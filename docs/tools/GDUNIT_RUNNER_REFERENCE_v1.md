# gdUnit Runner Reference v1

## Purpose

`tools/run_gdunit4.ps1` runs the fixed rules/Adapter suite selected by its explicit test list. It is a Toolchain L1 runner, not a UI, input, runtime, visual, or player-experience acceptance tool.

## Invocation

```powershell
powershell -ExecutionPolicy Bypass -File tools/run_gdunit4.ps1 -DryRun
powershell -ExecutionPolicy Bypass -File tools/run_gdunit4.ps1
```

## Success Contract

All are required:

```text
exit 0
Overall Summary: <zero errors and failures>
Executed test cases: (N/N), where N is the current explicit suite total and N >= 1
SUITE_OK_N_OF_N
```

## Failure Contract

- Missing Godot/project/runner exits 2 with explicit path.
- Nonzero runner exit prints stdout/stderr paths.
- Timeout returns blocked/124 with a session record, owned child PID, stdout/stderr paths, and reconcile status; force-kill is disabled.
- Missing expected summary prints stdout/stderr paths and the session record.

## Evidence Boundary

Headless gdUnit proves rules and Adapter contracts only. It cannot prove UI focus, actual keyboard input, active-scene boot, runtime resource loading, visual pixels, audio playback, performance, or user experience. For runtime-facing changes, run `tools/project_feedback_loop.py` first; this runner is a target test stage, not the project feedback loop itself.
