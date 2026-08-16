# runtime/main.gd
# S4 minimal runtime scene controller, v0.2 (playable-slice polish, NEXT_IMPL_UNIT_PLAN_v0_2 candidate A).
# Provides the smallest observable vertical slice:
#   player node (real keyboard movement), >=1 enemy node (fed as ordered_candidates to the pure rules core),
#   a visible auto-attack line pointing at the locked snapshot target, hit/kill feedback bound to
#   hit_results / kill_outcomes, and kill -> enemy removal -> clear (placeholder presentation, no art commitment).
#
# Seam / ownership (ADR-TECH-01/02):
#   - The scene talks to the rules core ONLY through the adapter (input->envelope, candidate_from_observation) and the
#     session (session.step). It never invents target selection / ordering / hit legality itself.
#   - Feedback is applied strictly from DshAdapter.feedback_from_result so an empty shot never fabricates a lock or hit.
#
# R1 (this unit) — real input-driven movement (formalized):
#   WASD + arrow keys (held-key polling) -> ADAPTER.movement_from_input -> carried as intent into the domain envelope
#   (make_envelope) -> engine applies displacement to the player node. The rules core never reads movement values; the
#   engine re-observes enemy positions AFTER the player has moved, so the NEXT pre-fire refresh re-locks a snapshot
#   from the moved location (ADR-TECH-04: no live retargeting within a shot; the shot's snapshot is immutable).
#   The dead `_unhandled_input` / `_set_move_axis` scaffolding of v0.1 is removed: `_read_movement_input` is now the
#   single formal movement input path.
#   Self-test mode is kept ONLY as a restricted deterministic regression (scripted zero-move + scripted fire); it is
#   explicitly NOT player-playable input evidence (a [SELF-TEST] marker is printed at start; real keyboard input is
#   observed by Independent QA through the runtime, not through this headless regression).
#
# R2 (this unit) — read-model full-field presentation (READ_MODEL_MINIMAL_FIELDS_v0_1 S5; ADR-TECH-02; UX-03 S1-S3):
#   HUD minimal face       LIFE (three segments, segments_lost structure constant 0 this unit) / TIMER
#                          (current_tick + run_duration_bound opaque) / B2 pre-fission structure placeholder.
#   attack_state           four states idle/resolving/resolved/no_target derived ONLY from rules trace fields
#                          (no_target_branch / hit_results / target_snapshot_ids).
#   kill_state             none -> killed, presented only while kill_outcomes is non-empty (settlement trace).
#   feedback binding       lock/hit/kill classes emitted only when their rule source is non-empty
#                          (target_snapshot_ids / hit_results / kill_outcomes); a [FB-BIND] log + HUD marker show the bind.
#   invalidation section   invalidation_event(id,tick) surfaced as "no hit this shot" (presentation-visible part only).
#   no-target quiet        no_target_branch => quiet form (no lock, no phantom hit); optional ONE-SHOT restrained
#                          non-color cue bound to the branch (S5 §4.2; exact presentation form NOT frozen / unresolved).
#   hint field             explicitly NOT implemented (S5 §4.4 exclusion; hint copy/trigger/effective-movement unresolved).
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
var life_label: Label
var timer_label: Label
var b2_label: Label
var state_label: Label
var kill_label: Label
var feedback_label: Label
var invalidation_label: Label
var no_target_label: Label
var enemies: Array = []          # [{node, stable_id}]
var next_stable_id: int = 1

# Read-model presentation state (presentation layer only; never a second rules authority).
var _quiet_episode_active: bool = false
var _last_presented_line: String = ""

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
		# Restricted deterministic regression marker: this is NOT player-playable input evidence.
		print("[SELF-TEST] restricted deterministic regression (scripted zero-move + scripted fire; NOT player-playable input evidence)")


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

	# --- R2 HUD minimal face (S5 §4.1 life/timer/b2) + read-model presentation lines. ---
	life_label = Label.new()
	life_label.position = Vector2(16, 12)
	life_label.text = "LIFE [o][o][o]  segments_lost=0"
	hud.add_child(life_label)

	timer_label = Label.new()
	timer_label.position = Vector2(16, 30)
	timer_label.text = "TIMER tick=0  run_bound=8min(opaque)"
	hud.add_child(timer_label)

	b2_label = Label.new()
	b2_label.position = Vector2(16, 48)
	b2_label.text = "B2 pre-fission (structure placeholder)"
	hud.add_child(b2_label)

	state_label = Label.new()
	state_label.position = Vector2(16, 66)
	state_label.text = "attack: idle"
	state_label.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	hud.add_child(state_label)

	kill_label = Label.new()
	kill_label.position = Vector2(16, 84)
	kill_label.text = "kill: none"
	hud.add_child(kill_label)

	feedback_label = Label.new()
	feedback_label.position = Vector2(16, 102)
	feedback_label.text = "feedback: - (quiet)"
	feedback_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	hud.add_child(feedback_label)

	invalidation_label = Label.new()
	invalidation_label.position = Vector2(16, 120)
	invalidation_label.text = ""
	invalidation_label.add_theme_color_override("font_color", Color(0.75, 0.75, 0.75))
	hud.add_child(invalidation_label)

	no_target_label = Label.new()
	no_target_label.position = Vector2(16, 138)
	no_target_label.text = ""
	no_target_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	hud.add_child(no_target_label)

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


# --- R1 formalized real input path: WASD + arrows, held-key polling. ---
# Continuous movement reading (works whether or not key-release events are received). This is the SINGLE movement input
# path; v0.1's `_unhandled_input`/`_set_move_axis` dead scaffolding is removed.
func _read_movement_input() -> Dictionary:
	var up := Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)
	var down := Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)
	var left := Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)
	var right := Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)
	return ADAPTER.movement_from_input({"up": up, "down": down, "left": left, "right": right})


func _process(delta: float) -> void:
	session.advance_tick()   # deterministic session tick drives the TIMER read-model field (S5 §4.1)

	# --- R1 input -> movement (adapter) ---
	var movement: Dictionary = _read_movement_input()
	if self_test_mode:
		# Restricted deterministic regression: scripted zero movement -> player displacement is deterministic no-op.
		position += Vector2(0, 0)
	else:
		position += Vector2(float(movement["dir_x"]), float(movement["dir_y"])) * move_speed * delta
		if movement["moved"]:
			# Movement causality log: position changes feed the NEXT pre-fire refresh (no live retargeting, ADR-TECH-04).
			print("[RUNTIME] player_moved dir=%s,%s player=(%.0f,%.0f)" % [movement["dir_x"], movement["dir_y"], position.x, position.y])

	player_visual.position = Vector2.ZERO

	# --- build live candidates from live enemy nodes (adapter-normalized observations; read AFTER movement) ---
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
		# Quiet no-target presentation (UX-03 S1/S2): no fabricated lock/hit; optional one-shot restrained cue.
		_enter_quiet_presentation()
		attack_line.visible = false
		if self_test_mode:
			_self_test_step()
		return

	_leave_quiet_presentation()

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


func _enter_quiet_presentation() -> void:
	# One-shot restrained non-color quiet-episode cue, bound ONLY to the no-target branch (S5 §4.2, UX-03 S3).
	# Exact presentation form is NOT frozen (unresolved); here it is a single log line + the quiet label.
	if not _quiet_episode_active:
		_quiet_episode_active = true
		print("[NO-TARGET-CUE] quiet episode begins (one-shot restrained non-color cue; bound no_target_branch)")
	if no_target_label:
		no_target_label.text = "no target (quiet)"
	# Read-model quiet face: presentation observes zero live candidates -> no_target quartile, no fabricated attack data.
	_present_read_model(session.rules_state, {}, [], true)


func _leave_quiet_presentation() -> void:
	if _quiet_episode_active:
		_quiet_episode_active = false
		if no_target_label:
			no_target_label.text = ""


func _present_read_model(state: Dictionary, fb: Dictionary, events: Array, engine_quiet: bool = false) -> void:
	# --- HUD minimal face (S5 §4.1): life/timer/b2, all existing as read-model fields, no invented values. ---
	# life: three-segment structure; segments_lost is a structural field (constant 0 this unit - no contact damage path).
	var segments_lost: int = int(state.get("segments_lost", 0))
	if life_label:
		life_label.text = "LIFE [o][o][o]  segments_lost=%d" % segments_lost
	# timer: current_tick (SESSION) + run_duration_bound opaque (value deferred to Systems; not promoted).
	if timer_label:
		timer_label.text = "TIMER tick=%d  run_bound=8min(opaque)" % session.current_tick()
	# b2: single legal value this unit = pre-fission (B2 three-arc structure kept as enum placeholder only).
	if b2_label:
		b2_label.text = "B2 pre-fission (structure placeholder)"

	# --- attack_state four states (S5 §4.3), derived ONLY from rules trace fields. ---
	var no_target_branch: bool = bool(state.get("no_target_branch", false))
	var hit_empty: bool = (state.get("hit_results", {}) as Dictionary).is_empty()
	var snap_empty: bool = (state.get("target_snapshot_ids", []) as Array).is_empty()
	var attack_text: String
	if engine_quiet or (no_target_branch and snap_empty):
		attack_text = "attack: no_target (quiet)"
	elif snap_empty:
		attack_text = "attack: idle"
	elif hit_empty:
		attack_text = "attack: resolving"
	else:
		attack_text = "attack: resolved"
	if state_label:
		state_label.text = attack_text

	# --- kill_state (S5 §4.3): none -> killed while kill_outcomes is non-empty (settlement trace). ---
	var kill_outcomes: Dictionary = state.get("kill_outcomes", {})
	var kill_text: String = "kill: killed(%d)" % kill_outcomes.size() if not kill_outcomes.is_empty() else "kill: none"
	if kill_label:
		kill_label.text = kill_text

	# --- hit_results_feedback binding marker (S5 §4.3): each feedback class is emitted ONLY when its rule source is
	#     non-empty (adapter gates lock/hit/kill); the HUD line shows the class -> source binding for auditability. ---
	var lock_count: int = (fb.get("lock_target", []) as Array).size() if fb.get("lock_target", []) is Array else 0
	var hit_count: int = (fb.get("hit", []) as Array).size() if fb.get("hit", []) is Array else 0
	var kill_count: int = (fb.get("kill", []) as Array).size() if fb.get("kill", []) is Array else 0
	var fb_text: String
	if lock_count == 0 and hit_count == 0 and kill_count == 0:
		fb_text = "feedback: - (quiet)"
	else:
		fb_text = "feedback: lock=%d hit=%d kill=%d (bound: target_snapshot_ids/hit_results/kill_outcomes)" % [lock_count, hit_count, kill_count]
	if feedback_label:
		feedback_label.text = fb_text

	# --- invalidation presentation section (S5 §4.3 visible part): "target invalid -> no hit this shot", no drain detail.
	var inv_text := ""
	for e in events:
		if e.get("type", "") == "invalidation_event":
			inv_text += "invalidation: id=%d tick=%d (no hit this shot)  " % [int(e.get("id", -1)), int(e.get("tick", -1))]
	if invalidation_label:
		invalidation_label.text = inv_text

	# Read-model change log (edge-triggered; keeps runtime logs small and deterministic).
	var line: String = "%s | %s | %s | %s" % [attack_text, kill_text, fb_text, inv_text.strip_edges()]
	if line != _last_presented_line:
		_last_presented_line = line
		print("[READ-MODEL] %s" % line)


func _apply_feedback(result: Dictionary, on_screen: Array) -> void:
	var state: Dictionary = result.get("state", {})
	var fb: Dictionary = ADAPTER.feedback_from_result(result)
	var snap: Array = state.get("target_snapshot_ids", [])
	var steps: Array = result.get("diagnostics", {}).get("steps", [])

	# Lock / auto-attack line points at the locked target.
	if not fb["lock_target"].is_empty():
		var sid: int = int(fb["lock_target"][0])
		for e in on_screen:
			if e.stable_id == sid and is_instance_valid(e.node):
				attack_line.points = PackedVector2Array([Vector2.ZERO, e.node.position - position])
				attack_line.visible = true
		print("[AUTO-ATTACK] locked id=%d" % sid)
		if "refresh_fire" in steps:
			# Movement causality (ADR-TECH-04 / UX-02 U2-B): this refresh re-observed positions AFTER movement,
			# so a moved player changes the NEXT shot's lock — the current shot's snapshot stays immutable.
			print("[LOCK-REFRESH] player=(%.0f,%.0f) lock=%s (movement re-locks NEXT refresh; current shot snapshot immutable)" % [position.x, position.y, str(snap)])
		print("[FB-BIND] lock=%s (emitted only while target_snapshot_ids non-empty)" % str(fb["lock_target"]))
	else:
		attack_line.visible = false
		if fb.get("no_target", false):
			print("[FB-BIND] no lock/hit/kill (no_target branch; quiet, no fabrication)")

	# Hit feedback bound to hit_results.
	if not fb["hit"].is_empty():
		print("[FB-BIND] hit=%s (emitted only while hit_results non-empty)" % str(fb["hit"]))
	for hid in fb["hit"]:
		print("[HIT] target id=%d" % hid)

	# Kill feedback bound to kill_outcomes -> remove the killed enemy node (clear visible).
	if not fb["kill"].is_empty():
		print("[FB-BIND] kill=%s (emitted only while kill_outcomes non-empty)" % str(fb["kill"]))
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

	# Full read-model presentation from this step's rules trace + gated feedback (R2).
	_present_read_model(state, fb, result.get("events", []))


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