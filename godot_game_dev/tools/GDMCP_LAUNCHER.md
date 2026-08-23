# Project-local GDMCP launcher

## Purpose

`gdmcp.ps1` is the auditable launcher for this project's GDMCP CLI. It derives the project root from its own location and resolves **only**:

```text
<project-root>/.gdmcp/bin/gdmcp.exe
```

It never falls back to a PATH-installed `gdmcp`. The wrapper does not write registry JSON, project settings, game files, or QA fixtures.

## Usage

Run from any PowerShell working directory:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\tools\gdmcp.ps1 -CheckOnly
pwsh -NoProfile -ExecutionPolicy Bypass -File .\tools\gdmcp.ps1 --json doctor
pwsh -NoProfile -ExecutionPolicy Bypass -File .\tools\gdmcp.ps1 --json editor state
```

`-CheckOnly` probes the local executable and reports project root, resolved path, GDMCP identity, and the exact version-probe command without contacting the editor.

All non-check arguments are passed transparently to the local executable. The wrapper records UTC timestamp, wrapper identity, project root, resolved executable, command (with credential-like argument values redacted), real stdout/stderr, temporary log paths, and child exit code. A non-zero child exit code remains non-zero at the wrapper boundary.

GDMCP tokens must be supplied through supported environment/configuration mechanisms; do not pass credentials as CLI arguments. The wrapper/session audit redacts recognized sensitive argv values, but child stdout/stderr are retained as raw diagnostic evidence and therefore are not a credential transport channel.

## Failure modes

* Missing `project.godot`: exit 2; root resolution is invalid.
* Missing `.gdmcp/bin/gdmcp.exe`: exit 2 with an explicit PATH-fallback-disabled error.
* Failed `--version` identity probe: non-zero (or 2 if the launcher cannot start it).
* Missing operation arguments outside check-only: exit 2.
* GDMCP operation failure: the child's exact non-zero exit code is returned.

## Verification record

Verified on 2026-08-18 in `D:\Game\New_Game\godot_game_dev`:

* Check-only resolved the project-local binary and reported `gdmcp 1.0.8`.
* Smoke commands `--json doctor` and `--json editor state` were run through this wrapper; their real stdout/stderr and exit codes were retained in the wrapper output.
* A copied wrapper in a temporary directory without `.gdmcp/bin/gdmcp.exe` failed clearly and non-zero; the real project binary was not touched.
* `test_gdmcp.ps1` covers positive check-only and the missing-local-binary negative case.
* Before/after hashes of game, QA, registry, and project files were unchanged.

## Maintenance

Maintainer: Godot Toolchain Engineering  
Last verified: 2026-08-18

Do not introduce a second GDMCP launcher or restore a bare PATH fallback. If the local binary location changes, update this wrapper and this verification record together.
