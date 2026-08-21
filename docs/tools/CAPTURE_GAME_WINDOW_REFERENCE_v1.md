# Capture Game Window Reference v1

## Purpose

`tools/capture_game_window.py` captures one **explicit PID-bound Godot DEBUG game window** and writes PNG + JSON sidecar. It exists because GDMCP screenshot could time out and desktop capture previously grabbed the editor or a stale game window.

## Boundary

This is an isolated native diagnostic route. It proves only visible window pixels and the captured window identity. It does **not** prove runtime gameplay/domain state; pair it with runtime state/log evidence and Native Visual QA for any visual verdict.

## Canonical Invocation

From `godot_game_dev` after launching a known game PID:

```powershell
python tools/capture_game_window.py `
  --pid <GAME_PID> `
  --project-root . `
  --scenario sliceA_visual_anchor `
  --state current_combat `
  --action idle_after_launch `
  --output qa/evidence/CAP-SLICEA-001/capture.png `
  --manifest qa/evidence/runtime_capture_manifest.jsonl
```

## Dry Run

```powershell
python tools/capture_game_window.py --pid <GAME_PID> --output qa/evidence/dry.png --dry-run
```

Dry run prints PID/title/rect/project root/SHA/output and writes no project artifact.

## Success Contract

- Exactly one visible top-level window belongs to `--pid`.
- Title contains `(DEBUG)` and does not match editor markers.
- Window is at least 800x400.
- Captured image dimensions equal the window rect and pixels are not flat.
- Output has PNG plus `.png.json` sidecar with schema, UTC, SHA, cwd/root, platform, Python/Pillow version, PID/title/rect, scenario/state/action, SHA-256, and evidence boundary.
- Optional manifest is append-only JSONL.

## Negative Fixtures

- Editor PID: exits `2`, says `Refusing editor window title`.
- Expired/nonexistent PID: exits `2`, says no visible window.
- PID with multiple windows, non-DEBUG title, small window, capture mismatch, or flat image: exits `2`; no pass artifact.

## Naming

Use `qa/evidence/<EVIDENCE_ID>/capture.png` with semantic metadata:

```text
EVIDENCE_ID: CAP-<slice>-<state>-<sequence>
scenario: slice identifier
state: current_combat | upgrade_open | defeat | victory | restart
action: player/setup path that produced the frame
```

Never overwrite a failed capture; create a new evidence ID and link both in the manifest.

## Revalidation Trigger

Re-run positive and negative tests when Windows capture backend, Pillow/Python, Godot major/minor, target viewport, or title convention changes.
