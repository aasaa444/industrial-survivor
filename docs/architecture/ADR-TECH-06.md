# ADR-TECH-06: Headless seam / evidence schema
**Date:** 2026-08-19
**Status:** Draft
**Deciders:** Tech Lead, QA, Producer

## Context
A headless invocation boundary is required to compare pure rules behavior without a rendered scene. The evidence schema must support immutable IDs, build/config identity, and explicit comparison behavior.

## Decision
- **Headless seam:** `step(domain_input_envelope, prior_state, tick) -> {state, events, diagnostics}`; pure function `ordered_candidates(state, params) -> ordered_ids`.
- **Evidence schema:** five-layer envelope: `domain_fixture`, `technical_envelope`, `ux_observation`, `qa_verdict`, `producer_index_entry`.
- **Identity rules:** `evidence_id` is immutable and unique; `schema_version` requires exact matching; `config_version` carries configuration identity.
- **Comparison:** exact mismatch only; no silent tolerance or field dropping.

## Consequences
*   **Positive:** Enables independent QA observation and verdict issuance; supports reproducibility.
*   **Negative:** Schema maintenance and raw-retention contract are required.

## Status Line
- Status: `draft_in_review`
- Author: Tech Lead
- Reviewers: QA, Producer, Systems/Rules
- Approval: Pending
