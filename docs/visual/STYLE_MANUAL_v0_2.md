# STYLE MANUAL v0.2 -- Rusted Doomsday Neon (锈蚀末日霓光)

- **version**: v0.2
- **author**: Concept Art Director
- **status**: `team_proposal` -- awaiting Game Director review and user final aesthetic acceptance
- **upstream**: `anchor_core_v0_1.png` (user-accepted baseline), `ANCHOR_REVIEW_v0_2.md` (Director `recommend-revision`), `STYLE_MANUAL.md` v0.2 draft (historical), `CREATIVE_BRIEF.md` v0.3 sec.7.1
- **inherits**: Style Manual v0.2 draft four-layer grammar (bottom decay / middle entity / upper signal / transient climax); layer priority rules; clearing-path principle; non-color encoding
- **new in this version**: specific hex palette, silhouette directions, material/texture directions, lighting/atmosphere directions, Director feedback incorporation
- **evidence boundary**: static document only; no runtime, QA, build, or asset evidence

---

## 0. Expert Preflight

- **tone source**: `CREATIVE_BRIEF.md` v0.3 sec.7.1 -- "rusted doomsday neon" (user_confirmed high-level visual direction)
- **anchor status**: `anchor_core_v0_1.png` = user-accepted baseline; `anchor_core_v0_2.png` = unaccepted refinement candidate
- **style manual status**: this v0.2 replaces the prior draft with concrete hex values and silhouette directions; still `team_proposal` until Director review
- **asset types in scope**: player sprite, enemy sprites (1 family, 2+ variants), scene background, card backgrounds, hit/kill/upgrade VFX, attack trajectory, clear-screen VFX
- **cost estimate**: 0 image generation calls; this is a static rule document
- **decision boundary**: user owns final aesthetic acceptance; Game Director owns independent creative review; this role proposes rules
- **stop condition**: if asset production, Godot access, runtime, build, QA, or acceptance is required, stop and return to decision gate

---

## 1. Palette -- Confirmed Hex Values

All values are `team_proposal`. Final acceptance requires Director review.

### 1.1 Background / Depth (炭黑-煤灰 family)

| Swatch | Hex | Role | Constraint |
|--------|-----|------|------------|
| Void | `#1a1a1e` | Deepest background, void, arena edges | Never pure `#000000`; must retain faint blue-black warmth |
| Shadow | `#252528` | Shadowed ground, recessed walls | Use for large-area dark fill |
| Mid-dark | `#2e2e33` | Mid-ground shadow, concrete depth | Bridge between void and steel |
| Steel dark | `#3d3d42` | Worn steel shadow side | Must not compete with entity layer |

### 1.2 Rust / Industrial Core (铁锈-氧化红 family)

| Swatch | Hex | Role | Constraint |
|--------|-----|------|------------|
| Deep rust | `#5c2612` | Heavy corrosion, old bloodstains | Environment only; not on player |
| Mid rust | `#8b3a1a` | Standard rust, oxidized iron | Primary environment rust tone |
| Bright rust | `#b85c2e` | Fresh rust, impact points, edge wear | Use sparingly; signals recent damage |
| Oxide orange | `#d4784a` | Light rust, transition to bare metal | Edges and highlights only |
| Scorch | `#3d1f0a` | Burnt metal, scorch marks | Small area; near energy sources |

### 1.3 Concrete / Steel / Bone (尘土-骨白 family)

| Swatch | Hex | Role | Constraint |
|--------|-----|------|------------|
| Old concrete | `#5c5448` | Concrete floor, walls | Dominant arena surface |
| Dusty concrete | `#7a7060` | Lighter concrete, worn surfaces | Paths and walkable areas |
| Bone white | `#c4b8a8` | Bleached bone, old paper, text base | Card backgrounds, UI text surfaces |
| Sand grit | `#8c7e6a` | Sand, grit, debris | Ground texture variation |
| Steel bare | `#6e6e72` | Exposed steel, unpainted metal | Structural elements |

### 1.4 Cyan / Electric Blue (冷青-电蓝 family) -- Player and Positive Signals

| Swatch | Hex | Role | Constraint |
|--------|-----|------|------------|
| Core cyan | `#00e5ff` | Player energy core, primary attack glow | The single most important signal color |
| Mid cyan | `#00b8d4` | Attack arc body, energy trail | Broader areas than core |
| Dark cyan | `#00838f` | Energy shadow, deep glow | Falloff and transition zones |
| Ultra cyan | `#00f0ff` | Hit flash core, B2 acquire confirmation | < 200ms; never persistent |
| Faded cyan | `#4dd0e1` | Afterimage, residual glow | Brief, must fade within 300ms |

### 1.5 Acid / Warning Yellow (酸黄-警示黄 family)

| Swatch | Hex | Role | Constraint |
|--------|-----|------|------------|
| Acid yellow | `#c6ff00` | Immediate danger, elite pre-attack | Must not share hue with reward |
| Warning amber | `#ffab00` | Contact damage flash, low-life warning | Brief, localized |
| Signal yellow | `#ffd600` | Pickup, collectible glow | Different shape/silhouette from danger |

### 1.6 Purple / Crimson (紫红-洋红 family) -- Elite and Rare

| Swatch | Hex | Role | Constraint |
|--------|-----|------|------------|
| Dark purple | `#7b1fa2` | Elite body accent, rare marker | Area-controlled; not on common enemies |
| Bright purple | `#d500f9` | Elite attack wind-up, B2 fan-split acquire | Distinct from cyan; use for "different" signal |
| Crimson | `#e91e63` | High-threat elite, critical danger | Narrowest usage; never on player |

### 1.7 Desaturated Green (低饱和绿 family) -- Collection / O2 (future)

| Swatch | Hex | Role | Constraint |
|--------|-----|------|------------|
| Patina green | `#558b2f` | Oxidized copper, aged metal | Environment accent only |
| Moss green | `#7cb342` | Organic decay, damp areas | Small area; avoid bright saturation |
| Deep green | `#33691e` | Shadowed vegetation, dark patina | Background only |

### 1.8 Palette Usage Rules

1. **Cyan is the player's color.** No enemy, environment element, or UI element may use core cyan (`#00e5ff`) or ultra cyan (`#00f0ff`) as its dominant hue. The player's attack arc, hit flash, and B2 confirmation own this family.
2. **Rust is the environment's color.** The arena floor, walls, and structures use the rust family as their primary warm tone.
3. **Yellow separates danger from reward.** Acid yellow (`#c6ff00`) = threat; signal yellow (`#ffd600`) = pickup. Never interchange.
4. **Purple is rare.** It appears only on elite enemies or B2 fan-split confirmation. It must not appear on common enemies.
5. **No color is the sole state indicator.** Shape, silhouette, position, icon, and brightness must carry at least one additional encoding for every state.

---

## 2. Silhouette Directions

### 2.1 Player Silhouette -- "Wasteland Clearer"

- **Shape language**: compact, upright, humanoid. Shoulders broader than hips (inverted triangle). Distinct hood or helmet silhouette with a recognizable crown/crest shape that reads at 45-degree oblique view.
- **Key identifiers**: energy arc generator visible on one arm or back -- a glowing cyan element that forms the attack origin. This is the player's "functional signal" per Style Manual v0.2 sec.5.2.
- **Size**: approximately 64-96 px tall at game resolution. The silhouette must remain readable when surrounded by 20+ enemies.
- **Negative space**: the player's legs and weapon arm should create a clear internal negative space (gap between body and weapon, or between legs) that distinguishes the silhouette from round/blobby enemy shapes.
- **Pose direction**: 4-directional (up, down, left, right) for movement. Idle stance with slight forward lean. Attack frame: arm extends, arc generator flares.
- **Anti-drift**: the player silhouette must NOT become a glowing mass. The functional cyan signal is a localized accent, not a full-body glow.

### 2.2 Enemy Silhouette -- "Rusted Humanoid Family"

- **Shape language**: hunched, asymmetrical, deteriorating. The humanoid form is visible but broken -- one shoulder droops, torso is twisted, limbs are uneven. This creates a family resemblance without identical clones.
- **Key identifiers**: rusted metal plates fused to flesh, exposed rebar or wire protruding from joints, hollow eye sockets or a single glowing dim point (NOT cyan -- use dim amber `#ff8f00` or dead grey `#616161`).
- **Size**: similar to player (64-96 px), but wider and more irregular. The hunch and asymmetry make them feel heavier.
- **Group readability**: when clustered, the enemy silhouettes should merge into a readable "rust mass" rather than individual detailed figures. The gaps between them create the pressure texture.
- **Two variants** (minimum):
  - **Variant A -- "Scrap Walker"**: lighter, faster-looking. More exposed rebar, thinner limbs, taller stance. The "speed" silhouette.
  - **Variant B -- "Rusted Brute"**: heavier, bulkier. Thicker rust plates, wider torso, shorter stance. The "weight" silhouette.
- **Anti-drift**: enemies must NOT glow. Their only light is the dim amber eye point or the brief cyan hit flash. They are the "rusted old world" -- the player's neon is the "new energy."

### 2.3 Scene Element Silhouettes

- **Arena boundary**: uneven walls of stacked concrete slabs, rusted I-beams, collapsed machinery. The boundary should have a broken, jagged top edge -- not a clean rectangle.
- **Ground**: large concrete floor plates with visible seams, cracks, and rust stains. The ground texture must provide directional cues for movement (grout lines, debris trails).
- **Decorations**: scattered industrial debris -- broken pipes, oil drums, cable spools, bent rebar. These serve as spatial reference points and should be clearly distinguishable from enemies by shape (angular vs. organic-hunched).
- **Anti-drift**: decorations must not be mistaken for enemies or pickups. They use the rust/concrete palette only, never cyan, yellow, or purple.

---

## 3. Material / Texture Direction

### 3.1 Rusty Industrial -- Concrete Manifestation

The anchor v0.1 establishes a visual language of **old steel, peeling coatings, oxidized edges, rough concrete, dust, and damp stains**. This is not a clean sci-fi or polished steampunk aesthetic -- it is decay, weight, and age.

- **Concrete**: rough, pitted surface with visible aggregate. Cracks follow stress lines, not random noise. Darker where water pools, lighter where abraded. Use `#5c5448` base with `#7a7060` highlights.
- **Steel / Iron**: oxidized in layers. The rust progression goes: bare steel (`#6e6e72`) -> light oxide at edges (`#d4784a`) -> mid rust body (`#8b3a1a`) -> deep corrosion pits (`#5c2612`). Rust spreads from edges, seams, and bolt holes -- not uniform surface coating.
- **Peeling coatings**: remnants of industrial paint (desaturated yellow `#827717` or faded green `#5c6b3c`) flaking off steel surfaces. The peeling reveals rust underneath.
- **Dust and grime**: accumulated in corners, along floor edges, and on horizontal surfaces. Not a uniform filter -- it builds up where airflow is blocked.
- **Dampness**: dark water stains on concrete (`#3a3a35`), small puddles with faint cyan reflection catch (NOT glowing, just a specular hint).

### 3.2 Player Materials

- **Base**: worn fabric (tattered cloak or reinforced coat), weathered leather straps, industrial boots. The player's materials are practical and lived-in, not pristine.
- **Functional signal**: the cyan energy source is a clean, bright material contrast -- a glowing crystal, energy coil, or arc generator. It is the one "new" thing in the old world.
- **Wear**: the player's gear shows use but not decay. Scratches, patches, and scuffs -- not rust holes. The player is surviving, not deteriorating.

### 3.3 Enemy Materials

- **Base**: the same rusted steel and concrete as the environment, but fused to flesh. The boundary between metal and organic matter is unclear -- rusted plates merge into grey, decaying skin.
- **Decay**: enemies are actively deteriorating. Rust flakes fall from their bodies. Joints grind. Their material state is worse than the environment -- they ARE the rust.
- **Contrast with player**: enemies share the rust palette with the environment. The player's cyan signal is the visual separator. If an enemy appears without cyan contrast, it should blend into the arena -- that is intentional, and the player must read them by silhouette and movement.

### 3.4 Card / UI Materials

- **Base**: dirty paper or corroded metal plate. The card surface is a recovered artifact -- stained, worn edges, but the central information is clean.
- **Keyword icon**: a clean cyan or purple glyph (depending on B2 phase) stamped or burned onto the card surface. The icon is the "neon" element on the "rusted" card.
- **States**: hover adds a subtle cyan edge glow (`#00e5ff` at 30% opacity). Selected adds a brighter border. Disabled dims the card to the rust palette.
- **Anti-drift**: card backgrounds must not become full-neon. The neon is the accent, not the surface.

---

## 4. Lighting / Atmosphere Direction

### 4.1 Ambient Light

- **Dominant**: low, cool ambient light. The arena is lit by overcast sky (not visible) or distant industrial fires. Overall scene reads as dark with localized brightness.
- **Color temperature**: ambient is cool-neutral (blue-black `#1a1a1e` to steel grey `#3d3d42`). Warmth comes from rust surfaces, not from light sources.
- **Brightness range**: the environment occupies the lower 40% of the brightness range. Player and enemies occupy 40-70%. Effects and signals occupy 70-100%.

### 4.2 Neon Light Sources

- **Player energy**: the cyan energy source on the player casts a subtle localized glow on nearby surfaces (ground, adjacent enemies). Radius is small (~2x player width). This is the player's "personal light."
- **Attack arcs**: the energy arc itself is bright (core `#00e5ff`), but it casts minimal ambient light. The arc is a visual signal, not a scene light source.
- **Hit flash**: brief (<150ms) localized cyan-white flash at the point of contact. Must not illuminate the entire screen.
- **B2 clear-screen**: the spatial result (density drop, path opening) is accompanied by a brief outward energy pulse -- a ring of fading cyan that expands and dissipates within ~500ms. This is NOT a persistent luminous field. After the pulse, the cleared space returns to ambient lighting.

### 4.3 Core -> Transition -> Falloff (Director Requirement)

Per Director review `ANCHOR_REVIEW_v0_2.md`:

- Every neon effect must have a readable **core** (brightest, smallest area), a **transition** (softer, broader), and a **falloff** (fading, no hard edge).
- The right-side B2 effect specifically must converge: the bright ring area must be smaller than the transition zone, and the falloff must be quiet enough that the cleared corridor reads as the primary result.
- No effect may maintain a persistent luminous field. After the brief high point, the scene returns to ambient.

### 4.4 Atmosphere and Mood

- **Not horror**: the atmosphere is oppressive but not terrifying. The player is in control, and the visual language supports that.
- **Not cheerful**: the world is broken, but the player brings the neon -- the one clean, bright thing cutting through the rust.
- **Weight and relief**: the mood arc is pressure -> clearing -> relief. The lighting supports this: dark/dense during pressure, bright/spacious after clearing, returning to ambient.

---

## 5. Anchor v0.1 Inheritance

### 5.1 What We Carry Forward

From `anchor_core_v0_1.png`:

1. **Three-stage comparison layout**: the anchor's left/middle/right structure (BEFORE / hit-kill / B2) is a compositional reference for the clear-screen visual journey. The final game does not use this triptych, but the visual progression it depicts is the target.
2. **Rusty industrial battlefield**: railway/concrete floor, industrial backdrop, rusted metal tones. This is the canonical environment.
3. **Cyan energy as the only neon**: blue-cyan arcs, hits, and effects. No other neon color family appears in the anchor.
4. **Dark player silhouette**: the player is a small, dark, hooded/armored figure at the bottom of each stage. The silhouette is stable across stages.
5. **Enemy horde**: rust-toned humanoid figures in large numbers, forming a readable mass.
6. **No text, UI, Boss, elite, O2**: the anchor's constraints are our constraints.

### 5.2 What We Correct (Director Feedback)

From `ANCHOR_REVIEW_v0_2.md` verdict `recommend-revision`:

1. **Right-side B2 area convergence**: the B2 effect ring must be smaller than v0.1. The bright area shrinks; the transition and falloff remain readable but subdued.
2. **Particle/brightness reduction**: fewer particles, less afterglow spread. The effect is a "fading circular rune-like field," not a "bright wide vortex."
3. **Clearing channel priority**: the primary visual result of B2 is a broad, continuous cleared corridor -- not the energy effect itself. The corridor must be the first thing the eye reads.
4. **Player silhouette priority**: the player must be the most stable, continuous, and high-contrast element in every frame. The right-side energy field must not compete with the player for attention.
5. **No persistent luminous field**: all effects return to ambient. The B2 result is spatial (enemies gone, path open), not luminous (continuous glow).

---

## 6. Anti-Drift Checklist

Every downstream asset must answer:

- [ ] Is the palette drawn from the confirmed hex families above?
- [ ] Does cyan (`#00e5ff` family) belong exclusively to the player and positive signals?
- [ ] Do enemies share the rust palette with the environment, distinguished by silhouette and movement?
- [ ] Does every neon effect have a readable core -> transition -> falloff?
- [ ] Is the B2 result a spatial clearing (corridor, density drop), not a persistent glow?
- [ ] Is the player silhouette the highest-contrast, most stable element in the frame?
- [ ] Are color and brightness never the sole state indicators?
- [ ] Does the scene lighting return to ambient after every effect?
- [ ] Are card backgrounds "rusted artifact with neon accent," not "neon surface"?

---

## 7. Closure

- **palette**: 8 families, 30+ hex values, usage rules
- **silhouettes**: player, enemy (2 variants), scene elements with shape language and anti-drift
- **materials**: rusty industrial concrete manifestation, player vs. enemy material contrast, card material rules
- **lighting**: ambient, neon sources, core->transition->falloff, atmosphere arc
- **anchor inheritance**: v0.1 carried forward, Director `recommend-revision` incorporated
- **status**: `team_proposal`; awaiting Game Director independent review and user final aesthetic acceptance
- **no asset, runtime, build, QA, or release evidence exists**

**closure_ready = true** for this style manual. Next step: Game Director review.