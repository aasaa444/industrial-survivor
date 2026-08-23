# Project Feedback Loop Reference v1

## Purpose

`project_feedback_loop.py` is the project's non-interactive, GodotMaker-style feedback loop. It coordinates the existing `background_process.py` launcher and records the real Godot child result. It is the project validation entrypoint for runtime-facing changes; it is not a foreground player test, capture tool, or acceptance authority.

## Main sequence

```text
one bounded mutation
-> project_compile
-> active_scene_boot
-> optional target_tests
-> Mechanical Gate
-> Player Gate when required
-> user acceptance
```

The current `project.godot` supplies `run/main_scene`; the tool never hard-codes a different scene. The active-scene step performs a bounded clean boot with `--quit-after 3` and records the child PID, child exit code, session record, stdout/stderr, and startup error markers. A longer `--self-test` is a separate target/mechanical check and is not used as the minimal boot gate.

## Invocation

```powershell
python tools/project_feedback_loop.py `
  --project-root D:\Game\New_Game\godot_game_dev `
  --godot C:\Users\User\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe `
  --log-dir D:\Game\New_Game\.zcode\feedback `
  --task-id <task> `
  --change-step-id <step>
```

Optional target commands are passed after `--target-command`; they run only after compile and active-scene boot pass. A receipt is written under the requested log directory or `--output`.

## Result boundaries

```text
launcher.status=passed
!= godot.project_compile=passed
!= godot.active_scene_boot=passed
```

`background_process.py` proves safe command execution, retained logs, session ownership, and exact child/launcher exit semantics. It does not prove the Godot project. `project_compile` proves the selected project parse/editor check. `active_scene_boot` proves the configured scene's headless self-test child result. Neither proves visual quality, real input, audio, player experience, or user acceptance.

A compile or boot failure stops target tests and produces a blocked receipt. Timeout is `blocked`/`124` with force-kill disabled. Child failures preserve the exact child exit code. The tool does not start a visible window, send OS input, capture pixels, or close unknown processes.
