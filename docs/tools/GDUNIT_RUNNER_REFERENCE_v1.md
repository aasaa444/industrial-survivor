# gdUnit Runner Reference v1

## Purpose

`tools/run_gdunit4.ps1` runs the fixed 60-case rules/Adapter suite. It is a Toolchain L1 runner, not a UI, input, runtime, visual, or player-experience acceptance tool.

## Invocation

```powershell
powershell -ExecutionPolicy Bypass -File tools/run_gdunit4.ps1 -DryRun
powershell -ExecutionPolicy Bypass -File tools/run_gdunit4.ps1
```

## Success Contract

All are required:

```text
exit 0
Overall Summary: ...60 test cases
Executed test cases: (60/60)
SUITE_OK_60_OF_60
```

## Failure Contract

- Missing Godot/project/runner exits 2 with explicit path.
- Nonzero runner exit prints stdout/stderr paths.
- Missing expected summary now prints stdout/stderr paths (the old undefined `$log` error was repaired 2026-08-21).
- Timeout currently kills only the direct runner process; process-tree/port release is a known limitation and belongs to future TOOL-LEASE integration.

## Evidence Boundary

Headless gdUnit proves rules and Adapter contracts only. It cannot prove UI focus, actual keyboard input, runtime resource loading, visual pixels, audio playback, performance, or user experience.
