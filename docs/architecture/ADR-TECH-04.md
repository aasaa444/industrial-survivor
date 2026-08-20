# ADR-TECH-04: target selection / nearest-threat cluster
**Date:** 2026-08-19
**Status:** Draft
**Deciders:** Tech Lead, Systems/Rules

## Context
The target selection logic resides in `adapter.gd` (candidate normalization) and `rules_core.gd` (total-order comparator). The confirmed key order is `nearest threat → cluster-center distance → stable candidate ordering/stable ID`. The shot does not continuously retarget; it locks an immutable snapshot after refresh.

## Decision
- **M-1 key chain:** `k1_bucket` (nearest-threat distance), `k2_bucket` (cluster-center distance), `stable_id` (final tie-break).
- **Total-order comparator:** pure comparator over discrete integer buckets; no float equality; no in-place sort of engine containers.
- **Snapshot locking:** pre-fire refresh → M-1 stable-sort → lock immutable snapshot.
- **No-target branch:** explicit no-target branch when `target_snapshot_ids` is empty; never fabricate a target.

## Consequences
*   **Positive:** Stable snapshot locking improves causal readability and fixture comparison.
*   **Negative:** Requires explicit invalidation and trace data. Bucket width is a ledger rule parameter, not a performance budget.

## Status Line
- Status: `draft_in_review`
- Author: Tech Lead
- Reviewers: Systems/Rules, UX/UI
- Approval: Pending
