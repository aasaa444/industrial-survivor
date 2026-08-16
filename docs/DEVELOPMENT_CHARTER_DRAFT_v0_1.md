# DEVELOPMENT CHARTER v0.1 — canonical authorization record (historical revision-02 inputs retained)

> **AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY**  
> **Lifecycle: `development governance / kickoff readiness preparation`**  
> This authorization does **not** authorize immediate implementation, Godot access or mutation, build, runtime, test, QA execution or acceptance, performance measurement or acceptance, export, release, or any kickoff execution before the readiness gate.

## 1. Metadata

| Field | Value |
|---|---|
| Named version | `Development Charter v0.1` (historical inputs: `v0.1-revision-02`) |
| Status | `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY` |
| Lifecycle | `development governance / kickoff readiness preparation` |
| Product authority / owner | `User` |
| Execution authority | `Executive Producer / Lead Producer` |
| Recording role | `Executive Producer / Lead Producer` |
| Authorization source | `current user response / explicit clickable authorization of Development Charter v0.1` |
| Approval state | `Development Charter v0.1 authorized for governance only; kickoff readiness not yet satisfied` |
| Working mode | `development governance / kickoff readiness preparation; implementation not started` |
| Source set | `docs/creative/GDD_SLICE_v0_1.md`; `docs/creative/SLICE_RULES_DECISION_v0_1.md`; `docs/creative/CREATIVE_BRIEF_v0_1.md`; `docs/DISCOVERY_HANDOFF.md`; `docs/visual/anchor/ANCHOR_DECISION.md`; `docs/creative/SLICE_PRECHARTER_DECISIONS_v0_1.md` |

All source claims below retain provenance. Team suggestions are not product decisions. No silence is treated as consent.

## 2. Authorization record and firewall

### 2.0 Authorization Record

- **Authorized artifact:** `Development Charter v0.1`
- **Authorization source:** `current user response / explicit clickable authorization of Development Charter v0.1`
- **Authorization meaning:** the User authorized this named, versioned Charter to become effective for **development governance and kickoff readiness preparation only**.
- **Status transition:** historical draft state `DRAFT / UNAPPROVED / NOT IN EFFECT` → current canonical state `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY`.
- **Lifecycle transition:** historical `preproduction` → current `development governance / kickoff readiness preparation`.
- **Actual start evidence:** this current user authorization and this Producer record update; no implementation member start is claimed.
- **Approval authority:** User remains product authority and final decision-maker. Executive Producer / Lead Producer owns execution governance within this Charter; Game Director, Tech Lead, and Independent QA/Release retain their separate authorities.

### 2.1 Scope of authorization

This authorization permits the Producer to maintain the Charter, establish governance boundaries, organize a static kickoff-readiness checklist, intake Change Requests, and prepare evidence/gate ownership. It does **not** expand product scope, promise, platform, architecture, thresholds, or release commitments. It does not convert candidate inputs, candidate budgets, candidate platform direction, unresolved algorithms, or team proposals into approved facts.

### 2.2 Non-authorizations and firewall

This Charter authorization does **not** authorize immediate implementation; Godot/GDMCP access or mutation; code, scenes, resources or assets; construction/build; running; tests; QA execution or acceptance; performance measurement or acceptance; export; release; staffing kickoff execution; milestone commitment; cost or calendar commitment; or dispatch/start of implementation members. Formal implementation remains blocked until kickoff readiness is satisfied and the relevant role conditions are met. No runtime, visual, performance, export, or QA evidence exists.

### 2.3 Rollback / reauthorization rule

The Producer may pause governance preparation for missing evidence, scope drift, unsafe readiness, or authority conflict. Any change to the player promise, immutable Charter decision, major scope, platform, architecture risk, acceptance threshold, or release commitment requires a Change Request and returns to the User for product decision or Charter reauthorization. Authorization cannot be inferred from silence; implementation cannot begin on this record alone.

The existing GDD is a `user-authorized design baseline`; it is not this Charter and does not activate it. The current conclusion is `not_ready_for_kickoff`.

### 2.1 Charter pre-authorization decision packet response — `v0.1-revision-02`

- **Record source/date:** `this decision packet / current user response`; no calendar date is inferred.
- **Provenance:** every item below is `user_confirmed` from this decision packet; no team proposal, assumption, or silence is promoted.
- **Historical packet status at capture:** `candidate Charter input / not effective`; this line records the pre-authorization state and is retained for provenance. The current document status is governed by the Authorization Record above.
- **Layering rule:** this packet is a new incremental response layer. Earlier records, proposals, assumptions, and unresolved fields remain traceable and are not rewritten or reclassified.

| Packet item | Recorded user-confirmed candidate input | Boundary retained |
|---|---|---|
| 1 | Existing player promise, experience pillars, Slice cap, and exclusions load into the Charter as `candidate immutable`. | Candidate boundary retained; current Charter authorization does not expand or reinterpret it. |
| 2 | `rules core + session + adapter/presentation` is a candidate architecture boundary. | Candidate only; Tech Lead must author a future ADR before formal confirmation. |
| 3 | Fixed tick/seed/snapshot/trace is promised only for QA/debug reproducibility. | No player-visible Replay promise; exact contract remains unresolved. |
| 4 | Before firing, refresh the nearest-threat cluster; stable-sort and lock that shot's target snapshot. | Exact cluster, distance, tie-break, ID lifecycle, and timing remain unresolved. |
| 5 | Retain high-level safety/terminal boundaries: no-target branch, contact safety, upgrade pause, focus-loss recovery, life depletion priority, and short result followed by automatic restart. | Exact timing, ordering, and mechanisms remain unresolved. |
| 6 | Make core playability observation a formal gate before scope expansion: movement causality, wave reduction/corridor recovery, `穿透 → 扇裂` comprehension, and immediate retry after failure. | Evidence must be observed; subjective fun and static documents cannot pass it. Current status `not_run/not_ready`. |
| 7 | Retain `1080p/60`, `50 FPS minimum`, input `≤50ms`, hit feedback `≤100ms`, cold start `<3s`, and restart `<1s` as candidate budgets. | Not hard gates, not observed results, and not release commitments. |
| 8 | Retain PC-first, keyboard input, 16:9 baseline, common widescreen, and basic accessibility direction. | No named OS, minimum resolution, export target, or release platform is selected. |

These eight packet inputs are the only newly written `user_confirmed` content in this revision. They do not close unresolved details and do not alter the four provenance layers.

## 3. Kickoff readiness governance checklist

The following are **readiness prerequisites / proposals**, not completed work. Every item is currently `pending / not_run / not_ready`; no kickoff execution or implementation start is claimed.

| Readiness owner | Static prerequisite / decision surface | Current status | Required evidence before kickoff gate |
|---|---|---|---|
| Executive Producer / Lead Producer | Charter integrity, scope caps/exclusions, provenance preservation, authority/RACI, Change Request intake and escalation path | `pending / not_ready` | Version/status audit, scope and provenance trace, CR template and decision-routing record |
| Tech Lead | ADR package for candidate rules/session/adapter seam; rules/session contract; determinism tick/seed/snapshot/trace seam; target/reset contracts | `pending / not_run / not_ready` | Authored ADRs and contracts with unresolved fields, ownership, compatibility, stop conditions, and review status |
| Systems / Balance | Experiment ledger for ranges, starting points, assumptions, dependencies, signals, promotion authority, and rollback rules | `pending / not_run / not_ready` | Ledger proposal; no candidate value promoted to a constant without authority and evidence |
| UX/UI | Interaction and accessibility contract: HUD hierarchy, causal hint, card focus/confirmation, focus-loss recovery, 16:9/widescreen and non-color accessibility | `pending / not_run / not_ready` | Reviewable interaction/accessibility contract with unresolved copy/layout/thresholds explicit |
| Game Director / Creative Director | Creative coherence against player promise, pillars, Slice intent, Anchor v0.1 boundary, and non-goals | `pending / not_run / not_ready` | Independent creative review plan and later evidence criteria; no creative acceptance claimed |
| Independent QA / Release Lead | Gate 0 preflight, evidence schema/index, observer independence, pass/block authority for Gates 0–6 | `pending / not_run / not_ready` | QA preflight checklist, evidence-field schema, blocker rules, and explicit independent pass/block route |

### Gate readiness status

- **Gate 0 — Charter readiness:** `not_run / not_ready`; authorization is recorded, but preflight and readiness prerequisites are incomplete.
- **Gate 1 — Static conformance:** `not_run / not_ready`.
- **Gate 2 — Deterministic/runtime:** `not_run / not_ready`.
- **Gate 3 — Visual/UI:** `not_run / not_ready`.
- **Gate 4 — Performance:** `not_run / not_ready`.
- **Gate 5 — Export smoke:** `not_run / not_ready`.
- **Gate 6 — Independent release review:** `not_run / not_ready`.

Independent QA/Release retains the final pass/block authority for every applicable gate. The Producer assembles evidence and may stop unauthorized or unready work; the Producer cannot waive an Independent QA/Release blocker.

## 4. Purpose, player promise, pillars, and slice intent

### 3.0 Current effective provenance precedence

For current Charter-draft interpretation, precedence is: **(1)** `SLICE_RULES_DECISION_v0_1.md §13` and **(2)** `SLICE_PRECHARTER_DECISIONS_v0_1.md PRECHARTER-01..11` for their explicitly covered current increments; then the six permitted sources' unchanged historical text for traceability. A later increment narrows or supersedes an earlier `unresolved` state only within its recorded scope; it does not rewrite history. Discovery and older Creative Brief unresolved entries are historical snapshots unless a later user-confirmed record explicitly covers the same field. No team proposal, assumption, static anchor, or silence is promoted to a user decision.

### 3.0.1 Decision-status legend

- **`user_confirmed`** — explicit owner input, retained as a candidate Charter constraint; it becomes effective only after separate authorization of a named, versioned Charter.
- **`Director interpretation`** — creative organization of confirmed intent; not a product decision and not creative acceptance.
- **`team_proposal`** — specialist recommendation for later review; never silently promoted.
- **`assumption`** — expectation requiring observation.
- **`unresolved`** — intentionally open detail or threshold; silence does not resolve it.

### 3.0.2 Promise and slice provenance

| Item | Current wording | Provenance/status |
|---|---|---|
| Player promise | Simple movement plus automatic attacks produce readable, weighty clear-screen control and cathartic relief. | `user_confirmed` direction; `Director interpretation` wording; candidate constraint only |
| Experience pillars | Clear-screen dominance; active control while moving; same-source power step; non-punitive rhythm; low-cognition choice. | `Director interpretation` of confirmed direction; not user acceptance of implementation |
| Slice intent | One same-source B2 journey in one bounded eight-minute slice, exposing movement-to-next-attack causality, clearing, `穿透 → 扇裂`, and control completion. | `user_confirmed` scope inputs plus `Director interpretation`; candidate constraint |
| O2 | Long-term out-of-run direction remains upstream context only. | `user_confirmed` upstream direction; explicitly excluded from this Slice |
| Historical Discovery/Brief unresolved items | Retained as historical snapshots. | `unresolved` historically; do not override later current records |

### 3.0.3 Slice identity

This Slice is **one same-source B2 journey** with two guaranteed pause upgrades: first `穿透`, then `扇裂`. It is not two independent B2s and is not a content showcase. O2 is an upstream long-term direction and is excluded from this Slice. Discovery and older Brief unresolved entries remain historical snapshots, not current authorization.

### Purpose

Provide the user with a bounded, provenance-aware execution envelope for review: scope, authority, dependencies, evidence gates, risks, and decisions required before any formal development. The proposal is intended to make the riskiest proof observable early without converting team proposals into commitments.

### Player promise (Director input, source-traceable)

With simple, direct movement and automatic attacks, the player cuts through an enemy wave and experiences increasingly exaggerated but readable clear-screen victories with weighty feedback, repeatable catharsis, and no punitive intent. The intended causal read is:

`pressure → readable hit → enemy-wave reduction / recovered space → same-source power step → control at eight minutes`.

This wording is adopted from the Creative Brief/GDD and Director input as creative provenance, not as evidence of an implemented or accepted experience.

### Experience pillars (Director-owned interpretation)

1. **Clear-screen dominance:** spatially readable enemy removal and recovered movement space, not counters or spectacle alone.
2. **Active control while moving:** movement preserves routes and affects the next automatic attack.
3. **Visible same-source power step:** fixed `穿透 → 扇裂`, with the attack identity becoming broader without becoming unreadable.
4. **Cathartic, non-punitive rhythm:** pressure resolves into recovery; failure is light and immediately retryable.
5. **Low-cognition choice:** two guaranteed, paused choices with same-keyword alternatives and one clear difference dimension.

### Slice intent

PC-first Demo / Vertical Slice; single-player, one ordinary enemy family, one automatic-attack family, one bounded industrial screen, one B2 combination, one eight-minute run, minimum HUD, and one short causal movement hint. The slice is meant to expose movement-to-next-attack causality, readable hit/kill hierarchy, spatial clearing, `穿透 → 扇裂`, and control completion. It is not a content showcase or a complete meta game.

## 4. Governance and authority (RACI-like)

| Role | Owns / accountable for | Recommends or executes | Can block | Must return to User |
|---|---|---|---|---|
| **User** | Product promise, final scope, platform, immutable product choices, Charter authorization, final product decisions | Selects among decision packages | May stop or refuse any gate | All product-level, threshold-crossing, reserved decisions |
| **Executive Producer / Lead Producer** | Mode, sequencing, dependencies, WIP, scope protection, Change Requests, milestone readiness, single front door | Assembles plan and escalation package; never self-accepts | Unauthorized work, scope drift, missing evidence, unsafe readiness | Promise/scope/platform/architecture-risk/release/Charter crossings |
| **Game Director / Creative Director** | Creative coherence, player promise, pillars, slice intent, visual hierarchy and creative review | Creative recommendations and evidence interpretation | Creative incoherence at review | Product direction, major promise/pillar/baseline changes |
| **Tech Lead** | Technical architecture, ADRs, engineering quality, measurement design and technical risk | Technical options and constraints | Technical safety/quality concerns within authority | Architecture risk crossing product/scope/platform or unresolved product conflict |
| **Systems / Balance** | Rules proposals, tuning ranges, experiments, balance evidence | Numbers, curves, simulations after authorization | Balance evidence may flag a gate risk, not grant acceptance | Product rule, scope, or threshold changes |
| **UX/UI** | Interaction, information hierarchy, focus safety, accessibility proposal | Copy/layout/interaction specifications and review evidence | May flag usability/accessibility risk | New product interaction, platform or scope commitment |
| **Gameplay Engineer (future)** | Authorized implementation and implementation evidence | Builds only after Charter/kickoff and technical contract | Reports technical blockers; cannot approve own work | Changes beyond authorized envelope |
| **Independent QA / Release** | Independent acceptance, release gates, evidence audit | Defines/runs acceptance after authorization | Owns blocking verdict; implementer cannot self-certify | Product-level acceptance reserved by Charter |

Operating values: `product_authority=user`; `execution_authority=executive_producer`; `creative_authority=game_director`; `technical_authority=tech_lead`; `acceptance_authority=independent_qa_release`; `communication_front_door=executive_producer`; `user_intervention=milestone_or_escalation_only` once—and only once—a Charter is authorized.

## 5. Scope baseline and change control

### In scope (authorized governance envelope; implementation remains gated)

- PC-first Demo / Vertical Slice; 16:9 baseline and common widescreen readability.
- One player; only movement via WASD + arrow keys; no gamepad promise, dash, or dodge.
- One ordinary rusted humanoid enemy family and one automatic directional energy-arc family.
- Fixed oblique top-down camera; one bounded, single-screen industrial arena.
- Pre-fire refresh of the nearest-threat cluster; post-fire fixed target set; no-target attack cycle; stable candidate ordering, with exact algorithm unresolved.
- One-contact damage event, brief invulnerability, slight separation, no repeated damage during invulnerability, re-contact only after separation; three life segments.
- Two guaranteed full pauses: three same-keyword cards, choose one, fixed `穿透 → 扇裂`; feedback before resume; no skip/reroll.
- Fan split retains the center arc and adds left/right arcs; three arcs inherit piercing and count independently.
- In-run XP/fragments only as the two-upgrade intermediary; no out-of-run loss or progression.
- Three pressure reads—entering pressure, sustained surround, route compression—while preserving a recoverable route; short victory/defeat result then immediate restart.
- HUD: life, timer, B2 phase; minimized XP; one extremely short causal movement hint; keyword title plus one clear difference dimension on cards.
- Immediate focus-loss freeze for combat and upgrade confirmation, preserving focus/selection and requiring fresh explicit input on return; stale Enter/Space must not confirm.

### Strict caps

One player; one ordinary enemy family; one attack family; one B2; one single-screen industrial arena; eight minutes; minimum HUD; one hint. No silent addition of content, systems, assets, modes, platforms, or polish beyond these caps.

### Out of scope

Bosses, elites, second arena, second enemy or weapon family, dash/dodge, gamepad promise, O2/meta progression, shop, currency, multiplayer, complete narrative, complete menus, complex tutorial, full UI, long-term collection, persistent luminous field as a substitute for clearing, and any feature not explicitly promoted through an approved Change Request.

### Change Request triggers

Every new feature, direction, platform, architecture, scope, schedule, cost, release commitment, or acceptance-threshold change enters a Change Request. It must state motivation, provenance, alternatives, displaced work, dependencies, risk, evidence impact, owner, and decision authority. Changes crossing promise, immutable Charter decisions, major scope, platform, architecture risk, or release commitment return to the User. Silence never expands scope.

## 6. Product and technical candidate constraints

### Four provenance layers

- **`user_confirmed / candidate charter constraint`:** a user choice recorded in the GDD/rules/pre-Charter records; retained within this authorized Charter as a candidate constraint, without promoting unresolved details or authorizing implementation.
- **`team_proposal`:** Director, Tech, Systems, UX, or QA recommendation; useful for planning, never silently promoted.
- **`assumption`:** expectation requiring observation (for example, deterministic combat and constrained randomness will remain readable).
- **`unresolved`:** exact values, algorithms, thresholds, copy, layout, hardware, and acceptance details still open.

### User-confirmed baseline and 22 decisions

The following 22 items are retained exactly as candidate Charter constraints, with their unresolved boundaries. **None takes effect until a versioned Charter is separately authorized.**

1. Only movement; no dash/dodge.
2. WASD + arrow keys; no gamepad promise.
3. Refresh nearest-threat cluster before each shot; fix this shot's targets after firing.
4. One contact damage event and slight brief separation.
5. Brief clear result, automatic immediate restart, no out-of-run loss.
6. Fixed piercing hit cap, light later-hit attenuation, independently counted arcs.
7. Three same-keyword variant cards form a bounded choice.
8. Full upgrade pause; selected feedback, then resume.
9. In-run XP/fragments only for the two upgrades; no currency/O2/persistence.
10. Pressure reads: entering pressure → sustained surround → route compression, with a recoverable route.
11. Victory reads as control completed and brief relief.
12. Defeat reads as light interruption and immediate retry.
13. Fixed structure and key journey; constrained light randomness only.
14. HUD shows `穿透 → 扇裂` phase keywords.
15. Extremely short functional movement hint.
16. Hint appears on entry, fades after first effective movement, once per run.
17. Three equal horizontal cards; mouse click or directional focus; Enter/Space confirm; no skip/reroll.
18. 16:9 baseline, common widescreen, minimum readability red line.
19. Basic accessibility baseline: do not rely on color alone; visible focus and restrained flashing.
20. Strict Slice cap and exclusions listed above.
21. PC-first performance direction with numeric budgets remaining candidates until Tech/Systems proposal and User confirmation.
22. User authorized GDD v0.1; the separately authorized `Development Charter v0.1` now governs development governance only, with implementation still gated.

### Anchor baseline clause

`ANCHOR_DECISION.md` v0.1 is the **user-accepted static preproduction baseline**. v0.2 is an **unaccepted candidate** and cannot automatically replace v0.1. The Anchor proves neither runtime behavior, QA, final art, nor release readiness; it is not a waiver or acceptance gate. Any replacement requires a separate user decision.

### PRECHARTER-01..11 (all `user_confirmed`, still candidate constraints)

- **PRECHARTER-01:** fixed tick + seed + snapshots; constrained light randomness. Exact tick, seed ownership, snapshot schema/cadence, random sources and replay equivalence are unresolved.
- **PRECHARTER-02:** attack in no-target case; otherwise nearest threat, cluster-center distance, then stable ordering/stable ID. Cluster definition, metric, tie-break fields, ID lifecycle and timing are unresolved.
- **PRECHARTER-03:** one legal contact event; brief invulnerability; slight separation; no repeat during invulnerability; re-contact only after separation. Timings, distance, damage, stacking and boundaries are unresolved.
- **PRECHARTER-04:** use ranges plus experimental starting points; do not lock unverified constants. Sampling, promotion authority and thresholds are unresolved.
- **PRECHARTER-05:** candidate upgrade windows about 2–3 minutes and 4.5–6 minutes; fixed `穿透 → 扇裂`. Exact trigger, XP, measurement and recovery are unresolved.
- **PRECHARTER-06:** persistent HUD life + timer + B2 phase; minimize XP. Layout, copy, minimum resolution and safe areas are unresolved.
- **PRECHARTER-07:** extremely short causal hint that movement affects the next attack; copy and timing unresolved.
- **PRECHARTER-08:** keyword title plus one clear difference dimension; variants, values, copy and pool unresolved.
- **PRECHARTER-09:** focus loss immediately freezes combat and upgrade confirmation; preserve focus/selection; fresh explicit input on return; reject stale Enter/Space. Event/buffer semantics unresolved.
- **PRECHARTER-10:** 1080p/60 target; 50 FPS minimum candidate; input ≤50ms, hit feedback start ≤100ms, cold start <3s, restart <1s are candidate budgets only, not results or hard gates.
- **PRECHARTER-11:** same-frame life depletion takes priority over eight-minute victory. Exact event ordering and cleanup are unresolved.

### v0.1-revision-02 target, safety, reproducibility, and platform boundary

- **Reproducibility only:** fixed tick/seed/snapshot/trace is a QA/debug reproducibility commitment candidate. It does not promise a player-visible Replay feature; replay equivalence, trace schema, ownership, cadence, and exact tick remain `unresolved`.
- **Target candidate:** refresh the nearest-threat cluster before firing, stable-sort it, and lock the current shot's target snapshot. Cluster definition, distance metric, tie-break, stable-ID lifecycle, invalidation, no-target timing, and exact algorithm remain `unresolved`.
- **Safety/terminal candidate:** preserve explicit no-target handling, legal-contact safety, full upgrade pause, focus-loss recovery, life-depletion precedence, and short result then automatic restart. Exact ordering, timing, event/buffer semantics, cleanup, and mechanisms remain `unresolved`.
- **Platform boundary:** PC-first, keyboard input, 16:9 baseline, common widescreen, and basic accessibility remain candidate direction only. No OS, minimum resolution, export target, or release platform is named.

### Candidate architecture boundary (not approved)

`rules core + session + adapter/presentation` is recorded only as a `user_confirmed` candidate Charter input from `v0.1-revision-02`. It is not an approved architecture. The Tech Lead must author and review an ADR before any architecture confirmation; implementation remains unauthorized. Exact module interfaces, ownership, event boundaries, engine integration, persistence, and presentation responsibilities remain `unresolved`.

### Technical contract status table

| Contract | Status | Candidate boundary / unresolved authority |
|---|---|---|
| tick, seed, RNG, snapshot, stable ID, config version | `candidate / unresolved` | Tech Lead proposes ownership, compatibility and schema; exact tick, seed owner, RNG sources, snapshot cadence, ID lifecycle and config-version migration remain open |
| target snapshot | `candidate / ADR-required` | Refresh immediately before firing; deterministically sort; lock the shot's set; invalidate removed/invalid targets; explicit no-target branch; count each arc independently; future trace fields remain open |
| reset | `candidate / ADR-required` | Same-tick outcome arbitration, cleanup, input lock during result, stale-input rejection, RNG/ID reset and one canonical restart path are required; exact ordering and duration remain open |
| pure rules seam / headless comparison | `candidate / user-reserved` | Future deliverable may expose pure inputs/outputs, fixtures, snapshot/trace comparison; no implementation evidence exists and no seam is approved |
| cross-boundary changes | `unresolved / ADR-required` | Module, rule-layer, event-order, platform, or architecture-risk changes require ADR + Change Request; promise/major-risk crossings return to User |

### Canonical rules execution order (direction only)

`pre-fire target refresh → no-target branch / target snapshot lock → hit/contact/XP → timer/terminal arbitration → result/input lock → reset`

This order is a team proposal constrained by the user-confirmed target and same-frame boundaries; exact tick and same-frame semantics remain `unresolved`.

### Playability evidence gate candidate

Before any scope expansion, a future authorized review must observe movement-to-next-attack causality, enemy-wave reduction and corridor recovery, comprehension of `穿透 → 扇裂`, and immediate retry after failure. This is a formal future evidence gate candidate, currently `not_run/not_ready`; subjective fun, static prose, and the Anchor cannot pass it. Independent QA/Release retains pass/block authority.

### Performance candidate boundary

Retain `1080p/60`, `50 FPS minimum candidate`, input `≤50ms`, hit-feedback start `≤100ms`, cold start `<3s`, and restart `<1s` only as `team_proposal` candidate budgets under the user-confirmed performance direction. They are not observed results, hard gates, or release commitments. Future evidence must name hardware, build/config, sampling window, percentile/authority, and independent QA review.

## 7. Technical workstreams and ADR candidates (not approved)

These are sequencing candidates, not technical commitments or ADRs:

1. **Rules/state core:** pure rules/state model for movement, contact, attack cycle, upgrades, outcomes, reset; exact state/event schema unresolved.
2. **Session:** seed/tick ownership, run lifecycle, deterministic reset and replay/snapshot boundaries.
3. **Adapter:** future engine/input/render adapter; no Godot inspection or implementation occurred in this task.
4. **Target snapshot/attack:** pre-fire cluster refresh, stable ordering, target snapshot, no-target behavior, fixed post-fire target set.
5. **Progression data:** XP/fragments, two candidate windows, fixed upgrade order, card data and range-based tuning.
6. **UX/read model/visual feedback:** HUD, causal hint, focus-loss protection, card comparison, hit/kill/B2 hierarchy and spatial clearing.
7. **Reset contract:** victory/defeat precedence, same-frame life depletion, result duration, state/input cleanup, immediate restart.
8. **Performance measurement:** named hardware/settings, build identity, frame-time sampling, input and feedback timestamps, cold/restart boundaries; no numeric gate is active now.

Candidate ADR subjects include determinism/replay scope, targeting semantics, contact lockout, reset arbitration, progression contract, focus safety, and measurement protocol. **No ADR has been created or approved here.** Tech Lead owns technical ADR authorship; Producer sequences the gate; User decides architecture-risk crossings.

### Systems / rules contracts (proposal, not active)

- **No-target:** branch explicitly before lock; no fabricated target. Exact attack-cycle timing remains `unresolved`.
- **Contact legality / re-arm:** one legal contact event, brief invulnerability, slight separation, no repeat during invulnerability, and re-arm only after separation; timings, stacking, and boundary behavior remain `unresolved`.
- **B2:** one same-source journey: central arc first, then central + left + right arcs; all inherit the provisional piercing rule and maintain independent hit budgets/counters. Geometry, duplicate hits, target sharing, and attenuation remain `unresolved`.
- **Upgrade transaction:** guarantee trigger → complete pause → valid choice → acquired feedback → combat resume; focus loss, invalid input, reset interaction, and all values remain `unresolved`.
- **Range-and-experiment ledger:** every future tuning row must record `range`, `starting_point`, `assumption`, `dependency`, `signal`, `promotion_authority`, and `stop/rollback_rule`. A starting point is not balance evidence.

### UX/UI state and observability contract (proposal, not active)

| State | Affordance / input / feedback / next step |
|---|---|
| Entry/combat | Movement affordance and one short causal hint; WASD/arrows; readable player/danger/space; next step is movement and observe next attack |
| Upgrade 1/2 | Three same-keyword cards; hover/focus then valid input; pressed → selected/acquired feedback → combat resume |
| Focus loss / resume | Freeze combat and confirmation, preserve focus/selection, require first fresh legal input on return, discard stale Enter/Space; buffer/event epoch unresolved |
| Victory/defeat/restart | Non-color distinction, short clear result, shared automatic restart path; copy/duration unresolved |

HUD must keep life, timer, and B2 phase visible; XP remains subordinate. Player, danger, and movable space outrank HUD; exact layout/pixels are `unresolved`. Future QA separately covers 16:9, widescreen, and basic accessibility; thresholds remain open. The movement hint's future goal is to relate movement to the next automatic-attack result, not merely advertise controls.

## 8. Production plan proposal (governance sequencing only; no implementation authorization)

No dates, costs, durations, staffing promises, or work-start claims are made.

| Relative phase | Entry evidence | Proposed activity | Exit evidence / owner | Dependency / stop |
|---|---|---|---|---|
| Charter authorization record / readiness gate | User authorization of named `Development Charter v0.1` and six-source provenance | Producer maintains the canonical record and prepares readiness prerequisites; this row does not start implementation | Current authorization record plus completed readiness evidence, with Independent QA/Release pass/block | Must stop while Gate 0 is `not_run / not_ready`; no implementation before readiness |
| Pre-implementation contract / ADR gate | Authorized Charter; Director/Tech/QA boundaries recorded | Tech Lead authors ADR candidates; Systems/UX specify contracts | Approved contract package, open decisions and evidence fields / Tech + Producer; QA reviews acceptance plan | Stop on unresolved product or architecture crossing |
| Smallest deterministic core seam | Contract package and approved scope | Future authorized engineering implements only the minimum rules/session seam | Reproducible source/runtime evidence plus fixture identifiers / Engineer + Tech; independently reviewed QA | Stop on scope drift, nondeterminism, or missing trace |
| Runtime slice loop | Core evidence and approved adapter boundary | Future authorized integration of one loop, reset, target snapshot and progression | Observed runtime traces, seed/fixture, reset evidence / Engineer + Tech; QA not self-certified | Stop on player-promise break or inaccessible evidence |
| UX / visual integration | Runtime loop and Director/UX review inputs | HUD, hint, card focus, feedback hierarchy and anchor-informed presentation | Screenshots/observations across states/aspects; Director/UX review / QA remains independent | Stop if effects obscure player/danger/space or focus safety fails |
| Independent QA / performance / export gates | Integrated candidate with build ID and logs | QA Gate 0–6 evidence collection | Independent verdict package; blockers resolved or User accepts escalation | Any required P0/P1, hard-gate, audit, startup/export failure blocks |

The current phase is governance/kickoff-readiness preparation under the authorized named Charter. Readiness remains incomplete: no member has been dispatched to implementation, and no kickoff execution has occurred.

## 9. Risk, dependency, decision latency, and Change Request governance

| Risk / dependency | Owner | Retirement evidence | Escalate / block when |
|---|---|---|---|
| Target semantics and stable ties make movement causality unclear | Tech Lead + Systems | Deterministic no-target/tie/removal scenarios and QA observation | Algorithm changes product readability or cannot be reproduced |
| Reset and same-frame outcome ambiguity | Tech Lead + QA | Fixture showing life depletion beats victory and clean immediate restart | Results conflict, stale input or cleanup cannot be audited |
| Contact lockout becomes sticky or punitive | Systems + Tech | Overlap/separation/re-contact traces and QA | No recoverable spacing or repeated damage occurs |
| B2 spectacle replaces clearing / corridor | Director + UX | Before/impact/after runtime evidence and visual review | Player, danger, wave or recovered space is obscured |
| Focus loss confirms stale selection/input | UX + Tech | Focus-loss runtime scenarios and independent QA | Selection lost, confirmation occurs without fresh input |
| Peak three-arc performance | Tech Lead | Named hardware/settings, build, sample and QA review | Candidate budget fails, scope must expand, or evidence is absent |
| Candidate timing/values harden prematurely | Systems/Producer | Range experiment log and explicit promotion decision | Unverified value is treated as product constant |
| Evidence gap / unavailable build or trace | Producer + QA | Auditable fixture/seed/trace/log/screenshot/build package | Any acceptance claim lacks source and observer |

Dependencies are ordered: User Charter authorization → contract/ADR package → minimum seam → runtime loop → UX/visual integration → independent QA/performance/export. Decision latency is tracked by unresolved decision, decision owner, needed evidence, and next review window; no “waiting” item is interpreted as approval.

## 10. Acceptance and evidence plan

Current status: **`not_run / not_ready_for_acceptance`**. No runtime, performance, export, QA, or release result is claimed. Implementers cannot self-certify.

### Evidence classes

- **`static/source`:** six Markdown source records and this draft; proves provenance and text only.
- **`synthetic/anchor`:** `anchor_core_v0_1.png` plus `ANCHOR_DECISION.md`; static visual baseline only, not runtime.
- **`runtime`:** observed game behavior/input/state; absent.
- **`QA`:** independent observation and verdict; absent.
- **`visual QA`:** independent frame/state/readability inspection; absent.
- **`performance`:** measured frame/input/start/restart evidence; absent.
- **`export/release`:** actual export smoke and release review artifacts; absent.

### Provenance map with section / increment trace

| Core clause | Current source trace | Status |
|---|---|---|
| 22 baseline decisions | `SLICE_RULES_DECISION_v0_1.md §13.2`, echoed in `GDD_SLICE_v0_1.md §9.1` | `user_confirmed input / candidate constraint` |
| PRECHARTER-01..11 | `SLICE_PRECHARTER_DECISIONS_v0_1.md §3`, status summary §4 | `user_confirmed input / candidate constraint`; candidate numbers remain `team_proposal` |
| Player promise / pillars / slice truths | `CREATIVE_BRIEF_v0_1.md §§player promise, experience pillars, slice intent`; `GDD_SLICE_v0_1.md §§2–3` | confirmed direction plus `Director interpretation` |
| Discovery direction and historical unresolved | `DISCOVERY_HANDOFF.md §§3–5` | current direction; older unresolved is historical |
| Anchor | `ANCHOR_DECISION.md §§2–5` | v0.1 user-accepted static baseline; v0.2 unaccepted candidate |
| O2 | `CREATIVE_BRIEF_v0_1.md user-confirmed direction §35–46` | upstream long-term direction; excluded from current Slice |

### Independent Director creative acceptance checklist

Status: **`not_run`**. This checklist is not QA and does not replace independent QA/Release. Future Director review must separately inspect player promise coherence, clear-screen spatial result, movement-to-next-attack causality, same-source `穿透 → 扇裂`, non-punitive rhythm, HUD/readability hierarchy, and Anchor non-substitution. No creative acceptance is claimed here.

### Future QA Gate 0–6

| Gate | Criterion | Expected | Evidence class / artifact | Executor | Independent observer / owner | Threshold / blocker severity | Retest scope | Status |
|---|---|---|---|---|---|---|---|---|
| Gate 0 | Charter readiness | Named version, authorization, scope, owners, decisions, acceptance plan | `static/source`: signed/versioned Charter + index | Producer assembles | Independent QA/Release final pass/block | Missing authorization or preflight = blocker | Recheck full readiness packet | `not_run` |
| Gate 1 | Static conformance | Provenance, 22 decisions, PRECHARTER-01..11, caps and exclusions match | `static/source`: trace matrix | Producer prepares | Independent QA/Release final pass/block | Drift/unverifiable source = blocker | Re-run affected comparisons | `not_run` |
| Gate 2 | Deterministic/runtime | Fixtures, seed/tick/snapshot/trace, no-target/tie/contact/reset/same-frame behavior | `runtime`: build/log/trace/snapshot | Engineer executes | Independent QA/Release final pass/block | P0/P1 or missing audit trail = blocker | Preserve failure; rerun criterion + regression on new build/config/seed | `not_run` |
| Gate 3 | Visual/UI | State/aspect coverage, focus, hint, cards, HUD, B2 and clearing readable | `visual QA` + `runtime`: screenshots/frame index | UX/Director prepare | Independent QA/Release final pass/block | Obscured player/danger/space or focus failure = blocker | Affected states/aspects + necessary regression | `not_run` |
| Gate 4 | Performance | Named hardware/OS/settings, build, raw samples, percentiles, timestamps | `performance`: raw capture + report | Tech executes | Independent QA/Release final pass/block | Threshold unresolved until named decision record; absent/auditable failure blocks | Same criterion with new build/config/hardware as required | `not_run` |
| Gate 5 | Export smoke | Clean start/launch, target OS/platform, artifact integrity, version/build identity, startup/restart evidence | `export/release`: artifact + logs | Toolchain/Engineer executes | Independent QA/Release final pass/block | launch failure, integrity/version mismatch, scope drift, open P0/P1, or unauditable evidence = blocker | Preserve failure; rerun export + affected regression | `not_run` |
| Gate 6 | Independent release review | Consolidated QA, regression, blockers and release recommendation | `QA` + `export/release`: evidence index/package | Producer assembles | Independent QA/Release final pass/block | Any open P0/P1, scope drift, or unverifiable evidence blocks; Producer has no waiver | Re-run affected criterion and required regression with new identity | `not_run` |

**Operational rule:** every applicable gate's final pass/block owner is Independent QA/Release. Producer only assembles the evidence package and cannot waive a blocker. Missing mandatory preflight/start evidence means `not_run`, not pass. Runtime, visual QA, and performance evidence are non-interchangeable; static Anchor/screenshots cannot satisfy runtime, and performance cannot establish readability. Unresolved thresholds require a named decision record with owner/authority; until resolved they remain `not_ready`.

Required evidence record fields: evidence ID; fixture ID; seed; tick/config version; trace/replay or snapshot reference; hardware/OS/settings; build ID; logs; screenshots or observed-frame references; performance sample window and percentile method; export artifact and launch result; observer/owner; timestamp; verdict; unresolved deviations. The Producer must retain an evidence index mapping each ID to its artifact, source/build/config identity, observer, and retention location; no ID or index means the evidence is not auditable. P0/P1 issues, hard-gate failure, unverifiable evidence, scope drift, or non-starting export block the relevant phase/release.

**Mandatory preflight/start evidence:** before any future gate execution, record the authorized version, mode, milestone, owner/dependency, build/config identity, fixture/seed, observer, and stop condition. Missing preflight/start evidence leaves the gate `not_run`. On retest, preserve the original failure, create new evidence IDs with new build/config/seed as applicable, rerun the affected criterion plus necessary regression, and require Independent QA/Release to re-observe; a retest does not erase history.

## 11. Milestone and deliverable proposal

These are relative deliverables, not calendar commitments:

1. **Charter review package:** this draft, source/provenance map, scope caps, authority table, open decisions. Owner: Producer; dependency: six static sources; blocker: no User authorization.
2. **Contract / ADR package:** approved Charter, rules/session/target/reset/focus/performance contracts and decision ledger. Owners: Tech Lead, Systems, UX; dependency: Charter; blocker: unresolved crossing or missing acceptance fields.
3. **Minimum runnable Slice:** future smallest deterministic core plus runtime loop. Owners: future Engineer + Tech; dependency: approved contracts; evidence: fixtures, seeds, traces, build ID; blocker: nondeterminism, scope drift, no independent review.
4. **Integration candidate:** UX/visual/HUD/cards/hint/B2/readability integrated. Owners: Engineer, UX, Director; dependency: runnable Slice; evidence: observed states/screens; blocker: visual hierarchy or focus safety failure.
5. **QA / Release package:** Gates 0–6 evidence, regression/blocker report, performance and export artifacts. Owner: Independent QA/Release; dependency: integration candidate; blocker: any required gate failure or unauditable evidence.

## 12. Open decision register for the User

| Decision | Recommendation | Alternative | Consequence |
|---|---|---|---|
| Accept proposed rules/state/session/adapter architecture boundary? | Accept as a candidate for Tech Lead ADR, not yet final | Request a different seam or defer | Affects sequencing, testability and architecture risk |
| Replay promise scope | Promise fixed tick/seed/snapshot/trace for QA/debug reproducibility only; no player-visible Replay promise | Commit to full player-visible replay or defer all determinism | Full replay adds schema, storage and compatibility cost; QA/debug reproducibility remains a candidate contract |
| Formal target-cluster semantics | Retain nearest → cluster-center distance → stable ordering/ID as proposal pending ADR | User selects another rule or defers | Changes attack readability, determinism and edge-case burden |
| Make performance candidates hard gates? | Keep 1080p/60 target and other numbers provisional until measurement and named hardware | Promote selected numbers to hard Charter gates | Hard gates can block scope/platform; soft candidates reduce release certainty |
| Minimum resolution / widescreen set | Ask UX/Tech for measured recommendation, then User selects minimum red line | Support a narrower set or defer | Changes layout, accessibility and QA matrix |
| Export platform / OS | Retain PC-first without a release-platform commitment until the User chooses | Name a target OS/export set now | Determines toolchain, QA and release evidence cost |
| Make playability observation a formal gate? | Yes: require observed movement causality, wave reduction/corridor recovery, `穿透 → 扇裂` comprehension, and immediate retry after failure before scope expansion | Treat as advisory only | Formal gate can stop content expansion; current status is `not_run/not_ready` and static documents cannot pass |
| Charter authorization | **Recorded:** User explicitly authorized named `Development Charter v0.1` for development governance only | User may request revision, pause, or reauthorize if a boundary crossing occurs | Governance preparation is active; implementation remains blocked until readiness gate and role conditions |

The Producer does not decide these reserved product or threshold questions. They remain open and require the User or the authorized role specified in this Charter; no current status is inferred from silence.

## 13. Provenance and version map

| Source | Coverage in this draft | Historical/current relation |
|---|---|---|
| `GDD_SLICE_v0_1.md` (`GDD v0.1`) | Player promise, slice caps, rules, evidence taxonomy, 22 decisions | Canonical static design baseline; not Charter or implementation authorization |
| `SLICE_RULES_DECISION_v0_1.md` §13 | Current 22-item `user_confirmed` record and older increments | §13 is current effective increment; older unresolved text remains historical |
| `CREATIVE_BRIEF_v0_1.md` | Direction A, pillars, visual baseline, slice truths, Director boundary | Creative handoff; v0.1 anchor remains baseline; not formal development |
| `DISCOVERY_HANDOFF.md` | Discovery provenance, Direction A, PC-first and user authority | Earlier Discovery record; later decisions refine it without silently rewriting history |
| `ANCHOR_DECISION.md` | v0.1 accepted static anchor; v0.2 candidate and review boundary | `synthetic/anchor` only; v0.2 never silently replaces v0.1 |
| `SLICE_PRECHARTER_DECISIONS_v0_1.md` | PRECHARTER-01..11 and four provenance layers | Latest pre-Charter increments; not a Charter; exact values remain open |

Older `unresolved` entries are not silently erased. Where a later user record narrows current status, the history remains traceable and the unresolved detail remains unresolved unless explicitly closed.

## 14. Change log and explicit next user decision

- **v0.1 (this file):** Created one new Producer decision packet from the six permitted static sources. No existing source was modified.
- **v0.1-revision-01 (this file):** Revised only this draft to add precedence/provenance, same-source B2 identity, technical/rules/UX contracts, Anchor boundaries, Director `not_run` checklist, evidence retention/retest rules, and operational Gate 0–6 ownership. All remain proposals or candidate constraints.
- **v0.1-revision-02 (historical input layer, retained):** Recorded the eight-item `Charter pre-authorization decision packet response` from `this decision packet / current user response`; all eight remain provenance-aware candidate inputs and unresolved details remain open. Its captured pre-authorization wording is historical and does not govern current status.
- **v0.1-authorization (current canonical authorization record):** User explicitly authorized named `Development Charter v0.1`. Current status is `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY`; current lifecycle is `development governance / kickoff readiness preparation`. This does not authorize implementation or close any candidate/unresolved item.
- **Current governance state:** kickoff readiness is `not_ready`; all Gates 0–6 are `not_run / not_ready`. No implementation member has started.
- No implementation, Godot, runtime, build, test, QA, performance, export, or release action occurred; no such evidence is claimed.
- Any change crossing promise, immutable Charter, major scope, platform, architecture risk, threshold, or release commitment returns to the User through Change Request and may require Charter reauthorization.

**CURRENT STOP CONDITION:** The canonical named artifact `Development Charter v0.1` is `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY`, with lifecycle `development governance / kickoff readiness preparation`. Kickoff readiness remains incomplete: no implementation, Godot/runtime/build/test/QA execution/performance measurement/export/release action is authorized or started, and no such evidence exists. Gate 0–6 remain `not_run / not_ready`; implementation requires completion of the readiness gate and all relevant role conditions. Independent QA/Release retains pass/block authority.
