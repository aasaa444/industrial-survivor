# Tools Inventory v1

| ID | Path | Purpose | Owner Hat | Platform | Mutates Project | Evidence Layer | Success Contract | Failure | Reference | Last Verified | Known Limit |
|---|---|---|---|---|---|---|---|---|---|---|---|
| TOOL-GDMCP-01 | `godot_game_dev/tools/gdmcp.ps1` | Project-local GDMCP launcher/preflight | Toolchain | Windows | No (check mode) | L1/L2 | `doctor` + `editor state` exit 0, audited stdout/stderr | nonzero | `tools/GDMCP_LAUNCHER.md` | 2026-08-21 | Does not prove player-visible state |
| TOOL-GDUNIT-01 | `godot_game_dev/tools/run_gdunit4.ps1` | Rules/Adapter test runner | Toolchain | Windows | Reports only | L1 | exit 0 + 60/60 markers | exit 2 | `tools/RUNNER.md`, `tools/GDUNIT_RUNNER_REFERENCE_v1.md` | 2026-08-21 | Headless cannot prove UI/input/runtime |
| TOOL-CAPTURE-01 | `godot_game_dev/tools/capture_game_window.py` | PID-bound native game-window capture | Tooling & Evidence | Windows | QA evidence only | isolated L2/L3 pixels | PNG + JSON sidecar, PID/title/rect/size/SHA | exit 2 rejection | `tools/CAPTURE_GAME_WINDOW_REFERENCE_v1.md` | 2026-08-21 | Proves visible pixels/window identity, not gameplay state |
| TOOL-LEASE-01 | `godot_game_dev/tools/godot_session_lease.py` | Read-only Godot PID/port health and observation lease | Tooling & Evidence | Windows | Lease JSON only | L1 | lease only for explicit existing Godot PID | exit 2 | `tools/GDMCP_SESSION_REFERENCE_v1.md` | 2026-08-21 | Never starts/stops processes; no GDMCP runtime proof |
| TOOL-RESOURCE-01 | `godot_game_dev/tools/verify_resource_layers.py` | Import/loader/parse layer report | Tooling & Evidence | Windows | Import cache only | L1 | resource exists + parse layer succeeds | exit 2 | `tools/GDMCP_SESSION_REFERENCE_v1.md` | 2026-08-21 | Import/parse does not prove scene/runtime |

## Inventory Rules

- A tool is not complete until its canonical reference and positive/negative self-test exist.
- Each verification records current SHA, cwd, version, platform, and evidence boundary.
- Tools do not create Demo acceptance; they create reliable routes for QA/user evidence.
