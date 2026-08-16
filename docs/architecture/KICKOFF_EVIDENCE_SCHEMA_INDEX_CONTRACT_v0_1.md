# KICKOFF EVIDENCE SCHEMA / INDEX CONTRACT v0.1

> **PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED**
>
> Governance/readiness-only `team_proposal` technical contract. This document is not an approved schema, not an evidence index, not a retention decision, not runtime/QA evidence, and not implementation authorization.

## 1. Status, authority, lifecycle, and boundary

| Field | Record |
|---|---|
| Artifact | `KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md` |
| Version | `v0.1` |
| Status | `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED` |
| Owner | Tech Lead — schema and compatibility proposal |
| Index/retention governance owner | Executive Producer / Lead Producer |
| Observer/verdict/block/retest authority | Independent QA / Release |
| Product authority | User — sole product owner and final decision-maker |
| Charter | `Development Charter v0.1` |
| Charter status | `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY` |
| Lifecycle | `development governance / kickoff readiness preparation` |
| Kickoff | `not_ready` |
| Evidence boundary | `static/source` only; no runtime evidence exists |
| Current decision class | `team_proposal` |

The Charter authorizes governance preparation only. This proposal does not authorize Godot/GDMCP access, code, scenes, resources, implementation, build, run, test, simulation, performance measurement, export, release, or QA execution/acceptance. A static contract cannot pass a runtime, visual, performance, export, or release gate.

### 1.1 Authority map

- **Tech Lead:** proposes technical identity, envelope shape, compatibility semantics, and schema versioning. Tech does not own domain meanings, index custody, or acceptance.
- **Systems / Rules:** owns domain fixture facts and their semantic meaning. The Systems package remains a separate source and is not modified here.
- **UX/UI:** owns player-facing observation payload and observable interaction/readability meaning.
- **Producer:** owns the future evidence index, retention, location, linkage, and governance disposition. Producer/QA have not frozen those policies in this proposal.
- **Independent QA / Release:** owns independent observation, verdict, block, and retest authority. Implementers cannot self-certify.
- **User:** owns product decisions and final authority; silence is not consent.

## 2. Provenance preservation

This proposal preserves, without reclassification or historical rewrite:

1. **22** original `user_confirmed` baseline inputs as candidate constraints, not implementation facts.
2. **Exactly 8** canonical `v0.1-revision-02` inputs from the corrected Matrix (promise/pillars/cap; candidate architecture; reproducibility; target snapshot; safety/terminal; playability gate; performance; platform).
3. The **current authorization record** for `Development Charter v0.1` as a separate authorization/provenance event, not a ninth revision-02 input.
4. **`PRECHARTER-01..11`** with their unresolved fields retained.
5. Four active provenance layers: **`user_confirmed`**, **`team_proposal`**, **`assumption`**, and **`unresolved`**.
6. The unresolved register and all authority boundaries.

The Matrix's canonical eight revision-02 inputs and current authorization record are deliberately separate. An earlier QA review recorded a stale `8/9` echo in the Systems contract package as a historical finding. The Systems owner correction is now present and verified in the current source: exactly eight canonical `v0.1-revision-02` inputs, with the current authorization recorded separately; the current Systems source no longer contains an `8/9` contradiction. This is a history-preserving correction only; Independent QA Gate 1 re-review remains required. A provenance count is not evidence of implementation, acceptance, or authorization beyond the Charter record.

## 3. Contract purpose and non-purpose

This versioned proposal supplies a common vocabulary for a future Producer-owned evidence index and retention/disposition contract. It separates domain facts, technical identity, UX observations, QA verdicts, and Producer linkage so that no field becomes a second rules source.

It does not select exact tick frequency, algorithm, timing, value, platform/OS, hardware, threshold, release target, retention duration, artifact store, or product promise. Those remain `unresolved`, `user_reserved`, or subject to Change Request/User authority as applicable.

## 4. Version and identity rules

### 4.1 Version fields

| Field | Proposed form | Rule |
|---|---|---|
| `schema_version` | `vMAJOR.MINOR.PATCH` | This proposal is `v0.1`. A backward-incompatible meaning, removal, rename, shape, ownership, or comparison change increments MAJOR; a compatible additive field/enum/documented optional extension increments MINOR; wording/metadata-only correction increments PATCH. Approval is separate from versioning. |
| `fixture_schema_version` | immutable version string | Identifies the domain fixture shape and expected-fact semantics used by a record. Fixture meaning is Systems-owned. |
| `evidence_envelope_version` | immutable version string | Identifies the layered envelope and field contract. Technical representation is Tech-proposed; it does not redefine domain facts. |
| `index_format_version` | immutable version string | Identifies the Producer-owned manifest/index format and linkage rules. |
| `config_version` | immutable configuration identity | Identifies rules/session/configuration inputs. It is not a disguised build or product approval. |
| `source_identity` | structured immutable source identity | At minimum a source revision/digest or static-document identity sufficient for audit. Do not invent a revision when unavailable. |
| `build_identity` | structured immutable build identity | Future runtime/build records must identify source, build mode/profile, config/schema, toolchain/engine where relevant, target identity, and artifact digest where available. No build identity exists for this static proposal. |

Exact compatible version matching is required. No silent rename, alias, coercion, field dropping, defaulting, or “close enough” tolerance is permitted. A producer-approved migration, if ever needed, must be explicit, versioned, authority-recorded, and linked; it does not alter the original record.

### 4.2 Identity requirements

`evidence_id` is immutable and unique. An evidence record is append-oriented: corrections create a new record or an explicit disposition; they do not overwrite an original failure or verdict. A retest creates a new `evidence_id`, carries `retest_of`, identifies new applicable source/build/config/fixture identity, and may carry `supersedes` only as a linkage statement. `supersedes` never erases history.

## 5. Layered evidence envelope

The proposed envelope has five orthogonal layers. Each layer has one semantic owner and may link to another layer, but cannot silently duplicate authoritative meaning:

1. **`domain_fixture`** — Systems-owned expected domain facts, fixture scenario, legal outcomes, and unresolved domain expectations.
2. **`technical_envelope`** — Tech-proposed identity, session/run/tick/seed/config/schema/build/source, snapshots, traces, events, and compatibility result.
3. **`ux_observation`** — UX-owned observed player-facing state, focus/readability/accessibility/causality/occlusion payload and frame references.
4. **`qa_verdict`** — Independent QA-owned observer, comparison, verdict, deviations, block, and retest decision.
5. **`producer_index_entry`** — Producer-owned unique index key, artifact locations, retention/disposition, linkage, and governance status.

The envelope is a transport and audit boundary, not a second rules engine. No layer may redefine a field owned by another layer. `state_before` and `state_after` carry explicitly named namespaces; a presentation label cannot become gameplay authority. Any mapping must be documented by the future approved contract.

## 6. Unified field contract

The table below is a proposal for field names and minimum shape. `required` means required for the stated evidence class/condition, not that the field exists today.

| Field | Type / shape | Owner | Required condition | Semantics | Evidence classes |
|---|---|---|---|---|---|
| `evidence_id` | immutable string | Producer | Every future record | Unique audit key; never reused | all future |
| `evidence_class` | enum: `static/source`, `synthetic/anchor`, `runtime`, `QA`, `visual QA`, `performance`, `export/release` | Producer records; source class owner supplies | Every record | Declares what the artifact can prove; classes are not interchangeable | all |
| `gate` | enum/string `Gate 0..6` or named review | Producer | Gate-linked record | Review surface; does not itself produce a pass | future gate |
| `criterion` | stable string + source link | Producer with criterion owner | Every gate/review record | Exact comparison target, not a prose substitute | all future |
| `fixture_id` | immutable string | Systems semantic owner; Producer indexes | Deterministic/fixture evidence | Identifies expected domain setup/facts | runtime, QA, performance when fixture-based |
| `scenario_id` | immutable string | Producer with Systems/UX | Scenario-based evidence | Distinguishes no-target, focus, reset, B2, aspect, etc. | future applicable |
| `run_id` | run-scoped immutable string | Tech proposes; Session future owner | Runtime/session trace | One execution context; not a product account or persistence ID | runtime, QA, performance |
| `seed` | explicit integer/string/null with reason | Tech proposal; Session future owner | Deterministic evidence | Randomness identity; absent only with explicit not-applicable reason | runtime, QA, performance |
| `tick_context` | structured `{tick, step, frequency?}` | Tech proposal | Tick/comparison evidence | Evaluation context; exact frequency remains unresolved | runtime, QA, performance |
| `config_version` | immutable string/object | Tech proposal; configuration owner later | Any config-sensitive comparison | Configuration identity; no silent defaults | all applicable |
| `schema_version` | version string | Tech proposal | Every envelope | Envelope contract version | all future |
| `source_identity` | structured revision/digest/document refs | Tech proposal; Producer indexes | Any claim tied to source | Source truth used; static sources remain static | all |
| `build_identity` | structured or null + reason | Tech proposal; future Toolchain | Runtime/build/performance/export | Exact source/build/profile/toolchain/target/artifact identity as available | runtime, performance, export/release |
| `build_mode` | enum/string | Tech proposal | Build-dependent evidence | Debug/dev/release/profile identity; not inferred | runtime, performance, export/release |
| `platform` / `os` / `hardware` / `settings` | conditional structured fields | Tech proposal; User/Producer for commitments | Criterion depends on platform or measurement | Named target, OS, hardware, resolution/renderer/settings; never assumed | performance, visual QA, export, applicable runtime |
| `input_sequence_ref` | immutable artifact reference | Tech proposal; Producer links | Input/interaction criterion | Link to ordered input events/epoch data; not a narrative summary | runtime, QA, visual QA |
| `initial_snapshot_ref` | artifact reference + digest | Tech proposal | State comparison start | Initial state used by the comparison | runtime, QA |
| `expected_snapshot_ref` / `expected_trace_ref` | artifact reference + digest | Systems defines facts; Tech represents | Fixture comparison | Expected domain result/trace; unresolved expectations stay marked | runtime, QA |
| `actual_snapshot_ref` / `actual_trace_ref` | artifact reference + digest | Tech produces; QA observes | Executed comparison | Observed output; must not overwrite expected data | runtime, QA |
| `domain_events` | ordered event records | Systems owns meaning; Tech serializes | Domain event evidence | Actual/expected domain events, with namespace and order explicit | runtime, QA |
| `state_before` | namespaced snapshot reference/object | Systems meaning; Tech shape; UX observation separate | Transition evidence | State immediately before event; no namespace conflation | runtime, QA, visual QA |
| `state_after` | namespaced snapshot reference/object | Systems meaning; Tech shape; UX observation separate | Transition evidence | State immediately after event | runtime, QA, visual QA |
| `focus_event` | structured event + phase | UX meaning; Tech mechanism | Focus-loss/resume criterion | Observed focus loss/return and safety context | runtime, QA, visual QA |
| `focus_epoch_before` / `focus_epoch_after` | explicit integer/string | Tech representation; UX safety meaning | Focus/epoch criterion | Input-safety epochs; not a gameplay rule source | runtime, QA |
| `stale_input_result` | enum/structured outcome | UX defines expected observation; Tech records | Focus/input safety | Whether stale Enter/Space or equivalent was rejected, with evidence | runtime, QA |
| `frame_refs` | ordered artifact/frame references | Observer produces; Producer indexes | Visual or frame-observed criterion | Exact frame/screenshot references and state context | visual QA, QA, runtime |
| `log_refs` | ordered log artifact references | Tech/observer produces; Producer indexes | Log-supported criterion | Raw logs with identity and digest where available | runtime, QA, performance, export |
| `trace_ref` | artifact reference + digest | Tech | Trace-supported criterion | Append-only diagnostic trace | runtime, QA, performance |
| `snapshot_ref` | artifact reference + digest | Tech | Snapshot-supported criterion | Versioned snapshot artifact; cadence/retention remain open | runtime, QA |
| `observer` | structured identity/role/time | Independent QA for verdict; observer for raw observation | Any future acceptance/evidence record | Who observed what; independence must be explicit | all future |
| `owner` | role/person or package owner | Producer records; artifact owner supplies | Every future record | Operational custody, distinct from verdict authority | all future |
| `timestamp` | timestamp + timezone/format | Observer/producer | Any time-based record | Capture/index time; no meaning without clock authority | all future |
| `clock_authority` | named monotonic/wall clock or `not_applicable` reason | Tech proposes; QA reviews | Timing/performance/focus evidence | Defines timestamp authority and comparability | applicable |
| `verdict` | enum `not_run`, `pass`, `fail`, `blocked`, `inconclusive`, `superseded` | Independent QA / Release | QA/review record | Independent result only; Producer cannot waive | QA, visual QA, performance, export/release |
| `unresolved_deviations` | list of structured deviations | QA with source owners | Any gap, mismatch, open field | Preserves uncertainty; empty only when justified | all future |
| `retention` | disposition object/reference | Producer proposal; Producer/QA review | Indexed artifact | Duration/class/location/disposition, not yet frozen | all future |
| `index_ref` | Producer manifest entry reference | Producer | Any indexed future artifact | Stable linkage to index/location/access record | all future |
| `retest_of` | prior `evidence_id` or null | Producer records; QA validates | Retest only | Original failure/criterion lineage | future retest |
| `supersedes` | prior record ID(s) or null | Producer records; QA/authority validates | Explicit replacement/disposition only | Relationship, never deletion or retroactive rewrite | future applicable |

Conditional fields are mandatory when their criterion depends on them. They must be present, or explicitly marked `not_applicable` with a reason; they may not be filled from assumptions. `timestamp` without `clock_authority` is incomplete for timing claims.

## 7. Namespace and ownership firewall

- **Domain fixture facts:** Systems semantic owner. This includes expected legal targets, no-target meaning, contact/re-arm facts, upgrade/B2 domain facts, terminal/reset expectations, and unresolved domain conditions.
- **Technical identity:** Tech proposal owner for session/run/tick/seed/config/schema/build/source identity and serialization/compatibility. Exact engine/platform choices remain open.
- **UX observation payload:** UX owner for focus/readability/accessibility/causality/occlusion and player-facing observation meaning. UX does not certify gameplay truth.
- **Index/retention/location/linkage:** Producer owner. Producer assembles and governs; it does not redefine expected facts or issue acceptance.
- **Observer/verdict/block/retest:** Independent QA / Release authority. Implementers and Producer cannot self-certify or waive a QA blocker.

A field may be technically serialized by another member, but serialization does not transfer semantic ownership. No duplicate authoritative field, hidden alias, or display-derived gameplay fact is allowed.

## 8. Comparison and compatibility behavior

1. Compare like evidence classes and explicitly declared namespaces; static/source, synthetic/anchor, runtime, visual QA, performance, export/release, and QA are not interchangeable.
2. Require exact compatible version matching for `schema_version`, `fixture_schema_version`, `evidence_envelope_version`, `index_format_version`, `config_version`, `source_identity`, and `build_identity` where applicable.
3. Any mismatch or unavailable required identity produces **`schema_incompatible`** (or, where the identity is absent rather than mismatched, a distinct `missing_evidence` state). Neither may be treated as pass.
4. No silent field dropping, rename, alias, coercion, default, semantic tolerance, timestamp substitution, or “close enough” comparison.
5. Variance/tolerance is permitted only when the applicable fixture contract explicitly lists it, the authority is named, and the approved record is linked. This proposal does not approve any variance.
6. Compare expected domain facts separately from actual technical output and UX observation. A screenshot cannot establish hidden domain correctness; a trace cannot establish player readability.
7. Preserve every original failure. A retest is a new record with a new `evidence_id`, current identity, `retest_of`, and any `supersedes` linkage. It does not delete, mutate, or turn the original failure into a pass.

## 9. Producer future index/retention contract proposal

This section is a handoff proposal only. **Producer and QA have not authority-reviewed or frozen it.** The Producer must create the actual index/retention contract later, after role review and any required Change Request.

### 9.1 Suggested repository-relative location and naming

- Suggested location: `docs/evidence/index/` (do not create this directory or any index file in this task).
- Suggested manifest naming: `EVIDENCE_INDEX_<gate-or-scope>_<version>.md` for human-readable governance manifests, with a future machine-readable companion only if Producer/Tech/QA approve one.
- Every manifest must declare its `index_format_version`, owner, source set, coverage, status, and whether it is empty, partial, or populated.
- Artifact paths should be repository-relative where possible; external locations require an access/owner record and a stable locator/digest.

### 9.2 Required future index fields

At minimum, each index row should carry: `evidence_id`; `evidence_class`; `gate`; `criterion`; `fixture_id`/`scenario_id` where applicable; `run_id`/`seed` where applicable; `schema_version`; `fixture_schema_version`; `evidence_envelope_version`; `config_version`; `source_identity`; `build_identity`/`build_mode` where applicable; conditional platform/OS/hardware/settings; artifact references (`frame_refs`, `log_refs`, `trace_ref`, `snapshot_ref`); observer; operational owner; timestamp/clock authority; verdict; unresolved deviations; retention disposition; access/ownership; `retest_of`; `supersedes`; and an explicit current status.

The index must map each ID to the actual artifact location/linkage and identity, not merely repeat a claim in prose. Missing ID, missing index linkage, or unverifiable artifact location means the record is not auditable.

### 9.3 Retention and disposition proposal

The future Producer contract should define, per evidence class and gate: retention duration or review point; canonical location; artifact integrity/digest rule; access owner; permitted readers; backup/archive policy; disposition authority; and treatment of superseded, failed, blocked, and incomplete records. This proposal recommends:

- retain raw artifacts and the original record together;
- retain failed/blocked records for the full relevant review and retest chain;
- never delete or overwrite a record merely because a retest passes;
- mark superseded records as superseded while preserving their lineage;
- make any deletion/expiry an explicit Producer disposition with QA visibility and authority record;
- distinguish `not_run`, `missing_evidence`, `schema_incompatible`, `blocked`, `inconclusive`, `fail`, `pass`, and `superseded` rather than collapsing them;
- record access/ownership for external artifacts and do not claim an artifact that cannot be retrieved.

No retention duration, storage technology, external repository, or deletion schedule is approved here.

### 9.4 Missing and no-runtime states

The future index must support explicit empty states:

- **`not_run`** — the criterion has not been executed; it cannot pass.
- **`not_ready`** — prerequisite/authority/readiness is incomplete.
- **`missing_evidence`** — a claimed or required artifact/identity/link is unavailable or unverifiable.
- **`no-runtime-evidence`** — static records exist, but no runtime observation exists; this is not a runtime pass.
- **`schema_incompatible`** — exact comparison cannot be made under the declared versions/identities.
- **`blocked`** — an authorized QA/Release blocker prevents closure.
- **`inconclusive`** — evidence is present but cannot support a verdict.

The current artifact is `static/source` only; it creates no runtime evidence and no future index record.

## 10. Gate 0/1 static prerequisites and implementation firewall

### Gate 0 — Charter/readiness prerequisites

Before any future execution, Producer must have a versioned authorized Charter reference, lifecycle/mode, ownership/RACI, provenance map preserving 22/8/PRECHARTER/four layers, Change Request route, evidence owner/index plan, independent QA authority, expert preflight/start record, dependency/build/config identity plan, and a stop condition. Current status: `not_run / not_ready`.

### Gate 1 — Static conformance prerequisites

Producer/Tech/Systems/UX/QA must review the field ownership map, version rules, source identity requirements, fixture/technical/UX/QA/Producer layer separation, unresolved register, and future index/retention proposal. The corrected Matrix count must remain eight revision-02 inputs plus the separate authorization record. Current status: `not_run / not_ready`.

### Implementation firewall

No implementation, Godot/GDMCP access, runtime, build, test, simulation, performance measurement, export, release, or QA acceptance may start from this proposal. No exact algorithm, timing, value, platform, OS, hardware, threshold, release target, or product promise is closed. A future member may implement only after the Producer/authority sequence, approved contracts, and kickoff readiness conditions are satisfied.

## 11. Unresolved register and CR/User boundary

Remain unresolved: exact fixture schema and domain fields; tick frequency and seed/RNG ownership details; snapshot cadence/retention and trace verbosity; target cluster algorithm and invalidation; contact/re-arm values; upgrade triggers/card values/timing; B2 geometry/counters/performance; focus epoch/buffer/platform behavior; state/read-model mapping; clock and measurement protocol; platform/OS/hardware/settings; acceptance thresholds/tolerances; artifact storage and retention duration; index machine format; access control; and all exact algorithms/timings/values.

Every feature, direction, platform, scope, schedule/cost, architecture, event-order, persistence, acceptance-threshold, hard-gate, or release change enters a Change Request. Return to the User for product decision or Charter reauthorization when it crosses the player promise, immutable Charter decision, major scope/cap/exclusion, platform/input/export/release, architecture risk, acceptance threshold, or release commitment. The Producer governs intake and sequence; Tech recommends technical consequences; Systems owns rule meaning; UX owns observation meaning; QA may block. No role replaces the User.

## 12. Closure and return record

- **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`; kickoff remains `not_ready`.
- **Actual start evidence:** direct Tech Lead member start for this static governance assignment after successful expert capability load; no implementation member start, kickoff execution, runtime start, or QA run is claimed.
- **Expert skill evidence:** `godot-tech-lead-expert` loaded successfully before document reading; capability level `direct expert skill loaded`.
- **Expert preflight:** static architecture/evidence context only; blast radius is the future evidence schema/index handoff; decisions are ownership/version/compatibility/index proposals; risks are provenance drift, duplicate authority, and silent incompatibility; required evidence is source inspection plus complete write/reread; boundary is governance-only; stop condition is artifact creation and verification or pre-existing-file block.
- **Architecture context:** only the six instructed static documents were read; no code, Godot, GDMCP, scene, resource, asset, runtime, build, test, simulation, performance, export, or release surface was accessed.
- **Verification:** target was absent before creation; this file was created and must be fully reread. No runtime or QA evidence is claimed.
- **Files modified:** only `docs/architecture/KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md` (new file).
- **Field-owner summary:** Systems owns domain fixture facts; Tech proposes technical identity and compatibility; UX owns observation payload; Producer owns index/retention/location/linkage; Independent QA owns observer/verdict/block/retest; User owns product authority.
- **Compatibility summary:** exact matching across declared versions and identities; incompatibility is explicit `schema_incompatible`; no silent rename/alias/coercion/tolerance; retests append new IDs and preserve failures.
- **Index/retention summary:** future Producer-owned repository-relative manifest/index, artifact references, access/ownership, explicit missing/no-runtime states, raw/failure/superseded lineage retention; proposal not frozen by Producer/QA.
- **Provenance preservation:** 22, exactly 8 revision-02 inputs, separate current authorization record, PRECHARTER-01..11, four provenance layers, and unresolved fields are retained. An earlier QA review's stale Systems `8/9` echo remains recorded as historical provenance; the Systems owner correction is now present and verified in the current source as exactly eight canonical revision-02 inputs with separate current authorization, so no current `8/9` contradiction remains. This history-preserving correction does not approve or freeze either contract; Independent QA Gate 1 re-review remains required.
- **Evidence boundary:** `static/source` only; no runtime, visual, performance, export, release, or QA evidence.
- **Closure-ready:** `yes` for this static technical contract proposal only; `no` for kickoff, implementation, runtime, QA acceptance, release, or any approval claim.

## 13. Role-expert return

```text
Role expert: godot-tech-lead-expert
Architecture context: six permitted static inputs read; no Godot/code/runtime surface; blast radius is evidence identity, layered envelopes, compatibility, Producer index/retention handoff, and QA linkage.
ADRs: no new approved ADR; this is a schema/index contract proposal that remains team_proposal.
Contracts handed off: five-layer envelope, field ownership table, version/identity rules, exact comparison behavior, retest lineage, and future Producer index/retention requirements.
Risk register: provenance count drift, duplicate domain authority, silent schema/config/build mismatch, missing artifact linkage, retention erasing failures, and Producer/QA policy not yet frozen.
Debt ledger: no implementation debt; readiness risks remain open with retirement evidence defined by future authority review and auditable records.
Verification: complete static reread required; no runtime, build, test, performance, export, release, or QA evidence.
Stop condition: stop before implementation or any authority crossing; return through Producer/Change Request/User when boundaries are crossed.
Closure-ready: yes for this static technical contract proposal; no for kickoff or acceptance.
```
