# M1 S2 Lessons and Workflow Record v0.1

- **Status:** `accepted`
- **Owner:** Doc Scribe / Phase-Closure Owner
- **Date:** 2026-08-18
- **Scope:** Reusable workflow lessons from M1 S2; procedural record, not a game implementation specification.

## SOP

1. **Local toolchain first.** Resolve and invoke the project-local absolute GDMCP binary at `D:\Game\New_Game\godot_game_dev\.gdmcp\bin\gdmcp.exe` through `tools/gdmcp.ps1` / `tools/GDMCP_LAUNCHER.md`. Never use a bare PATH fallback. Run check-only doctor/editor-state preflight before mutation or runtime work.
2. **Diagnose before mutating.** Prefer read-only diagnosis, source inspection, and editor-state inspection before any mutation. Preserve action-chain and registry caveats; an action record is not proof unless its registry/evidence chain is inspectable.
3. **Use semantic contracts.** Runtime names and groups must be semantic, not positional or generated-name assumptions. Input behavior must use InputMap action semantics, not raw key assumptions.
4. **Make timing deterministic.** First-frame and first-attack timing are evidence-sensitive. Use a fixed-tick fixture for deterministic movement and capture actual before/after runtime state, not only source declarations.
5. **Keep evidence honest.** Record fixture/scenario/build/seed/tick/clock/observer metadata. Label actual runtime evidence separately from source-only or handoff facts. Keep the fixture isolated while anchoring it to production adapter/session/rules.
6. **Handoff cleanly.** Engineer reports implementation scope and changed files; Independent QA owns acceptance and observes a fresh runtime. Do not repeat QA without candidate evidence. Do not substitute Unit or Gate evidence: each evidence class remains non-substitutable.
7. **Coordinate background members correctly.** After dispatch, do not poll, checkpoint, or treat a waiting round as failure. Wait only for a real terminal report. Do not run a goal auto-loop or injection while a member is running.
8. **Stop and roll back explicitly.** Use explicit stop conditions and rollback boundaries. Escalate reserved decisions through CR plus User approval; do not promote candidate values to rules, Gates, performance commitments, or release claims by implication.

## Current-round application

- S2 used a QA-only fixed-step fixture with production anchors.
- Fresh Independent QA observed the complete movement → legal hit → kill_clear → pressure reduction → after snapshot → recovery → next movement chain and clean stop.
- The exact verdict remains `S2 fixture acceptance evidence complete`.
- R08 Option 2 is inactive; S3/B2 and later work are deferred/not entered.

## Change log

- **v0.1 — 2026-08-18 — Doc Scribe:** Captured reusable workflow and evidence lessons from this round.
