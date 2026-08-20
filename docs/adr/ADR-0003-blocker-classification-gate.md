# ADR-0003 — Blocker Classification Gate

- **ADR ID:** `ADR-0003`
- **Status:** `accepted`
- **Owner:** Doc Scribe
- **Date:** 2026-08-19
- **Decision authority:** User for product-level classification disputes; Executive Producer for development-phase enforcement
- **Supersedes:** None. New rule.
- **References:** `ADR-0002` (M1 S2 evidence and closeout boundaries)

## Context

During M1 S2 visual evidence capture, the grace-window Enemy visibility could not be captured via MCP bridge — bridge delay exceeds the 1.0s grace window, and neither debugger break nor runtime sampling can capture during the grace period. The game timing logs independently verified that grace 1.0s and resolve delay 0.25s work correctly. The visual evidence check was therefore `PARTIAL/UNACCEPTED` as a static gate.

This created a pattern: an evidence check that is technically unpassable due to toolchain limitations, yet the underlying game behavior is verified through other means (timing logs). Without a classification rule, the team risked treating every unpassable check as a game-blocking failure.

## Decision

A new stop gate, **Blocker Classification Gate**, is added to `$godot-game-team` SKILL.md Stop gates section. All blockers are classified into exactly three categories before any action is taken:

1. **Game blocker (hard gate):** Code bugs, rule errors, broken mechanics, logic contradictions. Must be fixed; cannot be bypassed.
2. **Toolchain blocker (soft gate):** Bridge latency, screenshot tool limitations, insufficient observation window, slow MCP response, runtime sampling timing issues. Recorded as known limitations; do not block game development. Marked in ledger and final report as `known tooling limitation`; do not block phase passage.
3. **Product blocker (user gate):** Promise conflicts, scope overruns, Charter threshold triggers. Escalated to User for decision.

The parent coordinator must classify every failing check before deciding whether to block. Toolchain blockers must never be treated as game blockers.

## Consequences

- The grace-window visual evidence is reclassified from `PARTIAL/UNACCEPTED` to `known tooling limitation` (see M1 Grace-Window evidence acceptance record).
- Future toolchain-imposed evidence gaps follow the same classification path: record, do not block.
- The Blocker Classification Gate is a process rule, not a product decision — it applies to all phases and all evidence types.
- The parent coordinator's ledger now includes a `blocker_classification` field for each unresolved check.

## Verification

- The rule is recorded in `$godot-game-team` SKILL.md Stop gates section.
- The first application is the M1 grace-window visual evidence reclassification (separate acceptance record).

## Change log

- **v0.1 — 2026-08-19 — Doc Scribe:** Created ADR-0003 recording the Blocker Classification Gate rule and its first application to M1 grace-window evidence.