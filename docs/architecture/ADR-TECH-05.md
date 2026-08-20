# ADR-TECH-05: contact / separation mechanics
**Date:** 2026-08-19
**Status:** Draft
**Deciders:** Tech Lead, Systems/Rules, UX/UI

## Context
Contact damage and separation are implemented in `main.gd` (engine-side AABB) and `rules_core.gd` (legal contact judgement). One legal contact produces one damage event, brief invulnerability, and slight separation. No repeat damage occurs during invulnerability.

## Decision
- **Contact seam:** engine detects overlap → adapter translates → rules core judges legality.
- **One damage per step:** exactly ONE contact_damage_event per step; the whole simultaneous overlapping set merges into it.
- **Invulnerability:** global brief invulnerability window (`contact_invulnerable_until_tick`).
- **Separation:** light separation is an ENGINE-side physical response; nudge the player a small distance away from the contacting victim.
- **Re-arm:** a victim re-arms ONLY after it separates (no longer in the current overlap set).

## Consequences
*   **Positive:** Protects recoverable spacing; prevents sticky/punitive contact.
*   **Negative:** Requires precise coordination between engine geometry and rules state.

## Status Line
- Status: `draft_in_review`
- Author: Tech Lead
- Reviewers: Systems/Rules, UX/UI
- Approval: Pending
