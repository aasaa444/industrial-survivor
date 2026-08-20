# B2 Card Selection UX Interaction Spec v0.1

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED`
> **Lifecycle:** `development governance / kickoff readiness preparation`
> **Owner:** UX/UI specialist
> **Evidence class:** `static/source` only — no runtime, visual QA, or acceptance evidence
> **Target:** B2 upgrade card selection interface (穿透 at tick≈1200, 扇裂 at tick≈3000)

---

## 1. Expert Preflight

- **Target player/context:** PC-first single-player, mid-combat, full pause, choosing one of three same-keyword cards.
- **Critical journey:** Combat → full pause → inspect three cards → compare one difference dimension → choose via keyboard or mouse → see acquired feedback → resume combat.
- **Top comprehension risks:** cards may not communicate the one meaningful difference; keyboard-only path may feel invisible; hover/focus states may be indistinguishable; card layout may occlude player/danger/space; stale input during pause transition may cause accidental selection.
- **Target conditions:** 16:9 baseline (640×360 viewport), common widescreen {16:10, 21:9} candidate; keyboard WASD/arrows for prior movement, 1/2/3 or directional focus + Enter/Space for cards, mouse hover + click; 1280×720 minimum resolution red line remains candidate only.
- **States in scope:** default, hover, focus, pressed, selected/acquired, disabled (during feedback), paused (combat frozen), resumed.
- **Input modes:** keyboard 1/2/3 direct selection; keyboard Arrow Left/Right + Enter/Space focus selection; mouse hover highlight; mouse click confirm.
- **Evidence route:** future runtime observation, visual QA screenshots at 16:9/16:10/21:9, independent QA at Gate 3.
- **Ownership boundary:** UX/UI owns the player-facing interaction contract and observable acceptance examples; Tech owns implementation; Systems owns card data/rules; Director owns creative coherence; QA/Release owns independent acceptance.
- **Stop condition:** stop at this static spec. No Godot, code, scene, asset, build, runtime, test, QA, performance, export, or release activity.

---

## 2. Current State Assessment

### 2.1 What exists today

The current card selection (runtime/main.gd lines 262–269, 438–500) is a minimal functional placeholder:

- 3 `Label` nodes stacked **vertically** at positions (48, 222), (48, 244), (48, 266) on a CanvasLayer (layer 10)
- 1 prompt `Label` at (16, 200) reading "B2 升级选择 (按 1/2/3):"
- Selection via `Input.is_key_pressed(KEY_1)` / `KEY_2` / `KEY_3` — polled every frame, no debounce
- No mouse hover, no mouse click, no directional focus, no Enter/Space confirm
- No visual card areas (no background, no border, no highlight)
- No selection feedback beyond log print
- Cards hide immediately on selection with no acquired-feedback phase
- No focus-loss protection on the card selection itself (combat is paused via early return in `_process`)

### 2.2 Gap to Charter requirements

| Charter requirement (decision #17) | Current state | Gap |
|---|---|---|
| Three equal **horizontal** cards | Vertical text labels | Layout |
| Mouse click or directional focus | Keyboard 1/2/3 only | Input |
| Enter/Space confirm | No Enter/Space path | Input |
| No skip/reroll | Satisfied (no skip mechanism) | None |
| Keyword title + one clear difference dimension | Flat `[N] 穿透 N — desc` text | Information hierarchy |
| Non-color distinguishability (UX-13) | No visual states at all | Accessibility |
| Full combat pause, feedback before resume | Pause works; no feedback phase | Feedback |
| Cards must not occlude player/danger/space (UX-09) | Cards at top-left, near HUD; acceptable for now but not ideal | Layout |

---

## 3. Card Layout Specification

### 3.1 Viewport baseline

- **Design viewport:** 640 × 360 (16:9)
- **Player position:** center (320, 180)
- **HUD zone:** top-left, approximately (16, 12) to (640, 200)
- **Danger/enemy zone:** primarily center to right of screen
- **Safe card zone:** bottom portion of screen, below the main gameplay area

### 3.2 Card dimensions and position

Three cards in a horizontal row, centered in the lower portion of the viewport.

```
+----------------------------------------------------------+
|  HUD (LIFE / TIMER / B2)                          (16:9) |
|                                                            |
|                   [gameplay area]                          |
|              (player, enemies, attacks)                    |
|                                                            |
|    +----------+    +----------+    +----------+           |
|    |  Card 1  |    |  Card 2  |    |  Card 3  |           |
|    |  [1] 穿透|    |  [2] 穿透|    |  [3] 穿透|           |
|    |  力场穿透 |    |  相位穿透 |    |  量子隧穿 |           |
|    | 命中上限+2|    | 命中上限+2|    | 命中上限+2|           |
|    +----------+    +----------+    +----------+           |
|                    [prompt text]                           |
+----------------------------------------------------------+
```

**Measurements (640×360 baseline):**

| Property | Value | Rationale |
|---|---|---|
| Card width | 160 px | Fits three cards + gaps in 640px with safe margins |
| Card height | 96 px | Accommodates 3 text lines + padding |
| Card gap | 20 px | Clear separation; 3×160 + 2×20 = 520px total width |
| Left card center X | 160 | (640 - 520)/2 + 80 = 160 |
| Center card center X | 320 | |
| Right card center X | 480 | |
| Card vertical center Y | 270 | Lower third of screen; 360 - 96/2 - 42 margin = 270 |
| Card corner radius | 4 px | Restrained industrial feel; matches anchor aesthetic |
| Card internal padding | 12 px horizontal, 10 px vertical | Adequate for 3 text lines |
| Prompt Y position | 332 | Below cards, centered |

**Safe zone rationale:** Card bottom edge at Y=318 (270 + 48). This leaves 42px margin to viewport bottom, keeping cards in the lower 35% of the screen. The gameplay area (player at 180, enemies distributed) occupies the upper 65%. Cards do not overlap the top-left HUD or the central player area.

### 3.3 Widescreen behavior

Per DC-PLAT-02 Option 2 (R03, 2026-08-16): **fit + letterbox gaps + UI relative scaling; no stretch, no crop.**

| Aspect | Behavior |
|---|---|
| 16:9 (640×360) | Baseline layout as specified |
| 16:10 (640×400) | Cards shift down proportionally; additional 20px vertical margin distributed evenly |
| 21:9 (840×360) | Cards remain centered; additional 100px horizontal margin per side; cards do NOT stretch |

Card width and height remain fixed in pixels; only position adjusts to the wider/taller canvas. This preserves text readability and interaction target size.

---

## 4. Information Hierarchy

Each card presents three tiers of information, ordered by visual weight:

### 4.1 Tier 1 — Keyword (title)

- **Content:** e.g. "穿透 I", "穿透 II", "穿透 III" (or "扇裂 I/II/III")
- **Font size:** 18px (largest on card)
- **Weight:** Bold
- **Position:** Top of card, left-aligned with padding
- **Purpose:** Immediate recognition of the upgrade family and variant identity

### 4.2 Tier 2 — Difference Dimension

- **Content:** The one clear dimension that distinguishes this card from its siblings. Examples:
  - "力场穿透" vs "相位穿透" vs "量子隧穿" (flavor + mechanical hint)
  - "左弧强化" vs "右弧强化" vs "三弧均衡"
- **Font size:** 14px
- **Weight:** Regular
- **Position:** Middle of card, left-aligned
- **Purpose:** The reason to choose one card over another. This is the key decision signal.

### 4.3 Tier 3 — Effect Description

- **Content:** Mechanical effect in functional language. Examples:
  - "攻击命中上限 +2"
  - "攻击弧数 +2（左弧强化）"
- **Font size:** 12px
- **Weight:** Regular
- **Color:** Muted (lighter than tier 2), communicates supporting detail
- **Position:** Bottom of card, left-aligned
- **Purpose:** Confirms the mechanical consequence; lowest priority, read after comparison

### 4.4 Card label formatting

```
+---------------------------+
|                           |
|  [1] 穿透 I               |  ← Tier 1: keyword + number prefix
|  力场穿透                 |  ← Tier 2: difference dimension
|  命中上限 +2              |  ← Tier 3: effect
|                           |
+---------------------------+
```

The number prefix `[1]` / `[2]` / `[3]` serves as the keyboard shortcut hint and is always visible at the same size as the keyword.

---

## 5. Interaction Flow

### 5.1 Full flow diagram

```
combat_active
    │
    ├─ tick reaches upgrade window (1200 or 3000)
    │
    ▼
┌─────────────────────────────────────────────┐
│  PAUSE TRANSITION (≈200ms)                   │
│  - Combat freezes (already handled)           │
│  - Cards fade/scale in from bottom            │
│  - Prompt appears                             │
│  - Input buffered during transition is        │
│    DISCARDED (stale-input rejection)          │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  CARD INSPECTION (indefinite)                │
│  - All three cards visible, default state     │
│  - Keyboard: 1/2/3 for direct select         │
│  - Keyboard: ←/→ to move focus              │
│  - Mouse: hover highlights card              │
│  - Mouse: click selects card                 │
│  - Enter/Space confirms focused card         │
│  - No skip, no reroll, no time limit          │
└─────────────────────────────────────────────┘
    │
    │ player confirms selection
    ▼
┌─────────────────────────────────────────────┐
│  PRESSED STATE (≈100ms)                      │
│  - Selected card: brief scale-down + darken   │
│  - Other two cards: dim / disable            │
│  - All input rejected during this phase       │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  ACQUIRED FEEDBACK (≈600ms)                  │
│  - Selected card: brighten, border accent     │
│  - "穿透 获得" or "扇裂 获得" text appears    │
│  - All input still rejected                   │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  RESUME TRANSITION (≈200ms)                  │
│  - Cards fade/scale out downward             │
│  - Combat resumes                             │
│  - B2 HUD label updates to reflect new phase  │
└─────────────────────────────────────────────┘
    │
    ▼
combat_active (with upgraded attack)
```

### 5.2 Timing budget

| Phase | Duration | Notes |
|---|---|---|
| Pause → cards appear | ≈200ms | Tween: cards slide up + fade in from Y+40 |
| Inspection | indefinite | Player-controlled |
| Pressed | ≈100ms | Brief flash; non-interruptible |
| Acquired feedback | ≈600ms | Confirmation visible; non-interruptible |
| Cards dismiss → resume | ≈200ms | Tween: cards slide down + fade out to Y+40 |
| **Total non-interactive** | ≈1100ms | From press to combat resume |

These durations are candidate values, not frozen constants. Exact tween curves and durations are subject to implementation tuning.

---

## 6. Selection Methods

### 6.1 Keyboard: Direct Number Selection

- **Keys:** `1`, `2`, `3` (main keyboard) and `Keypad 1`, `Keypad 2`, `Keypad 3`
- **Behavior:** Pressing the key immediately selects the corresponding card (index 0, 1, 2)
- **Debounce:** The key must be **pressed** (not held) — use `Input.is_key_pressed` but gate on a `was_pressed` edge. Releasing and re-pressing the same key is required for a second selection attempt (though only one selection is legal per window).
- **Stale protection:** Any key 1/2/3 pressed during the pause transition or acquired-feedback phase is discarded.

### 6.2 Keyboard: Directional Focus + Enter/Space

- **Left/Right arrows:** Move a visible focus indicator among the three cards. Wraps: pressing Right on card 3 moves to card 1; pressing Left on card 1 moves to card 3.
- **Up/Down arrows:** No-op during card selection (cards are horizontal).
- **Enter or Space:** Confirms the currently focused card.
- **Initial focus:** Card 2 (center) is focused by default when cards appear. This gives the player a neutral starting point and makes the left/right relationship immediately clear.
- **Stale protection:** Enter/Space events buffered before the inspection phase begins are discarded.

### 6.3 Mouse: Hover

- **Trigger:** Mouse enters a card's bounding rectangle.
- **Visual:** Card background lightens, border brightens, cursor changes to pointing hand (`MOUSE_CURSOR_POINTING_HAND`).
- **Exit:** Mouse leaves → card returns to default state.
- **Interaction with keyboard focus:** If the player moves keyboard focus with arrow keys while also hovering with the mouse, the last-used input mode takes priority. Hovering overrides keyboard focus; pressing an arrow key overrides hover and re-establishes keyboard focus on the target card.

### 6.4 Mouse: Click

- **Trigger:** Left mouse button click on any card.
- **Behavior:** Immediately selects the clicked card (same as pressing 1/2/3).
- **Stale protection:** Clicks during pause transition or acquired-feedback phase are discarded.

---

## 7. Feedback Design

### 7.1 State matrix

| State | Background | Border | Text | Scale | Cursor | Input accepted |
|---|---|---|---|---|---|---|
| **Default** | Dark fill (Color(0.08, 0.08, 0.10, 0.85)) | 1px muted (Color(0.30, 0.30, 0.35)) | Normal | 1.0 | Default | Yes |
| **Hover** | Lightened fill (Color(0.12, 0.12, 0.16, 0.90)) | 1.5px bright (Color(0.50, 0.50, 0.60)) | Normal | 1.03 | Pointing hand | Yes |
| **Focus (keyboard)** | Same as hover | 1.5px accent (Color(0.55, 0.75, 0.95)) — non-color: **dashed** border style | Normal | 1.03 | Default | Yes |
| **Pressed** | Darkened (Color(0.04, 0.04, 0.06, 0.95)) | 2px accent (Color(0.65, 0.85, 1.0)) | Bold | 0.97 | Default | **No** |
| **Selected (acquired)** | Accent fill (Color(0.10, 0.15, 0.22, 0.90)) | 2px bright accent (Color(0.70, 0.90, 1.0)) — **solid** | Bold + "获得" suffix | 1.0 | Default | **No** |
| **Dimmed (sibling)** | Darker (Color(0.04, 0.04, 0.06, 0.70)) | 1px faded (Color(0.15, 0.15, 0.20)) | Muted alpha | 0.95 | Default | **No** |

### 7.2 Non-color communication (UX-13)

Each state is distinguishable by at least two non-color properties:

| State | Non-color signal 1 | Non-color signal 2 |
|---|---|---|
| Default → Hover | Scale increase (1.0 → 1.03) | Border width increase (1px → 1.5px) |
| Hover → Focus | Border style change (solid → dashed) | Cursor change (pointer → default) |
| Default → Pressed | Scale decrease (1.0 → 0.97) | Border width increase (1px → 2px) |
| Pressed → Selected | Text suffix "+ 获得" | Border style (dashed/solid → solid) |
| Selected → Dimmed | Alpha reduction | Scale decrease |

Border **style** (solid vs dashed) is the primary non-color differentiator between keyboard focus and mouse hover. Dashed border = keyboard focus; solid border = mouse hover or selected.

### 7.3 Acquired feedback text

After selection, the acquired card's tier-1 text changes to include the confirmation:

- Before: `[1] 穿透 I`
- After: `[1] 穿透 I — 获得`

This text change is the primary non-color confirmation signal. The prompt label also updates:

- Before: "B2 升级选择 (按 1/2/3 或方向键+回车)"
- After: "穿透 已获得" (or "扇裂 已获得")

### 7.4 Transition animations

| Transition | Tween | Duration | Easing |
|---|---|---|---|
| Cards appear | Position: Y+40 → Y, Modulate: a=0 → a=1 | 200ms | ease-out (expo) |
| Cards dismiss | Position: Y → Y+40, Modulate: a=1 → a=0 | 200ms | ease-in (expo) |
| Hover enter | Scale: 1.0 → 1.03 | 100ms | ease-out |
| Hover exit | Scale: 1.03 → 1.0 | 100ms | ease-out |
| Press | Scale: 1.0 → 0.97 | 80ms | ease-in |
| Acquired | Border width: 1.5px → 2px | 150ms | ease-out |

All animations use Godot `Tween` (`create_tween()`). No AnimationPlayer nodes are required for card transitions.

---

## 8. Prompt Text

The prompt label sits below the three cards, centered horizontally.

**Default state text:**
> B2 升级选择 — 按 1/2/3 或 ← → + 回车，或点击卡牌

**After selection (acquired feedback):**
> 穿透 已获得

or

> 扇裂 已获得

The prompt is rendered at 13px, muted color, centered. It fades in with the cards and fades out on dismiss.

---

## 9. Coexistence with Existing HUD (UX-09)

### 9.1 Current HUD layout

The existing HUD occupies the top-left corner of the screen as a vertical stack of `Label` nodes:

```
(16, 12)   LIFE [o][o][o]  segments_lost=0
(16, 30)   TIMER tick=0  run_bound=8min(opaque)
(16, 48)   B2: pre-fission
(16, 66)   attack: idle
(16, 84)   kill: none
(16, 102)  feedback: - (quiet)
(16, 120)  (invalidation)
(16, 138)  (no_target)
(16, 156)  contact: none
(16, 174)  (result)
(16, 200)  [upgrade prompt — hidden]
(48, 222)  [card 1 — hidden]
(48, 244)  [card 2 — hidden]
(48, 266)  [card 3 — hidden]
```

### 9.2 Proposed card positioning

The card panel is placed at the **bottom-center** of the screen, well separated from the HUD:

- HUD: top-left, Y range 12–200
- Cards: bottom-center, card centers at Y=270, card bottom at Y=318
- **No overlap between HUD zone and card zone.**

### 9.3 Combat visibility

The cards occupy the lower 35% of the 640×360 viewport. The player (center at Y=180) and typical enemy positions (Y=200, Y=420 in the current 640×720 scene) remain fully visible above the card zone. The card background is semi-transparent (alpha 0.85) so gameplay behind the cards is partially visible but clearly subordinated.

### 9.4 During card display

- Combat is **fully paused** — no enemies move, no attacks fire, no contact damage occurs
- The HUD (LIFE, TIMER, B2) remains visible and readable above the cards
- The B2 label updates to reflect the new phase after the acquired feedback phase completes

---

## 10. Accessibility Requirements (UX-13)

| Requirement | Implementation |
|---|---|
| Non-color state distinction | Border style (solid/dashed), border width, scale, text suffix, alpha — see §7.2 |
| Keyboard-only path | Full: 1/2/3 direct, or ←/→ focus + Enter/Space confirm |
| Mouse-only path | Full: hover to inspect, click to confirm |
| Focus visibility | Dashed border + scale increase, clearly distinguishable from hover |
| Readable text | Minimum 12px font; sufficient contrast against dark card background |
| No rapid flashing | All transitions ≥80ms; no blinking or strobing |
| Stale input protection | Input buffered before inspection phase is discarded; held keys do not repeat-select |
| Focus-loss safety | If window loses focus during card inspection, cards remain visible, selection is preserved, and fresh input is required on return (per UX contract §4) |

---

## 11. Implementation Notes

### 11.1 Node structure (recommended)

```
CanvasLayer (layer 10, same as current HUD)
├── CardPanel (ColorRect — full-width semi-transparent backdrop, optional)
│   ├── Card1 (PanelContainer → VBoxContainer)
│   │   ├── KeywordLabel (Label, tier 1)
│   │   ├── DifferenceLabel (Label, tier 2)
│   │   └── EffectLabel (Label, tier 3)
│   ├── Card2 (same structure)
│   └── Card3 (same structure)
└── PromptLabel (Label, centered below cards)
```

Using `PanelContainer` with a `StyleBoxFlat` for the card background gives free border-radius, border width, and background color control without custom drawing.

### 11.2 Input handling recommendations

- Replace the current per-frame `Input.is_key_pressed` polling for card selection with an `_unhandled_input` approach using `InputEventKey` with `pressed == true` (edge-triggered) to avoid repeated selection from held keys.
- Use a `_guarded` flag during pause transition and acquired-feedback phases to reject all input.
- Track `_input_mode: String = "keyboard"` or `"mouse"` — set to `"mouse"` on `mouse_entered` signal, set to `"keyboard"` on arrow key press. This determines which focus indicator to show.

### 11.3 Card data structure

Cards should be defined as data dictionaries, not hardcoded label strings:

```gdscript
var _upgrade_cards: Array = [
    {
        "id": 1,
        "keyword": "穿透 I",
        "difference": "力场穿透",
        "effect": "命中上限 +2",
        "shortcut": "1",
    },
    # ...
]
```

This separates content from presentation and makes future card pool expansion straightforward.

### 11.4 Stale input rejection

During the pause transition (first 200ms after upgrade window opens) and the acquired-feedback phase (600ms after selection), all card-related input is discarded. The implementation should:

1. Set `_card_input_guarded = true` when the upgrade window begins
2. Start a timer or count frames for the pause transition duration
3. After transition, set `_card_input_guarded = false` to allow inspection
4. On selection, set `_card_input_guarded = true` again
5. After acquired feedback + dismiss, clear the guard

---

## 12. Acceptance Examples

### 12.1 Keyboard path (happy path)

1. Player is in combat; tick reaches 1200
2. Combat freezes; three cards slide up from the bottom over 200ms
3. Card 2 (center) has dashed border (keyboard focus)
4. Player presses `1`
5. Card 1 briefly darkens + shrinks (100ms), then brightens with "穿透 I — 获得" (600ms)
6. Cards slide down and fade out (200ms)
7. Combat resumes; B2 label shows "穿透"; attack line is wider

### 12.2 Mouse path (happy path)

1. Player is in combat; tick reaches 3000
2. Combat freezes; three cards appear
3. Player moves mouse over Card 3 — Card 3 lightens, border brightens, cursor changes to pointer
4. Player clicks Card 3
5. Same pressed → acquired → dismiss flow as keyboard path
6. Combat resumes; B2 label shows "扇裂"; fan arcs visible

### 12.3 Keyboard focus path (happy path)

1. Cards appear; Card 2 focused (dashed border)
2. Player presses Right arrow — focus moves to Card 3 (dashed border on Card 3, Card 2 returns to default)
3. Player presses Left arrow — focus moves back to Card 2
4. Player presses Enter — Card 2 is selected

### 12.4 Stale input rejection

1. Player is holding `1` key as combat approaches tick 1200
2. Upgrade window opens; the held `1` is discarded (input guarded during transition)
3. Player must release `1` and press it again to select Card 1

### 12.5 Focus loss during card selection

1. Cards are visible; player is inspecting
2. Window loses focus (Alt+Tab)
3. Combat remains frozen; cards remain visible; current focus/hover is preserved
4. Window regains focus
5. Previous keyboard focus or hover state is restored
6. Player must provide fresh input (stale Enter/Space from before focus loss is rejected)

---

## 13. Risks and Open Decisions

| Risk | Severity | Mitigation |
|---|---|---|
| Card content (difference dimension, effect text) not yet finalized | Medium | Spec uses placeholder text; content is Systems/Narrative ownership |
| 640×360 viewport may be too small for three 160px cards + readable text | Low | Card width can be reduced to 140px with 14px gap if needed; spec provides safe minimum |
| Dashed border for keyboard focus may not be visually distinct enough | Low | Can add a subtle glow or outline offset as fallback; test with visual QA |
| Tween durations may feel too slow or too fast | Low | All durations are candidate values; tune during implementation |
| Card panel may overlap with future HUD elements | Low | Card zone is in lower 35% of screen; HUD is in upper portion; no known conflict |

**Open decisions requiring User or other role input:**

- Exact card copy (keyword variants, difference dimensions, effect descriptions) — owned by Systems / Narrative
- Exact tween durations and easing curves — owned by UX, tuned during implementation
- Minimum resolution red line — remains candidate; User decision via CR
- Card background artwork vs flat ColorRect — owned by Technical Art / Director
- Whether cards should emit a subtle sound on hover/select — owned by Audio (out of scope for this spec)

---

## 14. Provenance and Compliance

### 14.1 Charter/GDD trace

| Requirement | Source | This spec section |
|---|---|---|
| Three equal horizontal cards | Decision #17, GDD §6.4 | §3 |
| Mouse click or directional focus; Enter/Space | Decision #17, GDD §6.4 | §6 |
| Full pause, feedback before resume | Decision #8, GDD §5.2 | §5 |
| Keyword title + one clear difference dimension | Decision #17, GDD §6.4 | §4 |
| 16:9 baseline, common widescreen | Decision #18, Charter §5 | §3.3 |
| Non-color distinguishability (UX-13) | Decision #19, UX contract §7 | §7.2, §10 |
| HUD must not occlude player/danger/space (UX-09) | UX contract §6.2 | §9 |
| Focus loss preserves selection, requires fresh input | Decision #17, PRECHARTER-09 | §5.1, §12.5 |

### 14.2 Decision layering

- **`user_confirmed`:** Charter decisions #7, #8, #17, #18, #19; PRECHARTER-08, PRECHARTER-09; DC-PLAT-02 Option 2 (R03)
- **`team_proposal`:** card dimensions, layout positions, tween durations, state visuals, transition flow
- **`assumption`:** 640×360 viewport is representative; text will be readable at specified sizes; dashed border will be visually distinguishable
- **`unresolved`:** exact card copy, tween curves, sound, background artwork, minimum resolution red line, reduced-motion policy

---

## 15. Closure

- **Role expert:** `godot-ux-ui-expert`
- **Mission/result:** B2 card selection UX interaction spec, covering layout, information hierarchy, all interaction states, keyboard and mouse paths, feedback design, accessibility, HUD coexistence, and acceptance examples
- **Critical journey and states:** combat → pause → inspect → select → feedback → resume; all states (default, hover, focus, pressed, selected, dimmed) covered
- **UX decisions/tradeoffs:** cards placed in lower screen third to avoid HUD and gameplay occlusion; dashed border for keyboard focus vs solid for hover; 1/2/3 direct + arrow keys + mouse as three valid input paths; stale input rejected during transitions
- **Evidence produced:** static spec document only; no runtime, visual QA, or acceptance evidence
- **Risks/unknowns:** card copy not finalized; tween durations are candidates; viewport size assumption needs verification
- **Handoffs:** Tech Lead for implementation contract; Systems for card data content; Director for creative review of information hierarchy; QA for acceptance test cases (§12)
- **Stop condition:** static spec complete; no Godot access, code, scene, asset, build, runtime, test, QA, performance, export, or release
- **Closure-ready:** `yes`