# IMPLEMENTATION OWNER NOMINATION v0.1 — 实现 owner 任命提案 + kickoff readiness 更新说明

> **Artifact type:** 任命提案 / 评估更新说明（非任命决定、非实现授权、非批准、非验收）
> **Prepared by:** Executive Producer / Lead Producer（执行制作人 / 首席制作人）
> **Lifecycle:** `development governance / kickoff readiness preparation`
> **权威与边界:** 产出**实现 owner（Godot Gameplay Engineer）任命提案** + 基于现状的 **8 项 readiness 前置满足度更新**。**最终任命由用户确认；该 owner 的实际启动（接触 Godot/代码/运行时）仍需实现授权，当前 `NOT_AUTHORIZED` 维持；本提案 ≠ 任命决定 ≠ 实现授权。**
> **Evidence class:** `static/source` only。未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未批准或冻结任何 ADR/合同；未豁免 QA blocker；未替 Independent QA 下 verdict；未替用户做任命/实现授权决定。
> **Provenance 参照:** `Development Charter v0.1`（AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY）；CR 台账 rev-5（38 条 = 13 已决策 + 25 absorb，`needs_user_decision = 0`）；QA_ACCEPTANCE_PLAN_v0_1（Gate 2 验收计划定稿）；ADR_REVIEW_SYSTEMS_INPUT_v0_1 / ADR_REVIEW_UX_INPUT_v0_1（评审输入在库）；KICKOFF_TECH_ADR_CONTRACTS_v0_1（ADR-TECH-01..08 `draft_in_review`，总状态 `PROPOSAL / DRAFT / NOT APPROVED`）。

---

## 0. 专家能力加载与接口实测证据

- **实际工具顺序（真实记录）：**
  1. `read` 精确角色专家 Skill 文件 `C:\Users\User\.agents\skills\godot-executive-producer-expert\SKILL.md`（245 行全文）——能力预读，入上下文。
  2. **直接调用 `skill({ name: "godot-executive-producer-expert" })` —— 调用成功**，运行时返回完整 SKILL 指令内容（同一会话中 `godot-game-team` 亦已由系统注入 skill_content）。**能力证据等级 = `strong_direct_skill`（首选等级；实际调用验证成功，非仅凭清单判断）。**
  3. 并行 read `KICKOFF_READINESS_ASSESSMENT_v0_1.md` / `QA_ACCEPTANCE_PLAN_v0_1.md` / `DEVELOPMENT_CHARTER_DRAFT_v0_1.md`。
  4. `skill`（同上）之后并行 read `CHANGE_REQUESTS_v0_1.md` / `QA_REVIEW_R01_R10_VERDICT_v0_1.md`。
  5. 并行 read `ADR_REVIEW_SYSTEMS_INPUT_v0_1.md` / `ADR_REVIEW_UX_INPUT_v0_1.md`。
  6. grep `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` 的 ADR 状态/§18 dossier 行，确认 ADR-TECH-01..08 总状态仍 `PROPOSAL / DRAFT / NOT APPROVED`（`draft_in_review`），无一项批准。
  7. write 本文件（唯一产物）。
- **接口实测结果:** 本 DSH 运行时 `skill` 接口**实际发起调用成功**并返回指令内容；未发生 unknown tool / 接口不存在错误。按实测纪律（2026-08-16），不得仅凭函数清单判定 `skill`/`tools.skill` 不可用——本会话实测成功，能力证据等级 = `strong_direct_skill`，未伪报、未降级。
- **应用证据:** 本提案按该 Skill 方法执行——**任命是委派、非自证**（实现 owner 不得自己验收）；**决策权边界**（实现范围内技术决策 vs 跨产品/架构/阈值/发布边界）；**write ownership**（Godot mutation 唯一写入 owner + GDMCP 铁律）；**stop conditions**（升级/QA blocker 不豁免/证据门不跳过）；**诚实边界**（static/source only，不虚报 runtime/QA 证据）；**边界漏斗**（未替用户做任命/实现授权决定）。
- **本任务未调用** `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

---

## 1. 任务范围、授权衔接与写入边界

- 用户经 `/godot-game-team` 方向 B，选择「按 Producer 建议顺序补齐缺口」——本任务 = Producer 建议**步骤②（任命实现 owner）+ 步骤⑤前置（readiness 评估更新）**。
- **边界：** 本任务产出**任命提案**（named owner 定义 + 决策权 + write ownership + stop conditions），**最终任命由用户确认**；且该 owner 的**实际启动**（接触 Godot/代码/运行时）仍需实现授权（当前 `NOT_AUTHORIZED`）——**任命 ≠ 启动**。
- 当前权威:`AUTH-01`（硬边界四项——实现仍 `NOT_AUTHORIZED`、QA 独立性、父线程边界、候选预算仅候选）。
- **只允许写入：** 本文件 `IMPLEMENTATION_OWNER_NOMINATION_v0_1.md`（唯一新产物）。未修改任何既有文档（readiness 评估、CR 台账、Charter、ADR、QA 验收计划等一律未触碰——readiness 评估的正式更新可由后续任务或新版本文件处理）。
- **Evidence class:** `static/source` only。

---

## 2. 实现 owner 任命提案

> **本提案不是任命决定。** 任何字段的生效条件见各字段标注；**最终任命须用户确认本提案**。

### 2.1 Named owner 定义

| 字段 | 内容 | 状态标注 |
|---|---|---|
| **角色** | **Godot Gameplay Engineer**（对应游戏团队 roster；对应角色专家 Skill = `godot-gameplay-engineer-expert` + 配套 `gdmcp` / `godot-cli-validation` 等） | `提案`（Role 已由 Charter §4「Gameplay Engineer (future)」占位；本提案将其落为 named owner，**非新角色、不扩张 roster**，对应未来实现阶段） |
| **Scope（授权后的实现范围）** | 最小确定性核心 seam（rules/state core → session）的**场景/脚本/资源/输入映射/引擎集成**（`.gd`/`.tscn`/`.tres`/`project.godot` 等 Godot mutation）；在经批准的 ADR/合同契约范围内实现 | `提案` + `实现授权后生效`（范围受已决 ADR/contracts 与 Charter caps 约束） |
| **依赖** | 需先在批准路径上就位的 ADR-TECH-01/02/03/04/05/06 之已批准契约 + Systems/UX 契约（当前 `draft_in_review`，`NOT APPROVED`）+ QA 验收计划（Gate 2 判据，`QA_ACCEPTANCE_PLAN_v0_1` 已定稿） | `提案` + `实现授权后生效`（授权限定在已批准契约上的实现） |

### 2.2 决策权边界

| 权限面 | 授予 / 拒绝 | 状态标注 |
|---|---|---|
| **可实现范围内的技术决策** | **授予：** 场景组织、脚本实现、资源命名/引用、输入映射细节、引擎/API 集成方式——在已批准 ADR/合同的 unresolved 界限内、且不跨越 Charter caps 的实现细化 | `实现授权后生效`（授权后 owner 可在实现范围内自主决定实现细节，不因每个局部技术选择打扰用户；对应 Charter §4「execution_authority 以内」） |
| **不得跨产品/架构/阈值/发布边界** | **拒绝：** 不得改变 player promise / pillars / 非目标、不得改变架构 seam（rules core/session/adapter）、不得把候选预算硬门槛化、不得承诺发布——任何此类改动 → 需经 CR + 用户/授权角色 | `实现授权后生效`（跨边界走 Change Request / 升级路径，绝不静默吸收） |
| **不得自证验收** | **拒绝：** owner 产出实现证据与 trace，但**不等同于 QA 验收**；产出由 Independent QA 独立观察（Gate 2–6）；owner 不得批准自己的实现 | `实现授权后生效`（对应「No self-acceptance」铁律） |

### 2.3 Write ownership

| 写入面 | 规则 | 状态标注 |
|---|---|---|
| **Godot mutation（实现授权后）** | 实现授权解除后，`.gd` / `.tscn` / `.tres` / `project.godot` 及等价 Godot 构件/**通过 GDMCP 的 mutation** 的唯一写入 owner = 该 Godot Gameplay Engineer | `实现授权后生效`（GDMCP 铁律：不经 GDMCP 不直接改；项目变更经 GDMCP 预检 → mutation → 再检路线） |
| **GDMCP 铁律** | 须遵守 Universal Godot gate / `$gdmcp` 合同（preflight `doctor` + `editor state` → 最小 scope 检视 → 经 GDMCP 应用 → 再检 → runtime/log 证据）；不得 shell/generic-writer 直接改 Godot 构件 | `实现授权后生效`（对实现 owner 的强制约束） |
| **实现级 write ownership 未指派前** | 当前**无任何 Godot mutation owner 生效**——实现级 write ownership 仍空缺，直至本提案经用户确认且实现授权解除 | `提案` + `实现授权后生效` |

### 2.4 Stop conditions

| 停止/升级条件 | 规则 | 状态标注 |
|---|---|---|
| **跨承诺/架构风险穿越** | 实现中若触及 promise / immutable / major scope / platform / architecture-risk / threshold / release 边界 → **立即停止并升级**（Producer 打包 → 用户裁决 / CR + reauthorize 路径）；不作为本地决策吸收 | `实现授权后生效` |
| **QA blocker 不豁免** | owner 不得豁免任何 Independent QA blocker；出现 P0/P1、非确定、证据缺失等 QA 阻断 → 停止相关实现并升级，而非绕过 | `实现授权后生效` |
| **证据门不跳过** | 不跳过 GDMCP 预检、fixture/seed/trace/snapshot、Gate 2–6 证据门；缺失 mandatory 证据 = `not_run`（非 pass） | `实现授权后生效` |
| **ADP stop conditions 沿用** | 沿用 Charter §2.3 / §8 / §9 与各 ADR/合同 stop conditions（scope drift、非确定、遮蔽、stale input、候选硬化、证据缺失、平台漂移） | `实现授权后生效` |

### 2.5 任命条件（正式生效的前提）

> 正式任命生效需**全部**满足以下三项；满足前该 owner 不视为 active、不接触 Godot/代码/运行时。

| # | 任命条件 | 状态标注 |
|---|---|---|
| ① | **用户确认本提案**（named owner 定义 + 决策权 + write ownership + stop conditions 获用户认可） | `需用户确认`（本任务只产出提案，最终任命由用户裁决） |
| ② | **实现授权解除**（`NOT_AUTHORIZED` → 授权；由用户在 readiness gate 后请求/授予） | `需用户确认` / `实现授权后生效`（授权不随本提案自动发生） |
| ③ | **记录实际 start 证据**（engineer 实际接触 Godot/GDMCP 前的 start 证据 + 角色专家 preflight / 能力证据；同一级于团队执行门 Gate 3） | `实现授权后生效`（ID / 派发确认 / plan 不构成 start 证据） |

### 2.6 任命提案总结

- **本提案：** 将 Charter §4 的「Gameplay Engineer (future)」占位落为 **named Godot Gameplay Engineer owner**，明确其决策权边界、write ownership 与 stop conditions。
- **本提案不是：** 任命决定、实现授权、kickoff pass、ADR/合同批准、验收 verdict。三项任命条件（用户确认 / 实现授权解除 / 实际 start 证据）任一未满足 → 任命不生效。

---

## 3. Kickoff readiness 评估更新说明（基于现状的 8 项前置更新）

> 基线：`KICKOFF_READINESS_ASSESSMENT_v0_1.md`（本文件为更新说明，**非对该文件的直接改写**——正式更新可由后续任务/新版本文件处理）。更新仅**反映本波已补齐的静态缺口**，不改变 kickoff `not_ready`、implementation `NOT_AUTHORIZED`、Gate 0/1 = `ready_for_next_review`、Gate 2–6 = `not_run / not_ready`。

### 3.1 8 项前置满足度更新表

| # | 前置条件 | 原状态（v0.1 评估） | **更新后状态** | 更新依据 / 剩余缺口 | Owner |
|---|---|---|---|---|---|
| 1 | 产品/设计 gate | 🔶 部分满足 | 🔶 **部分满足**（未变） | Gate 0/1 仍 `ready_for_next_review`（静态复审）；设计 gate `not_run`（Charter §8）。QA_ACCEPTANCE_PLAN 定稿不改变产品/设计 gate 状态 | Producer + Independent QA |
| 2 | seam/ownership 决策 | 🔶 部分满足 | 🔶 **部分满足**（推进中） | ADR-TECH-01/02（seam + ownership）已进入跨角色评审——本波 **Systems/UX 评审输入已在库**（ADR_REVIEW_SYSTEMS_INPUT_v0_1/v0.1、ADR_REVIEW_UX_INPUT_v0.1）标记 `align`/`revise-needed` 意见与阻断 A（Systems；ADR-TECH-04 单点收束依赖）；**ADR-TECH-01..08 尚未批准**，ownership/模块 seam 未冻结 | Tech Lead（依评审修订后逐条批准） |
| 3 | 技术 ADR/合同批准 | 🔴 未满足 | 🔴 **未满足**（推进中，仍最高优先级缺口） | ADR-TECH-01..08 仍 `PROPOSAL / DRAFT / NOT APPROVED`（`draft_in_review`，§18 dossier 确认无一批准）；Systems/UX 合同 `NOT APPROVED`。**本波补齐 = 跨角色评审输入已在库**（Systems `align`/`revise-needed` + 阻断 A；UX `align`/`revise-needed` + ADR-TECH-02 弱阻断），批准路径从「评审待入」推进到「评审输入已交付、待 Tech Lead 依评审修订 → 逐条批准」 | Tech Lead（ADR）；Systems/UX + User（架构风险穿越） |
| 4 | 实现 owner | 🔴 未满足 | 🔶 **部分满足（待用户确认）→ 本提案覆盖** | **本提案（§2）产出 named owner 任命提案**（角色/决策权/write ownership/stop conditions + 三项任命条件）。但未到 🟢：**任命须用户确认（任命条件①）+ 实现授权解除（②）+ 实际 start 证据（③）**，三者任一未满足前 owner 不 active | Producer（提案）→ **User（确认任命）** |
| 5 | GDMCP 路径 | 🔴 未满足 | 🔴 **未满足**（未变） | 实现访问 Godot/GDMCP 仍被 Charter §2.2 非授权覆盖；doctor/editor-state 前置预检**未运行**（须实现授权后按 Universal Godot gate 执行）。**本软缺口不在本波覆盖**（调用需授权，遂维持 `not_run`） | Producer + Tech Lead + future Engineer（授权后） |
| 6 | QA 验收计划 | 🔶 部分满足 | 🟢 **已满足（文档定稿）** | **QA_ACCEPTANCE_PLAN_v0_1 已定稿**：Gate 2 确定性 fixture 判据、fixture schema 提案、mandatory 证据字段审计（缺失 = `not_run`）、独立 QA 观察路线、ADR-TECH-06 的 QA `align` 评审输入。文档层定稿达成；**执行仍待实现授权 + 真实 fixture/runner**（Gate 2 仍 `not_run`） | Independent QA + Tech Lead |
| 7 | write ownership（实现级） | 🔶 部分满足 | 🟢 **已满足（文档定稿）→ 本提案覆盖** | **本提案 §2.3 定义实现级 write ownership**（Godot mutation 唯一写入 owner + GDMCP 铁律）。与 #4 同：**生效仍待用户确认任命 + 实现授权解除**（当前无 active owner | Producer（提案）→ **User（确认）+ 实现授权** |
| 8 | stop conditions | 🟢 已满足 | 🟢 **已满足**（未变） | Charter §2.3/§8/§9 + ADR 各 stop conditions 完备；**本提案 §2.4 将实现级 stop conditions 落为 named owner 的明文约束**（升级 / QA blocker 不豁免 / 证据门不跳过） | 各 role |

**图例：** 🟢 已满足 = 静态层成立且实现后可执行；🔶 部分满足 / 待确认 = 缺口已细化/提案已产出，但冻结、确认或授权未完成；🔴 未满足 = 当前仍未达成，构成剩余 kickoff 前置缺口。

### 3.2 更新后的缺口清单（剩余缺口）

1. **ADR/合同批准（最高优先级缺口，推进中）。** ADR-TECH-01..08 + Systems/UX 合同仍全部 `NOT APPROVED`；跨角色评审输入已在库，**下一步 = Tech Lead 依 Systems/UX 评审意见修订 ADR（含 ADR-TECH-04 阻断 A、ADR-TECH-02 read-model 弱阻断）→ 逐条进入批准流程 → 用户/授权角色确认**。实现 owner 无法在未批准契约上启动（Charter §2.2/§8 gate 为 entry）。
2. **实现授权解除（本波未覆盖，需用户裁决）。** 本提案完成实现 owner 任命提案，但**任命 ≠ 启动**；`NOT_AUTHORIZED` 维持。用户完成 🟢 缺口收束后，可在 readiness gate 就绪时**请求/授予实现授权**（授权不随本文件自动发生）。
3. **GDMCP 实现路径预检（本波未覆盖，待实现授权后执行）。** doctor + editor-state 前置未运行，无证据表明该路径在本环境就绪；须实现授权后按 Universal Godot gate 执行并记录。
4. **实现 owner 任命生效（需用户确认）。** 本提案待用户确认（任命条件①）；确认 + 授权解除 + 实际 start 证据（②③）三满足后才视为 active。

### 3.3 本波已补齐缺口汇总（相对 baseline）

| 本波补齐项 | 原 🔶/🔴 状态 | 更新后 | 交付物 |
|---|---|---|---|
| QA 验收计划定稿 | 🔶（#6） | 🟢 文档定稿 | `QA_ACCEPTANCE_PLAN_v0_1.md` |
| ADR 跨角色评审输入在库 | 🔴（#3 推进中） | 评审输入已交付（待修订/批准） | `ADR_REVIEW_SYSTEMS_INPUT_v0_1.md`、`ADR_REVIEW_UX_INPUT_v0_1.md` |
| 实现 owner 任命提案 | 🔴（#4） | 提案已产出（待用户确认） | **本文件 §2** |
| 实现级 write ownership 提案 | 🔶（#7） | 提案已产出（待确认 + 授权） | **本文件 §2.3** |

### 3.4 满足度汇总（更新后）

| 满足度 | 项数 | 项 |
|---|---|---|
| 🟢 已满足 | 3 | stop conditions；QA 验收计划（文档定稿）；write ownership（提案已产出，待确认+授权）※ |
| 🔶 部分满足 / 待确认 | 2 | seam/ownership 决策（推进中）；实现 owner（提案待用户确认）※ |
| 🔴 未满足 | 3 | 技术 ADR/合同批准（推进中）；GDMCP 路径；实现授权解除 ※ |

> ※ 表示该行的判断依赖「用户确认任命」与「实现授权」两个未决动作；在两者落地前，对应项不视为 fully satisfied（即使静态提案已完备）。

---

## 4. Provenance 分层与不变量保留

### 4.1 分层声明

- **`user_confirmed`（仅引用，不新增）：** 22 项原始决策；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；cr-001（R09 决策引用）；DC-ARCH-01 → A1（R02）；AUTH-01（含「实现仍 NOT_AUTHORIZED / 候选预算仅候选」）；方向 B 选择。**本文件不重写、不重分类任何一项。**
- **`team_proposal`（本文件全部实质建议）：** 实现 owner 任命提案（角色/决策权/write ownership/stop conditions/任命条件）；readiness 8 项前置更新判断；本波补齐项汇总。均为提案，待用户确认 / 相应授权决定。
- **`assumption`：** 实现 owner（若被任命 + 授权）可在已批准契约内履行其决策权与 GDMCP 铁律；readiness 更新仅反映静态缺口补齐，不预支 runtime/QA 结论——均未观察前不成立。
- **`unresolved`（全量保留）：** ADR/合同批准状态、GDMCP 预检结果、实现 owner 是否被用户任命、实现授权是否被用户解除——均保持 open，不因本提案关闭（沉默不解决）。

### 4.2 不变量保留声明

**22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 / 候选预算（六项 + `1280×720` 红线仅候选）**——本文件未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`。

---

## 5. 明确声明（边界漏斗）

- **本提案不是任命决定、不是实现授权。** 最终任命由用户裁决（任命条件①）；实现启动由用户裁决授权（任命条件②）；本提案不代替用户做出请求实现授权的决定——该决定权在用户。
- **未修改任何既有文档：** readiness 评估、CR 台账、Charter、ADR、QA 验收计划、评审输入等一律未触碰；readiness 评估的正式更新可由后续任务/新版本文件处理。
- **未批准/冻结任何 ADR / 合同。**
- **未豁免 QA blocker / 未替 Independent QA 下 verdict / 未替用户做任命或实现授权决定。**
- **未触碰 Godot/运行时：** 未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；无 runtime/视觉/性能/QA 证据。

---

## 6. Evidence inspected（static/source only）

1. `docs/production/KICKOFF_READINESS_ASSESSMENT_v0_1.md`（全 119 行，更新基准）
2. `docs/production/QA_ACCEPTANCE_PLAN_v0_1.md`（全 286 行）
3. `docs/DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（§1–§438 关键行；§4「Gameplay Engineer (future)」、§8 production plan、§10 gate 表）
4. `docs/production/CHANGE_REQUESTS_v0_1.md`（§6 计数、§8 batch/decision、disposition 语义；§260 后未读，不影响本提案引用）
5. `docs/production/QA_REVIEW_R01_R10_VERDICT_v0_1.md`（全 127 行）
6. `docs/production/ADR_REVIEW_SYSTEMS_INPUT_v0_1.md`（全 175 行）
7. `docs/production/ADR_REVIEW_UX_INPUT_v0_1.md`（全 189 行）
8. `docs/architecture/KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（grep 状态行 + §18 dossier，确认 ADR-TECH-01..08 仍 `NOT APPROVED`）

---

## 7. 版本与变更记录

- **v0.1（本文件）：** Executive Producer / Lead Producer 唯一新产物——实现 owner 任命提案（§2）+ kickoff readiness 前置满足度更新说明（§3）+ 明确边界声明（§5）。未修改任何既有文档。

## Closure

`closure_ready = true` **仅**限本静态任命提案 + readiness 更新说明 artifact。非任命决定、非实现授权、非 kickoff pass、非合同/ADR 批准、非验收 verdict；本提案结论不替用户做出任命或实现授权决定。
