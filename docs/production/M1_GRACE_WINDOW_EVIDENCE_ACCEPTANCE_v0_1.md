# M1 Grace-Window Visual Evidence Acceptance v0.1

- **Status:** `accepted as known tooling limitation`
- **Owner:** Doc Scribe
- **Date:** 2026-08-19
- **Product authority:** User; M1 already approved as product milestone (2026-08-18)
- **References:** `ADR-0003` (Blocker Classification Gate), `ADR-0002` (M1 S2 evidence and closeout), `M1_S2_CLOSEOUT_RECORD_v0_1.md`

## Background

The M1 S2 closeout record and ADR-0002 addendum noted a "known limitation": current main-scene Enemy visibility and first-round automatic-attack timing remained a downstream runtime/UX follow-up. The QA-only fixture evidence was bounded to its fixture route and was not main-scene visual acceptance.

This record formalizes the disposition of the main-scene grace-window Enemy visual evidence.

## Evidence status change

| Field | Old state | New state |
|---|---|---|
| Main-scene grace-window Enemy visual evidence | `PARTIAL / UNACCEPTED` | `known tooling limitation` |
| Game timing: grace 1.0s | Verified via timing logs | No change |
| Game timing: resolve delay 0.25s | Verified via timing logs | No change |
| M1 product milestone | Approved by User (2026-08-18) | No change |

## Root cause analysis

The MCP bridge latency exceeds 1.0s. Both attempted capture methods fail:

- **Debugger break:** The break-and-sample round-trip time exceeds the grace window duration. By the time the debugger reaches a breaked state, the grace window has already elapsed.
- **Runtime sampling:** The runtime probe polling interval plus bridge transport latency cannot reliably hit a sub-1.0s window.

The game timing logs independently confirm that grace 1.0s and resolve delay 0.25s function correctly. The underlying game behavior is verified; the evidence gap is purely observational.

## Classification

Per ADR-0003 Blocker Classification Gate, this is a **toolchain blocker (soft gate)**. It does not indicate a game bug, rule error, or broken mechanic. It is recorded as a known limitation and does not block game development, phase passage, or the M1 product milestone.

## Preserved debug seams

The following debug seams implemented in `res://runtime/main.gd` are preserved for future verification when toolchain conditions improve:

- `qa_hold_before_combat` — pauses before combat round for observation
- Other grace-window-related debug hooks

These seams remain in production code as non-disruptive instrumentation. They are not QA acceptance evidence now, but they enable future verification without code changes.

## Impact on M1

None. M1 was approved by User on 2026-08-18. The grace-window visual evidence was already noted as a known limitation in the approval record. This formal reclassification does not alter the M1 product milestone status.

## Change log

- **v0.1 — 2026-08-19 — Doc Scribe:** Formalized grace-window visual evidence as known tooling limitation per ADR-0003 Blocker Classification Gate. Recorded root cause (MCP bridge latency > 1.0s), preserved debug seams, and confirmed no impact on M1 approval.