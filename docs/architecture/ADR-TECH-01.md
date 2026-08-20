# ADR-TECH-01: rules/session/adapter/presentation seam
**Date:** 2026-08-19
**Status:** Draft
**Deciders:** Tech Lead, User (for architecture-risk crossing)

## Context
The current implementation (M1) uses a four-layer architecture: `runtime/main.gd` (presentation/scene), `adapter/adapter.gd` (translation), `rules/session.gd` (lifecycle), and `rules/rules_core.gd` (pure rules). Cross-role implementation is unsafe if rules, lifecycle, engine integration, and presentation semantics are mixed. The scene currently talks to the rules core ONLY through the adapter and session.

## Decision
1. **Rules core:** deterministic, side-effect-free evaluation of domain inputs against domain state; owns rule outcomes, target snapshot interpretation, contact legality, upgrade eligibility, and terminal arbitration.
2. **Session:** owns one run's identity and lifecycle, tick/seed/config context, reset transaction, and the boundary at which a rules step is evaluated.
3. **Adapter:** maps engine clock/input/collision observations into domain inputs and maps domain outputs to engine-facing effects. It cannot silently add game rules.
4. **Presentation:** consumes a read model and explicit interaction intents for HUD, hint, cards, result, focus, and feedback. It cannot become a second rules implementation.

## Consequences
*   **Positive:** Systems can review rule vocabulary independently; engineering can implement against seams; QA can compare pure fixtures and session traces; UX can consume stable read-model fields.
*   **Negative:** Explicit data translation, schema versioning, and discipline against adapter leakage are required.

## Status Line
- Status: `draft_in_review`
- Author: Tech Lead
- Reviewers: Systems/Rules, UX/UI
- Approval: Pending
