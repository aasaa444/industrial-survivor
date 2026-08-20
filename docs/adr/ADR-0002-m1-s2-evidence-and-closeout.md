# M1 S2 ADR — Evidence, Fixture, and Closeout Boundaries

- **ADR ID:** `ADR-0002`
- **Status:** `accepted` for this evidence/process boundary; it does not approve M1 as a product milestone.
- **Owner:** Doc Scribe / Phase-Closure Owner
- **Date:** 2026-08-18
- **Decision authority:** User for M1 product approval, release, thresholds, and reserved scope crossings
- **Supersedes:** None. `ADR-0001-wildcard-infrastructure.md` was not present at discovery time.

## Context

The current round needed durable evidence for M1 S2 without confusing a QA-only fixture with production implementation acceptance. The earlier roster had no dedicated Doc Scribe or phase-closure owner. Existing records are historical and do not prove this round's M1 S2 closeout.

## Decision

1. Record S2 through a deterministic QA-only fixture that reuses production adapter/session/rules anchors and fixed-step input evidence.
2. Treat actual runtime after-state, metadata, observer identity, and clean stop as evidence fields; distinguish them from source-only claims.
3. Require the project-local GDMCP wrapper path: `.gdmcp\bin\gdmcp.exe`; no bare PATH fallback. Preflight is check-only and includes doctor/editor-state smoke plus negative, log, exit-code, and redaction boundaries.
4. Keep the verdict narrow: `S2 fixture acceptance evidence complete`. It is not `M1 approved`, `release-ready`, or `Unit4 revalidated`.
5. Keep R08 Option 2 inactive unless a CR and User approval activate it. Keep S3/B2 and all later milestones deferred/not entered.

## Consequences

- QA evidence is reproducible and traceable while production and fixture changes remain visibly separated.
- Independent QA remains the acceptance owner; the Engineer does not self-accept its implementation.
- M1 remains open for User product decision even though S2 technical evidence is accepted.
- Historical documents remain unchanged; current-round records explain any apparent envelope/GDMCP pending drift.

## Evidence references

- [`../production/QA_M1_S2_EARLY_CAPTURE_v0_1.md`](../production/QA_M1_S2_EARLY_CAPTURE_v0_1.md)
- [`../production/M1_S2_CLOSEOUT_RECORD_v0_1.md`](../production/M1_S2_CLOSEOUT_RECORD_v0_1.md)
- [`../production/M1_S2_DECISION_LEDGER_v0_1.md`](../production/M1_S2_DECISION_LEDGER_v0_1.md)
- Runtime artifact: `user://m1_s2_early_capture_trace.json` (not a repository file)
- Toolchain: `tools/gdmcp.ps1`, `tools/test_gdmcp.ps1`, `tools/GDMCP_LAUNCHER.md`

## Change log

- **v0.1 — 2026-08-18 — Doc Scribe:** Added ADR-0002 for S2 evidence and phase-close boundaries.


## Addendum — explicit User product decision

- **Decision:** `M1 approved as product milestone`
- **Authority:** User / product authority
- **Decision source:** This round's direct User message
- **Decision date:** 2026-08-18 (project date convention)
- **Old state:** `M1 final product approval: pending user`
- **New state:** `M1 final product approval: approved by User`
- **Scope/evidence boundary:** M1 S2 technical evidence and Independent QA fixture evidence are `PASS`; Unit 4 remains `accepted`.
- **Exclusions:** This does not approve S3/B2, M2/M3/M4, Gate 3, performance, export, or Release, and does not mean `release-ready`.
- **R08 Option 2:** remains `inactive`; M1 approval does not activate it.
- **Known limitation:** Current main-scene Enemy visibility and first-round automatic-attack timing remain a downstream runtime/UX follow-up. QA-only fixture PASS remains bounded to the fixture route and is not main-scene visual acceptance.
- **Next-stage transition:** none automatic. S3/B2 or M2 requires new User authorization/change window and corresponding evidence gate.

This addendum records User approval, not Producer, Engineer, or QA代签; the original ADR statement that S2 evidence alone did not approve M1 remains historically accurate and is advanced only by this explicit User decision.

## Change log

- **v0.1 decision update — 2026-08-18 — Doc Scribe:** Added the explicit User approval addendum without rewriting the original ADR decision text.
