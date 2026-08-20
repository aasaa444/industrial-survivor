# PROMPT PACK v0.1 -- Image Generation Prompts for 2D Artist

- **version**: v0.1
- **author**: Concept Art Director
- **status**: `team_proposal` -- parameterized prompts for downstream 2D Artist; not final assets
- **references**: `STYLE_MANUAL_v0_2.md`, `anchor_core_v0_1.png`, `ANCHOR_REVIEW_v0_2.md`, `GDD_SLICE_v0_1.md`, `B2_CARD_UX_SPEC_v0_1.md`
- **usage**: each prompt is a starting point. The 2D Artist iterates against the style manual and anchor, not the prompt text alone.
- **knobs**: `[SIZE]`, `[VARIANT]`, `[POSE]`, `[MOOD]`, `[EFFECT]`, `[PHASE]` are documented per prompt. Change only the knob values; keep the structural prompt intact.

---

## 1. Player Character -- "Wasteland Clearer"

### 1.1 Front View (Idle)

```
Prompt:
A single humanoid wasteland survivor viewed from a fixed oblique 45-degree top-down perspective, full body, centered, facing downward-toward-camera. Worn dark industrial fabric cloak with tattered edges, weathered leather straps across chest, heavy boots. One arm bears a compact cyan energy arc generator -- a glowing cyan crystal or coil mounted on the forearm or shoulder, emitting a subtle directional cyan light (#00e5ff). Hood or helmet with a recognizable crest shape. The figure stands in a neutral stance, slight forward lean, ready to move. Dark silhouette with localized cyan accent on the weapon arm. Background: transparent. Style: game sprite, flat-shaded with subtle rim lighting, clean readable silhouette, no text, no UI, no glow aura around the whole body.
```

Knobs:
- `[SIZE]`: 128x128 px render resolution (output at 2x = 256x256 for import)
- `[POSE]`: idle / ready stance
- `[MOOD]`: neutral, alert

### 1.2 Side View (Movement Frame)

```
Prompt:
Same wasteland survivor character, side profile, viewed from fixed oblique 45-degree top-down perspective. Mid-stride walking pose, one leg forward, body leaning slightly into the movement. The cyan energy arc generator on the arm is visible in profile, casting a faint cyan edge light on the ground immediately beside the figure. Hood or helmet crest visible from the side. The cloak flows slightly behind, indicating forward motion. Dark rusty-industrial palette for clothing and gear; cyan accent only on the generator. Background: transparent. Style: game sprite, flat-shaded, clean silhouette, no text, no UI.
```

Knobs:
- `[SIZE]`: 128x128 px
- `[POSE]`: walking stride (frame 2 of 4)
- `[MOOD]`: purposeful movement

### 1.3 Attack Frame

```
Prompt:
Same wasteland survivor character, viewed from fixed oblique 45-degree top-down perspective. Attack pose: the arm with the cyan energy arc generator is extended forward, the generator flaring bright cyan (#00f0ff core, #00e5ff mid, #00b8d4 falloff). A directional energy arc blade extends from the generator -- a curved cyan slash, approximately 90-degree arc, about 2x the player's width in reach. The arc is bright at its core and fades at its edges. The figure's body is braced, slight recoil in the stance. The cyan light casts a brief localized glow on the ground immediately in front of the player. Background: transparent. Style: game sprite, flat-shaded body, bright layered glow on the arc, no text, no UI.
```

Knobs:
- `[SIZE]`: 128x128 px (the arc may extend beyond this -- render at 256x256 to capture full arc)
- `[POSE]`: attack extension
- `[MOOD]`: power release, focused

### 1.4 Hit Frame (Player Takes Damage)

```
Prompt:
Same wasteland survivor, viewed from fixed oblique 45-degree top-down perspective. Recoiling from impact, body pushed slightly backward, cloak flaring. Brief amber flash (#ffab00) at the point of contact on the body, localized, not full-body glow. The cyan generator flickers dimly. The silhouette is momentarily disrupted but still readable. Background: transparent. Style: game sprite, flat-shaded, brief flash accent, no text, no UI.
```

Knobs:
- `[SIZE]`: 128x128 px
- `[POSE]`: recoil / hit reaction
- `[MOOD]`: impact, brief vulnerability

---

## 2. Enemy Characters -- "Rusted Humanoid Family"

### 2.1 Variant A -- "Scrap Walker" (Lighter, Faster)

```
Prompt:
A single rusted humanoid enemy, viewed from fixed oblique 45-degree top-down perspective, full body, facing upward-toward-camera. Hunched posture, asymmetrical -- one shoulder lower than the other, torso twisted. Thin, elongated limbs wrapped in rusted metal bands and exposed rebar. Flesh is grey and decaying, fused with patches of corroded iron (#8b3a1a). Hollow eye sockets with a dim amber point of light (#ff8f00) -- not bright, just a faint glint. Walking pose, mid-stride. The figure is lighter and taller than the brute variant. Rust flakes trail slightly from the joints. Background: transparent. Style: game sprite, flat-shaded, rusted-industrial palette, no cyan, no glow, no text, no UI.
```

Knobs:
- `[SIZE]`: 128x128 px
- `[VARIANT]`: scrap-walker
- `[POSE]`: walking stride
- `[MOOD]`: relentless, decaying

### 2.2 Variant A -- Death Frame

```
Prompt:
Same rusted humanoid "scrap walker" enemy. Death pose: the figure collapses, knees buckling first, torso folding forward. Rust flakes burst outward from the joints. The amber eye point extinguishes. The body dissolves into a pile of rusted scrap and grey ash over 2-3 frames. The collapse is weighty but brief -- approximately 300ms total. No bright flash, no cyan, no explosion. The death is a rust-collapse, not a spectacle. Background: transparent. Style: game sprite, flat-shaded, 2-3 frame dissolve sequence, rusted palette only.
```

Knobs:
- `[SIZE]`: 128x128 px
- `[VARIANT]`: scrap-walker
- `[POSE]`: death collapse (frame 1 of 3)
- `[MOOD]`: weight, finality, rust returning to rust

### 2.3 Variant B -- "Rusted Brute" (Heavier, Bulkier)

```
Prompt:
A single rusted humanoid enemy, bulkier variant, viewed from fixed oblique 45-degree top-down perspective. Wide, hunched torso covered in thick rusted iron plates (#8b3a1a with #5c2612 deep corrosion at edges). Shorter, thicker limbs than the scrap walker. One arm is larger, ending in a crude metal club or fused scrap mass. The head is sunk low between the shoulders. Dim amber eye point (#ff8f00). Stance is wide, heavy, grounded. Walking pose, slow lurch forward. Background: transparent. Style: game sprite, flat-shaded, rusted-industrial palette, heavier silhouette than scrap walker, no cyan, no glow, no text, no UI.
```

Knobs:
- `[SIZE]`: 128x128 px
- `[VARIANT]`: rusted-brute
- `[POSE]`: walking lurch
- `[MOOD]`: heavy, implacable

### 2.4 Variant B -- Hit Frame

```
Prompt:
Same rusted humanoid "rusted brute" enemy. Hit reaction: the figure recoils slightly, a localized cyan-white flash (#00f0ff core, fading to #00e5ff) at the point of impact on the body. Rust flakes spray from the impact point. The amber eye flickers. The recoil is brief and does not move the figure far -- the brute is heavy. Background: transparent. Style: game sprite, flat-shaded, brief localized cyan flash at impact point only, no full-body glow.
```

Knobs:
- `[SIZE]`: 128x128 px
- `[VARIANT]`: rusted-brute
- `[POSE]`: hit recoil
- `[MOOD]`: impact, brief stun

---

## 3. Scene Background -- "Industrial Arena"

### 3.1 Arena Floor + Walls

```
Prompt:
A single-screen bounded industrial arena, viewed from a fixed oblique 45-degree top-down perspective, filling the entire frame. The floor is cracked concrete (#5c5448 base) with visible seams, rust stains (#8b3a1a), and scattered debris. The arena is bordered by uneven walls of stacked concrete slabs, rusted I-beams, and collapsed industrial machinery. The walls have a broken, jagged top edge. A few scattered industrial props: bent pipes, an oil drum, cable spools, broken rebar -- all in the rusted-industrial palette, angular shapes, not organic. The center of the floor is relatively open, providing a readable movement space. The floor grout lines and debris provide directional cues for movement. Lighting: low ambient, cool-neutral, with subtle warm accents from rust surfaces. No characters, no effects, no text, no UI. The arena feels abandoned, heavy, and oppressive but not horror. Style: game background, flat-shaded with subtle texture, 1920x1080 resolution.
```

Knobs:
- `[SIZE]`: 1920x1080 px
- `[MOOD]`: oppressive but not horror, abandoned industrial
- `[FEATURES]`: open center, debris at edges, directional floor cues

### 3.2 Arena Decorations (Prop Sheet)

```
Prompt:
A sprite sheet of industrial arena decoration props, viewed from fixed oblique 45-degree top-down perspective. Individual props on transparent background: (1) bent rusted pipe, (2) corroded oil drum with faded hazard marking, (3) wooden cable spool with frayed cable, (4) broken concrete slab with exposed rebar, (5) pile of scrap metal, (6) rusted floor grating. All props use the rusted-industrial palette: concrete (#5c5448, #7a7060), rust (#8b3a1a, #5c2612), steel (#6e6e72), with no cyan, no neon, no glow. Props are angular and mechanical, not organic -- they must not be mistaken for enemies. Style: game sprite sheet, flat-shaded, consistent lighting, transparent background.
```

Knobs:
- `[SIZE]`: each prop 64-128 px; sheet 512x512 px
- `[MOOD]`: abandoned industrial debris
- `[FEATURES]`: 6 distinct props, angular shapes, rust palette only

---

## 4. Card Backgrounds

### 4.1 Pierce Keyword Card (B2 Phase 1)

```
Prompt:
A horizontal game card, approximately 3:2 aspect ratio, viewed flat (not perspective). The card surface is a recovered artifact -- dirty paper or thin corroded metal plate, with worn edges and subtle rust stains at the corners (#8b3a1a). The center of the card is cleaner, with a stamped or burned cyan glyph (#00e5ff) representing the pierce keyword concept -- a simple arrow or spearhead shape, clean and readable. The card background uses the bone-white range (#c4b8a8) for the paper variant, or the dark steel range (#6e6e72) for the metal variant. The glyph is the only neon element. The card has a subtle dark border. Style: game UI card, flat-shaded, readable at small size, no text on the image (text will be overlaid by the game engine).
```

Knobs:
- `[SIZE]`: 300x200 px (render at 2x = 600x400)
- `[VARIANT]`: pierce keyword
- `[MOOD]`: recovered artifact, functional
- `[GLYPH]`: arrow / spearhead / thrust symbol

### 4.2 Fan-Split Keyword Card (B2 Phase 2)

```
Prompt:
Same card format as the pierce card. The card surface is the same recovered artifact style. The glyph is a purple (#d500f9) symbol representing the fan-split concept -- a central line branching into three lines, or a spreading arc shape. The purple glyph is the only neon element. The card background is slightly darker than the pierce card, suggesting progression. Same worn edges, rust stains, and artifact quality. Style: game UI card, flat-shaded, readable at small size, no text on the image.
```

Knobs:
- `[SIZE]`: 300x200 px (render at 2x = 600x400)
- `[VARIANT]`: fan-split keyword
- `[MOOD]`: recovered artifact, progression
- `[GLYPH]`: branching three-line / spreading arc symbol

### 4.3 Card State Variants

```
Prompt:
The same card base as above, but with state variations applied. (1) Hover state: a subtle cyan edge glow (#00e5ff at low opacity) around the card border, 2-3px wide. (2) Selected state: a brighter cyan border (#00f0ff), 3-4px wide, with a brief inner glow. (3) Disabled state: the card is dimmed, the glyph is grey (#616161), the card surface is darker. All states preserve the artifact quality -- the card is still a rusted object, not a neon screen. Style: game UI card states, flat-shaded, transparent background.
```

Knobs:
- `[SIZE]`: 300x200 px per state
- `[STATES]`: hover, selected, disabled
- `[MOOD]`: clear state distinction, non-color encoding (brightness + border width)

---

## 5. VFX -- Combat Effects and Feedback

### 5.1 Hit VFX -- Localized Impact Flash

```
Prompt:
A single localized impact flash effect, viewed from fixed oblique 45-degree top-down perspective. A bright cyan-white core (#00f0ff) at the center of impact, approximately 8-16 px diameter, surrounded by a mid-cyan transition ring (#00e5ff) extending to about 24-32 px, with a dark cyan falloff (#00838f) fading to transparent at about 48 px. Small rust-colored particles (#b85c2e, #8b3a1a) spray outward from the impact point -- 4-6 particles, each 2-4 px, traveling roughly 16-24 px from center before fading. The effect is brief, self-contained, and does not form a persistent glow. The flash is brightest at frame 1 and fades to transparent by frame 3. Background: transparent. Style: game VFX sprite sheet, 3-frame sequence, additive blend ready, no text, no UI.
```

Knobs:
- `[SIZE]`: 64x64 px per frame; 3-frame strip = 192x64 px
- `[EFFECT]`: hit-impact
- `[MOOD]`: sharp, localized, brief
- `[PHASE]`: single-frame peak, 3-frame total (~150ms at 60fps)

### 5.2 Kill VFX -- Enemy Death Dissolve / Shatter

```
Prompt:
An enemy death dissolve effect, viewed from fixed oblique 45-degree top-down perspective. The effect is centered on a now-vanished enemy position. Frame 1: the enemy silhouette begins to crack, with bright cyan-white fracture lines (#00f0ff) tracing through the rusted body. Rust flakes (#8b3a1a, #b85c2e) begin separating from the edges. Frame 2: the body collapses inward, rust flakes burst outward in a ring (8-12 particles, 3-6 px each, traveling 24-40 px). The cyan fracture lines pulse once and begin fading. Frame 3: the body dissolves into a small pile of grey ash (#7a7060) and rusted scrap (#5c2612), with a few remaining particles settling. The cyan is gone. The ash pile remains as a brief ground decal. No explosion, no full-screen flash, no persistent glow. The death reads as a rust-collapse, weighty but brief. Background: transparent. Style: game VFX sprite sheet, 3-frame sequence, flat-shaded particles, no text, no UI.
```

Knobs:
- `[SIZE]`: 128x128 px per frame; 3-frame strip = 384x128 px
- `[EFFECT]`: kill-dissolve
- `[MOOD]`: weight, finality, rust returning to rust
- `[PHASE]`: 3-frame total (~300ms at 60fps)

### 5.3 Attack Trajectory VFX -- Energy Arc Glow

```
Prompt:
A directional energy arc effect, viewed from fixed oblique 45-degree top-down perspective, oriented horizontally (rotate in-engine). The arc is a curved cyan slash, approximately 90-degree arc shape, with a bright core line (#00f0ff, 2-3 px wide) at the center, a mid-cyan glow band (#00e5ff, 6-8 px wide) around the core, and a dark cyan outer falloff (#00838f, 12-16 px wide) fading to transparent. The arc is sharpest at the center and tapers at both ends. Subtle particle trail: 3-5 small cyan particles (#00e5ff, 1-2 px) trailing slightly behind the arc body, fading within 2 frames. The arc is a single-frame effect that leaves a brief afterimage: frame 2 shows a dimmer version (#4dd0e1 at 40% brightness) offset by 4-6 px in the attack direction. Frame 3 is transparent. The arc reads as a clean directional energy slash, not a thick beam or explosion. Background: transparent. Style: game VFX sprite sheet, 3-frame sequence (full -> afterimage -> gone), additive blend ready, no text, no UI.
```

Knobs:
- `[SIZE]`: 256x128 px per frame; 3-frame strip = 768x128 px
- `[EFFECT]`: attack-arc
- `[MOOD]`: sharp, directional, clean energy
- `[PHASE]`: 3-frame total (~150ms at 60fps)

### 5.4 B2 Clear-Screen VFX -- Pierce Clear (Phase 1)

```
Prompt:
A clear-screen spatial effect for the pierce upgrade, viewed from fixed oblique 45-degree top-down perspective, filling the entire arena view. The effect represents a wave of piercing energy sweeping through the enemy horde. Frame 1: a bright cyan horizontal line (#00f0ff, 2 px wide) appears at the center of the arena, with a mid-cyan band (#00e5ff, 8-12 px) above and below. Enemies along the line flash briefly with the hit VFX. Frame 2: the line expands into a widening corridor -- the center brightens (#00f0ff core, 16-24 px wide) while the edges begin a transition (#00e5ff to #00838f) outward to about 1/3 of the arena width. Enemies within the corridor read as dissolving (use kill VFX). Frame 3: the corridor reaches its full width, the center is now a cleared path of open ground (#5c5448 base concrete visible). The cyan edges fade to dark cyan (#00838f) and then to transparent. Frame 4: the cyan is gone. The corridor is wide and open, with enemy density visibly reduced. The remaining enemies are pushed to the edges. No persistent glow, no full-screen flash, no text. The primary visual result is the opened space, not the energy effect. Background: the arena floor is visible beneath the effect (composite in-engine). Style: game VFX sprite sheet, 4-frame sequence, additive blend, no text, no UI.
```

Knobs:
- `[SIZE]`: 1920x1080 px per frame; 4-frame strip = 7680x1080 px
- `[EFFECT]`: clear-screen-pierce
- `[MOOD]`: spatial dominance, relief, control asserted
- `[PHASE]`: 4-frame total (~500ms at 60fps)

### 5.5 B2 Clear-Screen VFX -- Fan-Split Clear (Phase 2)

```
Prompt:
A clear-screen spatial effect for the fan-split upgrade, viewed from fixed oblique 45-degree top-down perspective, filling the entire arena view. The effect represents three spreading energy arcs clearing the enemy horde. Frame 1: three cyan arcs appear from the player position -- one center arc (#00f0ff core), and two side arcs (#00e5ff) branching left and right at approximately 30-degree angles. Enemies along all three arcs flash with the hit VFX. Frame 2: the three arcs widen into three overlapping corridors. The center corridor is brightest (#00f0ff core, #00e5ff transition), the side corridors are slightly dimmer (#00e5ff core, #00838f transition). The corridors fan outward, covering roughly 60% of the arena width combined. Frame 3: the corridors reach full spread, the cyan edges fade to dark cyan (#00838f) and then to transparent. The arena floor is visible -- three cleared paths with reduced enemy density. A subtle purple accent (#d500f9) appears briefly at the corridor edges, distinguishing this from the pierce clear. Frame 4: all cyan and purple is gone. Three wide corridors are open, enemies pushed to the remaining gaps. No persistent glow, no full-screen flash. The primary visual result is the three opened paths, not the energy effect. Background: the arena floor is visible beneath the effect (composite in-engine). Style: game VFX sprite sheet, 4-frame sequence, additive blend, no text, no UI.
```

Knobs:
- `[SIZE]`: 1920x1080 px per frame; 4-frame strip = 7680x1080 px
- `[EFFECT]`: clear-screen-fan-split
- `[MOOD]`: spatial dominance, three-path control, power peak
- `[PHASE]`: 4-frame total (~600ms at 60fps)

### 5.6 Upgrade VFX -- Card Selection Confirmation

```
Prompt:
An upgrade confirmation light effect, viewed flat (UI overlay, not perspective). The effect plays over the selected card. Frame 1: the selected card border pulses bright cyan (#00f0ff, 3-4 px wide) or bright purple (#d500f9) depending on phase, with a brief inner glow spreading from the card center. The other two unselected cards dim to grey (#616161). Frame 2: the glow expands outward from the card in a soft ring -- cyan (#00e5ff, fading to #4dd0e1) for pierce acquire, purple (#d500f9, fading to #7b1fa2) for fan-split acquire. The ring reaches about 2x the card width. Frame 3: the ring fades, the card border returns to the selected state (bright cyan/purple, 2 px), and a subtle particle burst (3-4 small matching-color particles, 2-3 px) rises from the card center and fades upward. Frame 4: all effects resolved. The card shows its selected state. The effect reads as confirmation of acquired power, not a distraction. Background: transparent (composite over the paused game screen). Style: game UI VFX sprite sheet, 4-frame sequence, additive blend, no text.
```

Knobs:
- `[SIZE]`: 400x300 px per frame; 4-frame strip = 1600x300 px
- `[EFFECT]`: upgrade-confirm
- `[MOOD]`: acquisition, power gained, clear confirmation
- `[PHASE]`: 4-frame total (~500ms at 60fps)

---

## 6. Prompt Knobs Reference

| Knob | Values | Description |
|------|--------|-------------|
| `[SIZE]` | e.g. `128x128`, `256x256`, `1920x1080` | Output render resolution in pixels |
| `[VARIANT]` | `scrap-walker`, `rusted-brute`, `pierce`, `fan-split` | Which asset variant to generate |
| `[POSE]` | `idle`, `walking`, `attack`, `hit`, `death` | Character pose or animation frame |
| `[MOOD]` | `neutral`, `alert`, `relentless`, `heavy`, `oppressive`, `functional` | Emotional tone of the asset |
| `[GLYPH]` | `arrow`, `spearhead`, `branching-arc`, `spread` | Icon/symbol shape for card faces |
| `[STATES]` | `hover`, `selected`, `disabled` | Card interaction state |
| `[FEATURES]` | `open-center`, `debris-edges`, `directional-cues` | Scene composition features |
| `[EFFECT]` | `hit-impact`, `kill-dissolve`, `attack-arc`, `clear-screen-pierce`, `clear-screen-fan-split`, `upgrade-confirm` | VFX effect type |
| `[PHASE]` | `pierce`, `fan-split` | B2 upgrade phase for VFX color selection |

---

## 7. Generation Constraints (All Prompts)

Every generation must respect:

1. **No text, no UI, no logos, no watermarks** in the generated image.
2. **No Boss, no elite, no O2** elements.
3. **No persistent luminous field** -- any glow must be localized and have a clear core->transition->falloff.
4. **Cyan (`#00e5ff` family) belongs to the player and positive signals** -- enemies and environment must not use it.
5. **Rust palette (`#8b3a1a` family) belongs to the environment and enemies** -- the player must not be rust-colored.
6. **Transparent background** for all character and prop sprites.
7. **Flat-shaded game sprite style** -- not realistic, not painterly, not pixel art, not vector.
8. **Fixed oblique 45-degree top-down perspective** for all gameplay sprites (cards are flat).
9. **Readable silhouette at game resolution** (64-96 px for characters) -- test by scaling down to check.

---

## 7. Iteration Protocol

1. **Generate one asset** using the prompt above.
2. **Compare against** `anchor_core_v0_1.png` and `STYLE_MANUAL_v0_2.md`.
3. **Check the anti-drift checklist** in Style Manual sec.6.
4. **If drift detected**: adjust the prompt, not the manual. The manual is the truth.
5. **If the manual is insufficient**: flag to Concept Art Director for manual update.
6. **Do not generate batches** until the first asset of each type passes review.

---

## 8. Closure

- **prompts**: 4 categories (player, enemy, scene, card), 10 prompt templates, 6 knobs documented
- **coverage**: player idle/move/attack/hit, enemy walker walk/death, enemy brute walk/hit, scene arena + props, cards pierce/fan-split + states
- **constraints**: 9 generation constraints, 6-step iteration protocol
- **status**: `team_proposal`; ready for 2D Artist dispatch after Director review of STYLE_MANUAL_v0_2.md
- **no images generated by this document**

**closure_ready = true** for this prompt pack. Next step: 2D Artist uses these prompts to generate first-pass assets, verified against the style manual and anchor.