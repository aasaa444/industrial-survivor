# ADR-TECH-02: determinism contract / snapshot schema
**Date:** 2026-08-19
**Status:** Draft
**Deciders:** Tech Lead, Systems/Rules

## Context
The rules core (`rules_core.gd`) is implemented as an engine-free pure GDScript layer. It must be reproducible for QA/debug. The current `step()` function returns `{state, events, diagnostics}`. A standardized snapshot schema is required to compare deterministic fixtures across runs.

## Decision
- **Purity:** a rules step accepts a versioned domain input envelope plus prior domain state and returns a new state plus domain events/diagnostics. It must not read wall-clock time, device state, scene tree, UI controls, or global mutable randomness.
- **Snapshot schema:** every snapshot must carry `config_version`, `live_candidates`, `ordered_ids`, `target_snapshot_ids`, `no_target_branch`, `refresh_tick`, `lock_tick`, `invalidation_log`, `hit_results`, `resolution_outcomes`, `kill_outcomes`, `segments_lost`, and `terminal_outcome`.
- **Trace format:** append-only diagnostic records for inputs, tick, rule transitions, target snapshot, random draw identifiers, upgrade/reset/terminal events, and config identity.

## Consequences
*   **Positive:** Headless fixture comparison becomes possible; UI focus or engine callbacks cannot change rules.
*   **Negative:** Requires explicit mapping and version compatibility; exact event ordering remains subject to Systems/Rules review.

## Status Line
- Status: `draft_in_review`
- Author: Tech Lead
- Reviewers: Systems/Rules, UX/UI
- Approval: Pending
