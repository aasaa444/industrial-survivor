# KICKOFF UX/UI CONTRACTS v0.1

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`
>
> **Contract type:** static UX/UI proposal for future review. It is not implementation authorization, a runtime result, visual QA, usability result, accessibility conformance result, or release acceptance.
>
> **Scope update (v0.1):** This document now includes **Part B (Gate 3 Visual/UI Preparation Contracts)** covering HUD layer hierarchy, focus safety protocol, card state machine, card visual feedback specification, and text/layout/accessibility specifications. Part A (general UX/UI contracts) and Part B (Gate 3 specific contracts) together form the complete kickoff readiness package for Gate 3 — Visual/UI.

## 1. Metadata, authority, and evidence boundary

| Field | Record |
|---|---|
| Artifact | `KICKOFF_UX_UI_CONTRACTS_v0_1.md` |
| Version | `v0.1` |
| Owner | UX/UI specialist (proposal owner); User remains product owner and final authority |
| Execution authority | Executive Producer / Lead Producer within the authorized Charter |
| Creative authority | Game Director / Creative Director |
| Technical authority | Tech Lead |
| Acceptance authority | Independent QA / Release Lead; implementer cannot self-certify |
| Product state | Development Charter v0.1 authorized for governance only |
| Current phase | `development governance / kickoff readiness preparation` |
| Implementation state | `DEVELOPMENT NOT STARTED` |
| Approval state | `NOT APPROVED` |
| Evidence class | `static/source` only, plus a referenced `synthetic/anchor` baseline |

### 1.1 Authority and non-authorization

This artifact organizes UX/UI contracts for kickoff readiness. It may recommend interaction, information hierarchy, copy structure, focus safety, responsive behavior, and future evidence collection. It does not redefine the player promise, add features, lock unresolved values, approve an architecture, authorize Godot access, start implementation, commit milestones, or accept a visual result.

The authorized Development Charter v0.1 is effective for **development governance only**. Its authorization does not authorize immediate implementation, Godot/GDMCP access or mutation, code, scenes, resources, assets, build, runtime, tests, QA execution, performance measurement, export, release, or kickoff execution before readiness. This document does not relax that firewall.

No runtime, visual QA, usability, accessibility, performance, export, or release evidence exists in this package. Static prose and the Anchor cannot establish that a player understands the game or that an implemented UI passes acceptance.

### 1.2 Expert preflight and stop condition

- **Target player/context:** a PC-first single-player player entering one bounded eight-minute survivor-like Slice.
- **Critical journey:** entry, movement-to-next-automatic-attack comprehension, pressure and clearing, two guaranteed upgrade pauses, B2 readability, terminal result, and immediate retry.
- **Top comprehension risks:** movement may read as mere evasion rather than attack control; B2 spectacle may obscure clearing space; cards may not communicate one meaningful difference; focus loss may cause stale confirmation; HUD may compete with player/danger/space.
- **Target conditions:** 16:9 baseline, common widescreen candidate, keyboard WASD/arrows for movement, mouse or directional focus plus Enter/Space for cards; exact minimum resolution and thresholds unresolved.
- **States in scope:** the state matrix in §3, focus/epoch safety, upgrade selection, HUD hierarchy, causal hint, B2/clearing read, terminal/restart, responsive and accessibility directions.
- **Evidence route:** future authorized Tech contracts, runtime observation, visual QA, independent QA/Release evidence, and Director review. This document itself supplies static design evidence only.
- **Ownership boundary:** UX/UI owns the player-facing contract and observable acceptance examples; Tech owns implementation seams; Systems owns rules; Director owns creative coherence; QA/Release owns independent acceptance.
- **Stop condition:** stop at this static contract. No Godot, code, scene, asset, build, runtime, test, QA, performance, export, or release activity is performed here.

## 2. Provenance and decision layering

This contract preserves four layers and does not upgrade one layer into another:

- **`user_confirmed`:** explicit product constraints retained from the current effective records, including the 22 decisions and PRECHARTER-01..11. They remain bounded by their stated unresolved fields.
- **`team_proposal`:** this document's UX/UI recommendations, acceptance examples, and evidence schema suggestions. They require the appropriate review or user decision where they cross authority.
- **`assumption`:** expectations that player cognition, readability, and causal comprehension will hold in a future observed Slice. They require observation.
- **`unresolved`:** exact copy, layout, timing, thresholds, implementation semantics, supported resolutions, and other open details. Silence does not resolve them.

### 2.1 Provenance map

| Contract input | Source trace | Status retained here |
|---|---|---|
| 22 baseline decisions | `SLICE_RULES_DECISION_v0_1.md §13.2–§13.6`; echoed in `GDD_SLICE_v0_1.md §9.1` | `user_confirmed` candidate constraint; unresolved detail remains open |
| PRECHARTER-01..11 | `SLICE_PRECHARTER_DECISIONS_v0_1.md §3–§8` | `user_confirmed` boundary where stated; technical and numeric details remain open |
| Player promise, pillars, Slice intent | `CREATIVE_BRIEF_v0_1.md §§player promise, experience pillars, slice intent`; `GDD_SLICE_v0_1.md §§2–3` | confirmed direction plus `Director interpretation`; not UX or runtime acceptance |
| HUD, hint, cards, focus safety | `DEVELOPMENT_CHARTER_DRAFT_v0_1.md §§5–6`, `GDD_SLICE_v0_1.md §§6.1–6.6`, `PRECHARTER-06..09` | user-confirmed boundaries plus UX proposal; exact details unresolved |
| Visual baseline | `ANCHOR_DECISION.md §§2–5` | `anchor_core_v0_1.png` is accepted static baseline; v0.2 is unaccepted candidate |
| Charter governance | `DEVELOPMENT_CHARTER_DRAFT_v0_1.md §§2, 3, 10, 12–14` | governance-only authorization; no implementation or acceptance implied |

The historical `22` decisions and `PRECHARTER` increments remain traceable. This artifact does not rewrite their source files, collapse historical unresolved entries, or treat proposals as product decisions.

## 3. UX state matrix

The matrix describes the intended player-facing contract. “Acceptance evidence” names future observable evidence, not evidence currently available.

| State | Player goal | Affordance | Input | Feedback | Next decision | Acceptance evidence |
|---|---|---|---|---|---|---|
| Entry | Understand where play begins and what first action matters | Player, danger, open space, persistent HUD, one extremely short causal hint are visible | Fresh movement input via WASD/arrows | Entry settles into readable combat; hint identifies movement-to-next-attack relationship | Move, observe, or hold a route | Future runtime frame + independent observation: entry is readable without implementation inference |
| Combat | Preserve a route and influence the next automatic attack | Player silhouette, nearest danger, enemy tide, and clear space outrank decoration | WASD/arrows; no dash/dodge promise | Movement is visible; next attack result is attributable later; hit/kill feedback is layered and short | Continue route, reposition, or let attack resolve | Runtime scenario with movement before firing and observed attack/clearing comparison |
| No-target | Understand that an attack cycle can resolve without a target | No fabricated target or misleading lock indicator; combat remains legible | Movement remains available; no special recovery input required | No-target handling is quiet and understandable; no false hit/kill feedback | Keep moving or wait for a new threat | Deterministic runtime trace plus QA observation of no-target branch |
| Upgrade pause 1 — focus/hover | Inspect three `穿透` alternatives and compare one clear difference | Three equal horizontal cards; current focus/hover visibly distinct | Mouse hover/click or directional focus | Full combat pause; cards become the decision surface | Move focus/hover among cards | Runtime/visual QA frame showing three cards, pause, focus visibility, and readable comparison |
| Upgrade pause 1 — pressed | Confirm the intended `穿透` card without ambiguity | Focused card enters pressed state | Enter/Space or mouse click | Short pressed feedback; no second card or stale event is accepted | Await acquired feedback | Runtime input observation of one valid confirmation and no accidental double-confirm |
| Upgrade pause 1 — selected/acquired | Know which `穿透` choice was acquired | Selected card remains identifiable long enough to read result | No additional confirmation required | Acquired feedback precedes resume; chosen result is explicit | Return to combat | Runtime frame/trace showing selection, feedback, and ordered resume |
| Upgrade pause 2 — focus/hover | Inspect three `扇裂` alternatives after the first power step | Same card structure and focus contract; keyword changes to `扇裂` | Mouse hover/click or directional focus | Full combat pause; B2 stage remains understandable | Choose one card; no skip/reroll | Runtime/visual QA evidence of fixed order and equal-card comparison |
| Upgrade pause 2 — pressed | Confirm one `扇裂` card | Focused card enters pressed state | Enter/Space or mouse click | One pressed confirmation, protected from stale input | Await acquired feedback | Independent observation of exactly one legal confirmation |
| Upgrade pause 2 — selected/acquired | Understand that the same-source attack has reached B2 | Selected card and B2 phase are explicit | No extra confirmation | Acquired feedback shows `扇裂`; resume follows | Return to B2 combat and read clearing | Runtime before/after evidence of card-to-B2 causal continuity |
| Focus loss — combat | Avoid unintended movement/attack consequences while window is inactive | No new confirmation affordance appears; world is frozen for required scope | Window/focus loss event | Immediate combat freeze; player state and relevant focus context are preserved | Return focus, then provide fresh explicit input | Runtime focus-loss scenario + QA trace proving no hidden progress or stale action |
| Focus loss — card selection | Preserve the pending choice and prevent accidental selection | Existing focused/selected card remains visible; no card is silently changed | Window/focus loss event | Immediate freeze of upgrade confirmation; selection is preserved | Return focus, inspect, then explicitly confirm | Runtime/visual evidence of preserved focus/selection and no stale Enter/Space confirm |
| Resume | Resume only after a fresh, intentional input epoch | Restored play/focus is visible; no hidden auto-confirm | Fresh explicit legal input required; stale Enter/Space rejected | Resume is deliberate and state-consistent | Continue movement or make the pending card decision | Tech/runtime evidence with input epoch IDs or equivalent observable trace; exact mechanism unresolved |
| Victory | Recognize control completed and brief relief | Clear result state takes priority over decoration | No required result confirmation | Non-color victory distinction; short result then automatic restart | Observe brief result, then re-enter | Runtime/visual QA evidence of 8-minute completion, readable result, and restart |
| Defeat | Recognize a light interruption and immediate retry | Clear result state, not a punitive screen or complex menu | No required result confirmation | Non-color defeat distinction; short result then automatic restart; no out-of-run loss | Re-enter and try again | Runtime/visual QA evidence of life depletion, result distinction, and immediate retry |
| Result | Read the terminal outcome before reset | Result label/state is visually and semantically prioritized | Input is not required to restart | Short, clear, bounded result presentation | Automatic reset path | Timed runtime observation with build/config identity; duration unresolved |
| Restart | Start a clean next run without carrying unintended state | Canonical automatic restart path; entry hierarchy returns | Fresh play input after reset; stale terminal input rejected as needed | No out-of-run loss; entry state is recognizable | Move and observe the next run | Runtime reset trace plus independent QA check of clean state and retry latency |

**Cross-state rule:** player, danger, enemy tide, and recovered/movable space outrank HUD and effects during combat; result priority outranks decoration only during terminal states. Exact layout, timing, and thresholds remain unresolved.

## 4. Focus and interaction contract

1. **Combat focus loss:** when the window loses focus, combat freezes immediately for the required scope. No world progression, movement consequence, attack consequence, or hidden confirmation may occur while inactive.
2. **Upgrade focus loss:** when the window loses focus during card selection, upgrade confirmation freezes immediately. The current focus/hover/selection context is preserved; no card is silently replaced, skipped, rerolled, or confirmed.
3. **Fresh input epoch:** after focus returns, the system must require a new explicit legal input epoch before resuming or confirming. The Enter/Space event that occurred before or during focus loss must not be replayed as confirmation.
4. **Stale input rejection:** stale Enter/Space, queued confirmation, or equivalent buffered action must be rejected. The exact event/buffer implementation is unresolved and belongs in a Tech contract.
5. **Input ownership:** movement uses WASD/arrows; upgrade focus/selection uses mouse or directional focus with Enter/Space confirmation. No gamepad promise is added.
6. **Visible state:** focus must have a non-color signal; pressed, selected/acquired, disabled/frozen, and resumed states must be distinguishable without relying on hidden state.
7. **Recoverability:** returning focus must not discard meaningful selection or force the player to reconstruct a choice without explanation. Any resume affordance must not create an extra product step unless approved through Change Request.
8. **Open implementation questions:** focus event policy, pause scope boundary, return-focus target, epoch representation, buffering/flushing semantics, platform behavior, and any resume messaging remain `unresolved`.

## 5. Upgrade flow contract

### 5.1 Shared flow

`focus/hover → pressed → selected/acquired feedback → resume`

- The combat world fully pauses for each guaranteed upgrade.
- The first pause presents three same-keyword `穿透` variant cards; the player chooses exactly one.
- The second pause presents three same-keyword `扇裂` variant cards; the player chooses exactly one.
- There is no skip and no reroll.
- Cards are three equal horizontal columns. Mouse click and directional focus are both valid paths. Enter/Space confirms the focused choice.
- The selected card must produce a short, readable acquired feedback before combat resumes.
- The B2 phase must remain semantically trackable as `穿透 → 扇裂`; exact visual treatment is unresolved.

### 5.2 Decision readability boundary

The card title is the keyword. Each card should expose one clear difference dimension, so the player can compare without scanning a complex build sheet. The difference dimension, card copy, values, icons, pool, layout metrics, and feedback timing are proposals/open fields—not approved product content.

### 5.3 Invalid and recovery cases

- A stale Enter/Space event does not confirm a card after focus loss.
- A click outside a valid card does not silently select a card; exact invalid-click feedback is unresolved.
- A second confirmation during pressed/acquired feedback does not acquire another card.
- Focus loss preserves the pending choice and returns the player to an inspectable state.
- Restart and terminal-state input must not leak into a new run; exact reset/input-lock semantics are a Tech/Systems dependency.

## 6. HUD and readability contract

### 6.1 Persistent hierarchy

The persistent HUD must show:

1. **Life** — three-segment survival state.
2. **Timer** — the eight-minute run boundary.
3. **B2 phase** — semantically explicit `穿透 → 扇裂`, with current phase readable.
4. **XP/fragments** — subordinate intermediary only, minimized and never allowed to compete with combat readability.

Exact HUD position, anchors, text, iconography, colors, stage treatment, safe margins, scaling, and minimum resolution are unresolved. No invented pixels, thresholds, font sizes, or contrast numbers are introduced here.

### 6.2 Spatial hierarchy and occlusion safety

- **First read:** player silhouette, nearest danger, enemy tide, and clear/movable space.
- **Second read:** attack result, hit/kill feedback, and the changed route/corridor.
- **Third read:** persistent life/timer/B2 HUD.
- **Supporting read:** XP/fragments and incidental environmental detail.

HUD and effects must not occlude the player, immediate danger, enemy-wave flow, attack result, or recoverable corridor. B2 must not become a sustained light field. Any layout proposal must reserve occlusion-safe zones and be checked later at the declared aspect ratios.

### 6.3 Causal movement hint

The player must be able to relate movement to the next automatic attack result. The hint is extremely short, functional, appears on entry, fades after the first effective movement, and appears once per run. Exact wording, localization, definition of “effective movement,” placement, fade timing, and behavior on focus loss/restart remain unresolved. This is a future comprehension observation target, not a current usability claim.

## 7. Accessibility and responsive contract

- **Baseline:** 16:9 design baseline; common widescreen support set = **{16:9, 16:10, 21:9}** as a directional candidate support commitment per **DC-PLAT-02 / Option 2** (Batch 1 decision record R03, 2026-08-16); not a named release platform. The `1280×720` minimum-resolution red line remains **candidate only**（仅候选，须经 CR + 用户批准才成为正式门槛）.
- **Responsive behavior:** preserve readable hierarchy and interaction targets; prefer additional safe space over stretching text/cards. Scaling rule per **DC-PLAT-02 / Option 2** (R03, 2026-08-16): **fit + letterbox gaps + UI relative scaling protecting safe areas; stretch and crop are prohibited**. Exact letterbox-gap presentation and scaling tiers remain `unresolved` (Tech feasibility confirmation required).
- **Keyboard:** WASD and arrows for movement; directional focus plus Enter/Space for card selection. No gamepad promise.
- **Non-color communication:** victory/defeat, focus, selected/acquired, pressed, disabled/frozen, and relevant combat states must not rely on color alone.
- **Focus visibility:** keyboard focus must be visibly distinguishable and retained through the focus-loss contract.
- **Text/card readability:** keyword title plus one clear difference dimension; text must remain readable at supported targets and not be embedded only in imagery.
- **Safe area/scaling:** protect HUD and cards from clipping, overlap, and unsafe edges; exact safe-area policy and scaling tiers remain open (scaling rule per DC-PLAT-02 / Option 2 above, R03 2026-08-16).
- **Motion/flash:** feedback should be short and restrained; no sustained high-frequency flashing or motion that obscures player/danger/space. Reduced-motion behavior is unresolved.
- **Reserved thresholds:** minimum resolution, contrast ratio, minimum focus/target size, minimum text size, flash frequency, motion duration, and reduced-motion policy remain `unresolved` and user-reserved where they become product or release commitments. Per **DC-PLAT-02 / Option 2** (R03, 2026-08-16), `1280×720` stays **candidate only**（仅候选，须经 CR + 用户批准才成为正式门槛）; no value is promoted by this contract.

This section is an accessibility direction and contract proposal. It is not an accessibility audit or conformance result.

## 8. B2 and clearing readability contract

- Read the scene as **center / left / right arcs** after `扇裂`: the central arc remains and left/right arcs are added.
- All three arcs inherit `穿透`; counters are independent. These are product boundaries from the current rules record, not invented implementation details.
- The player must read the causal sequence: same-source attack → expanded coverage → enemy tide reduction → corridor/movement-space recovery.
- Clearing enemy tide and recovering a usable corridor take priority over spectacle, persistent glow, or a large luminous field.
- Feedback must preserve player silhouette, immediate danger, wave flow, and the post-clear space through the strongest moment.
- Exact arc geometry, angle, interval, length, hit cap, attenuation, duplicate-hit rule, and visual timing remain unresolved and belong to Systems/Tech/Director review.

Future visual evidence must compare before/impact/after states in context. The static Anchor can guide hierarchy but cannot establish that clearing or control is readable in motion.

## 9. Evidence matrix and retest contract

| ID | Future observation target | Evidence class | Required evidence fields | Current status | Retest fields |
|---|---|---|---|---|---|
| UX-01 | Entry, hint, first effective movement, hint fade once | `runtime` + `QA` | evidence ID, build/config, input sequence, frame refs, observer, verdict | `not_run / not_ready` | preserve failure; new build/config, affected entry run, regression on restart |
| UX-02 | Movement relates to next automatic attack and clearing — crystallized per cr-001 Option A key order (`nearest threat → cluster-center distance → stable ordering/stable ID`), M-1 observable faces (nearest-threat / cluster-center / stable-order), UX-INPUT scenarios U2-A..D | `runtime` + `QA` | fixture/seed, movement trace, attack trace (candidate_ids/ordered_ids/target_snapshot_ids/hit_results), before/after frames, observer, verdict | `not_run / not_ready` | same scenario with new identity; re-observe causality and space |
| UX-03 | No-target branch is quiet and non-misleading — crystallized per UX-INPUT S1/S2/S3, Systems quiet-cycle form, cr-004 (i) snapshot semantics, scenarios U3-A..D | `runtime` + `QA` | deterministic fixture, no_target_branch, feedback class bound to hit_results, next_eligible_fire_tick, trace, frame/log refs, observer, verdict | `not_run / not_ready` | repeat no-target and adjacent-target cases |
| UX-04 | Upgrade 1: three `穿透` cards, focus/hover, pause, one confirm | `runtime` + `visual QA` | state, input path, screenshots/frame index, build/config, observer | `not_run / not_ready` | affected card path plus keyboard/mouse regression |
| UX-05 | Upgrade 2 fixed order and three `扇裂` cards | `runtime` + `visual QA` | prior acquired state, card state, input path, frame refs, observer | `not_run / not_ready` | repeat both upgrade windows and order check |
| UX-06 | Focus loss during combat freezes immediately | `runtime` + `QA` | focus event, state before/after, epoch/trace reference, timestamps, observer | `not_run / not_ready` | repeat on affected window/aspect/build configuration |
| UX-07 | Focus loss during card selection preserves focus/selection | `runtime` + `visual QA` + `QA` | selected/focused card, focus event, stale-input attempt, frame refs, observer | `not_run / not_ready` | repeat stale Enter and Space cases plus mouse path |
| UX-08 | Fresh input epoch and stale Enter/Space rejection | `runtime` + `QA` | event sequence, epoch/trace field or equivalent, outcome, build/config | `not_run / not_ready` | rerun same sequence after fix; preserve original failure |
| UX-09 | HUD life/timer/B2 persistent; XP subordinate; no occlusion — at named aspects `{16:9 baseline, 16:10, 21:9}` per **DC-PLAT-02 / Option 2** (R03, 2026-08-16) | `visual QA` + `runtime` | aspect/resolution, state, screenshot/frame refs, observer, verdict | `not_run / not_ready`（support set per DC-PLAT-02 Option 2; `1280×720` red line candidate only） | affected aspect/state plus 16:9 regression |
| UX-10 | Victory and defeat are non-color-distinct, short, and restart | `runtime` + `visual QA` + `QA` | terminal trigger, result frame refs, timing, reset identity, observer | `not_run / not_ready` | victory, defeat, same-frame precedence, and clean restart |
| UX-11 | B2 center/left/right arcs, inherited piercing, independent counters, clearing space | `runtime` + `visual QA` + `QA` | pre/post frames, trace/counters, fixture/seed, observer | `not_run / not_ready` | affected B2 state plus clearing regression |
| UX-12 | Common widescreen readability and safe-area behavior — named aspects `{16:9, 16:10, 21:9}`, fit + UI scaling, no stretch / no crop per **DC-PLAT-02 / Option 2** (R03, 2026-08-16) | `visual QA` + `QA` | named aspect/resolution, build/config, frames, clipping/overlap notes, observer | `not_run / not_ready`（per DC-PLAT-02 Option 2; `1280×720` red line candidate only） | failed aspect plus baseline 16:9 |
| UX-13 | Accessibility direction: focus, text/cards, non-color states, restrained motion | `visual QA` + `QA` | target settings, state coverage, frame refs, checklist, independent verdict | `not_run / not_ready` | affected state/aspect and full accessibility subset |

**Evidence boundary:** `static/source` proves only that this contract and its sources exist. `synthetic/anchor` proves only a static visual reference. Neither replaces `runtime`, `visual QA`, `usability observation`, `accessibility review`, `performance`, or independent QA evidence.

**Required future record fields:** evidence ID; fixture ID; seed; tick/config version where applicable; trace/snapshot reference; hardware/OS/settings where applicable; build ID; logs; screenshots or observed-frame references; timestamp; owner/observer; verdict; unresolved deviations; and retest linkage. A retest adds new evidence IDs and preserves the original failure.

## 10. Anchor boundary

`ANCHOR_DECISION.md` v0.1 and `anchor_core_v0_1.png` are the current user-accepted **static preproduction baseline** (`synthetic/anchor`). They inform rusted-industrial mood, restrained cyan signal, silhouette, core→transition→falloff, before/impact/after comparison, and clearing-space priority.

`anchor_core_v0_2.png` remains an **unaccepted candidate**. It cannot silently replace v0.1. No candidate refinement, static image, or visual direction in this contract constitutes Director acceptance, user aesthetic acceptance, final asset approval, runtime proof, or visual QA.

## 11. Dependencies and handoffs

| Dependency | UX/UI handoff / required decision | Authority boundary |
|---|---|---|
| Tech contracts | Read model for player/danger/space/HUD data; focus event and input epoch; stale-event rejection; pause/resume and reset semantics; config/version and trace fields | Tech Lead authors implementation contract/ADR; architecture crossings return to User |
| Systems / rules | States and ordering for no-target, upgrades, B2, contact safety, terminal precedence, and restart | Systems owns rule proposals; UX does not redefine mechanics |
| Game Director / Creative Director | Review player-promise coherence, clear-screen result, B2 same-source read, Anchor v0.1 boundary, and non-punitive rhythm | Director reviews creative coherence; no UX self-acceptance |
| Executive Producer / Lead Producer | Sequence readiness, preserve scope, intake CRs, assemble evidence and gates | Producer owns execution governance and cannot waive QA blockers |
| Independent QA / Release | Define and independently observe Gate 1/3/6-relevant interaction, visual, accessibility, and retest evidence | QA/Release owns acceptance and may block |
| User | Decide product-level copy/layout/threshold/platform or scope crossings when reserved | User is final product authority; silence is not consent |

## 12. Change Request triggers and open decisions

A Change Request is required for every new feature, direction, platform, architecture, scope, schedule, cost, release commitment, or acceptance-threshold change. The request must record motivation, provenance, alternatives, displaced work, dependencies, risk, evidence impact, owner, and decision authority.

UX/UI must escalate to the User when a proposal:

- changes the player promise, experience pillars, immutable Charter decision, or Slice cap;
- adds input devices, platforms, screens, progression, cards, menus, tutorial steps, or other scope;
- promotes a minimum resolution, contrast, target size, flash/motion limit, copy, timing, or layout into a product/release commitment;
- changes the accepted Anchor baseline or treats v0.2 as accepted;
- creates architecture risk through focus, event, read-model, pause, or reset semantics;
- changes a release commitment or acceptance gate.

Current open UX/UI decisions include exact hint copy and fade timing; card copy, values, icons and difference dimension; focus style and return-focus target; focus epoch/buffer semantics; HUD placement and safe zones; minimum resolution and supported widescreen set; scaling/letterbox/crop behavior; contrast/text/focus-size/flash/motion thresholds; result copy/timing; and evidence acceptance thresholds. These remain `unresolved`.

## 13. Closure status

- **Artifact status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`.
- **Static deliverable:** this UX/UI contract package only.
- **Files modified:** only `docs/ux/KICKOFF_UX_UI_CONTRACTS_v0_1.md`.
- **No work claimed:** no Godot/GDMCP access, code, scenes, resources, assets, build, run, test, visual QA, usability study, accessibility audit, performance measurement, export, release, nested delegation, or implementation start.
- **Closure-ready:** `yes` for this static UX/UI contract assignment (now includes Part B Gate 3 Visual/UI Preparation Contracts); not a kickoff or acceptance-ready verdict.
- **Next handoff:** Producer may include this package in kickoff-readiness review. Tech, Systems, Director, and Independent QA must review their respective dependencies before any future implementation gate. Part B additions (sections §14–§19) are part of the Gate 3 readiness package and must be reviewed alongside Part A.

---

# PART B — Gate 3 Visual/UI Preparation Contracts

> **Purpose:** The following five sections (§14–§18) supply the explicit, structured specifications required for Gate 3 — Visual/UI readiness. They expand on the general contracts in Part A (§§3–9) with concrete layer definitions, protocol flows, state machines, visual feedback tokens, and layout/accessibility measurements. All values are `team_proposal` unless noted; exact thresholds, timing, and pixels remain `unresolved` pending implementation tuning and Director/QA review.

## 14. HUD Layer Hierarchy (4 layers)

The persistent HUD is organized into four layers, ordered by visual priority from foreground to background. Each layer has a distinct functional role and spatial zone to prevent occlusion of the combat-critical first read (player, danger, space).

### 14.1 Layer definitions

| Layer | Name | Content | Spatial zone (640x360) | Z-order | Notes |
|---|---|---|---|---|---|
| **L1** | **Critical status** | Life segments (3 segments). Timer (8-min run boundary). | Top-left corner. Anchored at (16, 12). Occupies roughly (16, 12) to (180, 50). | Foremost HUD layer. Always visible. | Must not be occluded by any other HUD layer or card panel. Non-color segment indicators required (filled/empty/dashed per segment). |
| **L2** | **Phase indicator** | B2 phase label: current keyword phase (pre-`穿透` / `穿透` / `扇裂`). | Below L1. Approx. (16, 56) to (180, 80). | Second priority. | Text or icon + text. Phase transition must be readable before combat resumes after upgrade. |
| **L3** | **Subordinate info** | XP/fragment count (two-upgrade intermediary). Kill count or other secondary stats if needed. | Below L2 or right-aligned. Approx. (16, 84) to (200, 120). | Third priority. | Minimized at all times. Must never compete with L1/L2 or combat readability. Muted visual treatment. |
| **L4** | **Causal hint (transient)** | One extremely short movement-to-attack hint. Appears on entry, fades after first effective movement, once per run. | Bottom-center or above player. Exact position `unresolved`. | Transient overlay. | Not persistent. Fades once per run. Content, wording, placement, fade timing `unresolved`. |

### 14.2 Cross-layer rules

- L1 and L2 are always visible and persistent. L3 is persistent but visually subordinate. L4 is transient.
- No layer may occlude the player silhouette, nearest danger, enemy tide, or clear/movable space during combat (per Charter §6.2 spatial hierarchy).
- The card panel (upgrade selection) is not part of the persistent HUD. When active, it occupies the lower-center zone (per §15 card layout) and does not overlap L1/L2.
- During terminal states (victory/defeat/result), a result label may temporarily elevate to L1 priority, but does not replace L1 — it appears in a non-overlapping zone.
- Exact font sizes, iconography, background treatment, padding, and safe margins for each layer are `unresolved`.

### 14.3 Widescreen behavior

Per DC-PLAT-02 Option 2 (R03): fit + letterbox gaps + UI relative scaling; no stretch, no crop.

| Aspect | HUD behavior |
|---|---|
| 16:9 (baseline) | Layout as specified above |
| 16:10 | L1/L2/L3 anchor to top-left; vertical spacing increases proportionally; L4 repositions relative to player |
| 21:9 | L1/L2/L3 remain top-left; additional horizontal margin prevents clipping on ultrawide; no stretching |

Card dimensions remain fixed; only anchor positions adjust. HUD text size remains fixed at the baseline pixel value; no dynamic scaling of text.

## 15. Focus Safety Protocol

The focus safety protocol defines behavior when the game window loses or regains OS focus. It applies to both combat mode and upgrade-pause (card selection) mode. The protocol has four mandatory elements.

### 15.1 Protocol elements

| Element | Description | Contract |
|---|---|---|
| **1. Freeze** | On focus loss, the game must freeze immediately for the required scope. | Combat: all movement, attack cycles, enemy movement, contact damage, and XP accrual stop. No world progression occurs. Upgrade pause: card selection input stops; no card is confirmed, skipped, or changed. |
| **2. Buffer** | During frozen state, all buffered input events are held but not processed. | No queued Enter/Space, no held key repeat, no mouse click queued before or during focus loss may be processed as a legal action after focus returns. Buffer is informational only; the buffer contents are discarded, not replayed. |
| **3. Input clear** | On focus loss, all input state is invalidated. | Movement keys: released (virtual state). Card focus: preserved visually but input-mode reset to neutral. Confirmation keys (Enter/Space/1/2/3): cleared. Mouse position: no stale click state retained. |
| **4. Fresh epoch** | On focus regain, only new, explicitly provided input is accepted. | The system must require a new explicit legal input epoch before resuming combat or confirming a card. The Enter/Space event that occurred before or during focus loss must not be replayed as confirmation (decision #17, PRECHARTER-09). |

### 15.2 Mode-specific behavior

| Mode | Freeze scope | Buffer behavior | Input clear scope | Fresh epoch requirement |
|---|---|---|---|---|
| **Combat** | All combat state frozen. Player position retained. Enemy positions and attack cycles frozen. Contact damage blocked. | Movement key state held but not applied. No attack/tick progression. | All held keys released virtually. Mouse position retained but click state cleared. | First new movement input after regain resumes combat. |
| **Card selection (upgrade pause)** | Card selection frozen. Combat already paused. | No card confirmation or focus change processed. | Enter/Space cleared. Number key (1/2/3) state cleared. Arrow key state cleared. Mouse click state cleared. | First new directional or click input after regain re-engages card inspection. Previous focus/hover visual state is preserved for reference but not treated as active. |
| **Terminal (victory/defeat/result)** | No combat to freeze. Result display frozen. | No restart or confirmation processed. | Restart/confirm input cleared. | First new input after regain triggers restart path. |

### 15.3 Implementation direction (for Tech contract)

- The exact mechanism for detecting focus loss/regain (Godot `focus_entered`/`focus_exited` signals on the main window or equivalent) is `unresolved`.
- The epoch representation (integer counter, event ID, or equivalent) is `unresolved`.
- The buffer-flushing semantics (discard buffered events vs. replay last legal event) must follow the contract above: **discard, never replay**.
- Platform-specific behavior (e.g., macOS Mission Control, Windows Alt-Tab, Linux window manager focus) must be validated at Gate 3.
- The focus epoch mechanism proposed in ADR-TECH-05 (increment on loss, increment on resume, discard prior-epoch events) is directionally aligned with this contract.

### 15.4 Evidence targets

| ID | Observation target | Acceptance example |
|---|---|---|
| UX-06 | Focus loss during combat freezes immediately | Runtime: Alt-Tab during combat; observe no enemy movement, no attack progression, no hidden progress after regain |
| UX-07 | Focus loss during card selection preserves focus/selection | Runtime: Alt-Tab during upgrade pause; observe cards visible, no card silently changed/confirmed; stale Enter/Space after regain is rejected |
| UX-08 | Fresh input epoch and stale rejection | Runtime: hold Enter before focus loss; after regain, Enter is rejected; only new press is accepted |

## 16. Card State Machine

The card state machine defines the lifecycle of a single card during upgrade selection. There are six discrete states. A card transitions through these states; only one state is active at any time.

### 16.1 State definitions

| State | Description | Visual signal | Input accepted | Transition triggers |
|---|---|---|---|---|
| **idle** | Card is visible but not focused or hovered. Default resting state after cards appear. | Dark fill, muted border (1px), normal text. Scale 1.0. | No (only focused/hovered card accepts input). | On cards appearing after pause transition. On hover/focus leaving this card. On another card gaining focus/hover. |
| **hover** | Mouse cursor is over this card. Temporary visual inspection state. | Lightened fill, brightened border (1.5px, solid), slight scale increase (1.03). Cursor: pointing hand. | No direct confirmation (hover is inspection only; click triggers transition to pressed). | On `mouse_entered` signal. On `mouse_exited` returns to idle. On keyboard arrow press from this card returns to idle (keyboard takes priority). |
| **pressed** | Player has confirmed selection (Enter/Space, click, or number key). Brief confirmation flash. Duration ~100ms. | Darkened fill, thick accent border (2px), scale decrease (0.97), bold text. | No (all input blocked during pressed + acquired feedback). | On valid confirmation input while this card is focused/hovered. |
| **selected (acquired)** | After pressed phase, this card is the acquired choice. Visible feedback period ~600ms. | Accent fill, bright accent border (2px, solid), bold text + "获得" suffix. Scale returns to 1.0. | No (input still blocked). | On pressed timer completion. |
| **transition_out** | Cards are being dismissed. Cards slide down and fade out. Duration ~200ms. | Opacity fading, position tweening downward (Y + 40px). | No (all input blocked). | On acquired feedback timer completion. |
| **dimmed** | Sibling cards (the two not selected) during pressed/selected phases. | Darker fill, faded border (1px), muted text alpha, scale decrease (0.95). | No. | On any sibling card entering pressed state. |

### 16.2 State transition diagram

```
                     cards appear
                         |
                         v
    +--------- hover <---+---> idle <--- hover exit / arrow from this card
    |            |        |        ^           |
    |  mouse_    |        |        |           | arrow key / 1/2/3 from another card
    |  entered   |        |        |           |
    |            v        |        +-----------+
    +--- [hover]  --------+                    
    |            |                             
    | click /    |  arrow key to another card  
    | Enter/Space|                             
    v            v                             
 [pressed] (~100ms)                           
    |                                          
    v                                          
 [selected / acquired] (~600ms)               
    |                                          
    v                                          
 [transition_out] (~200ms)                    
    |                                          
    v                                          
  (cards removed, combat resumes)             
                                             
Sibling cards:                                
 [idle] ---> [dimmed] during pressed/selected 
 [dimmed] ---> [idle] on transition_out complete
```

### 16.3 Keyboard focus vs. mouse hover distinction

| Property | Keyboard focus | Mouse hover |
|---|---|---|
| Border style | **Dashed** | **Solid** |
| Border color | Accent (blue-white) | Brightened neutral |
| Scale | 1.03 | 1.03 |
| Cursor | Default | Pointing hand |
| Priority rule | Arrow key press overrides hover. | Mouse movement overrides keyboard focus. |
| Persistence through focus loss | Focus visual preserved; input cleared. | Hover visual preserved; input cleared. |

### 16.4 Cross-state rules

- Only one card may be in pressed/selected state at a time.
- Only one card may have keyboard focus at a time. Only one card may have mouse hover at a time.
- During pressed and selected states, all input is blocked system-wide (not just per-card). A `_card_input_guarded` flag governs this.
- The 1/2/3 number keys act as direct-select (same as Enter/Space on the corresponding card) and bypass the focus state entirely.
- Cards 1/2/3 correspond to left/center/right positions respectively.

## 17. Card Visual Feedback Specification

### 17.1 Color tokens (directional, not frozen)

All colors are `team_proposal` candidate values. Exact final values are `unresolved` pending Director/Technical Art review and Anchor v0.1 coherence check.

| Token | RGBA | Usage |
|---|---|---|
| `card_bg_default` | Color(0.08, 0.08, 0.10, 0.85) | Card background at idle |
| `card_bg_hover` | Color(0.12, 0.12, 0.16, 0.90) | Card background on hover |
| `card_bg_pressed` | Color(0.04, 0.04, 0.06, 0.95) | Card background on pressed |
| `card_bg_acquired` | Color(0.10, 0.15, 0.22, 0.90) | Card background when selected/acquired |
| `card_bg_dimmed` | Color(0.04, 0.04, 0.06, 0.70) | Sibling card background when dimmed |
| `card_border_default` | Color(0.30, 0.30, 0.35) | Muted resting border |
| `card_border_hover` | Color(0.50, 0.50, 0.60) | Brightened hover border |
| `card_border_focus` | Color(0.55, 0.75, 0.95) | Keyboard focus accent border |
| `card_border_pressed` | Color(0.65, 0.85, 1.0) | Pressed accent border |
| `card_border_acquired` | Color(0.70, 0.90, 1.0) | Bright accent for acquired card |
| `card_border_dimmed` | Color(0.15, 0.15, 0.20) | Faded sibling border |
| `hint_color_muted` | (directional, `unresolved`) | Subordinate info text (XP, etc.) |

### 17.2 Non-color feedback matrix

Per decision #19 and UX-13: every state transition must be distinguishable without relying on color alone.

| Transition | Non-color signal 1 | Non-color signal 2 | Non-color signal 3 |
|---|---|---|---|
| idle -> hover | Scale: 1.0 -> 1.03 | Border width: 1px -> 1.5px | Cursor: default -> pointing hand |
| hover -> focus | Border style: solid -> dashed | Cursor: pointing hand -> default | (border color change is supplemental, not primary) |
| idle/hover -> pressed | Scale: 1.0/1.03 -> 0.97 | Border width: 1px/1.5px -> 2px | Text weight: normal -> bold |
| pressed -> selected (acquired) | Text suffix: "+ 获得" appended | Border style: any -> solid | Scale: 0.97 -> 1.0 (spring back) |
| any -> dimmed (sibling) | Alpha reduction on entire card | Scale: -> 0.95 | Text opacity: muted |
| transition_out | Position tween (Y + 40px) | Opacity: 1.0 -> 0.0 | Scale: maintained (no change during dismiss) |

### 17.3 Transition timing budget

| Phase | Duration | Easing | Interruptible? |
|---|---|---|---|
| Cards appear (transition_in) | ~200ms | ease-out (expo) | No |
| Hover enter/exit | ~100ms | ease-out | Yes (fast hover) |
| Pressed flash | ~100ms | ease-in | No |
| Acquired feedback display | ~600ms | flat hold | No |
| Cards dismiss (transition_out) | ~200ms | ease-in (expo) | No |
| **Total non-interactive** | **~1100ms** | | From press to combat resume |

All timings are candidate values subject to implementation tuning. No animation may produce sustained high-frequency flashing or obscure player/danger/space.

### 17.4 Acquired feedback text

- Card title line: `[N] 穿透 I` -> `[N] 穿透 I -- 获得`
- Prompt line: `"B2 upgrade selection -- ..."` -> `"穿透 已获得"` or `"扇裂 已获得"`
- The "获得" suffix is the primary non-color confirmation signal.

## 18. Text, Layout, and Accessibility Specifications

### 18.1 Text hierarchy and sizing

| Text element | Role | Proposed size | Weight | Alignment | Notes |
|---|---|---|---|---|---|
| **Card Tier 1 (keyword)** | Card title (e.g., "穿透 I") | 18px | Bold | Left-aligned, top of card | Largest text on card; immediate recognition |
| **Card Tier 2 (difference)** | One clear difference dimension | 14px | Regular | Left-aligned, middle of card | Key decision signal |
| **Card Tier 3 (effect)** | Mechanical effect description | 12px | Regular (muted) | Left-aligned, bottom of card | Supporting detail; lowest priority |
| **Card keyboard hint** | "[1]" / "[2]" / "[3]" number prefix | 18px (same as Tier 1) | Regular | Precedes keyword text | Always visible; keyboard shortcut indicator |
| **HUD L1 life** | Segment indicator | `unresolved` | `unresolved` | Top-left | Non-color: filled/empty/dashed per segment |
| **HUD L1 timer** | Run timer display | `unresolved` | `unresolved` | Top-left, adjacent to life | |
| **HUD L2 phase** | B2 phase label | `unresolved` | `unresolved` | Below L1 | Current keyword phase |
| **HUD L3 subordinate** | XP/fragments, secondary stats | Muted size | Light weight | Below L2 | Visually subordinate; muted color |
| **Prompt text** | Card selection instruction | 13px | Regular | Centered below cards | Fades in/out with cards |
| **Result text** | Victory/defeat/result label | `unresolved` | Bold | `unresolved` | Terminal state priority; non-color distinction |
| **Hint text** | Causal movement hint | `unresolved` | `unresolved` | `unresolved` | Transient; appears once per run |

### 18.2 Layout zones (640x360 baseline)

```
+----------------------------------------------------------+
|  [L1: LIFE + TIMER]                      16:9 baseline   |
|  [L2: B2 PHASE]                                        |
|  [L3: XP/subordinate]                                  |
|                                                            |
|                  [GAMEPLAY ZONE]                          |
|              (player, enemies, attacks,                  |
|               attacks, danger, space)                    |
|                  player center ~(320, 180)                |
|                                                            |
|    +----------+    +----------+    +----------+           |
|    |  Card 1  |    |  Card 2  |    |  Card 3  |           |
|    |  [1] 穿透|    |  [2] 穿透|    |  [3] 穿透|           |
|    +----------+    +----------+    +----------+           |
|                  [prompt text]                             |
+----------------------------------------------------------+
```

**Zone definitions (640x360):**

| Zone | Bounds (approx.) | Purpose |
|---|---|---|
| HUD L1 (top-left) | (16, 12) to (180, 50) | Critical status: life + timer |
| HUD L2 | (16, 56) to (180, 80) | Phase indicator |
| HUD L3 | (16, 84) to (200, 120) | Subordinate info |
| Gameplay | Center and upper 60% | Player, enemies, attacks, danger, space |
| Card panel | Bottom-center. Cards at Y center ~270. Card bottom at Y=318. | Upgrade selection (only during upgrade pause) |
| Prompt | Below cards, Y ~332, centered | Card selection instruction |
| Hint (transient) | `unresolved` | Causal movement hint (L4, transient) |

### 18.3 Card layout measurements (640x360 baseline)

| Property | Value | Rationale |
|---|---|---|
| Card width | 160px | 3 cards + 2 gaps fit within 640px with safe margins |
| Card height | 96px | Accommodates 3 text lines + padding |
| Card gap | 20px | Clear separation; 3x160 + 2x20 = 520px total |
| Card vertical center Y | 270px | Lower 35% of screen; does not overlap HUD or player |
| Card corner radius | 4px | Restrained industrial feel per Anchor |
| Card internal padding | 12px horizontal, 10px vertical | |
| Card bottom edge | Y = 318 | 42px margin to viewport bottom |

### 18.4 Spatial occlusion safety rules

- **First read (combat):** player silhouette, nearest danger, enemy tide, clear/movable space. Never occluded by HUD or card panel.
- **Second read:** attack result, hit/kill feedback, changed route. Never occluded.
- **Third read:** persistent HUD (L1/L2). Never occluded by card panel.
- **Fourth read:** subordinate info (L3), transient hint (L4). May be temporarily occluded by card panel during upgrade, but card panel only appears during full combat pause.
- Card panel zone is bottom-center, Y range ~222-318. Player (Y~180) and typical enemy positions are in the upper 60%. **No overlap** between card zone and gameplay zone.

### 18.5 Accessibility specification

| Requirement | Direction | Status | Notes |
|---|---|---|---|
| **Non-color communication** | Every state transition uses at least 2 non-color signals (scale, border width, border style, text suffix, alpha, cursor) | `team_proposal` (see §17.2) | Decision #19; validated against UX-13 |
| **Keyboard-only full path** | 1/2/3 direct selection + arrow keys + Enter/Space confirm. Full parity with mouse. | `team_proposal` (see §16) | No gamepad promise (decision #2) |
| **Mouse-only full path** | Hover to inspect, click to confirm. Full parity with keyboard. | `team_proposal` (see §16) | |
| **Focus visibility** | Keyboard focus uses dashed border; visually distinct from hover (solid border) | `team_proposal` (see §16.3) | Must be tested across supported aspects |
| **Text readability** | Minimum 12px for smallest text; sufficient contrast against dark backgrounds | `team_proposal` | Exact contrast ratio `unresolved` (future CR) |
| **No rapid flashing** | All transitions >= 80ms; no blinking, strobing, or sustained high-frequency flashing | `team_proposal` | Per decision #19 |
| **Stale input rejection** | Input guarded during transition phases; held keys do not repeat-select | `team_proposal` (see §15) | |
| **Focus-loss safety** | Freeze, buffer, input clear, fresh epoch per §15 protocol | `team_proposal` (see §15) | UX-06/07/08 evidence targets |
| **Safe area / scaling** | fit + letterbox gaps + UI relative scaling per DC-PLAT-02 Option 2; no stretch, no crop | `user_confirmed (direction)` | `1280x720` minimum resolution remains candidate only |
| **Responsive layout** | HUD anchored to corners; cards centered; text fixed pixel size; no dynamic text scaling | `team_proposal` | Exact scaling tiers `unresolved` |
| **Reduced motion** | Not yet specified. All transitions are short (<600ms) and purposeful. Reduced-motion policy is `unresolved`. | `unresolved` | Future CR if needed |
| **Minimum target size** | Card interaction targets are 160x96px (well above typical minimums). HUD click targets are not yet defined. | `team_proposal` | Exact minimum target size threshold `unresolved` |

### 18.6 Gate 3 evidence requirements for visual/UI readiness

| ID | Evidence target | Evidence class | Required fields |
|---|---|---|---|
| UX-09 | HUD life/timer/B2 persistent; XP subordinate; no occlusion at named aspects {16:9, 16:10, 21:9} | visual QA + runtime | aspect/resolution, state, screenshot/frame, observer, verdict |
| UX-10 | Victory/defeat non-color-distinct, short, restart | runtime + visual QA + QA | terminal trigger, result frames, timing, reset identity, observer |
| UX-12 | Common widescreen readability and safe-area behavior | visual QA + QA | named aspect/resolution, build/config, frames, clipping/overlap notes |
| UX-13 | Accessibility: focus, text/cards, non-color states, restrained motion | visual QA + QA | target settings, state coverage, frame refs, checklist, verdict |

---

## 19. Fresh UX/UI expert revalidation record — static handoff

- **Role expert:** `godot-ux-ui-expert` — loaded successfully before project/design content was read; this record is authored by the newly assigned direct UX/UI member.
- **Expert preflight:** target player/context, critical journey, comprehension risks, 16:9/common-widescreen and keyboard/mouse conditions, in-scope states, evidence route, ownership boundary, and static-only stop condition are recorded in §1.2 and remain valid.
- **Static revalidation:** §§3–9 retain the complete journey and state coverage: entry → combat → no-target → upgrade pause 1 (`穿透`) → upgrade pause 2 (`扇裂`) → focus-loss combat/card selection → resume with fresh epoch and stale Enter/Space rejection → victory/defeat/result/restart. Focus-loss freeze, preserved selection, and unresolved implementation semantics remain explicit.
- **Contract checks revalidated:** upgrade card interaction; HUD life/timer/B2 and XP subordination; player/danger/space and clearing hierarchy; causal movement hint; 16:9/widescreen, keyboard, non-color feedback, focus visibility, safe area/scaling/accessibility directions with thresholds unresolved; UX-01..UX-13 evidence/retest matrix; Anchor v0.1 static baseline versus v0.2 unaccepted candidate; Tech/Systems/Director/Producer/Independent QA dependencies; Change Request triggers; and preservation of 22, 8, PRECHARTER-01..11, four provenance layers, and unresolved items.
- **Evidence and authority boundary:** this is static/source revalidation only. No runtime, visual QA, usability, accessibility, performance, export, release, or acceptance evidence is claimed. User remains product authority; Producer governs readiness; Tech/Systems/Director/Independent QA retain their separate authorities.
- **Result:** no substantive contract correction was required; only this concise fresh-member revalidation record was appended. Kickoff/readiness and acceptance remain `UNAPPROVED / NOT_READY`.
- **Closure-ready:** `yes` for this static revalidation only; not a kickoff-ready or acceptance-ready verdict.
