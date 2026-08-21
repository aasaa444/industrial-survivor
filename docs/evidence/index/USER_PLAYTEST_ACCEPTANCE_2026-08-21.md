# User Playtest Acceptance Record - Current Demo

## Product Goal
Industrial Survivor: a 5–10 minute playable demo the user is willing to show to friends.

## User-confirmed acceptance

On 2026-08-21, the user tested the current upgrade interaction and explicitly reported:

> "OK，我这边试完通过了"

Accepted surface: upgrade/build interaction on the current playable build.

## Observed/verified scope

| Requirement | Evidence | Status |
|---|---|---|
| Three initial build choices | User playtest; current build choice UI | Accepted by user |
| Follow-up upgrade state | User playtest confirmed the follow-up is a single current-build upgrade card | Accepted by user |
| Card centering | User reported centered cards after the fix | Accepted by user |
| Card interaction | User tested and accepted the corrected interaction after global hit-testing / visibility fixes | Accepted by user |
| XP collection and level progression | Runtime logs: `[GROWTH] energy_collected`; controlled QA path | Runtime observed |
| Rail/Fan/Pulse application | Current-SHA controlled path logs and user playtest | Runtime observed / user interaction accepted |
| Victory/restart | Current-SHA controlled six-minute evidence: `CAP-DEMO6-001` | Runtime observed |
| Performance | Current-machine soak samples, mostly 144 FPS | Current-machine evidence only |
| Rules/Adapter regression | Current runner: 60/60 | Static/headless evidence |

## Current build

- Current accepted gameplay commit: `32952f1` (`center and activate single build upgrade card`)
- Earlier current-SHA six-minute evidence: `b1f2e01`, indexed in `EVIDENCE_INDEX_DEMO_FINAL_b1f2e01.md`
- Current user acceptance is limited to the upgrade/build interaction and the playable prototype surface tested by the user. It does not claim export, cross-hardware, or commercial-release readiness.

## Remaining non-blocking/deferred scope

- User may still choose to continue polish: deeper build upgrade choices, more animation states, long-run balancing, export validation, and friend playtest with another person.
- These are not silently converted to "done" by this record.
