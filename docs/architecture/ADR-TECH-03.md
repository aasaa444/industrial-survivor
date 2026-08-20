# ADR-TECH-03: seed / fixture reproducibility
**Date:** 2026-08-19
**Status:** Draft
**Deciders:** Tech Lead, Systems/Rules

## Context
Fixed tick, seed, snapshots, and constrained light randomness are promised only for QA/debug reproducibility. There is explicitly no player-visible Replay promise. The session (`session.gd`) owns the single session seed context.

## Decision
- **Tick:** a single fixed-step evaluation boundary; exact frequency remains unresolved.
- **Seed/RNG:** one session-owned seed context; random draws must be named, ordered, and bounded (`draw_stream(stream_name)`).
- **Snapshot:** versioned state capture at a future-defined cadence, including enough state to compare deterministic fixtures.
- **Stable ID:** every traceable actor/target/event subject receives a stable run-scoped identity; lifecycle allocation remains unresolved.
- **Config version:** every future snapshot/trace/fixture carries a configuration schema/version identity (`rules_core.gd::CONFIG_VERSION`).

## Consequences
*   **Positive:** Enables diagnosis and independent comparison.
*   **Negative:** Adds instrumentation and schema maintenance. Determinism still requires implementation and QA evidence.

## Status Line
- Status: `draft_in_review`
- Author: Tech Lead
- Reviewers: Systems/Rules, QA
- Approval: Pending
