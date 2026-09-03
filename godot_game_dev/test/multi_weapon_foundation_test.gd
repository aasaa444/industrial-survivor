extends GdUnitTestSuite

const LOADOUT = preload("res://rules/loadout_state.gd")
const ATTACKS = preload("res://rules/multi_weapon_transactions.gd")

func _add_offer(loadout: Dictionary, kind: String, weapon_id: String, slot_id: String = "", rank: int = 1, index: int = 0) -> Dictionary:
	var offer := LOADOUT.create_offer(loadout, kind, weapon_id, slot_id, rank, index)
	return LOADOUT.queue_offer(loadout, offer)

func test_loadout_v1_add_weapon_preserves_existing_slot() -> void:
	var state := LOADOUT.empty_loadout(7)
	state = _add_offer(state, "add_weapon", "rail_pierce", "", 1, 0)
	var rail_offer: Dictionary = state["pending_offers"][0]
	var rail_result: Dictionary = LOADOUT.apply_offer(state, rail_offer)
	assert_bool(rail_result["accepted"]).is_true()
	var with_rail: Dictionary = rail_result["state"]
	state = _add_offer(with_rail, "add_weapon", "arc_coil", "", 1, 0)
	var arc_offer: Dictionary = state["pending_offers"][0]
	var arc_result: Dictionary = LOADOUT.apply_offer(state, arc_offer)
	assert_bool(arc_result["accepted"]).is_true()
	var slots: Array = LOADOUT.sorted_slots(arc_result["state"])
	assert_int(slots.size()).is_equal(2)
	assert_str(String(slots[0]["slot_id"])).is_equal("slot-001")
	assert_str(String(slots[0]["weapon_id"])).is_equal("rail_pierce")
	assert_str(String(slots[1]["slot_id"])).is_equal("slot-002")
	assert_str(String(slots[1]["weapon_id"])).is_equal("arc_coil")

func test_loadout_upgrade_changes_only_target_slot() -> void:
	var state := LOADOUT.empty_loadout(8)
	state = _add_offer(state, "add_weapon", "rail_pierce")
	var rail := LOADOUT.apply_offer(state, state["pending_offers"][0])
	state = _add_offer(rail["state"], "add_weapon", "arc_coil")
	var arc := LOADOUT.apply_offer(state, state["pending_offers"][0])
	state = _add_offer(arc["state"], "upgrade_weapon", "rail_pierce", "slot-001", 2)
	var result := LOADOUT.apply_offer(state, state["pending_offers"][0])
	assert_bool(result["accepted"]).is_true()
	var slots: Array = LOADOUT.sorted_slots(result["state"])
	assert_int(int(slots[0]["rank"])).is_equal(2)
	assert_int(int(slots[1]["rank"])).is_equal(1)
	assert_int(int(slots[1]["next_attack_seq"])).is_equal(0)

func test_loadout_rejects_duplicate_stale_wrong_run_and_wrong_slot() -> void:
	var state := LOADOUT.empty_loadout(9)
	state = _add_offer(state, "add_weapon", "rail_pierce")
	var offer: Dictionary = state["pending_offers"][0]
	var applied := LOADOUT.apply_offer(state, offer)
	var duplicate := LOADOUT.apply_offer(applied["state"], offer)
	assert_bool(duplicate["accepted"]).is_false()
	assert_str(String(duplicate["event"]["reason"])).is_equal("duplicate_offer")
	var stale := LOADOUT.apply_offer(applied["state"], {"offer_id": "r9:o999", "card_id": "r9:o999:c0", "run_id": 9, "kind": "add_weapon", "weapon_id": "arc_coil", "target_rank": 1})
	assert_bool(stale["accepted"]).is_false()
	assert_str(String(stale["event"]["reason"])).is_equal("stale_offer")
	var wrong_run_state := _add_offer(applied["state"], "add_weapon", "arc_coil")
	var wrong_run_offer: Dictionary = wrong_run_state["pending_offers"][0].duplicate(true)
	wrong_run_offer["run_id"] = 99
	var wrong_run := LOADOUT.apply_offer(wrong_run_state, wrong_run_offer)
	assert_bool(wrong_run["accepted"]).is_false()
	assert_str(String(wrong_run["event"]["reason"])).is_equal("wrong_run")
	var wrong_slot_state := _add_offer(applied["state"], "upgrade_weapon", "rail_pierce", "slot-999", 2)
	var wrong_slot := LOADOUT.apply_offer(wrong_slot_state, wrong_slot_state["pending_offers"][0])
	assert_bool(wrong_slot["accepted"]).is_false()
	assert_str(String(wrong_slot["event"]["reason"])).is_equal("wrong_slot")

func test_due_slots_sort_by_slot_order_then_slot_id() -> void:
	var due := ATTACKS.due_slot_order([
		{"slot_id": "slot-002", "slot_order": 1, "next_fire_tick": 4},
		{"slot_id": "slot-001", "slot_order": 0, "next_fire_tick": 4},
		{"slot_id": "slot-003", "slot_order": 2, "next_fire_tick": 9},
	], 4)
	assert_array(due.map(func(slot): return slot["slot_id"])).is_equal(["slot-001", "slot-002"])

func test_two_attacks_have_independent_identity_and_snapshots() -> void:
	var state := ATTACKS.empty_state(11)
	var candidates := [
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 2},
		{"stable_id": 2, "k1_bucket": 1, "k2_bucket": 0, "alive": true, "hp": 2},
	]
	var rail := ATTACKS.begin_attack(state, "r11:s001:a01", "slot-001", "rail_pierce", 1, "direct", 1, 20, candidates)
	var arc := ATTACKS.begin_attack(rail["state"], "r11:s002:a01", "slot-002", "arc_coil", 1, "arc_chain", 2, 20, candidates)
	assert_bool(rail["accepted"]).is_true()
	assert_bool(arc["accepted"]).is_true()
	assert_array(arc["state"]["attack_order"]).is_equal(["r11:s001:a01", "r11:s002:a01"])
	assert_str(String(arc["state"]["attacks"]["r11:s001:a01"]["slot_id"])).is_equal("slot-001")
	assert_str(String(arc["state"]["attacks"]["r11:s002:a01"]["weapon_id"])).is_equal("arc_coil")
	assert_array(arc["state"]["attacks"]["r11:s001:a01"]["target_snapshot_ids"]).is_equal([1, 2])
	assert_array(arc["state"]["attacks"]["r11:s002:a01"]["target_snapshot_ids"]).is_equal([1, 2])

func test_cross_attack_death_is_invalid_no_hit() -> void:
	var state := ATTACKS.empty_state(12)
	var candidates := [{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 1}]
	var first := ATTACKS.begin_attack(state, "r12:s001:a01", "slot-001", "rail_pierce", 1, "direct", 1, 30, candidates)
	var second := ATTACKS.begin_attack(first["state"], "r12:s002:a01", "slot-002", "arc_coil", 1, "arc_chain", 1, 30, candidates)
	var first_resolve := ATTACKS.resolve_attack(second["state"], "r12:s001:a01", 31, candidates)
	var second_resolve := ATTACKS.resolve_attack(first_resolve["state"], "r12:s002:a01", 31, candidates)
	assert_bool(first_resolve["accepted"]).is_true()
	assert_bool(second_resolve["accepted"]).is_true()
	var second_attack: Dictionary = second_resolve["state"]["attacks"]["r12:s002:a01"]
	assert_bool(second_attack["hit_results"].is_empty()).is_true()
	assert_str(String(second_attack["resolution_outcomes"][1])).is_equal("no-hit-invalid")
	assert_bool(second_attack["kill_outcomes"].is_empty()).is_true()

func test_arc_trace_carries_identity_and_source_chain() -> void:
	var state := ATTACKS.empty_state(13)
	var candidates := [
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 3},
		{"stable_id": 2, "k1_bucket": 1, "k2_bucket": 0, "alive": true, "hp": 3},
	]
	var begun := ATTACKS.begin_attack(state, "r13:s002:a01", "slot-002", "arc_coil", 1, "arc_chain", 2, 40, candidates)
	var resolved := ATTACKS.resolve_attack(begun["state"], "r13:s002:a01", 41, candidates)
	var trace: Array = resolved["state"]["attacks"]["r13:s002:a01"]["trace"]
	assert_int(trace.size()).is_equal(2)
	assert_str(String(trace[0]["attack_id"])).is_equal("r13:s002:a01")
	assert_str(String(trace[0]["slot_id"])).is_equal("slot-002")
	assert_int(int(trace[0]["hop"])).is_equal(0)
	assert_int(int(trace[0]["source_id"])).is_equal(-1)
	assert_int(int(trace[1]["source_id"])).is_equal(1)

func test_attack_resolve_is_single_use_and_reset_is_clean() -> void:
	var state := ATTACKS.empty_state(14)
	var candidates := [{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 3}]
	var begun := ATTACKS.begin_attack(state, "r14:s001:a01", "slot-001", "rail_pierce", 1, "direct", 1, 50, candidates)
	var first := ATTACKS.resolve_attack(begun["state"], "r14:s001:a01", 51, candidates)
	var repeated := ATTACKS.resolve_attack(first["state"], "r14:s001:a01", 52, candidates)
	assert_bool(repeated["accepted"]).is_false()
	assert_str(String(repeated["events"][0]["reason"])).is_equal("already_resolved")
	var reset := ATTACKS.reset(first["state"], 15)
	assert_int(int(reset["run_id"])).is_equal(15)
	assert_int(int(reset["reset_epoch"])).is_equal(1)
	assert_bool(reset["attacks"].is_empty()).is_true()

func test_three_due_slots_keep_independent_cadence_and_identity() -> void:
	var slots := [
		{"slot_id": "slot-003", "slot_order": 2, "weapon_id": "rail_pierce", "rank": 2, "next_fire_tick": 12, "next_attack_seq": 0},
		{"slot_id": "slot-001", "slot_order": 0, "weapon_id": "rail_pierce", "rank": 1, "next_fire_tick": 12, "next_attack_seq": 1},
		{"slot_id": "slot-002", "slot_order": 1, "weapon_id": "arc_coil", "rank": 1, "next_fire_tick": 12, "next_attack_seq": 0},
	]
	var due := ATTACKS.due_slot_order(slots, 12)
	assert_array(due.map(func(slot): return slot["slot_id"])).is_equal(["slot-001", "slot-002", "slot-003"])
	var state := ATTACKS.empty_state(21)
	var candidates := [{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 3}]
	for slot in due:
		var attack_id := "r21:%s:a%02d" % [slot["slot_id"], int(slot["next_attack_seq"]) + 1]
		var delivery := "arc_chain" if slot["weapon_id"] == "arc_coil" else "direct"
		var begun := ATTACKS.begin_attack(state, attack_id, slot["slot_id"], slot["weapon_id"], int(slot["rank"]), delivery, 1, 12, candidates)
		assert_bool(begun["accepted"]).is_true()
		state = begun["state"]
	assert_array(state["attack_order"]).is_equal(["r21:slot-001:a02", "r21:slot-002:a01", "r21:slot-003:a01"])
	assert_str(String(state["attacks"]["r21:slot-002:a01"]["weapon_id"])).is_equal("arc_coil")

func test_multi_adapter_feedback_keeps_three_attack_identities() -> void:
	var events := [
		{"type": "attack_refresh", "attack_id": "r22:slot-001:a01", "slot_id": "slot-001", "weapon_id": "rail_pierce", "rank": 1, "target_snapshot_ids": [1]},
		{"type": "attack_refresh", "attack_id": "r22:slot-002:a01", "slot_id": "slot-002", "weapon_id": "arc_coil", "rank": 1, "target_snapshot_ids": [1]},
		{"type": "attack_refresh", "attack_id": "r22:slot-003:a01", "slot_id": "slot-003", "weapon_id": "rail_pierce", "rank": 2, "target_snapshot_ids": [1]},
	]
	var feedback := preload("res://adapter/multi_weapon_adapter.gd").feedback_from_events(events)
	assert_int(feedback["lock"].size()).is_equal(3)
	assert_str(String(feedback["lock"][1]["attack_id"])).is_equal("r22:slot-002:a01")
	assert_str(String(feedback["lock"][2]["weapon_id"])).is_equal("rail_pierce")
