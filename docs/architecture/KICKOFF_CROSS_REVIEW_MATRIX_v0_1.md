# KICKOFF CROSS-REVIEW MATRIX v0.1

> **PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED**
>
> This artifact is governance/readiness input only. It is not an approved architecture, contract, implementation authorization, runtime result, build result, test result, performance result, export/release decision, or QA verdict. The current Development Charter authorizes governance and kickoff-readiness preparation only; implementation remains blocked.

## 1. Producer metadata and authority boundary

| Field | Record |
|---|---|
| Artifact | `KICKOFF_CROSS_REVIEW_MATRIX_v0_1.md` |
| Version | `v0.1` |
| Owner | Executive Producer / Lead Producer |
| Product authority | User; sole product owner and final decision-maker |
| Execution authority | Executive Producer / Lead Producer, within the Charter |
| Creative authority | Game Director / Creative Director |
| Technical authority | Tech Lead |
| Rules/domain authority | Systems / Rules; owns rule meanings and domain facts |
| UX authority | UX/UI; owns player-facing observable meaning and interaction/readability proposal |
| Acceptance authority | Independent QA / Release; owns observer, verdict, block, and retest authority |
| Canonical Charter | `Development Charter v0.1` |
| Charter status | `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY` |
| Lifecycle | `development governance / kickoff readiness preparation` |
| Kickoff | `not_ready`; Gates 0, 2, and 3 are `not_run / not_ready` |
| Evidence class | `static/source` only; Anchor is separately `synthetic/anchor` static baseline |
| Provenance | Date-free source/provenance references; no calendar date is inferred or required here |
| Capability limitation | Tech review reported `capability_level=static_skill_load` because its direct skill wrapper was unavailable. This is not runtime, implementation, or direct expert-skill evidence and is not upgraded here. |
| Current work mode | Governance assembly only; no implementation member start is claimed |

The Producer assembles governance and evidence linkage. The Producer does not decide product intent, technical architecture, UX meaning, or QA acceptance. Team proposals remain proposals. Silence is not approval.

## 2. Cross-review scope and source map

This matrix reconciles the completed static Tech/Systems/UX cross-review packages into one reviewable ownership and handoff proposal. It does not approve or freeze any package.

### 2.1 Sources inspected

- `docs/DEVELOPMENT_CHARTER_DRAFT_v0_1.md` — canonical Charter status, lifecycle, authority, scope firewall, gates, 22 decisions, 8 revision-02 inputs, and evidence rules.
- `docs/visual/anchor/ANCHOR_DECISION.md` — corrected historical pre-authorization wording, current canonical Charter reference, Anchor v0.1 boundary, and v0.2 candidate boundary.
- `docs/architecture/KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` — candidate seams, ADR subjects, technical identity, determinism, snapshot/trace, reset, and evidence proposals.
- `docs/creative/KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md` — domain vocabulary, rule order, target/contact/upgrade/B2/terminal meanings, fixture proposals, and unresolved rules.
- `docs/ux/KICKOFF_UX_UI_CONTRACTS_v0_1.md` — player-facing state/interaction contract, focus safety, hierarchy, accessibility direction, and future observation targets.
- `docs/creative/GDD_SLICE_v0_1.md` — canonical static Slice design baseline, state namespace distinction, promise/pillars, scope, and unresolved register.
- `docs/creative/SLICE_RULES_DECISION_v0_1.md` — user-confirmed Slice rules and retained incremental history.
- `docs/creative/SLICE_PRECHARTER_DECISIONS_v0_1.md` — `PRECHARTER-01..11` user-confirmed boundaries and unresolved fields.

### 2.2 Preserved input counts and layers

The matrix preserves, without reclassification:

- **22 original `user_confirmed` inputs** from the current Slice rules record/GDD echo. They remain candidate constraints within the authorized governance envelope, not implementation facts.
- **Exactly 8 canonical `v0.1-revision-02` inputs** retained from Charter §2.1: (1) promise/pillars/cap; (2) candidate architecture; (3) reproducibility; (4) target snapshot; (5) safety/terminal; (6) playability gate; (7) performance; (8) platform. These are the only revision-02 packet inputs counted here; their candidate boundaries and unresolved fields remain intact.
- **Current `Development Charter v0.1` authorization is a separate current authorization record / provenance event**, not a revision-02 packet input and not a ninth item. Its boundary remains `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY`, with lifecycle `development governance / kickoff readiness preparation`; kickoff remains `not_ready` and implementation is not authorized. This correction preserves the authorization history and does not convert it into packet content.
- **`PRECHARTER-01..11`** exactly, including their unresolved fields.
- Four active provenance layers: **`user_confirmed`**, **`team_proposal`**, **`assumption`**, and **`unresolved`**.

No proposal, candidate budget, Anchor, historical wording, or assumption is promoted to a product decision. Historical pre-authorization language in the Anchor remains historical at capture; the current canonical reference is the authorized Charter above. Anchor v0.1 remains the accepted static/synthetic baseline; v0.2 remains an unaccepted candidate and cannot replace v0.1 silently.

## 3. Reconciled ownership and seam matrix

### 3.1 Direction of responsibility

The proposed dependency direction is:

`rules core (domain truth) → session (run/lifecycle context) → adapter (translation only) → presentation/read-model (read-only projection) → UX observation`

The technical package may describe the inverse dependency direction for implementation wiring (`adapter/presentation → session → rules core`); that is a dependency statement, not a change in semantic ownership. Rules core never receives UX authority. Presentation never becomes a second rules engine.

| Surface | Semantic owner | Technical owner/proposal | UX observable owner | QA evidence owner |
|---|---|---|---|---|
| Rules core/domain truth | Systems/Rules | Tech proposes pure seam and schema | UX consumes consequences only | Independent QA observes expected vs actual domain facts |
| Session/run lifecycle | Systems defines lifecycle meaning; Session owns lifecycle context | Tech proposes tick/seed/run/reset/config context | UX observes lifecycle projection | QA observes lifecycle/reset traces |
| Adapter | No new semantics; translates | Tech Lead | UX supplies required intent/read fields | QA checks translation evidence and boundary integrity |
| Read model/presentation | Domain meaning comes from Rules; projection is read-only | Tech proposes versioned technical schema | UX owns player-facing fields and observations | QA independently checks projection and player-visible outcomes |
| Evidence index | Producer | Tech supplies identity fields; Systems supplies expected facts; UX supplies observations | UX does not own the unique index | QA owns verdict/block/retest, not index custody |

### 3.2 Semantic seam rules

1. **Rules core owns meaning:** target legality, no-target, contact/re-arm, upgrade/B2 domain effects, terminal precedence, and reset domain facts.
2. **Session owns context:** run identity, lifecycle phase, tick/seed/config context, pending transaction/reset context, and the canonical restart boundary. It does not redefine rule meanings.
3. **Adapter translates only:** device/engine/time observations into domain inputs and domain outputs into presentation/engine-facing outputs. It may not add hidden targeting, timing, or gameplay rules.
4. **Read model/presentation projects only:** it exposes authorized domain facts and interaction affordances. It must not mutate rules or infer new gameplay facts from graphics.
5. **UX observes meaning at the player surface:** focus/readability/accessibility, causality, hierarchy, and visible interaction state. UX does not own gameplay state or rule semantics.
6. **Producer links evidence:** one unique index maps evidence IDs to source, fixture, scenario, run, build/config identity, observer, verdict, retention, and retest chain.
7. **QA decides acceptance:** QA/Release independently observes, issues verdicts, blocks, and authorizes retest closure. Producer assembly is not acceptance.

## 4. Domain seam and scenario ownership matrix

| Scenario/surface | Systems semantic owner | Tech technical owner/proposal | UX observable owner | QA evidence owner | Unresolved / stop condition |
|---|---|---|---|---|---|
| Target snapshot and no-target | Meaning of nearest-threat cluster, legal candidates, no fabricated target, locked shot set | Snapshot ID, refresh/lock lifecycle, ordering fields, stable IDs, serialization, trace/snapshot schema | Player can relate movement to next attack; no misleading target/hit cue | No-target, ties, removal, ordering, and observed causality fixtures/verdict | Cluster membership, metric/quantization, tie fields, ID lifecycle, invalidation, cadence, geometry. Stop on implicit no-target, unstable ordering, or retarget after lock without contract. |
| Contact and re-arm | One legal contact, damage meaning, invulnerability, separation, re-arm only after separation | Contact event representation, timing/context fields, state transition trace, cleanup | Player reads hit, safety, recoverable spacing; no sticky/punitive contact | Overlap, invulnerability, separation, re-contact, boundary, simultaneous-contact evidence | Duration, distance/direction, damage/stacking, global vs pair protection, boundary behavior. Stop on repeated damage during protection or unrecoverable overlap. |
| Upgrade transaction | Eligibility/trigger meaning, stage order `穿透 → 扇裂`, acquired domain effect, pending transaction/reset meaning | Pause/lifecycle/input transaction, schema, event order, persistence only within current run, reset clearing | Card focus/selection/pressed/acquired/resume meaning and readability | One legal choice, order, pause, feedback-before-resume, reset/focus scenarios | XP source/values, trigger measurement, card pool/content, pause timing, cancellation, feedback duration. Stop on stale confirmation, skipped/rerolled choice, or reset leakage. |
| Focus loss and resume | Pending transaction and reset meaning; no gameplay progression while required pause applies | Focus event, epoch/buffer/pause mechanism, stale-input filtering, serialization/trace fields | Focus epoch safety meaning, preserved focus/selection, fresh explicit input, non-color state | Combat/card focus-loss, stale Enter/Space, resume and preservation observations | Event policy, epoch increments, flush/buffer semantics, return target, platform behavior. Stop on stale confirmation or hidden progression. |
| B2 | Same-source transition, piercing inheritance, independent arc hit-counter meaning | Arc IDs, snapshot/trace representation, technical geometry/config fields, compatibility identity | Same-source read, center/left/right readability, clearing/corridor observation, no persistent light field | Before/impact/after frames plus domain trace and independent verdict | Geometry, sharing, duplicate hits, attenuation, counters, timing, performance. Stop if spectacle obscures player/danger/space or becomes a persistent field. |
| Terminal and reset | Life depletion beats same-frame eight-minute victory; result and canonical fresh-run meaning | Same-tick arbitration, result/input lock, reset transaction, seed/ID/input cleanup, reset trace | Victory/defeat distinction, short result, immediate retry, no punitive flow | Same-frame precedence, result, clean reset, stale-input and retry evidence | Exact event order, duration, cleanup, queued input. Stop on callback-order variance, dirty state, or result ambiguity. |
| Rules/state versus UX state | Domain facts and `gameplay_state` meaning | Technical schema and lifecycle transport | `ux_interaction_state` and projection observations | Compare each namespace without conflation | No duplicate authority or semantic alias. Stop on UX field becoming gameplay authority. |
| B2 performance candidate | Systems records design consequence; no hard number promotion | Tech proposes measurement identity/protocol | UX observes effects/occlusion, not frame-rate authority | QA independently reviews measurements and thresholds | Hardware/OS/settings/percentile/threshold authority unresolved. Stop on unauditable budget claim. |

## 5. Unified namespaces and fixture split

### 5.1 State namespaces

The namespaces are orthogonal and must be serialized, compared, and reported separately:

- **`gameplay_state`**: authoritative domain/lifecycle state, including `run_entry`, `combat_active`, `moving`, `idle`, `attack_cycle`, `attack_target_locked`, `hit`, `invulnerable`, `upgrade_pause_1`, `upgrade_pause_2`, `victory`, `defeat`, and `reset`. `attack_target_locked` is a transient child of `attack_cycle`; historical aliases (`run_init`, `run_reset`, `combat_moving`, `combat_idle`) are traceability aliases only.
- **`ux_interaction_state`**: player-facing interaction state, including `default`, `hover`, `focus`, `pressed`, `selected`, `disabled`, `paused`, `resumed`, result presentation, and focus-loss presentation.

`gameplay_state`/domain state belongs to Systems for meaning and Session for lifecycle context, not UX. `ux_interaction_state` belongs to UX/presentation. No duplicate authoritative field is permitted, and no silent semantic alias may be introduced. A display label may map to a domain field only through a documented read-model mapping.

### 5.2 Fixture/evidence split

| Payload | Owner | Contains | Must not contain |
|---|---|---|---|
| Domain fixture expected facts | Systems/Rules | Expected rule outcomes, legal targets, contact/re-arm facts, upgrade/B2 facts, terminal/reset facts | Technical implementation claims, UI verdicts, or hidden assumptions |
| Technical evidence envelope | Tech + Producer | Identity, tick/seed/config/schema, snapshots/traces, state transition and compatibility records | UX acceptance or product approval |
| UX observation payload | UX/UI | Observed focus/readability/accessibility/causality/occlusion and frame references | Authoritative gameplay facts or QA verdict |
| QA verdict | Independent QA/Release | Observer identity, comparison result, pass/block/retest verdict, deviations, retest linkage | Implementer self-acceptance or Producer waiver |

Target snapshot **semantics** belong to Systems; snapshot ID, lifecycle, serialization, and compatibility belong to Tech. Focus epoch **safety meaning** belongs to UX; epoch/buffer/pause mechanism belongs to Tech; pending transaction/reset meaning belongs to Systems/Session. Fixture domain facts belong to Systems; the technical evidence envelope belongs to Tech/Producer/QA; UX observations remain a separate projection. Producer owns the unique index and retention/linkage; QA owns observer/verdict/block/retest authority.

## 6. Unified evidence envelope proposal (not frozen)

The following is a compatibility and governance proposal, not a frozen schema:

```text
evidence_id
evidence_class
gate
criterion
fixture_id
scenario_id
run_id
seed
tick_context
config_version
schema_version
source_identity
build_identity
build_mode
platform? / os? / hardware? / settings?
input_sequence_ref
initial_snapshot_ref
expected_snapshot_or_trace_ref
actual_snapshot_or_trace_ref
domain_events
state_before
state_after
focus_event
focus_epoch_before
focus_epoch_after
stale_input_result
frame_refs
log_refs
trace_ref
snapshot_ref
observer
owner
timestamp
clock_authority
verdict
unresolved_deviations
retention/index_ref
retest_of
supersedes
```

### 6.1 Field-group ownership

| Field group | Primary owner | Required collaboration |
|---|---|---|
| Identity, gate, criterion, fixture/scenario/run, retention/index, retest/supersession | Producer | QA verifies auditability; source owners provide links |
| Evidence class and technical identity (`seed`, `tick_context`, config/schema, source/build/mode, conditional platform data) | Tech proposes; Producer records | User/Charter authority for platform or hard-gate crossings; QA independently inspects |
| Initial/expected/actual snapshots, trace references, domain events, `state_before/after` | Systems defines expected facts; Tech defines technical representation | QA compares; Producer indexes |
| Focus event, epochs, stale-input result | UX defines observable safety meaning; Tech defines mechanism/fields | Systems/Session defines pending/reset semantics; QA observes |
| Frame/log references and observation timestamps | Observer/operating member produces | QA owns independent observation; Producer retains links |
| `observer`, `owner`, `verdict`, deviations | QA owns independent verdict and block; Producer owns package owner | Implementer may report, never self-certify |
| `clock_authority` and measurement context | Tech proposes | QA reviews; User if threshold/release commitment is crossed |

Conditional `platform`, `os`, `hardware`, and `settings` fields are mandatory when the criterion depends on them; they are not silently filled with assumptions. `timestamp` is meaningless without the declared `clock_authority`.

### 6.2 Comparison incompatibility

Comparisons must distinguish exact mismatch, missing evidence, and approved future tolerance only if an explicit authority record exists. Any incompatible `schema_version`, config identity, snapshot shape, or trace contract returns **`schema_incompatible`**. There is no silent tolerance, field dropping, semantic aliasing, coercion, or “close enough” comparison. A retest preserves the original record and creates new evidence IDs with the new identity; `supersedes` never erases history.

## 7. Handoff and gate sequence

### 7.1 Required sequence

1. **Systems/Rules → Tech:** deliver domain meanings, expected facts, fixture scenarios, unresolved algorithms/values, and stop conditions. Tech may formalize technical schemas but may not change rule meaning.
2. **Tech → UX:** deliver proposed lifecycle/read-model/identity/focus/reset seams and compatibility behavior. UX defines observable player meaning without becoming rule authority.
3. **UX → Producer:** deliver player-facing state/interaction/readability/accessibility observations, unresolved fields, and future observation criteria. UX does not claim runtime usability or visual acceptance.
4. **Producer → Independent QA/Release:** deliver the unique evidence index proposal, ownership map, gate criteria, source links, unresolved register, and handoff readiness package.
5. **Independent QA/Release:** independently reviews preflight, observes applicable evidence in a future authorized phase, issues verdict/block/retest, and may stop the phase. QA does not inherit Producer or implementer acceptance.

Game Director review is required when promise/pillars, creative coherence, slice intent, B2 readability, clear-screen result, or Anchor interpretation is involved. A User Change Request/product decision is required for promise/pillars, immutable decisions, major scope/caps/exclusions, platform/OS/input/export/release, architecture risk, acceptance thresholds/hard gates, Replay/persistence/meta, or exact algorithms/timings/values when they cross product, threshold, or Charter authority.

### 7.2 Current gates

| Gate | Static prerequisite / future evidence | Current status |
|---|---|---|
| Gate 0 | Charter integrity, provenance, owners, CR route, expert/preflight evidence, QA plan | `not_run / not_ready` |
| Gate 2 | Authorized future deterministic implementation evidence: fixtures, seed/tick, snapshots/traces, target/contact/reset/terminal comparisons | `not_run / not_ready` |
| Gate 3 | Future runtime/visual observation across states/aspects, focus, HUD, cards, B2 and clearing | `not_run / not_ready` |

Gate 1, 4, 5, and 6 also remain `not_run / not_ready`; this matrix does not alter the Charter. Static source material can prepare Gate 0/2/3 prerequisites, but cannot pass runtime, visual, performance, export, or release gates. No kickoff execution has occurred.

## 8. Cross-review unresolved register

The following remain open and are intentionally not resolved by this matrix:

- exact rules/session/adapter/presentation interfaces and architecture approval;
- target-cluster membership, distance metric/quantization, tie-break fields, stable-ID lifecycle, refresh/fire timing, invalidation, no-target cadence, target sharing, arc geometry and duplicate-hit policy;
- tick frequency, seed owner/initialization, RNG streams/sources/ranges, snapshot cadence/schema/retention, trace verbosity, replay equivalence and stable-ID serialization;
- contact duration, invulnerability duration, damage, separation distance/direction, stacking, simultaneous contacts, boundaries, removal, and re-arm predicate;
- XP source/values, trigger conditions, candidate windows, measurement definition, card pool, variants, values, copy, icons, selection and recovery timing;
- B2 angles, spacing, length, collision shape, target sharing, attenuation, counters, simultaneous ordering, effect timing and performance budget;
- terminal event ordering, same-tick semantics, result duration/copy, input lock, reset cleanup, RNG/ID reset and stale-input handling;
- `gameplay_state` exact transition schema, read-model schema, presentation field mapping, adapter error behavior and compatibility migration;
- focus event policy, pause scope, epoch increments, buffer flushing, return-focus behavior, platform-specific behavior and messaging;
- HUD layout, safe areas, copy, minimum resolution, supported widescreen set, scaling/crop/letterbox, contrast, text/focus size, flashing, motion and reduced-motion thresholds;
- performance protocol: named hardware, OS, settings, build mode, sampling window, percentile, clock, input/feedback timestamp definitions, and hard-vs-soft authority;
- platform, OS, input, export target, release channel, build identity, and artifact requirements;
- final asset, audio, Style Manual, Anchor refinement, and creative acceptance boundaries;
- acceptance thresholds, evidence tolerances, observer independence, retention duration/location, and any missing convention/ADR records.

## 9. Change Request and User decision boundaries

Every new feature, direction, platform, scope, schedule/cost, architecture, input, persistence, Replay, meta, acceptance-threshold, hard-gate, or release change enters a Change Request with motivation, provenance, alternatives, displaced work, dependencies, risk, evidence impact, owner, and decision authority.

The Producer must return the package to the User for a product decision or Charter reauthorization when a CR crosses any of these boundaries:

- player promise, experience pillars, or slice intent;
- immutable Charter decisions, strict caps, exclusions, or major scope;
- platform/OS, input-device promise, export target, or release commitment;
- architecture risk or seam/contract ownership;
- acceptance thresholds, performance hard gates, or release gates;
- Replay, persistence, O2/meta progression, or other excluded product systems;
- exact algorithms, timings, values, or constants when their choice changes product meaning, scope, risk, platform, threshold, or Charter commitments.

No product decision is inferred from any proposal, unresolved field, static document, or silence. Game Director may recommend creative action; Tech may recommend technical action; Systems may recommend rule meanings/ranges; UX may recommend observation criteria; QA may block evidence. None replaces the User for reserved decisions.

## 10. Closure and evidence boundary

This matrix is closure-ready **only as a static governance/readiness matrix**. It contains no Godot/GDMCP access, code, scenes, resources, assets, implementation, build, runtime, test, simulation, performance measurement, export, release, or QA evidence. It does not prove the architecture, contracts, rules, readability, determinism, performance, or acceptance.

Implementation remains blocked. The next permissible action is review of this proposal by the named role authorities, preservation of unresolved fields, and independent QA/Release preflight planning under the authorized Charter. Kickoff remains `not_ready`; implementation and formal execution have not started.

## 11. Producer return and verification record

- **Status:** `not_ready`
- **Mode:** development governance / kickoff readiness preparation
- **Charter:** `Development Charter v0.1`, authorized for governance only
- **Expert skill/preflight evidence:** `godot-executive-producer-expert` loaded successfully before substantive work. Preflight confirmed User authority, Producer execution authority, separate Director/Tech/Systems/UX/QA authorities, governance-only mode, unresolved critical path, escalation triggers, and stop condition. Working directory was confirmed as `D:\Game\New_Game`.
- **Files modified:** only `docs/architecture/KICKOFF_CROSS_REVIEW_MATRIX_v0_1.md` (new artifact)
- **Provenance check:** 22 original user-confirmed inputs, exactly 8 canonical `v0.1-revision-02` inputs (promise/pillars/cap; candidate architecture; reproducibility; target snapshot; safety/terminal; playability gate; performance; platform), separate current Charter authorization record/provenance event, `PRECHARTER-01..11`, four provenance layers, Anchor v0.1/v0.2 boundaries, and unresolved fields are preserved; no proposal became approval. This is a provenance clarification/history-preserving count correction only: it does not change Charter decisions, close unresolved items, approve the matrix/contracts, or authorize implementation.
- **Cross-review summary:** Systems owns rule meanings/domain facts; Session owns lifecycle context; Tech owns technical envelope and proposed schemas/mechanisms; Adapter translates only; read-model/presentation is read-only; UX owns player-facing observations; Producer owns evidence index/governance; Independent QA owns observer/verdict/block/retest.
- **Evidence boundary:** static/source only, with Anchor v0.1 as synthetic/static reference; no runtime, implementation, build, test, performance, export, release, or QA evidence.
- **Closure ready:** `yes` for this static matrix only; `no` for kickoff, implementation, runtime, or acceptance.
