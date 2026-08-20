# CR-VISUAL-PRIORITY-001 — Change Request Record

**cr_id**: `CR-VISUAL-PRIORITY-001`
**created**: 2026-08-19
**status**: `authorized / effective`
**disposition**: `absorb_within_authority`

## 1. Source

- **Origin**: 用户直接授权（User direct authorization）
- **原始表述 (Original statement)**: "视觉优先级提升为最高。将 Charter 中标记为'延后'的资产/动画/音频提升到当前开发优先级。"
- **Provenance**: 当前会话用户明确指令，非团队提案、非沉默推断。

## 2. Charter Reference

| Field | Value |
|---|---|
| Current Charter version | `Development Charter v0.1` |
| Charter status | `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY` |
| Charter lifecycle | `development governance / kickoff readiness preparation` |
| Affected immutable_decisions | None modified. The 22-item user_confirmed baseline, PRECHARTER-01..11, strict Slice cap, and exclusions remain unchanged. |
| Affected Charter sections | Section 5 (Scope baseline) — visual asset/audio production was previously listed as out-of-scope for the initial implementation phase; Section 7 (Technical workstreams) — the "UX/visual integration" workstream is accelerated; Section 8 (Production plan) — resequencing |

## 3. Impact Assessment

### 3.1 Product Impact
- **无产品承诺变更**: The player promise, experience pillars, Slice intent, and B2 structure remain exactly as recorded in Charter v0.1 and GDD v0.1.
- **视觉呈现升级**: The existing gameplay (Units 1-4, B2 upgrade system, card UX, attack visuals) gains production-quality visual assets replacing the current ColorRect placeholders.
- **Anchor 基线不变**: `anchor_core_v0_1.png` (v0.1) remains the user-accepted baseline. Director verdict `recommend-revision` on v0.2 is preserved; v0.2 does not auto-replace v0.1.

### 3.2 Creative Impact
- **Game Director boundary preserved**: The Director's independent creative review authority is unchanged. Visual production must align with the Director's `recommend-revision` feedback: right-side B2 ring area/brightness收敛, core→transition→falloff preserved, clearing corridor emphasized, no persistent luminous field.
- **Style Manual v0.2**: remains draft; the Concept Art Director should finalize or supersede it as part of this production push.

### 3.3 Technical Impact
- **No architecture change**: The existing ECS architecture, attack system, card system, and state machine are unaffected.
- **Sprite replacement**: ColorRect nodes (player, enemies) become Sprite2D with imported textures. Line2D attack visuals may be enhanced with additional VFX layers.
- **Audio engine**: AudioStreamPlayer nodes added; no AudioServer bus rearchitecture needed.

### 3.4 Scope Impact
- **In scope (new)**: Player character sprite, enemy sprite, scene background, card backgrounds, hit particles, kill VFX, upgrade light effects, attack trajectory animations, attack SFX, kill SFX, upgrade SFX, ambient BGM.
- **Still out of scope**: Bosses, elites, second arena, second enemy/weapon family, dash/dodge, gamepad, O2/meta, shop, currency, multiplayer, complete narrative, complete menus, full UI, export/release.

### 3.5 Schedule Impact
- **被挤出的工作 (Displaced work)**: The Charter's planned next-phase items (formal ADR package completion, pure rules seam, deterministic core contract finalization) were already de facto overtaken by the user's direct implementation authorization. This CR formally acknowledges that the current priority is visual production, and the remaining Charter governance formalities (TECH-07/08 ADRs, formal Gate 2-6 execution) are deferred until after the visual baseline is established.
- **不失焦安全机制**: The Charter's existing safety boundaries (no-target branch, contact safety, upgrade pause, focus-loss recovery, life depletion priority, short result + auto restart) are already implemented and tested (60/60). They remain in place and are not displaced.

## 4. Producer Disposition

**`absorb_within_authority`**

Rationale:
1. The user is the product authority and has explicitly authorized this priority change.
2. The Producer owns sequencing and dependency control within the approved Charter.
3. No Charter immutable decision, promise, pillar, platform, architecture risk, or release commitment is changed.
4. The strict Slice cap and exclusions remain intact.
5. Visual production stays within the existing scope — it upgrades the presentation layer of already-implemented and tested gameplay.

This CR does NOT trigger `reauthorize_charter`: no promise/immutable/platform/threshold/release crossing occurs.

## 5. Owner & Acceptance

| Field | Value |
|---|---|
| **Owner (排程)** | Executive Producer / Lead Producer |
| **Visual production dispatch** | Per VISUAL_PRODUCTION_PLAN_v0_1.md |
| **Creative acceptance** | Game Director / Creative Director (independent review) |
| **QA acceptance** | Independent QA / Release Lead (visual QA, not self-certified by producers) |
| **User acceptance** | User final aesthetic approval |

## 6. Acceptance Criteria

1. Player character replaced from blue ColorRect to production sprite matching rusty-industrial Anchor v0.1 baseline.
2. Enemy characters replaced from orange ColorRect to production sprites in the rusted-humanoid family.
3. Scene background replaced from black void to bounded single-screen industrial arena.
4. Card backgrounds upgraded from plain ColorRect to styled card faces consistent with the UX spec (B2_CARD_UX_SPEC_v0_1.md).
5. Attack visuals (dual-line glow, fan-split arcs, hit flash, kill animation) enhanced with production VFX.
6. Hit particles, kill effects, and upgrade light effects implemented and readable.
7. Attack SFX, kill SFX, and upgrade SFX implemented.
8. Ambient BGM (loopable, non-intrusive) implemented.
9. All 60 existing tests continue to pass.
10. Visual QA confirms: player/danger/space readability, no occlusion of critical gameplay information, color-non-dependent state distinction.

## 7. Related Documents

- `VISUAL_PRODUCTION_PLAN_v0_1.md` — detailed sequencing and role assignments
- `DEVELOPMENT_CHARTER_DRAFT_v0_1.md` — governing Charter
- `GDD_SLICE_v0_1.md` — design baseline
- `docs/visual/anchor/ANCHOR_DECISION.md` — Anchor v0.1 baseline
- `docs/visual/anchor/ANCHOR_REVIEW_v0_2.md` — Director review with `recommend-revision`
- `docs/visual/STYLE_MANUAL.md` — draft Style Manual v0.2

## 8. Closure

`closure_ready = true` for this CR record. The CR is authorized and effective. Execution proceeds per VISUAL_PRODUCTION_PLAN_v0_1.md.