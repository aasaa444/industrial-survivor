# VISUAL PRODUCTION PLAN v0.1 — Visual Priority Upgrade

**document**: `VISUAL_PRODUCTION_PLAN_v0_1.md`
**version**: v0.1
**created**: 2026-08-19
**owner**: Executive Producer / Lead Producer
**authorization**: CR-VISUAL-PRIORITY-001 (user direct authorization)
**status**: `active / ready for dispatch`

## 1. Objective

Replace all current placeholder visuals (ColorRect-based player, enemies, scene, cards) with production-quality assets aligned to the `anchor_core_v0_1.png` baseline — rusty-industrial ("锈蚀末日霓光") with restrained cyan neon — while preserving the already-implemented and tested gameplay (Units 1-4, B2, card UX, 60/60 tests).

## 2. Scope

### In Scope

| Category | Deliverable | Current State | Target State |
|---|---|---|---|
| Player sprite | Character sheet (idle, 4-directional movement frames) | Blue ColorRect | Rusty-industrial silhouette with functional cool signal |
| Enemy sprite | Rusted humanoid family (walk, hit, death frames) | Orange ColorRect | Rusted-humanoid, distinguishable from environment |
| Scene background | Single-screen industrial arena | Black background | Bounded industrial arena (concrete, rust, old steel) |
| Card backgrounds | Styled card faces for upgrade selection | ColorRect + Label | Card faces per UX spec (keyword title + difference dimension) |
| Hit VFX | Hit particles / flash per enemy contact | Basic flash | Localized cyan-white core flash + light afterimage |
| Kill VFX | Enemy death dissolve/collapse | Basic shrink | Short rust-collapse dissolve, weighty but not occlusive |
| Upgrade VFX | Light effects for pierce acquire / fan split acquire | None | Visible same-source power step confirmation |
| Attack trajectory | Enhanced dual-line glow + fan-split arcs | Line2D dual glow | Enhanced with subtle VFX layers |
| Clear-screen VFX | Wave-clearing spatial result emphasis | None | Density drop, path opening, residual outward energy |
| Attack SFX | Directional energy-arc attack sound | None | Procedural or imported, short, weighty |
| Kill SFX | Enemy death sound | None | Short, layered, not fatiguing on repeat |
| Upgrade SFX | Card select + acquire confirmation | None | Distinct pierce/fan-split tones |
| BGM | Looping ambient background music | None | Low-key industrial ambient, non-intrusive, ~4-8 min loop |

### Out of Scope (unchanged from Charter)

- Bosses, elites, second arena, second enemy/weapon family
- Dash/dodge, gamepad, O2/meta, shop, currency
- Complete narrative, complete menus, complex tutorial
- Export/release, multi-platform assets
- Final asset polish beyond Slice needs

## 3. Roles and Deliverables

### 3.1 Concept Art Director (Phase 1)

**Depends on**: Nothing (reads existing docs)
**Blocks**: 2D Artist

**Deliverables**:
1. Finalize visual direction confirmation against `anchor_core_v0_1.png`
2. Produce palette board (specific hex values for the 8 color families from Style Manual v0.2)
3. Update Style Manual to v0.3 (or produce a standalone visual brief) with:
   - Confirmed palette with hex codes
   - Player silhouette direction (shape language, size ratio)
   - Enemy family silhouette direction
   - Scene arena composition reference
   - Card face visual language
4. Parameterized prompt packs for downstream 2D Artist

**Acceptance**: Game Director review of palette and silhouette direction. No asset production at this stage.

### 3.2 2D Artist (Phase 2)

**Depends on**: Concept Art Director (Phase 1 complete)
**Blocks**: Animation & VFX Producer (for integration, not for all VFX work)

**Deliverables**:
1. **Player sprite sheet**: 4-directional movement frames (or 8-directional if needed), idle frame, hit frame. Dimensions per existing game viewport (suggested: 64x64 or 96x96 px render at 2x for retina). Transparent background PNG.
2. **Enemy sprite sheet**: Rusted humanoid, walk frames, hit frame, death frames (2-3 frame dissolve). Same dimension convention as player.
3. **Scene background**: Single-screen industrial arena, 1920x1080 (or 1280x720 at 2x), tiling or single-image. Must leave readable space for player movement area.
4. **Card backgrounds**: 3 card face variants (pierce keyword family), 3 card face variants (fan-split keyword family). Dimensions per UX spec. Include hover/focus/selected state variants.

**Acceptance**: Technical Art Coordinator verifies import dimensions, transparency, pivot points. Game Director reviews against Anchor baseline.

### 3.3 Animation & VFX Producer (Phase 3)

**Depends on**: 2D Artist (for sprite integration); can begin VFX design in parallel after Phase 1
**Blocks**: None (final integration phase)

**Deliverables**:
1. **Hit particles**: Godot GPUParticles2D or CPUParticles2D, localized cyan-white flash on enemy contact. Duration ~150ms, self-clearing.
2. **Kill VFX**: Enemy death dissolve — short rust-toned collapse, 2-3 frame dissolve sprite or particle burst. Duration ~300ms. Must not occlude player or next danger.
3. **Upgrade light effects**: Brief full-screen (or card-area) confirmation flash on card selection. Distinct visual for pierce acquire vs fan-split acquire. Duration ~500ms.
4. **Attack trajectory enhancement**: Optional particle trail along the Line2D arc, subtle glow pulse on fire.
5. **Clear-screen emphasis**: When enemy density drops below threshold, subtle spatial-result effect (widening light, outward energy pulse). Must NOT become persistent luminous field.

**Acceptance**: Visual QA — player/danger/space hierarchy preserved. No occlusion of critical game information. Frame budget within candidate 50 FPS minimum.

### 3.4 Audio Designer (Phase 3, parallel)

**Depends on**: Concept Art Director (for tone alignment)
**Blocks**: None

**Deliverables**:
1. **Attack SFX**: Short directional energy-arc sound. ~200-400ms. Weighty but not harsh. Must layer well on rapid fire.
2. **Kill SFX**: Short enemy death sound. ~200-300ms. Layered — initial impact + decay. Non-fatiguing on repeat.
3. **Upgrade SFX**: Two distinct tones — pierce acquire (lower, sharper) and fan-split acquire (wider, richer). ~500ms each.
4. **BGM**: Looping ambient industrial track. ~4-8 minutes. Low-key, non-intrusive, builds subtly toward B2 phase. WAV or OGG Vorbis.

**Acceptance**: Audio review — no clipping, consistent loudness, layered playback without muddiness. All sounds play correctly through AudioStreamPlayer nodes.

## 4. Dependency Graph

```
Concept Art Director (Phase 1)
    |
    +---> 2D Artist (Phase 2)
    |         |
    |         +---> Animation & VFX Producer (Phase 3)
    |
    +---> Audio Designer (Phase 3, parallel)
```

## 5. Sequencing

| Phase | Role | Action | Depends On | Estimated Relative Effort |
|---|---|---|---|---|
| 1 | Concept Art Director | Palette + silhouette + prompt packs | None | 1 unit |
| 2 | 2D Artist | Player sprite, enemy sprite, scene BG, card BGs | Phase 1 complete | 3 units |
| 3a | Animation & VFX Producer | Hit/kill/upgrade/attack/clear-screen VFX | Phase 2 (sprites); Phase 1 (design) | 2 units |
| 3b | Audio Designer | Attack/kill/upgrade SFX, BGM | Phase 1 (tone) | 2 units |
| 4 | Technical Art Coordinator | Import verification, scene integration | Phases 2 + 3a + 3b | 1 unit |
| 5 | Independent QA | Visual QA, audio QA, regression (60 tests) | Phase 4 | 1 unit |

Effort units are relative, not calendar estimates. Phases 3a and 3b can run in parallel.

## 6. Acceptance Criteria

### Visual
1. Player distinguishable from enemies and background at combat density.
2. Enemy family visually coherent (rusted-humanoid) and distinguishable from environment.
3. Scene arena provides spatial context without occluding movement space.
4. Card faces readable at upgrade pause; hover/focus/selected states distinct.
5. Hit/kill VFX are brief, readable, and do not occlude next danger.
6. Upgrade VFX provide clear confirmation without blocking card readability.
7. Right-side B2 effects follow Director `recommend-revision`: area/brightness收敛, core→transition→falloff preserved, no persistent luminous field.
8. Color is never the sole state indicator.

### Audio
9. All SFX play at correct timing (attack fire, enemy death, upgrade confirm).
10. BGM loops seamlessly, does not overpower SFX, and can be muted independently.
11. No audio clipping or distortion at default volume.

### Regression
12. All 60 existing tests continue to pass.
13. Gameplay behavior (movement, attack targeting, contact, life, upgrade, victory/defeat, reset) unchanged.

## 7. Scope Boundaries (What We Are NOT Doing)

- NOT creating final production assets beyond Slice needs.
- NOT changing the 22-item user_confirmed baseline or PRECHARTER-01..11.
- NOT adding new gameplay mechanics, enemy types, or attack families.
- NOT implementing O2, meta-progression, shop, or currency.
- NOT adding gamepad support, dash, dodge, or new input methods.
- NOT exporting or releasing.
- NOT replacing the existing ECS architecture or state machine.
- NOT creating a persistent luminous field that substitutes for clearing.
- NOT accepting visual assets without independent Game Director review.

## 8. Communication

- **Single front door**: Executive Producer / Lead Producer
- **Creative arbitration**: Game Director / Creative Director
- **Technical arbitration**: Tech Lead (for import/performance concerns only)
- **Acceptance**: Independent QA / Release Lead
- **User intervention**: Milestone or escalation only (per Charter)

## 9. Risk Register

| Risk | Mitigation | Owner |
|---|---|---|
| Style drift from Anchor v0.1 baseline | Concept Art Director must reference anchor_core_v0_1.png; Director reviews palette before 2D production | Concept Art Director, Game Director |
| VFX occlusion of player/danger | VFX Producer must follow Style Manual layer priority rules; Visual QA gate | Animation & VFX Producer, QA |
| Audio fatigue on repeat | Short SFX, layered but not harsh; BGM low-key ambient | Audio Designer |
| Performance regression from particles | VFX budget per Charter candidate: 50 FPS minimum on reference hardware | Tech Lead, Animation & VFX Producer |
| Card background readability | 2D Artist must follow B2_CARD_UX_SPEC_v0_1.md; UX review | 2D Artist, UX/UI |
| Right-side B2 still too bright | Director's `recommend-revision` feedback must be applied; v0.2 learnings incorporated | Animation & VFX Producer, Game Director |

## 10. Recommended Dispatch Order

1. **Concept Art Director** — first, unblocked. Must complete before 2D Artist starts.
2. **2D Artist** — after Concept Art Director. Longest pole; start immediately when Phase 1 completes.
3. **Audio Designer** — can start after Phase 1 (tone established). Runs parallel to 2D Artist.
4. **Animation & VFX Producer** — can begin VFX design after Phase 1; full integration after Phase 2 sprites available.
5. **Technical Art Coordinator** — after Phases 2+3, integration and import verification.
6. **Independent QA** — final gate after all assets integrated.

## 11. Closure

`closure_ready = true` for this production plan. Dispatch authority rests with the Executive Producer. The Concept Art Director should be dispatched first, with the 2D Artist and Audio Designer following as soon as Phase 1 deliverables are reviewed.