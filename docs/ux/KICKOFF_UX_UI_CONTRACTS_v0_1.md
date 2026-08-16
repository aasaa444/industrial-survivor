# KICKOFF UX/UI CONTRACTS v0.1

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`
>
> **Contract type:** static UX/UI proposal for future review. It is not implementation authorization, a runtime result, visual QA, usability result, accessibility conformance result, or release acceptance.

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
- **Closure-ready:** `yes` for this static UX/UI contract assignment; not a kickoff or acceptance-ready verdict.
- **Next handoff:** Producer may include this package in kickoff-readiness review. Tech, Systems, Director, and Independent QA must review their respective dependencies before any future implementation gate.

## 14. Fresh UX/UI expert revalidation record — static handoff

- **Role expert:** `godot-ux-ui-expert` — loaded successfully before project/design content was read; this record is authored by the newly assigned direct UX/UI member.
- **Expert preflight:** target player/context, critical journey, comprehension risks, 16:9/common-widescreen and keyboard/mouse conditions, in-scope states, evidence route, ownership boundary, and static-only stop condition are recorded in §1.2 and remain valid.
- **Static revalidation:** §§3–9 retain the complete journey and state coverage: entry → combat → no-target → upgrade pause 1 (`穿透`) → upgrade pause 2 (`扇裂`) → focus-loss combat/card selection → resume with fresh epoch and stale Enter/Space rejection → victory/defeat/result/restart. Focus-loss freeze, preserved selection, and unresolved implementation semantics remain explicit.
- **Contract checks revalidated:** upgrade card interaction; HUD life/timer/B2 and XP subordination; player/danger/space and clearing hierarchy; causal movement hint; 16:9/widescreen, keyboard, non-color feedback, focus visibility, safe area/scaling/accessibility directions with thresholds unresolved; UX-01..UX-13 evidence/retest matrix; Anchor v0.1 static baseline versus v0.2 unaccepted candidate; Tech/Systems/Director/Producer/Independent QA dependencies; Change Request triggers; and preservation of 22, 8, PRECHARTER-01..11, four provenance layers, and unresolved items.
- **Evidence and authority boundary:** this is static/source revalidation only. No runtime, visual QA, usability, accessibility, performance, export, release, or acceptance evidence is claimed. User remains product authority; Producer governs readiness; Tech/Systems/Director/Independent QA retain their separate authorities.
- **Result:** no substantive contract correction was required; only this concise fresh-member revalidation record was appended. Kickoff/readiness and acceptance remain `UNAPPROVED / NOT_READY`.
- **Closure-ready:** `yes` for this static revalidation only; not a kickoff-ready or acceptance-ready verdict.
