# ADR-TECH-07: performance measurement protocol
**Date:** 2026-08-19
**Status:** Draft
**Deciders:** Tech Lead, QA

## Context
Candidate budgets exist (1080p/60, 50 FPS minimum, input response ≤50ms, cold start <3s, restart <1s) but have not been measured. A measurement protocol is required for future authorized measurement.

## Decision
- **Protocol fields:** Evidence ID, build identity, hardware, OS, settings, scenario, sampling, statistic, clock authority, input method, and observer.
- **Budget status:** all candidate budgets remain candidate only; no number is promoted to a hard gate without a named decision.
- **Measurement authority:** Tech Lead proposes protocol; QA owns acceptance and cannot be waived.

## Consequences
*   **Positive:** Establishes a measurable baseline before optimization.
*   **Negative:** Hardware/OS/settings/percentile authority remain unresolved.

## Status Line
- Status: `draft_in_review`
- Author: Tech Lead
- Reviewers: QA, User (for hard-gate choice)
- Approval: Pending
