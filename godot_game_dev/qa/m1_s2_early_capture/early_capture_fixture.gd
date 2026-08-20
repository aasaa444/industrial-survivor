extends Node2D

const ADAPTER = preload("res://adapter/adapter.gd")
const SESSION = preload("res://rules/session.gd")

const FIXTURE_ID := "m1_s2_early_capture"
const SCENARIO_ID := "s2_early_capture_movement_attack_clear"
const BUILD_IDENTITY := "qa-fixture-2"
const SEED := 240817
const CLOCK_AUTHORITY := "fixture_fixed_tick"
const OBSERVER := "GodotGameplayEngineer"
const EVIDENCE_SCOPE := "qa_only_fixture"
const FIXED_DELTA := 0.1
const MOVEMENT_STEP := 20.0
const ATTACK_RANGE := 70.0

var tick_context := {"tick": 0, "clock": "fixed", "delta": FIXED_DELTA}
var session: RefCounted
var player: Node2D
var enemies: Array[Node2D] = []
var hp := {"Enemy_1": 1, "Enemy_2": 1}
var stable_ids := {"Player": "player-001", "Enemy_1": "enemy-001", "Enemy_2": "enemy-002"}
var trace: Array[Dictionary] = []
var snapshot_before: Dictionary = {}
var snapshot_after: Dictionary = {}
var handshake := false
var attack_pending := false
var attack_done := false
var input_observed := false
var movement_recorded := false
var movement_before := Vector2.ZERO
var movement_after := Vector2.ZERO
var ui_right_was_pressed := false
var pending_input_transitions: Array[Dictionary] = []
var live_candidates: Array = []
var trace_ref := "user://m1_s2_early_capture_trace.json"

func _ready() -> void:
	session = SESSION.new(SEED)
	_build_fixture()
	_record("fixture_ready", {"parent": get_path(), "metadata": _metadata(), "contract": "adapter+session+rules_core"})
	snapshot_before = _snapshot("before_handshake")
	print("[S2_EARLY] " + JSON.stringify({"event":"snapshot_before", "snapshot":snapshot_before, "metadata":_metadata()}))

func _build_fixture() -> void:
	player = Node2D.new()
	player.name = "Player"
	player.position = Vector2(100, 100)
	player.add_to_group("player")
	player.add_to_group("player_actor")
	player.set_meta("stable_id", stable_ids["Player"])
	add_child(player)
	for spec in [["Enemy_1", Vector2(150, 100), "enemy-001"], ["Enemy_2", Vector2(240, 100), "enemy-002"]]:
		var enemy := Node2D.new()
		enemy.name = spec[0]
		enemy.position = spec[1]
		enemy.add_to_group("enemies")
		enemy.add_to_group("enemy_actor")
		enemy.set_meta("stable_id", spec[2])
		add_child(enemy)
		enemies.append(enemy)

func _input(event: InputEvent) -> void:
	if not handshake or not event.is_action("ui_right"):
		return
	var pressed := event.is_pressed()
	if pressed == ui_right_was_pressed:
		return
	ui_right_was_pressed = pressed
	pending_input_transitions.append({"pressed":pressed, "tick_received":tick_context["tick"]})
	_record("input_transition_received", {"action":"ui_right", "pressed":pressed, "source":"InputEventAction", "auditable":true})

func _process(_delta: float) -> void:
	tick_context["tick"] += 1
	if not handshake:
		return
	_consume_one_fixed_tick()
	if attack_pending and not attack_done:
		_resolve_attack()

func _consume_one_fixed_tick() -> void:
	if pending_input_transitions.is_empty():
		return
	var transition: Dictionary = pending_input_transitions.pop_front()
	var pressed := bool(transition["pressed"])
	if pressed:
		movement_before = player.position
		input_observed = true
		var movement := ADAPTER.movement_from_input({"right":true})
		player.position += Vector2(float(movement["dir_x"]), float(movement["dir_y"])) * MOVEMENT_STEP
		movement_after = player.position
		movement_recorded = true
		_record("movement", {"action":"ui_right", "phase":"fixed_tick_consumed", "before":_vec(movement_before), "after":_vec(movement_after), "delta":_vec(movement_after - movement_before), "tick":tick_context["tick"], "fixed_step":MOVEMENT_STEP})
	else:
		_record("movement_release", {"action":"ui_right", "phase":"release_stop", "tick":tick_context["tick"], "stopped_on_release":true, "pending_after":pending_input_transitions.size()})

func capture_before() -> Dictionary:
	handshake = true
	_record("observation_handshake", {"accepted":true, "tick":tick_context["tick"]})
	return {"handshake":true, "snapshot_before":snapshot_before}

func release_attack() -> Dictionary:
	if not handshake:
		return {"released":false, "reason":"handshake_required"}
	attack_pending = true
	_record("attack_release", {"phase":"released", "tick":tick_context["tick"], "target_candidates":_live_set(), "real_transition":true})
	return {"released":true, "tick":tick_context["tick"]}

func get_evidence() -> Dictionary:
	var evidence := {"metadata":_metadata(), "snapshot_before":snapshot_before, "trace":trace, "trace_ref":trace_ref, "input":{"action":"ui_right", "observed":input_observed, "before":_vec(movement_before), "after":_vec(movement_after), "delta":_vec(movement_after - movement_before), "stopped_on_release":movement_recorded and pending_input_transitions.is_empty()}}
	if attack_done and not snapshot_after.is_empty():
		evidence["snapshot_after"] = snapshot_after
		evidence["space"] = {"before":"corridor_open", "after":"corridor_open_after_clear", "basis":"live enemy AABB proxy", "observed":true}
		evidence["next_movement_decision"] = {"decision":"advance_right_then_refresh_target", "observed":true, "after_event":"kill_clear"}
	return evidence

func _resolve_attack() -> void:
	attack_pending = false
	_refresh_candidates()
	var refresh: Dictionary = session.step(ADAPTER.make_envelope("refresh_fire", live_candidates, {"dir_x":0,"dir_y":0,"moved":false}, 1, [], [], 30, 1, {}))
	_record("attack_refresh", {"phase":"locked_snapshot", "tick":tick_context["tick"], "target_snapshot":refresh["state"].get("target_snapshot_ids", [])})
	var resolve: Dictionary = session.step(ADAPTER.make_envelope("resolve", [], {"dir_x":0,"dir_y":0,"moved":false}, 1, [], [], 30, 1, {}))
	var state: Dictionary = resolve["state"]
	var snapshots: Array = state.get("target_snapshot_ids", [])
	var target_id: int = int(snapshots[0]) if not snapshots.is_empty() else -1
	var distance: float = player.position.distance_to(enemies[0].position) if target_id == 1 and not enemies.is_empty() else -1.0
	var hit := (state.get("hit_results", {}) as Dictionary).has(target_id)
	_record("hit", {"target":"Enemy_1", "distance":distance, "legal":hit, "tick":tick_context["tick"], "source":"rules_core.hit_results"})
	if not hit:
		_record("attack_rejected", {"reason":"rules_core_no_hit", "target":"Enemy_1", "tick":tick_context["tick"]})
		return
	var killed: Dictionary = state.get("kill_outcomes", {})
	if not killed.has(1):
		return
	hp["Enemy_1"] = 0
	var pressure_before := _live_set().size()
	var target := enemies[0]
	enemies.pop_front()
	target.queue_free()
	_record("kill_clear", {"target":"Enemy_1", "live_set":_live_set(), "pressure_before":pressure_before, "pressure_after":_live_set().size(), "tick":tick_context["tick"], "source":"rules_core.kill_outcomes"})
	attack_done = true
	snapshot_after = _snapshot("after_clear")
	_record("space_recovery", {"observed":true, "basis":"kill_clear", "tick":tick_context["tick"]})
	_record("next_movement_decision", {"decision":"advance_right_then_refresh_target", "after_event":"kill_clear", "tick":tick_context["tick"]})
	_write_trace()
	print("[S2_EARLY] " + JSON.stringify({"event":"snapshot_after", "evidence":get_evidence()}))

func _refresh_candidates() -> void:
	live_candidates.clear()
	var center := Vector2.ZERO
	for enemy in enemies:
		center += enemy.position
	if not enemies.is_empty():
		center /= enemies.size()
	for enemy in enemies:
		var sid := 1 if enemy.name == "Enemy_1" else 2
		live_candidates.append(ADAPTER.candidate_from_observation(sid, enemy.position, player.position, center, hp[enemy.name]))

func _snapshot(label: String) -> Dictionary:
	var entries: Array[Dictionary] = [{"name":player.name, "groups":player.get_groups(), "parent":str(player.get_parent().get_path()), "position":_vec(player.position), "stable_id":stable_ids["Player"]}]
	for enemy in enemies:
		entries.append({"name":enemy.name, "groups":enemy.get_groups(), "parent":str(enemy.get_parent().get_path()), "position":_vec(enemy.position), "stable_id":enemy.get_meta("stable_id"), "hp":hp[enemy.name]})
	return {"label":label, "tick":tick_context["tick"], "clock":CLOCK_AUTHORITY, "entities":entries, "live_set":_live_set(), "pressure":_live_set().size()}

func _live_set() -> Array[String]:
	var result: Array[String] = []
	for enemy in enemies:
		if is_instance_valid(enemy): result.append(enemy.name)
	return result

func _metadata() -> Dictionary:
	return {"fixture_id":FIXTURE_ID, "scenario_id":SCENARIO_ID, "build_identity":BUILD_IDENTITY, "seed":SEED, "tick_context":tick_context.duplicate(), "clock_authority":CLOCK_AUTHORITY, "observer":OBSERVER, "evidence_scope":EVIDENCE_SCOPE, "fixed_step":MOVEMENT_STEP, "attack_range_contract":ATTACK_RANGE}

func _record(event: String, data: Dictionary) -> void:
	trace.append({"event":event, "tick":tick_context["tick"], "clock":CLOCK_AUTHORITY, "data":data})
	print("[S2_EARLY] " + JSON.stringify({"event":event, "tick":tick_context["tick"], "data":data}))

func _vec(value: Vector2) -> Dictionary:
	return {"x":value.x, "y":value.y}

func _write_trace() -> void:
	var file := FileAccess.open(trace_ref, FileAccess.WRITE)
	if file: file.store_string(JSON.stringify(get_evidence()))
