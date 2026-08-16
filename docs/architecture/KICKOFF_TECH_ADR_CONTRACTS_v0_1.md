# KICKOFF TECH ADR & CONTRACT PACKAGE v0.1

> **STATUS: ADR-TECH-01..06 `approved`（user_confirmed，R11，2026-08-16）= 生效技术契约（decision level）；ADR-TECH-07/08 `draft_in_review` / `NOT APPROVED`. DEVELOPMENT NOT STARTED.**
>
> This is a Tech Lead-owned package for `development governance / kickoff readiness preparation`. ADR-TECH-01..06 are **approved as effective technical contracts at the decision level**（user_confirmed，R11，2026-08-16）; ADR-TECH-07/08 remain `draft_in_review` / `NOT APPROVED`. **Approval ≠ implementation authorization**: it does not approve an overall architecture beyond the approved ADRs, does not freeze remaining contracts, does not authorize implementation, kick off, or release, and provides no runtime evidence. Implementation start requires a separate user authorization + GDMCP preflight + start evidence.

## 1. Metadata, authority, and evidence boundary

> **Draft-advancement note (2026-08-16, A1 = DC-ARCH-01 → Option A1, cr-201):** ADR-TECH-01..08 have been advanced from `ready_to_draft` into the authorized **draft → cross-role review → per-ADR approval** path. Each ADR below now carries its own **评审状态与跨角色依赖（draft status & cross-role dependency）** subsection and is additionally aggregated in §18 "ADR dossier". **Cross-role review-integration (2026-08-16):** ADR-TECH-01..06 advanced to `ready_for_approval` after adopting Systems `ADR_REVIEW_SYSTEMS_INPUT_v0_1.md` (TECH-04 Block A), UX `ADR_REVIEW_UX_INPUT_v0_1.md` (TECH-01 R1–R2, TECH-02 R3–R5, TECH-05 R6–R7), and QA `QA_ACCEPTANCE_PLAN_v0_1.md §7` (TECH-06). `ready_for_approval` means **review input integrated, no unresolved blocker — ready to enter the per-ADR approval flow**; it is a state marker, **not** approval. Total status remained **`PROPOSAL / DRAFT / NOT APPROVED`** for all ADRs until the per-ADR approval. **ADR approval status-line synchronization (2026-08-16, R11)：** 用户经 `/godot-game-team` 方向 B 选项卡片逐条批准，Producer 已登记 `CHANGE_REQUESTS_v0_1.md §8.6 R11`（user_confirmed）。ADR-TECH-01..06 状态行更新为 **`approved`**（生效技术契约，decision level）；TECH-05 **机制边界批准、精确数值语义延后**（cr-006..020 Systems 契约 in_flight）；TECH-07/08 保持 `draft_in_review`。**批准 ≠ 实现授权**：implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`。本次同步仅更新状态行与状态相关注记，未改变任何已批准正文语义、未提升任何候选数值。Cross-role dependencies remain marked `satisfied` / `in_flight` / `missing / assumption source`; the R11 approval does not upgrade any `unresolved` rule/nullary value to `user_confirmed` beyond the ADR status itself.

| Field | Value |
|---|---|
| Artifact | `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` |
| Version | `v0.1` |
| Owner | Tech Lead |
| Product authority | User; final product decision-maker |
| Execution authority | Executive Producer / Lead Producer |
| Technical authority | Tech Lead, within the Charter and without replacing User/Director/QA |
| Acceptance authority | Independent QA / Release; implementers cannot self-certify |
| Current lifecycle | `development governance / kickoff readiness preparation` |
| Status | ADR-TECH-01..06 **`approved`（生效技术契约，decision level，user_confirmed R11 2026-08-16）**; ADR-TECH-07/08 `draft_in_review` / `NOT APPROVED`; **DEVELOPMENT NOT STARTED** |
| Charter boundary | `Development Charter v0.1`, `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY` |
| Kickoff state | `not_ready`; Gates 0–6 `not_run / not_ready` |
| Evidence class | `static/source` only |
| Date authority | No calendar date inferred in this artifact |

### 1.1 Scope and authority firewall

The Charter authorizes governance preparation and static readiness work only. It does not authorize Godot/GDMCP access or mutation, code, scenes, resources, assets, build, runtime execution, tests, QA execution or acceptance, performance measurement, export, release, staffing kickoff execution, or milestone/cost/platform commitments. This package therefore contains no implementation, no engine claim, no measured budget, and no acceptance verdict.

The package is a recommendation from the Tech Lead. `candidate`, `team_proposal`, and `unresolved` remain distinct from `user_confirmed`. A proposed ADR becomes effective only after the appropriate review and authority decision. A product, platform, major scope, architecture-risk, acceptance-threshold, or release crossing requires a Change Request and returns to the User for decision or Charter reauthorization. Silence is never approval.

### 1.2 Provenance and evidence boundary

Permitted static inputs read for this package:

- `docs/DEVELOPMENT_CHARTER_DRAFT_v0_1.md` — canonical `Development Charter v0.1`, current authorization and governance boundary.
- `docs/creative/GDD_SLICE_v0_1.md` — canonical static design baseline; no runtime/QA claim.
- `docs/creative/SLICE_RULES_DECISION_v0_1.md` — current user-confirmed rules record and retained history.
- `docs/creative/SLICE_PRECHARTER_DECISIONS_v0_1.md` — `PRECHARTER-01..11` decision packet.
- `docs/creative/CREATIVE_BRIEF_v0_1.md` — creative direction and player-promise boundary.
- `docs/DISCOVERY_HANDOFF.md` — historical Discovery provenance and Direction A handoff.

Four provenance layers remain active and are not re-decided here:

1. **`user_confirmed`** — explicit owner choice; retained as a candidate Charter constraint, not implementation evidence. **R11（2026-08-16）adds the explicit user decision approving ADR-TECH-01..06 as decision-level technical contracts（status-line update）; this is `user_confirmed` for the ADR status only — it does not turn any `team_proposal` / `unresolved` rule detail into a confirmed value, and it is not implementation authorization.**
2. **`team_proposal`** — specialist recommendation; never silently promoted.
3. **`assumption`** — expectation requiring observation.
4. **`unresolved`** — deliberately open detail, value, algorithm, threshold, or authority question.

Static documents prove only that these records and boundaries exist. They do not prove architecture safety, gameplay correctness, readability, determinism in execution, performance, export, or release readiness.

### 1.3 Retained decision inputs (not re-decided)

This package explicitly preserves the **22 original `user_confirmed` decisions** recorded in `SLICE_RULES_DECISION_v0_1.md §13.2` / `GDD_SLICE_v0_1.md §9.1`, including movement-only, keyboard boundary, pre-fire target refresh, contact safety, result/restart, piercing and three-arc independence, bounded cards, pause/recovery, in-run intermediary only, pressure/recoverable route, victory/defeat tone, fixed structure with light randomness, B2 HUD, causal hint, hint timing, card input path, 16:9/widescreen baseline, basic accessibility, strict cap/exclusions, candidate performance direction, and separate Charter authorization.

It also preserves all **8 revision-02 decision packet inputs** in the Charter: candidate architecture boundary; QA/debug-only fixed tick/seed/snapshot/trace; pre-fire nearest-threat cluster refresh and locked shot snapshot; high-level safety and terminal boundaries; formal playability observation gate candidate; candidate performance set; PC-first/keyboard/16:9/accessibility direction; and the governance-only Charter authorization. Their unresolved fields remain unresolved.

It preserves **`PRECHARTER-01..11`** exactly as inputs: determinism; target ordering; contact legality; range/starting-point tuning; upgrade timing candidates and order; persistent HUD; causal hint; card information structure; focus-loss safety; candidate performance budgets; and same-frame life-depletion precedence. No item is promoted by this document.

The Discovery direction, Creative Brief player promise/pillars, GDD slice intent, and the current Charter are provenance layers and constraints, not invitations to add content or invent mechanics. `DISCOVERY_HANDOFF.md` historical unresolved items remain historical unless explicitly narrowed by later user-confirmed records.

## 2. Expert preflight and technical blast radius

- **Architecture context read:** the six permitted static inputs listed above; no project code, Godot project, scene, resource, asset, GDMCP state, build, or runtime was read.
- **Blast radius:** rules/state vocabulary, session lifecycle, attack targeting, upgrade transaction, input focus safety, presentation read model, reset arbitration, deterministic fixtures, future build/config identity, and QA evidence indexing. Systems/Rules and UX/UI contracts are direct dependencies.
- **Decisions to be made:** candidate module seams and future verification interfaces, not product rules or exact constants.
- **Assumptions:** a pure rules seam can be specified without selecting an engine implementation; session owns run identity; adapters translate rather than author rules; future evidence can compare snapshots/traces.
- **Top risks:** unresolved target semantics; sticky contact/re-arm; stale input after focus loss; same-tick terminal ambiguity; premature constants; trace/schema incompatibility; presentation becoming a second rules engine; platform commitments hidden in build configuration.
- **Required future evidence:** authorized implementation, deterministic fixtures, snapshots/traces, focus/reset scenarios, build/config identity, and Independent QA/Release observation.
- **Decision boundary:** Tech Lead proposes the technical “how”; User retains product and architecture-risk crossings; Director retains creative coherence; Systems/Rules owns rules meaning; UX/UI owns interaction/readability proposal; Producer sequences and governs; Independent QA/Release accepts or blocks.
- **Stop condition:** stop drafting and escalate via Change Request if a proposal changes player promise, immutable Charter scope, platform, major architecture risk, acceptance threshold, or release commitment; stop implementation planning while required contracts or authority are missing.

## 3. Candidate contract map

The candidate dependency direction is inward: `adapter/presentation → session → rules core`; rules core remains engine-free, UI-free, and skill-free. Session owns run lifecycle and deterministic context. Adapters translate engine/input/time into domain inputs and translate domain outputs into presentation. Presentation consumes a read model and emits user intent; it does not mutate rules directly.

This is a candidate boundary, not an approved architecture. Persistence is not proposed as a Slice feature; any future persistence would require a Change Request and User decision. The package does not prescribe internal code structure.

| Seam | Proposed responsibility | Must not own | Required future evidence |
|---|---|---|---|
| Rules core | Pure state transition and rule evaluation | Godot nodes, rendering, input devices, persistence | Fixture input/output comparison |
| Session | Run identity, tick/seed context, lifecycle, reset ownership | UI layout, balance promotion, acceptance | Repeated run and reset trace |
| Adapter | Translate engine/input/time and route outputs | New gameplay semantics | Adapter contract tests |
| Presentation/read model | Derive player-facing state, focus/feedback intents | Rule mutation or hidden targeting | State/aspect observation |
| Evidence seam | Snapshot/trace/fixture/build identity | Product acceptance | Auditable evidence index |

## 4. ADR-TECH-01 — Candidate rules/session/adapter/presentation boundary

**Status:** **`approved`**（user_confirmed，R11，2026-08-16；DC-ARCH-01 A1 + AUTH-01 P2）。**生效技术契约（decision level）；≠ 实现授权**——implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`。总状态由 `PROPOSAL / DRAFT / NOT APPROVED` 升级为「TECH-01 已批准（生效契约）」，本体为生效技术契约。

### Context

The user-confirmed candidate boundary is `rules core + session + adapter/presentation`. The Slice needs movement, automatic attack, contact, two upgrade pauses, outcomes, and restart while preserving a low-cognition player promise. Cross-role implementation will be unsafe if rules, lifecycle, engine integration, and presentation semantics are mixed.

### Candidate decision

Draft four separable responsibilities:

1. **Rules core:** deterministic, side-effect-free evaluation of domain inputs against domain state; owns rule outcomes, target snapshot interpretation, contact legality, upgrade eligibility, and terminal arbitration once Systems/Rules meanings are specified.
2. **Session:** owns one run's identity and lifecycle, tick/seed/config context, reset transaction, and the boundary at which a rules step is evaluated.
3. **Adapter:** maps engine clock/input/collision observations into domain inputs and maps domain outputs to engine-facing effects. It cannot silently add game rules.
4. **Presentation:** consumes a read model and explicit interaction intents for HUD, hint, cards, result, focus, and feedback. It cannot become a second rules implementation. **Presentation responsibility additionally derives the accessibility-visible face (non-color communication, frozen/disabled states, focus visibility — per UX contract §7 / decision #19) and the no-target / feedback-binding face (a no-target branch exposes an observable "no valid target this shot" signal and binds hit-class feedback to `hit_results`, so an empty shot does not fabricate a lock indicator or a phantom hit — per UX review R1 / UX-03 S1/S2).** Read-model fields and their accessibility/no-target mapping remain unresolved until UX/Systems co-own the exact field set.

### Candidate alternatives / anti-proposals

- **Monolithic scene/controller:** rejected as a draft direction because rules, engine state, and presentation become inseparable and headless comparison is weakened.
- **UI-owned gameplay state:** rejected because presentation would become authoritative and focus/presentation changes could alter rules.
- **Engine-physics-authoritative rules:** retained only as a future alternative requiring evidence; it risks hidden timing and poor deterministic comparison.
- **Premature generic ECS/service framework:** not proposed for this bounded Slice; speculative abstraction could expand scope without evidence.

### Consequences

Positive expectation: systems can review rule vocabulary independently; engineering can implement against seams; QA can compare pure fixtures and session traces; UX can consume stable read-model fields. Costs: explicit data translation, schema versioning, and discipline against adapter leakage. Targeting, collision, timing, and upgrade semantics remain unresolved until Systems/Rules and UX/UI contracts are reviewed.

### User-reserved architecture risk

The User must decide any alternative that crosses the candidate boundary, changes product promise or Slice cap, introduces persistence, changes platform assumptions, or materially increases architecture scope. This ADR does not approve the boundary.

### Draft acceptance / stop condition

Ready to advance only when Systems/Rules defines rule meanings, UX/UI defines presentation/interaction needs, Producer records dependencies, and Independent QA/Release confirms evidence fields are auditable. Stop on hidden rule ownership, circular dependency, missing headless seam, or architecture-risk crossing.

### 评审状态与跨角色依赖（draft advancement, 2026-08-16）

- **Draft status:** `approved`（user_confirmed，R11，2026-08-16）— **生效技术契约（decision level）**；批准使本 ADR 生效，**≠ 实现授权**（implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`）。(Systems review `align` 2026-08-16 + UX review `align`/R1–R2 integrated; no unresolved blocker.) Owner: Tech Lead; User for architecture-risk crossing.
- **Cross-role dependencies:**
  - Systems/Rules — `in_flight` (rules-meaning inputs; cr-001 decided to `user_confirmed` but exact cluster/metric/tie semantics remain unresolved, deferred to cr-002..005). **Systems review input `ADR_REVIEW_SYSTEMS_INPUT_v0_1.md` recorded `align` for ADR-TECH-01 (no blocker) and serves as the Systems rules-semantics review carrier; the `PROPOSALS_CR002_004_005_v0_1.md` rules-meaning source is now in-repo (see ADR-TECH-04).** Tech does not proxy Systems semantics.
  - UX/UI — **provided by `ADR_REVIEW_UX_INPUT_v0_1.md` (2026-08-16, `align` + R1–R2 integrated)**: presentation responsibility now includes the accessibility face and the no-target/feedback-binding face (R1); UX observation-relevance for read-model fields links to the UX-01..13 evidence matrix (B3 traceability). Exact read-model field values remain `unresolved` and co-owned with UX/Systems.
  - Producer dependency record — `in_flight` (CR ledger §7 sequencing already records dependency-first batching).
  - Independent QA — `not_run / not_ready`; QA evidence-field audit deferred to Gate-2 planning.
- **Advancement action taken:** reviews/session/adapter/presentation seam candidate retained; presentation responsibility complemented with accessibility + no-target/feedback-binding face (UX R1); UX dependency status moved to "provided by review input" (UX R2); draft complements (boundary, purity, evidence seam) inherited from ADR-TECH-02/06. No boundary approved.

## 5. ADR-TECH-02 — Purity, lifecycle ownership, and presentation read model

**Status:** **`approved`**（user_confirmed，R11，2026-08-16；DC-ARCH-01 A1 + AUTH-01 P2）。**生效技术契约（decision level）；≠ 实现授权**——implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`。总状态由 `PROPOSAL / DRAFT / NOT APPROVED` 升级为「TECH-02 已批准（生效契约）」，本体为生效技术契约。

### Proposed contract

- **Rules purity:** a rules step accepts a versioned domain input envelope plus prior domain state and returns a new state plus domain events/diagnostics. It must not read wall-clock time, device state, scene tree, UI controls, or global mutable randomness.
- **Session lifecycle:** Session is the sole owner of run start, active/paused/result/reset lifecycle and run identity. It supplies the evaluation context and owns one canonical restart path. Exact state names and transition timing remain subject to Systems/Rules and UX/UI review.
- **Run ownership:** one active session owns one run; adapters may request intents but cannot create a second authoritative run or bypass reset arbitration.
- **Presentation read model:** presentation receives a derived, versioned read model containing only player-facing state and permitted interaction affordances: life, timer, B2 phase, hint visibility, upgrade cards/focus, result state, player/danger/space cues, **no-target branch / attack-resolution state**, **feedback-binding marker (feedback class ↔ `hit_results`)**, **accessibility-derived state (frozen/disabled/non-color/focus-visible)**, and **hint valid-move association (candidate/order-change observable)**, as later defined. Exact fields, layout, copy, and thresholds are unresolved. Read-model fields carry only the presentation-facing subset; internal stable-ordering detail lives in ADR-TECH-03/04 trace fields, not this model (UX review R3/R4 note).
- **Feedback causality:** domain events may be rendered as feedback, but presentation must not infer a new rule from visual state. **Empty-shot non-forgery (UX review R4 / UX-03 S1/S2): presentation emits lock-indicator / hit / kill feedback classes only when `hit_results` is non-empty; a no-target (empty) shot emits no fabricated lock targeting or hit feedback, and may only surface an optional non-color "no target" cue bound to the no-target branch — never a phantom hit.**

### Consequences / open questions

Purity makes headless fixture comparison possible and prevents UI focus or engine callbacks from changing rules. Session ownership gives reset and same-tick arbitration one home. A read model prevents UI from reaching into mutable domain objects, but requires explicit mapping and version compatibility. Exact event ordering, read-model schema, and adapter error behavior are unresolved.

### Stop condition

Stop if any adapter or presentation path becomes an unrecorded rules authority, if session lifecycle is split across owners, or if a required player-visible field cannot be traced to an authorized rule/read-model contract.

### 评审状态与跨角色依赖（draft advancement, 2026-08-16）

- **Draft status:** `approved`（user_confirmed，R11，2026-08-16）— **生效技术契约（decision level）**；批准使本 ADR 生效，**≠ 实现授权**（implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`）。(Systems review `align` 2026-08-16 + UX review `revise-needed`→resolved by R3–R5 integration 2026-08-16; no unresolved UX blocker after read-model field supplement.) Owner: Tech Lead + Systems/Rules + UX/UI.
- **Cross-role dependencies:**
  - Systems/Rules — `in_flight`: rules-layer contract change notification order is Systems → Engineer → QA; exact read-model fields are Systems/UX co-owned and remain unresolved.
  - UX/UI — **provided by `ADR_REVIEW_UX_INPUT_v0_1.md` (2026-08-16, `revise-needed` weak-block resolved)**: read-model field list (R3) supplemented with no-target/attack-resolution, feedback-binding, accessibility frozen/disabled/non-color, and hint valid-move association; empty-shot non-forgery clause (R4) added; UX field-list status per R5 moved from `in_flight/missing` to "provided, to be merged into the approved contract". Layout, copy, thresholds remain unresolved; UX does not become gameplay authority.
  - Headless seam (ADR-TECH-06) — `dependency-blocked` until fixture schema + build/config identity exist.
- **Advancement action taken:** purity + session-ownership + read-model contract retained as candidate; read-model field list extended per UX R3 and empty-shot non-forgery clause added per UX R4; inherited already-decided P1 (single Windows x86_64 target narrows window/HiDPI read-model surface) and B3 evidence-tightening (read-model fields must trace to authority). No purity/ownership contract approved.

## 6. ADR-TECH-03 — Determinism, reproducibility, and trace scope

**Status:** **`approved`**（user_confirmed，R11，2026-08-16；DC-ARCH-01 A1 + AUTH-01 P2）。**生效技术契约（decision level）；≠ 实现授权**——implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`。总状态由 `PROPOSAL / DRAFT / NOT APPROVED` 升级为「TECH-03 已批准（生效契约）」，本体为生效技术契约。

### User-confirmed boundary retained

Fixed tick, seed, snapshots, and constrained light randomness are promised only for **QA/debug reproducibility**. There is explicitly **no player-visible Replay promise** in this package or the Charter inputs.

### Candidate contract

- **Tick:** a single fixed-step evaluation boundary; exact frequency remains unresolved and must be selected with Systems/Rules and returned to User if it affects product/performance scope.
- **Seed/RNG:** one session-owned seed context; random draws must be named, ordered, and bounded. Exact initialization, streams, and permitted ranges remain unresolved.
- **Snapshot:** versioned state capture at a future-defined cadence, including enough state to compare deterministic fixtures. Snapshot storage, cadence, compression, and retention remain unresolved.
- **Trace:** append-only diagnostic records for inputs, tick, rule transitions, target snapshot, random draw identifiers, upgrade/reset/terminal events, and config identity. Exact schema and verbosity remain unresolved.
- **Stable ID:** every traceable actor/target/event subject receives a stable run-scoped identity; lifecycle allocation, reuse, and serialization remain unresolved.
- **Config version:** every future snapshot/trace/fixture carries a configuration schema/version identity. Migration policy is unresolved; incompatible data must fail loudly rather than silently compare.
- **Scope:** reproducibility is a QA/debug seam, not replay storage, sharing, spectator mode, rewind, or player-facing history.

### Alternatives and consequences

A wall-clock/random-global design is not proposed because it weakens repeatability. Full player Replay is explicitly not selected: it would add product promise, storage, compatibility, and UI scope. The candidate seam adds instrumentation and schema maintenance but enables diagnosis and independent comparison. Determinism still requires implementation and QA evidence; this ADR cannot claim it.

### Stop condition

Stop on unowned random sources, unstable IDs, missing config identity, silent schema mismatch, or any attempt to market/implement player-visible Replay without a Change Request and User decision.

### 评审状态与跨角色依赖（draft advancement, 2026-08-16）

- **Draft status:** `approved`（user_confirmed，R11，2026-08-16）— **生效技术契约（decision level）**；批准使本 ADR 生效，**≠ 实现授权**（implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`）。(Systems review `align` 2026-08-16; no unresolved blocker. Reproducibility remains an untested goal, not a claim — implementation + QA evidence required before any reproducibility assertion.) Owner: Tech Lead + Systems/Rules.
- **Cross-role dependencies:**
  - Systems/Rules — `in_flight`: tick/seed/snapshot/trace exact semantics and the B2 multi-arc intra-step ordering decision (mechanism open choice per `DC_SYS_01_TECH_INPUT §2.5`) co-owned with Systems; exact tick frequency remains unresolved and returns to User if it affects product/performance scope (cr-020).
  - cr-203 (Replay) — record retained (2026-08-16): QA/debug-only reproducibility is candidate-confirmed; **player-visible Replay explicitly absent**. Any player-visible Replay proposal → CR + User.
  - QA/Release — `not_run / not_ready`; reproducible-fixture design + QA repeatability review deferred.
- **Advancement action taken:** tick/seed/snapshot/trace/stable-ID/config-version candidate and deterministic-seam scope retained; reproducibility equality (`config_version + seed + versioned input + build identity ⇒ elementwise-same order/snapshot/events` from `DC_SYS_01_TECH_INPUT §2.6`) integrated as a feasibility input. No determinism claim is made — implementation + QA evidence required before any reproducibility assertion.

## 7. ADR-TECH-04 — Target snapshot contract

**Status:** **`approved`**（user_confirmed，R11，2026-08-16；core semantics retained, exact mechanism details remain `unresolved` per cr-002..005 Systems/UX in_flight）。**生效技术契约（decision level）；≠ 实现授权**——implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`。总状态由 `PROPOSAL / DRAFT / NOT APPROVED` 升级为「TECH-04 已批准（生效契约）」，本体为生效技术契约。

### Required high-level semantics

Immediately before each fire, refresh the nearest-threat cluster. Use the candidate ordering `nearest threat → cluster-center distance → stable candidate ordering/stable ID`. Lock that shot's target snapshot after refresh; the shot does not continuously retarget. If no valid target exists, take an explicit no-target branch rather than fabricating a target. Removed/invalid targets must not be applied as valid hits. Each arc counts independently under the user-confirmed piercing boundary.

### Candidate contract fields

A future target snapshot/trace should carry: `run_id`, `tick`, `config_version`, `shot_id`, `attack_id`, `arc_id`, candidate IDs, validity status, cluster reference, ordering keys, chosen/locked IDs, no-target reason, refresh timestamp/tick, lock timestamp/tick, invalidation reason, and resolution outcome. Field names are proposal-level.

### Unresolved detail register

Cluster definition; distance metric and quantization; tie-break fields; stable-ID lifecycle; invalidation timing; target removal during a shot; exact no-target cycle timing; fire/refresh timing; arc geometry; duplicate-hit policy; shared target policy; attenuation and hit budget; and whether diagnostics expose all candidates or only selected IDs remain unresolved. These must not be hardened by implementation convenience.

### Alternatives / consequences

Continuous retargeting is not proposed because it weakens movement-to-next-shot causality and auditability. Arbitrary list order is not proposed because it is nondeterministic. Stable snapshot locking improves causal readability and fixture comparison, at the cost of explicit invalidation and trace data.

### 评审状态与跨角色依赖（draft advancement, 2026-08-16）

- **Draft status:** `approved`（user_confirmed，R11，2026-08-16）— **生效技术契约（decision level）**；批准使本 ADR 生效，**≠ 实现授权**（implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`）。批准不改变 cr-002..005 的 `unresolved` 语义（Systems/UX 候选语义源仅挂钩、未批准）。(Systems review integrated 2026-08-16: Block A adopted → proposal-in-repo + candidate semantics hooked; no unresolved blocker.) Owner: Tech Lead + Systems/Rules.
- **Decided input integrated (2026-08-16, R09):** cr-001 → DC-SYS-01 → Option A `user_confirmed`. Ordering key chain confirmed = `nearest threat → cluster-center distance → stable order / stable ID`. Crucially, per `DC_SYS_01_TECH_INPUT §2.2`, "stable" must be read as a **total-order key chain on a copy-derived ordered-ID list** (deterministic across runs), not preservation of engine container insertion order; sorting must avoid float equality and must not sort engine containers in place. These are mechanism constraints (Tech), not rule semantics (Systems).
- **Cross-role dependencies (review-integrated, 2026-08-16):** Systems/Rules semantics for cluster membership, metric/quantization/tie-break fields, stable-ID lifecycle, invalidation timing, no-target resolution (cr-002..005) remain `unresolved`, co-owned by Systems + UX/UI. **The Systems proposal artifact `PROPOSALS_CR002_004_005_v0_1.md` is now `in_repo` (v0.1, `docs/production/`), status `in_flight`, pending Systems rules-semantics confirmation.** The `PROPOSALS_CR002_004_005_v0_1.md file absent 2026-08-16` mark is **retracted and superseded by this review-integration pass** per Systems review Block A (`ADR_REVIEW_SYSTEMS_INPUT_v0_1.md §3`). The Systems proposal is now **explicitly hooked as the candidate semantic source for ADR-TECH-04**: M-1 (cr-002 discrete two-scalar key-chain distance = `k1_bucket` nearest-threat → `k2_bucket` cluster-center → `stable_id` final order), (i) snapshot-authoritative invalidation (cr-004), and quiet-cycle no-target form (cr-005). These are **candidate semantic sources only — NOT approved**; cr-002/004/005 remain `unresolved` (`team_proposal`, `absorb_within_authority`) until evidence + review + User confirmation. Tech records the mechanism seam feasibility; it does not assert the metric/quantization/quiet-cycle semantics as settled. bucket width remains a ledger rule parameter, not a performance budget — if any value is promoted to a Gate/release criterion it must return via CR + User (§14). ADR-TECH-04's stop conditions remain live and none are waived.
- **Advancement action taken:** snapshot-lock ≠ live-retarget, explicit no-target branch, removed/invalid-targets-must-not-hit, and per-arc independence candidate retained; the five determinism disciplines (total-order keys, no in-place sort, float-safe buckets, comparator purity, deterministic input premise) from `DC_SYS_01_TECH_INPUT §2.2–§2.6` are recorded as mechanism feasibility inputs; Systems review Block A adopted — proposal-in-repo mark + M-1/(i)/quiet-cycle hooked as candidate semantics (not approved). No snapshot contract approved; stop conditions (target changing after lock without explicit contract, implicit no-target, container-order-dependent tie, promise-crossing sorting) remain in force.

### Stop condition

Stop if a target can change after lock without an explicit contract, if no-target behavior is implicit, if tie resolution depends on container order, or if the algorithm changes the player promise and has not returned through Change Request/User authority.

## 8. ADR-TECH-05 — Contact/re-arm, upgrade transaction, focus epoch, terminal arbitration/reset

**Status:** **`approved`（机制边界）**（user_confirmed，R11，2026-08-16；DC-ARCH-01 A1 + AUTH-01 P2）。**批准机制边界**（contact 单次伤害+轻分离、升级事务两阶段、focus epoch 拒陈旧、同帧生命优先），**精确数值语义延后**（cr-006..020 Systems 契约 in_flight）。**生效技术契约（decision level）；≠ 实现授权**——implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`。总状态由 `PROPOSAL / DRAFT / NOT APPROVED` 升级为「TECH-05 机制边界已批准（生效契约；精确数值语义延后）」，本体为生效技术契约。**跨角色依赖：Systems/Rules 契约（contact/upgrade/reset 精确语义，cr-006..020 仍 in_flight）+ UX/UI 交互契约（focus epoch / 失焦安全定义）——由父协调器协调**。

### Contact and re-arm

One legal contact produces one damage event, brief invulnerability, and slight separation. No repeat damage occurs during invulnerability. Re-contact becomes legal only after separation. Contact duration, separation distance/direction, invulnerability duration, damage, stacking, simultaneous contacts, and boundaries remain unresolved.

### Upgrade transaction

The transaction is: guarantee trigger → full combat pause → valid stage-appropriate choice → selected/acquired feedback → combat resume. First stage is `穿透`, second is `扇裂`; each presents three same-keyword variants; no skip/reroll. Exact trigger, XP source/values, card data, pause scope, feedback duration, cancellation, and recovery timing remain unresolved.

### Focus-loss epoch/buffer

On focus loss, immediately freeze combat and upgrade confirmation, preserve focus/selection, reject stale `Enter/Space`, and require a fresh explicit legal input after return. Candidate mechanism: associate input events with a focus/input epoch; increment epoch on loss and again at resume boundary, discard buffered confirmation events from prior epochs, and accept only newly observed legal input. This is a mechanism proposal, not a frozen implementation contract. Exact flushing, movement buffering, platform event policy, return-focus behavior, and messaging remain unresolved. **UX review R6 (2026-08-16) marks combat-freeze scope, return-focus target, and platform event policy as `unresolved` pre-prerequisites of the UX-06/07/08 observation targets (focus-loss combat freeze / focus-loss card-choice retention / fresh-epoch + stale-rejection), aligned with the UX contract §9 evidence matrix and cr-012/013 — they remain open and are not settled by this ADR.**

### Same-tick terminal arbitration and reset

Life depletion takes priority over eight-minute completion when both occur in the same tick. Candidate order is: evaluate legal events → arbitrate terminal outcome → enter result/input lock → emit short clear result → run one canonical automatic reset. Exact intra-tick ordering, simultaneous damage/completion semantics, result duration, cleanup list, RNG/ID reset, and stale-input rejection remain unresolved.

### Consequences / stop condition

These boundaries protect recoverable spacing, safe upgrades, and deterministic result identity. Stop if contact can become sticky/punitive, an upgrade can confirm from stale input, terminal priority varies by callback order, or reset leaves session state, IDs, RNG, focus, or input dirty. Any product-visible timing or threshold decision remains User/System-owned as applicable.

### 评审状态与跨角色依赖（draft advancement, 2026-08-16）

- **Draft status:** `approved`（机制边界，user_confirmed，R11，2026-08-16）— **生效技术契约（decision level）**；批准使本 ADR 生效，**≠ 实现授权**（implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`）。**精确数值语义延后**（contact/upgrade/reset 精确语义仍 `unresolved`，Systems 契约 in_flight，cr-006..020）。(Systems review `align` 2026-08-16 + UX review `align`/R6–R7 integrated + Systems Block A note confirming cr-002/004/005 do not touch contact/upgrade/reset semantics; no unresolved blocker from Systems/UX on the mechanism boundary.) Owner: Tech Lead + Systems/Rules + UX/UI.
- **Cross-role dependencies (parent-coordinated):**
  - **Systems/Rules contract** (contact legality, upgrade trigger/transaction, terminal ordering) — `in_flight`; Systems review `align` (2026-08-16) confirms the `PROPOSALS_CR002_004_005_v0_1.md` target-semantics source does **not** cover contact/upgrade/reset semantics (cr-006..020 remain `unresolved`). Exact contact/upgrade/reset fields stay `unresolved` and co-owned; Tech does not proxy Systems meaning.
  - **UX/UI interaction contract** (focus-epoch / focus-loss safety definition) — **provided by `ADR_REVIEW_UX_INPUT_v0_1.md` (2026-08-16, `align` + R6–R7 integrated)**: focus-epoch aligns with UX contract §4 / PRECHARTER-09 / decision #17; combat-freeze scope, return-focus target, and platform event policy marked as `unresolved` pre-prerequisites of UX-06/07/08 (R6); review status names UX-06/07/08 evidence IDs (R7).
  - cr-012/013 (focus epoch mechanism) — `absorb_within_authority` (Tech mechanism + UX safety meaning + QA observation).
- **Advancement action taken:** contact/re-arm transaction, upgrade transaction (穿透 → 扇裂, three same-keyword variants, no skip/reroll), focus-epoch mechanism proposal, and same-tick terminal arbitration with one canonical reset retained as candidate proposals; UX-06/07/08 prerequisite marking added (R6/R7). None upgraded; all exact values/timings remain unresolved and product-visible timing/threshold decisions remain User/System-owned.

## 9. ADR-TECH-06 — Headless seam and future evidence schema

**Status:** **`approved`**（user_confirmed，R11，2026-08-16；DC-ARCH-01 A1 + AUTH-01 P2）；future implementation prerequisite, not existing implementation。**生效技术契约（decision level）；≠ 实现授权**——implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`。总状态由 `PROPOSAL / DRAFT / NOT APPROVED` 升级为「TECH-06 已批准（生效契约）」，本体为生效技术契约。**跨角色依赖：evidence schema / QA 输入（Evidence schema 合同 + QA 证据字段审计）——由父协调器协调**。

### Future seam proposal

Before implementation, define a headless invocation boundary that accepts a versioned initial snapshot/config, a deterministic input sequence, and a tick budget, then returns final snapshot, ordered trace, domain events, diagnostics, and build/config identity. The seam must be callable without a rendered scene and must not require Godot runtime evidence to compare pure rules behavior. This is a prerequisite proposal, not a claim that such a seam exists.

### Fixture / comparison schema (proposal)

Each future fixture should identify: `evidence_id`, `fixture_id`, `run_id`, seed, tick/config/schema versions, input sequence, initial snapshot, expected snapshot or trace digest, actual snapshot/trace reference, build ID, observer, timestamp, and unresolved deviations. Comparison must distinguish exact mismatch, allowed nondeterministic field, schema incompatibility, and missing evidence. No tolerance or equivalence rule is selected here.

### Future evidence IDs

Evidence IDs should be immutable and linked by the Producer's evidence index to fixture, source/build/config identity, observer, artifact location, and verdict. Future IDs may cover no-target, target ties, removal, contact/re-arm, upgrade pause, focus loss, same-tick terminal arbitration, reset, B2 arc independence, and performance/export records. No IDs are claimed as existing.

### Build/config identity

A future record should include source revision, build mode, config version, platform target if selected, engine/toolchain identity if relevant, seed, fixture, and timestamp. Platform and engine values are intentionally not selected in this static proposal.

### Stop condition

Stop implementation kickoff if no headless seam, fixture schema, config identity, or evidence-index ownership exists; static prose cannot substitute for future evidence.

### 评审状态与跨角色依赖（draft advancement, 2026-08-16）

- **Draft status:** `approved`（user_confirmed，R11，2026-08-16）— **生效技术契约（decision level）**；批准使本 ADR 生效，**≠ 实现授权**（implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`）。批准不执行 Gate/fixture；fixture-schema 决策仍 Systems-owned（cr-110 pending）。(QA review `align` 2026-08-16, `QA_ACCEPTANCE_PLAN_v0_1.md §7`, + notes adopted; no unresolved blocker.) Owner: Tech Lead + future Engineer + QA.
- **Cross-role dependencies (parent-coordinated):**
  - Evidence schema / QA input — `in_flight` / **QA review `align` provided by `QA_ACCEPTANCE_PLAN_v0_1.md §7` (2026-08-16)**: `KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md` (five-layer envelope, version/identity rules, exact compare behavior, `schema_incompatible`/`missing_evidence` states) is the adopted Tech-proposed schema source; Independent QA evidence-field/verify-section audit is `not_run / not_ready` and parent-coordinated. **QA notes adopted:** (a) `run_id` is explicitly normalized into the schema (avoids multi-sample context ambiguity under one `evidence_id`); (b) the **raw trace/snapshot retention contract** (constitution/format/link/retention location) is marked a **finalize-in-approval-path item**, not asserted as satisfied here; (c) **fixture expected-facts semantic ownership belongs to Systems** (cr-110 pending) — Tech/QA do not assert the domain expectation semantics. The fixture-schema decision remains Systems-owned and not yet supplied.
  - Producer evidence index — future handoff proposal only; not frozen; raw-retention/index finalization is a later approval-path deliverable.
- **Decided inputs integrated:** **cr-113 → DC-REL-01 O2 (evidence-complete release, R07)** — default zero-tolerance evidence discipline adopted for comparison; **cr-114 → DC-ACC-02 B3 (evidence tightening, R06)** — strict evidence-integrity rules; both support the seam's exact-mismatch-only comparison default (variance allowed only under a named authorized deviation).
- **Advancement action taken:** headless seam input/output shape, fixture comparison schema (with explicit `run_id` normalization per QA note), immutable evidence IDs, and build/config identity candidate retained; raw-retention contract and fixture expected-facts ownership flagged as approval-path finalize items (QA notes); the `ordered_candidates(state, params) → ordered_ids` pure-function seam form from `DC_SYS_01_TECH_INPUT §4.2` is recorded as a feasibility input. No seam/fixture/schema approved; static prose is not future evidence.

## 10. ADR-TECH-07 — Performance measurement protocol template

**Status:** `ready_to_draft` candidate → **A1 draft/review 路径中**（DC-ARCH-01 A1 + AUTH-01 P2，2026-08-16）；candidate budgets are not hard gates and have not been measured（六项候选预算未被提升，仍「仅候选，须经 CR + 用户批准才成为正式门槛」；归 DC-PERF-01 / cr-109）。仍未批准；总状态 `PROPOSAL / DRAFT / NOT APPROVED`。

### Retained candidate direction

`1080p/60`, `50 FPS minimum`, input response `≤50ms`, hit-feedback start `≤100ms`, cold start `<3s`, and restart `<1s` remain candidate budgets under the user-confirmed PC-first direction. They are not achieved facts, hard gates, acceptance results, or release commitments.

### Protocol template for future authorized measurement

| Field | Required future entry |
|---|---|
| Evidence ID / fixture | Unique ID and scenario, including peak three-arc case |
| Build identity | Source revision, build mode, config/schema version |
| Hardware | Exact CPU/GPU/RAM/display and power mode |
| OS | Named OS/version; not selected by this package |
| Settings | Resolution, renderer/settings, window mode, VSync/frame cap and other relevant settings |
| Scenario | State, enemy density, arcs, effects, input path, startup/restart boundary |
| Sampling | Warm-up, duration, sample rate, frame-time/raw input timestamps |
| Statistic | Average plus declared percentile(s), min/max and dropped samples |
| Clock authority | Monotonic clock and timestamp authority to be selected/documented |
| Input method | Definition of input-to-observed-state latency |
| Feedback method | Definition of hit-feedback start timestamp |
| Independent observer | QA/Release identity and review status |
| Result | Candidate comparison only until User/Charter decision |

Hardware, OS, settings, percentile, timestamp authority, sample window, and measurement authority are **user-reserved or unresolved**. Tech Lead may propose a protocol; Tech Lead cannot declare the budget met. Independent QA/Release owns acceptance and Producer cannot waive a blocker.

### Stop condition

Stop measurement claims when any required identity or raw sample is missing, when a candidate number is treated as a hard gate without a named decision, or when scope/platform changes are needed to meet it without Change Request/User review.

### 评审状态与跨角色依赖（draft advancement, 2026-08-16）

- **Draft status:** `draft_in_review` — **`PROPOSAL / DRAFT / NOT APPROVED`**; not approved/frozen/effective. Owner: Tech Lead; User for hard-gate choice; QA acceptance.
- **Decided input (2026-08-16, R04):** **DC-PERF-01 → Option A** — all six candidate budgets remain **candidate only** ("仅候选，须经 CR + 用户批准才成为正式门槛"). cr-107 (named hardware baseline) and cr-108 (sampling method / percentile / clock authority) advance **as measurement identity (protocol), not as thresholds** (Tech proposal + QA audit). Gate 2/4 measurement authorization is still `NOT_AUTHORIZED`.
- **Cross-role dependencies:**
  - QA/Release audit — `in_flight`: measurement-protocol audit input points are marked in the new `PERF_MEASUREMENT_PROTOCOL_v0_1.md`; QA evidence-field audit not yet run.
  - Systems/UX — measurement scenario inputs (density, arcs, input path, startup/restart boundary) co-owned; not yet supplied.
- **Advancement action taken:** the measurement protocol template in this ADR was expanded into a standalone draft `PERF_MEASUREMENT_PROTOCOL_v0_1.md` (cr-107/108). Candidates were **not** promoted to thresholds; the `1280×720` red line remains candidate-only. No performance number is measured, achieved, or gate-frozen.

## 11. ADR-TECH-08 — Export/build identity boundary

**Status:** `ready_to_draft` candidate → **A1 draft/review 路径中**（DC-ARCH-01 A1 + AUTH-01 P2，2026-08-16）。已接收 Batch 1 决策输入：DC-PLAT-01 → P1（Windows x86_64 单一导出 + artifact digest / build identity；本期不发布），cr-112 激活 target 身份字段提案；未变更本 ADR 正文的平台/分辨率承诺语义（不新增 P1 之外的附加承诺）。仍未批准；总状态 `PROPOSAL / DRAFT / NOT APPROVED`。

A future build/export artifact should carry source revision, named build/profile, configuration/schema version, fixture/seed where applicable, toolchain/engine identity where relevant, timestamp, artifact digest, and target identity. This supports traceability between fixtures, runtime observations, performance samples, and export smoke evidence.

This ADR intentionally does **not** choose an OS, renderer, export target, release platform, minimum resolution, or distribution channel. The current direction is PC-first with keyboard and 16:9/common-widescreen readability only. Any platform or release commitment returns to the User through Change Request and may require Charter reauthorization. Export evidence is future `export/release` evidence, not present evidence.

**Stop condition:** no export/release claim without a named target decision, build identity, artifact, launch result, and Independent QA/Release review.

### 评审状态与跨角色依赖（draft advancement, 2026-08-16）

- **Draft status:** `draft_in_review` — **`PROPOSAL / DRAFT / NOT APPROVED`**; not approved/frozen/effective. Owner: Tech Lead + Toolchain future; User for platform/release. This ADR intentionally does not choose an OS/renderer/export target/release platform/distribution channel.
- **Decided inputs integrated:**
  - **DC-PLAT-01 → P1 (R01):** `Windows x86_64` single export + artifact digest / build identity; **no release this period** (Gate 6 = internal review posture). This narrows the build-identity surface without adding any commitment beyond P1.
  - **cr-112 (build identity, P1-activated):** target identity field active (Tech + Toolchain proposal); measurement-build and log identity need `settings`/hardware/OS rows (feeds cr-108).
- **Cross-role dependencies:** Toolchain Engineer (reporting under Tech Lead umbrella) proposes identity implementation; cannot select a release platform without User authority. Independent QA reviews export evidence; static text passes no export/release gate.
- **Advancement action taken:** source revision / build profile / config–schema version / fixture–seed / toolchain–engine / timestamp / artifact digest / target identity candidate retained. No platform/export/release commitment named; any crossing returns to User via CR and may require Charter reauthorization.

## 12. ADR decision table

| ADR / surface | Current status | Owner | Next evidence / dependency | Stop condition |
|---|---|---|---|---|
| TECH-01 boundary | **`approved`**（user_confirmed，R11，2026-08-16；System aligned + UX aligned/R1–R2，生效技术契约） | Tech Lead; User for architecture-risk crossing | Implementation authorization (NOT_AUTHORIZED); Systems/Rules semantics; Producer dependency record | Hidden rule owner or boundary crossing |
| TECH-02 purity/lifecycle/read model | **`approved`**（user_confirmed，R11，2026-08-16；UX R3–R5 已整合，生效技术契约） | Tech Lead + Systems/Rules + UX/UI | Implementation authorization (NOT_AUTHORIZED); headless seam | UI/adapter becomes rules authority |
| TECH-03 reproducibility | **`approved`**（user_confirmed，R11，2026-08-16；Systems `align`，生效技术契约；复现仍为未验证目标非声明） | Tech Lead + Systems/Rules | Implementation authorization (NOT_AUTHORIZED); authorized fixture and trace design; QA repeatability review | Player Replay implied; unowned RNG/schema |
| TECH-04 target snapshot | **`approved`**（user_confirmed，R11，2026-08-16；Systems Block A 已整合，生效技术契约；cr-002..005 语义仍 `unresolved`） | Tech Lead + Systems/Rules | Implementation authorization (NOT_AUTHORIZED); key-order change → User; cluster/tie/metric/timing fixtures | Implicit no-target or unstable ordering |
| TECH-05 safety/reset/focus | **`approved`（机制边界）**（user_confirmed，R11，2026-08-16；Systems `align` + UX `align`/R6–R7 已整合，生效技术契约；**精确数值语义延后**，Systems contact/upgrade/reset 契约仍 `in_flight`，cr-006..020，跨角色协调） | Tech Lead + Systems/Rules + UX/UI | Implementation authorization (NOT_AUTHORIZED); interaction contract and focus/contact/terminal scenarios | Sticky contact, stale confirm, nondeterministic reset |
| TECH-06 headless seam | **`approved`**（user_confirmed，R11，2026-08-16；QA `align` + notes 已整合，生效技术契约） | Tech Lead + future Engineer + QA | Implementation authorization (NOT_AUTHORIZED); fixture schema (Systems-owned), build/config identity, raw-retention finalize-in-approval-path | No comparison path or missing observer |
| TECH-07 measurement | `user_reserved` for thresholds; protocol `ready_to_draft` → **A1 draft/review 路径中**（2026-08-16） | Tech Lead; User for hard-gate choice; QA acceptance | Named hardware/OS/settings and raw samples | Candidate treated as gate or missing audit fields |
| TECH-08 build/export identity | `user_reserved` for platform → **A1 draft/review 路径中**（2026-08-16）；已接收 P1 输入（Windows x86_64 单包 + artifact digest/build identity；cr-112 激活 target 身份） | Tech Lead + Toolchain future; User for platform/release | Platform decision, artifact identity, export smoke | Unnamed target or release implication |

`ready_to_draft` means suitable for review drafting, not approved. `unresolved` means the detail must remain open. `user_reserved` means only the User may decide the crossing. `dependency-blocked` means a prerequisite contract/evidence owner is missing. **`approved`（user_confirmed，R11，2026-08-16）means the ADR is an effective technical contract at the decision level only; it is NOT implementation authorization — kickoff remains `not_ready`, implementation remains `NOT_AUTHORIZED`; TECH-07/08 remain `draft_in_review` / `NOT APPROVED`.**

## 13. Cross-role dependencies and handoff contracts

### Systems / Rules

Systems/Rules must define the meaning of rule inputs/outputs, target cluster, tie/metric semantics, contact legality, upgrade triggers, B2 independent arc budgets, and terminal ordering. Systems owns rules meaning and balance proposals; it does not promote constants without authority and evidence. Any rules-layer contract change is notified to Systems first, Engineer second, QA third.

### UX/UI

UX/UI must define the presentation/read-model fields needed for HUD, causal hint, card focus/confirmation, focus-loss recovery, accessibility, 16:9/common-widescreen behavior, and result/restart comprehension. UX/UI does not become gameplay authority. Exact copy, layout, thresholds, focus visuals, and platform behavior remain open until reviewed.

### Producer

Producer sequences this package, records dependencies, maintains Change Requests, and protects the Charter. Producer cannot waive an Independent QA/Release blocker, approve product/platform/release crossings, or turn this proposal into an implementation start.

### Future Engineer / Toolchain

Future implementation members receive contracts and constraints only after readiness. They may choose internal structure within approved seams, must preserve traceability, and cannot self-certify. Toolchain identity work remains subordinate to the Tech Lead and cannot select a release platform without User authority.

### Independent QA / Release

QA/Release owns acceptance and blocking for applicable gates. Future acceptance must independently inspect rules fixtures, runtime scenarios, visuals, performance, export, and evidence identity. Static ADR text cannot pass any runtime, performance, export, or release gate.

## 14. Change Request triggers and reapproval rule

Create a Change Request for every new feature, direction change, platform change, scope change, schedule/cost/release commitment, acceptance-threshold change, rule-layer contract change, event-order change, persistence proposal, or architecture boundary change. The CR must record motivation, provenance, alternatives, displaced work, dependencies, risk, evidence impact, owner, and decision authority.

Return to the User for product decision or Charter reauthorization when a change crosses the player promise, immutable Charter decision, major scope, platform, architecture risk, acceptance threshold, or release commitment. No ADR in this package may be used to bypass that route. A later approved ADR must carry its own version, approver/authority, effective boundary, and supersession link.

## 15. Technical risk register and debt candidates

| Risk / debt candidate | Owner | Retirement evidence / condition | Current status |
|---|---|---|---|
| Target cluster/tie semantics undermine movement causality | Tech + Systems | Deterministic no-target/tie/removal fixtures and QA observation | Open |
| Contact re-arm becomes sticky or punitive | Systems + Tech | Overlap/separation/re-contact trace and QA observation | Open |
| Focus-loss stale input confirms upgrade | UX + Tech | Focus-loss scenarios with epoch/buffer evidence and QA | Open |
| Same-tick terminal result differs by callback order | Tech + QA | Deterministic life-depletion-over-victory fixture | Open |
| Candidate constants harden prematurely | Systems + Producer | Range ledger and explicit promotion authority | Open |
| Snapshot/trace schema lacks compatibility identity | Tech | Versioned schema and mismatch behavior | Open |
| Presentation duplicates rule logic | Tech + UX | Read-model contract review and seam comparison | Open |
| Candidate performance budget is unauditable | Tech + QA | Named hardware/settings/raw samples/percentiles | Open |
| Platform assumption becomes release commitment | User + Producer | Named platform decision and reauthorized Charter if needed | Open |

No implementation debt is claimed because implementation has not started. These are readiness risks and future debt-entry candidates, not a completed debt ledger.

## 16. Readiness and closure checklist

- [x] Static Tech proposal only; no implementation, Godot, runtime, build, test, measurement, export, or release action.
- [x] Charter authorization boundary and `kickoff not_ready` retained.
- [x] Candidate rules/session/adapter/presentation boundary recorded without approval claim.
- [x] Purity, lifecycle, read model, determinism, target, safety/reset, headless, performance, and build identity ADR candidates recorded.
- [x] Exact unresolved algorithms, constants, metrics, timing, ID lifecycle, platform, and thresholds remain open.
- [x] 22 original user-confirmed inputs, 8 revision-02 inputs, `PRECHARTER-01..11`, and four provenance layers referenced without re-decision.
- [x] Systems/Rules and UX/UI dependencies and independent QA authority recorded.
- [x] Change Request and User reapproval triggers recorded.
- [x] **A1 draft-advancement applied (2026-08-16):** ADR-TECH-01..08 advanced to `draft_in_review` with per-ADR review status, cross-role dependency state (§18), and integrated already-decided inputs (P1 / A1 / cr-001 key order / DC-PERF-01 Option A / B3 / O2 / cr-203 / cr-112); total status still `PROPOSAL / DRAFT / NOT APPROVED`.
- [x] **Cross-role review-integration applied (2026-08-16):** ADR-TECH-01..06 advanced to `ready_for_approval` — Systems `ADR_REVIEW_SYSTEMS_INPUT` (TECH-04 Block A: proposal-in-repo + M-1/(i)/quiet-cycle candidate semantics hooked), UX `ADR_REVIEW_UX_INPUT` (TECH-01 R1–R2, TECH-02 R3–R5, TECH-05 R6–R7), and QA `QA_ACCEPTANCE_PLAN §7` (TECH-06 run_id/raw-retention/fixture-ownership) all integrated; `ready_for_approval` was a state marker, **not** approval — total status still `PROPOSAL / DRAFT / NOT APPROVED`. TECH-07/08 remain `draft_in_review`.
- [x] **ADR approval status-line synchronization applied (2026-08-16, R11):** ADR-TECH-01..06 status lines updated to **`approved`（user_confirmed，R11，2026-08-16）** in §4–§9 chapter status lines, §12 decision table, and §18 dossier — **effective technical contracts at the decision level only**. TECH-05 is `approved` for its **mechanism boundary** with exact numeric semantics deferred (cr-006..020 Systems contract in_flight). **Approved ≠ implementation authorization**: kickoff still `not_ready`, implementation still `NOT_AUTHORIZED`. TECH-07/08 remain `draft_in_review` / `NOT APPROVED`.
- [ ] **Not performed and not claimed:** designation remains — no new semantics introduced by this status synchronization (only status lines/status annotations changed, ADR body semantics unchanged); implementation start, runtime evidence, QA acceptance, performance measurement, export, and release readiness remain unauthorized and unclaimed.

### Closure statement

This artifact is closure-ready as a **static Tech Lead proposal package with approved decision-level technical contracts**, not as a kickoff approval. **ADR-TECH-01..06 are `approved`（user_confirmed，R11，2026-08-16）— effective technical contracts at the decision level.** TECH-05 is approved for its **mechanism boundary** (contact 单次伤害+轻分离、升级事务两阶段、focus epoch 拒陈旧、同帧生命优先); its exact numeric semantics remain deferred (Systems contract in_flight, cr-006..020). **Approval ≠ implementation authorization**: kickoff remains `not_ready`, implementation remains `NOT_AUTHORIZED`; no candidate budget was promoted; no new semantics were introduced by this status synchronization (only status lines / status annotations changed). TECH-07/08 remain `draft_in_review` / `NOT APPROVED`. This package is not ready to authorize implementation. Any future approval of remaining items or change must be explicit, versioned, provenance-preserving, and authority-correct.

## 17. Role-expert return

```text
Role expert: godot-tech-lead-expert
Architecture context: permitted static documents read (Charter-adjacent list + Systems/UX/QA review inputs + Systems proposals + CR ledger); no code/Godot; blast radius covers rules, session, adapter, presentation, targeting, reset, evidence, performance, and build identity.
ADRs: ADR-TECH-01..06 **`approved`**（user_confirmed，R11，2026-08-16）— effective decision-level technical contracts; TECH-05 mechanism boundary approved (exact semantics deferred, cr-006..020 in_flight); TECH-07/08 remain `draft_in_review` / `NOT APPROVED`. Designation: authority is decision level only — NOT implementation authorization (implementation still `NOT_AUTHORIZED`, kickoff still `not_ready`).
Contracts handed off: pure rules seam, session ownership, adapter boundary, presentation read model (+accessibility/no-target face), target snapshot, safety/reset/focus, deterministic trace, headless fixture (run_id + raw-retention-finalize + Systems fixture ownership), measurement template, build identity.
Risk register: target ties, contact re-arm, stale focus input, same-tick arbitration, schema identity, duplicated UI rules, unauditable budgets, platform drift.
Debt ledger: no implementation debt; readiness risk candidates recorded.
Verification: static/source only; no runtime, build, test, QA, performance, export, or release evidence.
Stop condition: stop on authority crossing, missing dependent contract, hidden rule ownership, or any request to start implementation before readiness.
Closure-ready: yes for approved decision-level technical contracts (TECH-01..06) + static proposal package for the remainder; no for kickoff, further approval, or implementation authorization.
```

## 18. ADR dossier — draft-advancement + cross-role review-integration log (2026-08-16, A1 / DC-ARCH-01 → Option A1)

> Consolidated per-ADR review state and approval status. **ADR-TECH-01..06 are `approved`（user_confirmed，R11，2026-08-16）— effective decision-level technical contracts**; TECH-05 approved for its mechanism boundary with exact numeric semantics deferred. **Approved ≠ implementation authorization**: kickoff remains `not_ready`, implementation remains `NOT_AUTHORIZED`; this approval status is a decision-level contract effect, not an implementation grant and not a QA/production go. **TECH-07/08 remain `draft_in_review` / `NOT APPROVED`**(no approval). `draft_in_review` = reviewed-draft state in the authorized draft → cross-role review → per-ADR approval ladder; `ready_for_approval` = review input integrated, no unresolved blocker (superseded for TECH-01..06 by R11 approval). No Systems/UX/QA verdict is substituted here.

| ADR | Draft status | Total status | Cross-role dependency state | Key decided input integrated | Advancement |
|---|---|---|---|---|---|
| TECH-01 boundary | **`approved`**（R11，2026-08-16） | **EFFECTIVE technical contract (decision level)** | Systems `align` (review input); UX/UI `align`/R1–R2 (review input provided); Producer `in_flight`; QA `not_run` | A1 (boundary stays candidate) | Seam candidate retained + presentation accessibility/no-target face (R1) + UX dep provided (R2); boundary approved as decision-level contract (≠ implementation authorization) |
| TECH-02 purity/lifecycle/read model | **`approved`**（R11，2026-08-16） | **EFFECTIVE technical contract (decision level)** | Systems/UX `in_flight`; UX `revise-needed`→R3–R5 integrated (weak block resolved); headless seam `dependency-blocked` (prerequisite, not a blocking approval issue) | P1; B3 | Read-model fields extended (R3) + empty-shot non-forgery clause (R4) + UX dep provided (R5); approved as decision-level contract (≠ implementation authorization) |
| TECH-03 reproducibility | **`approved`**（R11，2026-08-16） | **EFFECTIVE technical contract (decision level)** | Systems `align` (review input); Systems `in_flight` (tick/seed/B2 arc-order co-owned); QA `not_run` | cr-203 (Replay explicitly absent) | Deterministic-seam + reproducibility-equality retained (approved as decision-level contract; reproducibility still an untested goal, not a claim — ≠ implementation authorization) |
| TECH-04 target snapshot | **`approved`**（R11，2026-08-16） | **EFFECTIVE technical contract (decision level)** | Systems `revise-needed`→Block A integrated (proposal in-repo, candidate semantics hooked — still `unresolved`); UX/UI `in_flight` | cr-001 Option A key order `user_confirmed` | Proposal-in-repo mark retracted + M-1/(i)/quiet-cycle hooked as candidate semantics; TECH-04 approved as decision-level contract; **cr-002..005 semantics NOT approved, remain `unresolved`** (≠ implementation authorization) |
| TECH-05 contact/re-arm etc. | **`approved`（机制边界）**（R11，2026-08-16） | **EFFECTIVE technical contract (decision level)** | Systems `align` (review input; cr-002..005 do not cover contact/upgrade/reset — Systems contract **`in_flight`**, cr-006..020); UX `align`/R6–R7 integrated | — | Contact/upgrade/focus/terminal mechanism boundary approved **with exact numeric semantics deferred** (cr-006..020 Systems contract in_flight); UX-06/07/08 prerequisite marking (R6/R7) retained (≠ implementation authorization) |
| TECH-06 headless seam | **`approved`**（R11，2026-08-16） | **EFFECTIVE technical contract (decision level)** | QA `align` (review input) + notes adopted; Evidence schema `in_flight`; QA evidence audit `not_run`; fixture schema Systems-owned | O2 (zero-tolerance); B3 (evidence tightening) | run_id normalized + raw-retention finalize-in-approval-path + fixture-expected-facts ownership → Systems (QA notes); approved as decision-level contract (does not run Gate/fixture; ≠ implementation authorization) |
| TECH-07 measurement | `draft_in_review` | PROPOSAL / DRAFT / NOT APPROVED | QA audit `in_flight`; Systems/UX scenario inputs not yet supplied | DC-PERF-01 Option A (candidates stay candidate) | Protocol expanded to `PERF_MEASUREMENT_PROTOCOL_v0_1.md` |
| TECH-08 build/export identity | `draft_in_review` | PROPOSAL / DRAFT / NOT APPROVED | Toolchain future; QA export review `not_run` | P1 (Windows x86_64 single export); cr-112 target identity active | Identity candidate retained; no platform commitment |

### 18.1 Assumption sources (recorded, not substituted)

- **Systems (cr-002..005 / contact / upgrade / reset):** `docs/production/PROPOSALS_CR002_004_005_v0_1.md` is **now `in_repo` (v0.1, verified 2026-08-16)** — the earlier "absent" record is retracted by the review-integration pass (Systems Block A). ADR-TECH-04 now cites this artifact as the candidate semantic source (M-1 / (i) / quiet-cycle, `team_proposal`, `unresolved`); ADR-TECH-05's contact/upgrade/reset semantics remain `in_flight` because cr-002..005 do not cover them (cr-006..020 still `unresolved`). Where ADR-TECH-04/05 reference Systems rule meaning beyond these sources, the source is marked `assumption` / parent-coordinated in-flight. **Tech does not author Systems rule semantics.**
- **UX/UI (focus epoch / read-model fields / no-target feedback form / observation goals UX-06..13):** **provided by `docs/production/ADR_REVIEW_UX_INPUT_v0_1.md` (v0.1, 2026-08-16)** for ADR-TECH-01/02/05 (`align`/`revise-needed`→R1–R7). Tech records interaction/focus **mechanism** feasibility only; interaction meaning and observation targets belong to UX/UI, and their exact field/layout/copy/threshold values remain `unresolved`.
- **Independent QA (ADR-TECH-06, evidence/fixture):** **provided by `docs/production/QA_ACCEPTANCE_PLAN_v0_1.md` §7 (v0.1, 2026-08-16)** — `align` with run_id/raw-retention/fixture-ownership notes. Gate 2 evidence-field audit remains `not_run / not_ready`; no QA verdict is claimed or waived.

### 18.2 Advancement boundary

This dossier records the prior advancement of ADR-TECH-01..06 to `ready_for_approval` (A1, cross-role review input integrated 2026-08-16, no unresolved blocker) and now records their **`approved`** status（user_confirmed，R11，2026-08-16）. ADR-TECH-07/08 remain `draft_in_review`（no approval）. **`approved` is a decision-level contract effect only**: it does **not** authorize implementation (still `NOT_AUTHORIZED`), does not advance kickoff (still `not_ready`), does not promote any candidate budget (six + `1280×720` red line remain candidate-only), does not waive QA blockers, does not issue QA verdicts, and does not proxy Systems/UX meaning. TECH-05's exact numeric semantics (cr-006..020) remain deferred to the Systems contract in_flight. Approval was user-confirmed (R11) and is recorded as provenance-preserving and authority-correct; any future change to an approved ADR must be separate, versioned, provenance-preserving, and authority-correct (§14).

### 18.3 Approval record and retained architecture-risk gates (Tech Lead, 2026-08-16)

> **Approval granted via R11（user_confirmed，2026-08-16）** — ADR-TECH-01..06 are `approved` as decision-level technical contracts, per the dependency-first recommended order below. **Approval ≠ implementation authorization** (implementation still `NOT_AUTHORIZED`, kickoff still `not_ready`). The architecture-risk owner gates below remain LARGE for any post-approval change to an approved ADR (§14): they name who must re-decide each crossing.

| ADR | Approved owner (of the approved contract) | Architecture-risk points needing User decision (remain live post-approval) | Notes / residual dependencies |
|---|---|---|---|
| TECH-01 boundary | Tech Lead; **User for any boundary crossing** | Any alternative that crosses the candidate boundary, changes promise/Slice cap, adds persistence, changes platform, or materially widens architecture scope must return to User (§4 User-reserved architecture risk) | Approved (R11); Systems `align` + UX `align`/R1–R2 integrated |
| TECH-02 purity/lifecycle/read model | Tech Lead + Systems/Rules + UX/UI co-own; User only on gateway **if** read-model fields imply product-visible threshold changes | None intrinsic to the contract; read-model field values crossing into product-visible layout/threshold return to User/UX | Approved (R11); reads on UX R3–R5 closure; headless seam (TECH-06) is a prerequisite, not a blocker |
| TECH-03 reproducibility | Tech Lead + Systems/Rules co-own (tick/B2 arc-order); **User if tick frequency affects product/performance scope (cr-020)** | Selecting a tick frequency that changes product/performance scope must return via CR + User (cr-020); "reproducibility" remains an untested goal until implementation + QA evidence | Approved (R11); cr-203 (player Replay) stays explicitly absent |
| TECH-04 target snapshot | Tech Lead + Systems/Rules co-own; **User if the confirmed key order would need to change** | **Any change to the `user_confirmed` key order `nearest threat → cluster-center distance → stable order/ID` (cr-001) = architecture/product crossing → User decision (CR).** M-1/(i)/quiet-cycle values remain `unresolved`; bucket-width as a gate/release criterion → CR + User | Approved (R11); approval of this ADR does **not** approve cr-002/004/005 semantics — they remain `unresolved` |
| TECH-05 safety/reset/focus | Tech Lead + Systems/Rules + UX/UI co-own; User/System-owner on product-visible timing/threshold | **Systems contact/upgrade/reset contract is still `in_flight` (cr-006..020)** — approval covers only the mechanism boundary; exact numeric semantics remain deferred; UX-06/07/08 prerequisites remain `unresolved` | Approved as mechanism boundary (R11); exact semantics deferred to Systems contract |
| TECH-06 headless seam | Tech Lead + future Engineer + QA; **User not needed unless fixture-schema/build identity crossing into platform/release** | fixture-schema decision is **Systems-owned** (cr-110 pending); raw-retention contract is a finalize-in-approval-path item | Approved (R11); Gate 2 execution remains `not_run` and requires implementation authorization before any fixture run |

**Approval order applied (dependency-first, per Producer step ①):** TECH-01 (boundary) → TECH-02 (purity/read model) → TECH-03 (reproducibility) → TECH-04 (target snapshot) → TECH-05 (safety/reset/focus, mechanism boundary) → TECH-06 (headless seam/evidence). All six approved together under R11（user_confirmed，2026-08-16）. TECH-07/08 remain `draft_in_review` and are **not** approved.
