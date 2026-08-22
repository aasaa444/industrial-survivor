extends GdUnitTestSuite

const ADAPTER = preload("res://adapter/multi_weapon_adapter.gd")
const CATALOG = preload("res://content/loadout_catalog.gd")

func test_identity_envelope_carries_attack_and_slot_identity() -> void:
	var env := ADAPTER.make_attack_envelope("refresh_fire", "r1:s002:a01", "slot-002", "arc_coil", 1, [], "arc_chain", 3)
	assert_str(String(env["attack_id"])).is_equal("r1:s002:a01")
	assert_str(String(env["slot_id"])).is_equal("slot-002")
	assert_str(String(env["weapon_id"])).is_equal("arc_coil")
	assert_int(int(env["rank"])).is_equal(1)
	assert_str(String(env["attack_delivery"])).is_equal("arc_chain")
	assert_int(int(env["attack_max_targets"])).is_equal(3)

func test_feedback_preserves_identity_and_does_not_infer_targets() -> void:
	var events := [
		{"type": "attack_refresh", "attack_id": "r2:s001:a01", "slot_id": "slot-001", "weapon_id": "rail_pierce", "rank": 2, "target_snapshot_ids": [4]},
		{"type": "resolution_outcome", "outcome": "hit", "id": 4, "attack_id": "r2:s001:a01", "slot_id": "slot-001", "weapon_id": "rail_pierce", "rank": 2},
	]
	var fb := ADAPTER.feedback_from_events(events)
	assert_int(fb["lock"].size()).is_equal(1)
	assert_str(String(fb["lock"][0]["attack_id"])).is_equal("r2:s001:a01")
	assert_array(fb["lock"][0]["target_snapshot_ids"]).is_equal([4])
	assert_int(fb["hit"].size()).is_equal(1)
	assert_str(String(fb["hit"][0]["slot_id"])).is_equal("slot-001")
	assert_array(fb["invalid"]).is_empty()

func test_arc_trace_feedback_has_identity_hop_and_source() -> void:
	var events := [
		{"type": "resolution_outcome", "outcome": "hit", "id": 4, "attack_id": "r3:s002:a01", "slot_id": "slot-002", "weapon_id": "arc_coil", "rank": 1, "hop": 0, "source_id": -1},
		{"type": "resolution_outcome", "outcome": "hit", "id": 5, "attack_id": "r3:s002:a01", "slot_id": "slot-002", "weapon_id": "arc_coil", "rank": 1, "hop": 1, "source_id": 4},
	]
	var trace: Array = ADAPTER.feedback_from_events(events)["trace"]
	assert_int(trace.size()).is_equal(2)
	assert_str(String(trace[0]["attack_id"])).is_equal("r3:s002:a01")
	assert_int(int(trace[0]["hop"])).is_equal(0)
	assert_int(int(trace[0]["source_id"])).is_equal(-1)
	assert_int(int(trace[1]["source_id"])).is_equal(4)

func test_catalog_cooldown_profiles_are_independent_by_weapon_and_rank() -> void:
	var rail := CATALOG.attack_profile("rail_pierce", 1)
	var arc := CATALOG.attack_profile("arc_coil", 1)
	assert_int(int(rail["cooldown_ticks"])).is_equal(36)
	assert_int(int(arc["cooldown_ticks"])).is_equal(48)
	assert_str(String(rail["behavior_id"])).is_equal("line_pierce")
	assert_str(String(arc["behavior_id"])).is_equal("arc_chain")
	assert_int(int(CATALOG.cooldown_for_rank("rail_pierce", 3))).is_equal(30)
