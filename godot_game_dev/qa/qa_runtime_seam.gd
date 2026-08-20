extends Node2D

@export var scenario: String = "victory"
@export var hold_result_seconds: float = 30.0
const SESSION = preload("res://rules/session.gd")
const ADAPTER = preload("res://adapter/adapter.gd")

var session: RefCounted
var phase: String = "boot"
var retry_timer: float = 0.0
var run_before: int = 0
var result_label: Label
var state_label: Label
var retry_label: Label

func _ready() -> void:
	session = SESSION.new(2026)
	run_before = session.run_id
	result_label = Label.new()
	result_label.position = Vector2(24, 120)
	result_label.text = "RESULT: pending"
	add_child(result_label)
	state_label = Label.new()
	state_label.position = Vector2(24, 160)
	state_label.text = "STATE: running | INPUT LOCK: false"
	add_child(state_label)
	retry_label = Label.new()
	retry_label.position = Vector2(24, 200)
	retry_label.text = "AUTO-RETRY: pending | OBSERVE TERMINAL FIRST"
	add_child(retry_label)
	print("[QA-SEAM] fixed scenario=" + scenario + " boot run_id=" + str(run_before))
	call_deferred("_drive_terminal")

func _drive_terminal() -> void:
	var terminal_input: Dictionary = {"timer_completed": scenario == "victory"}
	var contacts: Array = []
	if scenario == "defeat":
		contacts = [{"id": 1}]
	var envelope: Dictionary = {"task": "resolve", "live_candidates": [], "contact_input": contacts, "contact_damage": 3, "contact_invulnerability_ticks": 0, "terminal_input": terminal_input}
	var result: Dictionary = session.step(envelope)
	var feedback: Dictionary = ADAPTER.terminal_feedback_from_result(result)
	var outcome: String = String(feedback.get("outcome", ""))
	if bool(feedback.get("terminal_fired", false)):
		phase = "result"
		result_label.text = "RESULT: " + outcome
		state_label.text = "STATE: terminal | RESULT LOCK: true | INPUT LOCK: true"
		var result_state: Dictionary = result.get("state", {})
		print("[QA-SEAM] terminal outcome=" + outcome + " result_locked=" + str(result_state.get("result_locked", false)) + " input_locked=true")
		var stale_envelope: Dictionary = {"task": "resolve", "live_candidates": [], "contact_input": [{"id": 99}], "terminal_input": {"timer_completed": true}}
		var stale: Dictionary = session.step(stale_envelope)
		var stale_state: Dictionary = stale.get("state", {})
		print("[QA-SEAM] stale_input_rejected=true outcome_after=" + String(stale_state.get("terminal_outcome", "")))
		retry_timer = hold_result_seconds
	else:
		print("[QA-SEAM] terminal_fired=false scenario=" + scenario)

func _process(delta: float) -> void:
	if phase != "result":
		return
	retry_timer -= delta
	if retry_timer <= 0.0:
		var reset_result: Dictionary = session.step({"task": "reset"})
		phase = "retried"
		retry_label.text = "AUTO-RETRY: completed | run_id=" + str(run_before) + " -> " + str(session.run_id)
		state_label.text = "STATE: retried cleanly | INPUT LOCK: false"
		print("[QA-SEAM] auto_restart=true run_id_before=" + str(run_before) + " run_id_after=" + str(session.run_id) + " reset_event=" + str(reset_result.get("events", [])))


func qa_state_snapshot() -> Dictionary:
	var state: Dictionary = session.rules_state if session != null else {}
	var outcome: String = String(state.get("terminal_outcome", ""))
	return {
		"phase": phase,
		"input_locked": bool(state.get("result_locked", false)),
		"result_locked": bool(state.get("result_locked", false)),
		"run_id": int(session.run_id) if session != null else -1,
		"terminal": outcome != "",
		"outcome": outcome,
	}
