class_name DshLoadoutState
extends RefCounted

const SCHEMA_VERSION := "loadout-v1"
const DEFAULT_MAX_SLOTS := 4
const MAX_RANK := 3

static func empty_loadout(run_id: int = 0, max_slots: int = DEFAULT_MAX_SLOTS) -> Dictionary:
	return {
		"schema_version": SCHEMA_VERSION,
		"run_id": run_id,
		"max_slots": maxi(1, max_slots),
		"slots": [],
		"pending_offers": [],
		"consumed_offer_ids": [],
		"next_slot_seq": 1,
		"next_offer_seq": 1,
	}

static func clone(loadout: Dictionary) -> Dictionary:
	return loadout.duplicate(true)

static func _slot_id(seq: int) -> String:
	return "slot-%03d" % seq

static func _offer_id(run_id: int, seq: int) -> String:
	return "r%d:o%d" % [run_id, seq]

static func _card_id(offer_id: String, card_index: int) -> String:
	return "%s:c%d" % [offer_id, card_index]

static func sorted_slots(loadout: Dictionary) -> Array:
	var slots: Array = []
	for raw in loadout.get("slots", []):
		slots.append(raw.duplicate(true))
	slots.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var ao := int(a.get("slot_order", 0))
		var bo := int(b.get("slot_order", 0))
		if ao != bo:
			return ao < bo
		return String(a.get("slot_id", "")) < String(b.get("slot_id", ""))
	)
	return slots

static func slot_for_id(loadout: Dictionary, slot_id: String) -> Dictionary:
	for raw in loadout.get("slots", []):
		if String(raw.get("slot_id", "")) == slot_id:
			return raw
	return {}

static func has_weapon(loadout: Dictionary, weapon_id: String) -> bool:
	for raw in loadout.get("slots", []):
		if String(raw.get("weapon_id", "")) == weapon_id:
			return true
	return false

static func create_offer(loadout: Dictionary, kind: String, weapon_id: String, target_slot_id: String = "", target_rank: int = 1, card_index: int = 0) -> Dictionary:
	var run_id := int(loadout.get("run_id", 0))
	var seq := int(loadout.get("next_offer_seq", 1))
	var offer_id := _offer_id(run_id, seq)
	return {
		"offer_id": offer_id,
		"card_id": _card_id(offer_id, card_index),
		"run_id": run_id,
		"kind": kind,
		"weapon_id": weapon_id,
		"target_slot_id": target_slot_id,
		"target_rank": target_rank,
	}

static func queue_offer(loadout: Dictionary, offer: Dictionary) -> Dictionary:
	var next := clone(loadout)
	var offer_copy := offer.duplicate(true)
	next["pending_offers"].append(offer_copy)
	next["next_offer_seq"] = int(next.get("next_offer_seq", 1)) + 1
	return next

static func _reject(loadout: Dictionary, offer: Dictionary, reason: String) -> Dictionary:
	return {
		"accepted": false,
		"state": clone(loadout),
		"event": {
			"type": "loadout_offer_rejected",
			"offer_id": String(offer.get("offer_id", "")),
			"card_id": String(offer.get("card_id", "")),
			"reason": reason,
		},
	}

static func apply_offer(loadout: Dictionary, offer: Dictionary) -> Dictionary:
	var next := clone(loadout)
	var offer_id := String(offer.get("offer_id", ""))
	var card_id := String(offer.get("card_id", ""))
	if String(offer.get("offer_id", "")).is_empty() or String(offer.get("card_id", "")).is_empty():
		return _reject(loadout, offer, "missing_identity")
	if int(offer.get("run_id", -1)) != int(loadout.get("run_id", 0)):
		return _reject(loadout, offer, "wrong_run")
	if next.get("consumed_offer_ids", []).has(offer_id) or next.get("consumed_offer_ids", []).has(card_id):
		return _reject(loadout, offer, "duplicate_offer")
	var pending: Dictionary = {}
	for raw in next.get("pending_offers", []):
		if String(raw.get("card_id", "")) == card_id or String(raw.get("offer_id", "")) == offer_id:
			pending = raw
			break
	if pending.is_empty():
		return _reject(loadout, offer, "stale_offer")
	if String(pending.get("kind", "")) != String(offer.get("kind", "")) or String(pending.get("weapon_id", "")) != String(offer.get("weapon_id", "")):
		return _reject(loadout, offer, "offer_mismatch")

	var kind := String(offer.get("kind", ""))
	var weapon_id := String(offer.get("weapon_id", ""))
	var target_slot_id := String(offer.get("target_slot_id", ""))
	var target_rank := int(offer.get("target_rank", 0))
	if kind == "add_weapon":
		if next.get("slots", []).size() >= int(next.get("max_slots", DEFAULT_MAX_SLOTS)):
			return _reject(loadout, offer, "slots_full")
		if has_weapon(next, weapon_id):
			return _reject(loadout, offer, "duplicate_weapon")
		if target_rank != 1 or not target_slot_id.is_empty():
			return _reject(loadout, offer, "invalid_add_target")
		var slot_seq := int(next.get("next_slot_seq", 1))
		next["slots"].append({
			"slot_id": _slot_id(slot_seq),
			"weapon_id": weapon_id,
			"rank": 1,
			"slot_order": next["slots"].size(),
			"next_fire_tick": 0,
			"next_attack_seq": 0,
		})
		next["next_slot_seq"] = slot_seq + 1
	elif kind == "upgrade_weapon":
		var slot := slot_for_id(next, target_slot_id)
		if slot.is_empty():
			return _reject(loadout, offer, "wrong_slot")
		if String(slot.get("weapon_id", "")) != weapon_id:
			return _reject(loadout, offer, "weapon_slot_mismatch")
		if target_rank != int(slot.get("rank", 0)) + 1 or target_rank > MAX_RANK:
			return _reject(loadout, offer, "invalid_rank")
		slot["rank"] = target_rank
	else:
		return _reject(loadout, offer, "unknown_kind")

	var remaining: Array = []
	for raw in next.get("pending_offers", []):
		if String(raw.get("card_id", "")) != card_id:
			remaining.append(raw)
	next["pending_offers"] = remaining
	next["consumed_offer_ids"].append(offer_id)
	next["consumed_offer_ids"].append(card_id)
	return {
		"accepted": true,
		"state": next,
		"event": {
			"type": "loadout_offer_applied",
			"offer_id": offer_id,
			"card_id": card_id,
			"kind": kind,
			"weapon_id": weapon_id,
			"target_slot_id": target_slot_id,
			"target_rank": target_rank,
		},
	}

static func reset(loadout: Dictionary, run_id: int) -> Dictionary:
	return empty_loadout(run_id, int(loadout.get("max_slots", DEFAULT_MAX_SLOTS)))
