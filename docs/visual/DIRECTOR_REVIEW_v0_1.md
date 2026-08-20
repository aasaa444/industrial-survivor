# DIRECTOR REVIEW v0.1 -- Style Manual v0.2 + Prompt Pack v0.1

- **reviewer**: Game Director / Creative Director
- **review date**: 2026-08-15
- **objects reviewed**: `STYLE_MANUAL_v0_2.md`, `PROMPT_PACK_v0_1.md`
- **reference**: `ANCHOR_REVIEW_v0_2.md` (Director's prior feedback)
- **evidence class**: `static/source` only -- documents reviewed as text; no visual, runtime, QA, build, or asset evidence was inspected
- **lifecycle**: preproduction creative review; not a QA, technical, release, or user acceptance verdict

---

## 0. Expert Preflight

- **user-confirmed direction**: "rusted doomsday neon" (锈蚀末日霓光), from `CREATIVE_BRIEF.md` v0.3 sec.7.1
- **player promise**: simple movement + auto-attack through enemy hordes, with clear, weighty feedback producing escalating clear-screen satisfaction
- **immutable**: user owns final aesthetic acceptance; this review is a creative recommendation, not a product decision
- **Director-owned**: creative coherence of the visual language against the player promise
- **not assessed**: production readiness, schedule, architecture, QA, runtime behavior
- **stop condition**: if code, runtime, QA, or asset production is required, stop and return to decision gate
- **top creative risks**:
  1. Neon effects overwhelming spatial readability
  2. Clear-screen result not visually dominant over the effect itself
  3. Player silhouette losing priority in dense frames
- **evidence boundary**: this review inspects only the two documents listed above plus the anchor review reference; it does not inspect actual images, runtime frames, or generated assets

---

## 1. Player Promise Consistency -- Rusted Industrial + Clear-Screen Dominance

**Style Manual**: The manual correctly anchors the entire visual language to "rusted doomsday neon." The four-layer brightness hierarchy (ambient 0-40%, entities 40-70%, signals 70-100%) maps cleanly to the promise: the world is heavy and dark, the player's neon cuts through it. Section 5.2 explicitly incorporates the prior Director feedback on B2 convergence, clearing channel priority, and player silhouette priority. The mood arc in sec.4.4 (pressure -> clearing -> relief) is a strong articulation of the non-punishing rhythm pillar.

**Prompt Pack**: The player prompts consistently use the "dark silhouette with localized cyan accent" formula. Enemy prompts lock them into the rust palette with no cyan. The arena prompt establishes the oppressive-but-not-horror tone. The card prompts follow the "rusted artifact with neon accent" rule.

**Finding**: The player promise is well-served by both documents. The rust/neon contrast is clear, and the B2 clear-screen spatial-result-over-luminous-effect principle is embedded in both the rules and the constraints.

**Risk note**: The prompt pack contains no dedicated B2 clear-screen VFX prompt (see sec.6 below). The clear-screen dominance -- the primary satisfaction source -- is described in rules but not directly prompted for production.

---

## 2. Experience Pillars -- Readability, Non-Punishing Rhythm, Low Cognitive Choice

**Readability**: The style manual addresses this through multiple mechanisms:
- Brightness range separation (sec.4.1)
- Non-color encoding rule (sec.1.8 rule #5): shape, silhouette, position, icon, and brightness must carry at least one additional encoding for every state
- Player silhouette priority (sec.2.1, anti-drift checklist)
- Enemy group-readability as "rust mass" rather than individual figures (sec.2.2)

The prompt pack inherits these constraints through the generation constraints (sec.6) and references the anti-drift checklist in the iteration protocol.

**Non-punishing rhythm**: The style manual's mood arc (sec.4.4) and the insistence that all effects return to ambient (anti-drift checklist) directly support this. The prompt pack's enemy death frame -- "weighty but brief, rust-collapse not a spectacle" -- aligns well.

**Low cognitive choice**: This is primarily a UX/gameplay concern, but the visual language contributes: the player's cyan is the only "new" thing in the frame, reducing the need to parse multiple signal colors. The scene element anti-drift (sec.2.3) ensures decorations are not confused with interactable elements.

**Finding**: The pillars are well-addressed at the rule level. The prompt pack translates them into generation constraints. No gaps identified.

---

## 3. Palette -- Cyan Player Exclusivity, Rust Enemies, Non-Color Differentiation

**Style Manual**: The palette is the strongest section. Eight families with 30+ hex values, each with explicit roles and constraints. The usage rules (sec.1.8) are unambiguous:
- Cyan (`#00e5ff` family) is player-exclusive
- Rust (`#8b3a1a` family) is environment/enemy
- Yellow separates danger (`#c6ff00`) from reward (`#ffd600`)
- Purple is elite/rare only
- Non-color encoding is mandatory

**Prompt Pack**: Every prompt explicitly states palette constraints. Hex values are embedded in the prompt text, which is useful for precision but may confuse some image generators that interpret hex codes literally rather than as color targets. The generation constraints (sec.6) reinforce the exclusivity rules.

**Finding**: The palette is production-ready. The non-color encoding rule is correctly positioned as a hard constraint. The one risk is that inline hex codes in prompts may produce inconsistent results across different image generation models -- the 2D Artist should treat them as targets, not as literal color picker values.

**Minor note**: The "Desaturated Green" family (sec.1.7) is labeled "Collection / O2 (future)" but the style manual's scope (sec.0) says "no O2" elements. This is a forward-looking placeholder and not a contradiction, but it could confuse a 2D Artist who reads the palette before the scope constraints.

---

## 4. Silhouette -- Player Recognizable, Enemies Group-Readable, No Confusion

**Style Manual**: The silhouette directions are concrete and actionable:
- Player: inverted triangle, recognizable crest/helmet, internal negative space, functional cyan signal as localized accent (sec.2.1)
- Enemies: hunched, asymmetrical, deteriorating, two variants with distinct weight profiles, group-readability as "rust mass" (sec.2.2)
- Scene elements: angular vs. organic-hunched distinction from enemies (sec.2.3)
- Anti-drift: player not a glowing mass, enemies not glowing, decorations not confused with interactables

**Prompt Pack**: Player prompts specify the hood/helmet crest, the localized cyan generator, and the transparent background. Enemy prompts specify the hunched/asymmetrical posture, the rusted plates, and the dim amber eye point. The prop sheet prompt explicitly states "angular and mechanical, not organic -- they must not be mistaken for enemies."

**Finding**: Silhouette directions are clear and consistent across both documents. The group-readability concept (enemies merge into a readable rust mass) is a strong design choice for the horde-survivor genre.

**Risk note**: The "rust mass" group-readability is a deliberate design choice, but it carries an inherent tension with individual enemy readability. The manual correctly relies on silhouette and movement rather than color for enemy distinction. The 2D Artist will need to verify that the two enemy variants are distinguishable at game resolution (64-96 px) when clustered -- the prompt pack's iteration protocol (sec.7) includes a "scale down to check" step, which addresses this.

---

## 5. Material / Lighting -- Core->Transition->Falloff, No Persistent Luminous Field

**Style Manual**: Section 4.3 explicitly encodes the Director's prior feedback as a requirement. The three-layer structure (core, transition, falloff) is described with clear spatial relationships: "brightest, smallest area" -> "softer, broader" -> "fading, no hard edge." The B2-specific constraint (right-side convergence: bright ring smaller than transition zone, falloff quiet enough that the cleared corridor reads as primary result) is carried forward from the anchor review.

The material section (sec.3) establishes the concrete/steel/rust material language with specific progression rules (rust spreads from edges, seams, bolt holes -- not uniform coating). The player/enemy material contrast (surviving vs. deteriorating) is clear.

The anti-drift checklist includes: "Does every neon effect have a readable core -> transition -> falloff?" and "Is the B2 result a spatial clearing, not a persistent glow?"

**Prompt Pack**: The player attack frame prompt explicitly describes the arc with core (`#00f0ff`), mid (`#00e5ff`), and falloff (`#00b8d4`). The enemy hit frame uses localized cyan flash with core-to-fade. The generation constraints (sec.6, rule #3) mandate "no persistent luminous field -- any glow must be localized and have a clear core->transition->falloff."

**Finding**: The core->transition->falloff requirement is well-integrated into both documents. The prohibition on persistent luminous fields is consistently enforced.

**Gap**: The prompt pack's player attack frame prompt describes the arc's three-layer glow, but the card state variants prompt (sec.4.3) uses "edge glow" and "inner glow" without explicit core->transition->falloff language. The disabled state dims to grey, which is correct. This is a minor inconsistency -- the card glow is low-risk compared to gameplay effects, but it should follow the same three-layer principle.

---

## 6. Prompt Pack -- Directly Deliverable to 2D Artist?

**Strengths**:
- Well-organized by asset category with clear knob system
- All prompts include size, perspective, palette, and style constraints
- Generation constraints (sec.6) are comprehensive and correct
- Iteration protocol (sec.7) is practical: one-at-a-time, check against anchor and manual, do not batch
- The knob reference table (sec.5) is clear and complete

**Gaps -- assets listed in style manual scope (sec.0) but missing from prompt pack**:

| Asset Type | Style Manual Scope | Prompt Pack Coverage |
|---|---|---|
| Player sprite | ✅ | ✅ 4 poses (idle, move, attack, hit) |
| Enemy sprites (2+ variants) | ✅ | ✅ 2 variants, 2 poses each |
| Scene background | ✅ | ✅ Arena + props |
| Card backgrounds | ✅ | ✅ 2 keywords + states |
| Hit/kill VFX | ✅ | ❌ No standalone VFX prompt -- enemy death is character animation, not VFX |
| Attack trajectory | ✅ | ❌ No dedicated trajectory/arc VFX prompt |
| Upgrade VFX | ✅ | ❌ Not addressed |
| Clear-screen VFX | ✅ | ❌ No dedicated B2 clear-screen prompt |

**Critical gap**: The B2 clear-screen VFX is the primary satisfaction source per the Creative Brief. The prompt pack has no prompt for the B2 energy pulse, the expanding/fading ring, the cleared corridor visualization, or the post-clear ambient return. The rules exist in the style manual (sec.4.2, 4.3, 5.2), but the 2D Artist has no prompt to execute against.

**Secondary gaps**:
- The card state variants prompt (sec.4.3) combines hover, selected, and disabled into one prompt. In practice, generating these as separate prompts gives the artist more control over each state.
- No prompt for the player's "afterimage" or "residual glow" (faded cyan `#4dd0e1`, per palette sec.1.4). The style manual describes this as a brief effect, but no prompt exists.
- The prompts embed hex codes in natural language, which may produce unpredictable results with some image generation models. A note to the 2D Artist about treating hex values as color targets rather than literal output expectations would reduce iteration friction.

**Finding**: The prompt pack covers character and environment assets well but is incomplete for VFX. The B2 clear-screen prompt is the most significant omission. The pack is not yet fully deliverable to a 2D Artist for a complete first-pass asset set.

---

## 7. Creative Verdict

**`approved_with_notes`**

The style manual is a coherent, well-structured creative document that correctly encodes the player promise, experience pillars, palette rules, silhouette directions, material language, and the core->transition->falloff lighting requirement. The prior Director feedback from `ANCHOR_REVIEW_v0_2.md` is incorporated explicitly and correctly.

The prompt pack is substantially correct and well-organized, but it is incomplete for VFX assets. The absence of a B2 clear-screen prompt is the single most significant gap -- the primary satisfaction source has no production prompt. The hit/kill VFX, attack trajectory, and upgrade VFX prompts are also missing, though these are secondary to the clear-screen gap.

Both documents are `team_proposal` status. This review does not upgrade them to user-confirmed; that remains the user's authority.

---

## 8. Specific Revision Notes

### Style Manual v0.2

1. **Four-layer grammar inheritance** (sec.0): The manual inherits the four-layer grammar from the v0.2 draft but does not reproduce it. If the 2D Artist does not have access to the draft, the grammar is effectively lost. Recommend including the four-layer grammar inline or citing a specific accessible source.

2. **Green palette forward reference** (sec.1.7): Labeled "Collection / O2 (future)" but the scope says "no O2." Add a note that this family is reserved for future use and must not appear in current-slice assets.

3. **Card glow language** (sec.3.4): The card hover/selected states use "edge glow" and "inner glow" without explicit core->transition->falloff mapping. Consider adding the three-layer structure to card state descriptions for consistency.

### Prompt Pack v0.1

4. **Missing: B2 clear-screen VFX prompt** (critical). Add a prompt covering:
   - The expanding/fading cyan ring (core `#00e5ff` -> transition `#00b8d4` -> falloff to ambient)
   - The cleared corridor as the primary visual result
   - The ~500ms dissipation timeline
   - The post-pulse return to ambient lighting

5. **Missing: standalone hit/kill VFX, attack trajectory, upgrade VFX prompts**. These are listed in the style manual scope. Either add prompts or explicitly document why they are deferred to a later prompt pack version.

6. **Card state variants** (sec.4.3): Consider splitting the combined state prompt into three separate prompts for finer artist control. If kept as one, add a note that the artist should generate each state independently.

7. **Hex code usage note**: Add a brief note to the iteration protocol (sec.7) that hex codes in prompts are color targets, not literal output expectations -- the 2D Artist should verify against the style manual's swatches, not the prompt text.

8. **Player afterimage prompt**: The faded cyan (`#4dd0e1`) afterimage is described in the palette (sec.1.4) but has no production prompt. Either add one or document that it is a post-processing effect handled in-engine.

---

## 9. Next Action

The Concept Art Director should revise the prompt pack to include the missing VFX prompts (priority: B2 clear-screen, then hit/kill VFX, then attack trajectory, then upgrade VFX). The style manual revisions are minor and can be addressed in the next version.

After revision, the prompt pack should be re-submitted for a follow-up Director review before 2D Artist dispatch.

---

## 10. Separate States

- **creative verdict**: `approved_with_notes`
- **user decision**: pending -- user retains final aesthetic acceptance authority
- **QA**: not run
- **technical/runtime**: not assessed
- **style manual status**: remains `team_proposal`; not upgraded to user-confirmed
- **prompt pack status**: remains `team_proposal`; not ready for 2D Artist dispatch until VFX gaps are addressed
- **v0.1 anchor baseline**: unchanged

---

## 11. Closure Evidence

- **inspected**: `STYLE_MANUAL_v0_2.md`, `PROMPT_PACK_v0_1.md`, `ANCHOR_REVIEW_v0_2.md`
- **not inspected**: actual images, runtime frames, generated assets, GDD, Creative Brief, Discovery Handoff, code, or Godot project files
- **not modified**: any file other than this review document
- **evidence class**: `static/source` only
- **closure_ready**: `true`