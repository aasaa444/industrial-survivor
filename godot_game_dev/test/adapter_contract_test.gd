# adapter_contract_test.gd
# gdUnit4 contract tests for the S3 adapter seam (DshAdapter).
# Verifies:
#   - input -> movement mapping correctness (WASD + arrows, diagonals, no move, no gamepad).
#   - domain-input-envelope routing (task selector + movement passthrough; adapter never authors rule semantics).
#   - event routing to engine feedback, strictly bound to hit_results / kill_outcomes / target_snapshot_ids:
#       lock indicator only when a target is locked; hit feedback only for real hits; kill feedback only for real kills;
#       an empty (no-target) shot emits only a quiet non-color cue, never a fabricated lock or phantom hit
#       (ADR-TECH-02 / UX-03 S2 empty-shot non-forgery).
#   - candidate_from_observation -> deterministic ordering with the pure rules core (M-1 key chain).
extends GdUnitTestSuite

const ADAPTER = preload("res://adapter/adapter.gd")
const RULES = preload("res://rules/rules_core.gd")


# --- Input mapping correctness ------------------------------------------------
func test_input_w_up_moves_up() -> void:
	var m: Dictionary = ADAPTER.movement_from_input({"w": true})
	assert_int(m["dir_x"]).is_equal(0)
	assert_int(m["dir_y"]).is_equal(-1)
	assert_bool(m["moved"]).is_true()


func test_input_arrow_up_moves_up() -> void:
	var m: Dictionary = ADAPTER.movement_from_input({"up": true})
	assert_int(m["dir_x"]).is_equal(0)
	assert_int(m["dir_y"]).is_equal(-1)
	assert_bool(m["moved"]).is_true()


func test_input_s_down_a_left_d_right() -> void:
	assert_int(ADAPTER.movement_from_input({"s": true})["dir_y"]).is_equal(1)
	assert_int(ADAPTER.movement_from_input({"a": true})["dir_x"]).is_equal(-1)
	assert_int(ADAPTER.movement_from_input({"d": true})["dir_x"]).is_equal(1)
	assert_int(ADAPTER.movement_from_input({"left": true})["dir_x"]).is_equal(-1)
	assert_int(ADAPTER.movement_from_input({"right": true})["dir_x"]).is_equal(1)
	assert_int(ADAPTER.movement_from_input({"down": true})["dir_y"]).is_equal(1)


func test_input_diagonal_and_none() -> void:
	var diag: Dictionary = ADAPTER.movement_from_input({"w": true, "d": true})
	assert_int(diag["dir_x"]).is_equal(1)
	assert_int(diag["dir_y"]).is_equal(-1)
	var none: Dictionary = ADAPTER.movement_from_input({})
	assert_bool(none["moved"]).is_false()
	assert_int(none["dir_x"]).is_equal(0)
	assert_int(none["dir_y"]).is_equal(0)


func test_input_is_pure_and_deterministic() -> void:
	var a: Dictionary = ADAPTER.movement_from_input({"w": true, "a": true})
	var b: Dictionary = ADAPTER.movement_from_input({"w": true, "a": true})
	assert_int(a["dir_x"]).is_equal(b["dir_x"])
	assert_int(a["dir_y"]).is_equal(b["dir_y"])


# --- Domain input envelope routing --------------------------------------------
func test_pick_task_refresh_when_unlocked() -> void:
	assert_str(ADAPTER.pick_task(false, false)).is_equal("refresh_fire")
	assert_str(ADAPTER.pick_task(true, false)).is_equal("refresh_fire")


func test_pick_task_resolve_when_locked_in_epoch() -> void:
	assert_str(ADAPTER.pick_task(false, true)).is_equal("resolve")


func test_make_envelope_carries_movement_and_candidates() -> void:
	var mov: Dictionary = ADAPTER.movement_from_input({"d": true})
	var env: Dictionary = ADAPTER.make_envelope("refresh_fire", [{"stable_id": 1}], mov, 1)
	assert_str(env["task"]).is_equal("refresh_fire")
	assert_int(env["movement"]["dir_x"]).is_equal(1)
	assert_int(env["attack_damage"]).is_equal(1)
	assert_array(env["live_candidates"]).is_equal([{"stable_id": 1}])


# --- Feedback binding (ADR-TECH-02 / UX-03 S2) --------------------------------
# Lock indicator appears ONLY when target_snapshot_ids is non-empty (a real lock).
func test_feedback_lock_only_when_target_locked() -> void:
	var res: Dictionary = {"state": {"target_snapshot_ids": [3], "hit_results": {}, "kill_outcomes": {}, "no_target_branch": false}}
	var fb: Dictionary = ADAPTER.feedback_from_result(res)
	assert_array(fb["lock_target"]).is_equal([3])
	# An empty shot must not fabricate a lock indicator.
	var empty_res: Dictionary = {"state": {"target_snapshot_ids": [], "hit_results": {}, "kill_outcomes": {}, "no_target_branch": true}}
	var fb2: Dictionary = ADAPTER.feedback_from_result(empty_res)
	assert_array(fb2["lock_target"]).is_empty()


# Hit feedback is bound strictly to hit_results.
func test_feedback_hit_bound_to_hit_results() -> void:
	var res: Dictionary = {"state": {"target_snapshot_ids": [1, 2], "hit_results": {1: true}, "kill_outcomes": {}, "no_target_branch": false}}
	var fb: Dictionary = ADAPTER.feedback_from_result(res)
	assert_array(fb["hit"]).is_equal([1])          # only the actually-hit id
	assert_bool(2 in fb["hit"]).is_false()         # no phantom hit for an unhit locked id


# Kill feedback is bound strictly to kill_outcomes (a real death event).
func test_feedback_kill_bound_to_kill_outcomes() -> void:
	var res: Dictionary = {"state": {"target_snapshot_ids": [1], "hit_results": {1: true}, "kill_outcomes": {1: true}, "no_target_branch": false}}
	var fb: Dictionary = ADAPTER.feedback_from_result(res)
	assert_array(fb["kill"]).is_equal([1])


# Empty (no-target) shot is quiet: no lock, no hit, no kill; only the optional non-color no-target cue.
func test_feedback_empty_shot_no_forgery() -> void:
	var res: Dictionary = {"state": {"target_snapshot_ids": [], "hit_results": {}, "kill_outcomes": {}, "no_target_branch": true}}
	var fb: Dictionary = ADAPTER.feedback_from_result(res)
	assert_bool(fb["no_target"]).is_true()
	assert_array(fb["lock_target"]).is_empty()
	assert_array(fb["hit"]).is_empty()
	assert_array(fb["kill"]).is_empty()


# A locked-but-unresolved result must not claim a hit: hit feedback is empty until the rules emit hit_results.
func test_feedback_no_hit_then_locked_only() -> void:
	var locked: Dictionary = {"state": {"target_snapshot_ids": [7], "hit_results": {}, "kill_outcomes": {}, "no_target_branch": false}}
	var fb: Dictionary = ADAPTER.feedback_from_result(locked)
	assert_array(fb["lock_target"]).is_equal([7])
	assert_array(fb["hit"]).is_empty()


# --- No-rule-semantics leakage ------------------------------------------------
# The adapter must not invent ordering: candidate -> rules ordering must come from DshRulesCore.ordered_candidates.
func test_adapter_candidates_feed_core_ordering() -> void:
	var ob: Array = [
		ADAPTER.candidate_from_observation(2, Vector2(20, 0), Vector2(0, 0), Vector2(10, 0), 1, 1.0),
		ADAPTER.candidate_from_observation(1, Vector2(3, 0), Vector2(0, 0), Vector2(10, 0), 1, 1.0),
	]
	var st := RULES.empty_state()
	st["live_candidates"] = ob
	var ids: Array = RULES.ordered_candidates(st, {})
	# Nearest-threat (k1) drives order: id1 (dist 3) before id2 (dist 20). Ordered by rules core, not the adapter.
	assert_array(ids).is_equal([1, 2])


# Envelope task routing end-to-end with the real rules core produces a lock only when candidates exist.
func test_adapters_envelope_drives_core_lock() -> void:
	var env: Dictionary = ADAPTER.make_envelope(
		"refresh_fire",
		[ADAPTER.candidate_from_observation(5, Vector2(50, 0), Vector2(0, 0), Vector2(25, 0), 1, 1.0)],
		ADAPTER.movement_from_input({"d": true}),
		1
	)
	var res: Dictionary = RULES.step(env, RULES.empty_state(), 5)
	assert_array(res["state"]["target_snapshot_ids"]).is_equal([5])
	# Feedback for a locked shot with no-hit-resolved state must show lock but no phantom hit.
	var fb: Dictionary = ADAPTER.feedback_from_result(res)
	assert_array(fb["lock_target"]).is_equal([5])
