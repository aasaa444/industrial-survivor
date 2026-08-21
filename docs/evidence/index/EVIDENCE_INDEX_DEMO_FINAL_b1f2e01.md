# Demo Final Evidence Index - b1f2e01

> This index records the current-SHA six-minute controlled run. `--qa-auto-select` is a QA seam for repeatable progression, not user-input acceptance.

| Evidence ID | SHA | Scenario | Runtime path | Evidence | Result |
|---|---|---|---|---|---|
| CAP-DEMO6-001 | `b1f2e01c47084906fdf3e9e090773a5da1802dab` | 6-minute controlled demo | clean launch -> energy collect -> Rail Pierce -> Fan -> Pulse -> survive -> victory -> auto-restart | `qa/evidence/CAP-DEMO6-001/events.log`, `stderr.log` | victory at ~360.7s; restart wave 1 at ~365s |
| CAP-DEMO-FINAL-START | `b1f2e01c47084906fdf3e9e090773a5da1802dab` | latest user playtest start | clean launch -> 3s stable frame | `qa/evidence/CAP-DEMO-FINAL-START/capture.png`, `.json` | valid pixels/window identity; gameplay state unproven |

## CAP-DEMO6-001 observations

- Three upgrade applications observed: `pierce`, `fan`, `pulse`.
- 72 `[PERF]` samples; observed FPS remained 143–144 in the controlled run; nodes/draw calls remained bounded in the recorded samples.
- Terminal: `[TERMINAL] outcome=victory (control completion)`.
- Restart: next wave sequence restarted after terminal result.
- `stderr.log` contains no `SCRIPT ERROR`, `Parse Error`, or Tween error.
- Evidence boundary: `--qa-auto-select` verifies the progression state machine and runtime effects, not a human's natural keyboard choice. User playtest is still required for final acceptance.
