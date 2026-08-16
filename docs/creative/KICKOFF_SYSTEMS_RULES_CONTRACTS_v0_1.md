# KICKOFF SYSTEMS / RULES CONTRACTS v0.1

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`
>
> **Purpose:** Static Systems/Rules contract package for future kickoff review under the user-authorized `Development Charter v0.1` governance-only boundary.
>
> This document is not an approved rules specification, balance evidence, implementation authorization, runtime result, simulation, or QA/release conclusion. It records contracts proposed for later review; it does not close unresolved fields or infer new user decisions.

## 1. Metadata, owner, authority, and evidence boundary

| Field | Record |
|---|---|
| Artifact | `KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md` |
| Version | `v0.1` |
| Status | `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED` |
| Lifecycle | `development governance / kickoff readiness preparation` |
| Product owner / final authority | `User` |
| Execution authority | `Executive Producer / Lead Producer` |
| Rules contract owner | `Systems / Rules` (proposal author; not product authority) |
| Technical authority | `Tech Lead` for architecture and technical ADRs; no architecture is approved here |
| Acceptance authority | `Independent QA / Release`; implementers cannot self-certify |
| Charter boundary | `Development Charter v0.1` is authorized for governance/readiness preparation only; no implementation, Godot, build, runtime, test, simulation, performance, export, or release work is authorized by this artifact |
| Current readiness | `not_ready`; Gates 0–6 remain `not_run / not_ready` |

### 1.1 Provenance and evidence boundary

The allowed evidence for this package is static/source evidence from the five instructed inputs and their retained provenance. Static text can establish traceability and proposed contracts only. It cannot establish that rules are implemented, playable, balanced, deterministic in execution, performant, visually readable, or accepted by QA.

The following labels are preserved exactly as decision classes:

- **`user_confirmed`** — an explicit owner decision recorded in the source decision layers. It is a candidate product/Charter constraint, not implementation or runtime proof.
- **`team_proposal`** — a specialist recommendation or organizing contract. It is not a user decision and cannot become one through silence.
- **`assumption`** — an expectation requiring observation or experiment; it is not evidence.
- **`unresolved`** — intentionally open detail, threshold, algorithm, or authority question.

No proposal, assumption, unresolved field, candidate budget, static Anchor, or historical text is promoted to `user_confirmed` by this package.

### 1.2 Charter governance-only boundary

This package may support Producer readiness assembly, Change Request intake, future ADR review, and later QA fixture planning. It does not authorize staffing kickoff execution, code, scenes, resources, Godot/GDMCP access, construction, running, testing, simulation, measurement, asset work, export, or release. Any conflict with the Charter, player promise, immutable candidate decision, major scope, platform, architecture risk, acceptance threshold, or release commitment must stop and return to the User through a Change Request and, where applicable, Charter reauthorization.

## 2. Player promise and contract intent

The source promise is: simple direct movement plus automatic attacks produce readable, weighty clear-screen control, increasingly strong but readable victories, repeatable catharsis, and non-punitive retry. The proposed rules contract exists to make the causal loop inspectable:

`movement intent → pre-fire target consequence → readable hit/contact result → space recovery or danger → fixed upgrade transaction → stronger same-source B2 control → victory/defeat → immediate reset`

This is a design contract proposal, not a claim that the loop currently works. The slice remains capped at one player, one ordinary enemy family, one automatic attack family, one same-source B2 journey, one bounded industrial screen, and an eight-minute run.

## 3. Rules vocabulary and state model

### 3.1 Vocabulary

| Term | Proposed meaning | Boundary |
|---|---|---|
| `entry` | Run entry/reset-complete state in which the new run becomes eligible to start | Product boundary: a fresh run has no out-of-run loss; exact initialization order unresolved |
| `combat` | Active play state in which movement, automatic attack, contact, XP, and timer may progress | Product boundary: only movement is promised; implementation scheduling unresolved |
| `no-target` | Explicit attack-cycle branch when the refresh yields no legal target | Product boundary: never fabricate a target; cadence/timing unresolved |
| `target snapshot` | The fixed target set captured after pre-fire refresh for the current shot | Product boundary: post-fire target set does not continuously retarget; schema/invalidation unresolved |
| `contact invulnerability` | Short protection after one legal contact event | Product boundary: no repeated damage during the protection window; duration unresolved |
| `separation` | Light, short separation after legal contact | Product boundary: preserve recoverable spacing; distance/direction/boundary behavior unresolved |
| `re-arm` | A previously contacted pair becomes eligible again only after separation | Product boundary: persistent overlap cannot repeatedly damage without re-arm; exact predicate unresolved |
| `upgrade pause` | Full combat pause for one guaranteed upgrade transaction | Product boundary: first `穿透`, then `扇裂`; pause/input semantics unresolved |
| `card choice` | Three same-keyword cards, choose exactly one; no skip/reroll | Product boundary: choice is bounded and meaningful; card values/content unresolved |
| `focus-loss` | Window/application focus loss that freezes combat and confirmation safely | Product boundary: preserve focus/selection and reject stale confirmation; event/buffer semantics unresolved |
| `resume` | Return from pause/focus-loss only after required feedback/safety conditions | Product boundary: valid fresh input and feedback-before-resume; exact epoch/timing unresolved |
| `victory` | Survival through the eight-minute completion condition | Product boundary: life depletion wins arbitration over same-frame completion |
| `defeat` | Life depletion result | Product boundary: short clear result, then automatic immediate restart; exact trigger/cleanup unresolved |
| `result` | Short, clear victory or defeat presentation with input locked | Product boundary: no punitive result flow; duration/copy unresolved |
| `reset` | Canonical clearing and fresh-run transition | Product boundary: no out-of-run loss; seed/ID/input cleanup and ordering unresolved |

### 3.2 Product boundary versus implementation unresolved

**Product boundaries retained in this proposal:** only movement; automatic attack; pre-fire nearest-threat cluster refresh and post-fire lock; explicit no-target handling; one legal contact with brief invulnerability and separation; re-arm after separation; three life segments; two guaranteed full pauses in `穿透 → 扇裂` order; three same-keyword cards and one choice with no skip/reroll; persistent life/timer/B2 HUD direction; focus-loss safety; life-depletion precedence; short result and automatic restart; same-source B2 with center plus left/right arcs inheriting piercing and independent counters.

**Implementation/design fields still unresolved:** tick frequency and same-tick semantics; state/event schema; cluster definition and distance metric; stable IDs and tie-break fields; target invalidation; no-target cadence; collision geometry; damage, timing, separation distance, stacking, boundaries; XP source/thresholds; card pool, values, copy, focus behavior; feedback duration; B2 geometry, duplicate-hit and sharing rules; reset cleanup; platform-specific focus behavior; all balance and performance measurements.

## 4. Canonical rules-order proposal

The canonical order proposed for review is:

`pre-fire refresh → no-target branch or snapshot lock → hit/contact/XP/timer → terminal arbitration → result/input lock → reset`

1. **Pre-fire refresh:** construct the current legal threat candidate set immediately before firing; apply the later-approved stable ordering.
2. **No-target branch or snapshot lock:** if empty, take the explicit no-target branch without a pseudo-target; otherwise capture and lock the shot snapshot.
3. **Hit/contact/XP/timer:** resolve the shot against its snapshot; process legal contact safety; award only authorized in-run XP/fragments; advance the run timer according to the later tick contract.
4. **Terminal arbitration:** resolve victory/defeat after same-step events; life depletion takes priority over eight-minute completion.
5. **Result/input lock:** enter a short result state and reject gameplay/confirmation input while result is active.
6. **Reset:** clear the canonical run state and begin the automatic immediate restart path.

This is a `team_proposal` constrained by `user_confirmed` boundaries. Exact tick/order, event queue semantics, simultaneous contacts, timer sampling, and cleanup are `unresolved`; this sequence is not an implementation mandate or approval.

## 5. Target and no-target contract

### 5.1 Proposed contract

1. Before each fire, refresh a high-level nearest-threat cluster.
2. Establish a stable candidate ordering for that cluster.
3. Select/lock the shot's target snapshot from the ordered candidates.
4. Once fired, the shot uses that snapshot and does not continuously retarget.
5. If the refreshed set is empty, enter the no-target branch; never invent a target, aim at a fake entity, or report a hit against absent threat.
6. Removed/invalid targets must be excluded from later resolution; the invalidation rule requires a future technical contract.

The phrase “nearest-threat cluster” is a product-level direction, not a complete algorithm. Exact cluster membership, distance/quantization, stable tie-break fields, stable-ID lifecycle, refresh/fire timing, snapshot schema, target sharing, and invalidation are `unresolved` and require Tech Lead ADR plus independent QA evidence.

### 5.2 No-target feedback and cadence

The no-target branch must preserve a readable automatic-attack cycle without fabricating combat success. Whether it emits a quiet cycle, a restrained availability cue, a delayed retry, or another feedback form is `team_proposal / unresolved`. No cadence, delay, animation, sound, or timing is approved here. The future contract must record the branch ID, input state, timer effect, feedback class, and next eligible fire point.

### 5.3 Deterministic fixture ID/schema proposal

Future fixtures should use stable IDs and explicit fields, for example:

```text
fixture_id, config_version, seed, tick, player_state,
entities[{stable_id, kind, position, alive, contact_state}],
attack_phase, candidate_ids, ordered_ids, target_snapshot_ids,
no_target_branch, hit_results, contact_results, xp_events,
timer_before, timer_after, terminal_candidate, terminal_result,
reset_epoch, trace_reference
```

This is a schema proposal only. It must not be treated as an approved architecture or runtime format. Every fixture should state expected observable facts and unresolved deviations, not only a prose intention.

## 6. Contact, invulnerability, separation, and re-arm contract

### 6.1 Proposed legal-contact transition

`eligible overlap → one legal contact event → life damage → short contact invulnerability → light separation → recoverable combat`

A pair that remains continuously overlapped cannot generate repeated damage during invulnerability. Re-arm is permitted only after the required separation predicate is satisfied. The contract must distinguish legal contact from continuous overlap and must preserve a route that can be recovered rather than turning contact into a sticky lock.

### 6.2 Unresolved edge behavior

The following remain `unresolved`: contact duration; exact invulnerability timing; separation distance and direction; damage amount and life consumption; multiple simultaneous contacts; stacked enemy contacts; player/enemy boundary cases; separation failure; re-contact timing; entity removal during contact; and whether invulnerability is global or pair-specific. No balance or fairness claim can be made until these are specified, observed, and independently reviewed.

### 6.3 Fixture matrix proposal

| Fixture ID family | Setup / event | Required trace questions |
|---|---|---|
| `CONTACT-single` | One eligible enemy enters contact once | Exactly one damage? invulnerability entered? separation emitted? |
| `CONTACT-overlap` | Same pair remains overlapped | No repeat damage during invulnerability? Does re-arm stay false? |
| `CONTACT-separate-rearm` | Pair separates then contacts again | Is exactly one new legal event allowed? |
| `CONTACT-simultaneous` | Two or more enemies contact in one step | Stacking/ordering/maximum damage still unresolved and explicitly reported |
| `CONTACT-boundary` | Contact occurs at arena boundary | Separation and recoverability without escape-through-boundary |
| `CONTACT-removal` | Contacted target is removed during protection | State cleanup and future re-arm behavior |

Fixture names are proposals for deterministic evidence, not executed tests.

## 7. Upgrade transaction contract

### 7.1 Guaranteed transaction

There are two guaranteed full pauses in a fixed order:

1. **Upgrade 1:** keyword `穿透`; present three same-keyword variant cards; choose exactly one.
2. **Upgrade 2:** keyword `扇裂`; present three same-keyword variant cards; choose exactly one.

There is no skip and no reroll. The transaction is:

`trigger → full pause → valid focus/selection → explicit choice → acquired feedback → resume`

A choice is not complete merely because a card is visible. The selected card must be observably acquired before combat resumes. Card values, exact XP trigger, timing windows, card pool, copy, focus styling, and recovery duration are unresolved. The candidate windows of about 2–3 minutes and 4.5–6 minutes remain candidate windows, not constants or balance evidence.

### 7.2 Pause, focus, stale input, and reset rules

- During an upgrade pause, combat simulation and gameplay progression are fully paused.
- Focus must be valid before confirmation; selection must remain observable.
- On focus loss, freeze combat and confirmation immediately, preserve selection/focus state, and require fresh explicit input after return.
- A buffered or stale `Enter`/`Space` from before focus return must not confirm a card.
- Feedback must occur before combat resumes.
- Reset must clear the pending transaction, selected card, focus epoch, buffered confirmation, XP intermediary, and upgrade progress according to the later approved reset contract.
- If reset and a pause trigger coincide, the terminal/reset arbitration must define which state owns the input and how stale transaction state is discarded; this is unresolved.

These are contract proposals bounded by user-confirmed safety requirements. Event buffering, focus event ordering, platform behavior, and exact pause/resume timing require Tech/UX review and independent QA scenarios.

## 8. B2 contract

### 8.1 Same-source structure

B2 is one same-source journey:

- Before `扇裂`: one center directional arc with the provisional piercing rule.
- After `扇裂`: center arc remains and left/right arcs are added, forming three arcs.
- All three arcs inherit the piercing rule.
- Each arc maintains an independent hit counter/budget.

This is not a second weapon family, a persistent luminous field, or an out-of-run system. It is a product-boundary proposal constrained by the confirmed Slice identity.

### 8.2 Unresolved B2 fields

Exact arc geometry, angular spread, spacing, length, collision shape, duplicate-hit policy, target sharing, shared versus independent attenuation, counter reset timing, simultaneous arc ordering, and performance budget are `unresolved`. “Independent hit counters” does not authorize a number; “inherit piercing” does not prove a balance result. Any proposed value must enter the range-and-experiment ledger.

## 9. HUD, XP observability, and playability evidence contract

### 9.1 Observability hierarchy

The persistent player-facing HUD proposal keeps **life**, **timer**, and **B2 phase** visible. The B2 phase must communicate the keywords `穿透 → 扇裂`; XP/fragments remain subordinate and serve only as the intermediary for the two upgrades. Player, immediate danger, enemy wave, and recoverable movement space outrank HUD decoration. Exact layout, copy, safe area, minimum resolution, iconography, and accessibility thresholds are unresolved.

### 9.2 Future playability observation gate

Before scope expansion, a future authorized observation must inspect, with independent review:

- movement causing a readable change in the next automatic attack;
- attack/kill results reducing pressure and recovering a corridor or movement pocket;
- the `穿透 → 扇裂` power step being understood as the same source becoming stronger;
- B2 comprehension without effects obscuring player, danger, wave, or space;
- immediate retry after failure without punitive delay.

This is a future evidence gate. Current status is `not_run / not_ready`; no static document, Anchor, assumption, or proposal can pass it.

## 10. Range-and-experiment ledger template

Every future number or threshold must begin as a range and starting point, not a locked constant.

| Field | Required record |
|---|---|
| `range` | Candidate lower/upper range, units, and excluded values |
| `starting_point` | Experimental initial value; explicitly not balance evidence |
| `assumption` | What player/system expectation the value is testing |
| `dependency` | Related state, platform, geometry, wave, UX, or performance dependency |
| `signal` | Observable success/failure signal and collection method |
| `promotion_authority` | Named role; User required for product/threshold/Charter crossings |
| `stop/rollback` | Stop condition, failure consequence, rollback/revert rule |
| `evidence_id` | Later trace, runtime observation, measurement, or QA reference; blank until produced |

Example ledger rows may cover contact invulnerability, separation, target cadence, piercing cap, attenuation, arc spread, XP trigger, or pressure density, but no example value is approved by this document.

## 11. Deterministic fixture/trace requirements and QA handoff

A future authorized implementation/validation package should provide fixture IDs, seed, tick/config version, stable entity IDs, pre/post snapshots, ordered target candidates, target snapshot, no-target branch, hit/contact/XP events, timer values, terminal arbitration, result/input lock, reset epoch, and unresolved deviations. A trace must be sufficient to compare two runs without relying on memory or screenshots alone.

The Systems handoff to Independent QA/Release must include:

1. the versioned contract and decision-status labels;
2. fixture matrix covering no-target, ties, removals, contact overlap/separation/re-arm, simultaneous contacts, both upgrades, focus loss/stale input, B2 arc counters, same-frame defeat-over-victory, result lock, and reset;
3. expected observable outcomes and explicit tolerances, with unresolved thresholds marked as such;
4. evidence IDs and observer fields once evidence exists;
5. a statement of what was not observed.

No balance claim is valid without authorized simulation/runtime evidence and independent review. This document contains no simulation, runtime, performance, build, export, or QA evidence.

## 12. Decision and Change Request rules

Every new feature, direction change, platform change, scope change, schedule/cost commitment, architecture change, threshold promotion, or release commitment enters a Change Request. The request records motivation, provenance, alternatives, displaced work, dependencies, risk, evidence impact, owner, and decision authority.

The request must return to the **User** for a product decision or Charter reauthorization if it crosses:

- the player promise or experience pillars;
- an immutable candidate Charter/product decision;
- major Slice scope or an exclusion;
- platform or input commitment;
- architecture risk or a cross-boundary contract;
- acceptance/performance thresholds;
- milestone or release commitment.

The Executive Producer/Lead Producer owns intake, sequencing, dependency and scope governance, but cannot silently approve such crossings. The Tech Lead owns technical ADRs, not product authority. Systems/Rules proposes rules and ranges, not implementation authority or acceptance. Independent QA/Release owns acceptance and may block any phase or release. The Producer cannot waive an Independent QA/Release blocker, missing evidence, or an unauditable result. Silence never constitutes approval.

## 13. Provenance map and authority preservation

### 13.1 Four layers

| Layer | Meaning retained in this package |
|---|---|
| `user_confirmed` | Explicit owner choices; candidate constraints only, not implementation/runtime proof |
| `team_proposal` | Specialist recommendations, contract ordering, fixture/schema and ledger templates |
| `assumption` | Expectations such as readability, recoverable routes, and deterministic clarity requiring observation |
| `unresolved` | Exact values, algorithms, timing, thresholds, schemas, platform details, and authority questions left open |

### 13.2 22 baseline decisions

The 22 decisions in `SLICE_RULES_DECISION_v0_1.md §13` and the echoed GDD record are preserved as `user_confirmed` candidate constraints, not rewritten as approved implementation rules: (1) movement only/no dash-dodge; (2) WASD + arrows/no gamepad promise; (3) pre-fire nearest-threat refresh and post-fire lock; (4) one contact event plus light separation; (5) short result and immediate restart without out-of-run loss; (6) fixed piercing cap/light later attenuation/independent arc counters; (7) three same-keyword choice cards; (8) full pause and feedback before resume; (9) in-run XP/fragments only; (10) pressure reads with recoverable route; (11) victory as control completion; (12) defeat as light interruption; (13) fixed structure/light randomness; (14) B2 keyword HUD; (15) extremely short movement hint; (16) hint entry/fade/once-per-run; (17) three equal cards and mouse/directional focus with Enter/Space/no skip-reroll; (18) 16:9/common widescreen/readability red line; (19) basic accessibility; (20) strict Slice cap/exclusions; (21) PC-first performance direction with numbers pending proposal and User confirmation; (22) GDD authorization separated from Charter/formal development.

No exact number, algorithm, threshold, or implementation mechanism is inferred from this list.

### 13.3 Exactly eight canonical `v0.1-revision-02` inputs

The eight inputs recorded in `DEVELOPMENT_CHARTER_DRAFT_v0_1.md` §2.1 are preserved with their boundaries and counted exactly as follows, matching the canonical Matrix list:

1. **Promise / pillars / cap:** existing player promise, experience pillars, Slice cap, and exclusions as candidate immutable boundaries.
2. **Candidate architecture:** `rules core + session + adapter/presentation`, requiring a future Tech ADR and not approved here.
3. **Reproducibility:** fixed tick/seed/snapshot/trace for QA/debug reproducibility only; no player Replay promise.
4. **Target snapshot:** pre-fire nearest-threat refresh, stable sort, and locked shot snapshot, with exact details unresolved.
5. **Safety / terminal:** high-level no-target, contact, upgrade-pause, focus-loss, life-depletion, and automatic-restart safety boundaries.
6. **Playability gate:** core playability observation as a formal future gate before scope expansion; current status `not_run / not_ready`.
7. **Performance:** candidate performance budgets only; not hard gates, observed results, or release commitments.
8. **Platform:** PC-first keyboard, 16:9/common-widescreen, and basic accessibility direction, without a named OS, minimum resolution, export target, or release platform.

The current `Development Charter v0.1` authorization is a separate current authorization record / provenance event, not a `v0.1-revision-02` packet input and not a ninth item. Its status remains `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY`; its lifecycle remains `development governance / kickoff readiness preparation`; kickoff remains `not_ready`; and implementation remains unauthorized. These are not expanded by the current package. The architecture boundary remains not approved.

This is a history-preserving provenance/count clarification only. It does not approve or accept the Systems proposal, close any unresolved field, or authorize implementation.

### 13.4 PRECHARTER-01..11

The eleven records in `SLICE_PRECHARTER_DECISIONS_v0_1.md` remain traceable and status-layered:

- `PRECHARTER-01`: fixed tick + seed + snapshots; constrained light randomness; exact determinism contract unresolved.
- `PRECHARTER-02`: no-target attack, otherwise nearest threat, cluster-center distance, stable ordering/ID; exact algorithm unresolved.
- `PRECHARTER-03`: one legal contact, invulnerability, separation, no repeat during invulnerability, re-arm after separation; timings/stacking/boundaries unresolved.
- `PRECHARTER-04`: ranges and experimental starting points; no unverified constants; promotion authority and evidence unresolved.
- `PRECHARTER-05`: candidate upgrade windows about 2–3 and 4.5–6 minutes; fixed `穿透 → 扇裂`; triggers/XP/timing unresolved.
- `PRECHARTER-06`: persistent life/timer/B2 HUD and minimized XP; layout and thresholds unresolved.
- `PRECHARTER-07`: extremely short causal movement hint; copy/timing and observation unresolved.
- `PRECHARTER-08`: keyword title plus one clear difference dimension; variants/values/copy unresolved.
- `PRECHARTER-09`: focus-loss freeze, preserve selection, fresh input, reject stale Enter/Space; event semantics unresolved.
- `PRECHARTER-10`: 1080p/60 direction, 50 FPS minimum candidate, response/start/restart candidate budgets; no achieved or hard-gate claim.
- `PRECHARTER-11`: same-frame life depletion takes priority over eight-minute victory; exact event ordering/cleanup unresolved.

### 13.5 Source authority and no-new-decision statement

- `DEVELOPMENT_CHARTER_DRAFT_v0_1.md` is the current governance boundary and source of role authority/readiness status; it does not authorize implementation here.
- `GDD_SLICE_v0_1.md` is the canonical static Slice design baseline; it is not runtime or QA evidence.
- `SLICE_RULES_DECISION_v0_1.md` §13 is the effective 22-item user-confirmed increment, with older history retained.
- `SLICE_PRECHARTER_DECISIONS_v0_1.md` is the 11-item user-confirmed pre-Charter layer; exact details remain open.
- `CREATIVE_BRIEF_v0_1.md` supplies the player promise, pillars, slice intent, and visual/creative boundaries; its Director interpretations are not silently converted to product decisions.

No new user decision is inferred. No Anchor, O2 direction, historical unresolved field, candidate budget, proposal, assumption, or static wording is upgraded by this package.

## 14. Closure and readiness statement

**Artifact status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`.

**Static deliverable:** Systems/Rules contract proposal, fixture/trace requirements, ledger template, QA handoff, and Change Request boundaries.

**Not produced:** implementation, Godot/GDMCP access, code, scenes, resources, runtime observation, simulation, build, test, performance measurement, export, release, or QA verdict.

**Readiness:** This package is suitable for Producer/Tech/UX/Director/Independent QA review as a kickoff-readiness input, but it does not itself satisfy Gate 0, approve architecture, promote balance constants, or authorize kickoff. Closure is ready only as a static proposal artifact; formal development remains not started and readiness remains not ready.
