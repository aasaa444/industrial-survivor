# rules_core_test.gd
# gdUnit4 test suite for the minimal deterministic rules core (DshRulesCore) and session (DshSession).
# Direction-aligned with QA_ACCEPTANCE_PLAN §3.4 fixture families:
#   TARGET-tie, TARGET-container-order, TARGET-removal, TARGET-no-target, TARGET-float-epsilon.
# S2 kill-path fixtures: KILL-single, KILL-multi, KILL-death-removal, plus enemy-lifetime (hp) field compatibility
# with the existing TARGET-* core semantics, and session-level kill-cycle / clean-reset.
#
# R3 O4 (this unit): per-family container-order variance variants for the KILL-* families
#   (each family is exercised under two candidate-insertion orders and must agree bitwise).
# R3 O5 (this unit): diagnostics-layer read-only kill decision-key trace tuples
#   (candidate_key_trace / kill_decision_trace / live_reduction_count), exported independently of state/events.
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

	var res: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, refresh["state"], 21)
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
	var res: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, refresh["state"], 31)
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
	var shot1: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, refresh["state"], 41)
	assert_bool(shot1["state"]["kill_outcomes"].is_empty()).is_true()
	var hp1: int = int(shot1["state"]["live_candidates"][0]["hp"])
	assert_int(hp1).is_equal(1)

	# Shot 2 on the SAME locked snapshot: both hit again, hp 1 -> 0, both die.
	var shot2: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, shot1["state"], 42)
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
	var shot1: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, refresh["state"], 51)
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
	var shot2: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, refresh2["state"], 53)
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
	s.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1})
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


# ============================ R3 O4: KILL-* per-family container-order variants ============================
# Each KILL-* family is executed under two candidate-insertion orders; ordered/snapshot AND kill behavior must be
# bitwise equivalent (the total-order key chain makes ordering container-independent, QA observation O4).

# KILL-single family variant: hp=1 target + survivor, both insertion orders -> identical snapshot and one-shot kill.
func test_kill_single_container_order_variant() -> void:
	var set_a: Array = [
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 2, "alive": true, "hp": 1},
		{"stable_id": 2, "k1_bucket": 0, "k2_bucket": 1, "alive": true, "hp": 5},
	]
	var set_b: Array = [
		{"stable_id": 2, "k1_bucket": 0, "k2_bucket": 1, "alive": true, "hp": 5},
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 2, "alive": true, "hp": 1},
	]
	var ra := RULES.empty_state()
	ra["live_candidates"] = set_a
	var rb := RULES.empty_state()
	rb["live_candidates"] = set_b
	# Container-order independence of the key chain: both orders sort to [2,1] -> identical snapshot.
	assert_array(RULES.ordered_candidates(ra, {})).is_equal([2, 1])
	assert_array(RULES.ordered_candidates(rb, {})).is_equal([2, 1])
	var ref_a: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": set_a}, RULES.empty_state(), 71)
	var ref_b: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": set_b}, RULES.empty_state(), 72)
	assert_array(ref_a["state"]["target_snapshot_ids"]).is_equal([2, 1])
	assert_array(ref_b["state"]["target_snapshot_ids"]).is_equal([2, 1])
	# One-shot kill behavior identical across insertion orders: id2 (hp=5) survives, id... (both hit; only hp<=0 dies)
	var shot_a: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, ref_a["state"], 73)
	var shot_b: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, ref_b["state"], 74)
	assert_bool(shot_a["state"]["kill_outcomes"].has(1)).is_true()
	assert_bool(shot_b["state"]["kill_outcomes"].has(1)).is_true()
	assert_bool(shot_a["state"]["kill_outcomes"].has(2)).is_false()
	assert_bool(shot_b["state"]["kill_outcomes"].has(2)).is_false()


# KILL-multi family variant: hp=2 pair, both insertion orders -> identical snapshot and identical two-shot death progression.
func test_kill_multi_container_order_variant() -> void:
	var set_a: Array = [
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 2},
		{"stable_id": 2, "k1_bucket": 0, "k2_bucket": 1, "alive": true, "hp": 2},
	]
	var set_b: Array = [
		{"stable_id": 2, "k1_bucket": 0, "k2_bucket": 1, "alive": true, "hp": 2},
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 2},
	]
	var ref_a: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": set_a}, RULES.empty_state(), 80)
	var ref_b: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": set_b}, RULES.empty_state(), 81)
	assert_array(ref_a["state"]["target_snapshot_ids"]).is_equal([1, 2])
	assert_array(ref_b["state"]["target_snapshot_ids"]).is_equal([1, 2])
	# shot 1: both step to hp=1, no kills (both orders identical).
	var s1a: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, ref_a["state"], 82)
	var s1b: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, ref_b["state"], 83)
	assert_bool(s1a["state"]["kill_outcomes"].is_empty()).is_true()
	assert_bool(s1b["state"]["kill_outcomes"].is_empty()).is_true()
	# shot 2 on the SAME locked snapshot: both die (identical across orders).
	var s2a: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, s1a["state"], 84)
	var s2b: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, s1b["state"], 85)
	assert_bool(s2a["state"]["kill_outcomes"].has(1)).is_true()
	assert_bool(s2a["state"]["kill_outcomes"].has(2)).is_true()
	assert_bool(s2b["state"]["kill_outcomes"].has(1)).is_true()
	assert_bool(s2b["state"]["kill_outcomes"].has(2)).is_true()


# KILL-death-removal family variant: hp=1 + hp=5 pair, both insertion orders -> identical death/removal and the
# follower refresh locks only the survivor.
func test_kill_death_removal_container_order_variant() -> void:
	var set_a: Array = [
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 1},
		{"stable_id": 2, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 5},
	]
	var set_b: Array = [
		{"stable_id": 2, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 5},
		{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 1},
	]
	var ref_a: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": set_a}, RULES.empty_state(), 90)
	var ref_b: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": set_b}, RULES.empty_state(), 91)
	assert_array(ref_a["state"]["target_snapshot_ids"]).is_equal([1, 2])
	assert_array(ref_b["state"]["target_snapshot_ids"]).is_equal([1, 2])
	var shot_a: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, ref_a["state"], 92)
	var shot_b: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, ref_b["state"], 93)
	assert_bool(shot_a["state"]["kill_outcomes"].has(1)).is_true()
	assert_bool(shot_b["state"]["kill_outcomes"].has(1)).is_true()
	assert_bool(shot_a["state"]["kill_outcomes"].has(2)).is_false()
	assert_bool(shot_b["state"]["kill_outcomes"].has(2)).is_false()
	# Follower refresh feeds only the live subset (deterministic extract) -> identical survivor-only snapshot.
	var live_a: Array = []
	for c in shot_a["state"]["live_candidates"]:
		if bool(c.get("alive", true)):
			live_a.append(c)
	var live_b: Array = []
	for c in shot_b["state"]["live_candidates"]:
		if bool(c.get("alive", true)):
			live_b.append(c)
	assert_array(live_a).is_equal(live_b)
	var next_a: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": live_a}, shot_a["state"], 94)
	var next_b: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": live_b}, shot_b["state"], 95)
	assert_array(next_a["state"]["target_snapshot_ids"]).is_equal([2])
	assert_array(next_b["state"]["target_snapshot_ids"]).is_equal([2])


# ============================ R3 O5: kill decision-key trace tuples (diagnostics, read-only) ============================
# Independent, read-only trace tuple export of the kill decision keys (k1/k2/stable_id buckets) + tick, plus the
# candidate key trace and live-reduction count. These live in diagnostics and never mutate state/events.

# The diagnostics layer exports per-killed {stable_id, k1_bucket, k2_bucket, tick} decision-key tuples.
func test_diagnostics_kill_decision_trace_exported() -> void:
	var st0 := RULES.empty_state()
	var refresh: Dictionary = RULES.step(
		{"task": "refresh_fire", "live_candidates": [
			{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 2, "alive": true, "hp": 1},
			{"stable_id": 2, "k1_bucket": 0, "k2_bucket": 1, "alive": true, "hp": 1},
		]}, st0, 100)
	var shot: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, refresh["state"], 101)
	var d: Dictionary = shot["diagnostics"]
	var trace: Array = d["kill_decision_trace"]
	assert_array(trace).has_size(2)
	# Both killed; k1 ties -> k2 decides first (id2 k2=1 < id1 k2=2); tuples carry the decision keys + tick.
	assert_int(int(trace[0]["stable_id"])).is_equal(2)
	assert_int(int(trace[0]["k1_bucket"])).is_equal(0)
	assert_int(int(trace[0]["k2_bucket"])).is_equal(1)
	assert_int(int(trace[0]["tick"])).is_equal(101)
	assert_int(int(trace[1]["stable_id"])).is_equal(1)
	assert_int(int(trace[1]["k1_bucket"])).is_equal(0)
	assert_int(int(trace[1]["k2_bucket"])).is_equal(2)
	assert_int(int(trace[1]["tick"])).is_equal(101)
	# Live-reduction count matches the number of kills this shot.
	assert_int(int(d["live_reduction_count"])).is_equal(2)
	# Read-only: the export does not alter the state/events kill records.
	assert_bool(shot["state"]["kill_outcomes"].has(1)).is_true()
	assert_bool(shot["state"]["kill_outcomes"].has(2)).is_true()


# The diagnostics layer exports the ordered candidate key trace on refresh, and a no-kill resolve yields an empty
# kill trace + zero live reduction (read-only, deterministic).
func test_diagnostics_candidate_key_trace_and_no_kill_resolve() -> void:
	var st0 := RULES.empty_state()
	var refresh: Dictionary = RULES.step(
		{"task": "refresh_fire", "live_candidates": [
			{"stable_id": 9, "k1_bucket": 1, "k2_bucket": 3, "alive": true, "hp": 5},
			{"stable_id": 3, "k1_bucket": 0, "k2_bucket": 9, "alive": true, "hp": 5},
			{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 1, "alive": true, "hp": 5},
		]}, st0, 110)
	var d_refresh: Dictionary = refresh["diagnostics"]
	var ctr: Array = d_refresh["candidate_key_trace"]
	# Key-chain order on refresh: (0,1) -> id1, (0,9) -> id3, (1,3) -> id9.
	assert_array(ctr).has_size(3)
	assert_int(int(ctr[0]["stable_id"])).is_equal(1)
	assert_int(int(ctr[0]["k1_bucket"])).is_equal(0)
	assert_int(int(ctr[0]["k2_bucket"])).is_equal(1)
	assert_int(int(ctr[1]["stable_id"])).is_equal(3)
	assert_int(int(ctr[1]["k1_bucket"])).is_equal(0)
	assert_int(int(ctr[1]["k2_bucket"])).is_equal(9)
	assert_int(int(ctr[2]["stable_id"])).is_equal(9)
	assert_int(int(ctr[2]["k1_bucket"])).is_equal(1)
	assert_int(int(ctr[2]["k2_bucket"])).is_equal(3)
	# No kill on this resolve (hp=5, damage 1): kill trace empty, live reduction 0, state untouched hit semantics.
	var shot: Dictionary = RULES.step({"task": "resolve", "attack_max_targets": 999, "attack_damage": 1}, refresh["state"], 111)
	var d_shot: Dictionary = shot["diagnostics"]
	assert_array(d_shot["kill_decision_trace"]).is_empty()
	assert_int(int(d_shot["live_reduction_count"])).is_equal(0)
	# Invalidation/exclusion does not fabricate a kill trace entry either.
	assert_bool(shot["state"]["hit_results"].has(9)).is_true()
	assert_bool(shot["state"]["kill_outcomes"].is_empty()).is_true()
# ============================ C3 CONTACT-* fixtures (this unit) ============================
# Deterministic contact fixtures for the C2 rules-core contact extension
# (NEXT_IMPL_UNIT_PLAN_v0_3 unit B; Systems §6.3 fixture matrix; decision #4 "one legal contact = one damage event").
#   CONTACT-single            exactly one damage event; invulnerability entered; life segment deducted.
#   CONTACT-overlap           persistent overlap cannot repeat damage during invulnerability; re-arm stays false.
#   CONTACT-separate-rearm    separation re-arms; a later new overlap is exactly one NEW legal contact.
#   CONTACT-simultaneous      two overlaps in one step -> ONE damage event (merged; invulnerability swallow);
#                             Nx stacking is an explicit unresolved boundary reported here, not implemented.
#   CONTACT-boundary          boundary contact: separation + recoverability (no sticky lock).
#   CONTACT-removal           contacted victim removed during protection -> contact/rearm state cleaned; future
#                             re-arm for a new contact is legal.
# Zero-tolerance exact assertions (O2/B3); no floats/approx.
# `30` invulnerability ticks mirrors the envelope candidate default as a test-local fixture input, NOT a promoted
# rule constant (promotion_authority=User; NUMBERS NOT FROZEN).

# CONTACT-single: one eligible enemy contacts once -> exactly one damage event; segments_lost=1; invulnerability entered.
func test_contact_single_exactly_one_damage_and_invuln() -> void:
	var st0 := RULES.empty_state()
	var res: Dictionary = RULES.step({
		"task": "refresh_fire",
		"contact_input": [{"id": 3}],
		"contact_invulnerability_ticks": 30,
		"contact_damage": 1,
	}, st0, 200)
	var st: Dictionary = res["state"]
	# Exactly one damage event, carrying the victim id and the new segments_lost.
	var dmg := 0
	var invuln := 0
	for e in res["events"]:
		if e["type"] == "contact_damage_event":
			dmg += 1
			assert_int(int(e["victim_id"])).is_equal(3)
			assert_int(int(e["segments_lost"])).is_equal(1)
		elif e["type"] == "contact_invulnerable_event":
			invuln += 1
			assert_int(int(e["until_tick"])).is_equal(230)
	assert_int(dmg).is_equal(1)
	assert_int(invuln).is_equal(1)
	# Life deduction + invulnerability window + the victim is rearm-required.
	assert_int(int(st["segments_lost"])).is_equal(1)
	assert_int(int(st["contact_invulnerable_until_tick"])).is_equal(230)
	assert_bool(st["contact_rearm"].has(3)).is_true()
	assert_bool(st["contact_rearm"][3]).is_false()
	# Diagnostics export the damage.
	assert_array(res["diagnostics"]["contact_damaged"]).is_equal([3])


# CONTACT-overlap: the same pair remains overlapped -> no repeat damage during invulnerability; re-arm stays false.
func test_contact_overlap_no_repeat_damage_rearm_false() -> void:
	var st0 := RULES.empty_state()
	var env: Dictionary = {
		"task": "refresh_fire",
		"contact_input": [{"id": 4}],
		"contact_invulnerability_ticks": 30,
		"contact_damage": 1,
	}
	var first: Dictionary = RULES.step(env, st0, 210)
	assert_int(int(first["state"]["segments_lost"])).is_equal(1)
	# Next step, still overlapped, still inside invulnerability -> no second damage.
	var second: Dictionary = RULES.step(env, first["state"], 211)
	assert_int(int(second["state"]["segments_lost"])).is_equal(1)
	var dmg2 := 0
	for e in second["events"]:
		if e["type"] == "contact_damage_event":
			dmg2 += 1
	assert_int(dmg2).is_equal(0)
	# After the invulnerability window expires, persistent overlap STILL cannot repeat damage (re-arm required).
	var after_invuln: Dictionary = RULES.step(env, second["state"], 241)
	assert_int(int(after_invuln["state"]["segments_lost"])).is_equal(1)
	var dmg3 := 0
	for e in after_invuln["events"]:
		if e["type"] == "contact_damage_event":
			dmg3 += 1
	assert_int(dmg3).is_equal(0)
	# Re-arm stays false while the pair remains overlapped.
	assert_bool(after_invuln["state"]["contact_rearm"][4]).is_false()


# CONTACT-separate-rearm: pair separates then contacts again -> exactly one NEW legal event after re-arm.
func test_contact_separate_rearm_exactly_one_new_legal_event() -> void:
	var st0 := RULES.empty_state()
	var env: Dictionary = {
		"task": "refresh_fire",
		"contact_input": [{"id": 5}],
		"contact_invulnerability_ticks": 30,
		"contact_damage": 1,
	}
	var c1: Dictionary = RULES.step(env, st0, 220)
	assert_int(int(c1["state"]["segments_lost"])).is_equal(1)
	# Separation step: the victim is no longer in the overlap set -> re-arm event, rearm flips true.
	var sep: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c1["state"], 221)
	assert_bool(sep["state"]["contact_rearm"][5]).is_true()
	var rearmed := 0
	for e in sep["events"]:
		if e["type"] == "contact_rearm_event" and int(e["id"]) == 5:
			rearmed += 1
	assert_int(rearmed).is_equal(1)
	assert_array(sep["diagnostics"]["contact_rearmed"]).is_equal([5])
	# A new overlap after separation -> exactly one NEW legal damage event (segments_lost=2).
	var c2: Dictionary = RULES.step(env, sep["state"], 222)
	assert_int(int(c2["state"]["segments_lost"])).is_equal(2)
	var dmg2 := 0
	for e in c2["events"]:
		if e["type"] == "contact_damage_event":
			dmg2 += 1
	assert_int(dmg2).is_equal(1)


# CONTACT-simultaneous: two enemies contact in one step -> a SINGLE damage event (recommended default, decision #4;
# invulnerability swallows the simultaneous set). Nx stacking is an explicit unresolved boundary, reported not implemented.
func test_contact_simultaneous_single_damage_event_merged() -> void:
	var st0 := RULES.empty_state()
	var res: Dictionary = RULES.step({
		"task": "refresh_fire",
		"contact_input": [{"id": 7}, {"id": 8}],
		"contact_invulnerability_ticks": 30,
		"contact_damage": 1,
	}, st0, 230)
	var st: Dictionary = res["state"]
	# Exactly ONE damage event: the simultaneous set merges (unresolved boundary: Nx stacking is NOT implemented).
	var dmg := 0
	for e in res["events"]:
		if e["type"] == "contact_damage_event":
			dmg += 1
	assert_int(dmg).is_equal(1)
	assert_int(int(st["segments_lost"])).is_equal(1)
	# The whole simultaneous set enters rearm-required (merged/single event).
	assert_bool(st["contact_rearm"].has(7)).is_true()
	assert_bool(st["contact_rearm"].has(8)).is_true()
	assert_bool(st["contact_rearm"][7]).is_false()
	assert_bool(st["contact_rearm"][8]).is_false()


# CONTACT-boundary: contact at the arena boundary -> separation + recoverability (no sticky lock, no
# escape-through-boundary in the rules seam; the recoverable route is asserted by re-arm + a new legal contact).
func test_contact_boundary_separation_and_recoverable() -> void:
	var st0 := RULES.empty_state()
	var env: Dictionary = {
		"task": "refresh_fire",
		"contact_input": [{"id": 9}],
		"contact_invulnerability_ticks": 30,
		"contact_damage": 1,
	}
	var c1: Dictionary = RULES.step(env, st0, 240)
	assert_int(int(c1["state"]["segments_lost"])).is_equal(1)
	# Boundary separation: the victim separates -> re-arm (recoverable spacing, not a sticky lock).
	var sep: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c1["state"], 241)
	assert_bool(sep["state"]["contact_rearm"][9]).is_true()
	# Recoverability: a new overlap with the same boundary victim is a new legal contact.
	var c2: Dictionary = RULES.step(env, sep["state"], 242)
	assert_int(int(c2["state"]["segments_lost"])).is_equal(2)
	var dmg2 := 0
	for e in c2["events"]:
		if e["type"] == "contact_damage_event":
			dmg2 += 1
	assert_int(dmg2).is_equal(1)


# CONTACT-removal: contacted target removed during protection -> contact/rearm state cleaned up (no phantom rearm);
# after protection expires, a future new contact is legal again (future re-arm behavior).
func test_contact_removal_during_protection_cleans_state() -> void:
	var st0 := RULES.empty_state()
	var env: Dictionary = {
		"task": "refresh_fire",
		"contact_input": [{"id": 11}],
		"contact_invulnerability_ticks": 30,
		"contact_damage": 1,
	}
	var c1: Dictionary = RULES.step(env, st0, 250)
	assert_int(int(c1["state"]["segments_lost"])).is_equal(1)
	assert_bool(c1["state"]["contact_rearm"].has(11)).is_true()
	# The contacted victim is removed during protection: rearm/contact state is cleaned (erased, not re-armed).
	var rem: Dictionary = RULES.step({
		"task": "refresh_fire",
		"removed_ids": [11],
		"contact_input": [],
	}, c1["state"], 251)
	assert_bool(rem["state"]["contact_rearm"].has(11)).is_false()
	var phantom_rearm := 0
	for e in rem["events"]:
		if e["type"] == "contact_rearm_event":
			phantom_rearm += 1
	assert_int(phantom_rearm).is_equal(0)
	# Future re-arm behavior: after protection expires (tick 300 > until 280), a new overlap is a fresh legal contact.
	var fresh: Dictionary = RULES.step({
		"task": "refresh_fire",
		"contact_input": [{"id": 12}],
		"contact_invulnerability_ticks": 30,
		"contact_damage": 1,
	}, rem["state"], 300)
	assert_int(int(fresh["state"]["segments_lost"])).is_equal(2)
	var dmg_new := 0
	for e in fresh["events"]:
		if e["type"] == "contact_damage_event":
			dmg_new += 1
	assert_int(dmg_new).is_equal(1)


# Additive compatibility: fixtures/steps without contact_input leave contact state undisturbed (segments_lost stays 0,
# no invulnerability armed, no contact events) - the existing TARGET-*/KILL-* semantics are unchanged.
func test_contact_absent_preserves_existing_semantics() -> void:
	var st0 := RULES.empty_state()
	var res: Dictionary = RULES.step({"task": "refresh_fire"}, st0, 260)
	assert_int(int(res["state"]["segments_lost"])).is_equal(0)
	assert_int(int(res["state"]["contact_invulnerable_until_tick"])).is_equal(-1)
	assert_bool(res["state"]["contact_rearm"].is_empty()).is_true()
	var dmg := 0
	for e in res["events"]:
		if e["type"] == "contact_damage_event":
			dmg += 1
	assert_int(dmg).is_equal(0)

# ============================ T3 TERMINAL-* / RESET-* fixtures (this unit) ============================
# Deterministic terminal/result/reset fixtures for the T2 rules-core terminal extension
# (NEXT_IMPL_UNIT_PLAN_v0_4 unit 4; ADR-TECH-05 §8 same-tick terminal arbitration + canonical reset;
# decision #5 life-depletion-same-frame-priority, #11 victory=control completion, #12 defeat=light interruption).
#   TERMINAL-life-depletion-first     life depletion (segments_lost=3) takes priority over timer completion same-frame.
#   TERMINAL-victory                  control completion => victory (decision #11).
#   TERMINAL-defeat-light-interruption life depletion => defeat (decision #12, a result not a punitive screen).
#   TERMINAL-result-lock              once result_locked, no re-arbitration / no re-emitted terminal event.
#   TERMINAL-stale-input-rejected     gameplay (contact) input rejected while result locked (result/input lock).
#   RESET-auto-restart                task=="reset" re-initializes pure state, increments reset_epoch, emits reset_event.
#   RESET-no-cross-run-loss           after reset a fresh run has no stale life/rearm/snapshot/results (no out-of-run loss).
# Zero-tolerance exact assertions (O2/B3); no floats/approx. Three life segments = decision #5 product boundary
# (terminal depletion threshold 3 is the confirmed three-segment life structure, not a promoted rule constant).

# Helper: run one legal contact on a fresh/armed rearm-required victim (contact + separate to re-arm).
func _terminal_contact_armed(st: Dictionary, sid: int, tick: int, terminal_input: Dictionary = {}) -> Dictionary:
	var env: Dictionary = {
		"task": "refresh_fire",
		"contact_input": [{"id": sid}],
		"contact_invulnerability_ticks": 30,
		"contact_damage": 1,
	}
	if not terminal_input.is_empty():
		env["terminal_input"] = terminal_input
	var res: Dictionary = RULES.step(env, st, tick)
	return res


# TERMINAL-life-depletion-first: when BOTH life depletion (segments_lost=3) and timer completion occur in the SAME
# tick, life depletion arbitrates to DEFEAT (priority; decision #5 / PRECHARTER-11 / ADR-TECH-05 §8). The victory
# path (timer_completed) does NOT win because life was depleted in the same frame.
func test_terminal_life_depletion_first_same_frame() -> void:
	var st: Dictionary = RULES.empty_state()
	# Contact 1 -> segments_lost=1 (not terminal).
	var c1: Dictionary = _terminal_contact_armed(st, 21, 200)
	assert_int(int(c1["state"]["segments_lost"])).is_equal(1)
	assert_str(String(c1["state"]["terminal_outcome"])).is_equal("")
	# Separate -> re-arm.
	var sep1: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c1["state"], 201)
	assert_bool(sep1["state"]["contact_rearm"][21]).is_true()
	# Contact 2 -> segments_lost=2 (not terminal).
	var c2: Dictionary = _terminal_contact_armed(sep1["state"], 21, 202)
	assert_int(int(c2["state"]["segments_lost"])).is_equal(2)
	assert_str(String(c2["state"]["terminal_outcome"])).is_equal("")
	# Separate -> re-arm.
	var sep2: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c2["state"], 203)
	assert_bool(sep2["state"]["contact_rearm"][21]).is_true()
	# Contact 3 -> segments_lost=3 (life depletion) AND timer_completed=true in the SAME tick -> DEFEAT (life priority).
	var c3: Dictionary = _terminal_contact_armed(sep2["state"], 21, 204, {"timer_completed": true})
	assert_int(int(c3["state"]["segments_lost"])).is_equal(3)
	assert_str(String(c3["state"]["terminal_outcome"])).is_equal("defeat")
	assert_bool(c3["state"]["result_locked"]).is_true()
	assert_bool(c3["state"]["reset_pending"]).is_true()
	# Exactly one terminal_event, outcome defeat.
	var term_ev := 0
	for e in c3["events"]:
		if e["type"] == "terminal_event":
			term_ev += 1
			assert_str(String(e["outcome"])).is_equal("defeat")
	assert_int(term_ev).is_equal(1)


# TERMINAL-victory: control completion (timer_completed) with life NOT depleted => victory (decision #11).
func test_terminal_victory_control_completion() -> void:
	var st: Dictionary = RULES.empty_state()
	var res: Dictionary = RULES.step({
		"task": "refresh_fire",
		"terminal_input": {"timer_completed": true},
	}, st, 300)
	assert_int(int(res["state"]["segments_lost"])).is_equal(0)
	assert_str(String(res["state"]["terminal_outcome"])).is_equal("victory")
	assert_bool(res["state"]["result_locked"]).is_true()
	assert_bool(res["state"]["reset_pending"]).is_true()
	var got := false
	for e in res["events"]:
		if e["type"] == "terminal_event":
			got = true
			assert_str(String(e["outcome"])).is_equal("victory")
	assert_bool(got).is_true()


# TERMINAL-defeat-light-interruption: life depletion => defeat, a SHORT result with input locked (not a punitive
# screen, decision #12). Result holds across subsequent steps (result lock) until reset.
func test_terminal_defeat_light_interruption() -> void:
	var st: Dictionary = RULES.empty_state()
	# Reach segments_lost=2 without terminal, then the 3rd contact depletes life -> defeat.
	var c1: Dictionary = _terminal_contact_armed(st, 31, 310)
	var sep1: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c1["state"], 311)
	var c2: Dictionary = _terminal_contact_armed(sep1["state"], 31, 312)
	var sep2: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c2["state"], 313)
	var c3: Dictionary = _terminal_contact_armed(sep2["state"], 31, 314)
	assert_str(String(c3["state"]["terminal_outcome"])).is_equal("defeat")
	assert_bool(c3["state"]["result_locked"]).is_true()
	assert_bool(c3["state"]["reset_pending"]).is_true()
	# The defeat is a bounded result (input locked), not a punitive state: the rules state carries the clean result
	# fields and the terminal outcome; the runtime presents it, then the session drives auto-restart.
	assert_int(int(c3["diagnostics"]["segments_lost"])).is_equal(3)
	assert_str(String(c3["diagnostics"]["terminal_outcome"])).is_equal("defeat")
	assert_bool(c3["diagnostics"]["result_locked"]).is_true()


# TERMINAL-result-lock: once result_locked, no re-arbitration — a later step (even timer_completed or another
# depletion) does NOT re-emit a terminal event and does NOT change the outcome.
func test_terminal_result_lock_no_rearbitration() -> void:
	var st: Dictionary = RULES.empty_state()
	# Reach defeat.
	var c1: Dictionary = _terminal_contact_armed(st, 41, 320)
	var sep1: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c1["state"], 321)
	var c2: Dictionary = _terminal_contact_armed(sep1["state"], 41, 322)
	var sep2: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c2["state"], 323)
	var c3: Dictionary = _terminal_contact_armed(sep2["state"], 41, 324)
	assert_str(String(c3["state"]["terminal_outcome"])).is_equal("defeat")
	assert_bool(c3["state"]["result_locked"]).is_true()
	# A subsequent step with timer_completed and a depleted life must NOT re-arbitrate or re-emit.
	var later: Dictionary = RULES.step({
		"task": "refresh_fire",
		"contact_input": [{"id": 41}],
		"terminal_input": {"timer_completed": true},
	}, c3["state"], 325)
	assert_str(String(later["state"]["terminal_outcome"])).is_equal("defeat")
	assert_bool(later["state"]["result_locked"]).is_true()
	var term_ev := 0
	for e in later["events"]:
		if e["type"] == "terminal_event":
			term_ev += 1
	assert_int(term_ev).is_equal(0)


# TERMINAL-stale-input-rejected: while result_locked, gameplay (contact) input is rejected at the rules seam — no new
# contact damage, no re-arbitration. The result/input lock holds (ADR-TECH-05 / Systems §4 result/input lock).
func test_terminal_stale_input_rejected() -> void:
	var st: Dictionary = RULES.empty_state()
	# Reach defeat.
	var c1: Dictionary = _terminal_contact_armed(st, 51, 330)
	var sep1: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c1["state"], 331)
	var c2: Dictionary = _terminal_contact_armed(sep1["state"], 51, 332)
	var sep2: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c2["state"], 333)
	var c3: Dictionary = _terminal_contact_armed(sep2["state"], 51, 334)
	assert_str(String(c3["state"]["terminal_outcome"])).is_equal("defeat")
	assert_bool(c3["state"]["result_locked"]).is_true()
	# Stale gameplay contact input while result locked -> rejected (no further life deduction, no contact damage event).
	var stale: Dictionary = RULES.step({
		"task": "refresh_fire",
		"contact_input": [{"id": 999}],
		"contact_invulnerability_ticks": 30,
		"contact_damage": 1,
	}, c3["state"], 335)
	assert_int(int(stale["state"]["segments_lost"])).is_equal(3)
	assert_str(String(stale["state"]["terminal_outcome"])).is_equal("defeat")
	var dmg_rejected := 0
	for e in stale["events"]:
		if e["type"] == "contact_damage_event":
			dmg_rejected += 1
	assert_int(dmg_rejected).is_equal(0)


# RESET-auto-restart: task=="reset" re-initializes the rules-owned pure state, increments reset_epoch, emits a
# reset_event, and clears result/terminal state so a new run is eligible (automatic immediate restart path).
func test_reset_auto_restart_task() -> void:
	var st: Dictionary = RULES.empty_state()
	var c1: Dictionary = _terminal_contact_armed(st, 71, 400)
	var sep1: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c1["state"], 401)
	var c2: Dictionary = _terminal_contact_armed(sep1["state"], 71, 402)
	var sep2: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c2["state"], 403)
	var c3: Dictionary = _terminal_contact_armed(sep2["state"], 71, 404)
	assert_str(String(c3["state"]["terminal_outcome"])).is_equal("defeat")
	# Canonical automatic reset: the session issues task=="reset" after the short result.
	var reset: Dictionary = RULES.step({"task": "reset"}, c3["state"], 405)
	assert_int(int(reset["state"]["reset_epoch"])).is_equal(1)   # 0 -> 1
	assert_int(int(reset["state"]["segments_lost"])).is_equal(0)
	assert_str(String(reset["state"]["terminal_outcome"])).is_equal("")
	assert_bool(reset["state"]["result_locked"]).is_false()
	assert_bool(reset["state"]["reset_pending"]).is_false()
	assert_array(reset["state"]["target_snapshot_ids"]).is_empty()
	assert_bool(reset["state"]["contact_rearm"].is_empty()).is_true()
	# A reset_event was emitted carrying the new reset_epoch.
	var reset_ev := 0
	for e in reset["events"]:
		if e["type"] == "reset_event":
			reset_ev += 1
			assert_int(int(e["reset_epoch"])).is_equal(1)
	assert_int(reset_ev).is_equal(1)
	assert_int(int(reset["diagnostics"]["reset_epoch"])).is_equal(1)


# RESET-no-cross-run-loss: after the canonical reset, a fresh run has NO stale cross-run state — life, re-arm,
# snapshots, hit/kill results and invalidation are all clean; a new contact in the new run deducts life fresh.
func test_reset_no_cross_run_loss() -> void:
	var st: Dictionary = RULES.empty_state()
	# Reaching a life-depleted (defeat) run.
	var c1: Dictionary = _terminal_contact_armed(st, 81, 420)
	var sep1: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c1["state"], 421)
	var c2: Dictionary = _terminal_contact_armed(sep1["state"], 81, 422)
	var sep2: Dictionary = RULES.step({"task": "refresh_fire", "contact_input": []}, c2["state"], 423)
	var c3: Dictionary = _terminal_contact_armed(sep2["state"], 81, 424)
	assert_int(int(c3["state"]["segments_lost"])).is_equal(3)
	# Canonical reset clears ALL cross-run state.
	var reset: Dictionary = RULES.step({"task": "reset"}, c3["state"], 425)
	assert_bool(reset["state"]["live_candidates"].is_empty()).is_true()
	assert_bool(reset["state"]["invalidation_log"].is_empty()).is_true()
	assert_int(int(reset["state"]["segments_lost"])).is_equal(0)
	assert_bool(reset["state"]["hit_results"].is_empty()).is_true()
	assert_bool(reset["state"]["kill_outcomes"].is_empty()).is_true()
	# Fresh run: a new refresh_fire re-feeds a candidate set (no stale snapshot), then a new contact deducts life fresh.
	var fresh: Dictionary = RULES.step({
		"task": "refresh_fire",
		"live_candidates": [{"stable_id": 91, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 1}],
		"contact_input": [{"id": 91}],
		"contact_invulnerability_ticks": 30,
		"contact_damage": 1,
	}, reset["state"], 426)
	# Life starts at 0 in the new run (no carried loss); first fresh contact deducts 1.
	assert_int(int(fresh["state"]["segments_lost"])).is_equal(1)
	assert_str(String(fresh["state"]["terminal_outcome"])).is_equal("")
	assert_bool(fresh["state"]["result_locked"]).is_false()
	assert_array(fresh["state"]["target_snapshot_ids"]).is_equal([91])
	# Exactly one fresh contact damage event in the new run (no phantom / no cross-run repeat).
	var dmg := 0
	for e in fresh["events"]:
		if e["type"] == "contact_damage_event":
			dmg += 1
	assert_int(dmg).is_equal(1)


# Additive compatibility: terminal/reset are opt-in — fixtures/steps without terminal_input and without task=="reset"
# do NOT set terminal state, and a victory/defeat outcome is only produced when triggered (existing semantics intact).
func test_terminal_absent_preserves_existing_semantics() -> void:
	var st: Dictionary = RULES.empty_state()
	var res: Dictionary = RULES.step({
		"task": "refresh_fire",
		"live_candidates": [{"stable_id": 3, "k1_bucket": 1, "k2_bucket": 1, "alive": true, "hp": 1}],
		"contact_input": [{"id": 3}],
		"contact_invulnerability_ticks": 30,
		"contact_damage": 1,
	}, st, 500)
	# No terminal_input, no depletion (segments_lost=1) -> no terminal outcome, no result lock.
	assert_int(int(res["state"]["segments_lost"])).is_equal(1)
	assert_str(String(res["state"]["terminal_outcome"])).is_equal("")
	assert_bool(res["state"]["result_locked"]).is_false()
	assert_int(int(res["state"]["reset_epoch"])).is_equal(0)
	var has_terminal := false
	for e in res["events"]:
		if e["type"] == "terminal_event" or e["type"] == "reset_event":
			has_terminal = true
	assert_bool(has_terminal).is_false()

func test_arc_chain_trace_is_ordered_and_source_linked() -> void:
	var state := RULES.empty_state()
	var refresh: Dictionary = RULES.step({"task": "refresh_fire", "live_candidates": [
		{"stable_id": 30, "k1_bucket": 2, "k2_bucket": 0, "alive": true, "hp": 2},
		{"stable_id": 10, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 2},
		{"stable_id": 20, "k1_bucket": 1, "k2_bucket": 0, "alive": true, "hp": 2},
	]}, state, 10)
	var resolve: Dictionary = RULES.step({"task": "resolve", "attack_delivery": "arc_chain", "attack_max_targets": 3}, refresh["state"], 11)
	var trace: Array = []
	for event in resolve["events"]:
		if event.get("type", "") == "resolution_outcome" and event.get("delivery", "") == "arc_chain":
			trace.append(event)
	assert_int(trace.size()).is_equal(3)
	assert_int(int(trace[0]["id"])).is_equal(10)
	assert_int(int(trace[0]["hop"])).is_equal(0)
	assert_int(int(trace[0]["source_id"])).is_equal(-1)
	assert_int(int(trace[1]["id"])).is_equal(20)
	assert_int(int(trace[1]["hop"])).is_equal(1)
	assert_int(int(trace[1]["source_id"])).is_equal(10)
	assert_int(int(trace[2]["source_id"])).is_equal(20)


func test_arc_chain_invalid_first_hop_terminates_the_chain() -> void:
	var state := RULES.empty_state()
	state["target_snapshot_ids"] = [1, 2, 3]
	state["invalidation_log"] = [{"id": 1, "tick": 9}]
	var result: Dictionary = RULES.step({"task": "resolve", "attack_delivery": "arc_chain", "attack_max_targets": 3}, state, 10)
	assert_bool(result["state"]["hit_results"].is_empty()).is_true()
	var trace_count := 0
	for event in result["events"]:
		if event.get("delivery", "") == "arc_chain":
			trace_count += 1
	assert_int(trace_count).is_equal(0)


func test_direct_delivery_does_not_emit_arc_trace() -> void:
	var state := RULES.empty_state()
	state["target_snapshot_ids"] = [1]
	state["live_candidates"] = [{"stable_id": 1, "k1_bucket": 0, "k2_bucket": 0, "alive": true, "hp": 2}]
	var result: Dictionary = RULES.step({"task": "resolve", "attack_delivery": "direct", "attack_max_targets": 1}, state, 10)
	for event in result["events"]:
		assert_bool(not event.has("delivery")).is_true()
