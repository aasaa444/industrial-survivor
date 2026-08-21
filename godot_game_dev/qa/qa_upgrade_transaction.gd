extends Node
# QA-only upgrade transaction driver (upgrade_build_v1, P2 runtime evidence).
# Boots the REAL main scene, drives ONE complete upgrade transaction through the
# contract command choose_upgrade(index, source), observes the six steps
# (trigger/mutate/read_model/behavior/feedback/reset) from the authoritative
# state dictionaries, writes runtime-transaction-evidence-v1 JSONL rows, and
# exits 0 on pass / 1 on any assertion failure.
#
# Evidence boundary: L2 runtime transaction on the real scene; NOT visual
# acceptance (L3) and NOT a substitute for user acceptance.
#
# Args (engine args are scanned):
#   --tx-branch=choice   observe the 3-card build_choice transaction (pierce)
#   --tx-branch=upgrade  observe the single-card build_upgrade transaction (fan rank 2)
#   --tx-sha=<git sha>   stamped into every row
#   --tx-digest=<id>     staged-candidate digest stamped into every row
#   --tx-out=<path>      JSONL output path under res://qa/evidence/

const MAIN_SCENE := preload("res://scenes/main.tscn")

const PROJECT_ROOT := "D:\\Game\\New_Game\\godot_game_dev"
const CONTRACT_ID := "upgrade_build_v1"
const STEP_IDS := ["trigger", "mutate", "read_model", "behavior", "feedback", "reset"]

var main: Node
var branch: String = "choice"
var tx_sha: String = ""
var tx_digest: String = ""
var tx_out: String = ""
var tx_id: String = ""
var rows: Array = []
var failure: String = ""

# feedback/behavior observation state
var _observing: bool = false
var _transitions: Dictionary = {}
var _confirm_sfx_seen: bool = false
var _applied_sfx_seen: bool = false
var _applied_stream_seen: bool = false
var _flash_seen: bool = false


func _ready() -> void:
	_parse_args()
	tx_id = "tx-%s-%d" % [branch, int(Time.get_unix_time_from_system())]
	if tx_out == "":
		tx_out = "res://qa/evidence/upgrade_tx/%s.jsonl" % tx_id
	# Defer: root is busy setting up children during _ready; the main scene must be
	# added after the boot frame so it enters the tree cleanly.
	call_deferred("_drive")


func _parse_args() -> void:
	for a in OS.get_cmdline_user_args():
		_read_arg(a)
	for a in OS.get_cmdline_args():
		_read_arg(a)


func _read_arg(a: String) -> void:
	if a.begins_with("--tx-branch="):
		branch = a.trim_prefix("--tx-branch=")
	elif a.begins_with("--tx-sha="):
		tx_sha = a.trim_prefix("--tx-sha=")
	elif a.begins_with("--tx-digest="):
		tx_digest = a.trim_prefix("--tx-digest=")
	elif a.begins_with("--tx-out="):
		tx_out = a.trim_prefix("--tx-out=")


func _fail(reason: String) -> void:
	failure = reason
	print("[QA-TX-FAIL] " + reason)


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _wait_frames(n: int) -> void:
	for i in range(n):
		await get_tree().process_frame


func _wait_until(cond: Callable, timeout: float) -> bool:
	var elapsed: float = 0.0
	while elapsed < timeout:
		if cond.call():
			return true
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	return cond.call()


func _observe_loop() -> void:
	while _observing:
		await get_tree().process_frame
		if main == null:
			return
		var cur: int = int(main.upgrade_ui_state.get("card_state", 0))
		if _last_state != cur:
			var key: String = "%d->%d" % [_last_state, cur]
			_transitions[key] = int(_transitions.get(key, 0)) + 1
			_last_state = cur
		if main._card_confirm_sfx_player != null and main._card_confirm_sfx_player.playing:
			_confirm_sfx_seen = true
		if main._upgrade_sfx_player != null and main._upgrade_sfx_player.playing:
			_applied_sfx_seen = true
			if main._upgrade_sfx_player.stream != null and main._upgrade_sfx_player.stream.resource_path.find("upgrade_applied") >= 0:
				_applied_stream_seen = true
		if main._upgrade_confirm_flash != null and main._upgrade_confirm_flash.visible:
			_flash_seen = true


var _last_state: int = 0


func _row(step_id: String, action: String, state_delta: Dictionary, event_refs: Array, log_refs: Array) -> void:
	var row: Dictionary = {
		"schema_version": "runtime-transaction-evidence-v1",
		"contract_id": CONTRACT_ID,
		"git_sha": tx_sha,
		"candidate_staged_digest": tx_digest,
		"project_root": PROJECT_ROOT,
		"transaction_id": tx_id,
		"sequence": rows.size() + 1,
		"step_id": step_id,
		"observed_at": Time.get_datetime_string_from_system(true) + "Z",
		"tick": int(main.session.current_tick()),
		"run_id": int(main.session.run_id),
		"action": action,
		"state_delta": state_delta,
		"event_refs": event_refs,
		"log_refs": log_refs,
		"artifact_refs": [tx_out],
		"evidence_boundary": "L2 runtime transaction step on the real scene; visual/user acceptance remains separate",
		"status": "passed",
	}
	rows.append(row)
	print("[QA-TX-ROW] " + JSON.stringify(row))


func _drive() -> void:
	print("[QA-TX] boot branch=%s sha=%s digest=%s" % [branch, tx_sha, tx_digest])
	main = MAIN_SCENE.instantiate()
	get_tree().root.add_child(main)
	# Grace phase is presentation-only; energy collection starts after it ends.
	await _wait(1.4)

	if branch == "choice":
		await _drive_choice()
	elif branch == "upgrade":
		await _drive_upgrade()
	else:
		_fail("unknown branch " + branch)

	if failure != "":
		print("[QA-TX] RESULT=failed reason=%s" % failure)
		get_tree().quit(1)
		return
	if rows.size() != STEP_IDS.size() or str(rows.map(func(r): return r["step_id"])) != str(STEP_IDS):
		_fail("row sequence mismatch: %s" % str(rows.map(func(r): return r["step_id"])))
		get_tree().quit(1)
		return
	if _write_jsonl():
		print("[QA-TX] RESULT=passed rows=%d out=%s" % [rows.size(), tx_out])
		get_tree().quit(0)
	else:
		get_tree().quit(1)


func _write_jsonl() -> bool:
	var dir := tx_out.get_base_dir()
	DirAccess.make_dir_recursive_absolute(dir)
	var f := FileAccess.open(tx_out, FileAccess.WRITE)
	if f == null:
		_fail("cannot write " + tx_out)
		return false
	for row in rows:
		f.store_line(JSON.stringify(row))
	f.close()
	return true


func _xp() -> int:
	return int(main.progression_state.get("xp", 0))


func _level() -> int:
	return int(main.progression_state.get("level", 1))


func _pending() -> bool:
	return bool(main.upgrade_ui_state.get("pending", false))


func _phase() -> String:
	return String(main.upgrade_ui_state.get("phase", ""))


# --- branch A: 3-card build_choice -> pierce ---------------------------------
func _drive_choice() -> void:
	# Step 1 trigger: ONE energy core collected, XP increments exactly once.
	var xp0: int = _xp()
	main._spawn_energy_core(main.position)
	if not await _wait_until(func(): return _xp() == xp0 + 1, 3.0):
		_fail("trigger: xp did not increment (xp=%d)" % _xp())
		return
	await _wait_frames(10)
	if _xp() != xp0 + 1:
		_fail("trigger: xp drifted after collection (xp=%d)" % _xp())
		return
	_row("trigger", "energy_core_collected_xp_once", {"xp": [xp0, _xp()]},
		["[GROWTH] energy_drop", "[GROWTH] energy_collected"], ["stdout log of this run"])

	# Step 2 mutate: threshold crossing -> level 2 + build_choice window pending once.
	var to_level_2: int = int(main.XP_TO_LEVEL_2)
	for i in range(to_level_2 - 1):
		main._spawn_energy_core(main.position)
	if not await _wait_until(func(): return _pending() and _phase() == "build_choice", 3.0):
		_fail("mutate: build_choice window not pending (pending=%s phase=%s)" % [str(_pending()), _phase()])
		return
	_row("mutate", "threshold_crossing_level2_build_choice", {"level": [1, _level()], "pending": [false, true], "phase": ["", "build_choice"]},
		["[B2-UPGRADE] window opened phase=build_choice"], ["stdout log of this run"])

	# Step 3 read model: HUD + card UI reflect the authoritative state.
	await _wait(0.25)
	var hud_level: String = main.b2_label.text if main.b2_label != null else ""
	var hud_xp: String = main.xp_label.text if main.xp_label != null else ""
	var visible_cards: int = 0
	for c in main._card_nodes:
		if c.bg != null and c.bg.visible:
			visible_cards += 1
	if hud_level.find("等级 2") < 0:
		_fail("read_model: b2_label does not show level 2: '%s'" % hud_level)
		return
	if visible_cards != 3:
		_fail("read_model: expected 3 visible cards, got %d" % visible_cards)
		return
	_row("read_model", "hud_and_cards_reflect_state", {"b2_label": hud_level, "xp_label": hud_xp, "visible_cards": visible_cards},
		["growth_hud", "upgrade_ui"], ["stdout log of this run"])

	# Steps 4+5 behavior+feedback: choose pierce via the contract command; observe
	# the authoritative build mutation, the rules attack parameters, and each
	# feedback element firing exactly once (single 2->3 selection transition).
	_transitions = {}
	_confirm_sfx_seen = false
	_applied_sfx_seen = false
	_applied_stream_seen = false
	_flash_seen = false
	_last_state = int(main.upgrade_ui_state.get("card_state", 0))
	_observing = true
	var obs: Callable = _observe_loop
	obs.call_deferred()
	main.choose_upgrade(0, "qa")
	if not await _wait_until(func(): return not _pending(), 8.0):
		_observing = false
		_fail("behavior: window did not close after choose_upgrade")
		return
	await _wait_frames(2)
	_observing = false
	var build: Dictionary = main.build_state
	if String(build.get("active_build", "")) != "pierce" or int(build.get("rank", 0)) != 1 or not bool(build.get("enabled", {}).get("pierce", false)):
		_fail("behavior: build_state after choose = %s" % JSON.stringify(build))
		return
	var max_targets: int = int(main.session.rules_state.get("attack_max_targets", 1))
	if max_targets != 3:
		_fail("behavior: rules attack_max_targets=%d expected 3" % max_targets)
		return
	_row("behavior", "choose_upgrade_0_qa_pierce_rank1", {"active_build": ["", "pierce"], "rank": [0, 1], "attack_max_targets": [1, max_targets]},
		["[B2-UPGRADE] applied phase=pierce"], ["stdout log of this run"])

	var sel_count: int = int(_transitions.get("2->3", 0))
	if sel_count != 1 or int(_transitions.get("3->4", 0)) != 1 or int(_transitions.get("4->5", 0)) != 1 or int(_transitions.get("5->0", 0)) != 1:
		_fail("feedback: card phase transitions not each-once: %s" % JSON.stringify(_transitions))
		return
	if not (_confirm_sfx_seen and _applied_sfx_seen and _applied_stream_seen and _flash_seen):
		_fail("feedback: flags confirm=%s applied=%s applied_stream=%s flash=%s" % [str(_confirm_sfx_seen), str(_applied_sfx_seen), str(_applied_stream_seen), str(_flash_seen)])
		return
	_row("feedback", "selection_and_application_each_once", {"transitions": _transitions, "confirm_sfx": true, "applied_sfx": true, "applied_stream": "upgrade_applied", "confirm_flash": true},
		["card_confirm_sfx", "upgrade_applied_sfx", "upgrade_confirm_flash"], ["stdout log of this run"])

	# Step 6 reset: canonical restart command clears progression/build/UI and advances run identity.
	_reset_step([xp0, "pierce"])


# --- branch B: single-card build_upgrade -> fan rank 2 ------------------------
func _drive_upgrade() -> void:
	# Setup (not evidenced): first build = fan via the same contract command.
	for i in range(int(main.XP_TO_LEVEL_2)):
		main._spawn_energy_core(main.position)
	if not await _wait_until(func(): return _pending() and _phase() == "build_choice", 3.0):
		_fail("setup: build_choice window not pending")
		return
	if not await _wait_until(func(): return int(main.upgrade_ui_state.get("card_state", 0)) == 2, 3.0):
		_fail("setup: card window never reached inspection")
		return
	main.choose_upgrade(1, "qa")
	if not await _wait_until(func(): return not _pending(), 8.0):
		_fail("setup: window did not close")
		return
	if String(main.build_state.get("active_build", "")) != "fan" or int(main.build_state.get("rank", 0)) != 1:
		_fail("setup: fan rank1 not established: %s" % JSON.stringify(main.build_state))
		return

	# Step 1 trigger: one more core collected exactly once.
	var xp0: int = _xp()
	main._spawn_energy_core(main.position)
	if not await _wait_until(func(): return _xp() == xp0 + 1, 3.0):
		_fail("trigger: xp did not increment (xp=%d)" % _xp())
		return
	await _wait_frames(10)
	if _xp() != xp0 + 1:
		_fail("trigger: xp drifted after collection (xp=%d)" % _xp())
		return
	_row("trigger", "energy_core_collected_xp_once", {"xp": [xp0, _xp()]},
		["[GROWTH] energy_drop", "[GROWTH] energy_collected"], ["stdout log of this run"])

	# Step 2 mutate: cross to level 3 -> single-card build_upgrade window.
	var to_level_3: int = int(main.XP_TO_LEVEL_3)
	for i in range(to_level_3 - _xp() + 2):
		main._spawn_energy_core(main.position)
	if not await _wait_until(func(): return _pending() and _phase() == "build_upgrade", 3.0):
		_fail("mutate: build_upgrade window not pending (pending=%s phase=%s)" % [str(_pending()), _phase()])
		return
	_row("mutate", "threshold_crossing_level3_build_upgrade", {"level": [2, _level()], "pending": [false, true], "phase": ["", "build_upgrade"]},
		["[B2-UPGRADE] window opened phase=build_upgrade"], ["stdout log of this run"])

	# Step 3 read model: level-3 HUD + exactly ONE visible card.
	await _wait(0.25)
	var hud_level: String = main.b2_label.text if main.b2_label != null else ""
	var visible_cards: int = 0
	for c in main._card_nodes:
		if c.bg != null and c.bg.visible:
			visible_cards += 1
	if hud_level.find("等级 3") < 0:
		_fail("read_model: b2_label does not show level 3: '%s'" % hud_level)
		return
	if visible_cards != 1:
		_fail("read_model: expected 1 visible card, got %d" % visible_cards)
		return
	_row("read_model", "hud_and_single_card_reflect_state", {"b2_label": hud_level, "visible_cards": visible_cards},
		["growth_hud", "upgrade_ui"], ["stdout log of this run"])

	# Steps 4+5 behavior+feedback: single-card rank upgrade via the contract command.
	_transitions = {}
	_confirm_sfx_seen = false
	_applied_sfx_seen = false
	_applied_stream_seen = false
	_flash_seen = false
	_last_state = int(main.upgrade_ui_state.get("card_state", 0))
	_observing = true
	var obs2: Callable = _observe_loop
	obs2.call_deferred()
	main.choose_upgrade(0, "qa")
	if not await _wait_until(func(): return not _pending(), 8.0):
		_observing = false
		_fail("behavior: window did not close after choose_upgrade")
		return
	await _wait_frames(2)
	_observing = false
	var build: Dictionary = main.build_state
	if String(build.get("active_build", "")) != "fan" or int(build.get("rank", 0)) != 2:
		_fail("behavior: fan rank2 not reached: %s" % JSON.stringify(build))
		return
	_row("behavior", "choose_upgrade_0_qa_fan_rank2", {"rank": [1, 2], "fan_arcs_stay": 3},
		["[B2-UPGRADE] applied phase=fan"], ["stdout log of this run"])

	var sel_count: int = int(_transitions.get("2->3", 0))
	if sel_count != 1 or int(_transitions.get("3->4", 0)) != 1 or int(_transitions.get("4->5", 0)) != 1 or int(_transitions.get("5->0", 0)) != 1:
		_fail("feedback: card phase transitions not each-once: %s" % JSON.stringify(_transitions))
		return
	if not (_confirm_sfx_seen and _applied_sfx_seen and _applied_stream_seen and _flash_seen):
		_fail("feedback: flags confirm=%s applied=%s applied_stream=%s flash=%s" % [str(_confirm_sfx_seen), str(_applied_sfx_seen), str(_applied_stream_seen), str(_flash_seen)])
		return
	_row("feedback", "selection_and_application_each_once", {"transitions": _transitions, "confirm_sfx": true, "applied_sfx": true, "applied_stream": "upgrade_applied", "confirm_flash": true},
		["card_confirm_sfx", "upgrade_applied_sfx", "upgrade_confirm_flash"], ["stdout log of this run"])

	_reset_step([xp0, "fan"])


func _reset_step(_unused: Array) -> void:
	var run_before: int = int(main.session.run_id)
	var xp_before: int = _xp()
	var level_before: int = _level()
	var build_before: String = String(main.build_state.get("active_build", ""))
	main._auto_restart()
	var prog: Dictionary = main.progression_state
	var build: Dictionary = main.build_state
	var ui: Dictionary = main.upgrade_ui_state
	if int(prog.get("xp", -1)) != 0 or int(prog.get("level", 0)) != 1:
		_fail("reset: progression not cleared: %s" % JSON.stringify(prog))
		return
	if String(build.get("active_build", "x")) != "" or int(build.get("rank", -1)) != 0:
		_fail("reset: build not cleared: %s" % JSON.stringify(build))
		return
	var enabled: Dictionary = build.get("enabled", {})
	if bool(enabled.get("pierce", true)) or bool(enabled.get("fan", true)) or bool(enabled.get("pulse", true)):
		_fail("reset: build enabled flags not cleared: %s" % JSON.stringify(enabled))
		return
	if bool(ui.get("pending", true)) or int(ui.get("card_state", -1)) != 0:
		_fail("reset: upgrade UI not cleared: %s" % JSON.stringify(ui))
		return
	var run_after: int = int(main.session.run_id)
	if run_after != run_before + 1:
		_fail("reset: run identity did not advance: %d -> %d" % [run_before, run_after])
		return
	if int(main.session.rules_state.get("segments_lost", -1)) != 0:
		_fail("reset: cross-run loss: segments_lost=%d" % int(main.session.rules_state.get("segments_lost", -1)))
		return
	_row("reset", "canonical_reset_state_cleared_run_identity_advanced",
		{"xp": [xp_before, 0], "level": [level_before, 1], "active_build": [build_before, ""], "run_id": [run_before, run_after]},
		["[TERMINAL-AUTO-RESTART] canonical reset"], ["stdout log of this run"])
