# Tools Inventory

| Tool | Owner | Scope | Evidence layer | Self-test | Reference |
|---|---|---|---|---|---|
| `project_feedback_loop.py` | Toolchain | GodotMaker-style non-interactive project feedback: current project compile/parse, configured active-scene boot/self-test, optional target command, and unified task receipt; delegates process execution to `background_process.py` | Project compile/active-scene child result; not player proof | `test_project_feedback_loop.py` fake failure propagation | `tools/PROJECT_FEEDBACK_LOOP_REFERENCE_v1.md` |
| `background_process.py` | Toolchain | Structured, hidden-host launcher for non-interactive GDMCP/headless Godot/CLI commands; preserves logs, exit codes, and session records; force kill disabled | Command/session evidence only | `test_background_process.py` | `tools/BACKGROUND_PROCESS_POLICY.md` |
| `capture_game_window.py` | Tooling & Evidence | Foreground-protected native DEBUG window pixels + PID/title/rect | Native window identity / visual pixels only | Existing capture smoke; refusal paths are built in | `tools/capture_game_window.py` |
| `runtime_capture.py` | Tooling & Evidence | QA-owned Arc Coil state-bound Godot viewport capture | L2 state + internal rendering | dry-run, Arc Coil positive, wrong-SHA negative, missing-artifact negative | `tools/RUNTIME_CAPTURE_REFERENCE_v1.md` |
| `player_slice_capture.py` | QA & Release | Real OS input player slice and native window frames; **requires explicit `--allow-real-input`**, performs one startup focus attempt, checks the tool-owned game window before every key, and aborts as `environment_blocked` on focus loss | L3 player path (requires protected window capture) | `test_input_guard.py` fake-window/no-SendInput tests + attended P3 slice | `tools/player_slice_capture.py` |
| `qa_runtime_viewport_capture.tscn` | Tooling & Evidence | QA-only real-main Arc Coil capture fixture | Internal route only | Used by `runtime_capture.py` | `tools/RUNTIME_CAPTURE_REFERENCE_v1.md` |
