extends Node
# QA-only six-minute full-loop observer (P4 evidence).
# Boots the REAL main scene with QA auto-select, watches the whole run without
# touching production state, records pacing/perf/terminal observations, then
# drives the canonical restart command and verifies the fresh-run state.

const MAIN_SCENE := preload("res://scenes/main.tscn")

var main: Node
var run_sha: String = ""
var select_idx: int = 1
var started_at: float = 0.0
var seen_waves: int = 0
var seen_upgrades: int = 0
var peak_alive: int = 0
var min_fps: float = 1e9
var perf_samples: int = 0
var record: Dictionary = {"schema_version": "p4-six-minute-v1", "status": "failed"}


func _ready() -> void:
	for a in OS.get_cmdline_user_args() + OS.get_cmdline_args():
		if a.begins_with("--run-sha="):
			run_sha = a.trim_prefix("--run-sha=")
		if a.begins_with("--qa-select="):
			select_idx = clampi(int(a.trim_prefix("--qa-select=")), 0, 2)
	_observe()


func _ready_main() -> void:
	main = MAIN_SCENE.instantiate()
	get_tree().root.add_child.call_deferred(main)


func _observe() -> void:
	await get_tree().process_frame
	main = MAIN_SCENE.instantiate()
	get_tree().root.add_child(main)
	main.qa_auto_select = true
	main.qa_select_index = select_idx
	started_at = Time.get_ticks_msec() / 1000.0
	print("[SIX-MIN] start sha=%s select=%d" % [run_sha, select_idx])
	var in_result: bool = false
	var outcome: String = ""
	while not in_result:
		await get_tree().create_timer(1.0).timeout
		if main == null:
			record["error"] = "main scene gone"
			break
		in_result = bool(main._in_result)
		outcome = String(main._result_state)
		var alive: int = 0
		for e in main.enemies:
			if is_instance_valid(e.node):
				alive += 1
		peak_alive = maxi(peak_alive, alive)
		var fps: float = Engine.get_frames_per_second()
		min_fps = minf(min_fps, fps)
		perf_samples += 1
		if perf_samples % 30 == 0:
			print("[SIX-MIN] t=%.0fs tick=%d alive=%d peak=%d fps=%.0f level=%d xp=%d kills=%d build=%s rank=%d" % [
				Time.get_ticks_msec() / 1000.0 - started_at, int(main.session.current_tick()), alive, peak_alive, fps,
				int(main.progression_state.get("level", 1)), int(main.progression_state.get("xp", 0)),
				int(main.run_kills), String(main.build_state.get("active_build", "")), int(main.build_state.get("rank", 0))])
	if outcome == "":
		_finish_failed("no terminal outcome before timeout")
		return
	var elapsed: float = Time.get_ticks_msec() / 1000.0 - started_at
	record["outcome"] = outcome
	record["elapsed_s"] = elapsed
	record["final_tick"] = int(main.session.current_tick())
	record["level"] = int(main.progression_state.get("level", 1))
	record["kills"] = int(main.run_kills)
	record["build"] = String(main.build_state.get("active_build", ""))
	record["rank"] = int(main.build_state.get("rank", 0))
	record["segments_lost"] = int(main.session.rules_state.get("segments_lost", 0))
	record["peak_alive"] = peak_alive
	record["min_fps"] = min_fps
	record["run_sha"] = run_sha
	print("[SIX-MIN] terminal outcome=%s elapsed=%.1fs tick=%d level=%d kills=%d build=%s rank=%d segments_lost=%d peak_alive=%d min_fps=%.0f" % [
		outcome, elapsed, record["final_tick"], record["level"], record["kills"], record["build"], record["rank"], record["segments_lost"], peak_alive, min_fps])
	# Canonical restart (same command the R key dispatches) + fresh-run verification.
	var run_before: int = int(main.session.run_id)
	await get_tree().create_timer(1.0).timeout
	main._auto_restart()
	await get_tree().create_timer(1.0).timeout
	var fresh_ok: bool = int(main.progression_state.get("xp", -1)) == 0 and int(main.progression_state.get("level", 0)) == 1 \
		and String(main.build_state.get("active_build", "x")) == "" and int(main.session.run_id) == run_before + 1 \
		and not bool(main.upgrade_ui_state.get("pending", true)) and int(main.run_kills) == 0
	record["restart_clean"] = fresh_ok
	print("[SIX-MIN] restart run_id=%d->%d clean=%s" % [run_before, int(main.session.run_id), str(fresh_ok)])
	record["status"] = "passed" if fresh_ok else "failed"
	print("[SIX-MIN] RESULT=%s" % record["status"])
	get_tree().quit(0 if fresh_ok else 1)


func _finish_failed(reason: String) -> void:
	record["error"] = reason
	print("[SIX-MIN] RESULT=failed reason=%s" % reason)
	get_tree().quit(1)
