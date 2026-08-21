# Runtime Capture Evidence Index v1

> Append-only index for PID-bound native capture artifacts. A capture proves visible pixels/window identity only unless a separate runtime state/log reference is linked.

| Evidence ID | SHA | Scenario / State / Action | PNG + Sidecar | PID / Viewport | Verdict Boundary | Status |
|---|---|---|---|---|---|---|
| CAP-LEGACY-SLICEA-001 | current at 2026-08-21 capture | sliceA_visual_anchor / current_combat / idle_after_launch | `godot_game_dev/qa/screenshots/verified_sliceA_current.png` + `.json` | PID 24604 / 1168x687 | valid native pixels/window identity; gameplay state unproven | historical sample |
| CAP-TOOL-001 | b98d99604e87a4616df16e25fb6bc674573dacf1 | tool_factory_smoke / current_combat / idle_after_launch | `godot_game_dev/qa/evidence/CAP-TOOL-001/capture.png` + `.json` | PID 17568 / 1168x687 | positive tool self-test; visible pixels/window identity only | valid_pixels |

## Status vocabulary

`valid_pixels`, `missing_runtime_context`, `blocked`, `inconclusive`, `superseded`. Do not use a filename or screenshot alone as a gameplay pass.
