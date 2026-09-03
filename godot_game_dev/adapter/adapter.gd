# adapter.gd
# Adapter seam (S3): translates engine/input observations into a domain input envelope and routes domain outputs
# into engine-facing feedback, WITHOUT authoring any new rule semantics.
#
# Approved contracts implemented:
#   ADR-TECH-01  adapter translates engine/input/time into domain inputs and domain outputs into engine effects;
#                it must NOT silently add game rules (no target selection / ordering / hit judging happens here).
#   ADR-TECH-02  purity of the translation layer (no wall-clock / device polling in these pure helpers); the
#                presentation-facing feedback is bound to `hit_results` — an empty shot never fabricates a lock
#                indicator or a phantom hit (UX-03 S1/S2 / ADR-TECH-02 empty-shot non-forgery).
#   ADR-TECH-03  deterministic relay: identical inputs map to identical envelopes; no global randomness in the adapter.
#
# Input device contract (UX contract §4 / §7, PC-first keyboard):
#   WASD and arrow keys map to movement; no gamepad promise. Direction is output as a normalized integer axis vector.
#
# C4 contact seam (this unit, C4 adapter/运行时 contact; NEXT_IMPL_UNIT_PLAN_v0_3 unit B):
#   - The engine detects overlap (AABB/collision) at the ADR-TECH-01 seam; the adapter translates that observation
#     into the domain contact input the rules core consumes: `contact_observations(overlaps) -> [{id}]`.
#   - `make_envelope` carries the contact observations + contact parameter candidates into the domain envelope
#     (contact_input / contact_invulnerability_ticks / contact_damage).
#   - `contact_feedback_from_result` routes contact domain events into engine-facing contact feedback classes,
#     bound strictly to the rule events (contact_damage_event / contact_rearm_event / contact_invulnerable_event);
#     no contact feedback is fabricated when no contact event exists.
#   The adapter never decides contact legality, damage amount, or re-arm semantics — those live in the rules core.
#
# T4 terminal seam (this unit, T4 adapter/运行时 结局仲裁·呈现·立即重试; NEXT_IMPL_UNIT_PLAN_v0_4 unit 4):
#   - `make_envelope` carries a `terminal_input` (session domain input: {timer_completed: bool} for the eight-minute
#     completion) through the domain envelope so the rules core can arbitrate terminal same-frame with life depletion.
#   - `terminal_feedback_from_result` translates the terminal DOMAIN outcomes (terminal_event / reset_event) into
#     engine-facing RESULT presentation fields, bound strictly to those rule events:
#       terminal_fired / outcome ("victory"|"defeat") only when a terminal_event fired this step;
#       reset_fired / reset_epoch only when a reset_event fired.
#   The adapter never decides victory/defeat — that is the rules core. It only translates the already-decided outcome.
#
# B4 upgrade seam (this unit, B4 adapter/运行时 B2升级; M1 B2):
#   - `make_envelope` carries `task=="upgrade_select"` + `selected_card_id` through the domain envelope so the
#     rules core can apply the upgrade effect.
#   - `upgrade_feedback_from_result` translates the upgrade DOMAIN events (upgrade_event) into engine-facing
#     upgrade feedback fields, bound strictly to the rule events:
#       upgrade_fired / phase / selected_card_id / attack_max_targets / attack_fan_arcs.
#   The adapter never decides upgrade effects — that is the rules core.
#
# Division of labour (honest seam):
#   - "which target is locked / which target hit / whether it died / whether a contact was legal / how much life it
#     costs / when it re-arms / whether the run reached victory/defeat" are answered ONLY by the rules core
#     (DshRulesCore.step -> target_snapshot_ids / hit_results / kill_outcomes / contact events / segments_lost /
#     terminal_outcome). The adapter never invents these.
#   - The adapter only (1) maps raw input booleans into a domain input envelope, (2) maps engine entity observations
#     into adapter-normalized candidates (stable_id + position-derived integer buckets + alive + hp), (3) maps engine
#     overlap observations into contact observations, (4) carries the session's terminal domain input, and (5) turns a
#     rules step result into a small set of engine-facing feedback commands.
class_name DshAdapter
extends RefCounted

const RULES = preload("res://rules/rules_core.gd")
const K1_SCALE: float = 1.0   # bucket denominator for nearest-threat distance (ledger/scale parameter, not frozen rule)
const K2_SCALE: float = 1.0   # bucket denominator for cluster-center distance (ledger/scale parameter, not frozen rule)

# --- Pure input -> movement ------------------------------------------------
# input_state: {w,a,s,d,up,left,down,right: bool}. Returns a normalized integer-axis direction plus a "moved" flag.
# Pure map: identical booleans yield an identical direction; no engine polling, no wall-clock.
static func movement_from_input(input_state: Dictionary) -> Dictionary:
	var x := 0
	var y := 0
	if bool(input_state.get("left", false)) or bool(input_state.get("a", false)):
		x -= 1
	if bool(input_state.get("right", false)) or bool(input_state.get("d", false)):
		x += 1
	if bool(input_state.get("up", false)) or bool(input_state.get("w", false)):
		y -= 1
	if bool(input_state.get("down", false)) or bool(input_state.get("s", false)):
		y += 1
	# Diagonal normalization on the integer axis (1/0), not continuous length — a pure, deterministic step.
	return {"dir_x": x, "dir_y": y, "moved": (x != 0 or y != 0)}


# --- Pure engine-entity -> adapter-normalized candidate -----------------------
# Builds one candidate record (as the rules core expects) from a stable_id and positions.
#   k1_bucket = nearest-threat( player->enemy ) distance bucket     (M-1 key chain first key)
#   k2_bucket = cluster-center distance bucket                      (M-1 key chain second key)
# `scale` is the ledger parameter for quantization; it is NOT a frozen rule constant.
static func candidate_from_observation(
	stable_id: int,
	enemy_pos: Vector2,
	player_pos: Vector2,
	cluster_center: Vector2,
	hp: int = 1,
	scale: float = K1_SCALE
) -> Dictionary:
	var threat_dist: float = enemy_pos.distance_to(player_pos)
	var cluster_dist: float = enemy_pos.distance_to(cluster_center)
	return {
		"stable_id": stable_id,
		"k1_bucket": RULES.quantize_bucket(threat_dist, scale),
		"k2_bucket": RULES.quantize_bucket(cluster_dist, scale),
		"alive": true,
		"hp": hp,
	}


# --- Pure engine-overlap -> domain contact observations (C4) ------------------
# `overlaps`: [{id, overlapping: bool}] produced by the engine's AABB/collision detection at the ADR-TECH-01 seam.
# Returns the domain contact input the rules core consumes: [{id}] for every currently eligible overlapping victim.
# Pure translation: the adapter does not judge legality, damage, or re-arm — that is the rules core's job.
static func contact_observations(overlaps: Array) -> Array:
	var out: Array = []
	for o in overlaps:
		if bool(o.get("overlapping", false)):
			out.append({"id": int(o.get("id", -1))})
	return out


# --- Pure route: task selector for the domain envelope -------------------------
# Chooses which rules task the engine should drive this step: 'refresh_fire' when it is time to pre-fire refresh
# and lock a new snapshot, otherwise 'resolve'. This picks a *task name only*; it does not choose targets.
# `locked_this_epoch` is a boolean the engine maintains (whether this fire epoch already locked). Pure and deterministic.
static func pick_task(force_refresh: bool, locked_this_epoch: bool) -> String:
	if force_refresh or not locked_this_epoch:
		return "refresh_fire"
	return "resolve"


# --- Pure build of the domain input envelope ----------------------------------
# Combines movement intent and a rules task into the domain input envelope accepted by DshRulesCore.step.
# `task` and `live_candidates` come from the caller (the engine loop). The adapter only assembles/delegates;
# it never decides ordering or hit legality.
# C4: `contact_input` (domain contact observations, may be empty so separation/re-arm is evaluated each step) and
# contact parameter candidates (invulnerability ticks / damage) ride the same envelope. All values are candidate
# defaults, never promoted rule constants.
# T4: `terminal_input` (session domain input, default empty; {timer_completed: bool}) rides so the rules core can
# arbitrate the eight-minute completion same-frame with life depletion.
static func make_envelope(
	task: String,
	live_candidates: Array,
	movement: Dictionary,
	attack_damage: int = 1,
	removed_ids: Array = [],
	contact_input: Array = [],
	contact_invulnerability_ticks: int = 30,
	contact_damage: int = 1,
	terminal_input: Dictionary = {},
	selected_card_id: int = -1,
	attack_max_targets: int = -1,
	attack_delivery: String = "direct"
) -> Dictionary:
	var env: Dictionary = {
		"task": task,
		"live_candidates": live_candidates.duplicate(true),
		"attack_damage": attack_damage,
		"movement": {
			"dir_x": int(movement.get("dir_x", 0)),
			"dir_y": int(movement.get("dir_y", 0)),
			"moved": bool(movement.get("moved", false)),
		},
		# C4: contact observations always carried (empty included) so separation/re-arm can be evaluated every step.
		"contact_input": contact_input.duplicate(true),
		"contact_invulnerability_ticks": int(contact_invulnerability_ticks),
		"contact_damage": int(contact_damage),
	}
	if not removed_ids.is_empty():
		env["removed_ids"] = removed_ids.duplicate(true)
	# T4: session domain input for the terminal (timer completion); empty default keeps additive compatibility.
	env["terminal_input"] = terminal_input.duplicate(true)
	# B4: upgrade selection (task=="upgrade_select" + selected_card_id); additive, only carried when set.
	if selected_card_id >= 0:
		env["selected_card_id"] = selected_card_id
	# B4: attack_max_targets envelope override for backward-compatible test fixtures (default -1 = use state value).
	if attack_max_targets >= 0:
		env["attack_max_targets"] = attack_max_targets
	env["attack_delivery"] = attack_delivery if attack_delivery == "arc_chain" else "direct"
	return env


# --- Pure route: rules step result -> engine-facing feedback commands ----------
# Feedback classes are emitted ONLY when their rule source is present:
#   - "lock_target": emitted when target_snapshot_ids is non-empty (a target was actually locked this shot).
#   - "hit": emitted per id only when hit_results contains that id (bound to hit_results; no fabricated hit).
#   - "kill": emitted per id only when kill_outcomes contains that id (death feedback bound to a real kill event).
#   - "no_target": optional non-color quiet cue for an empty shot — emitted ONLY when no_target_branch is true and
#     target_snapshot_ids is empty; it NEVER produces a lock indicator or a phantom hit (ADR-TECH-02 / UX-03 S2).
# The adapter adds no ordering, no target selection and no hit judgement.
static func feedback_from_result(result: Dictionary) -> Dictionary:
	var state: Dictionary = result.get("state", {})
	var target_snapshot_ids: Array = state.get("target_snapshot_ids", [])
	var hit_results: Dictionary = state.get("hit_results", {})
	var kill_outcomes: Dictionary = state.get("kill_outcomes", {})
	var no_target_branch: bool = bool(state.get("no_target_branch", false))

	var feedback: Dictionary = {
		"lock_target": [],
		"hit": [],
		"kill": [],
		"hit_trace": [],
		"no_target": false,
	}
	# Lock indicator only when a non-empty snapshot was actually locked.
	if not target_snapshot_ids.is_empty():
		feedback["lock_target"] = target_snapshot_ids.duplicate(true)
	# Hit feedback strictly bound to hit_results.
	for id_raw in hit_results:
		feedback["hit"].append(int(id_raw))
	# Arc chain trace is bound strictly to ordered rules events; adapter does not infer hops.
	for event in result.get("events", []):
		if String(event.get("type", "")) == "resolution_outcome" and String(event.get("outcome", "")) == "hit" and String(event.get("delivery", "")) == "arc_chain":
			feedback["hit_trace"].append({"id": int(event.get("id", -1)), "hop": int(event.get("hop", -1)), "source_id": int(event.get("source_id", -1))})
	# Kill feedback strictly bound to kill_outcomes.
	for id_raw in kill_outcomes:
		feedback["kill"].append(int(id_raw))
	# Quiet no-target cue only for an empty shot (no fabricated lock/hit).
	feedback["no_target"] = no_target_branch and target_snapshot_ids.is_empty()
	return feedback


# --- Pure route: contact domain events -> engine-facing contact feedback (C4) --
# Contact feedback classes are bound strictly to the rules contact events in the step result:
#   - "damage": [{victim_id, segments_lost}] only for real contact_damage_event(s).
#   - "invulnerable": true only when a contact_invulnerable_event fired this step.
#   - "rearm": [ids] only for real contact_rearm_event(s).
# No contact feedback is fabricated when no contact event exists (empty-shot / no-contact quiet discipline).
static func contact_feedback_from_result(result: Dictionary) -> Dictionary:
	var events: Array = result.get("events", [])
	var feedback: Dictionary = {"damage": [], "invulnerable": false, "rearm": []}
	for e in events:
		var etype: String = e.get("type", "")
		if etype == "contact_damage_event":
			feedback["damage"].append({
				"victim_id": int(e.get("victim_id", -1)),
				"segments_lost": int(e.get("segments_lost", 0)),
			})
		elif etype == "contact_invulnerable_event":
			feedback["invulnerable"] = true
		elif etype == "contact_rearm_event":
			feedback["rearm"].append(int(e.get("id", -1)))
	return feedback


# --- Pure route: terminal domain events -> RESULT presentation fields (T4) -----
# Translates the terminal DOMAIN outcomes into engine-facing RESULT presentation, bound STRICTLY to the terminal
# rule events:
#   - "terminal_fired": true only when a terminal_event fired this step.
#   - "outcome": "victory" | "defeat" — the already-decided terminal outcome (the adapter never decides victory/defeat).
#   - "result_locked": state.result_locked (the result/input lock the presentation must respect while it shows the result).
#   - "reset_fired": true only when a reset_event fired this step.
#   - "reset_epoch": the new reset_epoch carried by the reset_event (or -1 if none).
# No RESULT presentation is fabricated when no terminal/reset event exists (quiet discipline).
static func terminal_feedback_from_result(result: Dictionary) -> Dictionary:
	var events: Array = result.get("events", [])
	var state: Dictionary = result.get("state", {})
	var feedback: Dictionary = {
		"terminal_fired": false,
		"outcome": "",
		"result_locked": bool(state.get("result_locked", false)),
		"reset_fired": false,
		"reset_epoch": -1,
	}
	for e in events:
		var etype: String = e.get("type", "")
		if etype == "terminal_event":
			feedback["terminal_fired"] = true
			feedback["outcome"] = String(e.get("outcome", ""))
		elif etype == "reset_event":
			feedback["reset_fired"] = true
			feedback["reset_epoch"] = int(e.get("reset_epoch", -1))
	return feedback


# --- Pure route: upgrade domain events -> engine-facing upgrade feedback (B4) --
# Translates the upgrade DOMAIN events into engine-facing upgrade feedback, bound STRICTLY to the upgrade rule events:
#   - "upgrade_fired": true only when an upgrade_event fired this step.
#   - "phase": "pierce" | "fan" — the phase that was applied.
#   - "selected_card_id": the card id the player selected.
#   - "attack_max_targets": the new attack_max_targets value after the upgrade.
#   - "attack_fan_arcs": the new attack_fan_arcs value after the upgrade.
# No upgrade feedback is fabricated when no upgrade event exists (quiet discipline).
static func upgrade_feedback_from_result(result: Dictionary) -> Dictionary:
	var events: Array = result.get("events", [])
	var feedback: Dictionary = {
		"upgrade_fired": false,
		"phase": "",
		"selected_card_id": -1,
		"attack_max_targets": 1,
		"attack_fan_arcs": 1,
	}
	for e in events:
		var etype: String = e.get("type", "")
		if etype == "upgrade_event":
			feedback["upgrade_fired"] = true
			feedback["phase"] = String(e.get("phase", ""))
			feedback["selected_card_id"] = int(e.get("selected_card_id", -1))
			feedback["attack_max_targets"] = int(e.get("attack_max_targets", 1))
			feedback["attack_fan_arcs"] = int(e.get("attack_fan_arcs", 1))
	return feedback
