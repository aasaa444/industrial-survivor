# QA M1 S2 Early-Capture Fixture — Independent QA Report v0.1

- **Status:** `accepted`
- **Verdict:** **`S2 fixture acceptance evidence complete`**
- **Report ID:** `QA_M1_S2_EARLY_CAPTURE_v0_1`
- **Owner:** Fresh Independent QA (sole acceptance owner)
- **Date:** 2026-08-18
- **Project root:** `D:\Game\New_Game\godot_game_dev`
- **Scope:** `res://qa/m1_s2_early_capture/early_capture_fixture.tscn` and its QA-only fixture route; this is fixture evidence, not production implementation acceptance.

## Evidence source and provenance

The runtime facts below are recorded from the Fresh Independent QA member handoff (`source: member handoff`, 2026-08-18). The Doc Scribe did not rerun QA. The runtime artifact reference is `user://m1_s2_early_capture_trace.json`; it is not copied into the repository.

## Observed runtime chain

Fresh QA restarted the fixture and actually observed:

1. `ui_right` input.
2. Movement from `(100,100)` to `(120,100)`.
3. Legal hit followed by `kill_clear`.
4. `live_set / pressure` transition `2 → 1`.
5. Actual after snapshot.
6. Space recovery.
7. Next movement decision.

The fixture reused the production adapter/session/rules anchors and used fixed-step `ui_right` movement. The after-state is actual runtime evidence, not source-only inference.

## Evidence metadata

The observed evidence included `fixture`, `scenario`, `build`, `seed`, `tick`, `clock`, and `observer` metadata. The observer was Fresh Independent QA. Clean stop was observed with `no_active_sessions`.

## Acceptance disposition

| Item | State | Owner | Evidence / consequence |
|---|---|---|---|
| Fixture scenario and runtime chain | `accepted` | Fresh Independent QA | Actual runtime observation above; trace ref `user://m1_s2_early_capture_trace.json` |
| Production anchor reuse | `inspected` | Gameplay Engineer / Fresh Independent QA | Member handoff says adapter/session/rules were reused; no production acceptance claim is made here |
| QA-only fixture boundary | `accepted` | Doc Scribe / Independent QA | Only `res://qa/m1_s2_early_capture/early_capture_fixture.gd` was changed for the fixture (`source: member handoff`) |
| Clean stop | `accepted` | Fresh Independent QA | `no_active_sessions` after stop |
| Unit 4 | `accepted` | Existing Unit 4 owner | Preserved; not rerun or rewritten this round |

## Exclusions and non-claims

- This report does **not** claim `M1 approved`, `release-ready`, Gate 3/5/6 completion, or product approval.
- It does **not** convert QA-only fixture evidence into production implementation acceptance.
- QA changed files: none during the fresh independent run.
- Unit 4 was not rerun and is not revalidated by this report.
- S3/B2 and M2/M3/M4 remain deferred/not entered.
- Performance, export, and Release remain deferred/not entered.
- R08 Option 2 remains inactive; activation requires CR plus User approval.

## Closeout reference

See [`M1_S2_CLOSEOUT_RECORD_v0_1.md`](M1_S2_CLOSEOUT_RECORD_v0_1.md) and [`ADR-0002-m1-s2-evidence-and-closeout.md`](../adr/ADR-0002-m1-s2-evidence-and-closeout.md). Historical documents remain unchanged; this report is the current-round closeout evidence.

## Change log

- **v0.1 — 2026-08-18 — Doc Scribe:** New durable record from Fresh Independent QA handoff; no runtime or QA files modified by this documentation pass.


## Post-report product decision boundary

This report's original exclusion that it did not itself claim product approval remains historically correct for the report artifact. Subsequently, by the User's direct message in this round, the product decision was recorded as:

- **Decision:** `M1 approved as product milestone`
- **Authority / source:** User / product authority; this round's direct User message
- **Old → new state:** `M1 final product approval: pending user` → `M1 final product approval: approved by User`
- **Scope:** M1 S2 technical evidence and Independent QA fixture evidence are `PASS`; Unit 4 remains `accepted`.
- **Boundary:** This fixture report remains QA-only fixture evidence and does not become main-scene visual acceptance. Current main-scene Enemy visibility and first-round automatic-attack timing remain a known downstream runtime/UX follow-up.
- **Exclusions:** S3/B2, M2/M3/M4, Gate 3, performance, export, and Release are not approved and remain deferred/not entered; this is not `release-ready`.
- **R08 Option 2:** remains `inactive` and is not activated by M1 approval.
- **Next-stage transition:** none automatic; S3/B2 or M2 requires new User authorization/change window and corresponding evidence gate.

This post-report decision is User approval, not Producer, Engineer, or QA代签.

## Change log

- **v0.1 decision update — 2026-08-18 — Doc Scribe:** Linked the explicit User product decision to this evidence record without rewriting its historical exclusions.
