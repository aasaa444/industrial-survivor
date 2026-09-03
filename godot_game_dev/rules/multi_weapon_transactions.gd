class_name DshMultiWeaponTransactions
extends RefCounted

const SCHEMA_VERSION := "multi-attack-v1"

static func empty_state(run_id: int = 0) -> Dictionary:
	return {
		"schema_version": SCHEMA_VERSION,
		"run_id": run_id,
		"attacks": {},
		"attack_order": [],
		"death_ledger": {},
		"reset_epoch": 0,
	}

static func clone(state: Dictionary) -> Dictionary:
	return state.duplicate(true)

static func _event_identity(attack: Dictionary) -> Dictionary:
	return {
		"attack_id": String(attack.get("attack_id", "")),
		"slot_id": String(attack.get("slot_id", "")),
		"weapon_id": String(attack.get("weapon_id", "")),
		"rank": int(attack.get("rank", 1)),
	}

static func _with_identity(event: Dictionary, attack: Dictionary) -> Dictionary:
	var out := event.duplicate(true)
	var identity := _event_identity(attack)
	for key in identity:
		out[key] = identity[key]
	return out

static func due_slot_order(slots: Array, tick: int) -> Array:
	var due: Array = []
	for raw in slots:
		if int(raw.get("next_fire_tick", 0)) <= tick:
			due.append(raw.duplicate(true))
	due.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var ao := int(a.get("slot_order", 0))
		var bo := int(b.get("slot_order", 0))
		if ao != bo:
			return ao < bo
		return String(a.get("slot_id", "")) < String(b.get("slot_id", ""))
	)
	return due

static func begin_attack(state: Dictionary, attack_id: String, slot_id: String, weapon_id: String, rank: int, delivery: String, max_targets: int, tick: int, live_candidates: Array) -> Dictionary:
	var next := clone(state)
	var attack_key := attack_id
	if attack_key.is_empty():
		return {"accepted": false, "state": next, "events": [{"type": "attack_rejected", "reason": "missing_attack_id"}]}
	if next["attacks"].has(attack_key):
		return {"accepted": false, "state": next, "events": [{"type": "attack_rejected", "attack_id": attack_key, "reason": "duplicate_attack_id"}]}
	var ordered: Array = []
	for raw in live_candidates:
		if bool(raw.get("alive", true)):
			ordered.append(raw.duplicate(true))
	ordered.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
			var a1 := int(a.get("k1_bucket", 0)); var b1 := int(b.get("k1_bucket", 0))
			if a1 != b1: return a1 < b1
			var a2 := int(a.get("k2_bucket", 0)); var b2 := int(b.get("k2_bucket", 0))
			if a2 != b2: return a2 < b2
			return int(a.get("stable_id", 0)) < int(b.get("stable_id", 0))
	)
	var snapshot: Array = []
	for candidate in ordered:
		snapshot.append(int(candidate.get("stable_id", -1)))
	var attack := {
		"attack_id": attack_key,
		"slot_id": slot_id,
		"weapon_id": weapon_id,
		"rank": rank,
		"delivery": delivery if delivery == "arc_chain" else "direct",
		"max_targets": maxi(1, max_targets),
		"refresh_tick": tick,
		"target_snapshot_ids": snapshot,
		"resolved": false,
		"hit_results": {},
		"resolution_outcomes": {},
		"kill_outcomes": {},
		"trace": [],
	}
	next["attacks"][attack_key] = attack
	next["attack_order"].append(attack_key)
	var refresh_event := {"type": "attack_refresh", "tick": tick, "target_snapshot_ids": snapshot.duplicate(true)}
	return {"accepted": true, "state": next, "attack": attack, "events": [_with_identity(refresh_event, attack)]}

static func resolve_attack(state: Dictionary, attack_id: String, tick: int, live_candidates: Array, attack_damage: int = 1) -> Dictionary:
	var next := clone(state)
	var attack: Dictionary = next["attacks"].get(attack_id, {}).duplicate(true)
	if attack.is_empty():
		return {"accepted": false, "state": next, "events": [{"type": "attack_rejected", "attack_id": attack_id, "reason": "unknown_attack"}]}
	if bool(attack.get("resolved", false)):
		return {"accepted": false, "state": next, "events": [{"type": "attack_rejected", "attack_id": attack_id, "reason": "already_resolved"}]}
	var live_by_id := {}
	for raw in live_candidates:
		live_by_id[int(raw.get("stable_id", -1))] = raw
	var invalid := {}
	var hit_count := 0
	var previous_id := -1
	var chain_started := false
	var damage := maxi(1, attack_damage)
	var events: Array = []
	for sid_raw in attack.get("target_snapshot_ids", []):
		var sid := int(sid_raw)
		var candidate: Dictionary = live_by_id.get(sid, {})
		var dead := bool(next["death_ledger"].get(sid, false)) or candidate.is_empty() or not bool(candidate.get("alive", true))
		if dead:
			invalid[sid] = true
			attack["resolution_outcomes"][sid] = "no-hit-invalid"
			var invalid_event := _with_identity({"type": "resolution_outcome", "outcome": "no-hit-invalid", "tick": tick, "id": sid}, attack)

			events.append(invalid_event)
			if String(attack.get("delivery", "direct")) == "arc_chain" and not chain_started:
				break
			continue
		if hit_count >= int(attack.get("max_targets", 1)):
			break
		hit_count += 1
		attack["resolution_outcomes"][sid] = "hit"
		attack["hit_results"][sid] = true
		var hit_event := _with_identity({"type": "resolution_outcome", "outcome": "hit", "tick": tick, "id": sid}, attack)
		if String(attack.get("delivery", "direct")) == "arc_chain":
			hit_event["hop"] = hit_count - 1
			hit_event["source_id"] = previous_id
			attack["trace"].append(_with_identity({"id": sid, "hop": hit_count - 1, "source_id": previous_id}, attack))
			chain_started = true
			previous_id = sid
		events.append(hit_event)
		var hp := int(candidate.get("hp", 1)) - damage
		candidate["hp"] = hp
		if hp <= 0:
			candidate["alive"] = false
			next["death_ledger"][sid] = true
			attack["kill_outcomes"][sid] = true
			events.append(_with_identity({"type": "kill_event", "tick": tick, "id": sid}, attack))

	attack["resolved"] = true
	next["attacks"][attack_id] = attack
	var projected_candidates: Array = []
	for raw in live_candidates:
		var stable_id: int = int(raw.get("stable_id", -1))
		var projected_candidate: Dictionary = raw.duplicate(true)
		if live_by_id.has(stable_id):
			projected_candidate = live_by_id[stable_id].duplicate(true)
		projected_candidates.append(projected_candidate)
	return {"accepted": true, "state": next, "attack": attack, "events": events, "live_candidates": projected_candidates}

static func reset(state: Dictionary, run_id: int) -> Dictionary:
	var next := empty_state(run_id)
	next["reset_epoch"] = int(state.get("reset_epoch", 0)) + 1
	return next
