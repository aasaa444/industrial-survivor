# M1 S2 Decision Ledger v0.1

- **Status:** `accepted`
- **Owner:** Doc Scribe / Phase-Closure Owner
- **Date:** 2026-08-18
- **Decision authority:** User for product approval and any reserved threshold/scope/release crossing
- **Source discipline:** Current-round technical and runtime facts from member handoffs are marked `source: member handoff`.

| ID | Decision / record | State | Owner | Evidence source / consequence |
|---|---|---|---|---|
| ADR-M1-S2-01 | Use a QA-only deterministic fixture with production adapter/session/rules anchors and fixed-step evidence for S2 acceptance | `accepted` | Gameplay Engineer / Fresh Independent QA | `QA_M1_S2_EARLY_CAPTURE_v0_1.md`; fixture evidence remains isolated from production acceptance |
| ADR-M1-S2-02 | Use the project-local GDMCP launcher and never a bare PATH fallback | `accepted` | Toolchain Engineer | `tools/GDMCP_LAUNCHER.md`, `tools/gdmcp.ps1`, `tools/test_gdmcp.ps1`; wrapper resolves `.gdmcp\bin\gdmcp.exe` and its check-only/doctor/editor-state/negative/log/exit-code/redaction boundaries were verified (`source: member handoff`) |
| ADR-M1-S2-03 | S2 technical PASS is not M1 product approval | `accepted` | User / Doc Scribe record owner | M1 final approval is `pending user`; phase closure is `ready for user decision` |
| ADR-M1-S2-04 | R08 Option 2 remains inactive | `accepted` | User / Executive Producer boundary | Activation requires CR plus User approval |
| ADR-M1-S2-05 | S3/B2, M2/M3/M4, Gate 3, performance, export, and Release remain deferred/not entered | `accepted` | Executive Producer / User authority | No later phase entry is implied by S2 evidence |
| ADR-M1-S2-06 | Unit 4 acceptance is preserved without rerun or rewrite | `accepted` | Existing Unit 4 owner | Unit 4 is non-substitutable evidence and was not rerun this round |

## Status vocabulary

`reported` means received from an owner; `inspected` means checked without changing the source; `accepted` means the named evidence boundary is accepted; `user-approved` is reserved for explicit User approval; `closed` means the documentation obligation is complete. This ledger does not turn `accepted` into `user-approved`.

## Change log

- **v0.1 — 2026-08-18 — Doc Scribe:** New decision ledger for M1 S2 closeout.


## User decision update — M1 product milestone approval

- **Decision:** `M1 approved as product milestone`
- **Authority:** User / product authority
- **Decision source:** This round's direct User message
- **Decision date:** 2026-08-18 (project date convention)
- **Prior recorded state:** `M1 final product approval: pending user`
- **New recorded state:** `M1 final product approval: approved by User`
- **Scope/evidence boundary:** M1 S2 technical evidence and Independent QA fixture evidence are `PASS`; Unit 4 remains `accepted`. This approval does not approve S3/B2, M2/M3/M4, Gate 3, performance, export, or Release.
- **R08 Option 2:** remains `inactive`; M1 approval does not activate it.
- **Known limitation:** Current main-scene Enemy visibility and first-round automatic-attack timing remain a known downstream runtime/UX follow-up. QA-only fixture evidence is bounded to its fixture route and must not be rewritten as main-scene visual acceptance.
- **Next-stage transition:** none automatic. Entry into S3/B2 or M2 requires new User authorization/change window and corresponding evidence gate.

This update advances the prior pending state by explicit User decision; it is not a Producer, Engineer, or QA sign-off.

- **v0.1 decision update — 2026-08-18 — Doc Scribe:** Recorded explicit User approval without rewriting the historical pending entry above.
