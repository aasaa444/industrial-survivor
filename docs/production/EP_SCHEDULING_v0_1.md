# EP SCHEDULING v0.1 -- Visual Phase Completion Roadmap

**document**: `EP_SCHEDULING_v0_1.md`
**version**: v0.1
**created**: 2026-08-19
**owner**: Executive Producer / Lead Producer
**authorization**: CR-VISUAL-PRIORITY-001 (user direct authorization); Charter v0.1 (AUTHORIZED)
**status**: `active / ready for execution`
**preceding artifact**: `VISUAL_PRODUCTION_PLAN_v0_1.md` v0.1
**handoff source**: `HANDOFF_CROSS_WINDOW_2026_08_19.md`

---

## 0. Expert Preflight

| Question | Answer |
|---|---|
| What user-approved charter authorizes this work? | Development Charter v0.1 + CR-VISUAL-PRIORITY-001 (user direct authorization to elevate visual production to highest priority) |
| What mode and milestone are active? | Mode = `development`. Milestone = M1 visual production phase. Units 1-4 + B2 + card UX all QA-passed. Visual assets produced but not integrated. |
| What is immutable, delegated, and escalation-only? | Immutable: 22-item user_confirmed baseline, PRECHARTER-01..11, Slice cap, anchor v0.1 baseline. Delegated: VFX implementation method, import parameters, asset integration order. Escalation-only: any change to grace 1.0s / resolve delay 0.25s / attack_interval 0.6s; any new mechanic beyond current scope. |
| What is the critical path and highest-risk proof? | Phase 4 VFX Producer retry is the critical path. It failed once (model request errors). Phase 5 depends on Phase 4 completion. Phase 6 depends on Phase 5. |
| Who owns each mutable surface and who accepts it independently? | VFX code changes = Animation/VFX Producer (owner); Game Director (creative acceptance); Independent QA (acceptance gate). Asset integration = Technical Art (owner); Independent QA (acceptance gate). |
| What can the team decide without interrupting the user? | All local implementation choices within PROMPT_PACK constraints, Director feedback, and Style Manual rules. Retry strategy for Phase 4 failures. Import parameter selection. Audio integration method. |
| What exact conditions require escalation? | VFX implementation exceeding 5 retry attempts; main.gd structural refactoring needed; any change to immutable timing constants; performance below candidate 50 FPS minimum. |
| What is the reporting cadence and single front door? | Executive Producer is the single front door. User re-engaged only at Phase 6 QA completion or escalation conditions. |
| What is the stop or rollback condition? | If Phase 4 fails 5 consecutive times, stop and escalate to user with decision package. If Phase 6 QA fails with blocker, stop and escalate. |

---

## 1. Current State Assessment

### 1.1 Production Phase Matrix (as of 2026-08-19)

| Phase | Role | Status | Evidence | Remaining Work |
|---|---|---|---|---|
| 1 | Concept Art Director | COMPLETE | STYLE_MANUAL_v0_2.md (18.5KB), PROMPT_PACK_v0_1.md (22.9KB, includes VFX sections 5.1-5.6) | None |
| 1.5 | Game Director Review | COMPLETE | DIRECTOR_REVIEW_v0_1.md -- verdict: `approved_with_notes` | None (notes carried to downstream) |
| 2 | 2D Artist | COMPLETE | 7 PNG files in `godot_game_dev/assets/` | None (all assets landed) |
| 3 | Audio Designer | COMPLETE | 7 WAV files in `godot_game_dev/assets/audio/` | None (all audio verified) |
| 4 | Animation/VFX Producer | **FAILED** | Subagent 76707ff8 failed (model request errors); main.gd unmodified (no GPUParticles, no AnimationPlayer, no kill VFX) | **Full VFX integration required** |
| 5 | Technical Art (Asset Integration) | NOT STARTED | -- | All 7 PNG + 7 WAV integration |
| 6 | Independent QA | NOT STARTED | -- | Visual + audio + 60-test regression |

### 1.2 Asset Inventory

**Produced but not integrated (7 PNG)**:
```
godot_game_dev/assets/player_idle_raw.png       (1.1MB, _raw, unprocessed)
godot_game_dev/assets/player_attack_raw.png     (1.0MB, _raw, unprocessed)
godot_game_dev/assets/enemy_walker_raw.png      (1.2MB, _raw, unprocessed)
godot_game_dev/assets/enemy_brute_raw.png       (1.3MB, _raw, unprocessed)
godot_game_dev/assets/arena_bg.png              (3.4MB, unprocessed)
godot_game_dev/assets/card_pierce_raw.png       (2.0MB, _raw, unprocessed)
godot_game_dev/assets/card_fan_split_raw.png    (1.9MB, _raw, unprocessed)
```

**Produced but not integrated (7 WAV)**:
```
godot_game_dev/assets/audio/attack_normal.wav        (0.18s, PCM 16-bit mono 44100Hz)
godot_game_dev/assets/audio/attack_pierce.wav        (0.35s, PCM 16-bit mono 44100Hz)
godot_game_dev/assets/audio/enemy_death.wav          (0.45s, PCM 16-bit mono 44100Hz)
godot_game_dev/assets/audio/upgrade_open.wav         (0.30s, PCM 16-bit mono 44100Hz)
godot_game_dev/assets/audio/card_confirm.wav         (0.12s, PCM 16-bit mono 44100Hz)
godot_game_dev/assets/audio/upgrade_applied.wav      (0.40s, PCM 16-bit mono 44100Hz)
godot_game_dev/assets/audio/bg_industrial_ambient.wav (8.0s, PCM 16-bit mono 44100Hz)
```

### 1.3 Codebase Constraints

- `main.gd`: 67.6KB (45686 bytes post-B2-fix). VFX integration will add more. Structural refactoring is NOT in current scope but flagged as risk.
- Architectural seam: `main.gd` (presentation) vs `rules/rules_core.gd` (pure rules) vs `adapter/adapter.gd` (translation) vs `rules/session.gd` (session).
- All gameplay code is frozen for modification by non-VFX/non-art roles.
- Grace window (1.0s), resolve delay (0.25s), attack_interval (0.6s) are **immutable**.

---

## 2. Dependency Graph (Remaining Phases)

```
Phase 4: Animation/VFX Producer [CRITICAL PATH, RETRY]
    |
    v
Phase 5: Technical Art Coordinator [BLOCKED by Phase 4]
    |
    v
Phase 6: Independent QA [BLOCKED by Phase 5]
    |
    v
Archive: Git Commit [BLOCKED by Phase 6 pass]
```

**No parallelism is possible among the remaining phases.** Each phase modifies `main.gd` (or its scene tree), and concurrent modification would create merge conflicts and unverifiable state. The dependency chain is strict: VFX code must land before asset integration can reference the VFX hooks, and QA must run against the fully integrated state.

---

## 3. Phase 4 -- Animation/VFX Producer (RETRY)

### 3.1 Rationale for Priority

Phase 4 is the **sole failed item** in the production pipeline. It is the critical path: Phase 5 (asset integration) and Phase 6 (QA) are both blocked on its completion. The previous failure (subagent 76707ff8) was caused by model request errors, NOT by a design or technical obstacle -- the VFX specifications in PROMPT_PACK sections 5.1-5.6 are complete and the Director has reviewed them. This is a retry of a well-defined task, not a new exploration.

### 3.2 Dispatch Assignment

| Field | Value |
|---|---|
| Role | Animation/VFX Producer |
| Expert Skill | `$godot-animation-expert` |
| Dispatch Method | Subagent (single, not nested) |
| Authorization | CR-VISUAL-PRIORITY-001 (user direct authorization); within approved Charter v0.1 |

### 3.3 Task Scope

Implement 6 VFX systems in `res://runtime/main.gd` (and optionally new VFX helper scripts in `res://runtime/`), per PROMPT_PACK_v0_1.md sections 5.1-5.6:

| ID | VFX | Specification Source | Duration Target | Key Constraint |
|---|---|---|---|---|
| VFX-01 | Hit Impact Flash | PROMPT_PACK section 5.1 | ~150ms | Core->transition->falloff (cyan-white core #00f0ff -> mid-cyan #00e5ff -> dark cyan #00838f). Localized. No persistent glow. |
| VFX-02 | Kill Death Dissolve | PROMPT_PACK section 5.2 | ~300ms | Replace existing scale+fade tween. Rust-collapse feel. Weighty but brief. No full-screen flash. |
| VFX-03 | Attack Trajectory Arc | PROMPT_PACK section 5.3 | ~150ms | Enhance existing Line2D dual-line glow. Energy arc with afterimage. Subtle particle trail. |
| VFX-04 | B2 Pierce Clear-Screen | PROMPT_PACK section 5.4 | ~500ms | Horizontal line -> widening corridor -> open space. Spatial result IS the visual. Not a persistent luminous field. |
| VFX-05 | B2 Fan-Split Clear-Screen | PROMPT_PACK section 5.5 | ~600ms | Three arcs -> three corridors -> open space. Purple accent (#d500f9) distinguishes from pierce. |
| VFX-06 | Upgrade Card Selection | PROMPT_PACK section 5.6 | ~500ms | Card border pulse + expanding ring + particle burst. Cyan for pierce, purple for fan-split. |

### 3.4 Modification Scope

**ALLOWED to modify**:
- `res://runtime/main.gd` -- VFX hook points, particle nodes, tween sequences
- `res://runtime/` -- new VFX helper scripts (e.g., `vfx_manager.gd`) if needed
- `res://assets/` -- new VFX texture resources (particle textures, etc.)

**PROHIBITED from modifying**:
- `res://rules/rules_core.gd` -- pure rules, untouchable
- `res://rules/session.gd` -- session logic, untouchable
- `res://adapter/adapter.gd` -- translation layer, untouchable
- `project.godot` -- no project settings changes
- `InputMap` -- no input changes
- Any `Autoload` configuration

### 3.5 Technical Constraints

| Constraint | Value | Source |
|---|---|---|
| Grace window | 1.0s | Immutable (Charter) |
| Resolve delay | 0.25s | Immutable (Charter) |
| Attack interval | 0.6s | Immutable (Charter) |
| Current attack visual | Dual-line glow (Line2D), fan-split Bezier arcs, 50ms white flash on hit, scale+fade tween on kill | Existing code in main.gd |
| Frame budget | Candidate 50 FPS minimum (not hard gate) | Charter candidate budget |
| Godot version | 4.7.1-stable | Project config |
| GDMCP | Required for all scene/code mutations | Production mutation gate |

### 3.6 Director Feedback to贯彻 (from DIRECTOR_REVIEW_v0_1.md)

1. **Core -> Transition -> Falloff**: Every neon effect must have readable core (brightest, smallest), transition (softer, broader), falloff (fading, no hard edge).
2. **No persistent luminous field**: After brief high point, scene returns to ambient. B2 result is spatial (enemies gone, path open), not luminous.
3. **Player silhouette priority**: Player must be most stable, high-contrast element in every frame. VFX must not compete with player for attention.
4. **Clearing channel priority**: Primary visual result of B2 is broad, continuous cleared corridor -- not the energy effect itself.

### 3.7 Acceptance Criteria

1. All 6 VFX systems implemented and playable in-game.
2. Each VFX follows core->transition->falloff lighting principle.
3. No VFX creates a persistent luminous field.
4. B2 clear-screen VFX emphasizes spatial result (opened corridor) over energy effect.
5. Player silhouette remains highest-contrast element during all VFX.
6. All 60 existing QA tests continue to pass (60/60).
7. VFX do not block input (all animations must be non-blocking per Animation Expert contract).
8. No rules state mutation from VFX callbacks (Tween/AnimationPlayer).

### 3.8 Failure and Retry Protocol

| Attempt | Action |
|---|---|
| 1st attempt | Standard dispatch. If model request errors occur, save progress and write handoff. |
| 2nd attempt | Resume from handoff. If model request errors again, save and write handoff. |
| 3rd attempt | Resume from handoff. Consider splitting task (VFX-01..03 first, then VFX-04..06). |
| 4th attempt | Resume remaining VFX from split. If still failing, simplify VFX scope (reduce to core 3: hit, kill, upgrade). |
| 5th attempt | Last resort. If still failing, **STOP and escalate to user** with decision package: (a) accept simplified VFX, (b) accept no VFX and proceed to asset-only integration, (c) investigate environment issue. |

Each failed attempt must produce:
- Exact failure point (which VFX was being worked on)
- Code state (what was modified vs what was not)
- Handoff document for next attempt

### 3.9 Expected Deliverables

1. Modified `main.gd` with VFX hook integration
2. Any new VFX helper scripts in `res://runtime/`
3. Any new VFX texture resources in `res://assets/`
4. Runtime evidence: screenshot/video of each VFX playing correctly
5. 60/60 test verification
6. Handoff report for Phase 5 Technical Art

---

## 4. Phase 5 -- Technical Art Coordinator

### 4.1 Rationale

All 7 PNG and 7 WAV assets are produced but remain unintegrated. The game still renders ColorRect placeholders. This phase replaces every placeholder with production assets and wires all audio.

### 4.2 Dispatch Assignment

| Field | Value |
|---|---|
| Role | Technical Art Coordinator |
| Expert Skill | `$godot-technical-art-expert` |
| Dispatch Method | Subagent (single) |
| Authorization | CR-VISUAL-PRIORITY-001 |
| Blocked By | Phase 4 completion (VFX code must land first) |

### 4.3 Task Scope

#### 4.3.1 Visual Asset Integration (7 PNG)

| Asset | Current State | Target State | Integration Notes |
|---|---|---|---|
| `player_idle_raw.png` | _raw, unprocessed | Sprite2D replacing player ColorRect. Must handle transparency, pivot, scale to game resolution. | Replace ColorRect node with Sprite2D; load texture; set filter/antialiasing per import. |
| `player_attack_raw.png` | _raw, unprocessed | Sprite2D for attack pose (swap or AnimationPlayer). | May use same Sprite2D with texture swap on attack. |
| `enemy_walker_raw.png` | _raw, unprocessed | Sprite2D replacing enemy walker ColorRect. | Same approach as player. |
| `enemy_brute_raw.png` | _raw, unprocessed | Sprite2D replacing enemy brute ColorRect. | Distinct from walker by size/silhouette. |
| `arena_bg.png` | Unprocessed | Background TextureRect or Sprite2D. | Must not occlude gameplay area. Set z-index below all entities. |
| `card_pierce_raw.png` | _raw, unprocessed | Card face TextureRect in card UI. | Replace ColorRect card backgrounds. |
| `card_fan_split_raw.png` | _raw, unprocessed | Card face TextureRect in card UI. | Replace ColorRect card backgrounds. |

#### 4.3.2 Audio Integration (7 WAV)

| Asset | Current State | Target State | Integration Notes |
|---|---|---|---|
| `attack_normal.wav` | Unintegrated | AudioStreamPlayer2D on player node, triggered on normal attack fire. | Short (0.18s), must layer on rapid fire (0.6s interval). |
| `attack_pierce.wav` | Unintegrated | AudioStreamPlayer2D on player node, triggered on pierce attack fire. | Short (0.35s), triggered during B2 pierce phase. |
| `enemy_death.wav` | Unintegrated | AudioStreamPlayer2D or AudioStreamPlayer, triggered on enemy kill. | Short (0.45s), must not fatigue on repeat. |
| `upgrade_open.wav` | Unintegrated | AudioStreamPlayer, triggered when upgrade window opens. | 0.30s, plays once per upgrade event. |
| `card_confirm.wav` | Unintegrated | AudioStreamPlayer, triggered on card selection confirm. | 0.12s, very brief feedback. |
| `upgrade_applied.wav` | Unintegrated | AudioStreamPlayer, triggered when upgrade is applied (card resolved). | 0.40s, confirmation of power gain. |
| `bg_industrial_ambient.wav` | Unintegrated | AudioStreamPlayer, looping BGM from game start. | 8.0s loop, low-key ambient, non-intrusive. |

### 4.4 _raw Asset Preprocessing

The 5 `_raw` PNGs need preprocessing before integration:
1. **Background removal / transparency**: Ensure transparent backgrounds for player/enemy/card sprites.
2. **Crop to content**: Trim excess transparent space.
3. **Pivot point**: Set center or feet-bottom pivot as appropriate for top-down gameplay.
4. **Scale verification**: Confirm dimensions are appropriate for game viewport (player/enemy ~64-96px at game resolution; cards ~300x200 or per UX spec).
5. **Import settings**: Godot import parameters (filter, mipmaps, compression) to be set by Technical Art.

The Technical Art Coordinator must assess each `_raw` asset and determine if Godot's import pipeline can handle them directly or if pre-processing (crop, transparency, scale) is needed before import.

### 4.5 Acceptance Criteria

1. All 7 PNGs correctly imported as Sprite2D or TextureRect nodes in the game scene.
2. Player sprite visible, correctly scaled, with transparency, replacing blue ColorRect.
3. Both enemy sprites visible, correctly scaled, replacing orange ColorRects.
4. Arena background visible, positioned behind all gameplay elements.
5. Card backgrounds visible in upgrade UI, replacing plain ColorRects.
6. All 7 WAVs wired to correct game events via AudioStreamPlayer nodes.
7. BGM loops seamlessly without audible seam.
8. No audio clipping at default volume.
9. All 60 existing QA tests continue to pass (60/60).
10. Gameplay behavior unchanged (movement, attack, contact, life, upgrade, victory/defeat, reset).

### 4.6 Expected Deliverables

1. Modified `main.gd` with asset integration (Sprite2D nodes, AudioStreamPlayer nodes, texture loading)
2. Possibly modified scene files (if not all done via code)
3. Updated `.import` files for new assets
4. Runtime evidence: screenshots showing production assets in game
5. 60/60 test verification
6. Handoff report for Phase 6 QA

---

## 5. Phase 6 -- Independent QA

### 5.1 Rationale

The final gate before visual phase completion. Must independently verify visual, audio, and regression correctness. Cannot be performed by the same member who implemented Phases 4 or 5 (independence requirement).

### 5.2 Dispatch Assignment

| Field | Value |
|---|---|
| Role | Independent QA / Release Lead |
| Expert Skill | `$godot-qa-release-expert` |
| Dispatch Method | Subagent (single) |
| Authorization | CR-VISUAL-PRIORITY-001 |
| Blocked By | Phase 5 completion |

### 5.3 Acceptance Checklist

#### 5.3.1 Visual Acceptance (8 items)

| # | Criterion | Evidence Required |
|---|---|---|
| V-1 | Player distinguishable from enemies and background at combat density | Screenshot during dense combat (20+ enemies on screen) |
| V-2 | Enemy family visually coherent (rusted-humanoid) and distinguishable from environment | Screenshot of enemy cluster |
| V-3 | Scene arena provides spatial context without occluding movement space | Screenshot of full arena view |
| V-4 | Card faces readable at upgrade pause; hover/focus/selected states distinct | Screenshot of upgrade window with card interaction |
| V-5 | Hit VFX brief, readable, does not occlude next danger | Screenshot/video of hit effect (~150ms visible) |
| V-6 | Kill VFX brief, readable, does not occlude next danger | Screenshot/video of kill effect (~300ms visible) |
| V-7 | Upgrade VFX provide clear confirmation without blocking card readability | Screenshot of upgrade confirmation |
| V-8 | Right-side B2 effects follow Director feedback: area/brightness converged, core->transition->falloff preserved, no persistent luminous field, cleared corridor is primary visual result | Screenshot/video of B2 activation and aftermath |

#### 5.3.2 Audio Acceptance (3 items)

| # | Criterion | Evidence Required |
|---|---|---|
| A-1 | All SFX play at correct timing (attack fire, enemy death, upgrade confirm) | Audio log or manual verification with timestamps |
| A-2 | BGM loops seamlessly, does not overpower SFX, can be muted independently | Runtime observation of 2+ BGM loops |
| A-3 | No audio clipping or distortion at default volume | Audio level measurement or careful listening |

#### 5.3.3 Regression Acceptance (2 items)

| # | Criterion | Evidence Required |
|---|---|---|
| R-1 | All 60 existing tests pass (60/60) | GDMCP test output with all pass records |
| R-2 | Gameplay behavior unchanged (movement, attack targeting, contact damage, life, upgrade, victory/defeat, reset) | E2E gameplay session log |

#### 5.3.4 Evidence Integrity (per DC-ACC-02 Option B3)

All evidence must include:
- `evidence_id`: unique identifier
- `evidence_class`: visual / audio / runtime / static
- `gate`: which gate this evidence serves
- `criterion`: which criterion (V-1..V-8, A-1..A-3, R-1..R-2)
- `observer`: Independent QA (not the implementer)
- `verdict`: pass / fail / not_run
- `retest`: only if previous failure exists
- Missing any mandatory field = `not_run` (not pass)

### 5.4 Verdict

QA produces a single verdict:
- **PASS**: All 13 criteria (8 visual + 3 audio + 2 regression) pass with complete evidence. Phase closes.
- **CONDITIONAL PASS**: Minor non-blocker issues found. Phase closes with documented deviations.
- **FAIL**: One or more blocker issues. Phase does NOT close. Issues routed to appropriate Phase 4/5 owner for fix. Re-QA after fix.

### 5.5 Expected Deliverables

1. QA verdict document with all 13 criteria evaluation
2. Evidence records for each criterion
3. Defect log (if any) with severity, reproduction steps, and owner assignment
4. Phase closure recommendation

---

## 6. Archive (Git Commit)

### 6.1 Triggered By

Phase 6 QA verdict = PASS or CONDITIONAL PASS.

### 6.2 Scope

All uncommitted work since last commit (`baf211f`):
- Phase 4: VFX code in main.gd + any new VFX scripts/textures
- Phase 5: Asset integration code in main.gd + scene changes + import files
- Any Phase 6 QA evidence documents

### 6.3 Commit Message Convention

```
New_Game: visual production complete -- VFX + asset integration + audio wiring (phases 4-5, QA pass)
```

### 6.4 Owner

Executive Producer (archive responsibility per production plan).

---

## 7. Parallelism Analysis

### 7.1 Strict Serial (No Parallelism Possible)

| Pair | Reason |
|---|---|
| Phase 4 -> Phase 5 | Phase 5 integrates assets into the same `main.gd` that Phase 4 modifies for VFX. Concurrent modification = merge conflict. VFX hooks must exist before assets are wired to them. |
| Phase 5 -> Phase 6 | QA must run against the fully integrated state. Cannot QA partial integration. |
| Phase 6 -> Archive | Cannot commit unverified work. |

### 7.2 What Could Theoretically Parallel But Should NOT

| Parallel Opportunity | Why Not |
|---|---|
| Phase 4 VFX + Phase 5 asset import prep (crop, transparency) | Asset preprocessing is safe to do in parallel, BUT the integration code (replacing ColorRects, wiring AudioStreamPlayers) depends on knowing the final VFX node structure. Preprocessing assets (crop, scale, transparency) is safe prep work that could be front-loaded into the Phase 5 member's brief, but should NOT be dispatched separately as it increases coordination overhead for minimal time gain. |
| Phase 4 VFX + background documentation | Documentation work could run in parallel but is not scheduled (not in scope). |

### 7.3 Conclusion

**All three remaining phases (4, 5, 6) must execute strictly serially.** The dependency chain is hard-blocked by shared file mutation (`main.gd`) and the requirement that QA run against the final integrated state. The total pipeline is: Phase 4 (retry) -> Phase 5 -> Phase 6 -> Archive.

---

## 8. Risk Register

### 8.1 Risk: VFX Producer Model Request Errors (Recurrence)

| Field | Detail |
|---|---|
| Probability | MEDIUM (happened once; environment instability) |
| Impact | HIGH (blocks entire critical path) |
| Mitigation | 5-attempt retry protocol (section 3.8). Each attempt saves progress. Split task on 3rd failure. Simplify scope on 4th. Escalate on 5th. |
| Owner | Executive Producer (retry orchestration) |

### 8.2 Risk: main.gd Structural Bloat

| Field | Detail |
|---|---|
| Probability | HIGH (main.gd already 67.6KB; VFX + asset integration will add more) |
| Impact | MEDIUM (maintainability, but does NOT block functionality) |
| Mitigation | Accept bloat within current phase. Flag as future refactoring item. Do NOT refactor during visual production -- too risky for regression. After visual phase complete, recommend Tech Lead assess whether to extract VFX/asset code into separate scripts. |
| Owner | Tech Lead (assessment after visual phase) |

**Change Request Note**: If VFX Producer determines that main.gd is too large to modify safely and requires structural refactoring (extracting VFX into a separate script), this is within the Animation/VFX Producer's delegated authority as long as: (a) the architectural seam (rules vs presentation) is not violated, (b) the refactoring does not change any gameplay behavior, and (c) 60/60 tests still pass. No user escalation needed for this local implementation decision.

### 8.3 Risk: _raw Assets Require Significant Preprocessing

| Field | Detail |
|---|---|
| Probability | MEDIUM (assets are _raw, unprocessed; may need transparency removal, cropping, scaling) |
| Impact | MEDIUM (adds time to Phase 5 but does not block Phase 4) |
| Mitigation | Technical Art Coordinator should assess all _raw assets immediately upon Phase 5 start. If assets are unusable without significant preprocessing, escalate to Producer for decision (simplify vs. regenerate vs. accept rough integration). |
| Owner | Technical Art Coordinator (assessment), Executive Producer (decision if escalation needed) |

### 8.4 Risk: Performance Regression from VFX + Assets

| Field | Detail |
|---|---|
| Probability | LOW-MEDIUM (GPUParticles, additional sprites, audio streams all consume resources) |
| Impact | MEDIUM (if FPS drops below candidate 50 FPS, visual quality tradeoffs needed) |
| Mitigation | VFX Producer must measure FPS before/after VFX implementation. Technical Art must verify sprite import settings (compression, mipmaps) are performance-aware. QA includes FPS observation in visual acceptance. |
| Owner | Animation/VFX Producer (initial measurement), Technical Art (import optimization), Independent QA (final verification) |

### 8.5 Risk: Asset-Audio Mismatch

| Field | Detail |
|---|---|
| Probability | LOW (assets are produced and verified independently) |
| Impact | LOW (worst case: wrong audio on wrong event, easily fixable) |
| Mitigation | Technical Art wires audio to named events. QA verifies each audio plays on correct trigger. |
| Owner | Technical Art (wiring), Independent QA (verification) |

### 8.6 Risk: VFX Occludes Gameplay Information

| Field | Detail |
|---|---|
| Probability | MEDIUM (VFX can easily overshadow player/danger readability) |
| Impact | HIGH (breaks readability pillar, would be QA blocker) |
| Mitigation | VFX Producer must follow Director feedback: player silhouette priority, no persistent luminous field, clearing corridor as primary visual. QA visual acceptance checklist (V-1..V-8) specifically tests for occlusion. |
| Owner | Animation/VFX Producer (implementation), Game Director (creative review), Independent QA (acceptance) |

---

## 9. Change Request Record

### 9.1 CRs Within Current Scope (No New Authorization Needed)

All work described in this scheduling document falls within CR-VISUAL-PRIORITY-001 and Charter v0.1 scope. No new Change Requests are required.

### 9.2 Items Flagged as Potential Future Change Requests

| Item | Why It Might Need CR | When |
|---|---|---|
| main.gd structural refactoring | If file becomes too large for safe modification, extraction into separate scripts may cross the architectural seam boundary | After Phase 6, assessed by Tech Lead |
| VFX simplification | If 5th retry still fails, accepting simplified VFX is a product decision (user decision) | Only if 5th retry fails |
| Performance budget promotion | If VFX+assets push FPS below candidate threshold, promoting 50 FPS to formal gate requires CR | Only if measured below 50 FPS |
| _raw asset regeneration | If Technical Art determines _raw assets are unusable, regenerating assets may require 2D Artist re-dispatch | Only if assets fail preprocessing assessment |

### 9.3 No Scope Changes

This scheduling document does NOT change:
- The 22-item user_confirmed baseline
- PRECHARTER-01..11
- The Slice cap or exclusions
- Any immutable timing constants (grace, resolve delay, attack interval)
- The anchor v0.1 baseline
- The Charter version or authorization status

---

## 10. Execution Summary

| Phase | Role | Skill | Depends On | Estimated Effort | Status |
|---|---|---|---|---|---|
| 4 (retry) | Animation/VFX Producer | `$godot-animation-expert` | Nothing | High (6 VFX systems) | Ready to dispatch |
| 5 | Technical Art Coordinator | `$godot-technical-art-expert` | Phase 4 | Medium (7 PNG + 7 WAV integration) | Blocked |
| 6 | Independent QA | `$godot-qa-release-expert` | Phase 5 | Medium (13 criteria + evidence) | Blocked |
| Archive | Executive Producer | N/A | Phase 6 pass | Low (git commit) | Blocked |

### 10.1 User Authorization Status

- **User authorization**: Granted (CR-VISUAL-PRIORITY-001, user direct authorization)
- **Producer execution authority**: Active within Charter v0.1
- **User re-engagement**: Only at (a) Phase 6 QA completion, (b) escalation after 5th retry failure, (c) performance budget promotion
- **Automatic progression**: Phases 4 -> 5 -> 6 -> Archive execute sequentially without user intervention per user-approved standing authorization

### 10.2 Next Immediate Action

**Dispatch Phase 4 Animation/VFX Producer (retry).**

The subagent should:
1. Load `$godot-animation-expert` skill
2. Read PROMPT_PACK_v0_1.md sections 5.1-5.6 for VFX specifications
3. Read DIRECTOR_REVIEW_v0_1.md for creative feedback constraints
4. Read STYLE_MANUAL_v0_2.md for palette and lighting rules
5. Read current `main.gd` to understand existing VFX hooks and presentation layer
6. Implement VFX-01 through VFX-06 per specifications
7. Run GDMCP validation and 60/60 test suite
8. Produce runtime evidence (screenshots/video)
9. Write handoff for Phase 5 Technical Art

---

## 11. Closure

- **Artifact**: `EP_SCHEDULING_v0_1.md` v0.1
- **Authorization**: CR-VISUAL-PRIORITY-001 (user direct authorization); Charter v0.1 (AUTHORIZED)
- **Mode**: `development` (visual production phase)
- **Status**: `active / ready for execution`
- **Critical path**: Phase 4 VFX Producer retry
- **Serial dependency**: Phase 4 -> Phase 5 -> Phase 6 -> Archive
- **User decisions required**: None at this time (escalation only if 5th retry fails or performance critical)
- **closure_ready**: `true` for this scheduling document
- **Next action**: Dispatch Phase 4 Animation/VFX Producer subagent
