# CHANGE REQUESTS v0.1 — CR Ledger, Producer Dispositions, and Decision Batching

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / IMPLEMENTATION AUTHORIZED (R13, pending GDMCP preflight) / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / implementation authorization effective (kickoff not_ready → authorization effective; actual start pending GDMCP preflight + start evidence)`
>
> **Owner (sole author):** Executive Producer / Lead Producer — CR intake, triage, disposition, sequencing, and decision-package design. This artifact does **not** decide any product/platform/numeric/release matter itself; it registers, disposes, and batches pending items for user decision or authorized role resolution.
>
> **Charter boundary:** `Development Charter v0.1` — `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY`. Kickoff `not_ready`；implementation `NOT_AUTHORIZED → 授权生效（user_confirmed，R13，rev-7 2026-08-16）——契约内 + GDMCP 预检前置 + QA 不豁免 + 候选预算不提升`；Gate 0/1 = `ready_for_next_review`（静态复审通过，QA pass）；Gates 2–6 = `not_run / not_ready`；blocking findings = none（latest Independent QA verdict `STATIC_GATE_0_1_READY_FOR_NEXT_REVIEW`）。**授权登记 ≠ GDMCP 预检通过：实际动工仍需实现成员执行 GDMCP 预检（doctor / editor-state）+ 记录实际 start 证据。**
>
> **Evidence class:** `static/source` only. No runtime, build, test, QA-execution, performance, export, or release evidence is claimed.
>
> **Batch 1 decision records:** `appended 2026-08-16` — DC-PLAT-01 → Option P1（cr-101/102/103）；DC-ARCH-01 → Option A1（cr-201）；DC-PLAT-02 → Option 2（cr-104/105）。Provenance = `user_confirmed`（用户决策），详见 §8.1 R01–R03。`reauthorize_charter` 未触发。
>
> **Standing authorization packet AUTH-01:** `registered 2026-08-16` — hybrid packet（混合授权包）formal record per §8.2. Provenance = `user_confirmed`（用户决策；用户经 /godot-game-team 方向 B 提问卡片明确选择「混合授权包」，2026-08-16）。Process layer P1–P3 + delegation rules D1–D3 + hard-boundary firewall registered verbatim; **no implementation authorization added**; kickoff still `not_ready`; implementation still `NOT_AUTHORIZED`。
>
> **Batch 2 decision records:** `appended 2026-08-16` — DC-PERF-01 → Option A（cr-109）；DC-ACC-01 → Option A2（cr-106）；DC-ACC-02 → Option B3（cr-114）；DC-REL-01 → Option 2（O2）（cr-113）；DC-PLAY-01 → Option 2（cr-202）。Provenance = `user_confirmed`（用户决策；用户在 Batch 2 选项卡片上的最终选择），详见 §8.3 R04–R08。`reauthorize_charter` 未触发（未来触发点见 §8.3 末结论）。
>
> **Batch 3 decision records:** `appended 2026-08-16` — DC-SYS-01 → Option A「确认候选方向」（cr-001）。Provenance = `user_confirmed`（用户决策；用户在 DC-SYS-01 选项卡片上的最终选择；本卡属 D2 升级类整卡呈交用户亲自选择），详见 §8.4 R09。**D2 判定结论：用户选择 A（非升级项）→ `reauthorize_charter` 未触发**；未选项 Option B、C、D 保持 `unresolved` / `team_proposal`（不删除、不静默推广）。
>
> **DC-ANCH-01 decision record（收官）：** `appended 2026-08-16` — DC-ANCH-01 → Option 1「保持 v0.1 基线，v0.2 维持候选（暂不推进）」（cr-301）。Provenance = `user_confirmed`（用户决策；用户在 DC-ANCH-01 选项卡片上的最终选择；本卡属 AUTH-01 D2 升级类（(d)(e)——promise/immutable 相关 + 审美验收边界）整卡呈交用户亲自选择），详见 §8.5 R10。**D2 判定结论：用户选择 Option 1（维持 v0.1 基线）→ `reauthorize_charter` 未触发**（选 2 升级 v0.2 才会触发）；`recommend-revision` 剩余项（清除通道连续开阔、玩家负空间明确、无持续发光场）登记为未来版本化修订候选（不静默丢弃）；未选项 Option 2/3/4 保持 `unresolved` / `team_proposal`（不删除、不静默推广）。**needs_user_decision 由 1 → 0（全部决策完成）；治理准备阶段全部决策批次收官。**
>
> **ADR 批准 + owner 任命确认 decision record（rev-6，2026-08-16）：** `appended 2026-08-16` — **R11 = ADR-TECH-01..06 批准**（provenance = `user_confirmed`，用户决策；用户在 ADR 批准选项卡片上逐条确认）：TECH-01（候选边界 seam）/02（纯度/生命周期/read model）/03（可复现性/确定性）/04（目标快照契约）/06（Headless seam/证据 schema）**全量批准**；TECH-05 **批准机制边界**（contact 单次伤害+轻分离、升级事务两阶段、focus epoch 拒陈旧、同帧生命优先），**精确数值语义延后**（Systems 契约 in_flight，cr-006..020 剩余缺口）——详见 §8.6 R11。**TECH-07/08 未批准**（保持 `draft_in_review`）。**R12 = 实现 owner 任命确认**（provenance = `user_confirmed`，用户决策）：**Godot Gameplay Engineer** 为实现 owner（依据 `IMPLEMENTATION_OWNER_NOMINATION_v0_1.md`）；任命条件①（用户确认）满足，②（实现授权解除）、③（实际 start 证据）待后续——详见 §8.6 R12。**ADR 状态行更新（置 `approved`）由 Tech Lead 执行（ADR 文件为 Tech Lead 拥有，本文档不代改）。**⚠️ **ADR 批准 ≠ 实现授权**：ADR 批准使其成为生效技术契约（approved），但 kickoff 仍 `not_ready`、implementation 仍 `NOT_AUTHORIZED`；实现启动仍需用户另行授权 + GDMCP 预检 + start 证据（§8.6 R11/R12 边界标注）。
>
> **实现授权 decision record（rev-7，2026-08-16）：** `appended 2026-08-16` — **R13 = 实现授权生效**（provenance = `user_confirmed`，用户正式授权实现）。前置条件核对（§8.7 R13 前置条件核对表）：1. 产品/设计 gate ✅（Gate 0/1 ready_for_next_review 静态复审通过 + QA pass；GDD slice/Anchor 基线在库）；2. seam/ownership 决策 ✅（DC-ARCH-01 → A1 已决 + ADR-TECH-01 已批准）；3. 技术 ADR/合同批准 ✅（ADR-TECH-01..06 已批准；TECH-07/08 未批——不阻塞最小确定性核心 seam）；4. 实现 owner ✅（Godot Gameplay Engineer 已任命确认，R12）；5. **GDMCP 路径 ⏳ 待验证**（用户已配置，**待实现成员预检验证**——登记为「待验证」，不替代预检）；6. QA 验收计划 ✅（QA_ACCEPTANCE_PLAN_v0_1 已定稿）；7. write ownership ✅（任命提案已定义：Godot mutation 唯一写入 owner + GDMCP 铁律）；8. stop conditions ✅（已定义）。**授权范围边界：实现限于已批准契约（ADR-TECH-01..06 + 已决决策）范围内；TECH-07/08 未批准不进入；候选预算不提升；QA 独立验收不豁免；GDMCP 预检通过后才动工。**⚠️ **授权登记 ≠ GDMCP 预检通过**：实际动工仍需实现成员执行 GDMCP 预检（doctor / editor-state）+ 记录实际 start 证据。kickoff 状态：`not_ready → 授权生效`（实际动工待预检通过与 start 证据）——详见 §8.7 R13。

---

## 1. Authority, scope, and firewall of this ledger

| Field | Record |
|---|---|
| Artifact | `CHANGE_REQUESTS_v0_1.md` |
| Version | `v0.1`（rev-7：实现授权登记（R13），2026-08-16；rev-6 = ADR 批准 + owner 任命确认 decision records 登记（R11/R12），2026-08-16；rev-5 = DC-ANCH-01 决策记录登记 + 治理准备阶段决策批次收官，2026-08-16；rev-4 = Batch 3 决策记录登记，2026-08-16；rev-3 = Batch 2 决策记录登记，2026-08-16；rev-2 = AUTH-01 混合授权包登记，2026-08-16；rev-1 = Batch 1 决策记录登记；文件路径/文件名不变） |
| Owner | Executive Producer / Lead Producer (sole author of this file) |
| Product authority | User — sole product owner and final decision-maker; silence is never consent |
| Execution authority | Executive Producer / Lead Producer within the authorized Charter |
| Reserved decision classes | Promise/immutable/major-scope/platform/architecture-risk/threshold/release crossings → return to User via CR; may require Charter reauthorization |
| Current status | `governance_assembly_only + Batch 1 decided (decision level) + AUTH-01 standing authorization registered (process/delegation only) + Batch 2 decided (decision level) + Batch 3 decided (decision level) + DC-ANCH-01 decided (decision level, §8.5 R10) + ADR-TECH-01..06 approved (decision level, §8.6 R11) + implementation owner appointment confirmed (decision level, §8.6 R12) + **implementation authorized (decision level, §8.7 R13, user_confirmed 2026-08-16 —— implementation transitioned `NOT_AUTHORIZED → 授权生效`, contract-scoped, GDMCP preflight pending, QA not exempted, candidate budgets not promoted)** — governance-readiness decision batches closed; ADR approvals + owner appointment + implementation authorization registered` for this ledger; no contract freeze without Tech Lead ADR status-line update; Batch 1 items (cr-101..105, cr-201) carry `user_confirmed（决策引用）` per §8.1 R01–R03; AUTH-01 registered per §8.2（P1–P3 流程 + D1–D3 委托 + 硬边界防火墙——不含实现授权，未提升任何候选预算）; Batch 2 items (cr-109, cr-106, cr-114, cr-113, cr-202) carry `user_confirmed（决策引用）` per §8.3 R04–R08; Batch 3 item (cr-001) carries `user_confirmed（决策引用）` per §8.4 R09; DC-ANCH-01邻卡 item (cr-301) now carries `user_confirmed（决策引用）` per §8.5 R10 —— **needs_user_decision = 0（全部决策完成，治理准备阶段决策批次收官）**; ADR-TECH-01..06 approved（§8.6 R11，用户决策）; implementation owner = Godot Gameplay Engineer confirmed（§8.6 R12，user 决策；条件①满足，②③待）; Tech Lead to update ADR-TECH-01..06 status lines to `approved` in the Tech-owned ADR package (§18 dossier coordination, not performed here); TECH-07/08 remain `draft_in_review` / `NOT APPROVED`; **ADR approval ≠ implementation authorization**; **implementation authorized (§8.7 R13, user_confirmed) — transitioned `NOT_AUTHORIZED → 授权生效` within approved contracts (ADR-TECH-01..06 + decided decisions); TECH-07/08 not in scope; candidate budgets not promoted; QA independent acceptance not waived; GDMCP preflight (doctor/editor-state) is the start prerequisite (⏳ 待验证 — user configured, implementation-member preflight pending), actual start requires preflight pass + start evidence — authorization registration ≠ GDMCP preflight pass**; kickoff: `not_ready → 授权生效`（实际动工待预检通过）; no candidate budget promoted |
| Invariants preserved | **22** original `user_confirmed` inputs; **exactly 8** canonical `v0.1-revision-02` inputs + **separate** current Charter authorization record (not a 9th item); **PRECHARTER-01..11**; four provenance layers (`user_confirmed` / `team_proposal` / `assumption` / `unresolved`); **all unresolved retained unresolved** — Batch 1（2026-08-16）例外仅限被决策项：cr-101..105、cr-201 升为 `user_confirmed（决策引用）`（§8.1 R01–R03），其余全部保留 open；AUTH-01 授权登记（§8.2，2026-08-16）与 Batch 2 决策登记（§8.3 R04–R08，2026-08-16）与 Batch 3 决策登记（§8.4 R09，2026-08-16）与 DC-ANCH-01 决策登记（§8.5 R10，2026-08-16）与 **ADR 批准 + owner 任命确认登记（§8.6 R11/R12，2026-08-16）** 与 **实现授权登记（§8.7 R13，2026-08-16）** 未改变上述任何一项——22 / 8+1 / PRECHARTER-01..11 / 四层 provenance / unresolved 全量（Batch 1 例外仅限被决策项 cr-101..105、cr-201；Batch 2 例外仅限被决策项 cr-109、cr-106、cr-114、cr-113、cr-202；Batch 3 例外仅限被决策项 cr-001；DC-ANCH-01 例外仅限被决策项 cr-301；**ADR 批准项为 ADR-TECH-01..06 状态行升级（由 Tech Lead 执行，非本 ledger 数值/决策升级），owner 任命确认为 named owner 落定（非新决策/非数值）；R13 为已批准契约内实现授权生效（非新契约、非数值提升、非 charter 变更）**）/ 候选预算（六项 + 1280×720 红线）均保持原状 |

### 1.1 Sources actually inspected (static/source only)

1. `docs/DEVELOPMENT_CHARTER_DRAFT_v0_1.md` — canonical Charter, authorization record, 22 decisions, 8 revision-02 inputs, PRECHARTER-01..11, scope caps, gates, open decision register (§12).
2. `docs/architecture/KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` — ADR-TECH-01..08 candidates, unresolved registers, measurement/export boundaries (`PROPOSAL / DRAFT / NOT APPROVED`).
3. `docs/creative/KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md` — rules vocabulary, canonical order, target/no-target, contact/re-arm, upgrade, B2, HUD/observability, ledger template (`PROPOSAL / DRAFT / NOT APPROVED`).
4. `docs/ux/KICKOFF_UX_UI_CONTRACTS_v0_1.md` — state matrix, focus/epoch, accessibility/responsive, evidence matrix UX-01..13 (`PROPOSAL / DRAFT / NOT APPROVED`).
5. `docs/architecture/KICKOFF_CROSS_REVIEW_MATRIX_v0_1.md` — reconciled ownership, seam matrix, unresolved register, 8/9 count correction evidence.
6. `docs/architecture/KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md` — five-layer envelope, version/identity rules, compatibility behavior (`team_proposal`).
7. `docs/evidence/KICKOFF_EVIDENCE_INDEX_AND_DISPOSITIONS_v0_1.md` — index/retention proposal, authority disposition ledger, Gate 0/1 `blocked`-pending-re-review state (historical; superseded by latest QA verdict per coordination facts).
8. `docs/visual/anchor/ANCHOR_DECISION.md` — Anchor v0.1 accepted static baseline; v0.2 authorized candidate; open items §7 (v0.2 review gate and user baseline decision are registered below as a neighboring pending item).
9. `docs/production/KICKOFF_READINESS_ASSESSMENT_v0_1.md` — 8 项实现授权前置条件核对基准（rev-7 登记 R13 时逐项核对；当前状态 = 静态/推进中）。
10. `docs/production/IMPLEMENTATION_OWNER_NOMINATION_v0_1.md` — 实现 owner 任命提案（write ownership §2.3、任命条件 §2.5、stop conditions §2.4；R12 已确认）。
11. `docs/DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（rev-7 核对 Charter 边界与授权契约范围，如需要）。

### 1.2 Cross-check of count invariants (conducted, no new facts asserted)

- The historical `8/9` contradiction is closed: current canonical sources (`CROSS_REVIEW_MATRIX §2.2`, `SYSTEMS_RULES §13.3`, Evidence index §3.2) all state **exactly 8 canonical `v0.1-revision-02` inputs** (promise/pillars/cap; candidate architecture; reproducibility; target snapshot; safety/terminal; playability gate; performance; platform) with the **current Charter authorization as a separate record/provenance event** — never a ninth item. This ledger adopts that corrected count. The stale `8/9` wording is retained only as historical QA provenance; Independent QA Gate 1 re-review remains in the review chain as applicable.
- **22 decisions, PRECHARTER-01..11, four provenance layers:** verified present in Charter §6 with unresolved boundaries retained; repeated verbatim nowhere here, referenced by ID only.

### 1.3 Candidate-budget state (candidate only — repeated for the record)

`1080p / 60 FPS`, `50 FPS minimum`, input `≤50ms`, hit-feedback start `≤100ms`, cold start `<3s`, restart `<1s` remain **candidate budgets only** (Charter §6; PRECHARTER-10; revision-02 input 7; ADR-TECH-07). They are **not** hard gates, observed results, release commitments, or acceptance thresholds. **Any promotion to a formal threshold / acceptance criterion / release condition requires a Change Request + explicit user decision** (see cr-109 / DC-PERF-01, and the standing rule in §4.4). **Batch 1（2026-08-16）未提升任何候选预算：** DC-PLAT-02 Option 2 下的 `1280×720` 最低分辨率红线仍为**仅候选**（须 CR + 用户批准才成为正式门槛），独立于上述六项；宽屏支持集 {16:9, 16:10, 21:9} 仅作为方向性支持承诺候选（§8.1 R03）。

---

## 2. Change Request protocol applied (as mandated)

Every entry below carries: `cr_id`; 来源原始表述 (source + verbatim/attributed wording); 当前 Charter 版本与受影响的 immutable_decisions; 产品/创意/技术/范围/进度影响; 被挤出的工作与依赖/风险/回滚或验证成本; Producer disposition; and, where disposition is `needs_user_decision`, the decision card membership, decision owner, decision window, post-approval owner, and acceptance standard.

Disposition vocabulary (fixed): `reject` | `defer` | `absorb_within_authority` | `needs_user_decision` | `reauthorize_charter`.

Reading conventions for this ledger:

- `absorb_within_authority` means the item is resolvable by the named role(s) as a proposal/experiment within already-confirmed `user_confirmed` boundaries (ledger, fixture, measurement protocol, mechanism proposal, review). It never means "approved" or "closed": the result stays `team_proposal` / `unresolved` until evidence and, where applicable, a user decision. If resolving it would cross promise/immutable/platform/threshold/release, the item escalates to `needs_user_decision` / `reauthorize_charter` instead.
- `needs_user_decision` means the item crosses a product-level or reserved-threshold boundary (or confirms one) and only the User may decide; the User is never asked to resolve a purely local technical detail.
- `defer` means safe to postpone without blocking readiness sequencing; reopened later at a named gate, never by silence.

---

## 3. CR registry — Cluster ①: Rules & gameplay (规则与玩法)

Sources: Charter §6/§12; PRECHARTER-01..05, 08, 11; Systems contract §§4–8, 10; Tech ADR-TECH-04/05; UX §§4–5, 8. All are `unresolved` today **except cr-001, which is decided (→ `user_confirmed（决策引用）`, §8.4 R09)**; its open detail (cluster membership/metric/quantization/tie-break/stable-ID lifecycle/invalidation/timing) remains `unresolved`, delegated to cr-002..005.

| cr_id | 待决项（来源原始表述核心） | 当前 Charter 版本 / 受影响的 immutable_decisions | 产品/创意/技术/范围/进度影响 | 被挤出的工作 / 依赖 / 风险 / 回滚或验证成本 | Disposition |
|---|---|---|---|---|---|
| cr-001 | **Target 语义原则（簇定义与排序原则）**：「refresh the nearest-threat cluster → stable-sort → lock that shot's target snapshot」(revision-02 #4)；「nearest threat, cluster-center distance, then stable ordering/stable ID」(PRECHARTER-02)；exact cluster membership/metric unresolved (ADR-TECH-04 §"Unresolved detail register"; Systems §5.1) | Charter v0.1；决策 #3（pre-fire 刷新+锁定）；revision-02 #4；PRECHARTER-02 | **产品**：直接决定「移动→下一次自动攻击」因果可读性（pillar 2/4）；**技术**：决定排序算法、快照与 fixture 语义；**范围/进度**：最小确定性核心 seam 的契约与 fixture 依赖此项 | 被挤出：target fixture 系列（no-target/ties/removal）无法定型直到原则选定；依赖：Systems 语义 + Tech 机制；风险：原则不明则因果可读性不可观察；验证成本：选定后需 fixture + QA Gate 2 观察 | `needs_user_decision`（决策包 DC-SYS-01）—— **已决策 → `user_confirmed（决策引用）`**（§8.4 R09：DC-SYS-01 → Option A「确认候选方向」；exact cluster membership/metric/quantization/tie-break/stable-ID 生命周期/失效·时点仍保持 `unresolved`，移交 cr-002..005） |
| cr-002 | **距离度量/量化与 tie-break 字段**：metric/quantization, tie-break fields unresolved (ADR-TECH-04; Systems §5.1) | Charter v0.1；PRECHARTER-02 | 技术为主；tie-break 直接影响确定性排序与 fixture 稳定性；间接影响可读性 | 依赖 cr-001 选定原则；风险：容器顺序依赖导致非确定；验证：排序 fixture + 追踪字段 | `absorb_within_authority`（Systems/Rules + Tech 依 cr-001 原则提案；fixture 验证；不触碰承诺） |
| cr-003 | **stable-ID 生命周期**：allocation, reuse, serialization unresolved (ADR-TECH-03/04; Matrix §8) | Charter v0.1；PRECHARTER-01/02 | 技术：追踪/快照/复现审计基础；错误 ID 生命周期会破坏 fixture 与证据链 | 依赖 cr-001 原则；风险：ID 重用导致复现不一致；验证：复现 fixture + QA 审计 | `absorb_within_authority`（Tech 提案；Session 持有；QA 审计） |
| cr-004 | **目标失效时机 / 射击中目标移除**：invalidation timing, target removal during shot unresolved (ADR-TECH-04; Systems §5.1 §6) | Charter v0.1；决策 #3；revision-02 #4 | 产品：失效语义错误会使锁定快照「打空气」或错误命中；技术：事件排序 | 被挤出：锁定后失效场景 fixture；依赖 cr-001/003；风险：移除目标被当作有效命中（禁令明确）；验证：removal fixture | `absorb_within_authority`（Tech + Systems 提案；fixture 验证） |
| cr-005 | **no-target 节奏与反馈形态**：exact no-target cycle timing, feedback form unresolved (ADR-TECH-04; Systems §5.2; UX §3 no-target row) | Charter v0.1；决策 #3；PRECHARTER-02（no-target 分支明确存在，禁止伪造目标） | 产品：自动攻击循环的可读性（quiet cycle 等形态未定）；UX：反馈不得误导命中 | 依赖 cr-001；风险：误导性命中反馈违反产品边界；验证：no-target 确定性 trace + UX/QA 观察 | `absorb_within_authority`（Systems 提案形态 → UX 观察目标 UX-03；若形态触碰产品承诺则升级） |
| cr-006 | **接触无敌时长 / 全局 vs 成对保护**：duration, global-or-pair unresolved (ADR-TECH-05; Systems §6.2; PRECHARTER-03) | Charter v0.1；决策 #4（一次接触伤害+轻分离）；PRECHARTER-03 | 产品：惩罚感/粘滞感；成对 vs 全局决定多敌接触体验 | 被挤出：CONTACT fixture 系列值；依赖：ledger (PRECHARTER-04)；风险：过早锁定常数；验证：重叠/分离/再接触 trace + QA | `absorb_within_authority`（Systems ledger：range + starting point；promotion 需证据+授权） |
| cr-007 | **分离距离/方向/边界行为**：separation distance/direction, boundary behavior unresolved (Systems §6.2; ADR-TECH-05) | Charter v0.1；决策 #4；PRECHARTER-03 | 产品：可恢复间距（pillar：非惩罚节奏）；边界处分离失败风险 | 被挤出：CONTACT-boundary fixture；风险：逃逸穿界或粘滞；验证：boundary fixture | `absorb_within_authority`（Systems ledger；Tech 几何协作） |
| cr-008 | **堆叠 / 同时接触**：simultaneous contacts, stacking unresolved (Systems §6.2 CONTACT-simultaneous; ADR-TECH-05) | Charter v0.1；决策 #4（一次接触伤害事件）；PRECHARTER-03 | 产品：同时多敌接触是否叠加为一次事件（规则含义）；范围：不新增伤害规则 | 被挤出：CONTACT-simultaneous fixture；风险：若堆叠改变「单次接触伤害」承诺 → 升级用户；验证：fixture 明确报告未决 | `absorb_within_authority`（Systems 提案；触碰承诺即升级 `needs_user_decision`） |
| cr-009 | **玩家/敌人边界与分离失败**：player/enemy boundary cases, separation failure unresolved (Systems §6.2; Matrix §4 contact row) | Charter v0.1；决策 #4 | 产品：可恢复性红线；技术：碰撞几何 | 风险：不可恢复重叠（粘滞）→ 玩家死亡不可读；验证：boundary fixture | `absorb_within_authority`（Systems + Tech 提案） |
| cr-010 | **升级触发 / 窗口**：trigger measurement, candidate windows ~2–3 min & 4.5–6 min remain candidates (PRECHARTER-05; Systems §7.1; ADR-TECH-05) | Charter v0.1；决策 #8（两次全场暂停）；PRECHARTER-05 | 产品：升级节奏（两次保证暂停的时机）；窗口数值是候选，不是常数 | 被挤出：trigger/XP fixture；风险：候选窗口被提前写死（禁令）；验证：ledger + 授权 promotion | `absorb_within_authority`（Systems/Balance ledger；转固定/发布承诺 → CR + 用户） |
| cr-011 | **XP 来源/数值与卡牌值/差异维**：XP source/values, card pool, variants, values, copy, icons, difference dimension unresolved (PRECHARTER-05/08; Systems §7; UX §5.2; ADR-TECH-05) | Charter v0.1；决策 #7（三张同关键词卡）；#9（XP 仅作中间物）；PRECHARTER-08 | 产品：卡牌可比较性（低认知选择 pillar）；卡牌内容若成发布承诺 → 用户 | 被挤出：卡牌内容提案（Systems/Balance 数值 + UX 文案/布局）；风险：同关键词可读性失败；验证：UX-04/05 + Balance 模拟 | `absorb_within_authority`（Systems/Balance + UX 提案；文案/数值若成发布承诺 → 用户） |
| cr-012 | **Focus epoch 机制**：event policy, epoch increments, return-focus target, platform behavior unresolved (ADR-TECH-05; UX §4; PRECHARTER-09) | Charter v0.1；决策 #17/19；PRECHARTER-09（冻结/保留/新鲜输入/拒陈旧） | 产品：失焦安全（陈旧确认禁令）；技术：epoch 机制 | 被挤出：epoch 机制提案 + UX-06/07/08 fixture；风险：隐藏进度或陈旧确认；验证：focus 场景 + QA | `absorb_within_authority`（Tech 机制 + UX 安全含义定义；QA 观察） |
| cr-013 | **Focus-loss buffer/刷新语义**：flush/buffer semantics, stale-input rejection detail unresolved (ADR-TECH-05; UX §4.4) | Charter v0.1；PRECHARTER-09；决策 #17 | 产品：失焦后无可疑自动确认；技术：缓冲清除时机 | 依赖 cr-012；风险：缓冲区误放陈旧 Enter/Space；验证：stale-input fixture | `absorb_within_authority`（Tech + UX 提案） |
| cr-014 | **终局/重置事件排序**：same-tick ordering, result duration, input lock unresolved (PRECHARTER-11; ADR-TECH-05; Systems §4 步骤 4–6) | Charter v0.1；决策 #5/#12；PRECHARTER-11（同帧生命耗尽优先于八分钟胜利） | 产品：胜利/失败呈现与立即重试节奏；技术：仲裁顺序 | 被挤出：terminal/reset fixture；风险：回调顺序改变结果；验证：life-depletion-over-victory fixture + QA | `absorb_within_authority`（Tech + Systems 提案；优先级边界已确认） |
| cr-015 | **same-tick 清理**：cleanup list, RNG/ID reset, queued input handling unresolved (ADR-TECH-05; ADR-TECH-03; Systems §7.2) | Charter v0.1；决策 #5；PRECHARTER-01/11 | 产品：干净重启（无越局损失）；技术：重置事务 | 被挤出：reset trace；风险：脏状态泄入新局；验证：reset trace + QA | `absorb_within_authority`（Tech/Session 提案） |
| cr-016 | **B2 几何**：arc geometry, angular spread, spacing, length, collision shape unresolved (Systems §8.2; UX §8; Matrix §4 B2 row) | Charter v0.1；决策 #6（固定穿透上限、独立计数）；PRECHARTER 相关 | 产品：B2 同源可读性（中心+左右弧不遮玩家/危险/空间）；范围：不成为持久光场 | 被挤出：B2 fixture + UX-11；风险：奇观遮蔽清屏（Director/QA 停线）；验证：before/impact/after 帧 | `absorb_within_authority`（Systems/Tech + Director 输入；遮蔽 → 升级） |
| cr-017 | **重复命中策略**：duplicate-hit policy unresolved (Systems §8.2; ADR-TECH-04; Matrix §4) | Charter v0.1；决策 #6 | 产品：同一目标是否被多弧重复命中；独立计数语义 | 依赖 cr-016；风险：重复命中破坏独立预算；验证：B2 fixture | `absorb_within_authority`（Systems 提案） |
| cr-018 | **目标共享**：target sharing unresolved (Systems §8.2; ADR-TECH-04) | Charter v0.1；决策 #6 | 产品：多弧共享目标与命中归属；计数独立性 | 依赖 cr-016/017；验证：B2 fixture | `absorb_within_authority`（Systems 提案） |
| cr-019 | **衰减 / 穿透命中上限值**：fixed piercing hit cap (boundary confirmed), light later-hit attenuation, independent counters; **values** unresolved (决策 #6; Systems §8.2; PRECHARTER-05) | Charter v0.1；决策 #6 | 产品：杀伤层级可读性；数值必须走 ledger | 被挤出：attenuation/pierce 数值实验；风险：过早写死；验证：ledger + 授权 promotion | `absorb_within_authority`（Systems/Balance ledger） |
| cr-020 | **tick 频率与会话定时语义**：exact tick frequency, same-tick semantics unresolved (PRECHARTER-01; ADR-TECH-03; Systems §3.2) | Charter v0.1；PRECHARTER-01；revision-02 #3 | 技术：确定性复现基础；若频率影响产品/性能范围 → 升级用户 | 被挤出：tick/seed 契约；依赖 ADR-TECH-03；验证：复现 fixture | `absorb_within_authority`（Tech + Systems 提案；触碰产品/性能范围 → 升级） |

---

## 4. CR registry — Cluster ②: Platform & acceptance (平台与验收)

Sources: Charter §6/§12; revision-02 #7/#8; ADR-TECH-07/08; UX §§7, 9, 12; Evidence Schema contract §§4, 8, 11; Evidence index §6. Today: cr-101..cr-105 carry Batch 1 decision references (`user_confirmed（决策引用）`, §8.1 R01/R03); cr-106, cr-109, cr-113, cr-114 carry Batch 2 decision references (`user_confirmed（决策引用）`, §8.3 R04–R07); cr-107, cr-108 remain `absorb_within_authority`（Tech 提案 + QA 审计——测量身份推进，R04 决策引用）.

| cr_id | 待决项（来源原始表述核心） | 当前 Charter 版本 / 受影响的 immutable_decisions | 产品/创意/技术/范围/进度影响 | 被挤出的工作 / 依赖 / 风险 / 回滚或验证成本 | Disposition |
|---|---|---|---|---|---|
| cr-101 | **OS 平台目标**：「Retain PC-first… No named OS」explicit (revision-02 #8; Charter §6 platform boundary; ADR-TECH-08) | Charter v0.1；决策 #18/21；revision-02 #8 | **平台**：决定工具链、QA 矩阵、性能/导出验证成本；下游一切证据身份依赖 | 被挤出：OS 相关 QA/export 排期；依赖：所有下游批；风险：选定即隐含发布承诺；回滚：未选前零成本 | `needs_user_decision`（决策包 DC-PLAT-01）—— **已决策 → `user_confirmed（决策引用）`**（§8.1 R01：DC-PLAT-01 → Option P1） |
| cr-102 | **导出目标（export target）**：export target, artifact requirements unresolved (Charter §6; ADR-TECH-08; Matrix §8) | Charter v0.1；决策 #21；revision-02 #8 | 平台/进度：Gate 5 export smoke 判据依赖目标身份；范围：不选则不承诺 | 依赖 cr-101；风险：未命名目标即无 Gate 5 前置；验证：export smoke 后续 | `needs_user_decision`（并入 DC-PLAT-01）—— **已决策 → `user_confirmed（决策引用）`**（§8.1 R01：单 Windows 打包产物） |
| cr-103 | **发布平台/渠道与本期发布姿态**：no release platform / distribution channel named (Charter §6/§12; UX §7; ADR-TECH-08「does not choose… distribution channel」) | Charter v0.1；决策 #21；release 相关边界 | 产品/范围：是否承诺本期发布；决定 Gate 6 与发布文案范围 | 依赖 cr-101/102；风险：发布姿态未明则 release 排期悬浮；验证：Gate 6 | `needs_user_decision`（并入 DC-PLAT-01；发布阈值另见 cr-113）—— **已决策 → `user_confirmed（决策引用）`**（§8.1 R01：本期不发布，Gate 6 按内部复审姿态） |
| cr-104 | **最低分辨率（红线）**：minimum resolution unresolved, user-reserved (PRECHARTER-06; UX §7「Reserved thresholds」; Charter §12 row) | Charter v0.1；决策 #18（16:9 基线+可读红线）；PRECHARTER-06 | 产品/UX：布局、安全区、可读性红线；QA 矩阵（UX-09/12）依赖 | 被挤出：resolution fixture/QA 排期；依赖 cr-101（OS）；风险：偏窄支持集限制玩家；验证：UX-09/12 | `needs_user_decision`（决策包 DC-PLAT-02）—— **已决策 → `user_confirmed（决策引用）`**（§8.1 R03：`1280×720` 红线仍仅候选） |
| cr-105 | **宽屏支持集与缩放/letterbox/crop 策略**：common widescreen candidate; scaling/letterbox/crop rules unresolved (UX §7; PRECHARTER-06; Charter §6) | Charter v0.1；决策 #18 | 产品：不同比例下可读性；承诺面：支持集若成发布承诺 → 用户 | 依赖 cr-104；风险：拉伸文字/卡牌或裁切 HUD；验证：UX-12 + 16:9 回归 | `needs_user_decision`（并 DC-PLAT-02；策略细节由 UX 依选定集提案）—— **已决策 → `user_confirmed（决策引用）`**（§8.1 R03：支持集 {16:9,16:10,21:9} 候选 + fit/禁 stretch/禁 crop） |
| cr-106 | **可访问性阈值**：contrast, min text/focus-target size, flash frequency, motion duration, reduced-motion unresolved (UX §7; PRECHARTER-06/09; Charter 决策 #19) | Charter v0.1；决策 #19（基本可访问性基线） | 产品/合规：非颜色通信、聚焦可见、节制闪动；阈值若成发布承诺 → 用户 | 被挤出：UX-13 覆盖与阈值表；风险：无障碍失败阻塞发布；验证：UX-13 + QA | `needs_user_decision`（决策包 DC-ACC-01；UX/UI 制备）—— **已决策 → `user_confirmed（决策引用）`**（§8.3 R05：DC-ACC-01 → Option A2「轻量候选规范」——内部候选数值表仍仅候选） |
| cr-107 | **性能硬件基线命名**：named hardware/OS/settings unresolved (ADR-TECH-07 §Protocol; Matrix §8) | Charter v0.1；PRECHARTER-10；决策 #21 | 技术：测量可审计性的前置；Producer 裁定：命名测量硬件属技术细节 → Tech 提案 + QA 审计；若硬件规格进入发布承诺 → 升级用户（cr-109 承接） | 被挤出：性能样本；风险：无身份证不可审计；验证：raw samples + QA 复核 | `absorb_within_authority`（Tech Lead 提案协议；QA 审计；承诺化 → 升级） |
| cr-108 | **性能采样方法与 percentile/时钟权威**：sampling method, percentile definition, clock authority unresolved (ADR-TECH-07; Evidence Schema §6.1; Matrix §8) | Charter v0.1；PRECHARTER-10；决策 #21 | 技术：percentile/采样定义决定数字含义；Producer 裁定属协议细节 → Tech 提案 + QA 审计 | 风险：候选预算不可审计；验证：采样窗口/percentile 记录 | `absorb_within_authority`（Tech Lead 提案；QA 审计；硬门槛化 → cr-109 升级） |
| cr-109 | **性能阈值权威：候选预算是否提升为正式门槛**：「Keep 1080p/60 target and other numbers provisional until measurement and named hardware」vs promote (Charter §12 performance row; revision-02 #7; PRECHARTER-10) | Charter v0.1；PRECHARTER-10；决策 #21 | **阈值**：软候选 vs 硬门槛，直接影响范围/发布确定性；**必须标注**：「仅候选，须经 CR + 用户批准才成为正式门槛」 | 被挤出：硬门槛后的性能 QA 成本；依赖 cr-107/108 与测量后证据；风险：过早硬化阻断范围/平台；验证：named decision record | `needs_user_decision`（决策包 DC-PERF-01；Tech Lead 制备）—— **已决策 → `user_confirmed（决策引用）`**（§8.3 R04：DC-PERF-01 → Option A——六项候选预算全部保持仅候选；cr-107/108 以测量身份推进；测量后新 CR 再呈交） |
| cr-110 | **Fixture schema 细节**：fixture fields/expected facts unresolved; `fixture_schema_version` pending (ADR-TECH-06; Evidence Schema §4/§6; Systems §5.3/11) | Charter v0.1；PRECHARTER-01/04 | 技术：确定性 gate 的证据形状 | 被挤出：fixture 系列；依赖 cr-001/002；风险：schema 不兼容 → `schema_incompatible` | `absorb_within_authority`（Systems 语义 + Tech 表述；QA 审计） |
| cr-111 | **Schema/config 兼容规则**：exact version matching, no silent coercion/alias/tolerance; migration policy unresolved (Evidence Schema §§4, 8; ADR-TECH-06) | Charter v0.1；PRECHARTER-01 | 技术：证据可比较性 / 复现审计 | 风险：静默不兼容比较 = 假 pass；验证：compare 行为契约 | `absorb_within_authority`（Tech 提案；QA 审计；公开授权差异才允许容差） |
| cr-112 | **Build identity 规则**：source/build/profile/toolchain/target/artifact digest rules unresolved (ADR-TECH-08; Evidence Schema §4.1) | Charter v0.1；决策 #21 | 技术：运行时/性能/导出证据身份；依赖 cr-101 平台选定后补 target 身份 | 风险：无身份则证据不可审计；验证：build identity 记录 | `absorb_within_authority`（Tech + Toolchain 提案；平台选定后激活） |
| cr-113 | **发布阈值 / 放行条件**：acceptance thresholds, evidence tolerances, release gates unresolved (Charter §12; ADR-TECH-07「Verification」; Evidence index §6) | Charter v0.1；发布与验收类边界；Gate 6 | **产品/发布**：什么构成可发布；QA 放行姿态与 Producer 无豁免权 | 被挤出：Gate 6 判据/证据包；依赖 cr-109/106/114；风险：未定义即发布不可判定；验证：QA 独立放行 | `needs_user_decision`（决策包 DC-REL-01；QA/Release + Producer 制备）—— **已决策 → `user_confirmed（决策引用）`**（§8.3 R07：DC-REL-01 → Option 2（O2）「证据完整放行」——本期不发布；零容差为 QA 职权内证据规则） |
| cr-114 | **视觉/可用性验收标准**：visual/usability acceptance criteria, occlusion/readability red line, evidence acceptance thresholds unresolved (UX §12 open decisions; Charter §12) | Charter v0.1；决策 #18/19；UX-09..13 | **产品/验收**：Gate 3 判据、遮挡红线、证据接受阈值 | 依赖 cr-104/105/106；风险：无红线则视觉 QA 无法判定；验证：UX-09..13 + QA | `needs_user_decision`（决策包 DC-ACC-02；UX/UI 制备 + Director 输入）—— **已决策 → `user_confirmed（决策引用）`**（§8.3 R06：DC-ACC-02 → Option B3「证据收紧」——定性红线 + 严格证据完整性规则） |

---

## 5. CR registry — Governance / architecture / neighboring open items

| cr_id | 待决项（来源原始表述核心） | 当前 Charter 版本 / 受影响的 immutable_decisions | 产品/创意/技术/范围/进度影响 | 被挤出的工作 / 依赖 / 风险 / 回滚或验证成本 | Disposition |
|---|---|---|---|---|---|
| cr-201 | **候选架构 seam 处置**：「Accept proposed rules/state/session/adapter architecture boundary?」— candidate only, ADR-required (revision-02 #2; Charter §12 row; ADR-TECH-01) | Charter v0.1；revision-02 #2 | **架构风险**；技术：ADR-TECH-01..08 定稿路径；范围：seam 影响一切契约 | 被挤出：ADR 定稿与最小核心 seam 计划；依赖：Tech 提案；风险：架构风险穿越需用户；验证：ADR 评审 + QA 证据计划 | `needs_user_decision`（决策包 DC-ARCH-01；Tech Lead 制备）—— **已决策 → `user_confirmed（决策引用）`**（§8.1 R02：Option A1，边界保持候选） |
| cr-202 | **可玩性观察门是否正式化**：「Make playability observation a formal gate?」 (revision-02 #6; Charter §12 row; Systems §9.2) | Charter v0.1；revision-02 #6（候选方向） | 产品/范围：正式门可阻止内容扩张；静态文档不能通过 | 被挤出：gate 判据 + QA 预检；风险：正式门成本 vs 咨询性降级；验证：门内观察 | `needs_user_decision`（决策包 DC-PLAY-01；Systems + QA 制备）—— **已决策 → `user_confirmed（决策引用）`**（§8.3 R08：DC-PLAY-01 → Option 2「分阶正式化」——判据结构生效、阻断权延后经 CR + 用户批准激活） |
| cr-203 | **Replay 承诺范围细节**：QA/debug-only reproducibility is candidate-confirmed; player-visible Replay explicitly absent; exact schema/cadence/ownership unresolved (revision-02 #3; ADR-TECH-03) | Charter v0.1；revision-02 #3；PRECHARTER-01 | 产品：不新增 Replay 承诺；技术：快照/追踪 schema | 被挤出：trace/snapshot 契约；风险：任何 player-visible Replay 提议 → CR + 用户；验证：复现 fixture | `absorb_within_authority`（Tech 提案细节；Replay 提议 → 升级） |
| cr-301 | **邻近：Anchor 基线是否升级 v0.2**（不属于两大簇）：「v0.2… requires independent Game Director / Creative Director review and then a separate user decision」 (ANCHOR_DECISION.md §78; v0.2 remains unaccepted candidate) | Charter v0.1；Anchor 条款（v0.1 基线；v0.2 不得静默替换） | 产品/创意：视觉基线；若选 v0.2 → 影响后续资产方向（仍需 Director 复审与用户决定） | 被挤出：创意复审闭合（ANCHOR_REVIEW_v0_2.md 未在本任务读取，留待父协调器/后续复审提供 Director 结论）；风险：v0.2 静默替换（禁令）；验证：独立 Director 复审 + 用户决定 | `needs_user_decision`（决策包 DC-ANCH-01；Game Director 制备，经父协调器派发；不属于指定的三簇制备角色映射）—— **已决策 → `user_confirmed（决策引用）`**（§8.5 R10：DC-ANCH-01 → Option 1「保持 v0.1 基线，v0.2 维持候选」；`recommend-revision` 剩余项登记为未来版本化修订候选） |

---

## 6. Producer disposition summary

| Disposition | Count | cr_ids |
|---|---|---|
| `reject` | 0 | — (no pending item warrants outright rejection at this readiness stage; items not needed are deferred instead) |
| `defer` | 0 | — (no item is safe to park before readiness without a named gate; all absorb items have an owner and ledger/evidentiary route) |
| `absorb_within_authority` | 25 | cr-002..cr-020（规则/技术机制、数值走 ledger）、cr-107, cr-108, cr-110, cr-111, cr-112、cr-203 |
| `needs_user_decision`（仍等待决策） | **0** | — （**全部决策完成**：Batch 1/2/3 + DC-ANCH-01 邻近卡均已 closed as decided；治理准备阶段决策批次收官） |
| Batch 1 已决策（`user_confirmed` 决策引用，§8.1 R01–R03） | 6 | cr-101, cr-102, cr-103, cr-104, cr-105, cr-201 |
| Batch 2 已决策（`user_confirmed` 决策引用，§8.3 R04–R08） | 5 | cr-109, cr-106, cr-114, cr-113, cr-202 |
| Batch 3 已决策（`user_confirmed` 决策引用，§8.4 R09） | 1 | cr-001 |
| DC-ANCH-01 已决策（`user_confirmed` 决策引用，§8.5 R10） | 1 | cr-301 |
| ADR-TECH-01..06 批准（`user_confirmed` 决策引用，§8.6 R11） | — | ADR-TECH-01/02/03/04/06 全量批准；TECH-05 机制边界批准（精确语义延后）；**TECH-07/08 未批准（保持 `draft_in_review`）** |
| 实现 owner 任命确认（`user_confirmed` 决策引用，§8.6 R12） | — | named owner = **Godot Gameplay Engineer**（依据 `IMPLEMENTATION_OWNER_NOMINATION_v0_1.md`）；任命条件①满足，②③待 |
| 实现授权（`user_confirmed` 决策引用，§8.7 R13） | — | implementation `NOT_AUTHORIZED → 授权生效`（契约内 ADR-TECH-01..06 + 已决决策范围；TECH-07/08 不进入）；边界注记：契约内 / **GDMCP 预检前置（⏳ 待验证）** / QA 不豁免 / 候选预算不提升；kickoff：not_ready → 授权生效（实际动工待预检通过与 start 证据） |
| `reauthorize_charter` | 0 | — no crossing is being proposed now; any option selected later that changes promise/immutable/platform/release will escalate to this disposition at that time（**Batch 1 三项、Batch 2 五项、Batch 3 一项与 DC-ANCH-01 一项选定均未触发（§8.1/§8.3/§8.4/§8.5）**，见下方 Producer note；DC-ANCH-01 选 2 才会触发该路径——本决策选 Option 1；**ADR-TECH-01..06 批准 + owner 任命确认亦未触发（§8.6 R11/R12——批准为契约生效、非实现授权/非 charter 变更；owner 任命为 named owner 落定、非新角色/非 scope 扩张）；实现授权登记（§8.7 R13）亦未触发——为已批准契约内实现授权生效，非新契约/非数值提升/非 promise/immutable/platform/release/charter 变更，候选预算未提升**） |

Producer note: `reject`/`defer` are not used at this stage by design — every registered item either resolves within an authorized role (absorb) or waits for an explicit user decision (needs_user_decision). Nothing is dropped silently; nothing is resolved by silence.

**Batch 1（2026-08-16）决策登记：** 三项需求决策已由用户选定并登记为 `user_confirmed`（provenance = 用户决策），见 §8.1 —— DC-PLAT-01 → Option P1（cr-101/102/103）；DC-ARCH-01 → Option A1（cr-201）；DC-PLAT-02 → Option 2「Balanced」（cr-104/105）。对应 cr 行状态更新为 `user_confirmed（决策引用）`；其余未选项（P2/P3、A2/A3/A4、Option 1/3/4）保持 `unresolved`/`team_proposal`。

**reauthorize_charter 触发条件与结论（2026-08-16）：** 触发条件 = 支持集或渠道或红线数值若写入发布承诺 / 发布文案 / Gate 判据 → 触发。**当前三项决策均未触发：** P1 本期不发布（无渠道/发布承诺）；A1 边界保持候选（ADR 仍为提案，架构风险未穿越）；Option 2 支持集 {16:9,16:10,21:9} 仅为方向性支持承诺候选、`1280×720` 红线数值仍仅候选（未写入发布承诺、发布文案或 Gate 判据）。

**reauthorize_charter 结论（Batch 2，2026-08-16）：** 本批五项亦均未触发——R04 保持候选未提升数值；R05 内部候选规范不写 Gate/发布；R06 证据完整性规则非数值门槛；R07 未来放行姿态（本期不发布）、零容差为 QA 职权内证据规则；R08 阻断权延后且激活必经 CR + 用户批准。逐条记录与未来触发点见 §8.3 R04–R08 及 §8.3 末结论。

**reauthorize_charter 结论（Batch 3，2026-08-16）：** 本批一项亦未触发——R09（DC-SYS-01 → Option A）无任何数值门槛/发布承诺/Gate 判据写入、promise/immutable/platform 语义均未改变（仅确认既有 `user_confirmed` 候选方向，决策 #3 / revision-02 #4 / PRECHARTER-02 语义不变）；本卡属 D2 升级类整卡呈交用户亲自选择，用户选择 **A（非升级项）** → 未触发。未选项 Option B、C、D 保持 `unresolved` / `team_proposal`。逐条记录见 §8.4 R09。

**reauthorize_charter 结论（DC-ANCH-01，2026-08-16）：** 本卡一项亦未触发——R10（DC-ANCH-01 → Option 1）维持 v0.1 基线，不改变 Charter 记录的 Anchor 基线条款（选 2 升级 v0.2 才会触发正式变更→触发该路径）；无任何数值门槛/发布承诺/Gate 判据写入、promise/immutable/platform 语义均未改变。本卡属 AUTH-01 D2 升级类（(d)(e)）整卡呈交用户亲自选择，用户选择 **Option 1（维持 v0.1）** → `reauthorize_charter` 未触发。未选项 Option 2/3/4 保持 `unresolved` / `team_proposal`；`recommend-revision` 剩余项登记为未来版本化修订候选。逐条记录见 §8.5 R10。

**治理准备阶段决策批次收官（2026-08-16，§8.5）：** **needs_user_decision 由 1 → 0（全部决策完成）**——DC-ANCH-01 = 已决策（closed as decided）；Batch 1/2/3 + DC-ANCH-01 邻近卡全部 closed as decided。38 条 CR 中 13 条 needs_user_decision 全部处理完毕：**13 条已决策（user_confirmed 决策引用）+ 25 条 absorb_within_authority + 0 reject/defer + 0 reauthorize**。

---

## 7. Decision batching for `needs_user_decision` items

Sequencing principle: dependency-first. Platform/export/resolution decisions condition all downstream layout, QA matrix, measurement identity, and export/release evidence — they are batched first. Acceptance calibration (performance thresholds, accessibility, visual/usability acceptance, release threshold, playability gate) follows because it defines what evidence must be produced and what may block. Rules semantics (target principle) can be prepared in parallel but must be decided before the smallest deterministic core seam is contracted, because fixture/Gate-2 evidence depends on it.

All decision windows are **date-free**, expressed relative to lifecycle gates (no calendar commitments are made; a window is a review/decision boundary, never a staffing promise).

### Batch 1 — Foundation: platform, resolution, architecture seam (影响所有下游 → 宜先定)

| Card | Linked cr_ids | 待决项 | 选项制备角色（不代填选项内容） | 建议决策窗口 |
|---|---|---|---|---|
| DC-PLAT-01 | cr-101, cr-102, cr-103 | 命名 OS + 导出目标 + 发布平台/渠道与本期发布姿态 | **Tech Lead**（+Toolchain 身份输入）；UX/UI 就分辨率依赖提供输入 | 下一次用户决策窗口（Gate 0/1 静态复审就绪后即启用；先于合同/ADR 定稿） |
| DC-PLAT-02 | cr-104, cr-105 | 最低分辨率红线 + 宽屏支持集与缩放/letterbox/crop 策略 | **UX/UI**（制备） + **Tech Lead**（可行性/实现成本输入） | 紧随 DC-PLAT-01；在 HUD/布局契约定稿前 |
| DC-ARCH-01 | cr-201 | 候选架构 seam 处置（维持候选待 ADR / 批准 / 换方案 / 推迟） | **Tech Lead** | 与 DC-PLAT-01 同期；在 ADR 定稿路径启动前 |

### Batch 1 — 状态：**已决策（closed as decided）**（2026-08-16，决策记录见 §8.1）

- DC-PLAT-01 → **Option P1「Windows-only 最小验证姿态」**（cr-101/102/103）；DC-ARCH-01 → **Option A1「维持候选 + 启动 ADR 定稿路径」**（cr-201）；DC-PLAT-02 → **Option 2「Balanced」**（cr-104/105）。
- 三条决策记录均为 `user_confirmed`（provenance = 用户决策）。未选项（P2/P3、A2/A3/A4、Option 1/3/4）保持 `unresolved`/`team_proposal`，不删除、不静默推广。
- **reauthorize_charter 未触发**（触发条件 = 支持集/渠道/红线数值写入发布承诺、发布文案或 Gate 判据：P1 本期不发布、A1 边界保持候选、Option 2 数值仍仅候选——均未写入）。

### Batch 2 — Acceptance calibration: performance, accessibility, acceptance, release, playability gate

| Card | Linked cr_ids | 待决项 | 选项制备角色（不代填选项内容） | 建议决策窗口 |
|---|---|---|---|---|
| DC-PERF-01 | cr-109 | 性能候选预算：软候选 vs 正式门槛（哪些数值、软硬、测量后复审规则）。**所有提到 1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s 之处必须标注「仅候选，须经 CR + 用户批准才成为正式门槛」** | **Tech Lead**（+QA 审计输入） | Batch 1 之后、性能测量协议授权之前 |
| DC-ACC-01 | cr-106 | 可访问性阈值（对比度/字号/目标尺寸/闪动/运动/减少动效） | **UX/UI** | 与 DC-PERF-01 同期；在 UX 契约/无障碍清单定稿前 |
| DC-ACC-02 | cr-114 | 视觉/可用性验收标准（Gate 3 判据、遮挡红线、证据接受阈值） | **UX/UI**（+ Game Director 与 QA 输入） | Batch 1 之后（依赖分辨率/支持集）；在 Gate 3 证据计划前 |
| DC-REL-01 | cr-113 | 发布阈值/放行条件与 QA 放行姿态 | **Independent QA/Release** + Producer 装配；用户裁定 | 在 Gate 6 与发布证据包规划前 |
| DC-PLAY-01 | cr-202 | 可玩性观察门正式化（正式门 vs 咨询性） | **Systems/Rules Designer**（判据）+ QA/Release（门权威结构） | 与 DC-ACC-02 同期；在范围扩张讨论前 |

### Batch 2 — 状态：**已决策（closed as decided）**（2026-08-16，决策记录见 §8.3 R04–R08）

- DC-PERF-01 → **Option A「保持候选直至测量证据」**（cr-109）；DC-ACC-01 → **Option A2「轻量候选规范（Internal Candidate Standard）」**（cr-106）；DC-ACC-02 → **Option B3「证据收紧（Evidence-Strict）」**（cr-114）；DC-REL-01 → **Option 2（O2）「证据完整放行（Evidence-Complete Release）」**（cr-113）；DC-PLAY-01 → **Option 2「分阶正式化」**（cr-202）。
- 五条决策记录均为 `user_confirmed`（provenance = 用户决策；用户在 Batch 2 选项卡片上的最终选择），2026-08-16 登记于 §8.3 R04–R08。未选项（DC-PERF-01：B/C/D；DC-ACC-01：A1/A3/A4；DC-ACC-02：B1/B2/B4；DC-REL-01：Option 1/3/4；DC-PLAY-01：Option 1/3）保持 `unresolved`/`team_proposal`，不删除、不静默推广。
- **reauthorize_charter 未触发**（本批五项均未把支持集/渠道/红线数值写入发布承诺、发布文案或 Gate 判据；零容差纪律为 QA 职权内证据规则）；未来触发点见 §8.3 末结论。
- **needs_user_decision 余 2 项**：cr-001（DC-SYS-01，Batch 3）制备可启动；cr-301（DC-ANCH-01，邻近卡）仍 `awaiting Director input`，等待 Game Director 复审输入（ANCHOR_REVIEW_v0_2.md 结论）。**Batch 3 窗口启用。**

**AUTH-01 生效（2026-08-16，见 §8.2 P1）：** 按 AUTH-01 流程层，Batch 2 已决策（closed as decided）→ Batch 3 → DC-ANCH-01 复审链**连续推进，无需批间征询「是否继续」**；决策窗口保留（未选项绝不静默通过），依赖顺序不变（Batch 1 → 2 → 3；DC-ANCH-01 独立）。

### Batch 3 — Rules core semantics (可并行制备；在最小确定性核心 seam 契约冻结前定)

| Card | Linked cr_ids | 待决项 | 选项制备角色（不代填选项内容） | 建议决策窗口 |
|---|---|---|---|---|
| DC-SYS-01 | cr-001 | Target 语义原则（簇定义 + 排序原则：确认现有候选方向 / 替代规则 / 推迟待 ADR） | **Systems/Rules Designer**（主制备）+ **Tech Lead**（机制/确定性字段输入）+ UX（可读性观察目标输入） | 不晚于最小确定性核心 seam 契约冻结；可与 Batch 1/2 并行制备 |

### Batch 3 — 状态：**已决策（closed as decided）**（2026-08-16，决策记录见 §8.4 R09）

- DC-SYS-01 → **Option A「确认候选方向」**——pre-fire refresh nearest-threat cluster → stable-sort → lock that shot's target snapshot；排序键序 = 最近威胁 → 簇中心距离 → 稳定排序/稳定 ID（cr-001）。
- 决策记录为 `user_confirmed`（provenance = 用户决策；用户在 DC-SYS-01 选项卡片上的最终选择）。**本卡属 D2 升级类**（Option B/C 命中 (d)）→ 整卡呈交用户亲自选择；用户选择 **A（非升级项）** → **reauthorize_charter 未触发**。未选项 Option B、C、D 保持 `unresolved` / `team_proposal`，不删除、不静默推广。
- **exact cluster membership、metric、quantization、tie-break 字段、stable-ID 生命周期、失效/时点保持 `unresolved`**（不动摇决策 #3 / revision-02 #4 / PRECHARTER-02 已确认语义），移交 cr-002..005 由对应角色 `absorb_within_authority` 提案 + fixture 验证。
- **needs_user_decision 余 1 项（此时点）**：cr-301（DC-ANCH-01，邻近卡）仍 `awaiting Director input`，等待 Game Director 复审输入（ANCHOR_REVIEW_v0_2.md 结论）。Batch 3 已 closed as decided；DC-ANCH-01 复审链按 AUTH-01 P1 继续推进。**（后续：DC-ANCH-01 已 closed as decided，§8.5 R10；治理准备阶段决策批次收官，needs_user_decision = 0。）**

### 邻近卡片（不属于两大簇；经父协调器派发）

| Card | Linked cr_ids | 待决项 | 选项制备角色 | 建议决策窗口 |
|---|---|---|---|---|
| DC-ANCH-01 | cr-301 | Anchor v0.2 是否成为新基线 | **Game Director / Creative Director**（独立复审）+ Doc Scribe（记录）；主输入为 ANCHOR_REVIEW_v0_2.md 的 Director 结论（本任务未读取，需父协调器/后续复审提供） | 任意治理窗口；v0.1 保持基线直至用户决定 |

**DC-ANCH-01 状态（2026-08-16，收官）：** **已决策（closed as decided）** —— 用户在 **DC-ANCH-01 选项卡片**上做出最终选择 **Option 1「保持 v0.1 基线，v0.2 维持候选（暂不推进）」**（provenance = 用户决策，§8.5 R10）。cr-301 → `user_confirmed（决策引用）`；Anchor v0.1 基线维持不变；`recommend-revision` 剩余项（清除通道连续开阔、玩家负空间明确、无持续发光场）登记为未来版本化修订候选（不静默丢弃）；`reauthorize_charter` 未触发。**needs_user_decision 由 1 → 0（全部决策完成）——治理准备阶段全部决策批次收官。**

**ADR 批准 + owner 任命状态（§8.6，2026-08-16）：** **ADR-TECH-01..06 已批准（用户决策，R11）** —— 批准其成为生效技术契约（TECH-01/02/03/04/06 全量；TECH-05 机制边界、精确语义延后）；**TECH-07/08 未批准（保持 `draft_in_review` / `NOT APPROVED`）**。ADR 状态行更新（置 `approved`）由 **Tech Lead** 在其拥有的 ADR 包（`KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` §18 dossier）执行——本文档登记决策、不代改 ADR 文件。**实现 owner 任命已确认（R12）：Godot Gameplay Engineer**（条件①满足，②实现授权解除、③实际 start 证据待后续）。⚠️ **ADR 批准 ≠ 实现授权**——implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`；实现启动仍需用户另行授权 + GDMCP 预检 + start 证据。

**实现授权状态（§8.7，R13，2026-08-16）：** **用户已正式授权实现**（provenance = `user_confirmed`，2026-08-16）。implementation `NOT_AUTHORIZED → 授权生效`（契约内，§8.7 R13 授权范围边界）；kickoff `not_ready → 授权生效`（**实际动工待 GDMCP 预检通过与 start 证据**）。⚠️ **授权登记 ≠ GDMCP 预检通过**——用户已配置 gdmcp/gdunit4 于 `D:\Game\New_Game\godot_game_dev`（需由实现成员实际预检验证，本登记不替代验证）；实际动工（接触 Godot/代码/运行时）仍需实现成员执行 **GDMCP 预检（doctor / editor-state）+ 记录实际 start 证据**（任命条件③）。边界注记：**契约内**（ADR-TECH-01..06 + 已决决策）、**TECH-07/08 未批准不进入**、**候选预算不提升**、**QA 独立验收不豁免**。**Producer 后续动作：编排实现成员 GDMCP 预检 + start 证据采集（预检通过后登记实际 start）**。

### 决策窗口总规则

1. 窗口是最迟决策边界，不是排期承诺；错过窗口的项保持 `unresolved` 并顺延至下一窗口，绝不静默通过。
2. 每一批内部可并行制备；批与批之间按依赖排序（Batch 1 → 2 → 3；DC-ANCH-01 独立）。
3. 每条待决项的默认为 `unresolved`/`team_proposal`；用户选择后才升为 `user_confirmed`。
4. 所有吸收项（§6 中 `absorb_within_authority`）现行即可由对应角色以 proposal/ledger/fixture 推进，不占用用户窗口，但任何硬门槛化/发布承诺化一律升级。
5. **AUTH-01（§8.2）流程层/决策层：** 批间不再以「继续吗」问题阻塞流程——Batch 2 → Batch 3 → DC-ANCH-01 连续推进；但任何升级类卡片（D2 判定命中 / D3 专业意见冲突）仍呈交用户亲自选择，未选项绝不静默通过。

---

## 8. Decision-card production structure (供 Systems / Tech / UX / QA / Director 成员填充 — 本任务不代填具体选项)

每张决策卡片必须按以下固定结构产出（由对应选项制备角色填充，提交给父协调器汇成选项卡片交用户选择）：

```text
Card ID:                 DC-<PACKAGE>-<NN>
待决项:                  linked cr_ids + 来源原始表述 + 当前 unresolved/team_proposal 状态
选项（2–4 个，精准、互斥）:
  Option <n>
    - 名称: <一句话>
    - 依据: <来自已确认 user_confirmed 边界/证据/约束，不引用未经证据的事实>
    - 影响: <产品/创意/技术/范围/进度各一行>
    - 风险: <风险 + 回滚或验证成本一行>
    - 候选预算相关: <如涉及 1080p/60 等，必须标注「仅候选，须经 CR + 用户批准才成为正式门槛」>
专业推荐:               <制备角色唯一推荐 + 一句理由 + 异议（若有）>
决策后记录规则:
  - 用户选择某项 → 记为 user_confirmed（provenance = 用户决策），并更新对应合同/ADR 的 status 字段；
  - 其余选项保持 unresolved/team_proposal（不删除、不静默推广）；
  - 若选项改变 promise/immutable/platform/threshold/release → 走 reauthorize_charter 路径。
决策窗口与截止依赖:       <按 §7 批次窗口>
批准后的新 owner:         <指定角色>
批准后的验收标准:         <命名证据/门 + 独立 QA 观察要求>
```

禁止事项（明确）：任何制备成员不得在选项填充时自行决定最终选项；不得把任何 `team_proposal`/`assumption`/`unresolved` 升级为 `user_confirmed`；不得批准或冻结 Tech/Systems/UX 合同；不得豁免 QA blocker；不得替用户做最终产品决策。

---

## 8.1 Decision records — Batch 1（user_confirmed，provenance = 用户决策）

> 按 §8「决策后记录规则」登记（用户选择某项 → 记为 `user_confirmed`，provenance = 用户决策；更新受影响 cr 行状态；其余选项保持 `unresolved`/`team_proposal`；若改变 promise/immutable/platform/threshold/release → `reauthorize_charter`）。
>
> 本区仅为**决策登记**：不批准/冻结任何合同或 ADR（Tech/Systems/UX 合同与 ADR 均保持 `PROPOSAL / DRAFT / NOT APPROVED`）；不豁免 QA blocker；不替 Independent QA 下 verdict；未选项不删除、不静默推广。

### 决策记录 R01 — DC-PLAT-01 → Option P1「Windows-only 最小验证姿态」

| 字段 | 记录 |
|---|---|
| Card ID | `DC-PLAT-01` |
| 选定选项 | **Option P1 —「Windows-only 最小验证姿态」** |
| 决策内容摘要 | 命名 OS = **Windows（x86_64）单一集合**；导出 = **单个 Windows 打包产物（可执行 + 数据目录，含 artifact digest / build identity）**；本期发布姿态 = **不发布**（Gate 6 按内部复审姿态执行，无商店/渠道承诺） |
| Provenance | `user_confirmed`（provenance = **用户决策**；用户在选项卡片上的 Batch 1 最终选择） |
| 决策时间戳 | `2026-08-16`（UTC+08:00） |
| 受影响 cr_id | **cr-101**（OS 平台目标）、**cr-102**（导出目标）、**cr-103**（发布平台/渠道与本期发布姿态） |
| 触发 reauthorize_charter？ | **否**（P1 本期不发布——无渠道/发布承诺变更；触发条件见 §6 Producer note） |
| 未选项（不删除、不静默推广） | Option P2、P3 保持 `unresolved` |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **Tech Lead**：按 Windows x86_64 单 target 更新 `ADR-TECH-08` 状态行与 build/export identity / target 身份字段（仍 `PROPOSAL / DRAFT / NOT APPROVED` 直至正式评审）；Gate 5/6 判据引用单一 target 姿态；cr-112 build identity 规则由 Tech + Toolchain 提案激活 target 身份字段。**Producer**：Gate 5/6 编排引用单一 target 姿态。 |

### 决策记录 R02 — DC-ARCH-01 → Option A1「维持候选 + 启动 ADR 定稿路径」

| 字段 | 记录 |
|---|---|
| Card ID | `DC-ARCH-01` |
| 选定选项 | **Option A1 —「维持候选 + 启动 ADR 定稿路径」** |
| 决策内容摘要 | 保持 `rules core → session → adapter → presentation/read-model` 为**候选**边界；**授权启动** ADR-TECH-01..08 定稿（draft → 跨角色评审 → 依评审结果逐条进入批准流程）；定稿产物仍为 `PROPOSAL / DRAFT / NOT APPROVED` 直至正式评审通过 |
| Provenance | `user_confirmed`（provenance = **用户决策**） |
| 决策时间戳 | `2026-08-16`（UTC+08:00） |
| 受影响 cr_id | **cr-201**（候选架构 seam 处置） |
| 触发 reauthorize_charter？ | **否**（A1 边界保持候选——ADR 仍为提案，架构风险 crossing 未穿越） |
| 未选项（不删除、不静默推广） | Option A2、A3、A4 保持 `unresolved` / `team_proposal` |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **Tech Lead**：启动 ADR-TECH-01..08 定稿（各 ADR 状态行按 A1 路径更新为 draft/评审；ADR-TECH-05/06 的 Systems/UX 契约依赖、ADR-TECH-06 的 evidence schema/QA 输入为跨角色依赖，标注为**父协调器协调项**）。**Producer**：编排评审排程。 |

### 决策记录 R03 — DC-PLAT-02 → Option 2「Balanced」

| 字段 | 记录 |
|---|---|
| Card ID | `DC-PLAT-02` |
| 选定选项 | **Option 2 —「Balanced：16:9 基线 + 常见宽屏（16:10、21:9），720p 红线候选，fit + UI 缩放、禁 stretch / 禁 crop」** |
| 决策内容摘要 | 支持集 = **{16:9, 16:10, 21:9}（作为方向性支持承诺候选）**；**`1280×720` 最低分辨率红线仍为「仅候选」**（须 CR + 用户批准才成为正式门槛；未写入发布承诺/发布文案/Gate 判据）；缩放规则 = **fit + letterbox 空隙 + UI 相对缩放保护安全区，禁 stretch / 禁 crop** |
| Provenance | `user_confirmed`（provenance = **用户决策**） |
| 决策时间戳 | `2026-08-16`（UTC+08:00） |
| 受影响 cr_id | **cr-104**（最低分辨率红线）、**cr-105**（宽屏支持集与缩放/letterbox/crop 策略） |
| 触发 reauthorize_charter？ | **否**（支持集为方向性承诺候选、红线数值仅候选——未写入发布承诺/发布文案/Gate 判据；若后续写入则触发） |
| 候选预算状态 | `1280×720` 红线仍为**仅候选**，独立于六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s，均保持候选，归 DC-PERF-01 / cr-109） |
| 未选项（不删除、不静默推广） | Option 1「Spartan」、Option 3「Broad」、Option 4「Defer」保持 `unresolved` / `team_proposal` |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **UX/UI Designer**：按选定集更新 UX 合同 v0.1 §7 状态（支持集/缩放规则条目与证据矩阵 UX-09/UX-12 状态；仍提案态直至契约评审）。**Tech Lead**：确认 Option 2 可行性（Godot stretch mode / UI scale / 安全区 clamp / 插值缩放策略；全屏/窗口化/HiDPI 依赖 cr-101）+ 更新 ADR-TECH-08 分辨率/身份字段提案。 |

---

## 8.2 Standing authorization — hybrid packet (2026-08-16) — AUTH-01

> 本区为**授权登记区**：把用户已确认的「混合授权包」按团队纪律持久化登记为正式授权记录（provenance 依据），供后续所有自动采纳决策引用。登记**不扩展授权范围、不改写授权文本、不新增决策**；本授权包**不包含实现授权**（实现保持 `NOT_AUTHORIZED`，见硬边界第 1 条）。

### 8.2.1 授权包头（AUTH-01）

| 字段 | 记录 |
|---|---|
| 授权包 ID | `AUTH-01` |
| 名称 | Standing authorization packet — hybrid packet（混合授权包） |
| Provenance | `user_confirmed`（provenance = **用户决策**；用户经 /godot-game-team 方向 B 提问卡片明确选择「混合授权包」，2026-08-16） |
| 登记时间戳 | `2026-08-16 17:49:42 +08:00`（Get-Date，登记时本地时间；provenance 源日期 = 2026-08-16） |
| 授权范围 | 流程层 P1–P3（§8.2.2）+ 决策层委托规则 D1–D3（§8.2.3）——**不含实现授权** |
| 自动采纳 / 呈交判定规则 | D1（非升级类 → 自动采纳专业推荐）+ D2（升级类 → 呈交用户亲自选择）+ D3（专业意见冲突 → 呈交用户裁决），详见 §8.2.3 |
| 防火墙声明 | 硬边界四项（实现授权 / Independent QA 独立性 / 父线程边界 / 候选预算状态），详见 §8.2.4——本授权包**不覆盖** |
| 关联决策记录 | §8.1 R01–R03（Batch 1：DC-PLAT-01 → P1；DC-ARCH-01 → A1；DC-PLAT-02 → Option 2）与 AUTH-01 衔接：P2 自动触发的 owner 后续动作正是 R01–R03 已确认决策的执行（A1 已含 ADR 定稿授权）；D2 升级类判定规则与 §6 `reauthorize_charter` 触发条件一致（未选项永不静默升级） |
| 状态 | `registered / effective for delegation & process`——**决策层 D1 自动采纳在后续批次逐卡触发时生效**，逐卡记录 provenance = 2026-08-16 授权包 §D1 显式委托；本登记本身未改变任何既有 unresolved 项状态 |

### 8.2.2 流程层（消除批间停摆，仍保持团队执行）— 原样登记

- **P1**：依 CHANGE_REQUESTS §7 依赖顺序**连续推进** Batch 2 → Batch 3 → DC-ANCH-01 复审链；批间不再停顿征询「是否继续」（决策窗口保留，但不再以「继续吗」问题阻塞流程）。
- **P2**：自动触发 Batch 1 已确认决策的 owner 后续动作——Tech Lead 启动 ADR-TECH-01..08 定稿路径 + Option 2（Balanced）可行性确认 + ADR-TECH-08 状态行更新；UX/UI 更新 UX 合同 v0.1 §7 状态行。这些属于已确认决策的执行（A1 已含 ADR 定稿授权）。
- **P3**：成员仍按容量（≤3 活跃成员）并行派发；成员仍产「2–4 个精准互斥选项 + 唯一专业推荐」；父协调器仍组装选项卡片供用户知情；**用户随时能否决任何自动采纳**。

### 8.2.3 决策层（委托规则，显式记录）— 原样登记

- **D1（非升级类 → 自动采纳）**：非升级类卡片，自动采纳专业推荐作为用户决策，记录为 `user_confirmed`（provenance = 2026-08-16 授权包 §D1 显式委托），由父协调器向用户透明报告（含卡片内容+采纳记录），用户可否决。
- **D2（升级类 → 仍呈交用户亲自选择）**：升级类判定（任一命中即升级，整卡呈交用户）：(a) 候选→正式门槛的数值提升；(b) 写入发布承诺 / 发布文案 / Gate 判据；(c) 命名发布渠道；(d) promise / immutable / platform 变更；(e) threshold / release crossing。**明确列出的升级类卡**：DC-PERF-01（阈值权威卡，cr-109）、DC-REL-01（发布阈值/放行条件，cr-113）、DC-ACC-02（Gate 3 视觉/可用性验收判据，cr-114）、DC-ANCH-01（Anchor v0.2 基线，cr-301——交接包明定需独立 Director 复审 + 用户单独决策，任何模式均不可自动采纳）。DC-ACC-01（cr-106 可访问性阈值）在制备时由 UX/UI 明确各选项是否含发布承诺化；凡含 (a)-(e) 的选项即使同卡其余选项不升级，该卡也呈交用户。
- **D3（专业意见冲突）**：成员间专业推荐冲突时呈交用户裁决，不自动消解、不由父线程代决。

### 8.2.4 硬边界（本授权包不覆盖，登记为防火墙声明）— 原样登记

- **实现授权仍未授权**：Godot/代码/场景/资源/运行/构建/测试/导出/发布保持 `NOT_AUTHORIZED`；任何迁入实现阶段的意图须用户另行明确重新授权 + 完整前置条件（产品/设计 gate、seam/ownership、ADR/合同批准路径、实现 owner、GDMCP 路径、QA 验收计划、write ownership、stop conditions）。
- **Independent QA 独立性不变**：QA 独立观察、独立 verdict、无豁免；自动采纳不减少任何 QA/证据门。
- **父线程边界不变**：父协调器只协调不代做实质工作；成员各自产证；证据门、不变量（22 / 8+1 / PRECHARTER-01..11 / 四层 provenance）、未选项永不静默升级。
- **候选预算状态不变**：1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s 与 1280×720 红线均保持「仅候选，须经 CR + 用户批准才成为正式门槛」——本授权包不自动提升任何候选数值。

### 8.2.5 登记边界声明（本区）

- 本区仅为**授权登记**：不扩展授权范围、不改写授权文本、不新增决策；不批准/冻结任何合同或 ADR（Tech/Systems/UX 合同与 ADR 均保持 `PROPOSAL / DRAFT / NOT APPROVED`）；不豁免 QA blocker；不替 Independent QA 下 verdict；不替用户做任何产品/平台/数值/发布决策（仅登记既有用户决策与既有用户授权包）。
- 本授权包登记**不改变**任何既有 `unresolved` 项状态（D1 自动采纳仅在后续批次逐卡触发时逐卡记录 provenance，逐卡经父协调器透明报告并保留用户否决权）；`reauthorize_charter` 触发条件不变（§6 Producer note）。

---

## 8.3 Decision records — Batch 2（user_confirmed，provenance = 用户决策）

> 按 §8「决策后记录规则」登记（用户选择某项 → 记为 `user_confirmed`，provenance = 用户决策；更新受影响 cr 行状态；其余选项保持 `unresolved`/`team_proposal`；若改变 promise/immutable/platform/threshold/release → `reauthorize_charter`）。Batch 2 五项由用户在 Batch 2 选项卡片上做出**最终选择**（2026-08-16；AUTH-01 §8.2.3 D2 升级类卡片均呈交用户亲自选择），本区即持久化登记。
>
> 本区仅为**决策登记**：不批准/冻结任何合同或 ADR（Tech/Systems/UX 合同与 ADR 均保持 `PROPOSAL / DRAFT / NOT APPROVED`）；不豁免 QA blocker；不替 Independent QA 下 verdict；未选项不删除、不静默推广。

### 决策记录 R04 — DC-PERF-01 → Option A「保持候选直至测量证据」

| 字段 | 记录 |
|---|---|
| Card ID | `DC-PERF-01` |
| 选定选项 | **Option A —「保持候选直至测量证据」（Status Quo + 测量后复审规则）** |
| 决策内容摘要 | 六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）**全部保持仅候选、不提升任何数值**；cr-107（命名硬件基线）+ cr-108（采样/percentile/时钟权威）作为**测量身份**推进（Tech 提案 + QA 审计）；Gate 4 测量证据齐备后由 Tech 以新 CR 再提案（cr-109 再次呈交用户） |
| Provenance | `user_confirmed`（provenance = **用户决策**；用户在 Batch 2 选项卡片上的最终选择） |
| 决策时间戳 | `2026-08-16`（UTC+08:00；登记当日 Get-Date = 2026-08-16） |
| 受影响 cr_id | **cr-109**（性能阈值权威：候选预算是否提升为正式门槛） |
| 触发 reauthorize_charter？ | **否**（六项全部保持仅候选、未提升任何数值——未写入发布承诺/发布文案/Gate 判据）；测量后若 Tech 以新 CR 提议提升 → 该提升本身即触发检查点 |
| 未选项（不删除、不静默推广） | Option B、C、D 保持 `unresolved` / `team_proposal` |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **Tech Lead**：推进 cr-107/108 测量协议定稿（命名硬件基线 + 采样/percentile/时钟权威，Tech 提案 + QA 审计）；Gate 4 测量证据齐备后以新 CR 再提案（cr-109 再次呈交用户）。**Independent QA**：cr-107/108 协议审计（Gate 4 路径仍 `not_run / not_ready`）。 |

### 决策记录 R05 — DC-ACC-01 → Option A2「轻量候选规范（Internal Candidate Standard）」

| 字段 | 记录 |
|---|---|
| Card ID | `DC-ACC-01` |
| 选定选项 | **Option A2 —「轻量候选规范（Internal Candidate Standard）」** |
| 决策内容摘要 | 以内部设计规范（**非门槛**）记录候选数值范围（对比度/最小字号/焦点目标最小尺寸/闪动频率/动效时长/减少动效），仅作 UX 构图、布局与 UX-13 证据字段命名词汇；**不写入 Gate 判据、不构成发布承诺、不冻结合同**；全部数值标注「仅候选，须经 CR + 用户批准才成为正式门槛」 |
| Provenance | `user_confirmed`（provenance = **用户决策**） |
| 决策时间戳 | `2026-08-16`（UTC+08:00） |
| 受影响 cr_id | **cr-106**（可访问性阈值） |
| 触发 reauthorize_charter？ | **否**（内部候选规范不写入 Gate/发布判据，不提升任何数值）；若后期将候选值写入 Gate 判据/发布承诺/发布文案 → 触发（见 §8.3 末未来触发点） |
| 未选项（不删除、不静默推广） | Option A1、A3、A4 保持 `unresolved` / `team_proposal` |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **UX/UI**：细化内部候选数值表（全部「仅候选」标注）；**Tech Lead**：确认 fit 缩放下候选尺寸（字号/焦点目标）的可达性；**Independent QA**：UX-13 观察与独立 verdict 不变（候选数值仅作证据字段命名）。 |

### 决策记录 R06 — DC-ACC-02 → Option B3「证据收紧（Evidence-Strict）」

| 字段 | 记录 |
|---|---|
| Card ID | `DC-ACC-02` |
| 选定选项 | **Option B3 —「证据收紧（Evidence-Strict）」** |
| 决策内容摘要 | Gate 3 判据保持定性红线（遮挡/焦点失败即 blocker），证据接受阈值升级为**严格完整性规则**——Charter §10 全部 mandatory 字段齐备才可判定；缺失任何字段 = `not_run`（不是 pass）；静态/Anchor 不可替代运行时/视觉证据；retest 保留原失败 |
| Provenance | `user_confirmed`（provenance = **用户决策**） |
| 决策时间戳 | `2026-08-16`（UTC+08:00） |
| 受影响 cr_id | **cr-114**（视觉/可用性验收标准） |
| 触发 reauthorize_charter？ | **否**（证据完整性规则为证据纪律、非数值门槛——不提升任何候选数值；Gate 3 定性判据只复述已确认 #18/#19 边界） |
| 未选项（不删除、不静默推广） | Option B1、B2、B4 保持 `unresolved` / `team_proposal` |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **UX/UI**：细化 Gate 3 证据完整性规则；**Independent QA**：观察协议（B3 可直接执行）；**Tech/Toolchain**：证据管线基建确认（§4.1 清单：build identity/digest、帧捕获、证据索引）。 |

### 决策记录 R07 — DC-REL-01 → Option 2（O2）「证据完整放行（Evidence-Complete Release）」

| 字段 | 记录 |
|---|---|
| Card ID | `DC-REL-01` |
| 选定选项 | **Option 2（任务登记编号 O2）—「证据完整放行（Evidence-Complete Release）」** |
| 决策内容摘要 | 未来放行条件 = Gate 2–6 全部通过 + 发布证据包完整性（evidence_id/class/gate/criterion/build_identity/observer/verdict/retest 链/unresolved_deviations/索引链接）+ **默认零证据容差**（证据类不可互换、无静默容差/alias/coercion——Evidence schema §8），由 Independent QA 出具含明确证据边界的放行声明；**本期 P1 不发布、不创建本期发布承诺、不命名渠道** |
| Provenance | `user_confirmed`（provenance = **用户决策**） |
| 决策时间戳 | `2026-08-16`（UTC+08:00） |
| 受影响 cr_id | **cr-113**（发布阈值 / 放行条件） |
| 触发 reauthorize_charter？ | **否**（未来放行姿态——本期不发布；零容差纪律为 QA 职权内证据规则，非新数值承诺）；若未来把阈值/证据包链接到发布承诺、命名渠道 → 触发（见 §8.3 末未来触发点） |
| 未选项（不删除、不静默推广） | Option 1、3、4 保持 `unresolved` / `team_proposal` |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **Independent QA / Release**：细化未来放行判据与证据包定义；**Toolchain**：证据管线基建确认（§4.1 清单）；**Producer**：Gate 6 证据装配与索引（无 verdict 权、无豁免权）。 |

### 决策记录 R08 — DC-PLAY-01 → Option 2「分阶正式化」

| 字段 | 记录 |
|---|---|
| Card ID | `DC-PLAY-01` |
| 选定选项 | **Option 2 —「分阶正式化：判据结构先行，阻断权经 CR + 用户批准后激活」** |
| 决策内容摘要 | 判据构成（S1–S4 信号）与观察协议**立即正式化**（结构生效可评审）；门权威（阻断权）**暂不激活**，待真实 runtime 观察证据校准后经校准报告 + 命名判据阈值 CR + 用户批准再激活；激活前门输出 advisory 状态；QA 独立观察与 verdict 权威不变 |
| Provenance | `user_confirmed`（provenance = **用户决策**） |
| 决策时间戳 | `2026-08-16`（UTC+08:00） |
| 受影响 cr_id | **cr-202**（可玩性观察门是否正式化） |
| 触发 reauthorize_charter？ | **否**（阻断权延后且激活必经 CR + 用户批准——无立即承诺/阈值变更）；激活时若判据阈值写入 Gate 判据 → 按 R08 既定路径呈交用户 |
| 未选项（不删除、不静默推广） | Option 1、3 保持 `unresolved` / `team_proposal` |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **Systems/Rules**：判据结构生效（S1–S4 信号与观察协议，可评审）；**Independent QA**：门权威结构生效（advisory 状态）；阻断权激活 = 校准报告 + 命名判据阈值 CR + 用户批准。 |

### §8.3 决策后结论 — reauthorize_charter 触发检查与未来触发点（Batch 2）

**触发条件（CR §6 Producer note / AUTH-01 §8.2.4）：** 支持集/渠道/红线数值写入发布承诺·发布文案·Gate 判据或 promise/immutable/platform/threshold/release crossing 才触发。

**本批五项均未触发：**
- **R04（DC-PERF-01 Option A）**：六项候选预算全部保持候选、未提升数值。
- **R05（DC-ACC-01 Option A2）**：内部候选规范不写入 Gate/发布（未提升候选值）。
- **R06（DC-ACC-02 Option B3）**：证据完整性规则为证据纪律、非数值门槛（不提升候选值）。
- **R07（DC-REL-01 Option 2/O2）**：未来放行姿态（本期不发布）；零容差纪律为 QA 职权内证据规则、非新数值承诺。
- **R08（DC-PLAY-01 Option 2）**：阻断权延后且激活必经 CR + 用户批准。

**未来触发点（触发即按已确认路径走 reauthorize_charter 检查）：**
- **DC-ACC-01（R05）**：若后期将候选数值表（对比度/字号/焦点尺寸等）写入 Gate 判据 / 发布承诺 / 发布文案 → 触发；须 CR + 用户批准后才成为正式门槛。
- **DC-REL-01（R07）**：若未来把发布证据包/阈值链接到发布承诺、命名渠道或释放时点 → 触发。
- **DC-PERF-01（R04）**：测量后若由 Tech 以新 CR 提议提升任何候选预算（cr-109 再次呈交用户）→ 该次提升本身即触发检查点。
- **DC-PLAY-01（R08）**：阻断权激活（校准报告 + 命名判据阈值 CR + 用户批准）若把判据阈值写入 Gate 判据 → 按 R08 既定路径呈交用户。

**候选预算状态（复核）：** 六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线**全部保持仅候选**；本批未提升任何一项。

---

## 8.4 Decision records — Batch 3（user_confirmed，provenance = 用户决策）

> 按 §8「决策后记录规则」登记（用户选择某项 → 记为 `user_confirmed`，provenance = 用户决策；更新受影响 cr 行状态；其余选项保持 `unresolved`/`team_proposal`；若改变 promise/immutable/platform/threshold/release → `reauthorize_charter`）。Batch 3 一项由用户在 **DC-SYS-01 选项卡片**上做出**最终选择**（2026-08-16；本卡属 AUTH-01 §8.2.3 **D2 升级类**——Option B/C 命中 (d) → 整卡呈交用户亲自选择），本区即持久化登记。
>
> 本区仅为**决策登记**：不批准/冻结任何合同或 ADR（Tech/Systems/UX 合同与 ADR 均保持 `PROPOSAL / DRAFT / NOT APPROVED`）；不豁免 QA blocker；不替 Independent QA 下 verdict；未选项不删除、不静默推广。

### 决策记录 R09 — DC-SYS-01 → Option A「确认候选方向」

| 字段 | 记录 |
|---|---|
| Card ID | `DC-SYS-01` |
| 选定选项 | **Option A —「确认候选方向」（confirm the candidate direction）** |
| 决策内容摘要 | 确认现有候选方向——**pre-fire refresh nearest-threat cluster → stable-sort → lock that shot's target snapshot**；排序键序 = **最近威胁 → 簇中心距离 → 稳定排序/稳定 ID**。仅固化「语义原则」层，**不改变**决策 #3 / revision-02 #4 / PRECHARTER-02 已确认语义；exact cluster membership、metric、quantization、tie-break 字段、stable-ID 生命周期、失效/时点**保持 `unresolved`**，移交 cr-002..005 由对应角色 `absorb_within_authority` 提案 + fixture 验证；解除 target fixture 系列（no-target/ties/removal）定型前提，最小确定性核心 seam 契约可进入冻结路径 |
| Provenance | `user_confirmed`（provenance = **用户决策**；用户在 DC-SYS-01 选项卡片上的最终选择） |
| 决策时间戳 | `2026-08-16`（UTC+08:00；登记当日 Get-Date = 2026-08-16） |
| 受影响 cr_id | **cr-001**（Target 语义原则——簇定义与排序原则） |
| 触发 reauthorize_charter？ | **否**——本卡属 D2 升级类（Option B/C 命中 (d)）整卡呈交用户亲自选择；用户选择 **A（非升级项）**：无任何数值门槛/发布承诺/Gate 判据写入、promise/immutable/platform 语义未改变（仅确认既有 `user_confirmed` 候选方向）→ **未触发** |
| 未选项（不删除、不静默推广） | Option B（替代规则：全局距离单调排序）、Option C（中心距离加权）、Option D（推迟待 ADR-TECH-04 定稿）保持 `unresolved` / `team_proposal` |
| 候选预算状态 | 本决策不涉及任何数值门槛；六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线**全部保持仅候选**，未被动用/提升 |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **Systems/Rules**：按 A 键序提案 cr-002（metric/quantization/tie-break 语义）、cr-004（失效语义）、cr-005（no-target 形态），均 `absorb_within_authority` + fixture 验证，不提升任何候选数值为常数。**Tech Lead**：cr-002/003/004 机制提案（键链全序、stable-ID 分配纪律、失效 drain 点）；ADR-TECH-04 语义段以本卡为输入继续定稿（仍 `PROPOSAL / DRAFT / NOT APPROVED`）。**UX/UI**：按选定原则固化 UX-02/UX-03 观察目标（场景矩阵 U2-A..D / U3-A..D，走 UX 合同修订流程，仍 `not_run / not_ready`）。**Independent QA**：Gate 2 确定性证据独立观察（fixture+seed+tick/config version+trace，仍 `not_run / not_ready`）。 |

### §8.4 决策后结论 — reauthorize_charter 触发检查与本批结论（Batch 3）

**触发条件（CR §6 Producer note / AUTH-01 §8.2.4）：** 支持集/渠道/红线数值写入发布承诺·发布文案·Gate 判据或 promise/immutable/platform/threshold/release crossing 才触发。

**本批一项未触发：**
- **R09（DC-SYS-01 Option A）**：仅确认既有 `user_confirmed` 候选方向——无任何数值/发布承诺/Gate 判据写入；决策 #3 / revision-02 #4 / PRECHARTER-02 语义不变；exact 细节仍 `unresolved` 移交 cr-002..005。

**决策窗口结论（Batch 3）：** 本批 needs_user_decision 项 cr-001 已 closed as decided → **Batch 3 = 已决策（closed as decided）**；needs_user_decision 余 1 项（cr-301 → DC-ANCH-01，仍 `awaiting Director input`）。按 AUTH-01 P1，DC-ANCH-01 复审链继续推进（Batch 2 → Batch 3 → DC-ANCH-01）。

**候选预算状态（复核）：** 六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线**全部保持仅候选**；本批未提升任何一项。

---

## 8.5 Decision record R10 — DC-ANCH-01 → Option 1「保持 v0.1 基线，v0.2 维持候选」

> 按 §8「决策后记录规则」登记（用户选择某项 → 记为 `user_confirmed`，provenance = 用户决策；更新受影响 cr 行状态；其余选项保持 `unresolved`/`team_proposal`；若改变 promise/immutable/platform/threshold/release → `reauthorize_charter`）。本卡不存在于 Batch 1–3 批次内，属**邻近卡片**（cr-301，DC-ANCH-01），经 AUTH-01 §8.2.2 P1 复审链连续推进；由用户在 **DC-ANCH-01 选项卡片**上做出**唯一最终选择**（2026-08-16；本卡属 AUTH-01 §8.2.3 **D2 升级类**——定义见 D2 (d)(e)：promise/immutable 变更 + 审美验收边界 → 整卡呈交用户亲自选择，任何模式均不可自动采纳），本区即持久化登记，为**治理准备阶段全部决策批次收官登记**。
>
> 本区仅为**决策登记**：不批准/冻结任何合同或 ADR（Tech/Systems/UX 合同与 ADR 均保持 `PROPOSAL / DRAFT / NOT APPROVED`）；不豁免 QA blocker；不替 Independent QA 下 verdict；不替用户做审美/基线裁决（仅登记既有用户决策）；未选项不删除、不静默推广。

### 决策记录 R10 — DC-ANCH-01 → Option 1「保持 v0.1 基线，v0.2 维持候选（暂不推进）」

| 字段 | 记录 |
|---|---|
| Card ID | `DC-ANCH-01` |
| 选定选项 | **Option 1 —「保持 v0.1 基线，v0.2 维持候选（暂不推进）」** |
| 决策内容摘要 | **v0.1 保持用户接受基线**；**v0.2 继续作为未接受候选、暂不推进任何版本化修订**。Game Director 唯一 verdict = **`recommend-revision`**（独立 Game Director / Creative Director 复审结论，与 ANCHOR_REVIEW_v0_2.md 一致）；v0.2 已在用户指定方向（右侧 B2 环/粒子/余辉面积亮度收敛、保留核心→过渡→衰减）满足并缓解，未观察到 rusted-industrial + restrained cyan 方向漂移，但清除成果/玩家负空间尚未充分成为第一结果。`recommend-revision` 的剩余改进项（**清除通道连续开阔、玩家负空间明确、无持续发光场**）登记为**未来版本化修订候选**（不静默丢弃）；未来若授权 v0.3 定向修订，其静态验收判据即预设为上述三项 |
| Provenance | `user_confirmed`（provenance = **用户决策**；用户在 DC-ANCH-01 选项卡片上的最终选择） |
| 决策时间戳 | `2026-08-16 22:01:52 +08:00`（Get-Date，登记当日；provenance 源日期 = 2026-08-16） |
| 受影响 cr_id | **cr-301**（邻近：Anchor 基线是否升级 v0.2） |
| 触发 reauthorize_charter？ | **否**——本卡属 AUTH-01 §8.2.3 **D2 升级类**（promise/immutable 相关 + 审美验收边界，(d)(e) 命中）整卡呈交用户亲自选择；用户选择 **Option 1（维持 v0.1 基线）** → **不改变 Charter 记录的 Anchor v0.1 基线条款**（§8.2.3 D2 说明：选 2 才会触发「把 v0.2 提升为新基线 = 正式变更 Charter Anchor 基线条款」→ 触发该路径）→ **未触发 `reauthorize_charter`** |
| 未选项（不删除、不静默推广） | Option 2（升级 v0.2 为新基线）、Option 3（v0.2 定向修订后再定 / 授权一次 v0.3）、Option 4（推迟复审）保持 `unresolved` / `team_proposal`；选 2 触发 `reauthorize_charter` 路径；选 3 产生的 v0.3 仍为候选不触发 |
| 候选预算状态 | 本决策不涉及任何数值门槛；六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线**全部保持仅候选**，未被动用/提升 |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **Technical Art + 2D Artist**：按 v0.1 基线**维持资产方向；不改变**下游资产 brief 的视觉参照（升 v0.2 / 修订会改变——本决策维持 v0.1 故不变）。**Doc Scribe**：因选 1 维持 v0.1 基线，**无需更新**基线引用（STYLE_MANUAL / UX §10 / Charter Anchor 条款引用均不动——选 2/3 才需同步更新；依卡批准后 owner 分工，本任务之外的引用更新由对应 owner 执行）。**Producer**：未来若用户另行授权 v0.3 定向修订 → 另立 CR + 决策窗口再处置；治理准备阶段决策批次收官（全部 needs_user_decision 处理完毕，见 §6/§7）。 |

### §8.5 决策后结论 — reauthorize_charter 触发检查与本卡收官（DC-ANCH-01）

**触发条件（CR §6 Producer note / AUTH-01 §8.2.4）：** 支持集/渠道/红线数值写入发布承诺·发布文案·Gate 判据或 promise/immutable/platform/threshold/release crossing 才触发；本卡另依 AUTH-01 §8.2.3 D2 判定（promise/immutable 相关 + 审美验收边界，(d)(e) 命中）。

**本卡一项未触发：**
- **R10（DC-ANCH-01 Option 1）**：维持 v0.1 基线——**不改变** Charter 记录的 Anchor 基线条款；未写入任何发布承诺/发布文案/Gate 判据；无任何数值门槛提升；`recommend-revision` 剩余项登记为未来版本化修订候选（不静默丢弃），未来若授权 v0.3 由 Producer 另立 CR 再处置。

**决策窗口结论（DC-ANCH-01）：** 本卡 cr-301 已 closed as decided（用户选定 Option 1）→ **needs_user_decision = 0（全部决策完成）**；治理准备阶段全部决策批次**收官**——Batch 1/2/3 + DC-ANCH-01 邻近卡全部 closed as decided。38 条 CR 中 13 条 needs_user_decision 全部处理完毕：**13 条已决策（user_confirmed 决策引用）+ 25 条 absorb_within_authority + 0 reject/defer + 0 reauthorize**。

**候选预算状态（复核）：** 六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线**全部保持仅候选**；本卡未提升任何一项。

---

## 8.6 Decision records — ADR-TECH-01..06 approval + implementation owner appointment (user_confirmed，provenance = 用户决策)

> 按 §8「决策后记录规则」登记（用户选择某项 → 记为 `user_confirmed`，provenance = 用户决策）。**R11**（ADR-TECH-01..06 批准）与 **R12**（实现 owner 任命确认）均由用户在 `/godot-game-team` 方向 B 的选项卡片上**逐条确认**（2026-08-16），本区即持久化登记。
>
> **批准 ≠ 实现授权：** 本区批准使 ADR 成为生效技术契约（approved），但**本登记不授权实现**——kickoff 仍 `not_ready`，implementation 仍 `NOT_AUTHORIZED`；实现启动仍需用户另行授权 + GDMCP 预检 + start 证据。**ADR 状态行更新（置 `approved`）由 Tech Lead 在其拥有的 ADR 包执行（`KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`），本文档登记决策记录、不代改 ADR 文件。**
>
> 本区仅为**决策/确认登记**：不授权实现、不冻结任何未被批准的项（TECH-07/08 保持 `draft_in_review` / `NOT APPROVED`）；不豁免 QA blocker；不替 Independent QA 下 verdict；promise/immutable/platform/release 语义未变；未选项保持 `unresolved` / `team_proposal`（不删除、不静默推广）。

### 决策记录 R11 — ADR-TECH-01..06 批准

| 字段 | 记录 |
|---|---|
| Card / 决策包 | **ADR 批准选项卡片**（用户在 `/godot-game-team` 方向 B 上逐条确认 ADR 批准） |
| 选定 | **批准 ADR-TECH-01、02、03、04、06（全量）+ ADR-TECH-05（机制边界）** |
| 决策内容摘要 | **TECH-01（候选边界 seam rules/core → session → adapter/presentation/read-model）全量批准**；**TECH-02（rules 纯度/生命周期/read model）全量批准**；**TECH-03（可复现性/确定性 seam，QA/debug-only，非 player-visible Replay）全量批准**；**TECH-04（目标快照契约）全量批准**（依赖 cr-001 Option A 已确认键序）；**TECH-05 批准机制边界**：contact 单次伤害+轻分离、升级事务两阶段（穿透→扇裂，三同关键词卡，无 skip/reroll）、focus epoch 拒陈旧输入、同帧生命耗尽优先于八分钟胜利——**精确数值/语义延后**（Systems 契约 `in_flight`，cr-006..020 剩余缺口移交 Systems/UX 对应角色 `absorb_within_authority` + fixture 验证）；**TECH-06（Headless seam/证据 schema）全量批准** |
| **未批准** | **ADR-TECH-07（性能测量协议）与 ADR-TECH-08（导出/构建身份边界）未批准**——保持 `draft_in_review` / `PROPOSAL / DRAFT / NOT APPROVED`（性能候选预算仍仅候选，硬件/采样/阈值权威未定；导出 target 依赖 P1 输入，未来经 CR + 用户批准路径） |
| Provenance | `user_confirmed`（provenance = **用户决策**；用户在选项卡片上逐条确认 ADR-TECH-01..06，2026-08-16） |
| 决策时间戳 | `2026-08-16`（UTC+08:00） |
| 受影响 / 引用 | **ADR-TECH-01..06**（Tech Lead 拥有的 `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`）；TECH-04 依赖 cr-001（R09）；TECH-05 依赖 Systems 契约（cr-006..020 in_flight） |
| 触发 reauthorize_charter？ | **否**（ADR 批准为契约生效、非实现授权、非 promise/immutable/platform/release/charter 变更；候选预算未提升） |
| 候选预算状态 | 六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线**全部保持仅候选**，未被动用/提升 |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **Tech Lead**：在 `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` §4/§12/§18 将 ADR-TECH-01..06 状态行更新为 `approved`（生效技术契约；TECH-05 标注机制边界批准、精确语义延后；总生命周期与 gate 状态不变），TECH-07/08 保持 `draft_in_review`；Systems 契约（cr-006..020 in_flight）随 TECH-05 批准后由 Systems 继续定稿。**Producer**：将 ADR 批准登记进 kickoff readiness 状态（静态缺口收束一项），但保持 kickoff `not_ready`、implementation `NOT_AUTHORIZED`；后续编排实现授权请求。**Systems / UX / QA**：契约与证据字段按批准后的 ADR 继续收敛（fixture/seed/trace、focus/contact/reset 场景、UX-06..13、Gate 2 证据计划）——批准不豁免 QA、不预支运行时证据。 |

### 决策记录 R12 — 实现 owner 任命确认

| 字段 | 记录 |
|---|---|
| 提案来源 | `IMPLEMENTATION_OWNER_NOMINATION_v0_1.md`（Executive Producer / Lead Producer 产出，v0.1，2026-08-16） |
| 选定 | **确认实现 owner = Godot Gameplay Engineer**（对应 roster；角色专家 Skill = `godot-gameplay-engineer-expert` + 配套 `gdmcp` / `godot-cli-validation` 等） |
| 决策内容摘要 | 将 Charter §4「Gameplay Engineer (future)」占位**落为 named owner**（非新角色、不扩张 roster）；明确其决策权边界（实现范围内技术决策授予；不得跨产品/架构/阈值/发布边界；不得自证验收）、write ownership（Godot mutation 唯一写入 owner + GDMCP 铁律）、stop conditions（升级 / QA blocker 不豁免 / 证据门不跳过——沿用既有边界） |
| **任命条件状态** | **① 用户确认本提案 = 满足（本记录即用户确认）**；**② 实现授权解除 = 待后续**（`NOT_AUTHORIZED` 维持，授权不随本确认自动发生）；**③ 实际 start 证据 = 待后续**（engineer 接触 Godot/GDMCP 前仍需 start 证据 + 角色专家 preflight / 能力证据） |
| Provenance | `user_confirmed`（provenance = **用户决策**；用户在选项卡片上确认任命 **Godot Gameplay Engineer** 为 owner，2026-08-16） |
| 决策时间戳 | `2026-08-16`（UTC+08:00） |
| 受影响的命名对象 | `IMPLEMENTATION_OWNER_NOMINATION_v0_1.md`（任命提案已获用户确认 → 任命条件①闭合）；Charter §4「Gameplay Engineer (future)」占位（落为 named owner） |
| 触发 reauthorize_charter？ | **否**（named owner 落定 = 任命确认，非新角色、非 scope/平台/阈值/发布扩张；实现范围内工作仍受已批准 ADR/contracts 与 Charter caps 约束） |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **Producer**：后续在 readiness gate 就绪时向用户编排**实现授权请求**（解除 `NOT_AUTHORIZED`）+ 记录 owner 实际 start 证据（任命条件②③绑定）；实现 owner 在授权解除 + start 证据前不视为 active、不接触 Godot/代码/运行时。**Tech Lead**：ADR-TECH-01..06 状态行更新（置 `approved`，R11）后，为 owner 提供已批准契约作为实现范围边界。 |

### §8.6 决策后结论 — reauthorize_charter 触发检查与边界声明（ADR 批准 + owner 任命）

**触发条件不变（CR §6 Producer note / AUTH-01 §8.2.4）：** 支持集/渠道/红线数值写入发布承诺·发布文案·Gate 判据或 promise/immutable/platform/threshold/release crossing 才触发。

**本两记录均未触发：**
- **R11（ADR-TECH-01..06 批准）**：批准为契约生效（Tech Lead 后续更新 ADR 状态行至 `approved`），非实现授权、非 promise/immutable/platform/charter 变更；候选预算/红线未提升；TECH-07/08 未批准。
- **R12（owner 任命确认）**：named owner 落定（条件①闭合），非新角色、非 scope 扩张；条件②（实现授权解除）、③（start 证据）仍待后续。

**边界声明（明确）：** ⚠️ **ADR 批准 ≠ 实现授权。** ADR-TECH-01..06 批准后成为生效技术契约（approved），为最小确定性核心 seam 的实现提供契约基础；但**实现启动仍未授权**——kickoff 仍 `not_ready`，implementation 仍 `NOT_AUTHORIZED`；实现启动仍需**用户另行明确授权实现 + GDMCP 预检（doctor / editor-state）+ 实际 start 证据**（任命条件②③）。完整剩余缺口 = **实现授权解除 + GDMCP 预检 + start 证据**。本文件不代用户做出实现授权请求/决定——该决定权在用户。

---

## 8.7 Decision record R13 — 实现授权（user_confirmed，provenance = 用户决策）

> 按 §8「决策后记录规则」登记（用户明确授权某项边界成立 → 记为 `user_confirmed`，provenance = 用户决策；更新受影响状态行）。**R13 = 实现授权生效**——用户在 2026-08-16 **正式授权实现**（provenance = `user_confirmed`，用户决策）。本区即持久化登记。
>
> **本登记 ≠ GDMCP 预检通过：** 本登记使实现授权**生效**（契约内），但**实际动工**（接触 Godot/代码/运行时）仍以 **GDMCP 预检通过 + 实际 start 证据**为前置（任命条件③）。GDMCP 路径状态 = ⏳ **待验证**（用户已配置 gdmcp/gdunit4 于 `D:\Game\New_Game\godot_game_dev`，需**由实现成员实际预检验证**——本登记不作为验证替代，本文件也不做任何 Godot/工具链验证）。
>
> 本区仅为**实现授权登记**：不新增/不冻结任何契约（实现限已批准契约范围）；不豁免 QA blocker；不替 Independent QA 下 verdict；不提升任何候选预算；不把实现范围解释为无限（限于已批准契约内）；TECH-07/08 未批准不进入；promise/immutable/platform/release 语义未变；`reauthorize_charter` 未触发。

### 决策记录 R13 — 实现授权生效

| 字段 | 记录 |
|---|---|
| Card / 授权 | **实现授权**（用户在 `/godot-game-team` 方向 B 实现授权，2026-08-16，正式授权实现） |
| 选定 | **授权实现**：implementation `NOT_AUTHORIZED → 授权生效`（契约内） |
| Provenance | `user_confirmed`（provenance = **用户决策**；用户 2026-08-16 正式授权实现，明确表述「我正式授权实现」） |
| 决策时间戳 | `2026-08-16`（UTC+08:00） |
| 授权范围边界 | 实现**限于已批准契约范围内**：**ADR-TECH-01..06（已批准，R11）+ 已决决策（R01–R10）**；**TECH-07/08 未批准 —— 不进入实现范围**；**候选预算（六项 + `1280×720` 红线）全部保持仅候选、不提升**；**QA 独立验收（Gate 2–6）不豁免**；**write ownership / GDMCP 铁律沿用**（Godot mutation 唯一写入 owner）+ **stop conditions / 任命条件沿用** |
| 实现 owner | **Godot Gameplay Engineer**（R12 已任命确认；任命条件①闭合、③实际 start 证据待预检通过后记录） |
| 前置条件核对表 | 见下表（§8.7 R13 前置条件核对） |
| GDMCP 路径状态 | ⏳ **待验证**（用户已配置 gdmcp/gdunit4 于 `D:\Game\New_Game\godot_game_dev`；**待实现成员实际预检验证（doctor / editor-state）**——本登记不作为验证替代） |
| kickoff 状态 | `not_ready → 授权生效`（**实际动工待 GDMCP 预检通过与 start 证据**；Gate 2–6 仍 `not_run / not_ready`） |
| 触发 reauthorize_charter？ | **否**（实现限已批准契约内：ADR-TECH-01..06 + 已决决策范围；无新契约、无 promise/immutable/platform/release/charter 变更；候选预算未提升） |
| 候选预算状态 | 六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线**全部保持仅候选**，未被动用/提升 |
| owner 后续动作提示（本文档之外由对应 owner 执行；本文件不代做） | **实现 owner（Godot Gameplay Engineer）**：执行 **GDMCP 预检（doctor + editor-state）** → 记录**实际 start 证据** + 角色专家 preflight / 能力证据；预检通过且 start 证据就绪后方可实际动工（接触 Godot/代码/运行时），并产出实现证据与 trace（不豁免 QA 独立观察）。**Producer**：编排实现成员 GDMCP 预检 + start 证据登记；维护 Gate 2–6 证据门。 |

### §8.7 R13 前置条件核对表（登记时逐项确认）

| # | 实现授权前置条件 | 核对状态 | 备注 |
|---|---|---|---|
| 1 | **产品/设计 gate** | ✅ 已满足 | Gate 0/1 = `ready_for_next_review`（静态复审通过 + QA pass）；GDD slice/Anchor 基线在库 |
| 2 | **seam/ownership 决策** | ✅ 已满足 | DC-ARCH-01 → A1 已决 + ADR-TECH-01 已批准 |
| 3 | **技术 ADR/合同批准** | ✅ 已满足 | ADR-TECH-01..06 已批准（R11）；TECH-07/08 未批——不阻塞最小确定性核心 seam |
| 4 | **实现 owner** | ✅ 已满足 | Godot Gameplay Engineer 已任命确认（R12） |
| 5 | **GDMCP 路径** | ⏳ 待验证 | 用户已配置（gdmcp/gdunit4，`D:\Game\New_Game\godot_game_dev`）；**待实现成员预检验证**——登记为「待验证」，不替代预检 |
| 6 | **QA 验收计划** | ✅ 已满足 | QA_ACCEPTANCE_PLAN_v0_1 已定稿 |
| 7 | **write ownership** | ✅ 已满足 | 任命提案已定义：Godot mutation 唯一写入 owner + GDMCP 铁律（nomination §2.3） |
| 8 | **stop conditions** | ✅ 已满足 | 已定义（Charter + ADR + nomination §2.4） |

> **核对结论：** 8 项中 **7 ✅ 已满足 + 1 ⏳ 待验证（GDMCP 路径）**。授权登记使 implementation `NOT_AUTHORIZED → 授权生效`；**GDMCP 预检（⏳ 待验证）为实际动工前置**——授权登记 ≠ GDMCP 预检通过，实际动工需预检通过 + start 证据。

### §8.7 决策后结论（R13）

**触发条件不变（CR §6 Producer note / AUTH-01 §8.2.4）：** 支持集/渠道/红线数值写入发布承诺·发布文案·Gate 判据或 promise/immutable/platform/threshold/release crossing 才触发。

**本记录未触发 `reauthorize_charter`：**
- **R13（实现授权生效）**：实现限已批准契约内（ADR-TECH-01..06 + 已决决策）；无新契约、无 promise/immutable/platform/release/charter 变更；TECH-07/08 不进入；候选预算/红线未提升；QA 独立验收不豁免。

**明确边界声明：** ⚠️ **授权登记 ≠ GDMCP 预检通过 ≠ 实际动工。** R13 使实现授权**生效**（契约内），是 kickoff 状态从 `not_ready` 转为「授权生效」的登记依据；但**实际动工**仍以 **实现成员 GDMCP 预检（doctor / editor-state）通过 + 实际 start 证据**为前置（任命条件③；GDMCP 路径 = ⏳ 待验证，用户已配置、待实现成员验证）。授权范围**限于已批准契约内**，不构成无限授权；候选预算、QA 独立验收、TECH-07/08 状态均不受影响。本文件不代实现成员执行/验证工具链。

---

## 9. Invariants, layering, and closure statement

- **22 项原始 user_confirmed 决策**：保持候选约束原状，未改写、未重分类（Charter §6）。
- **Exactly 8 canonical revision-02 inputs**（promise/pillars/cap; candidate architecture; reproducibility; target snapshot; safety/terminal; playability gate; performance; platform）+ **独立**的当前 Charter authorization record：此 ledger 明确两者分离，无第九项（核对 Matrix §2.2 / Systems §13.3 / Evidence index §3.2；历史 8/9 echo 已闭合，仅作为旧 QA 溯源保留）。
- **PRECHARTER-01..11**：全部保留，unresolved 字段未动。
- **四层 provenance**：`user_confirmed` / `team_proposal` / `assumption` / `unresolved` 全程区分；无任何静默提升。
- **All unresolved retained（Batch 1 决策登记后）**：除 Batch 1 已决策项（cr-101..105、cr-201 → `user_confirmed（决策引用）`，§8.1 R01–R03，决策层面 closed as decided）外，本 ledger 其余各项保持 `unresolved`（或候选约束下的 `team_proposal` 细节）；未选项（P2/P3、A2/A3/A4、Option 1/3/4）保持 open，不删除、不静默推广；用户未选择前一律保持 open，绝不静默通过。
- **Tech / Systems / UX 三份合同**保持 `PROPOSAL / DRAFT / NOT APPROVED`；kicked 的架构 seam 提案（rules core → session → adapter → presentation/read-model）保持候选且仅静态一致，无实现验证，未被本 ledger 批准（DC-ARCH-01 Option A1 已授权启动 ADR-TECH-01..08 定稿路径，但 seam 仍为候选、ADR 仍为提案——§8.1 R02）。
- **候选预算**保持候选：1080p/60、50 FPS minimum、≤50ms、≤100ms、<3s、<1s —— 仅候选，须经 CR + 用户批准才成为正式门槛（Batch 1 未提升任何候选预算；`1280×720` 红线亦保持仅候选——§8.1 R03）。
- **不变量声明（含 Batch 1 决策登记更新）**：本文件原位更新——追加 §8.1 决策记录 R01–R03、更新 cr-101..105/cr-201 状态（→ `user_confirmed（决策引用）`）、更新 §6/§7 批次状态；**未修改任何其它既有文档**（Tech/Systems/UX 合同、ADR、证据 index 及其它均未触碰——相应 owner 在后续批次更新）；未访问/修改 Godot、代码、场景、资源；未运行、构建、测试、测性能、导出、发布；未批准合同；未豁免 QA blocker；未替 Independent QA 下 verdict；未替用户做任何产品/平台/数值/发布决策（仅登记既有用户决策）。
- **不变量声明（AUTH-01 授权登记后复核，2026-08-16）**：追加 §8.2（AUTH-01）、更新 §7（Batch 2 起按 AUTH-01 连续推进）、版本升 rev-2 后复核——**22 项原始 user_confirmed 决策**（Charter §6）未改写、未重分类；**Exactly 8 canonical revision-02 inputs + 独立 Charter authorization record（8+1）**未变（Matrix §2.2 / Systems §13.3 / Evidence index §3.2）；**PRECHARTER-01..11** 全部保留；**四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）全程区分、无静默提升；**unresolved 全量保留**——AUTH-01 登记未把任何 unresolved 项升级为决策（D1 自动采纳仅在后续批次逐卡触发时逐卡记录 provenance）；**候选预算保持仅候选**——六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线均未被本授权包提升（§8.2 硬边界第 4 条）；本文件未修改任何其它既有文档（Tech/Systems/UX 合同、ADR、证据 index 及其它均未触碰）；未访问/修改 Godot 或运行任何 build/test/export。
- **不变量声明（Batch 2 决策登记后复核，2026-08-16）**：追加 §8.3（R04–R08）、更新 cr-109/cr-106/cr-114/cr-113/cr-202 状态（→ `user_confirmed（决策引用）`）、更新 §6 计数（needs_user_decision 7→2）与 §7 批次状态（Batch 2 已决策、Batch 3 窗口启用）、版本升 rev-3 后复核——**22 项原始 user_confirmed 决策**（Charter §6）未改写、未重分类；**Exactly 8 canonical revision-02 inputs + 独立 Charter authorization record（8+1）**未变；**PRECHARTER-01..11** 全部保留；**四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）全程区分、无静默提升；**unresolved 全量保留**——Batch 2 例外仅限被决策项 cr-109/cr-106/cr-114/cr-113/cr-202（§8.3 R04–R08 升为 `user_confirmed（决策引用）`），其余（含 cr-001、cr-301）全部保留 open；未选项（B/C/D、A1/A3/A4、B1/B2/B4、Option 1/3/4、Option 1/3）不删除、不静默推广；**候选预算保持仅候选**——六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线均未被本批提升（§8.3 末结论）；本文件未修改任何其它既有文档（Tech/Systems/UX 合同、ADR、证据 index 及其它均未触碰）；未访问/修改 Godot 或运行任何 build/test/export。
- **不变量声明（Batch 3 决策登记后复核，2026-08-16）**：追加 §8.4（R09）、更新 cr-001 状态（→ `user_confirmed（决策引用）`）、更新 §6 计数（needs_user_decision 2→1）与 §7 批次状态（Batch 3 已决策 closed as decided）、版本升 rev-4 后复核——**22 项原始 user_confirmed 决策**（Charter §6）未改写、未重分类；**Exactly 8 canonical revision-02 inputs + 独立 Charter authorization record（8+1）**未变；**PRECHARTER-01..11** 全部保留；**四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）全程区分、无静默提升；**unresolved 全量保留**——Batch 3 例外仅限被决策项 cr-001（§8.4 R09 升为 `user_confirmed（决策引用）`），其 exact cluster membership/metric/quantization/tie-break/stable-ID 生命周期/失效·时点仍保持 `unresolved` 移交 cr-002..005，其余（cr-301）全部保留 open；未选项（Option B/C/D）不删除、不静默推广；**候选预算保持仅候选**——六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线均未被本批提升（§8.4 末结论）；本文件未修改任何其它既有文档（Tech/Systems/UX 合同、ADR、证据 index 及其它均未触碰）；未访问/修改 Godot 或运行任何 build/test/export。
- **不变量声明（DC-ANCH-01 决策登记后复核，2026-08-16）**：追加 §8.5（R10）、更新 cr-301 状态（→ `user_confirmed（决策引用）`）、更新 §6 计数（needs_user_decision 1→0，**全部决策完成**）与 §7 批次状态（DC-ANCH-01 已决策 closed as decided，治理准备阶段决策批次收官）、版本升 rev-5 后复核——**22 项原始 user_confirmed 决策**（Charter §6）未改写、未重分类；**Exactly 8 canonical revision-02 inputs + 独立 Charter authorization record（8+1）**未变；**PRECHARTER-01..11** 全部保留；**四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）全程区分、无静默提升；**unresolved 全量保留**——DC-ANCH-01 例外仅限被决策项 cr-301（§8.5 R10 升为 `user_confirmed（决策引用）`），Anchor 基线维持 v0.1、v0.2 仍为未接受候选、`recommend-revision` 剩余项登记为未来版本化修订候选；未选项（Option 2/3/4）不删除、不静默推广；其余 unresolved 全部保留 open；**候选预算保持仅候选**——六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线均未被本卡提升（§8.5 末结论）；本文件未修改任何其它既有文档（Tech/Systems/UX 合同、ADR、证据 index、STYLE_MANUAL、UX §10、Charter Anchor 条款及其它均未触碰——Doc Scribe 因本决策维持 v0.1 无需更新基线引用）；未访问/修改 Godot 或运行任何 build/test/export。
- **不变量声明（ADR 批准 + owner 任命确认登记后复核，rev-6，2026-08-16）**：追加 §8.6（R11 = ADR-TECH-01..06 批准，TECH-07/08 未批准；R12 = owner 任命确认 Godot Gameplay Engineer）、更新 §1 状态/版本、§6 摘要与 §7 状态，版本升 rev-6 后复核——**22 项原始 user_confirmed 决策**（Charter §6）未改写、未重分类；**Exactly 8 canonical revision-02 inputs + 独立 Charter authorization record（8+1）**未变；**PRECHARTER-01..11** 全部保留；**四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）全程区分、无静默提升（R11 的 ADR 状态行升级为批准后由 Tech Lead 在 ADR 文件执行，**本 ledger 仅登记决策引用，不把任何数值/决策提升为 `user_confirmed` 之外的类别，也不代改 Tech 拥有的 ADR 文件**）；**unresolved 全量保留**——本 rev 未把任何 unresolved 项升级为决策解决：ADR-TECH-07/08 保持 `draft_in_review` / `NOT APPROVED`；TECH-05 的精确数值语义（cr-006..020）保持 `unresolved` 移交 Systems 契约 in_flight；任命条件②（实现授权解除）、③（start 证据）保持待后续；候选预算保持仅候选——六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线均未被本 rev 提升；未选项、未批准项（TECH-07/08）不删除、不静默推广；**本 rev 未修改任何其它既有文档**（ADR 文件、Tech/Systems/UX 合同、evidence index、Charter、QA 验收计划及其它均未触碰——ADR 状态行更新为 Tech Lead 的后续协调动作，非本文件代做）；未访问/修改 Godot 或运行任何 build/test/export；**批准 ≠ 实现授权——implementation 仍 `NOT_AUTHORIZED`，kickoff 仍 `not_ready`**（§8.6 边界声明）。
- **不变量声明（实现授权登记后复核，rev-7，2026-08-16）**：追加 §8.7（R13 = 实现授权生效，provenance = `user_confirmed` 用户正式授权 2026-08-16）、更新 §1 状态/版本、§6 摘要、§7 状态与 §1.1 sources，版本升 rev-7 后复核——**22 项原始 user_confirmed 决策**（Charter §6）未改写、未重分类；**Exactly 8 canonical revision-02 inputs + 独立 Charter authorization record（8+1）**未变；**PRECHARTER-01..11** 全部保留；**四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）全程区分、无静默提升；**unresolved 全量保留**——本 rev 未把任何 unresolved 项升级为决策解决：ADR-TECH-07/08 保持 `draft_in_review` / `NOT APPROVED`；TECH-05 精确数值语义（cr-006..020）、GDMCP 预检结果、实际 start 证据均保持待后续/未决（沉默不解决）；R13 为实现授权生效（已批准契约内），非新契约、非 resolve 任何 unresolved 项；候选预算保持仅候选——六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线均未被本 rev 提升；TECH-07/08、未选项不删除、不静默推广；**本 rev 未修改任何其它既有文档**（ADR 文件、Tech/Systems/UX 合同、evidence index、Charter、QA 验收计划及 `KICKOFF_READINESS_ASSESSMENT` / `IMPLEMENTATION_OWNER_NOMINATION` 均未触碰——仅以只读方式核对前置条件）；未访问/修改 Godot、代码、场景、资源；未运行、构建、测试、导出、发布；未验证/未预检任何工具链（GDMCP 预检为实现成员职责，本登记不替代验证）；**授权 ≠ 预检通过 ≠ 实际动工——implementation `NOT_AUTHORIZED → 授权生效`（契约内），kickoff `not_ready → 授权生效`，实际动工待 GDMCP 预检通过 + start 证据**（§8.7 边界声明）；`reauthorize_charter` 未触发。

**Closure:** `closure_ready = yes` **only for this static CR-ledger artifact** after creation, the Batch 1 decision-record update (2026-08-16), the AUTH-01 standing-authorization registration (2026-08-16, §8.2), the Batch 2 decision-record update (2026-08-16, §8.3 R04–R08), the Batch 3 decision-record update (2026-08-16, §8.4 R09), the DC-ANCH-01 decision-record update (2026-08-16, §8.5 R10 — **governance-readiness decision batches closed**), the ADR-TECH-01..06 approval + implementation owner appointment registration (2026-08-16, §8.6 R11/R12), and the **implementation authorization registration (2026-08-16, §8.7 R13)**, and reread. It is not a kickoff pass, an implementation authorization, a contract approval, or an acceptance verdict. **Implementation authorization is now effective (§8.7 R13, user_confirmed) — implementation transitioned `NOT_AUTHORIZED → 授权生效` (contract-scoped: ADR-TECH-01..06 + decided decisions; TECH-07/08, candidate budgets, and QA acceptance unchanged); kickoff transitioned `not_ready → 授权生效`, but actual start still requires the implementation member's GDMCP preflight (doctor / editor-state) pass + recorded start evidence (⏳ 待验证 — user-configured gdmcp/gdunit4 at `D:\Game\New_Game\godot_game_dev` pending implementation-member verification). Registration ≠ GDMCP preflight pass ≠ actual start.** Gates 0/1 remain `ready_for_next_review` (static review only — QA pass); Gates 2–6 remain `not_run / not_ready`; AUTH-01 adds delegation/process rules only — no release or threshold authority is conferred, and implementation authority is limited to the approved contract scope. **ADR-TECH-01..06 approval (§8.6 R11) makes them effective technical contracts at the decision level (Tech Lead to update the ADR status lines to `approved` in the Tech-owned ADR package), and §8.7 R13 activates implementation within that approved scope; neither is a contract/QA/release authority grant beyond the approved boundaries.**