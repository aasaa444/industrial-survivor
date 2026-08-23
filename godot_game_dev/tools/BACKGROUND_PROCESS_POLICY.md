# Background Process Policy

`background_process.py` is the only route for non-interactive project subprocesses.

It is a command executor, not a Godot project validator. Use it for project-local GDMCP CLI, headless Godot, gdUnit, import, parse, build, and CLI validation. It uses structured argv, hides only its own Windows console host, writes stdout/stderr/session records, preserves exit codes, and never kills a child process. A launcher `status=passed` proves only that the child command completed with the recorded result; callers must interpret the child command's own contract.

For runtime-facing changes, use `tools/project_feedback_loop.py` to obtain the separate `project_compile` and `active_scene_boot` results before target tests or handoff. The active scene comes from the current `project.godot`; gdUnit, resource-only parse, GDMCP editor state, and a launcher exit code are not interchangeable with active-scene boot.

Do not use it for foreground Godot windows, native L3 capture, `ImageGrab`, `SendInput`, real-player E2E, or any attended validation. Those routes remain visible and require their own safety contracts.

`--show-host` is available only for debugging a background route. Normal project work should use the default quiet host behavior.

If a command host still flashes after a project tool uses this launcher, the remaining window is likely created by the ZCode/Bash host itself. Current ZCode configuration exposes no verified Windows child-window visibility control; report that as a host limitation rather than weakening project evidence or foreground safety rules.
