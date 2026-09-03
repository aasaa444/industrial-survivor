class_name DshMultiWeaponAdapter
extends RefCounted

static func make_attack_envelope(
	task: String,
	attack_id: String,
	slot_id: String,
	weapon_id: String,
	rank: int,
	live_candidates: Array,
	delivery: String,
	max_targets: int,
	attack_damage: int = 1
) -> Dictionary:
	return {
		"task": task,
		"attack_id": attack_id,
		"slot_id": slot_id,
		"weapon_id": weapon_id,
		"rank": rank,
		"live_candidates": live_candidates.duplicate(true),
		"attack_delivery": delivery if delivery == "arc_chain" else "direct",
		"attack_max_targets": maxi(1, max_targets),
		"attack_damage": maxi(1, attack_damage),
	}

static func feedback_from_events(events: Array) -> Dictionary:
	var feedback := {
		"lock": [],
		"hit": [],
		"kill": [],
		"invalid": [],
		"trace": [],
	}
	for raw in events:
		var event: Dictionary = raw
		var identity := {
			"attack_id": str(event.get("attack_id", "")),
			"slot_id": str(event.get("slot_id", "")),
			"weapon_id": str(event.get("weapon_id", "")),
			"rank": int(event.get("rank", 1)),
		}
		var event_type := str(event.get("type", ""))
		if event_type == "attack_refresh":
			var lock := identity.duplicate(true)
			lock["target_snapshot_ids"] = event.get("target_snapshot_ids", []).duplicate(true)
			feedback["lock"].append(lock)
		elif event_type == "resolution_outcome":
			var outcome := identity.duplicate(true)
			outcome["id"] = int(event.get("id", -1))
			outcome["outcome"] = str(event.get("outcome", ""))
			if outcome["outcome"] == "hit":
				feedback["hit"].append(outcome)
				if event.has("hop"):
					var trace := outcome.duplicate(true)
					trace["hop"] = int(event.get("hop", -1))
					trace["source_id"] = int(event.get("source_id", -1))
					feedback["trace"].append(trace)
			else:
				feedback["invalid"].append(outcome)
		elif event_type == "kill_event":
			var kill := identity.duplicate(true)
			kill["id"] = int(event.get("id", -1))
			feedback["kill"].append(kill)
	return feedback
