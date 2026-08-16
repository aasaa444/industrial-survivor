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
# Division of labour (honest seam):
#   - "which target is locked / which target hit / whether it died / whether a contact was legal / how much life it
#     costs / when it re-arms" are answered ONLY by the rules core (DshRulesCore.step -> target_snapshot_ids /
#     hit_results / kill_outcomes / contact events / segments_lost). The adapter never invents these.
#   - The adapter only (1) maps raw input booleans into a domain input envelope, (2) maps engine entity observations
#     into adapter-normalized candidates (stable_id + position-derived integer buckets + alive + hp), (3) maps engine
#     overlap observations into contact observations, and (4) turns a rules step result into a small set of
#     engine-facing feedback commands.
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
static func make_envelope(
	task: String,
	live_candidates: Array,
	movement: Dictionary,
	attack_damage: int = 1,
	removed_ids: Array = [],
	contact_input: Array = [],
	contact_invulnerability_ticks: int = 30,
	contact_damage: int = 1
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
		"no_target": false,
	}
	# Lock indicator only when a non-empty snapshot was actually locked.
	if not target_snapshot_ids.is_empty():
		feedback["lock_target"] = target_snapshot_ids.duplicate(true)
	# Hit feedback strictly bound to hit_results.
	for id_raw in hit_results:
		feedback["hit"].append(int(id_raw))
	# Kill feedback strictly bound to kill_outcomes (a real death event).
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