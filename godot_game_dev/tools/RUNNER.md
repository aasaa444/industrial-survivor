# gdUnit4 fixed runner

Run from any PowerShell cwd:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File D:\Game\New_Game\godot_game_dev\tools\run_gdunit4.ps1 -DryRun
pwsh -NoProfile -ExecutionPolicy Bypass -File D:\Game\New_Game\godot_game_dev\tools\run_gdunit4.ps1 -SelfTest
pwsh -NoProfile -ExecutionPolicy Bypass -File D:\Game\New_Game\godot_game_dev\tools\run_gdunit4.ps1
```

The script fixes the project root, Godot 4.7.1 console executable, exact `res://addons/gdUnit4/bin/GdUnitCmdTool.gd` casing, explicit test files, timeout (120 s), report directory, and exit-code checks. `-DryRun` verifies executable/version/project/runner and prints the exact command without running tests. `-SelfTest` verifies the wrapper path checks without running tests. A real run requires exit 0 and the authoritative `Overall Summary: <zero errors and failures>` / `Executed test cases: (N/N)` markers, where N is the current explicit suite total. Reports are written outside the project under `user://toolchain-suite` (Godot app data). UI/input interaction is not proven by this headless runner; use `tools/project_feedback_loop.py` for project compile and active-scene boot, and native runtime QA for player evidence.

Known failure diagnostics are printed and the temporary full log path is reported. Do not use `addons/gdUnit4/runtest.cmd` for acceptance evidence because it requires an injected `GODOT_BIN`, uses a different invocation, and is not the fixed wrapper.
