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
#
# R1 extension (this unit): input -> movement -> NEXT-shot lock causality contracts (ADR-TECH-04 / UX-02 U2-B/U2-C).
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


# ============================ R1: input -> movement -> NEXT-shot lock causality ============================
# (ADR-TECH-04: movement changes the NEXT pre-fire refresh lock; the CURRENT shot's snapshot stays immutable;
#  UX-02 U2-B / U2-C.)

# Movement intent is carried into the domain envelope as intent-only and never changes rules semantics.
func test_movement_intent_does_not_change_rules_semantics() -> void:
	var candidates: Array = [
		ADAPTER.candidate_from_observation(1, Vector2(60, 0), Vector2(0, 0), Vector2(35, 0), 1, 1.0),
		ADAPTER.candidate_from_observation(2, Vector2(10, 0), Vector2(0, 0), Vector2(35, 0), 1, 1.0),
	]
	var moving_env: Dictionary = ADAPTER.make_envelope(
		"refresh_fire", candidates, ADAPTER.movement_from_input({"d": true}), 1)
	var still_env: Dictionary = ADAPTER.make_envelope(
		"refresh_fire", candidates, ADAPTER.movement_from_input({}), 1)
	var res_moving: Dictionary = RULES.step(moving_env, RULES.empty_state(), 5)
	var res_still: Dictionary = RULES.step(still_env, RULES.empty_state(), 5)
	# The rules core ignores movement intent entirely: identical candidates -> identical ordered/snapshot.
	assert_array(res_moving["state"]["ordered_ids"]).is_equal(res_still["state"]["ordered_ids"])
	assert_array(res_moving["state"]["target_snapshot_ids"]).is_equal(res_still["state"]["target_snapshot_ids"])
	assert_bool(res_moving["state"]["no_target_branch"]).is_equal(res_still["state"]["no_target_branch"])


# U2-B: after the player moves, the NEXT refresh re-observes the moved location and re-locks (the attack-line target,
# the nearest-first id, flips); the CURRENT shot's locked snapshot stays immutable during movement (ADR-TECH-04).
func test_movement_causality_next_refresh_relocks() -> void:
	# Enemies: A id=1 at (60,0), B id=2 at (10,0); cluster_center fixed (35,0).
	# Player at P0=(0,0): threat buckets B(k1=10) < A(k1=60) -> lock snapshot [2,1]; nearest-first lock = B (id 2).
	var p0 := Vector2(0, 0)
	var can_p0: Array = [
		ADAPTER.candidate_from_observation(1, Vector2(60, 0), p0, Vector2(35, 0), 1, 1.0),
		ADAPTER.candidate_from_observation(2, Vector2(10, 0), p0, Vector2(35, 0), 1, 1.0),
	]
	var r_p0: Dictionary = RULES.step(
		ADAPTER.make_envelope("refresh_fire", can_p0, ADAPTER.movement_from_input({"d": true}), 1),
		RULES.empty_state(), 10)
	# B is nearest-threat first: the full locked snapshot is [2,1].
	assert_array(r_p0["state"]["target_snapshot_ids"]).is_equal([2, 1])

	# Player moves to P1=(60,0) (d held). The CURRENT shot already locked [2,1]; movement intent must NOT live-retarget it.
	var p1 := Vector2(60, 0)
	var can_p1: Array = [
		ADAPTER.candidate_from_observation(1, Vector2(60, 0), p1, Vector2(35, 0), 1, 1.0),
		ADAPTER.candidate_from_observation(2, Vector2(10, 0), p1, Vector2(35, 0), 1, 1.0),
	]
	var resolve_env: Dictionary = ADAPTER.make_envelope("resolve", [], ADAPTER.movement_from_input({"d": true}), 1)
	resolve_env["attack_max_targets"] = 999
	var resolve_after_move: Dictionary = RULES.step(resolve_env, r_p0["state"], 11)
	# Resolution reads ONLY the immutable locked snapshot [2,1] (both locked ids hit), even though the player moved.
	assert_array(resolve_after_move["state"]["target_snapshot_ids"]).is_equal([2, 1])
	assert_bool(resolve_after_move["state"]["hit_results"].has(2)).is_true()
	assert_bool(resolve_after_move["state"]["hit_results"].has(1)).is_true()

	# NEXT pre-fire refresh observes positions from the moved player location: A(k1=|60-60|=0) < B(k1=|10-60|=50)
	# -> the next lock re-orders to [1,2]; the nearest-first attack-line target flips from B to A (id 1).
	var r_p1: Dictionary = RULES.step(
		ADAPTER.make_envelope("refresh_fire", can_p1, ADAPTER.movement_from_input({"d": true}), 1),
		resolve_after_move["state"], 12)
	assert_array(r_p1["state"]["target_snapshot_ids"]).is_equal([1, 2])
	# Cross-shot causality: movement changed WHICH target is locked first in the NEXT shot ([0] id 2 -> id 1).
	assert_int(int(r_p0["state"]["target_snapshot_ids"][0])).is_equal(2)
	assert_int(int(r_p1["state"]["target_snapshot_ids"][0])).is_equal(1)


# U2-C control: unchanged geometry across runs -> bitwise-identical lock (movement causality is stable/readable).
func test_same_geometry_same_lock_across_runs() -> void:
	var candidates: Array = [
		ADAPTER.candidate_from_observation(1, Vector2(60, 0), Vector2(0, 0), Vector2(35, 0), 1, 1.0),
		ADAPTER.candidate_from_observation(2, Vector2(10, 0), Vector2(0, 0), Vector2(35, 0), 1, 1.0),
	]
	var run1: Dictionary = RULES.step(
		ADAPTER.make_envelope("refresh_fire", candidates, ADAPTER.movement_from_input({}), 1),
		RULES.empty_state(), 20)
	var run2: Dictionary = RULES.step(
		ADAPTER.make_envelope("refresh_fire", candidates, ADAPTER.movement_from_input({}), 1),
		RULES.empty_state(), 21)
	assert_array(run1["state"]["target_snapshot_ids"]).is_equal(run2["state"]["target_snapshot_ids"])
	assert_array(run1["state"]["ordered_ids"]).is_equal(run2["state"]["ordered_ids"])


# ============================ C4 contact seam contract tests (this unit) ============================
# Adapter contact seam (NEXT_IMPL_UNIT_PLAN_v0_3 unit B / ADR-TECH-01):
#   - engine overlap observation -> domain contact observations (contact_observations);
#   - envelope carries the contact observations + candidate parameters (make_envelope);
#   - contact feedback classes bound strictly to the rules contact events (contact_feedback_from_result):
#       no contact feedback is fabricated when no contact event exists.
# The adapter never judges contact legality / damage / re-arm — that stays in the rules core.

# contact_observations translates engine overlap booleans into the domain contact input [{id}] (only overlapping).
func test_contact_observations_filters_overlaps() -> void:
	var obs: Array = ADAPTER.contact_observations([
		{"id": 1, "overlapping": true},
		{"id": 2, "overlapping": false},
		{"id": 3, "overlapping": true},
	])
	assert_array(obs).is_equal([{"id": 1}, {"id": 3}])


# An empty/absent overlap set translates to an empty contact observation list (contact quiet, no fabrication).
func test_contact_observations_empty_when_no_overlap() -> void:
	var obs: Array = ADAPTER.contact_observations([
		{"id": 5, "overlapping": false},
	])
	assert_array(obs).is_empty()


# make_envelope carries contact observations + the candidate contact parameters through the domain envelope.
func test_make_envelope_carries_contact_input_and_params() -> void:
	var mov: Dictionary = ADAPTER.movement_from_input({"d": true})
	var env: Dictionary = ADAPTER.make_envelope(
		"refresh_fire", [{"stable_id": 1}], mov, 1, [], [{"id": 2}], 30, 1)
	assert_array(env["contact_input"]).is_equal([{"id": 2}])
	assert_int(int(env["contact_invulnerability_ticks"])).is_equal(30)
	assert_int(int(env["contact_damage"])).is_equal(1)
	# The envelope always carries contact_input (empty included) so separation/re-arm is evaluated every step.
	var env2: Dictionary = ADAPTER.make_envelope("refresh_fire", [{"stable_id": 1}], mov, 1)
	assert_array(env2["contact_input"]).is_empty()


# contact_feedback_from_result is bound strictly to contact domain events (no fabrication when none present).
func test_contact_feedback_bound_to_events() -> void:
	var res: Dictionary = {
		"events": [
			{"type": "contact_damage_event", "victim_id": 4, "segments_lost": 1, "tick": 10},
			{"type": "contact_invulnerable_event", "until_tick": 40, "tick": 10},
			{"type": "contact_rearm_event", "id": 4, "tick": 20},
		],
	}
	var fb: Dictionary = ADAPTER.contact_feedback_from_result(res)
	assert_array(fb["damage"]).is_equal([{"victim_id": 4, "segments_lost": 1}])
	assert_bool(fb["invulnerable"]).is_true()
	assert_array(fb["rearm"]).is_equal([4])


# No contact event -> no contact feedback (quiet; the empty/no-contact path never fabricates damage).
func test_contact_feedback_empty_when_no_contact_event() -> void:
	var res: Dictionary = {"events": [{"type": "no_target_branch", "tick": 5}]}
	var fb: Dictionary = ADAPTER.contact_feedback_from_result(res)
	assert_array(fb["damage"]).is_empty()
	assert_bool(fb["invulnerable"]).is_false()
	assert_array(fb["rearm"]).is_empty()

# ============================ T4 terminal seam contract tests (this unit) ============================
# Adapter terminal seam (NEXT_IMPL_UNIT_PLAN_v0_4 unit 4 / ADR-TECH-01 + ADR-TECH-05):
#   - make_envelope carries the session terminal domain input (timer_completed) through the domain envelope;
#   - terminal_feedback_from_result binds the RESULT presentation strictly to the terminal rule events
#     (terminal_event / reset_event): no RESULT presentation is fabricated when no terminal event exists.
# The adapter never decides victory/defeat — that stays in the rules core.

# make_envelope carries the terminal_input (timer_completed) through the domain envelope (additive default empty).
func test_make_envelope_carries_terminal_input() -> void:
	var mov: Dictionary = ADAPTER.movement_from_input({"w": true})
	var env: Dictionary = ADAPTER.make_envelope(
		"refresh_fire", [{"stable_id": 1}], mov, 1, [], [], 30, 1, {"timer_completed": true})
	assert_bool(env["terminal_input"].get("timer_completed", false)).is_true()
	# Default (no terminal_input) carries an empty terminal_input for additive compatibility.
	var env2: Dictionary = ADAPTER.make_envelope("refresh_fire", [{"stable_id": 1}], mov, 1)
	assert_bool(env2["terminal_input"].is_empty()).is_true()


# terminal_feedback_from_result is bound strictly to the terminal domain events.
func test_terminal_feedback_bound_to_events() -> void:
	var res: Dictionary = {
		"state": {"result_locked": true},
		"events": [
			{"type": "terminal_event", "outcome": "defeat", "tick": 10},
			{"type": "reset_event", "reset_epoch": 2, "tick": 12},
		],
	}
	var fb: Dictionary = ADAPTER.terminal_feedback_from_result(res)
	assert_bool(fb["terminal_fired"]).is_true()
	assert_str(String(fb["outcome"])).is_equal("defeat")
	assert_bool(fb["result_locked"]).is_true()
	assert_bool(fb["reset_fired"]).is_true()
	assert_int(int(fb["reset_epoch"])).is_equal(2)


# No terminal/reset event -> no RESULT presentation (quiet; the empty/neutral path never fabricates victory/defeat).
func test_terminal_feedback_empty_when_no_terminal_event() -> void:
	var res: Dictionary = {
		"state": {"result_locked": false},
		"events": [{"type": "no_target_branch", "tick": 5}],
	}
	var fb: Dictionary = ADAPTER.terminal_feedback_from_result(res)
	assert_bool(fb["terminal_fired"]).is_false()
	assert_str(String(fb["outcome"])).is_equal("")
	assert_bool(fb["reset_fired"]).is_false()
	assert_int(int(fb["reset_epoch"])).is_equal(-1)
