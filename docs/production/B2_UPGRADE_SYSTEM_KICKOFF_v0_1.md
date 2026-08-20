# B2 Upgrade System Development Kickoff v0.1

- **Status:** `development dispatched`
- **Owner:** Doc Scribe (record); Executive Producer (execution oversight)
- **Date:** 2026-08-19
- **Product authority:** User; M1 approved (2026-08-18); B2 within Charter scope
- **References:** `Development Charter v0.1`, `ADR-0002`, `M1_S2_CLOSEOUT_RECORD_v0_1.md`

## Decision

B2 upgrade system development has been dispatched to the Godot Gameplay Engineer for implementation. The Engineer owns the B2 implementation within the Charter-defined scope.

## Scope

Per the Development Charter, B2 upgrade system includes:

- **Penetration → Fan-split (穿透 → 扇裂):** The core B2 upgrade mechanic that transforms the piercing attack into a fan-shaped splitting attack.
- **Card selection:** The upgrade card selection interface presented to the player at upgrade points.
- **Two pause-based upgrades:** Two upgrade opportunities during gameplay, each triggered by a pause event where the player chooses from available upgrade cards.

## Exclusions

The following are explicitly excluded from this implementation scope:

- **Assets:** No new visual assets, sprites, or textures are produced by the Engineer. Placeholder assets may be used.
- **Animation:** No animation or VFX work is in scope. Animation/VFX Producer is not dispatched.
- **Audio:** No audio design or SFX is in scope. Audio Designer is not dispatched.

## Prerequisites

All prerequisites are confirmed complete before B2 dispatch:

| Prerequisite | Status | Evidence |
|---|---|---|
| Unit 1 | Complete, QA passed | Existing acceptance records |
| Unit 2 | Complete, QA passed | Existing acceptance records |
| Unit 3 | Complete, QA passed | Existing acceptance records |
| Unit 4 | Complete, QA passed | Existing acceptance records |
| M1 product milestone | User-approved (2026-08-18) | ADR-0002 addendum, M1_S2_CLOSEOUT_RECORD |

## Implementation owner

- **Domain role:** Godot Gameplay Engineer
- **Mission:** Implement B2 upgrade system mechanics as defined in Charter
- **Scope:** `production_mutation` via GDMCP; B2 mechanics only
- **Exclusions:** Assets, animation, audio, narrative content
- **Independent QA:** Will be dispatched after Engineer returns implementation evidence

## B2 mechanics reference (Charter-defined)

The Charter defines B2 as the first post-M1 upgrade layer:

1. Player collects upgrade triggers during gameplay.
2. At upgrade points (two per session), gameplay pauses and a card selection UI appears.
3. Player selects one upgrade card from available options.
4. The `穿透 → 扇裂` upgrade transforms the piercing attack pattern into a fan-shaped split attack.
5. After selection, gameplay resumes with the new upgrade active.

## Phase boundaries

- **B2 implementation:** In progress (Engineer dispatched).
- **B2 QA:** Pending Engineer handoff; Independent QA will be dispatched after implementation evidence.
- **B2 acceptance:** Pending Independent QA verdict.
- **S3 / M2:** Deferred / not entered; requires new User authorization.

## Change log

- **v0.1 — 2026-08-19 — Doc Scribe:** Recorded B2 upgrade system development kickoff. Engineer dispatched with Charter-defined scope. Prerequisites verified complete. Independent QA pending.