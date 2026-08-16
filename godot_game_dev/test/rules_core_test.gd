# rules_core_test.gd
# gdUnit4 test suite for the minimal deterministic rules core (DshRulesCore) and session (DshSession).
# Direction-aligned with QA_ACCEPTANCE_PLAN §3.4 fixture families:
#   TARGET-tie, TARGET-container-order, TARGET-removal, TARGET-no-target, TARGET-float-epsilon.
# S2 kill-path fixtures: KILL-single, KILL-multi, KILL-death-removal, plus enemy-lifetime (hp) field compatibility
# with the existing TARGET-* core semantics, and session-level kill-cycle / clean-reset.
# Fixed seed + fixed tick; exact-value assertions.
extends GdUnitTestSuite

const RULES = preload("res://rules/rules_core.gd")
const SESSION = preload("res://rules/session.gd")

# --- TARGET-tie: equal distance buckets are resolved by stable_id; k1 dominates k2. ---
func test_target_tie_stable_id_decides() -> void:
	var state := RULES.empty_state()
	state["live_candidates"] = [
		{"stable_id": 2, "k1_bucket": 1, "k2_bucket": 1, "alive": true},
		{"stable_id": 1, "k1_bucket": 1, "k2_bucket": 1, "alive": true},
	]
	var ids: Array = RULES.ordered_candidates(state, {})
	assert_array(ids).is_equal([1, 2])


# k1 (nearest-threat bucket) has strict priority over k2 (cluster-center bucket).
func test_target_tie_k1_dominates_k2() -> void:
	var state := RULES.empty_state()
	state["live_candidates"] = [
		{"stable_id": 1, "k1_bucket": 1, "k2_bucket": 0, "alive": true},
		{"stable_id": 2, "k1_bucket": 0, "k2_bucket": 99, "alive": true},
	]
	var ids: Array = RULES.ordered_candidates(state, {})
	assert_array(ids).is_equal([2, 1])


# --- TARGET-container-order: two insertion orders yield bitwise-identical ordered_ids. ---
func test_target_container_order_independent() -> void:
	var set_a: Array = [
		{"stable_id": 5, "k1_bucket": 1, "k2_bucket": 2, "alive": true},
		{"stable_id": 3, "k1_bucket": 0, "k2_bucket": 9, "alive": true},
		{"stable_id": 9, "k1_bucket": 0, "k2_bucket": 1, "alive": true},
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 1, "alive": true},
	]
	var set_b: Array = [
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 1, "alive": true},
		{"stable_id": 9, "k1_bucket": 0, "k2_bucket": 1, "alive": true},
		{"stable_id": 3, "k1_bucket": 0, "k2_bucket": 9, "alive": true},
		{"stable_id": 5, "k1_bucket": 1, "k2_bucket": 2, "alive": true},
	]
	var sa := RULES.empty_state()
	sa["live_candidates"] = set_a
	var sb := RULES.empty_state()
	sb["live_candidates"] = set_b
	var ids_a: Array = RULES.ordered_candidates(sa, {})
	var ids_b: Array = RULES.ordered_candidates(sb, {})
	assert_array(ids_a).is_equal(ids_b)
	# Exact expected order derives from the key chain: (0,1)->{1,9} then (0,9)->{3} then (1,2)->{5}.
	assert_array(ids_a).is_equal([1, 9, 3, 5])


# --- TARGET-no-target: empty legal set -> explicit no-target branch, no fabricated target, next eligible tick recorded. ---
func test_target_no_target_branch() -> void:
	var empty := RULES.empty_state()
	var res: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": []}, empty, 7)
	var st: Dictionary = res["state"]
	assert_bool(st["no_target_branch"]).is_true()
	assert_array(st["target_snapshot_ids"]).is_empty()
	assert_int(st["next_eligible_fire_tick"]).is_equal(8)
	# The step must NOT fabricate a target or a lock indicator.
	assert_array(st["ordered_ids"]).is_empty()
	var has_branch_event := false
	for e in res["events"]:
		if e["type"] == "no_target_branch":
			has_branch_event = true
	assert_bool(has_branch_event).is_true()


# --- TARGET-removal: a target removed after lock is drained as invalidation_event; it produces no hit; snapshot IDs unchanged. ---
func test_target_removal_no_hit_and_invalidation_event() -> void:
	var st0 := RULES.empty_state()
	var refresh: Dictionary = RULES.step(
		{"task": "refresh_fire", "live_candidates": [
			{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true},
			{"stable_id": 2, "k1_bucket": 0, "k2_bucket": 0, "alive": true},
		]},
		st0, 10)
	var locked: Dictionary = refresh["state"]
	assert_array(locked["target_snapshot_ids"]).is_equal([1, 2])

	# Resolve on a later tick; target 2 was removed before resolution -> drained at the resolution drain point.
	var resolve: Dictionary = RULES.step({"task": "resolve", "removed_ids": [2]}, locked, 12)
	var st: Dictionary = resolve["state"]

	# invalidation_event(2, 12) is present in the trace/events.
	var found_inv := false
	for e in resolve["events"]:
		if e["type"] == "invalidation_event" and int(e["id"]) == 2 and int(e["tick"]) == 12:
			found_inv = true
	assert_bool(found_inv).is_true()

	# Target 1 hits; target 2 produces no hit (no fabricated hit).
	assert_bool(st["hit_results"].has(1)).is_true()
	assert_bool(st["hit_results"].has(2)).is_false()
	assert_str(str(st["resolution_outcomes"].get(2, ""))).is_equal("no-hit-invalid")
	# Snapshot ID set is unchanged.
	assert_array(st["target_snapshot_ids"]).is_equal([1, 2])


# --- TARGET-float-epsilon: near-equal distances quantize into the same bucket; two same-seed runs agree bitwise. ---
func test_target_float_epsilon_same_seed_consistency() -> void:
	var dist_a := 1.0000001
	var dist_b := 1.0000002
	var scale := 1000.0
	assert_int(RULES.quantize_bucket(dist_a, scale)).is_equal(RULES.quantize_bucket(dist_b, scale))

	# Two independent same-seed runs over the same candidate distances produce identical ordered_ids.
	var run1 := RULES.empty_state()
	run1["live_candidates"] = [
		{"stable_id": 1, "k1_bucket": RULES.quantize_bucket(dist_a, scale), "k2_bucket": 1, "alive": true},
		{"stable_id": 2, "k1_bucket": RULES.quantize_bucket(dist_b, scale), "k2_bucket": 1, "alive": true},
	]
	var run2 := RULES.empty_state()
	run2["live_candidates"] = [
		{"stable_id": 1, "k1_bucket": RULES.quantize_bucket(dist_a, scale), "k2_bucket": 1, "alive": true},
		{"stable_id": 2, "k1_bucket": RULES.quantize_bucket(dist_b, scale), "k2_bucket": 1, "alive": true},
	]
	assert_array(RULES.ordered_candidates(run1, {})).is_equal(RULES.ordered_candidates(run2, {}))


# --- session: fixed seed + fixed tick + reset gives a clean, deterministic restart with no cross-run dirty state. ---
func test_session_reset_is_clean_and_deterministic() -> void:
	var s1 := SESSION.new(1337)
	s1.step({"task": "refresh_fire", "live_candidates": [
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true}]})
	s1.advance_tick()
	assert_int(s1.current_tick()).is_equal(1)
	assert_bool(not s1.rules_state["target_snapshot_ids"].is_empty()).is_true()

	var run_before: int = s1.run_id
	s1.reset(1337)
	assert_int(s1.run_id).is_equal(run_before + 1)
	assert_int(s1.current_tick()).is_equal(0)
	# Reset leaves no cross-run dirty state: snapshots / invalidation / results / kills are all rebuilt fresh.
	assert_array(s1.rules_state["ordered_ids"]).is_empty()
	assert_array(s1.rules_state["target_snapshot_ids"]).is_empty()
	assert_bool(s1.rules_state["invalidation_log"].is_empty()).is_true()
	assert_bool(s1.rules_state["hit_results"].is_empty()).is_true()
	assert_bool(s1.rules_state["kill_outcomes"].is_empty()).is_true()

	# Same seed re-run reproduces the same step output (determinism at session level).
	var s2 := SESSION.new(1337)
	var r2: Dictionary = s2.step({"task": "refresh_fire", "live_candidates": [
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true}]})
	var r3: Dictionary = s1.step({"task": "refresh_fire", "live_candidates": [
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true}]})
	assert_array(r2["state"]["ordered_ids"]).is_equal(r3["state"]["ordered_ids"])


# ============================ S2 KILL-path fixtures ============================

# --- KILL-single: one target with hp=1 dies from a single hit; kill_event + kill_outcomes recorded. ---
func test_kill_single_hit_kills_enemy() -> void:
	var st0 := RULES.empty_state()
	var refresh: Dictionary = RULES.step(
		{"task": "refresh_fire", "live_candidates": [
			{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 1},
		]}, st0, 20)
	assert_array(refresh["state"]["target_snapshot_ids"]).is_equal([1])

	var res: Dictionary = RULES.step({"task": "resolve", "attack_damage": 1}, refresh["state"], 21)
	var st: Dictionary = res["state"]
	assert_bool(st["hit_results"].has(1)).is_true()
	assert_bool(st["kill_outcomes"].has(1)).is_true()
	# A kill_event is emitted with the target id and tick.
	var found_kill := false
	for e in res["events"]:
		if e["type"] == "kill_event" and int(e["id"]) == 1 and int(e["tick"]) == 21:
			found_kill = true
	assert_bool(found_kill).is_true()
	# The dead candidate is marked not alive (clean-shrink signal for the next refresh).
	var cand: Dictionary = st["live_candidates"][0]
	assert_bool(cand["alive"]).is_false()
	# Next refresh excludes the dead target -> no ghost target in the following locked snapshot.
	var next_refresh: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": st["live_candidates"]}, st, 22)
	assert_array(next_refresh["state"]["target_snapshot_ids"]).is_empty()
	assert_bool(next_refresh["state"]["no_target_branch"]).is_true()


# --- KILL-single adapter-compat: a candidate without an explicit hp field defaults to 1 -> one hit still kills it. ---
func test_kill_candidate_without_hp_defaults_to_one() -> void:
	var st0 := RULES.empty_state()
	var refresh: Dictionary = RULES.step(
		{"task": "refresh_fire", "live_candidates": [
			{"stable_id": 3, "k1_bucket": 0, "k2_bucket": 0, "alive": true},
		]}, st0, 30)
	var res: Dictionary = RULES.step({"task": "resolve", "attack_damage": 1}, refresh["state"], 31)
	assert_bool(res["state"]["hit_results"].has(3)).is_true()
	assert_bool(res["state"]["kill_outcomes"].has(3)).is_true()


# --- KILL-multi: multiple targets and a multi-hit path where each full hit steps hp down; death after enough hits. ---
func test_kill_multi_targets_multi_hit() -> void:
	var st0 := RULES.empty_state()
	# Two enemies with hp=2. Single-hit damage is 1 per shot.
	var refresh: Dictionary = RULES.step(
		{"task": "refresh_fire", "live_candidates": [
			{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 2},
			{"stable_id": 2, "k1_bucket": 1, "k2_bucket": 0, "alive": true, "hp": 2},
		]}, st0, 40)
	assert_array(refresh["state"]["target_snapshot_ids"]).is_equal([1, 2])

	# Shot 1: both hit, hp 2 -> 1, neither dies.
	var shot1: Dictionary = RULES.step({"task": "resolve", "attack_damage": 1}, refresh["state"], 41)
	assert_bool(shot1["state"]["kill_outcomes"].is_empty()).is_true()
	var hp1: int = int(shot1["state"]["live_candidates"][0]["hp"])
	assert_int(hp1).is_equal(1)

	# Shot 2 on the SAME locked snapshot: both hit again, hp 1 -> 0, both die.
	var shot2: Dictionary = RULES.step({"task": "resolve", "attack_damage": 1}, shot1["state"], 42)
	assert_bool(shot2["state"]["kill_outcomes"].has(1)).is_true()
	assert_bool(shot2["state"]["kill_outcomes"].has(2)).is_true()


# --- KILL-death-removal: after death the target is removed from the live set and can never produce a ghost hit. ---
# Target 1 (hp=1) dies on the first shot; target 2 (hp=5) survives. After death, target 1 is excluded from the live set
# and from any later locked snapshot / resolution, so it can never produce a ghost hit.
func test_kill_death_removal_no_ghost_hit() -> void:
	var st0 := RULES.empty_state()
	var refresh: Dictionary = RULES.step(
		{"task": "refresh_fire", "live_candidates": [
			{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 1},
			{"stable_id": 2, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 5},
		]}, st0, 50)

	# Shot 1: both lock ids resolve; target 1 dies, target 2 takes a hit but survives.
	var shot1: Dictionary = RULES.step({"task": "resolve", "attack_damage": 1}, refresh["state"], 51)
	assert_bool(shot1["state"]["hit_results"].has(1)).is_true()
	assert_bool(shot1["state"]["hit_results"].has(2)).is_true()
	assert_bool(shot1["state"]["kill_outcomes"].has(1)).is_true()
	assert_bool(shot1["state"]["kill_outcomes"].has(2)).is_false()
	# target 1 is marked not alive (death -> clean-shrink), target 2 remains live.
	var s1_alive := true
	var s2_alive := true
	for c in shot1["state"]["live_candidates"]:
		if int(c["stable_id"]) == 1:
			s1_alive = bool(c.get("alive", true))
		elif int(c["stable_id"]) == 2:
			s2_alive = bool(c.get("alive", true))
	assert_bool(s1_alive).is_false()
	assert_bool(s2_alive).is_true()

	# The follower refresh is fed the live subset (target 2) and locks only it; the dead target never reappears.
	var live_only: Array = []
	for c in shot1["state"]["live_candidates"]:
		if bool(c.get("alive", true)):
			live_only.append(c)
	var refresh2: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": live_only}, shot1["state"], 52)
	assert_array(refresh2["state"]["target_snapshot_ids"]).is_equal([2])

	# A subsequent resolve over that new snapshot hits only the live target (no ghost hit for the dead id).
	var shot2: Dictionary = RULES.step({"task": "resolve", "attack_damage": 1}, refresh2["state"], 53)
	assert_bool(shot2["state"]["hit_results"].has(2)).is_true()
	assert_bool(shot2["state"]["hit_results"].has(1)).is_false()
	assert_bool(shot2["state"]["kill_outcomes"].has(1)).is_false()
	assert_bool(shot2["state"]["kill_outcomes"].has(2)).is_false()


# --- KILL-death-removal + invalidation (ii): a target drained as removed_ids before a later resolve produces no kill
#     and no fabricated hit, even if it would otherwise have lived. ---
func test_kill_removed_target_produces_no_hit_and_no_kill() -> void:
	var st0 := RULES.empty_state()
	var refresh: Dictionary = RULES.step(
		{"task": "refresh_fire", "live_candidates": [
			{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 3},
		]}, st0, 60)
	var res: Dictionary = RULES.step({"task": "resolve", "removed_ids": [1], "attack_damage": 1}, refresh["state"], 61)
	var st: Dictionary = res["state"]
	# The removed target is excluded from resolution entirely: no hit, no kill.
	assert_bool(st["hit_results"].has(1)).is_false()
	assert_bool(st["kill_outcomes"].has(1)).is_false()
	assert_str(str(st["resolution_outcomes"].get(1, ""))).is_equal("no-hit-invalid")
	var found_kill := false
	for e in res["events"]:
		if e["type"] == "kill_event" and int(e["id"]) == 1:
			found_kill = true
	assert_bool(found_kill).is_false()


# --- TARGET-* enemy-lifetime field compat: adding `hp` to candidates must not change the deterministic ordering. ---
func test_target_order_unchanged_by_enemy_lifetime_fields() -> void:
	var no_hp := RULES.empty_state()
	no_hp["live_candidates"] = [
		{"stable_id": 5, "k1_bucket": 1, "k2_bucket": 2, "alive": true},
		{"stable_id": 3, "k1_bucket": 0, "k2_bucket": 9, "alive": true},
		{"stable_id": 9, "k1_bucket": 0, "k2_bucket": 1, "alive": true},
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 1, "alive": true},
	]
	var with_hp := RULES.empty_state()
	with_hp["live_candidates"] = [
		{"stable_id": 5, "k1_bucket": 1, "k2_bucket": 2, "alive": true, "hp": 1},
		{"stable_id": 3, "k1_bucket": 0, "k2_bucket": 9, "alive": true, "hp": 1},
		{"stable_id": 9, "k1_bucket": 0, "k2_bucket": 1, "alive": true, "hp": 1},
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 1, "alive": true, "hp": 1},
	]
	assert_array(RULES.ordered_candidates(with_hp, {})).is_equal(RULES.ordered_candidates(no_hp, {}))
	assert_array(RULES.ordered_candidates(with_hp, {})).is_equal([1, 9, 3, 5])


# --- session + kill: a full kill cycle through the session clears cleanly; kill state does not leak across runs. ---
func test_session_kill_cycle_then_reset_clean() -> void:
	var s := SESSION.new(2024)
	s.step({"task": "refresh_fire", "live_candidates": [
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 1}]})
	s.advance_tick()
	s.step({"task": "resolve", "attack_damage": 1})
	assert_bool(s.rules_state["kill_outcomes"].has(1)).is_true()
	assert_bool(s.rules_state["hit_results"].has(1)).is_true()

	var run_before: int = s.run_id
	s.reset(2024)
	assert_int(s.run_id).is_equal(run_before + 1)
	# No kill/hit/invalidation cross-run dirty state after reset.
	assert_bool(s.rules_state["kill_outcomes"].is_empty()).is_true()
	assert_bool(s.rules_state["hit_results"].is_empty()).is_true()
	assert_bool(s.rules_state["invalidation_log"].is_empty()).is_true()
	assert_array(s.rules_state["target_snapshot_ids"]).is_empty()
