
## Real-input safety

`player_slice_capture.py`, `defeat_run_capture.py`, and `export_release_check.py` default to `input_disabled`. Real Windows keyboard injection requires explicit `--allow-real-input` and is intended only for an attended foreground run. The tools make one startup focus attempt, then check the owned game window before every key and screenshot. If focus changes, they stop with `environment_blocked`, do not send further input, and do not steal focus back. Use a VM, Sandbox, separate desktop/session, or second machine for frequent unattended foreground testing.
