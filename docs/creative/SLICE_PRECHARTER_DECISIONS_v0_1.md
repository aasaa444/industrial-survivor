# Slice Pre-Charter Decisions v0.1

- **Version:** `v0.1`
- **Lifecycle:** `preproduction`
- **Record date:** `2026-08-16`
- **Owner:** `user`
- **Recording role:** `Doc Scribe`
- **Status:** `user_confirmed_precharter_decisions / not a Development Charter`
- **Source:** User's explicit GUI selections in the current session.

## 1. Purpose and authorization boundary

This is an independent, traceable record of eleven Charter-before decisions. The user has authorized the GDD baseline, but this record does **not** authorize a Development Charter, formal development, implementation, Godot access or mutation, runtime execution, build, testing, QA, performance acceptance, export, or release. No silence, proposal, assumption, or static document evidence is promoted into product authorization.

This record does not rewrite the canonical GDD or any upstream document. It records this session's incremental decisions beside them. If a later document needs to incorporate these decisions, it must preserve the provenance and the unresolved fields below.

## 2. Provenance layers

- **`user_confirmed`** — the user explicitly selected the boundary in the GUI this session. This means a product choice was made; it does not mean the choice is implemented or verified.
- **`team_proposal`** — a recommendation or candidate number supplied by a domain role, retained as such and never upgraded by this record.
- **`assumption`** — a design expectation that requires observation; it is not a decision.
- **`unresolved`** — deliberately open detail requiring later domain work, user confirmation, or evidence.

## 3. Decision ledger

| ID | User selection (`user_confirmed`) | Provenance / recommendation source | Impact surface | Follow-up verification evidence | Still unresolved |
|---|---|---|---|---|---|
| `PRECHARTER-01` | Deterministic behavior: fixed tick + seed + snapshots; retain only constrained light randomness. | `user_confirmed`, direct GUI choice. Recommendation context: Tech Lead / Systems proposal may define the eventual determinism contract, but does not author this product boundary. | Replayability, debugging, combat timing, wave/content variation, future QA evidence. | A later authorized Tech/Gameplay design must specify and demonstrate reproducible runs and snapshot/replay comparison; independent QA must verify repeatability. | Exact tick frequency; seed initialization and ownership; snapshot schema/cadence; permitted random sources/ranges; replay equivalence and extreme-sample rules. |
| `PRECHARTER-02` | Target selection: attack in a no-target case; otherwise use nearest threat, cluster-center distance, then a stable candidate ordering/stable ID. | `user_confirmed`, direct GUI choice. Recommendation context: Tech Lead / Systems may formalize the algorithm. | Automatic attack readability, movement-to-next-shot causality, deterministic targeting, edge cases. | Authorized implementation evidence plus deterministic scenario tests and independent QA observation for no-target, ties, target removal, and stable ordering. | Exact threat-cluster definition; distance metric/quantization; stable tie-break fields and ID lifecycle; attack-cycle timing and no-target behavior details. |
| `PRECHARTER-03` | Contact: one damage event per legal contact; brief invulnerability; slight separation; no repeated damage during invulnerability; contact can become valid again only after separation. | `user_confirmed`, direct GUI choice. Recommendation context: Systems/Balance and Tech Lead can propose numeric collision parameters. | Player survival, recoverable spacing, collision state transitions, hit feedback, QA edge cases. | Runtime observation and independent QA scenarios for overlap, separation, invulnerability, re-contact, boundaries, and simultaneous contacts. | Contact duration; separation distance/direction; invulnerability duration; damage amount; stacking and boundary rules. |
| `PRECHARTER-04` | Use ranges plus experimental starting points; do not lock unverified product constants. | `user_confirmed`, direct GUI choice. Recommendation source: Systems/Balance owns balance proposals; Tech Lead owns technical constraints. | All tuning tables, balance, performance candidates, implementation configuration, change control. | Versioned tuning proposal, experiment results, runtime measurements, and independent QA evidence; values remain provisional until explicitly accepted. | All exact gameplay constants, sampling plan, acceptance thresholds, hardware/test conditions, and who may promote a starting point to a product constant. |
| `PRECHARTER-05` | Upgrade timing candidates: first about 2–3 minutes, second about 4.5–6 minutes; these remain candidate windows pending runtime validation; fixed `穿透 → 扇裂` order remains. | `user_confirmed`, direct GUI choice for the windows and order. Recommendation source: Systems/Balance supplied the candidate timing framing; user did not lock constants. | Session pacing, XP curve, upgrade presentation, B2 readability, balance iteration. | Runtime pacing observations, balance experiments, deterministic repeated runs, and independent QA verification of order and pause/recovery behavior. | Exact trigger condition; XP source and values; window measurement definition; wave/density dependency; card content and numbers; recovery timing. |
| `PRECHARTER-06` | HUD permanently shows life + timer + B2 phase in B2; XP is minimized. | `user_confirmed`, direct GUI choice. Recommendation source: UX/UI for hierarchy and readability; user selected the boundary. | Information hierarchy, screen space, accessibility, B2 comprehension, responsive layout. | UX/UI review and later runtime/visual QA across supported aspect ratios and states; no current visual acceptance is implied. | Exact position, anchors, size, colors, copy, iconography, B2 stage treatment, XP representation, minimum resolution and safe areas. |
| `PRECHARTER-07` | Add an extremely short causal tutorial hint explaining that movement affects the next automatic attack result; exact copy remains undecided. | `user_confirmed` for inclusion and causal purpose; `unresolved` for wording. Recommendation source: UX/UI / narrative-copy discipline; user selected the boundary. | Onboarding, player cognition, first attack cycle, tutorial timing and localization. | UX review plus observed first-session/runtime evidence that players understand the causal relationship without clutter. | Exact wording, language/localization, trigger, duration, dismissal, repeat behavior, placement, and accessibility treatment. |
| `PRECHARTER-08` | Upgrade cards use a keyword title plus one clear difference dimension; exact variants, values, and copy remain undecided. | `user_confirmed` for information structure; `unresolved` for content. Recommendation source: UX/UI and Systems/Balance; not a card-content approval. | Choice readability, cognitive load, balance communication, content authoring. | UX/UI review, balance comparison, and independent runtime QA of focus/selection/readability. | Concrete variants, numbers, titles/copy, icons, difference dimension definition, pool rules, layout, focus and confirmation feedback. |
| `PRECHARTER-09` | On focus loss, immediately freeze combat and upgrade confirmation; preserve focus/selection; after return require new explicit input; prevent stale Enter/Space from confirming. | `user_confirmed`, direct GUI choice. Recommendation source: UX/UI for interaction safety and Tech Lead for input/state handling; neither replaces user authority. | Pause state, input buffering, accessibility, upgrade safety, focus recovery, platform/window behavior. | Authorized runtime scenarios plus independent QA for focus loss during combat and upgrade selection, stale-input rejection, and recovery. | Exact focus event policy, buffering/flushing semantics, pause scope, return-focus behavior, timing, platform-specific behavior, and messaging. |
| `PRECHARTER-10` | Performance direction: 1080p/60 FPS target and 50 FPS minimum candidate; also retain candidate budgets of input response ≤50 ms, key hit-feedback start ≤100 ms, cold start <3 s, restart <1 s. All are candidate budgets pending measurement, not achieved facts. | `user_confirmed` for the direction and candidate-budget set as a recording boundary; `team_proposal` for the candidate numeric budgets from Tech Lead; `unresolved` for measurement protocol, hardware tiers, and acceptance status. | Rendering, input, feedback, startup/restart, scope and future QA/release review. | Reproducible performance measurements on named hardware/settings and independent QA/Release review. Until then these are neither pass criteria nor release commitments. | Hardware tiers; OS/settings; build mode; frame-time sampling/window; percentile vs average; input-to-observation method; hit-feedback timestamp definition; cold-start/restart boundaries; hard vs soft budget decision. |
| `PRECHARTER-11` | Same-frame outcome rule: life depletion takes priority over 8-minute completion. This is a confirmed rule boundary, but its implementation still requires runtime/QA validation. | `user_confirmed`, direct GUI choice. Recommendation context: Systems/Tech may formalize ordering and state transition; QA independently accepts behavior. | End-state arbitration, victory/defeat feedback, deterministic replay, restart and acceptance criteria. | Deterministic same-frame scenarios with independent QA observation of life-depletion precedence and clear result/restart behavior. | Exact event ordering within a tick, simultaneous damage/completion semantics, queued input handling, result display duration, and reset cleanup. |

## 4. Layered status summary

### 4.1 `user_confirmed`

The user confirmed the eleven boundaries exactly as summarized in the ledger: deterministic direction; target-selection ordering; legal-contact and invulnerability behavior; range/starting-point tuning method; candidate upgrade windows with fixed `穿透 → 扇裂`; persistent HUD fields and minimized XP; a causal movement hint; card information structure; focus-loss safety; the performance direction and candidate budget set as candidates; and same-frame life-depletion precedence.

### 4.2 `team_proposal`

The candidate performance numbers are retained as **Tech Lead candidate proposals** recorded under the user-confirmed performance direction. Systems/Balance, UX/UI, Tech Lead, and future engineering may propose algorithms, ranges, measurement protocols, copy, layouts, and tuning tables. Their proposals do not become product decisions without the appropriate user decision or Charter gate.

### 4.3 `assumption`

It is an explicit assumption for later validation—not current evidence—that deterministic combat plus constrained randomness will make movement-to-next-attack causality and B2 progression readable, and that the proposed HUD/card/tutorial information hierarchy can remain legible in the intended slice. These assumptions remain open.

### 4.4 `unresolved`

All exact values and implementation details listed in the ledger remain unresolved, including tick frequency, seed/snapshot contract, cluster and distance math, tie-break fields, contact timings/distances, XP source and values, upgrade trigger measurement, HUD placement/copy, card variants and numbers, focus buffering semantics, minimum resolution, hardware and performance measurement protocol, and same-tick event ordering.

## 5. Performance candidate boundary

**Direction confirmed:** PC-first performance work should target 1080p/60 FPS, with 50 FPS retained as a minimum candidate direction, alongside candidate response/startup/restart budgets listed in `PRECHARTER-10`.

**Numbers pending measurement:** these figures are candidate budgets, not observed results, not acceptance results, not release budgets, and not evidence of meeting any target. No performance claim may be made until a later authorized measurement protocol names hardware, settings, build, sampling method, and acceptance authority; independent QA/Release must review the evidence.

## 6. Change impact and handoff

- **Game Director / Creative Director:** check that determinism, targeting, contact recovery, pacing, B2 order, HUD, tutorial, cards, and outcome arbitration preserve the player promise and slice intent; do not silently expand unresolved details.
- **Tech Lead:** own later technical ADRs and proposals for tick/seed/snapshot, targeting, input focus safety, same-tick ordering, and measurement architecture; this record does not author those technical decisions.
- **Systems / Balance:** turn ranges and upgrade windows into experiments, balance tables, and evidence; do not promote starting points or candidate windows to constants without authority and observation.
- **UX/UI:** specify readable HUD, causal hint, card hierarchy, focus recovery, and accessibility details for review; do not treat this record as final copy/layout approval.
- **Future Producer:** treat this as preproduction scope/decision input only. Any feature, direction, platform, architecture, scope, schedule, or release change enters a Change Request and returns to the user when it crosses the relevant authority boundary.
- **Independent QA / Release:** define and independently inspect deterministic, contact, focus-loss, same-frame, pacing, visual, and performance evidence when formally authorized; implementers cannot self-certify.

## 7. Authorization gate

This record is complete only as a pre-Charter decision record. To enter formal development, the user must separately and explicitly authorize a **versioned Development Charter** defining scope, milestones, dependencies, platform, architecture risk, and acceptance gates. No consent to that Charter or to implementation can be inferred from this record. Until then, no Producer kickoff, Godot work, code, runtime, build, test, QA, performance acceptance, export, or release work is authorized.

## 8. Evidence boundary and drift check

- **Evidence class:** `static/source` only: this Markdown record, the permitted source documents, and the user's current GUI selections.
- **Not observed:** Godot state, runtime behavior, visual frames, build output, tests, QA, performance measurements, export, or release evidence.
- **Known static drift:** older source records preserve earlier `unresolved` states. This independent record does not rewrite them. The existing GDD and rules record already distinguish user decisions from proposals and unresolved details; this record adds the eleven current increments without claiming that older documents are silently synchronized.
- **Convention gap:** `docs/DEVELOPMENT.md` and `docs/adr/` were checked for convention and are absent in the current docs path; no substitute ADR or convention file was created.

## 9. Change log

| Date | Change | Scope / evidence |
|---|---|---|
| `2026-08-16` | Created `SLICE_PRECHARTER_DECISIONS_v0_1.md` from the user's current GUI choices. | New independent preproduction record; 11 decisions; static/source only. Canonical GDD and all other files were not rewritten. |

## 10. Closure statement

This record is `user_confirmed_precharter_decisions / not a Development Charter`. It records user decisions without claiming implementation, runtime correctness, QA acceptance, performance attainment, export readiness, or release readiness. Open items remain with the responsible domain roles and the user under the authorization gates above.
