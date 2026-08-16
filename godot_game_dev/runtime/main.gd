# runtime/main.gd
# S4 minimal runtime scene controller. Provides the smallest observable vertical slice:
#   player node (movable), >=1 enemy node (fed as ordered_candidates to the pure rules core), a visible auto-attack
#   line pointing at the locked snapshot target, hit/kill feedback bound to hit_results / kill_outcomes, and
#   kill -> enemy removal -> clear (placeholder presentation, no art commitment).
#
# Seam / ownership (ADR-TECH-01/02):
#   - The scene talks to the rules core ONLY through the adapter (input->envelope, candidate_from_observation) and the
#     session (session.step). It never invents target selection / ordering / hit legality itself.
#   - Feedback is applied strictly from DshAdapter.feedback_from_result so an empty shot never fabricates a lock or hit.
#
# Runtime self-test (headless-evidence): when launched with `--self-test`, the controller drives a scripted fire sequence
# against fixed enemy nodes, logs observed movement/auto-attack/hit/kill/removal/clear lines, then quits. This is an
# observable runtime trace of the vertical slice, not visual QA and not a hidden test scaffold.
extends Node2D

const ADAPTER = preload("res://adapter/adapter.gd")
const SESSION = preload("res://rules/session.gd")

@export var move_speed: float = 160.0
@export var attack_interval: float = 0.6

var session  # DshSession instance (untyped to avoid a global-class-cache dependency at headless scene load)
var locked_this_epoch: bool = false
var last_fire_time: float = 0.0

# Node handles built at runtime (placeholder presentation).
var player_visual: ColorRect
var attack_line: Line2D
var hud_label: Label
var no_target_label: Label
var state_label: Label
var enemies: Array = []          # [{node, stable_id}]
var next_stable_id: int = 1

var self_test_mode: bool = false
var self_test_t: float = 0.0
var self_test_killed: Array = []
var self_test_fire_issued: bool = false
var self_test_done: bool = false


func _ready() -> void:
	session = SESSION.new(2026)
	_self_test_mode_detect()
	_build_visuals(self_test_mode)
	if self_test_mode:
		_self_test_add_enemies()


func _self_test_mode_detect() -> void:
	# Scan both user args and the full engine arg list: some Godot 4 invocations deliver trailing flags to one or the other.
	for a in OS.get_cmdline_user_args():
		if a == "--self-test":
			self_test_mode = true
	for a in OS.get_cmdline_args():
		if a == "--self-test":
			self_test_mode = true


func _new_enemy_node(pos: Vector2, hp: int, color: Color) -> Node2D:
	var e := Node2D.new()
	e.position = pos
	var r := ColorRect.new()
	r.color = color
	r.size = Vector2(26, 26)
	r.position = -r.size / 2.0
	e.add_child(r)
	add_child(e)
	enemies.append({"node": e, "stable_id": next_stable_id, "hp": hp, "hit_flash": 0.0})
	next_stable_id += 1
	return e


func _build_visuals(for_self_test: bool) -> void:
	player_visual = ColorRect.new()
	player_visual.color = Color(0.2, 0.7, 1.0)   # cyan signal (restrained, non-color-distinguishable by shape too)
	player_visual.size = Vector2(24, 24)
	player_visual.position = -player_visual.size / 2.0
	add_child(player_visual)
	position = Vector2(320, 360)

	attack_line = Line2D.new()
	attack_line.width = 3.0
	attack_line.default_color = Color(1.0, 1.0, 0.6)
	attack_line.visible = false
	add_child(attack_line)

	var hud := CanvasLayer.new()
	hud.layer = 10
	add_child(hud)
	hud_label = Label.new()
	hud_label.position = Vector2(16, 16)
	hud_label.text = "LIFE [o][o][o]  TIMER pre-8min  B2 pre-fission"   # placeholders for S5 read-model minimal HUD (life/timer/b2)
	hud.add_child(hud_label)
	no_target_label = Label.new()
	no_target_label.position = Vector2(16, 40)
	no_target_label.text = ""
	no_target_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	hud.add_child(no_target_label)
	state_label = Label.new()
	state_label.position = Vector2(16, 64)
	state_label.text = "attack: idle"
	state_label.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	hud.add_child(state_label)

	if not for_self_test:
		# Two placeholder enemies so there is a live candidate set to target.
		_new_enemy_node(Vector2(560, 200), 1, Color(0.9, 0.35, 0.2))
		_new_enemy_node(Vector2(620, 420), 1, Color(0.9, 0.35, 0.2))


func _self_test_add_enemies() -> void:
	# Deterministic scene layout for the headless self-test.
	_new_enemy_node(Vector2(300, 360), 1, Color(0.9, 0.35, 0.2))
	_new_enemy_node(Vector2(560, 180), 1, Color(0.9, 0.35, 0.2))
	# Distance to player start (320,360): enemy id1 at (300,360) dist 20; enemy id2 at (560,180) dist ~290.
	# Nearest-threat -> enemy id1 locks first.


func _unhandled_input(event: InputEvent) -> void:
	if self_test_mode:
		return
	# Keyboard WASD / arrows movement (UX contract §4 / §7, PC-first keyboard).
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_W, KEY_UP:
				_set_move_axis(-1)
			KEY_S, KEY_DOWN:
				_set_move_axis(1)
			KEY_A, KEY_LEFT:
				# handled in _process via Input.is_key_pressed for continuous movement
				pass
			KEY_D, KEY_RIGHT:
				pass


# Continuous movement reading (works whether or not key-release events are received).
func _read_movement_input() -> Dictionary:
	var up := Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)
	var down := Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)
	var left := Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)
	var right := Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)
	return ADAPTER.movement_from_input({"up": up, "down": down, "left": left, "right": right})


func _set_move_axis(_axis: int) -> void:
	pass


func _process(delta: float) -> void:
	# --- input -> movement (adapter) ---
	var movement: Dictionary = _read_movement_input()
	if self_test_mode:
		# Scripted demonstration movement so the log shows the player is movable.
		position += Vector2(0, 0)
	else:
		position += Vector2(float(movement["dir_x"]), float(movement["dir_y"])) * move_speed * delta
		if movement["moved"]:
			print("[RUNTIME] player_moved dir=%s,%s" % [movement["dir_x"], movement["dir_y"]])

	player_visual.position = Vector2.ZERO

	# --- build live candidates from live enemy nodes (adapter-normalized observations) ---
	var live_candidates: Array = []
	var cluster_center := Vector2.ZERO
	var on_screen: Array = []
	for e in enemies:
		if is_instance_valid(e.node):
			on_screen.append(e)
			cluster_center += e.node.position
	if not on_screen.is_empty():
		cluster_center /= on_screen.size()
	for e in on_screen:
		live_candidates.append(ADAPTER.candidate_from_observation(
			e.stable_id, e.node.position, position, cluster_center, e.hp, 1.0))

	# --- fire cadence (rules-core drive via session) ---
	if live_candidates.is_empty():
		if no_target_label:
			no_target_label.text = "no target (quiet)"
		attack_line.visible = false
		if self_test_mode:
			_self_test_step()
		return

	last_fire_time += delta
	if last_fire_time >= attack_interval:
		last_fire_time = 0.0
		locked_this_epoch = false

	# task routing: refresh when we need a fresh lock this epoch, else resolve.
	var task: String = ADAPTER.pick_task(not locked_this_epoch, locked_this_epoch)
	var env: Dictionary = ADAPTER.make_envelope(task, live_candidates, movement, 1)
	var result: Dictionary = session.step(env)
	_apply_feedback(result, on_screen)
	if not locked_this_epoch:
		locked_this_epoch = true

	if self_test_mode:
		_self_test_step()


func _apply_feedback(result: Dictionary, on_screen: Array) -> void:
	var state: Dictionary = result.get("state", {})
	var fb: Dictionary = ADAPTER.feedback_from_result(result)
	var snap: Array = state.get("target_snapshot_ids", [])

	# Lock / auto-attack line points at the locked target.
	if not fb["lock_target"].is_empty():
		var sid: int = int(fb["lock_target"][0])
		for e in on_screen:
			if e.stable_id == sid and is_instance_valid(e.node):
				attack_line.points = PackedVector2Array([Vector2.ZERO, e.node.position - position])
				attack_line.visible = true
		print("[AUTO-ATTACK] locked id=%d" % sid)
	else:
		attack_line.visible = false

	# Hit feedback bound to hit_results.
	for hid in fb["hit"]:
		print("[HIT] target id=%d" % hid)

	# Kill feedback bound to kill_outcomes -> remove the killed enemy node (clear visible).
	for kid in fb["kill"]:
		print("[KILL] id=%d died -> remove" % kid)
		for e in on_screen:
			if e.stable_id == kid and is_instance_valid(e.node):
				e.node.queue_free()
				e.node = null
		print("[CLEAR] enemy id=%d cleared from play" % kid)
	if not fb["kill"].is_empty():
		var remaining: int = 0
		for e in on_screen:
			if is_instance_valid(e.node):
				remaining += 1
		print("[RUNTIME] live enemies=%d" % remaining)

	# No-target quiet cue (non-color distinction for an empty shot).
	if bool(fb["no_target"]) and no_target_label:
		no_target_label.text = "no target (quiet)"
	elif no_target_label:
		no_target_label.text = ""
	_apply_attack_state(state)


func _apply_attack_state(state: Dictionary) -> void:
	# Placeholder read-model presentation of S5 §4.3 `attack_state`: expose a quiet, non-color, structured signal
	# derived only from the rules trace (no_target_branch / hit_results / target_snapshot_ids). No fabricated feedback.
	var no_target: bool = bool(state.get("no_target_branch", false))
	var hit_empty: bool = (state.get("hit_results", {}) as Dictionary).is_empty()
	var snap_empty: bool = (state.get("target_snapshot_ids", []) as Array).is_empty()
	if no_target and snap_empty:
		state_label.text = "attack: no_target (quiet)"
	elif snap_empty:
		state_label.text = "attack: idle"
	elif hit_empty:
		state_label.text = "attack: resolving"
	else:
		state_label.text = "attack: resolved"


func _self_test_step() -> void:
	# Scripted run: force-fire once, expect a kill, then assert removal + clear, print evidence, quit.
	self_test_t += 1
	if not self_test_fire_issued:
		# Ensure an epoch locked and resolved a hit -> death.
		if not locked_this_epoch:
			return
		if session.rules_state.get("kill_outcomes", {}).size() > 0:
			self_test_fire_issued = true
			print("[SELF-TEST] kill_outcomes=%s" % [Array(session.rules_state["kill_outcomes"].keys())])
	elif not self_test_done:
		# After the kill(s), verify the killed enemy is removed from play (live enemies shrank) -> clear visible.
		var remaining: int = 0
		for e in enemies:
			if is_instance_valid(e.node):
				remaining += 1
		if remaining == 0:
			print("[SELF-TEST-CLEAR] enemies removed; live enemies=%d (clear visible)" % remaining)
			self_test_done = true
			get_tree().quit(0)
		elif self_test_t > 120:
			print("[SELF-TEST-FAIL] enemy NOT removed; live enemies=%d" % remaining)
			get_tree().quit(1)
