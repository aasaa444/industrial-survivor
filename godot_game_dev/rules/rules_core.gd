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
# Guidance references:
#   DC_SYS_01_TECH_INPUT §2.2   total-order key chain k1/k2/stable_id; quantize to fixed-scale integer buckets;
#                               sort a derived immutable copy; never sort an engine/live container in place.
#   PROPOSALS_CR002_004_005     M-1 discrete two-scalar key chain; cr-004 (ii) snapshot-authoritative drain + no-hit on invalid;
#                               cr-005 quiet-cycle no-target branch fields (rule-side; presentation is a later task).
#   NEXT_IMPL_UNIT_PLAN S2       kill path as thin deterministic pure logic; KILL-single / KILL-multi / KILL-death-removal.
class_name DshRulesCore
extends RefCounted

const CONFIG_VERSION: String = "rules-core-v2"

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


# --- Headless seam: step(domain_input_envelope, prior_state, tick) ---------------
# Returns {state, events, diagnostics}. `prior_state` is never mutated (clone-on-write).
# Envelope: {
#   "task": "refresh_fire" | "resolve",
#   "live_candidates": [candidate records] (adapter-normalized observations for refresh; optional `hp` per candidate,
#                       defaults to 1 so existing TARGET-* fixtures remain valid without an explicit hp field),
#   "removed_ids": [id, ...] (explicit domain events drained at this step's drain point),
#   "attack_damage": int (default 1; kill-path single-hit damage applied to each hit target during `resolve`,
#                         supplied by the caller/ledger as a parameter, NOT a hardcoded constant promoted),
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
	}

	# [a] Named drain point: drain invalidation/removal domain events at the start of this step's resolution boundary.
	for rid in envelope.get("removed_ids", []):
		var r: int = int(rid)
		state["invalidation_log"].append({"id": r, "tick": tick})
		events.append({"type": "invalidation_event", "id": r, "tick": tick})
		state["live_candidates"] = _filter_alive_ids(state["live_candidates"], r)

	var task: String = envelope.get("task", "none")
	var attack_damage: int = int(envelope.get("attack_damage", 1))
	if attack_damage < 1:
		attack_damage = 1

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

	# [h] Return a fresh (new_state, events, diagnostics); prior_state untouched.
	state["config_version"] = CONFIG_VERSION
	return {"state": state, "events": events, "diagnostics": diagnostics}
