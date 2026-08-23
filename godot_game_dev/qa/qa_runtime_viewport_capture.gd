extends Node
# QA-only state-bound viewport capture for CR-TOOLING-001.
# It instantiates the real main scene, drives a deterministic Arc Coil moment through
# the public command, records authoritative state, and saves the game's own viewport.
# This proves state+rendering only; native-window evidence is produced separately.

const MAIN_SCENE := preload("res://scenes/main.tscn")
const PROJECT_ROOT := "D:\\Game\\New_Game\\godot_game_dev"

var main: Node
var transaction_id: String = ""
var candidate_identity: Dictionary = {}
var candidate_identity_file: String = ""
var capture_profile: String = "arc-coil"
var output_dir: String = ""
var failure: String = ""

func _ready() -> void:
	for a in OS.get_cmdline_user_args() + OS.get_cmdline_args():
		if a.begins_with("--capture-tx="): transaction_id = a.trim_prefix("--capture-tx=")
		elif a.begins_with("--capture-identity-file="): candidate_identity_file = a.trim_prefix("--capture-identity-file=")
		elif a.begins_with("--capture-profile="): capture_profile = a.trim_prefix("--capture-profile=")
		elif a.begins_with("--capture-out="): output_dir = a.trim_prefix("--capture-out=")
	if candidate_identity_file == "":
		_fail("candidate identity file missing")
		_finish()
		return
	var identity_file := FileAccess.open(candidate_identity_file, FileAccess.READ)
	if identity_file == null:
		_fail("candidate identity file unreadable")
		_finish()
		return
	var parsed_identity = JSON.parse_string(identity_file.get_as_text())
	if not (parsed_identity is Dictionary) or str(parsed_identity.get("working_tree_sha256", "")) == "":
		_fail("candidate identity invalid")
		_finish()
		return
	candidate_identity = parsed_identity
	if transaction_id == "": transaction_id = "capture-%d" % int(Time.get_unix_time_from_system())
	if output_dir == "": output_dir = "res://qa/evidence/runtime_capture/%s" % transaction_id
	call_deferred("_drive")

func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _wait_until(cond: Callable, timeout_s: float) -> bool:
	var elapsed := 0.0
	while elapsed < timeout_s:
		if cond.call(): return true
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	return cond.call()

func _fail(reason: String) -> void:
	failure = reason
	print("[PAIRED-CAPTURE-FAIL] " + reason)

func _drive() -> void:
	if capture_profile != "arc-coil":
		_fail("unsupported capture profile: %s" % capture_profile)
		_finish()
		return
	main = MAIN_SCENE.instantiate()
	get_tree().root.add_child(main)
	await _wait(0.2)
	main._start_game()
	await _wait(1.3)
	for i in range(int(main.XP_TO_LEVEL_2)):
		main._spawn_energy_core(main.position)
	if not await _wait_until(func(): return bool(main.upgrade_ui_state.get("pending", false)) and int(main.upgrade_ui_state.get("card_state", 0)) == 2, 4.0):
		_fail("build choice did not reach inspection")
		_finish()
		return
	# The approved initial offer puts Arc Coil in the third visible card slot.
	main.choose_upgrade(2, "qa_capture")
	if not await _wait_until(func(): return not bool(main.upgrade_ui_state.get("pending", false)) and String(main.build_state.get("weapon_id", "")) == "arc_coil", 5.0):
		_fail("arc coil build was not applied")
		_finish()
		return
	for offset in [Vector2(90, 0), Vector2(138, 32), Vector2(178, -18)]:
		main._new_enemy_node(main.position + offset, 3, Color(0.9, 0.35, 0.2), "walker")
	if not await _wait_until(func(): return main._last_arc_coil_trace.size() >= 2 and main._arc_coil_vfx_nodes.size() >= 2, 5.0):
		_fail("arc coil chain did not produce hop trace and VFX")
		_finish()
		return
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	_write_artifacts()
	_finish()

func _write_artifacts() -> void:
	var absolute_dir := ProjectSettings.globalize_path(output_dir)
	DirAccess.make_dir_recursive_absolute(absolute_dir)
	var png_path := absolute_dir.path_join("viewport.png")
	var texture := get_viewport().get_texture()
	if texture == null:
		_fail("viewport texture unavailable; capture requires a rendered window")
		return
	var image := texture.get_image()
	if image == null or image.is_empty():
		_fail("viewport image unavailable or empty")
		return
	var save_error := image.save_png(png_path)
	if save_error != OK:
		_fail("viewport png save failed: %d" % save_error)
		return
	var alive := 0
	for e in main.enemies:
		if is_instance_valid(e.node): alive += 1
	var snapshot := {
		"schema_version": "runtime-viewport-state-v1",
		"capture_id": transaction_id + ":viewport",
		"transaction_id": transaction_id,
		"candidate_identity": candidate_identity,
		"project_root": PROJECT_ROOT,
		"scenario": "arc_coil_chain",
		"state": "arc_coil_chain_active",
		"action": "qa_capture choose_upgrade(2) -> three nearby walkers",
		"tick": int(main.session.current_tick()),
		"run_id": int(main.session.run_id),
		"progression": main.progression_state.duplicate(),
		"build": main.build_state.duplicate(),
		"upgrade_ui": main.upgrade_ui_state.duplicate(),
		"alive_enemies": alive,
		"camera_position": {"x": main.position.x, "y": main.position.y},
		"recent_input": "qa_capture",
		"arc_coil_trace": main._last_arc_coil_trace.duplicate(true),
		"arc_coil_vfx_nodes": main._arc_coil_vfx_nodes.size(),
		"viewport_png": png_path,
		"proves": "authoritative Arc Coil chain trace and Godot viewport rendering on the same frame",
		"does_not_prove": "desktop window foreground, title, rect, or player-visible OS composition",
		"evidence_boundary": "L2 state + internal render frame; native window layer required separately"
	}
	var f := FileAccess.open(absolute_dir.path_join("state.json"), FileAccess.WRITE)
	f.store_string(JSON.stringify(snapshot, "\t"))
	f.close()
	print("[PAIRED-CAPTURE] state=passed tx=%s png=%s" % [transaction_id, png_path])

func _finish() -> void:
	if failure != "":
		print("[PAIRED-CAPTURE] RESULT=failed")
		get_tree().quit(1)
	else:
		print("[PAIRED-CAPTURE] RESULT=passed")
		get_tree().quit(0)
