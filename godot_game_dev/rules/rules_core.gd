# rules_core.gd
# Minimal deterministic target-semantics core (engine-free pure GDScript).
#
# Approved contracts implemented:
#   ADR-TECH-01  rules core seam (engine-free); ordered_candidates lives here, never in adapter/presentation.
#   ADR-TECH-02  purity: no wall-clock, no device, no scene tree, no UI, no global randomness.
#   ADR-TECH-03  determinism: total-order key chain; comparator uses only discrete integer buckets, never float equality.
#   ADR-TECH-04  target snapshot: pre-fire refresh -> M-1 stable-sort -> lock immutable snapshot; explicit no-target branch;
#                removed/invalid targets never produce a hit or a fabricated hit; per-shot resolution reads only the locked snapshot.
#   ADR-TECH-06  headless seam: step(domain_input_envelope, prior_state, tick) -> {state, events, diagnostics};
#                pure function ordered_candidates(state, params) -> ordered_ids (callable with no rendered scene).
#
# S2 kill-path extension (deterministic pure logic, this unit):
#   Enemy HP            - each live candidate carries an integer `hp` (default 1 unless supplied by the adapter/ledger).
#   Hit -> death        - `resolve` applies `attack_damage` (envelope parameter, default 1) to each locked snapshot ID that
#                         produced a `hit`; candidate hp is stepped down. When hp <= 0 the candidate is marked `alive=false`
#                         (death) and a `kill_event` + `kill_outcomes[id]=true` is recorded.
#   Death -> removal    - death is the deterministic "clean-shrink" signal: `ordered_candidates` already filters `alive==true`,
#                         so a dead candidate is naturally excluded from the next refresh's derived snapshot (no need to
#                         re-query a live entity). A killed target therefore never appears in a later locked target set and
#                         can never produce a ghost hit. This is consistent with the invalidation drain-point semantics (ii)
#                         in SEMANTICS_INVALIDATION_FINAL_v0_1.md: removed/invalid => no hit; death is the mechanism-legal
#                         removal that the adapter feeds forward on the next pre-fire refresh.
#
# R3 O5 (this unit, diagnostics-only, additive): the step() diagnostics read-only exports
#   candidate_key_trace    - ordered [{stable_id, k1_bucket, k2_bucket}] for the current live candidate set (M-1 key chain order),
#   kill_decision_trace    - [{stable_id, k1_bucket, k2_bucket, tick}] for every target killed by this shot (independent, read-only),
#   live_reduction_count   - number of live candidates reduced (kills) in this step.
# These are additive diagnostics; they do not change state/event semantics, ordering, or the kill path.
#
# C2 contact extension (this unit, C2 rules-core contact pure logic; NEXT_IMPL_UNIT_PLAN_v0_3 unit B):
#   The rules core receives adapter contact observations (`contact_input` = [{id}] of currently eligible overlapping
#   victims, translated from engine-side collision/overlap detection at the ADR-TECH-01 seam). It never owns engine
#   entities: it only classifies what it receives and emits domain events/state.
#   Model (deterministic, zero RNG, decision #4 "one legal contact = one damage event"):
#     eligible overlap (adapter input) -> legal contact judgement
#       -> exactly ONE contact_damage_event per step (+ segments_lost deducted once)
#       -> brief global contact invulnerability window (state.contact_invulnerable_until_tick)
#       -> the whole simultaneous overlapping set merges into that single event (re-arm required for the entire set)
#     re-arm        -> a rearm-required victim re-arms ONLY after it separates (no longer in the current overlap set);
#                      persistent overlap cannot repeat damage (CONTACT-overlap). Separation also ENDS the brief
#                      invulnerability window, so a future new contact after re-arm is legal (CONTACT-separate-rearm /
#                      C2 points: "分离后无敌结束、未来新接触可再触发"); removal during protection cleans state (CONTACT-removal).
#   life deduction semantics: contact damage deducts `segments_lost` (0..3 per the three life segments); defeat/terminal
#   arbitration is deferred (not this unit) — segments_lost is capped at 3 and no defeat/reset is triggered here.
#   All contact numbers (invulnerability ticks, damage per contact) are ENVELOPE PARAMETERS with candidate defaults,
#   never promoted rule constants (promotion_authority=User; NUMBERS NOT FROZEN).
class_name DshRulesCore
extends RefCounted

const CONFIG_VERSION: String = "rules-core-v3"

# A fresh, empty rules state. `live_candidates` is the current live observation set (adapter-normalized);
# the core never mutates it in place and always derives ordered_ids from an immutable copy.
static func empty_state() -> Dictionary:
	return {
		"config_version": CONFIG_VERSION,
		"live_candidates": [],
		"ordered_ids": [],
		"target_snapshot_ids": [],
		"no_target_branch": false,
		"refresh_tick": -1,
		"lock_tick": -1,
		"invalidation_log": [],       # [{id, tick}] explicit removals drained at a named drain point
		"hit_results": {},            # {id: true} for resolved valid hits
		"resolution_outcomes": {},    # {id: "hit" | "no-hit-invalid"}
		"kill_outcomes": {},          # {id: true} for targets that died in this shot (hp <= 0)
		"next_eligible_fire_tick": 0,
		# --- C2 contact state (rules-core owned; no engine entities) ---
		"segments_lost": 0,                     # life segments lost (0..3); defeat arbitration deferred (not this unit)
		"contact_invulnerable_until_tick": -1,  # global brief invulnerability window end (tick); -1 = not invulnerable
		"contact_rearm": {},                    # {victim_id: bool} - false = rearm required (needs separation); absent = armed
	}

# --- Pure quantization helper -------------------------------------------------
# Fixed-scale integer bucket for a distance. `scale` (bucket width denominator) is a ledger rule parameter
# supplied by the caller/fixture; it is NOT a hardcoded constant promoted here. No float equality is ever compared.
static func quantize_bucket(dist: float, scale: float) -> int:
	return int(floor(dist * scale))


# --- M-1 total-order comparator ------------------------------------------------
# Pure comparator over the discrete key chain (k1_bucket, k2_bucket, stable_id). Because k3 (stable_id) is globally
# unique, the chain is a strict total order: the sorted result is unique and independent of container/input order.
# No float comparison, no wall-clock, no engine state, no iteration count, no global randomness.
static func _key_less(a: Dictionary, b: Dictionary) -> bool:
	var a1: int = int(a["k1_bucket"])
	var b1: int = int(b["k1_bucket"])
	if a1 != b1:
		return a1 < b1
	var a2: int = int(a["k2_bucket"])
	var b2: int = int(b["k2_bucket"])
	if a2 != b2:
		return a2 < b2
	return int(a["stable_id"]) < int(b["stable_id"])


# --- Pure seam: ordered_candidates(state, params) -> ordered_ids ----------------
# Derives the total-order id list from the live candidate set on an immutable copy. Never sorts the caller's container.
# `params` is reserved for future scale/criteria adjustments without changing the seam signature.
# A candidate with `alive == false` (e.g. killed) is excluded here -> it is naturally kicked out on the next refresh
# (the deterministic "death -> removal / clean-shrink" of the kill path), so it can never be re-locked or ghost-hit.
static func ordered_candidates(state: Dictionary, _params: Dictionary = {}) -> Array:
	var live: Array = []
	for cand in state.get("live_candidates", []):
		if bool(cand.get("alive", true)):
			live.append(cand.duplicate(true))
	live.sort_custom(_key_less)
	var ids: Array = []
	for cand in live:
		ids.append(int(cand["stable_id"]))
	return ids


# --- Deep clone (immutable-copy discipline) -------------------------------------
static func _clone_input(value) -> Variant:
	if value is Dictionary:
		var out := {}
		for k in value:
			out[k] = _clone_input(value[k])
		return out
	elif value is Array:
		var out := []
		for item in value:
			out.append(_clone_input(item))
		return out
	else:
		return value


static func _filter_alive_ids(candidates: Array, removed_id: int) -> Array:
	var out: Array = []
	for cand in candidates:
		if int(cand.get("stable_id", -1)) != removed_id:
			out.append(cand)
	return out


# --- Look up a live candidate record by stable_id (returns null if absent). ------
static func _find_candidate(candidates: Array, sid: int) -> Dictionary:
	for cand in candidates:
		if int(cand.get("stable_id", -1)) == sid:
			return cand
	return {}


# --- R3 O5 read-only key-trace helpers (diagnostics only; never mutate state). ---
# Ordered [{stable_id, k1_bucket, k2_bucket}] for the given ordered id list (M-1 key chain order).
static func _key_trace_from_ids(state: Dictionary, ids: Array) -> Array:
	var out: Array = []
	for sid_raw in ids:
		var sid: int = int(sid_raw)
		var cand := _find_candidate(state.get("live_candidates", []), sid)
		if not cand.is_empty():
			out.append({
				"stable_id": sid,
				"k1_bucket": int(cand.get("k1_bucket", 0)),
				"k2_bucket": int(cand.get("k2_bucket", 0)),
			})
	return out


# Kill decision-key tuples for each killed id: [{stable_id, k1_bucket, k2_bucket, tick}].
# Key order follows the killed dict insertion order (snapshot order), which is deterministic.
static func _kill_decision_trace(state: Dictionary, killed: Dictionary, tick: int) -> Array:
	var out: Array = []
	for sid_raw in killed:
		var sid: int = int(sid_raw)
		var cand := _find_candidate(state.get("live_candidates", []), sid)
		out.append({
			"stable_id": sid,
			"k1_bucket": int(cand.get("k1_bucket", 0)),
			"k2_bucket": int(cand.get("k2_bucket", 0)),
			"tick": tick,
		})
	return out


# --- C2 pure contact evaluation (engine-free, deterministic, zero RNG) ----------
# See header contract comment. Adapter supplies `contact_input` = [{id}] of currently eligible overlapping victims.
#   [1] Re-arm pass: a rearm-required victim that is no longer overlapping re-arms (separation predicate satisfied).
#   [2] Legal contact pass: exactly ONE damage event per step; the whole simultaneous set merges into it (decision #4
#       recommended default: single contact damage + invulnerability swallowing; Nx stacking is an explicit unresolved
#       boundary reported by the CONTACT-simultaneous fixture, not implemented here).
# All values (invulnerability ticks, damage per contact) are envelope parameters with candidate defaults.
static func _apply_contact(state: Dictionary, envelope: Dictionary, events: Array, tick: int, diagnostics: Dictionary) -> void:
	var contact_input: Array = envelope.get("contact_input", [])
	var invuln_ticks: int = int(envelope.get("contact_invulnerability_ticks", 30))
	if invuln_ticks < 0:
		invuln_ticks = 0
	var damage: int = int(envelope.get("contact_damage", 1))
	if damage < 1:
		damage = 1

	# Current overlapping victim id set (deterministic input order).
	var in_contact: Dictionary = {}
	for item in contact_input:
		var cid: int = int(item.get("id", -1))
		if cid >= 0:
			in_contact[cid] = true

	# [1] Re-arm: a rearm-required victim that separated re-arms. Separation also ENDS the brief invulnerability
	# window (futile re-arm while still protected would block "separation -> future new contact legal", C2 points:
	# "分离后无敌结束、未来新接触可再触发").
	var rearm_keys: Array = state["contact_rearm"].keys()
	for rev_raw in rearm_keys:
		var rid: int = int(rev_raw)
		if not state["contact_rearm"][rid] and not in_contact.has(rid):
			state["contact_rearm"][rid] = true
			state["contact_invulnerable_until_tick"] = -1
			diagnostics["contact_rearmed"].append(rid)
			events.append({"type": "contact_rearm_event", "id": rid, "tick": tick})

	# [2] Legal contact: exactly one damage event per step.
	for item in contact_input:
		var cid: int = int(item.get("id", -1))
		if cid < 0:
			continue
		# Rearm required for this victim -> persistent overlap cannot repeat damage (CONTACT-overlap).
		if state["contact_rearm"].get(cid, true) == false:
			continue
		# Global invulnerability window -> no second damage during protection (decision #4).
		if tick < int(state.get("contact_invulnerable_until_tick", -1)):
			continue
		# Legal contact: exactly one damage event; the whole overlapping set merges into it.
		var segments_lost: int = int(state.get("segments_lost", 0)) + damage
		if segments_lost > 3:
			segments_lost = 3    # three life segments; defeat/terminal arbitration deferred (not this unit)
		state["segments_lost"] = segments_lost
		state["contact_invulnerable_until_tick"] = tick + invuln_ticks
		for mid in in_contact.keys():
			state["contact_rearm"][int(mid)] = false
		diagnostics["contact_damaged"].append(cid)
		events.append({"type": "contact_damage_event", "victim_id": cid, "segments_lost": segments_lost, "tick": tick})
		events.append({
			"type": "contact_invulnerable_event",
			"until_tick": int(state["contact_invulnerable_until_tick"]),
			"tick": tick,
		})
		break


# --- Headless seam: step(domain_input_envelope, prior_state, tick) ---------------
# Returns {state, events, diagnostics}. `prior_state` is never mutated (clone-on-write).
# Envelope: {
#   "task": "refresh_fire" | "resolve",
#   "live_candidates": [candidate records] (adapter-normalized observations for refresh; optional `hp` per candidate,
#                       defaults to 1 so existing TARGET-* fixtures remain valid without an explicit hp field),
#   "removed_ids": [id, ...] (explicit domain events drained at this step's drain point),
#   "attack_damage": int (default 1; kill-path single-hit damage applied to each hit target during `resolve`,
#                         supplied by the caller/ledger as a parameter, NOT a hardcoded constant promoted),
#   "contact_input": [{id}, ...] (C2: adapter contact observations of currently eligible overlapping victims),
#   "contact_invulnerability_ticks": int (C2 candidate default 30; envelope parameter, NOT frozen),
#   "contact_damage": int (C2 candidate default 1; envelope parameter, NOT frozen),
# }
static func step(envelope: Dictionary, prior_state: Dictionary, tick: int) -> Dictionary:
	var state: Dictionary = _clone_input(prior_state)
	var events: Array = []
	var diagnostics: Dictionary = {
		"tick": tick,
		"steps": [],
		"ordered_ids": [],
		"no_target_branch": false,
		"hit_results": {},
		"kill_outcomes": {},
		"next_eligible_fire_tick": state.get("next_eligible_fire_tick", 0),
		"candidate_key_trace": [],
		"kill_decision_trace": [],
		"live_reduction_count": 0,
		# --- C2 contact diagnostics (additive, read-only exports) ---
		"contact_damaged": [],
		"contact_rearmed": [],
		"segments_lost": 0,
	}

	# [a] Named drain point: drain invalidation/removal domain events at the start of this step's resolution boundary.
	for rid in envelope.get("removed_ids", []):
		var r: int = int(rid)
		state["invalidation_log"].append({"id": r, "tick": tick})
		events.append({"type": "invalidation_event", "id": r, "tick": tick})
		state["live_candidates"] = _filter_alive_ids(state["live_candidates"], r)
		# C2 CONTACT-removal: a contacted victim removed during protection cleans its rearm/contact state so a future
		# contact with a fresh/removed id re-arms normally (state cleanup, future re-arm behavior).
		state["contact_rearm"].erase(int(r))

	var task: String = envelope.get("task", "none")
	var attack_damage: int = int(envelope.get("attack_damage", 1))
	if attack_damage < 1:
		attack_damage = 1

	# C2 contact evaluation runs when the adapter supplies contact observations (independent of the attack task;
	# fixtures that do not pass contact_input are untouched - additive).
	if envelope.has("contact_input"):
		_apply_contact(state, envelope, events, tick, diagnostics)

	if task == "refresh_fire":
		diagnostics["steps"].append("refresh_fire")
		state["refresh_tick"] = tick
		# [b] Refresh candidate set from adapter-normalized live observations if provided.
		if envelope.has("live_candidates"):
			state["live_candidates"] = _clone_input(envelope["live_candidates"])
		# [c] Derive ordered_ids on an immutable copy (pure; M-1 key chain). Killed (alive=false) candidates are excluded,
		#     realizing the deterministic death -> removal clean-shrink at the next refresh.
		var ordered: Array = ordered_candidates(state)
		state["ordered_ids"] = ordered.duplicate(true)
		diagnostics["ordered_ids"] = ordered.duplicate(true)
		# [O5] Read-only candidate key trace in M-1 key-chain order (additive diagnostics only).
		diagnostics["candidate_key_trace"] = _key_trace_from_ids(state, ordered)
		# [d] Lock this shot's immutable snapshot after refresh.
		state["target_snapshot_ids"] = ordered.duplicate(true)
		state["lock_tick"] = tick
		if ordered.is_empty():
			# Explicit no-target branch: never fabricate a target, no lock indicator, quiet-cycle rule-side fields.
			state["no_target_branch"] = true
			diagnostics["no_target_branch"] = true
			state["next_eligible_fire_tick"] = tick + 1
			diagnostics["next_eligible_fire_tick"] = state["next_eligible_fire_tick"]
			events.append({
				"type": "no_target_branch",
				"tick": tick,
				"next_eligible_fire_tick": state["next_eligible_fire_tick"],
			})
		else:
			state["no_target_branch"] = false
			diagnostics["no_target_branch"] = false

	elif task == "resolve":
		# [f][g] Resolution reads ONLY the locked snapshot (no live re-query). Invalidated snapshot IDs produce no hit
		# (no fabricated hit). The immutable snapshot ID set is never changed by resolution.
		diagnostics["steps"].append("resolve")
		var invalid: Dictionary = {}
		for inv in state.get("invalidation_log", []):
			invalid[int(inv["id"])] = true
		var hit_map: Dictionary = {}
		var outcomes: Dictionary = {}
		var killed: Dictionary = {}
		for sid_raw in state.get("target_snapshot_ids", []):
			var sid: int = int(sid_raw)
			if invalid.has(sid):
				outcomes[sid] = "no-hit-invalid"
				events.append({"type": "resolution_outcome", "id": sid, "outcome": "no-hit-invalid", "tick": tick})
			else:
				outcomes[sid] = "hit"
				hit_map[sid] = true
				events.append({"type": "resolution_outcome", "id": sid, "outcome": "hit", "tick": tick})
				# [kill path] Apply single-hit damage to the live candidate, record death when hp <= 0.
				var cand: Dictionary = _find_candidate(state["live_candidates"], sid)
				if not cand.is_empty():
					var hp: int = int(cand.get("hp", 1))
					hp = hp - attack_damage
					cand["hp"] = hp
					if hp <= 0:
						# Deterministic death: flip `alive`, emit a kill_event, remember the kill outcome.
						# ordered_candidates excludes alive==false -> the next refresh naturally drops this target
						# (clean-shrink signal, consistent with the invalidation drain semantics (ii)).
						cand["alive"] = false
						cand["dead"] = true
						killed[sid] = true
						events.append({
							"type": "kill_event",
							"id": sid,
							"tick": tick,
							"hp_left": 0,
						})
		state["hit_results"] = hit_map
		state["resolution_outcomes"] = outcomes
		state["kill_outcomes"] = killed.duplicate(true)
		diagnostics["hit_results"] = hit_map.duplicate(true)
		diagnostics["kill_outcomes"] = killed.duplicate(true)
		# [O5] Additive diagnostics after resolution:
		#   - candidate key trace of the (post-kill) live set in M-1 key-chain order,
		#   - independent kill decision key tuples (k1/k2/stable_id buckets + tick),
		#   - live reduction (kill) count for this shot.
		diagnostics["candidate_key_trace"] = _key_trace_from_ids(state, ordered_candidates(state))
		if not killed.is_empty():
			diagnostics["kill_decision_trace"] = _kill_decision_trace(state, killed, tick)
			diagnostics["live_reduction_count"] = killed.size()

	# [h] Return a fresh (new_state, events, diagnostics); prior_state untouched.
	state["config_version"] = CONFIG_VERSION
	diagnostics["segments_lost"] = int(state.get("segments_lost", 0))
	return {"state": state, "events": events, "diagnostics": diagnostics}