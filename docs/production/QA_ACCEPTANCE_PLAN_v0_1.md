# QA ACCEPTANCE PLAN v0.1 — Gate 2 确定性 fixture 验收计划定稿 + ADR-TECH-06 QA/证据视角评审输入

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / NOT EXECUTED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`；Gate 2 `not_run / not_ready`。
>
> **Artifact owner (sole author):** Independent QA / Release Lead（`godot-qa-release-expert`）。
>
> **Evidence class:** `static/source` only。本文件是**验收计划文档定稿 + ADR-TECH-06 评审输入**，既不执行任何验收/观测（Gate 2 仍 `not_run`），也不批准或冻结任何 ADR / 合同 / fixture schema / build-config identity；不豁免任何未来 QA 门；不替实现者自证；不替用户做任何产品/验收裁决。
>
> **本文件仅为「文档定稿」而非「执行」：** 一切执行依赖 ① 实现授权（`NOT_AUTHORIZED` 解除）② 真实 fixture / runner / trace / build-config identity 产出后被 Independent QA 独立观察。

---

## 0. 任务范围、授权衔接、来源与不变量

### 0.1 专家能力加载与实际工具顺序（真实记录）

- **角色专家 Skill:** `godot-qa-release-expert`，解析路径 `C:\Users\User\.agents\skills\godot-qa-release-expert\SKILL.md`。
- **加载等级:** `strong_member_skill` —— 首选实证：本会话**实际调用 `skill({ name: "godot-qa-release-expert" })` 成功**，运行时返回完整 SKILL 指令内容（非仅凭函数清单/工具描述判断，非伪报不可用）。按 DSH 实测纪律（2026-08-16），`skill`/`tools.skill` 均可能「未列入 schema 但实际可调用」，故以实际调用验证；本会话 `skill` 接口实测成功，未发生 unknown tool / 接口不存在错误。
- **实际工具顺序（真实记录）：**
  1. `skill("godot-qa-release-expert")` → **成功**（`strong_member_skill`）。
  2. 并行 read `CHANGE_REQUESTS_v0_1.md` / `DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（全部成功）。
  3. 并行 read `KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md` / `DC_SYS_01_TECH_INPUT_v0_1.md`（全部成功）。
  4. 并行 read `PROPOSALS_CR002_004_005_v0_1.md` / `UX_OBSERVATION_TARGETS_CR001_v0_1.md`（全部成功）。
  5. read `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（含 ADR-TECH-06 全文与 §18 dossier；随后续读 §18 末端）。
  6. read `QA_AUDIT_PERF_PROTOCOL_v0_1.md`（既往 QA 审计输入，供验收计划对齐）。
  7. glob 确认目标文件不存在（净新增）。
  8. write 本文件（唯一产物）。
- **接口实测结果:** `skill` 工具未在 session 函数清单中直接列出，但**实际发起调用成功并返回指令内容**；未发生不可用错误。能力证据等级 = `strong_member_skill`（首选等级）。
- **本任务未调用** `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

### 0.2 授权衔接（引用，不重投）

- 用户经 `/godot-game-team` 方向 B，选择「按 Producer 建议顺序补齐缺口」——本任务 = **QA 验收计划定稿（步骤④）+ ADR-TECH-06 的 QA 跨角色评审输入（步骤①）**。
- **工作边界：** 验收计划是文档定稿（fixture schema 提案、Gate 2 判据、独立观察路线、证据字段审计），**不是执行验收**；ADR 评审是**输入**（`align / revise-needed / block`），不批准任何 ADR。
- 当前权威：`AUTH-01`（流程 P1..P3、委托 D1..D3、硬边界四项——实现仍 `NOT_AUTHORIZED`、QA 独立性、父线程边界、候选预算仅候选）。
- 已决决策引用：DC-PLAT-01 → P1 (R01)；DC-ARCH-01 → A1 (R02)（ADR-TECH-01..08 进入 draft→评审→批准路径，总状态仍 `PROPOSAL / DRAFT / NOT APPROVED`）；DC-PLAT-02 → Option 2 (R03)；DC-PERF-01 → Option A (R04)；DC-ACC-01 → A2 (R05)；DC-ACC-02 → **B3 (R06)**（Gate 3 证据收紧，mandatory 字段齐备才判定，缺失 = `not_run`）；DC-REL-01 → **O2 (R07)**（证据完整性放行，QA 职权内默认零容差）；DC-PLAY-01 → **Option 2 (R08)**（可玩性门分阶正式化，判据 S1–S4 已定，阻断权待 CR+用户激活）；DC-SYS-01 → **Option A (R09)**（cr-001，键序 = 最近威胁 → 簇中心距离 → 稳定排序/稳定 ID）；DC-ANCH-01 → Option 1 (R10)。
- 本文件**只引用上述决策，不在本文件内重投/改判任何决策**。

### 0.3 只读来源清单（证据类别：static/source only）

1. `docs/production/CHANGE_REQUESTS_v0_1.md`（R06 B3、R07 O2、R08、R09、R04 等决策引用；cr-110/111/112 登记）。
2. `docs/DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（§10 Gate 0–6 表、mandatory 证据字段、preflight/start 强制项）。
3. `docs/architecture/KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md`（五层证据信封、身份/版本字段、compare/verdict/retest 语义、`schema_incompatible`/`missing_evidence`/`not_run` 等缺失态）。
4. `docs/production/DC_SYS_01_TECH_INPUT_v0_1.md`（§3 fixture 族：TARGET-tie / removal / no-target / container-order / float-epsilon / B2-arc-order；§2.2–2.6 确定性纪律；§4.2 headless seam 形态）。
5. `docs/production/PROPOSALS_CR002_004_005_v0_1.md`（Systems 提案：距离度量 M-1、失效语义 (i)、no-target quiet cycle；trace 字段）。
6. `docs/production/UX_OBSERVATION_TARGETS_CR001_v0_1.md`（UX-02/UX-03 场景矩阵 U2-A..D / U3-A..D、观察信号 G1–G4 / S1–S3、B3 完整性字段清单）。
7. `docs/architecture/KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（ADR-TECH-06 全文 §9 + §18 dossier；ADR-TECH-03/04/08）。
8. `docs/production/QA_AUDIT_PERF_PROTOCOL_v0_1.md`（Independent QA 既往审计输入，供验收计划对齐其审计位与 `partial`/auditable 方法论）。

未读取任何其它文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未执行任何验收/观测/QA 执行；未派发/扩展任何成员。

### 0.4 写入边界与不变量保留

- 本文件是本次任务**唯一写入的新产物**：`docs/production/QA_ACCEPTANCE_PLAN_v0_1.md`。未修改任何既有文档（Charter、CR 台账、Tech/Systems/UX 输入、ADR、Evidence schema、QA_AUDIT_PERF_PROTOCOL、UX 合同等一律未触碰）。
- 不变量声明（全部维持原状，本文件未改动任何一项）：
  - **22 项原始 `user_confirmed`**（Charter 决策 #1..#22）；
  - **恰好 8 项 canonical v0.1-revision-02 inputs + 独立 Charter authorization record（无第九项）**；
  - **PRECHARTER-01..11**；
  - **四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）；
  - **unresolved 全量保留**（本文件不把任何 unresolved 项升级为决策；不把任何 `team_proposal` / 候选数值提升）。
- 候选预算（六项性能候选 + `1280×720` 红线）全部保持**仅候选**，本文件不涉及、不提升。

---

## 1. Expert preflight（按 godot-qa-release-expert §Expert preflight，应用于本定稿任务）

- **验收范围（本文件定稿的对象）：** Gate 2「确定性/runtime」判据 + fixture schema 提案 + Independent QA 独立观察路线 + 证据字段审计（mandatory + 缺失处理 = `not_run` + 默认零容差 O2/B3）。
- **Changed risks（本 scope 相关）：** 目标语义使移动因果可读性不清（Charter §9 首行风险）；排序/稳定 ID / 失效时序的容器顺序依赖与浮点非确定；locked 后移除目标被误判为「有效命中」或「打空气」（Systems §5.1 规则 6）；no-target 误导性命中反馈违反产品边界；reset / same-frame 时序；trace/schema 静默不兼容比较（假 pass）。这些均由 ADR-TECH-04/05/06 stop condition 与 cr-002..005/110/111 覆盖。
- **所需证明类型：** 确定性 fixture 提交后由 QA 独立核计——`static/source`（schema/fixture 定义文本）**可审计**，但 Gate 2 判定**只能由 `runtime` 类证据（真实 runner 输出 + trace + snapshot）支撑**。静态文档不能通过 Gate 2（Charter §10 best-effort「Runtime, visual QA, and performance evidence are non-interchangeable」）。
- **环境/目标：** 未来授权实现的确定性 headless runner（按 TC-INPUT §4.2 seam：`step(...)` + 纯函数 `ordered_candidates(state, params) → ordered_ids`）。Gate 2 为纯规则 seam，无 Godot 渲染 runtime；run on 授权后实现；当前虚拟环境 = `not_run / not_ready`（本文件不触即不改变）。
- **独立性边界：** 验收由 Independent QA/Release 独立执行与独立 verdict。实现者（Engineer）、Tech、Systems、UX 不得自证；Producer 不得豁免 QA blocker。本文件是**计划**，授权后的实际验收仍须由独立 QA 执行；本文件不代替未来 QA 观察。
- **Top three failure hypotheses（验收计划需防）：**
  1. 排序 / 稳定 ID / 失效时序依赖隐藏容器顺序或浮点抖动 → 同 seed 跨 run / 跨容器插入序不一致（G1 破坏、复现失败）。
  2. locked 后目标被移除/失效被误判为「有效命中」或「打空气」→ 违反「移除目标不得命中」禁令（S2、G4）。
  3. fixture / schema / build-config identity 静默不兼容 → `exact_mismatch` 被吞、假 pass；或 mandatory 字段缺失仍被判定（违反 B3）。
- **停止条件：** 本文件产出并通读；不进入实现、不执行验收/观测、不批准 ADR、不派发。任一未来验收执行都依赖实现授权 + 真实 fixture + 独立 QA 观察。
- **会阻断「pass」的点（B3 / Charter §10）：** 任何 mandatory 字段缺失 = `not_run`（不是 pass）；任何 `schema_incompatible` / `missing_evidence` = 不可判定；任一 in-scope P0/P1 缺陷 = 阻断；observable causality / trace 缺失 = 不可审计。零容差默认仅以命名授权偏差例外（O2/B3）。

---

## 2. Gate 2 判据 — 确定性 fixture 验收（target: TARGET-* 族 + seed 复现 + trace 字段核对）

> Gate 2 目前 `not_run / not_ready`。本判据为**未来授权执行时的判定规则**，不是当前 pass。

### 2.1 Gate 2 验收判定的主谓与前提

- **验收对象：** 最小确定性核心 seam（rules core）的确定性行为——pre-fire refresh → stable-sort/lock snapshot → no-target 分支 / locked-target 解析 → hit 结算 → 失效事件 → trace 字段。
- **前置条件（mandatory preflight/start evidence，Charter §10 强制项）：** 授权版本、mode、milestone、owner/dependency、**build-config identity**（fixture_schema_version / config_version / source_identity / build_identity / seed / tick 语义）、fixture 场景、observer、stop condition。**任一缺失 → Gate 2 `not_run`。**
- **证据类要求：** Gate 2 判定只能由 `runtime` 类证据支撑（真实 runner 输出、初始/期望/实际 snapshot、ordered trace）。静态 schema 文本或 fixture 定义本身**不等于**该 fixture 通过。

### 2.2 Gate 2 判据（per-fixture 判定）

| 判据维度 | 规则 | 证据来源 |
|---|---|---|
| Fixture 覆盖完成 | 指定 TARGET-* 族场景全部执行，且每族携带**容器顺序方差变体**（同场景两种实体插入序） | runner 输出 / 每条 fixture 记录 |
| 排序确定性 | 同 seed + 同 config_version + 同版本化输入序列 + 同 build identity → `ordered_ids` / `target_snapshot_ids` 逐位一致（跨 run、跨容器插入序） | 同 seed 两次 run trace 逐位对比 |
| 失效语义 | locked 后目标移除 → 该 ID 不产生命中（不伪造命中）；`invalidation_event(id, tick)` 入 trace；快照 ID 集不变；no-target 分支显式 | `TARGET-removal` / `TARGET-no-target` trace + hit_results |
| trace 字段核对 | `refresh_tick`、`lock_tick`、`invalidation_event`、`resolution_outcome`、`target_snapshot_ids`、`no_target_branch`、`next_eligible_fire_tick`、tie-break 键 `(k1_bucket, k2_bucket, stable_id)` 齐备且可核对 | ordered trace / snapshot |
| 比较纪律 | 精确匹配（零容差默认）；失败类固定为 `exact_mismatch` / `allowed_nondeterministic` / `schema_incompatible` / `missing_evidence`；无命名授权偏差不得容差 | compare 行为契约 / verdict 记录 |

### 2.3 pass / fail / blocked / not_run 判定规则（B3 完整性）

- **`pass`（单项 fixture）：** 该 fixture 的 mandatory 证据字段（§4 清单）**全部齐备**，且期望事实与 runner 实际输出精确匹配，比较按零容差纪律进行，无 `schema_incompatible` / `missing_evidence`。
- **`fail`：** 期望值 / 实际值精确不匹配（`exact_mismatch`），或任何确定性断言未满足（排序不一致 / 失效目标被命中 / no-target 被伪造等）。保留原始失败证据，不因 retest 通过而删除历史。
- **`blocked`：** 授权实现的 runner 或 fixture 不可用 / 中断 / 无法产出可审计输出 / 独立观察被阻断 → Gate 2 维持 not_pass，直至独立 QA 能按判据观察。
- **`not_run`：** 未执行该 fixture，或**任一 mandatory 字段缺失 / identity（schema/config/source/build）不可用** → **`not_run`（不是 pass，不是 fail）**。B3 强制：mandatory 字段齐备才可判定，缺失即 `not_run`。
- **禁止：** 不得因「另一 fixture 全绿」覆盖本 fixture 的 `not_run` / `fail`；green subset 不 override block（技能 operating system）。

---

## 3. Fixture schema 提案（对齐 Evidence schema 信封 + TC-INPUT §3.1 形状）

### 3.1 对齐原则

- 本提案对齐 **KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0.1 五层信封**（`domain_fixture` / `technical_envelope` / `ux_observation` / `qa_verdict` / `producer_index_entry`）与 **DC_SYS_01_TECH_INPUT §3.1 形状**（header / initial snapshot / expected facts / comparison surface）。
- **层所有权（不越权）：** fixture 的**领域期望事实**语义归 Systems（本文件引用 `PROPOSALS_CR002_004_005_v0_1` 的 M-1 / (i) / quiet-cycle 为 `team_proposal` 输入，不代 Systems 定裁）；**机制落实 / 序列化 / identity** 归 Tech；**观察信号**归 UX；**判断对象 / verdict** 归 Independent QA；**索引 / 留存**归 Producer。本文件作为 QA 提供 **verdict 层所需的观察面与 mandatory 字段一致性要求**。
- 本 schema 提案为 `team_proposal`，不冻结；`fixture_schema_version` 为不可变版本串，任何向后不兼容变更升 MAJOR。

### 3.2 Fixture schema 提案（四区块）

| 区块 | 内容（字段） | 对齐来源 |
|---|---|---|
| **header** | `evidence_id`、`fixture_id`、`fixture_schema_version`、`config_version`、`seed`、`tick_budget`、版本化 `input_sequence`（或引用）、`scenario_id`（族名 + 变体）、`observer`、`timestamp`+`clock_authority` | Evidence schema §4/§6；TC-INPUT §3.1 |
| **initial snapshot** | `player_state`；`entities[{stable_id, kind, position(量化), alive, contact_state}]`；`attack_phase`；`timer_before` | TC-INPUT §3.1 |
| **expected facts** | 每条断言给出**显式期望值或显式不变量** + 允许偏差清单；unresolved 阈值标注为 `unresolved`（Systems §11-3） | TC-INPUT §3.1；PROPOSALS §2.5/§3.5/§4.4 |
| **comparison surface** | 确定性字段**精确匹配**：`ordered_ids`、`target_snapshot_ids`、`hit_results`、事件序列（含 `invalidation_event`）；失败类固定 `exact_mismatch / allowed_nondeterministic / schema_incompatible / missing_evidence`；默认零容差（O2/B3：无命名授权偏差即不容差） | Evidence schema §8；TC-INPUT §3.1 |

> 范围：规则 fixture 全部 headless，无视觉/帧断言（视觉/UX 属 Gate 3 与 UX-02/UX-03，不在此列）。

### 3.3 与 Evidence schema 信封的字段映射（QA verdict 层必须可读取）

- 每条 Gate 2 fixture 记录应落在信封的 `domain_fixture`（Systems 期望事实）+ `technical_envelope`（identity/seed/tick/snapshot/trace）+ `qa_verdict`（observer/verdict/deviations/retest）三层；`producer_index_entry` 由 Producer 后续装配链路。
- Gate 2 判定所需的 `qa_verdict` 层字段至少包括：`observer`（独立 QA 身份）、`verdict`（`not_run/pass/fail/blocked/inconclusive/superseded`）、`unresolved_deviations`、`retest_of`/`supersedes`（不覆盖历史）。
- **审计要求：** 本 schema 提案仅供 QA 在验收执行时比对；任何字段语义冲突（如 fixture 期望事实被 technical layer 改写）→ 视为 `schema_incompatible`，不得 pass（对齐 Evidence schema §7 命名空间防火墙）。

### 3.4 目标相关 fixture 族映射（对齐 TC-INPUT §3.2 + Systems §2.6 + UX 场景矩阵）

| Fixture 族 | 场景 | 期望事实（QA verdict 观察面） | 覆盖 |
|---|---|---|---|
| `TARGET-tie` | 两候选按度量等距 | `ordered_ids` 精确 = 键链次序（cluster-center 优先，最终 stable_id 决序） | G1/G3 稳定可重复性 |
| `TARGET-tie-cluster-center` | 距离桶与簇心桶均相等 | 落 stable_id 决序；跨 run 一致 | G1 |
| `TARGET-removal` | 锁定快照含 ID X；解析前 X 被移除 | X 无命中；`invalidation_event` 带 tick 入 trace；快照 ID 集不变；no-target 联动 cr-004 (i) | S2/G4 + cr-004 |
| `TARGET-no-target` | 刷新得空合法集 | `no_target_branch=true`；无伪造目标；`next_eligible_fire_tick` 记录；无命中反馈（quiet/cr-005） | S1/S3 + cr-005 |
| `TARGET-container-order` | 同场景两种插入序 | `ordered_ids` 逐位相同（**关键确定性回归族**） | G1 |
| `TARGET-float-epsilon` | 距离落入量化桶内近等 | 两次同 seed run 排序一致（防浮点抖动） | G1 |
| `B2-arc-order` / `B2-ties` | 三弧同一步各锁一 shot | 弧序固定；各弧 shot 快照与命中独立（决策 #6 独立计数） | N3 + #6 |

---

## 4. 证据字段审计（mandatory 清单 + missing 处理 = not_run + 默认零容差 O2/B3）

### 4.1 Mandatory 字段清单（Gate 2 fixture 记录，B3 完整性）

> 依 Charter §10「Required evidence record fields」+ Evidence schema §6 + TC-INPUT §3.1 + UX-OBS B3 清单。**下列字段对每条 Gate 2 记录均为强制**（存在或显式 `not_applicable`+理由，不得静默填充）。

- **身份链：** `evidence_id`（不可变唯一）；`fixture_id`；`fixture_schema_version`；`evidence_envelope_version`；`config_version`；`source_identity`；`build_identity`（含 build_mode，future `runtime` 证据必填）；`seed`（显式数值/null+理由）。
- **执行上下文：** `run_id`；`tick_context`（`{tick, step, frequency?}`，精确频率未决）；`scenario_id`。
- **输入 / 快照 / 期望 / 实际：** `input_sequence_ref`；`initial_snapshot_ref`（+digest）；`expected_snapshot_ref`/`expected_trace_ref`（+digest，unresolved 期望保持标注）；`actual_snapshot_ref`/`actual_trace_ref`（+digest）。
- **领域与事件：** `domain_events`（有序，namespace 明确）；`state_before`/`state_after`；`ordered_ids`；`target_snapshot_ids`；`hit_results`；`invalidation_event(id,tick)`（如适用）；`no_target_branch`；`next_eligible_fire_tick`（如适用）；`feedback class`（UX-03，绑定 hit_results，S2）。
- **观察与判定：** `observer`（独立 QA 身份）；`timestamp` + `clock_authority`；`verdict`；`unresolved_deviations`；`retest_of`/`supersedes`；`log_refs`/`trace_ref`/`snapshot_ref`（raw 可检索引用）。

### 4.2 缺失处理规则（B3）

- **任一 mandatory 字段缺失 / identity 不可用 → 该记录 = `not_run`**（不是 pass、不是 fail、不是 inconclusive）。
- **比较无法按声明版本执行 → `schema_incompatible`**（≠ pass）。
- **声明了但找不到 / 无法核验 → `missing_evidence`**（≠ pass）。
- 缺失状态与 `not_run`/`not_ready`/`no-runtime-evidence` 明确区分，不 collapse（Evidence schema §9.4）。
- **no-runtime 静态记录不得替代 Gate 2 的 runtime 判定**（static 文档 / fixture 定义文本不是该 fixture 的证据）。

### 4.3 默认零容差（O2/B3）

- 比较默认零容差；任何 variance/tolerance 仅在 ① fixture 契约显式列明 ② authority 命名 ③ 已批准授权偏差记录链接时允许（Evidence schema §8.5）。本文件不批准任何 variance。
- 候选预算（六项 + `1280×720` 红线）不涉及 Gate 2 判定，全部保持仅候选。

---

## 5. Independent QA 独立观察路线（实现授权后如何观察）

> 本路线为**未来授权实现后的观察方法**，不是当前执行。Gate 2 `not_run / not_ready` 维持。

- **观察对象：** 授权后的确定性 runner（TC-INPUT §4.2 seam：`step(...)` + `ordered_candidates(...) → ordered_ids`）+ 真实 fixture / trace / snapshot 产物。
- **QA 独立步骤（per fixture 验收）：**
  1. **记录 preflight/start identity**（§4.1 身份链）；缺失 → `not_run`。
  2. **运行 / 复现：** 同 seed 两次 run，核对 `ordered_ids` / `target_snapshot_ids` 逐位一致（跨容器方差变体再核）。
  3. **trace 比对：** 期望 facts vs 实际 traced 事件（含 invalidation/no-target/hit_results），零容差精确比对；`schema_incompatible`/`missing_evidence` → 不可判定。
  4. **失效 / no-target 专项：** `TARGET-removal`（locked 后移除 → 无幽灵命中）与 `TARGET-no-target`（无伪造目标、无命中反馈）——cr-004 (i) / cr-005 quiet-cycle 语义是否在可观察面满足 S2/S1/S3。
  5. **证据索引核对：** 确认每个 `evidence_id` 可经 Producer 索引链接到 fixture/source/build/config identity/observer/artifact location（审计可检索性）。
  6. **verdict：** 记录独立 `observer` + `verdict`（`not_run/pass/fail/blocked/inconclusive/superseded`）+ `unresolved_deviations`；**retest 保留原失败** + 新增 `evidence_id`（不覆盖历史）。
- **retest 链：** 同场景 + 新 build/config identity 重跑；保留原失败记录，`retest_of`/`supersedes` 仅作链接；Independent QA 重新观察后才可更新判定。
- **协作边界（不越权）：** 若 fixture 期望事实语义不清 → 请求 Systems 澄清（**不重写规则使测试通过**）；若 runner/seam 可用性缺陷 → 向 Engineer/Tech 请求修复并 n：1 复现支持；QA 本身**不实现 fix、不批准 ADR、不提升候选预算**。

---

## 6. 明确边界声明（文档定稿 vs 执行）

- **计划是文档定稿，不是执行：** 本文件定稿 Gate 2 判据、fixture schema 提案、独立观察路线、证据字段审计方法；**未执行任何验收 / 观测 / QA 运行**。Gate 2 `not_run / not_ready` 维持不变。
- **执行依赖授权与真实产物：** 未来验收必须等待 ① 实现授权（`NOT_AUTHORIZED` 解除）② 真实 fixture / runner / trace / build-config identity 产出 ③ 独立 QA 在实际样本上重新独立观察。在本前，一切 Gate 2 相关状态保持 `not_run`。
- **未批准/冻结任何 ADR / 合同 / fixture schema / build-config identity / 证据 index。** 本文件不替代 ADR-TECH-06 的批准流程；不豁免任何未来 QA 门；不替实现者自证。
- **独立性不变：** 不豁免 QA blocker；不替用户做产品/验收裁决；候选预算全保持仅候选。
- **证据类别：** 本文件仅为 `static/source`。无 runtime / visual QA / performance / export / release 证据，也不声称任何此类证据。

---

## 7. ADR-TECH-06 QA / 证据视角评审输入（步骤①）

> 以下为 Independent QA 对 `ADR-TECH-06 — Headless seam and future evidence schema`（`KICKOFF_TECH_ADR_CONTRACTS_v0_1.md §9`）的 **QA/证据视角评审输入**（`team_proposal`）。**结论为评审输入，不批准 ADR-TECH-06**；ADR-TECH-06 现为 `draft_in_review`（`PROPOSAL / DRAFT / NOT APPROVED`），未冻结、未生效，仍有待批准流程。

### 7.1 评审对象与评估面

- 评审三个 QA 关切面：**① fixture schema 对齐** ② **build/config identity** ③ **evidence index 可审计性**。
- 参照：Evidence schema 合同（§4/§6/§8/§9）、TC-INPUT §3.1/§4.2、Charter §10 mandatory 字段、B3（R06）/O2（R07）决策引用、cr-110/111/112 登记。

### 7.2 逐面评审（QA 视角）

**① fixture schema 对齐 —— `satisfied in-proposal`（提议方向对齐，细节 unresolved,不阻塞评审输入）**
- ADR-TECH-06 §9「Fixture / comparison schema (proposal)」所列字段（`evidence_id` / `fixture_id` / run_id / seed / tick/config/schema versions / input sequence / initial snapshot / expected & actual snapshot/trace / build ID / observer / timestamp / unresolved deviations）与 Evidence schema envelope 及 TC-INPUT §3.1 形状**对齐良好**；TC-INPUT §4.2 的 `ordered_candidates(...)` seam 与 `step(...)` 输入输出形态可支撑 field 级精确比较。
- **variance/tolerance：** ADR-TECH-06 未选容差规则，与默认零容差（O2/B3）一致；仅命名授权偏差例外。QA 认可该默认。
- **缺口 / 建议（不冻结）：** unsolved 细节包括 fixture 期望事实的**语义归属确认**（Systems 未在 ADR-TECH-06 内的 fixture 决策；cr-110 待决）、`feedback class`/UX 观察信号的 binding 位置（归 UX-03 而非法。fixture comparison surface）、`tick_context`/`run_id` 明确的收纳（对齐 schema `run_id`，避免执行上下文归属不清）。这些属授权后的精化 + 相应评审，**不阻塞本评审输入的 `align` 方向**。

**② build/config identity —— `satisfied in-proposal`（方向到位；未命名平台/引擎不阻塞纯 headless Gate 2）**
- ADR-TECH-06 §9「Build/config identity」要求 source revision / build mode / config version / platform / engine/toolchain / seed / fixture / timestamp —— 已覆盖 cr-112（P1 激活 target 身份）、config_version/schema_version/source_identity、build_identity/build_mode。对纯 headless runner 的 Gate 2，`build_identity`（含 source/config/fixture_schema version + seed）即可满足可复现要求。
- **缺口 / 建议：** 平台/OS/硬件/settings 等条件字段在 Gate 2 headless 场景多为 `not_applicable`，但**必须显式标注 `not_applicable`+理由**（对齐 schema §6 条件字段纪律），不得静默省略；`run_id` 建议显式收纳。命名硬件/OS/settings 属性能（Gate 4 / cr-107/108）与导出（Gate 5）要求，非 Gate 2 纯规则观察的硬前置——本评审输入不把 Gate 2 错误地绑定到测量身份上。

**③ evidence index 可审计性 —— `satisfied in-proposal`（方向到位；Producer 索引为未来 handoff，未冻结）**
- ADR-TECH-06 「Future evidence IDs」要求 evidence_id 不可变 + Producer index 链接到 fixture/source/build/config identity/observer/artifact location/verdict —— 与 Evidence schema §9/§4.2 一致；`schema_incompatible`/`missing_evidence`/retest lineage 语义已对齐。
- **缺口 / 建议：** Producer 索引/留存契约尚未冻结（Evidence schema §9 handoff）；raw trace/snapshot 的构成/格式/链接/留存位置仍需在批准路径中定稿（对齐 QA_AUDIT_PERF_PROTOCOL 中 G6 的同类教训——「声明了保留」须有可核验的满足者与证据）。缺 index linkage → 该 evidence 不可审计。

### 7.3 ADR-TECH-06 评审结论（QA 视角）

> **结论：`align`**（对齐/可推进评审——QA/证据视角下 ADR-TECH-06 的 seam 输入输出、fixture compare schema、build/config identity、evidence index 提议**方向正确、可审计框架到位**，可按 A1 draft/review 路径继续跨角色评审与逐条批准流程）。

**依据（QA 视角）：**
- headless seam 形态（`step(...)` + `ordered_candidates(...)`）满足「无渲染可比较纯规则行为」的可测性前置（ADR-TECH-06 stop condition / TC-INPUT §4.2）；QA Gate 2 独立观察路线（§5）可直接基于该 seam 与 fixture 产物执行。
- fixture compare schema 字段集对齐 Evidence schema envelope 与 TC-INPUT §3.1，默认零容差（O2/B3）一致 —— 满足 QA「精确比较 + schema_incompatible/missing_evidence 不可 pass + retest 不覆盖历史」的验收纪律。
- build/config identity 覆盖能支撑可复现（gate-2 足够），条件字段可显式 `not_applicable`，未把测量身份错误地绑定到 Gate 2。
- evidence index 可审计方向到位（不可变 ID + Producer 链接 + raw 引用），raw 留存契约与 index 冻结属授权后完成项。

**附注（不阻塞 align，供后续重视）：**
- fixture 期望事实的**语义归属（Systems）**与 UX 观察信号绑定（UX-03）仍需在相应评审中确认（cr-110 / cr-005），本评审输入不代 Systems/UX 定裁。
- Producer 证据 index 与 raw 留存契约（含 digests/链接/位置）应在批准路径中定稿；QA 在真实样本上才能对「可审计性」做最终独立核验（参照 QA_AUDIT_PERF_PROTOCOL 的诚实边界：无样本时可审形状，不可预支对真实样本的核验结论）。
- `run_id` 显式收纳建议（对齐 schema §6，避免同一 evidence_id 下多次采样窗口上下文归属不清）。
- **ADR-TECH-06 仍未批准 / 未冻结 / 未生效**（`draft_in_review` → `PROPOSAL / DRAFT / NOT APPROVED`）；本评审输入不改变该状态，不替代批准流程，不豁免任何 QA 门。

---

## 8. Provenance 分层与不变量保留

### 8.1 分层声明

- **`user_confirmed`（仅引用，不新增）：** 22 项原始决策（含 #3 pre-fire 刷新+锁定、#5 同帧生命耗尽优先、#6 独立弧计数）；revision-02 #3/#4/#8；PRECHARTER-01/-02/-04/-11；cr-001（Option A，R09）；cr-101..105/201（R01–R03）；cr-109/106/114/113/202（R04–R08）；cr-301（R10）；AUTH-01；本文件全部依赖的「实现仍 `NOT_AUTHORIZED` / Gate 2 `not_run`」状态均如引用。本文件不重写、不重分类任何一项。
- **`team_proposal`（本文件全部实质建议）：** Gate 2 判据定稿、fixture schema 提案、mandatory 字段审计清单与缺失判定规则、独立观察路线、ADR-TECH-06 `align` 评审输入、协作边界。所有引用 Systems（M-1/(i)/quiet-cycle）与 UX（G1–G4/S1–S3、U2/U3 场景）的提案均按 `team_proposal` 引用，不代升级。
- **`assumption`：** 确定性排序在 seed+输入序列+固定 tick + 全序键链下保持可复现（G1 期望需观察验证，未观察前不成立）；headless runner 可在纯规则 seam 上被 QA 独立调用；raw trace/snapshot 在批准路径中可核验留存。
- **`unresolved`（全量保留，未关闭）：** cluster membership；metric/quantization 精确数值与单位；tie-break 字段的可读性语义；stable-ID 生命周期细节；invalidation 精确时机与 drain 实现；no-target cycle 精确周期与提示形态；B2 多弧中间态；tick 频率；`fixture_schema_version` 具体值；raw 留存/索引冻结——均保持 open（cr-002..005/110/111/112 承接）。**本文件未把任何一项升级。**

### 8.2 不变量保留声明

**22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量** —— 本文件未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未动用/提升。

---

## 9. 边界声明与 Closure

- **未执行任何验收 / 观测 / QA 运行：** Gate 2 仍 `not_run / not_ready`；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未执行任何 fixture / trace / snapshot 比较；无 runtime/视觉/性能/QA 证据。
- **未批准/冻结任何 ADR / 合同 / fixture schema / build-config identity / evidence index：** ADR-TECH-06 保持 `PROPOSAL / DRAFT / NOT APPROVED`；本文件为其 QA 评审输入，不替代批准流程。cr-110/111/112 与 schema/索引相关内容保持 hold。
- **未豁免任何 QA 门 / 未替实现者自证 / 未替用户做产品或验收裁决。**
- **提交接受边界：** 实现 authorization `NOT_AUTHORIZED`；Gate 2 `not_run`；最终验收放行归 Independent QA/Release（Producer 无权豁免）。
- **写入面：** 仅新增 `docs/production/QA_ACCEPTANCE_PLAN_v0_1.md`；未修改任何既有文档。
- **未派发任何成员：** 未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

**Closure：** `closure_ready = yes`（仅限本静态验收计划 + ADR-06 评审输入文件）。不是 kickoff pass、不是实现授权、不是合同/ADR 批准、不是 Gate 2 验收 verdict。Kickoff 仍 `not_ready`；implementation 仍 `NOT_AUTHORIZED`；Gate 2–6 仍 `not_run / not_ready`。

---

## 10. Next handoff（供父协调器引用）

- 本文件与 QA_AUDIT_PERF_PROTOCOL_v0_1.md 一并作为 QA 侧 kickoff-readiness 评审输入；供 ADR-TECH-06 跨角色评审与 Gate 2 证据计划装配。
- **执行依赖：** 未来 Gate 2 验收必须等待实现授权 + 真实 fixture/runner/trace/build-config identity 产出 + 独立 QA 在实际样本上重新独立观察（届时按正式证据流程，本文件的方法即启用）。
- 后续可补的 QA 交付物（本任务不做，未授权）：Gate 2 实际验收报告（授权后）；Gate 0/1 静态复审意见（独立 QA，尚未运行，`not_run`）。

---

## 11. 版本与变更记录

- **v0.1（本文件）：** Independent QA/Release 唯一新产物——Gate 2 确定性 fixture 验收计划定稿 + ADR-TECH-06 QA/证据视角评审输入（`align`）。未修改任何其它文档，未执行任何验收。
