class_name DshLoadoutCatalog
extends RefCounted

const CATALOG = preload("res://content/weapon_catalog.gd")

static func cooldown_for_rank(weapon_id: String, rank: int) -> int:
	var profile := CATALOG.rank_profile(weapon_id, rank)
	return maxi(1, int(profile.get("cooldown_ticks", 36)))

static func attack_profile(weapon_id: String, rank: int) -> Dictionary:
	var profile := CATALOG.rank_profile(weapon_id, rank)
	return {
		"weapon_id": weapon_id,
		"rank": clampi(rank, 1, 3),
		"cooldown_ticks": cooldown_for_rank(weapon_id, rank),
		"max_targets": maxi(1, int(profile.get("max_targets", 1))),
		"fan_arcs": maxi(1, int(profile.get("fan_arcs", 1))),
		"behavior_id": String(CATALOG.definition_for_id(weapon_id).get("behavior_id", "")),
	}
