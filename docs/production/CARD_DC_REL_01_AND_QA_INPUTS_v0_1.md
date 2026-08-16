# CARD DC-REL-01 — OPTIONS PACKAGE（cr-113 未来发布放行姿态）+ DC-PLAY-01 门权威结构 + 波 1 卡片 QA 审计输入

> **Status:** `PROPOSAL / OPTION PREPARATION / NOT A USER DECISION / NOT APPROVED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`。
>
> **制备角色（本文件唯一 owner）：** Independent QA / Release Lead（`godot-qa-release-expert`）；本文件为波 2 任务「DC-REL-01 决策卡片选项制备 + DC-PLAY-01 门权威结构 + 波 1 卡片 QA 审计输入」的唯一新产物。
>
> **本文件是什么：** ① 按 `CHANGE_REQUESTS_v0_1.md §8` 固定卡片结构，为 **DC-REL-01「发布阈值 / 放行条件（cr-113）」** 制备 2–4 个精准、互斥的整体选项（含子维度：放行条件构成 / 证据容差 / Gate 6 判据 / QA 放行姿态·无豁免 / 发布证据包），提交父协调器汇成选项卡片交用户选择；并按 **AUTH-01 §8.2.3 D2** 对每个选项逐条标注升级判定。② 为 **DC-PLAY-01（cr-202）** 产出 QA/Release 侧**门权威结构**（衔接 Systems 判据部分的 §5.5 衔接依赖，不代做判据）。③ 为波 1 卡片（DC-PERF-01 / DC-ACC-01 / DC-ACC-02）提供 **QA 可执行性审计输入**。
>
> **本文件不是什么：** 不是用户最终决策；不替用户选择 DC-REL-01 选项（本卡为升级类卡片，用户必须亲自选择）；不决定 DC-PLAY-01 是否正式化（Systems 卡 Option 1/2/3 由用户选择，本结构为 QA 侧权威骨架）；不批准/冻结/定稿任何合同、ADR 或 Gate 判据；不豁免 QA blocker；不替 Independent QA 下任何 verdict；不把任何 `team_proposal`/`assumption`/`unresolved` 升级为 `user_confirmed`；不提升任何候选预算。
>
> **证据类别：** `static/source` only。未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布；**未执行任何 QA 观测或验收**（Gate 2–6 保持 `not_run / not_ready`，无 runtime 证据可观测）。
>
> **版本：** `v0.1`（选项制备 + 门权威结构 + QA 审计输入产物；非决策、非合同、非批准）。

---

## 0. 不变量与来源边界（先声明，后文不再逐条重复）

- 不变量保留声明（与 Charter §1/§9、CR ledger §1/§9、Evidence schema §2 一致）：
  - **22 项**原始 `user_confirmed` 决策：保持候选约束原状；
  - **恰好 8 项** canonical `v0.1-revision-02` 输入 + **独立**的当前 Charter authorization record（**无第九项**，8+1）；
  - **PRECHARTER-01..11**：全部保留，unresolved 字段未动；
  - **四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）全程区分，无静默提升；
  - **unresolved 全量保留**：cr-113、cr-202 及本文件全部子维度数值在用户选择前一律 open；本制备不提升任何候选数值。
- **被本文件未提升的候选预算（原样保留）**：`1080p/60`、`50 FPS minimum`、input `≤50ms`、hit-feedback start `≤100ms`、cold start `<3s`、restart `<1s` 与 `1280×720` 红线——全部**仅候选**（Charter §6；PRECHARTER-10；revision-02 #7/#8；CR §1.3/§9；AUTH-01 硬边界第 4 条）。本文件任何出现候选数值处必标注：「仅候选，须经 CR + 用户批准才成为正式门槛」。
- **实际读取来源（仅 static/source）**：
  1. `docs/DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（全 439 行：§2.1 revision-02 #6/#7/#8、§3 Gate 状态、§6 候选约束/22 决策/PRECHARTER-10/可玩性门候选、§10 Gate 0–6 表/操作规则/强制 preflight/start 证据/证据字段、§12 开放决策行）；
  2. `docs/production/CHANGE_REQUESTS_v0_1.md`（全 345 行：§3–§8.2：cr-113/cr-202 行、§7 Batch 2 行、§8 卡片结构、§8.1 R01–R03、§8.2 AUTH-01 P1–P3/D1–D3/硬边界、§9 不变量）；
  3. `docs/production/CARD_DC_PLAY_01_OPTIONS_v0_1.md`（全 160 行：S1–S4 判据、§3 选项、§4 推荐、§5 判据构成、§5.5 QA 门权威结构衔接依赖）；
  4. `docs/production/CARDS_DC_PERF_01_OPTIONS_v0_1.md`（全 315 行：DC-PERF-01 选项 A–D、§4 推荐 Option A、附节 B）；
  5. `docs/production/CARDS_DC_ACC_01_DC_ACC_02_OPTIONS_v0_1.md`（全 308 行：DC-ACC-01 选项 A1–A4、DC-ACC-02 选项 B1–B4、§3.5/§4.5 推荐 A2/B3）；
  6. `docs/architecture/KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md`（全 248 行：§1.1 权威映射、§4/§6 字段契约、§5 五层信封、§7 命名空间防火墙、§8 比较行为、§9.4 缺失态）。
- 未读取授权清单之外的任何文件。

---

## 1. 待决项（linked cr_ids + 来源原始表述 + 当前状态）

### 1.1 DC-REL-01 — 发布阈值 / 放行条件（cr-113）

| 字段 | 记录 |
|---|---|
| Card ID | `DC-REL-01`（CR §7 Batch 2 行：制备角色 = Independent QA/Release + Producer 装配；用户裁定） |
| 待决项 | **cr-113**：「发布阈值 / 放行条件：acceptance thresholds, evidence tolerances, release gates unresolved (Charter §12; ADR-TECH-07「Verification」; Evidence index §6)」 |
| 当前状态 | `needs_user_decision`（CR §4 行；§6 计数 = Batch 2 待决策项）；依赖 cr-109（DC-PERF-01）/ cr-106（DC-ACC-01）/ cr-114（DC-ACC-02）；Gate 6 `not_run / not_ready`；QA 放行姿态与 Producer 无豁免权（Charter §10 操作规则） |
| 受影响边界 | Charter v0.1 发布与验收类边界；Gate 6（Independent release review）；AUTH-01 硬边界第 2 条（QA 独立性不变）与第 4 条（候选预算状态不变） |
| AUTH-01 判定 | **D2（升级类）**：§8.2.3 明列「DC-REL-01（发布阈值/放行条件，cr-113）」——**任何模式均不可自动采纳，必须呈交用户亲自选择**。本卡选项涉及 release crossing，必命中 §D2 (e)（部分选项另命中 (b)/(a)），逐选项标注见 §2.3 |
| 发布姿态语义 | **Batch 1 P1（§8.1 R01）= 本期不发布**：任何选项的语义为「定义『将来若发布』什么构成可发布 + QA 如何放行」，**不创建本期发布承诺、不命名渠道、不写发布文案**（cr-103 已按 R01 决策；`reauthorize_charter` 触发条件按 CR §6 Producer note 检查） |

### 1.2 DC-PLAY-01 — 可玩性观察门正式化（cr-202；QA/Release 侧门权威结构）

| 字段 | 记录 |
|---|---|
| Card ID | `DC-PLAY-01`（CR §7 Batch 2 行：Systems/Rules Designer 判据 + QA/Release 门权威结构；本文件为 QA 侧部分） |
| 待决项 | **cr-202**：「Make playability observation a formal gate?」(revision-02 #6; Charter §12 row; Systems §9.2) |
| 当前状态 | 正式化与否 = `user_reserved` / `unresolved`；判据观察项 = `team_proposal`（Systems 卡 §5.1–5.4）；门现状 = `not_run / not_ready` |
| Systems 卡衔接 | `CARD_DC_PLAY_01_OPTIONS_v0_1.md` §5.5：「Independent QA/Release（另行制备）交付：门权威结构（门裁决执行、独立观察、verdict/block/retest 授权、证据审计）」「本判据部分不定义 QA 如何裁决、不替代 QA 预检；两部分的合并评审由父协调器装配为最终选项卡片供用户选择」——本文件 §3 即该衔接口 |
| AUTH-01 判定 | Systems 卡已标注：命中 §D2 (b)/(d) 类（Option 1/2），整卡呈交用户；本门权威结构不改变该判定 |

### 1.3 波 1 卡片（QA 审计输入对象）现状

- **DC-PERF-01（cr-109）**：Batch 2 窗口启用；制备角色 Tech Lead 已完成选项 A–D + 推荐 Option A（CARDS_DC_PERF_01 §4）；Gate 4 `not_run`；性能测量未授权。
- **DC-ACC-01（cr-106）** / **DC-ACC-02（cr-114）**：制备角色 UX/UI 已完成选项 A1–A4 / B1–B4 + 推荐 A2 / B3（CARDS_DC_ACC_01_DC_ACC_02 §3.5/§4.5）；Gate 3 `not_run`；UX-09..13 证据行 `PROPOSAL / DRAFT / NOT APPROVED`。
- 本文件 §4 仅提供 QA 可执行性审计输入，**不替用户选择、不改判任何卡片推荐**。

---

## 2. A. DC-REL-01 选项包（主交付）

### 2.1 共同前提（所有选项适用；不因选项不同而改变）

1. **本期不发布（P1）**：任何选项都只为**未来发布放行姿态**定义判据——「将来若发布，什么构成可发布 + QA 如何放行」；不创建本期发布承诺、不命名渠道、不写发布文案（§8.1 R01；Charter §2.3：release crossing → 用户/重授权）。
2. **QA 独立放行姿态不变（硬边界）**：Independent QA 独立观察、独立 verdict、无豁免；Producer 只装配证据、**无豁免权**（AUTH-01 硬边界第 2 条；Charter §10 操作规则；CR §8 禁止事项）。本卡任何选项不得让渡、豁免或由 Producer 代决 QA blocker。
3. **候选预算状态不变（硬边界）**：六项候选预算与 `1280×720` 红线保持**仅候选，须经 CR + 用户批准才成为正式门槛**（AUTH-01 硬边界第 4 条；CR §1.3/§9）。本卡任何选项不提升其中任何一项；出现候选数值处必标注。
4. **证据纪律不变（Charter §10 / Evidence schema §8/§9.4）**：缺失 mandatory 字段 = `not_run`，不是 pass；证据类不可互换（static/source、synthetic/anchor、runtime、visual QA、performance、export/release、QA 互相不可替代）；retest 保留原失败、新增证据 ID；静态/Anchor 不可替代 runtime/visual QA。
5. **依赖链：cr-113 依赖 cr-109（DC-PERF-01）/ cr-106（DC-ACC-01）/ cr-114（DC-ACC-02）**（CR §4 cr-113 行）——本卡不代填、不预设、不冻结这三张卡的判据内容；只定义发布判据如何引用/挂接其决策记录（引用方式为选项内容差异，见下）。
6. **Gate 6 现状**：`not_run / not_ready`；Gate 6 = Independent release review（Charter §10 表），判据缺失时不可判定。本卡任何选项不构成 Gate 6 执行或放行结论。

### 2.2 子维度定义（本卡覆盖）

| 子维度 | 定义 |
|---|---|
| 放行条件构成 | 未来「可发布」= 什么集合（门、证据、数值子集）满足即视为可放行 |
| 证据容差 | 对发布证据的容忍/宽容规则（默认零容差 vs 显式授权容差） |
| Gate 6 判据 | Gate 6（Independent release review）的判定内容由谁、以何种规则构成 |
| QA 放行姿态 / 无豁免 | Independent QA 放行声明形态；Producer 无豁免；无证据不放行 |
| 发布证据包 | 未来发布时提交的证据 package 构成与完整性要求 |

四个选项沿**「未来放行判据的来源与定稿时点」**主轴互斥：Option 1 = 现在定稿且不含本卡新要素（只认既有门结构）；Option 2 = 现在定稿且含本卡新要素（证据完整性与零容差规则）；Option 3 = 现在定稿结构、放行数值子集内容挂接未来依赖卡决策（绑定句由本卡写入、数值由依赖卡+用户批准）；Option 4 = 全部实质判据留待未来发布决策点（本卡只登记已确认的 QA 姿态）。任一选项均不提升候选数值、不创建本期发布承诺；四分选项不能同时成立。

### 2.3 选项

#### Option 1 — 「门基座放行（Gate-Floor Release）」

- **名称（一句话）：** 未来放行条件 = 现有 Gate 2–6 全部通过 + Independent QA 独立放行 verdict；本卡不引入任何新增放行要素（不发散数值、不写新 Gate 判据内容）。
- **依据：** cr-113 行（release gates unresolved）；Charter §10 Gate 0–6 表（Gate 6 = Independent release review；Producer 无豁免；缺失 preflight = `not_run`）；Gate 语义现状（Gate 2–6 `not_run / not_ready`）；P1 本期不发布（§8.1 R01）；AUTH-01 硬边界第 2 条。此处不引用任何未经证据的事实。
- **影响：**
  - 产品：未来「可发布」= 全门通过；无隐藏数字承诺，玩家面向零新增承诺。
  - 创意：不额外收窄创意/表现空间（无本卡新增数值约束）。
  - 技术：放行面 = 既有门证据（Gate 2 runtime / Gate 3 visual QA / Gate 4 performance / Gate 5 export smoke 均按各自判据）；无新工具面。
  - 范围：放行面 = 现有门结构；任何未来数值门槛化仍走各自卡片（cr-109/106/114）+ CR + 用户。
  - 进度：Gate 6 判据可直接引用既有门结构（无新要素待设计）；排程最轻。
- **风险：** 若未来发布决策点要求额外数字承诺（商店/合规/可访问性合规），本选项未覆盖 → 届时需新 CR + 用户决策（决策平移）；**回滚成本 = 低**（零承诺写入）；**验证成本 = 未来 Gate 2–6 证据 + 独立放行 verdict**。
- **候选标注：** 本选项不涉及数值提升；文中引用候选预算处一律「仅候选，须经 CR + 用户批准才成为正式门槛」。
- **子维度表：**

| 子维度 | 本选项内容 |
|---|---|
| 放行条件构成 | = 适用门（Gate 2–6）全部通过 |
| 证据容差 | = 沿用 Charter §10 既有纪律（默认零容差；本卡不新增容差条款） |
| Gate 6 判据 | = 引用既有门结构与 QA verdict；无本卡新增判据要素 |
| QA 放行姿态 / 无豁免 | = 不变：Independent QA 独立 verdict；Producer 无豁免；无证据不放行 |
| 发布证据包 | = 既有门证据 + QA verdict；不要求本卡新增包结构 |

- **D2 升级判定（AUTH-01 §8.2.3）：** (a) 候选→正式门槛数值提升：**否**；(b) 写入发布承诺/发布文案/Gate 判据：**否**（不写新判据内容）；(c) 命名发布渠道：否；(d) promise/immutable/platform 变更：否；(e) threshold/release crossing：**是**（定义未来放行判据本身触及 release 边界）。→ **命中 (e)**；且 §8.2.3 明列 DC-REL-01 为升级卡——**整卡呈交用户亲自选择**。

#### Option 2 — 「证据完整放行（Evidence-Complete Release）」★ 专业推荐

- **名称（一句话）：** 未来放行条件 = Gate 2–6 通过 + **发布证据包完整性**（Charter §10 mandatory 字段 + Evidence schema 索引映射齐备）+ **默认零证据容差**（证据类不可互换、无静默容差），由 Independent QA 出具含明确证据边界的放行声明。
- **依据：** cr-113 原文（acceptance thresholds, **evidence tolerances**, release gates）；Charter §10（Required evidence record fields；操作规则：证据类不可互换、缺失 mandatory = `not_run`、retest 保留失败；Gate 6 行）；Evidence schema §4.2/§6/§8（`verdict` 枚举、比较行为：无静默容差、`schema_incompatible`/`missing_evidence` ≠ pass、retest lineage）；§9.2（索引字段）；AUTH-01 硬边界第 2 条；与波 1 卡推荐同型（DC-ACC-02 §4.5 推荐 B3「证据收紧」——证据完整性作为可判定的最小完备集）。全部为已确认文档事实，无新增事实。
- **影响：**
  - 产品：未来「可发布」= **可审计放行**；每个放行判定可追溯到证据 ID 与索引链接。
  - 创意：无创意数值约束（证据完整性为流程/证据面）。
  - 技术：证据管线（build identity、artifact digest、索引映射、trace/帧归档）成为 Gate 6 前置 → **需 Toolchain 基建确认**（见 §4.1）。
  - 范围：放行条件 = 证据纪律（完整性规则，非数值门槛）；范围/平台自由度保留（无平台新承诺）。
  - 进度：证据完整性与未来 Gate 6 证据包排程联动；比 Option 1 略重（字段复核面）。
- **风险：** 若证据完整性规则在工具链未就绪时被误当作「已可执行」→ 证据不可审计却宣称可判（假可审计）；QA 须在其工具链验证字段可执行性后方可判（§4）；**回滚成本 = 低**（完整性规则未写入任何发布承诺，可随时收紧/放宽）；**验证成本 = 证据索引 + mandatory 字段逐行复核 + QA 独立复核（未来 Gate 6）**。
- **候选标注：** 本选项不提升任何数值；引用候选预算处一律「仅候选，须经 CR + 用户批准才成为正式门槛」。
- **子维度表：**

| 子维度 | 本选项内容 |
|---|---|
| 放行条件构成 | = Gate 2–6 通过 + 发布证据包完整性 |
| 证据容差 | = **默认零容差**（证据类不可互换、无静默容差/alias/coercion——Evidence schema §8）；显式容差仅在命名授权记录中列出 |
| Gate 6 判据 | = 证据包完整性 + QA 独立放行声明（含证据边界）；无数值判据要素 |
| QA 放行姿态 / 无豁免 | = 不变：Independent QA 出具放行声明（pass/fail/blocked/not_run）；Producer 无豁免；证据不完整 = `not_run`，不放行 |
| 发布证据包 | = 本卡定义包完整性要求（evidence_id / evidence_class / gate / criterion / build_identity / observer / verdict / retest 链 / unresolved_deviations / 索引链接） |

- **D2 升级判定（AUTH-01 §8.2.3）：** (a)：**否**；(b) 写入……Gate 判据：**是**（证据包完整性与零容差规则构成 Gate 6 判据内容）；(c)：否；(d)：否；(e) threshold/release crossing：**是**。→ **命中 (b)(e)**——整卡呈交用户亲自选择。

#### Option 3 — 「分层放行（Layered Release：门基座 + 条件性数值绑定）」

- **名称（一句话）：** 未来放行条件 = 两层：硬层 = Gate 2–6 通过 + QA 放行（无开放 P0/P1）；数值层 = **若未来经依赖卡（cr-109/cr-106/cr-114）+ CR + 用户批准将候选预算/红线升级为正式门槛，该门槛经决策记录自动计入放行条件；本卡只写绑定句、不提升任何数值**。
- **依据：** cr-113 行（依赖 cr-109/106/114——放行条件与阈值卡显式挂钩）；Charter §10 Gate 4 行（threshold unresolved until **named decision record** with owner/authority）；Evidence schema §8（明确的授权差异才允许容差/记录链接）；CR §1.3/§9 与 AUTH-01 硬边界第 4 条（候选预算仅候选）；Charter §2.3（threshold/release crossing → 用户/重授权）。均为已确认文档事实。
- **影响：**
  - 产品：未来放行面 = 门基座 + 已正式化的阈值子集；承诺粒度由依赖卡裁决（本卡只做绑定规则）。
  - 创意：数值约束仅在依赖卡批准生效后进入放行面——非本卡新增。
  - 技术：放行判定可能需要跨 Gate 4（performance）/ Gate 3（视觉/可访问性）数据聚合 → 若阈值被提升，聚合/引用成本出现。
  - 范围：放行规则完整但依赖链最长（引用 cr-109/106/114 决策记录）；范围自由度由依赖卡裁决。
  - 进度：Gate 6 判据引用依赖卡决策记录 → 需在全部依赖卡决策后方可定稿引用；排程依赖链最重。
- **风险：** 依赖未决（cr-109/106/114 均待用户选择）→ 数值层内容悬置，放行判据含「待定子句」；依赖卡若选择「不提升」，绑定句无引用对象（空绑定）；**回滚成本 = 低-中**（引用关系返工）；**验证成本 = 依赖卡决策记录 + Gate 4/3/6 证据 + QA 复核**。
- **候选标注：** 六项候选预算与 `1280×720` 红线全部标注「仅候选，须经 CR + 用户批准才成为正式门槛」；**本卡不提升其中任何一项**——提升动作属依赖卡（DC-PERF-01/DC-ACC-01/DC-ACC-02）决策范围。
- **子维度表：**

| 子维度 | 本选项内容 |
|---|---|
| 放行条件构成 | = 门基座（Gate 2–6 + QA 放行）⊕ 未来正式化阈值子集（经命名决策记录引用） |
| 证据容差 | = 沿用 Charter §10/Evidence schema §8 既有纪律（显式授权差异才允许容差） |
| Gate 6 判据 | = 引用既有门结构 + 依赖卡命名决策记录；绑定句由本卡写入，数值内容由依赖卡产出 |
| QA 放行姿态 / 无豁免 | = 不变：Independent QA 独立 verdict；Producer 无豁免；无证据不放行 |
| 发布证据包 | = 既有门证据 + 依赖卡决策记录引用；证据包必须携带全部激活阈值的 named decision record |

- **D2 升级判定（AUTH-01 §8.2.3）：** (a)：**否**（本卡不执行候选→正式门槛提升；提升仍由依赖卡 + CR + 用户批准）；(b) 写入……Gate 判据：**是**（绑定句写入 Gate 6 判据引用）；(c)：否；(d)：否；(e) threshold/release crossing：**是**。→ **命中 (b)(e)**——整卡呈交用户亲自选择。若用户选定本选项且未来依赖卡批准提升 → 绑定数值进入放行面时按 Charter §2.3 检查 `reauthorize_charter`。

#### Option 4 — 「放行姿态悬置（Posture-Only Defer）」

- **名称（一句话）：** 不定义任何未来发布阈值/条件/容差；本卡只登记**已确认**的 QA 放行姿态（未来放行 = Independent QA 独立 verdict + Producer 无豁免 + 无证据不放行），实质判据全部留待未来发布决策点（届时按已确认门结构与新 CR 确定）。
- **依据：** cr-113 行当前状态 `unresolved`（未决即悬置）；Charter §12 开放决策行（release 相关决策可由用户在决策窗口裁定；§2.3：未决不因沉默通过）；AUTH-01 硬边界第 2/4 条（QA 独立性不变；候选预算不自动提升）；P1 本期不发布（无近期发布点，悬置无空窗）。均为已确认文档事实。
- **影响：**
  - 产品：未来「可发布」当前仅姿态化（QA 独立门槛）；实质判据开放。
  - 创意：零约束（无本卡任何判据）。
  - 技术：零新增。
  - 范围：放行面 = 现有 Gate 结构；不提前承诺任何判据或数值。
  - 进度：最轻；Gate 6 判据内容留待未来。
- **风险：** 未来发布决策点出现时实质判据未定型 → 需在该点补 CR + 用户决策（决策平移成本）；cr-113 的「evidence tolerances / Gate 6 判据」子项在本卡零产出（与待决项原文字面覆盖最少）；**回滚成本 = 零**（无承诺写入）；**验证成本 = 未来 Gate 2–6 证据 + 未来发布决策点裁定**。
- **候选标注：** 本选项不提出任何数值；引用候选预算处标注「仅候选，须经 CR + 用户批准才成为正式门槛」。
- **子维度表：**

| 子维度 | 本选项内容 |
|---|---|
| 放行条件构成 | = 悬置（未来发布决策点裁定） |
| 证据容差 | = 悬置（未来裁定；当前沿用 Charter §10 既有纪律） |
| Gate 6 判据 | = 悬置（未来裁定；本卡不写任何判据内容） |
| QA 放行姿态 / 无豁免 | = **登记已确认姿态**：Independent QA 独立 verdict、Producer 无豁免、无证据不放行（AUTH-01 硬边界第 2 条——非本卡新创，仅重申） |
| 发布证据包 | = 悬置（未来裁定） |

- **D2 升级判定（AUTH-01 §8.2.3）：** 本选项自身**不命中 (a)-(e)**（不写判据、不写承诺、不提升数值、不改 promise/platform）。但 §8.2.3 明列 DC-REL-01 为升级卡，且「凡含 (a)-(e) 的选项即使同卡其余选项不升级，该卡也呈交用户」——**整卡仍呈交用户亲自选择**；用户选定本选项后，cr-113 在决策层面记为 `user_confirmed`（用户选择「推迟实质判据」），其细节仍保持 `unresolved`。

### 2.4 专业推荐（唯一）

**推荐 Option 2「证据完整放行（Evidence-Complete Release）」。**

- **一句理由：** cr-113 三个子维度中，「acceptance thresholds」的数值实质属于并仅属于依赖卡 cr-109/106/114（各有 CR + 用户批准机制，本卡重复立法只会制造双源）；「release gates」在 Charter §10 Gate 6 已有结构；真正未定且属于 QA/Release 职权的缺口正是「**evidence tolerances**」与 **Gate 6 发布证据包完整性**——Option 2 直接回答该缺口，与已确认的 QA 证据纪律（Charter §10 操作规则、Evidence schema §8/§9.4、AUTH-01 硬边界第 2 条）及波 1 卡推荐（DC-ACC-02 B3「证据收紧」）同构，是零 runtime 证据、本期不发布语境下唯一**可立即定稿且零虚假承诺**的放行判据。
- **异议（并列，不替用户消解）：**
  1. 若用户以「未来发布必须含明确数值承诺」为第一权重 → Option 3（分层绑定）更完整，但内容依赖 cr-109/106/114 决策，且与「候选预算不提升、测量后再定」的现行纪律存在张力（DC-PERF-01 推荐 Option A 同向）。
  2. 若用户以「全零产出」为第一权重 → Option 1/4 更轻，但把证据容差与发布证据包留作未定义——Gate 6 未来面对容差问题将无判定材料。
  3. 若未来合规（无障碍/商店）成为硬约束 → 届时按 §2.3 触发新 CR + 用户决策；本推荐不预锁该内容（未实测数值不得承诺）。
- **依赖（本推荐不冻结任何依赖方）：** cr-109 / cr-106 / cr-114（依赖卡决策，仍 `needs_user_decision`）；Toolchain 基建（证据管线/digest/索引——§4.1 确认清单）；Gate 2–6 未来证据（现 `not_run`）；父协调器装配与用户选择（D2 整卡呈交）。QA 独立性、Producer 无豁免、候选预算仅候选三项硬约束在本推荐下保持原样。

### 2.5 决策后记录规则 / 决策窗口 / 批准后 owner 与验收标准（CR §8 模板）

- **决策后记录规则：** 用户选择某选项 → 记为 `user_confirmed`（provenance = 用户决策），并更新 cr-113 状态与 Gate 6 判据引用（由对应 owner 在用户选择后执行）；其余选项保持 `unresolved`/`team_proposal`（不删除、不静默推广）；若选定项把判据/数值写入发布承诺、发布文案或 Gate 判据 → 按 Charter §2.3 / CR §6 Producer note 检查 `reauthorize_charter`。**本制备产物不更新任何文档。**
- **决策窗口与截止依赖：** Batch 2（CR §7）；在 Gate 6 与发布证据包规划前；依赖 cr-109/106/114 决策（Option 3 的引用定稿尤其依赖）；与 DC-PLAY-01 同批可并行制备。
- **批准后的新 owner：** Independent QA/Release（放行判据执行、独立观察、verdict/retest）+ Executive Producer/Lead Producer（Gate 6 证据装配与索引）+ Tech/Toolchain（证据管线基建，按选定选项激活）。
- **批准后的验收标准：** 未来 Gate 6 判据以所选选项内容执行为准：真实门证据（Gate 2–6）+ 命名决策记录（若选 Option 3）+ 证据包完整性（若选 Option 2）+ Independent QA 独立放行 verdict；Producer 无豁免；静态文档不能过门；无 runtime 证据 = `not_run`，不是 pass（Charter §10）。

---

## 3. B. DC-PLAY-01 门权威结构（Independent QA/Release 侧；衔接 Systems 判据部分，不代做判据）

> **定位：** 本结构是 `CARD_DC_PLAY_01_OPTIONS_v0_1.md §5.5` 指明的 QA/Release 交付物，与 Systems 卡 §5.1–§5.4 的判据构成（S1–S4 信号、观察方法、阻断/放行规则）配合；**本结构不定义判据内容、不替代 Systems 判据、不替代 QA 预检**。两部分的合并评审由父协调器装配为最终选项卡片交用户选择（§3.8）。

### 3.1 门裁决执行者（Gate Adjudication Executor）

- **唯一裁决执行者：Independent QA / Release。** 门最终 pass/block/retest 判定权归 Independent QA（Charter §10 操作规则：「every applicable gate's final pass/block owner is Independent QA/Release」「Producer has no waiver」；Charter §4 RACI：Independent QA owns blocking verdict；Evidence schema §1.1/§7：「Observer/verdict/block/retest authority — Independent QA / Release」「Implementers and Producer cannot self-certify or waive a QA blocker」）。
- 角色分工（不越权）：Systems/Rules = 判据语义 owner（S1–S4 含义、期望观察事实）；UX/Director = 观察输入/创意复核（非裁决）；Engineer（未来授权）= 证据生产者（构建/运行/trace 产出）；Tech/Toolchain = 证据载体与身份基建；Producer = 证据装配与索引（非证人、无豁免）；User = 最终产品权威（门内判定不外推产品裁决）。QA 可拒绝不完整或不可审计证据（godot-qa-release-expert：may reject incomplete or unsafe evidence）。

### 3.2 verdict / block / retest 授权

- **verdict 枚举：** `not_run` / `pass` / `fail` / `blocked` / `inconclusive` / `superseded`（Evidence schema §6 `verdict` 行；Evidence schema §9.4 状态语义：`not_run` ≠ pass；`missing_evidence`/`schema_incompatible` ≠ pass）。门内 verdict 由 Independent QA 出具，Producer 不得改写。
- **block（阻断权）：** 任一必选信号（S1–S4）无真实 runtime 观察证据，或证据缺 mandatory 字段，或观察未达（仅候选）阈值 → 门 `blocked` / `not_ready`，内容扩张候选不得进入下一阶段（正式门可阻止内容扩张——cr-202/Charter §12；Systems 卡 §5.3）。**阻断权激活时点**按用户对 Systems 卡 Option 1/2/3 的选择：Option 1 立即；Option 2 延后至校准报告 + 命名判据阈值 CR + 用户批准（Systems 卡 §5.3「激活语义」）；Option 3 不激活（信号 advisory，QA 按现有证据规则处理）。**QA 权威本身在三选项下不变**（QA 独立性是 AUTH-01 硬边界，不随正式/咨询/分阶改变）。
- **retest（重测授权）：** 仅由 Gate 2 起**新的 runtime 证据**触发；retest 创建新 `evidence_id`，携带 `retest_of`，保留原失败证据（Evidence schema §4.2/§8：append-only，retest 不删除/改写原记录）；重测范围 = 受影响判据 + 必要回归（Charter §10）；重测 verdict 仍由 Independent QA 独立出具。
- **授权边界（不越权）：** QA 判定 S1–S4 是否**有可观察证据支撑**，不重写 Systems 判据使其通过（godot-qa-release-expert：Ask Systems to clarify ambiguous acceptance intent; do not rewrite the rules to make a test pass）；QA 不修复实现（问 Engineer 修，不自己修）。

### 3.3 独立观察协议（Independent Observation Protocol）

- **观察者身份：** 观察与判定由 Independent QA 执行，独立于实现者（Engineer 产证、QA 观察判证；AUTH-01 硬边界第 2 条：QA 独立观察、独立 verdict、无豁免）。实现者不得代录 QA 观察记录；QA 不得验收自产实现（Charter §10：implementers cannot self-certify）。
- **观察载体（未来授权后）：** 结构化 runtime 航行——预置 fixture（Systems §5.3 fixture 字段 + §11 QA handoff）+ seed/tick 固定（PRECHARTER-01）+ 记录输入序列（Evidence schema §6 `input_sequence_ref`）+ trace/snapshot 引用；按需使用 godot-native-e2e（GDMCP 观察的场景/输入/玩家流）与 godot-native-visual-qa（命名帧观测）作为证据载体（未来授权时）。
- **观察记录字段（强制）：** `observer`（身份/角色/时点）、`build_identity`/`build_mode`、`fixture_id`、`run_id`/`seed`、`tick_context`、`clock_authority`（时间类证据）、`frame_refs`/`log_refs`/`trace_ref`、`unresolved_deviations`、`verdict`、`retest` 链（Evidence schema §6）。缺失任一项按 §3.4 处理。
- **独立观察不得由静态文档自证：** 观察记录必须指向真实 runtime 产物（trace/snapshot/帧引用），不得以设计文档/卡文本/Anchor 充当观察记录。

### 3.4 证据审计要求（Evidence Audit Requirements）

- **门判定的证据包最小构成：** `evidence_id`（唯一审计键）+ `evidence_class` = `runtime`（S1–S4 判据只接受 runtime 证据类）+ `gate`（定位门面）+ `criterion`（S1–S4 之一，带源链接）+ `fixture_id`/`scenario_id` + `run_id`/`seed` + `build_identity` + `observer` + `verdict` + `unresolved_deviations` + `retest_of`/`supersedes`（如适用）+ Producer 索引链接（Evidence schema §6/§9.2）。
- **缺失规则：** 缺失任何 mandatory 字段 = **`not_run`**，不是 pass（Charter §10；CR §9）；无法验证的 artifact 位置 = 不可审计（Evidence schema §9.2：「Missing ID, missing index linkage, or unverifiable artifact location means the record is not auditable」）。
- **证据类不可互换：** static/source 与 synthetic/anchor 不可替代 runtime / visual QA（Charter §10；Systems 卡 §5.2 ④）；截图不能单独证明因果（须 trace/输入序列）；trace 不能建立可读性（须 visual QA/runtime 观察）——证据类各自证明不同的事（godot-qa-release-expert：proof types are distinct）。
- **审计执行：** QA 在门判定前核验证据包身份链接（版本精确匹配、无静默容差/alias/coercion——Evidence schema §4.1/§8）；比对 expected（Systems 语义）与 actual（Tech 序列化）分离进行，不混层。

### 3.5 观察者 / 证人边界（Observer/Witness Boundary，含运行环境身份）

- **证人角色表：**

| 角色 | 在门内身份 | 权限边界 |
|---|---|---|
| Independent QA/Release | **唯一裁决证人**（verdict/block/retest） | 独立观察、核对证据、出具 verdict；不得自产证据 |
| Engineer（未来授权） | **证据生产者** | 构建/运行/产出 trace；不得自证、不得代录 QA 观察 |
| Tech/Toolchain | 证据载体/身份提供方 | 提供 build identity/digest/采样身份；不裁决 |
| Systems | 判据语义 owner | 定义 S1–S4 期望事实；不替代 QA 裁决 |
| UX/Director | 观察输入/创意复核 | 提供框架/审美输入；无门内 verdict 权 |
| Producer | 证据装配与索引 | 装配证据包、维护索引；**无豁免权、无 verdict 权** |
| User | 最终产品权威 | 门内判定不外推产品决策；产品级裁决归用户 |

- **独立性边界：** QA 不得验收自产实现；实现者不得自证（Charter §10）；AUTH-01 自动采纳**不减少任何 QA/证据门**（硬边界第 2 条）——本门结构在 D1 自动采纳流程下同样完整生效。
- **运行环境边界（OS/硬件身份）：** 可玩性观察须记录运行环境身份（platform/os/hardware/settings——Evidence schema §6 条件字段；Gate 2–6 语义现状下无任何观测）；同一观察记录不得跨硬件/配置静默复用；`clock_authority` 缺失时时间类证据视为不完整（Evidence schema §6）。

### 3.6 静态文档不能通过门；无 runtime 证据 → `not_run`（明确声明）

- S1–S4 判据仅以**真实 runtime 观察**为可过门证据（revision-02 #6；Charter §6「Playability evidence gate candidate」；Systems 卡 §5.3）。静态 prose、设计文档、Systems/QA 卡文本、Anchor 均不能通过门（Charter §6/§10；Systems 卡 §5.4）。
- 无 runtime 证据 → 门保持 **`not_run / not_ready`**，**永不「静态通过」**（Evidence schema §9.4 `no-runtime-evidence` 状态：静态记录存在 ≠ runtime pass）。
- 首次门判定前必须齐备强制 preflight/start 证据：授权版本、模式、milestone、owner/dependency、build/config 身份、fixture/seed、observer、停止条件（Charter §10「Mandatory preflight/start evidence」）——缺失则 `not_run`。

### 3.7 与 Systems 判据部分的关系（不代做判据）

- Systems 卡交付：判据构成（S1–S4 信号与观察内容、观察方法、阻断/放行规则、阈值声明）——§5.1–§5.4。
- 本结构交付：门裁决执行、独立观察、verdict/block/retest 授权、证据审计、OS/证人边界——§3.1–§3.6。
- 手递手约束：本结构引用 S1–S4 仅作判据挂接标识（criterion 字段），不解释、不扩充其语义；判据语义归 Systems。门位置/激活条款以 Systems 卡选项 + 用户选择落定为准（§3.2 block 激活时点）。

### 3.8 合并评审方式（父协调器装配）

- 父协调器把 Systems 判据部分（Systems 卡）与本门权威结构（本文件 §3）装配为 **DC-PLAY-01 最终选项卡片**交用户选择（D2 升级类，整卡呈交；Systems 卡 §5.5：「两部分的合并评审由父协调器装配」）。
- 装配校验点（父协调器/汇卡时核）：① 判据与门权威的引用一致性（S1–S4 标识可挂接）；② 选项挂接说明完整（Option 1/2/3 与 §3.2 block 激活时点对应）；③ 不变量与边界声明在两张卡间无冲突；④ QA 独立性声明在两卡一致。
- 用户选择后：门判据/门权威按选定选项生效，owner 与验收标准按 Systems 卡 §6 与本文件 §2.5 对应字段执行。

---

## 4. C. 波 1 卡片 QA 审计输入（简短；不替用户选择、不改判任何卡片推荐）

> 立场声明：以下为 Independent QA 的**可执行性审计输入**——回答「证据字段是否可在 QA 工具链上执行 / 哪些需 Toolchain 基建确认 / QA 独立 verdict 需求」。**不替用户选择 DC-PERF-01 / DC-ACC-01 / DC-ACC-02 选项；不改判各卡专业推荐（DC-PERF-01 → Option A；DC-ACC-01 → A2；DC-ACC-02 → B3）。**

### 4.1 通用：Gate 3/4 证据的 QA 工具链可执行性缺口（需 Toolchain 基建确认）

| 基建项 | 影响 Gate | QA 现状 | 状态 |
|---|---|---|---|
| build identity / artifact digest 生成与归档（cr-112 激活后） | Gate 3/4/6 | QA 可核验身份字段，但身份生成在 Toolchain 侧 | **需 Toolchain 确认**（Evidence schema §4.1/§6） |
| 命名帧/多帧捕获管线（frame_refs + settings 身份 + 时间戳） | Gate 3 | QA 可消费帧引用；捕获管线的分辨率/窗口/裁剪身份必须记录，否则 16:9/16:10/21:9 帧不可比 | **需 Toolchain 确认** |
| raw sample 采集 + percentile/时钟权威实现（cr-108 协议落地） | Gate 4 | QA 可审计「采样窗口/percentile/时钟权威记录」的存在性；采样工具在 Tech/Toolchain 侧 | **需 Toolchain 确认**（ADR-TECH-07 协议定稿前置） |
| 像素级测量（对比度/字号/焦点目标尺寸/遮挡重叠） | Gate 3 | 现无现成手段；B2/A3/A4 类量化方案依赖 | **需 Toolchain 确认**（CARDS_DC_ACC_01_DC_ACC_02 §4.5 依赖 2 同向） |
| 证据索引/归档映射（Evidence schema §9） | Gate 6（含 DC-REL-01 Option 2/3） | 索引为 Producer 职责；映射基建在 Toolchain/Producer 侧 | **需确认**（未来索引契约） |

**审计结论（通用）：** 任何依赖上述基建的证据字段在基建确认前不可判定 → 相关 Gate 保持 `not_run / not_ready`；QA 不会在工具面未就绪时宣称可判（「unavailable tooling ≠ passing check」——godot-qa-release-expert Evidence contract）。

### 4.2 DC-PERF-01（cr-109；Gate 4 测量）

- **证据字段可执行性：** QA 可在其工具链**直接执行** = raw samples 的身份完备性审计（build identity、命名硬件/OS/settings、时钟权威、percentile 定义、采样窗口）——即审计「测量是否可审计、数值含义是否可复现」（cr-107/108 协议落地后）。QA **不替代执行测量本身**（测量执行者 = Tech，Gate 4 表 Executor；QA = final pass/block observer，Charter §10）。
- **需 Toolchain 确认：** 采样脚本与 raw sample 归档、percentile/时钟权威实现、build identity/digest（§4.1 行 1/3）。
- **QA 独立 verdict 需求：** 每个性能判据行 = 命名硬件 + raw samples + percentile + **QA 独立复核 verdict**（Gate 4 行；ADR-TECH-07 停止条件：缺任何 identity/raw sample 即停）。**候选数值未提升前不构成 blocker 依据**（仅记录测量值；提升须 DC-PERF-01 决策 + CR + 用户批准——若用户选 B/C/D，Gate 4 判据必须引用命名决策记录且 QA 观察不豁免）。
- **与 DC-REL-01 衔接：** Gate 4 性能证据是未来 Gate 6 发布证据包的输入之一（证据类 `performance`；若用户选 DC-REL-01 Option 3，达标的正式化门槛经决策记录计入放行面）。

### 4.3 DC-ACC-01（cr-106；UX-13 行）

- **证据字段可执行性：** UX-13 行（`target settings` / `state coverage` / 命名帧 / checklist / **independent verdict**）——QA 可直接执行 = 命名帧捕获（基建确认后）+ checklist 逐项核对 + 独立 verdict + retest 链接（CARDS_DC_ACC_01 §3 各选项 QA 观察要求行）。数值类（对比度/字号/焦点目标尺寸）需像素级测量（§4.1 行 4）。
- **需 Toolchain 确认：** 像素级测量手段、fit 缩放下候选尺寸的实际屏幕像素可达性（720p 候选红线处——DC-ACC-01 §3.5 依赖 2「需 Tech 确认」同源）、reduced-motion 若未来承诺的设置面评估。
- **QA 独立 verdict 需求：** 无论用户选 A1–A4 中任何一项：verdict 由 Independent QA 出具、observers 身份记录、retest 保留原失败（Charter §10）；**候选数值未经 CR + 用户批准不得作为 blocker 依据**（A2 自约束与 §3.5 推荐一致）；若选 A3/A4，QA 须在像素测量工具面确认后才能执行数值判据（否则 `not_run`）。
- **不改判声明：** UX 推荐 A2——审计确认：A2 在 QA 工具链上可执行性高（候选数值仅作证据字段命名、verdict 定性），与 QA 独立性无冲突。

### 4.4 DC-ACC-02（cr-114；Gate 3 / UX-09..13）

- **证据字段可执行性：** B1/B3（定性红线 + 证据完整性）→ QA 工具链**可直接执行**（命名帧 + checklist + verdict + 完整性复核——即既有 QA 证据能力）；B2/B4（量化红线）→ 像素级遮挡检测/剪影判定需工具链确认（§4.1 行 4；CARDS_DC_ACC_02 §4.5 依赖 2 同源）。
- **需 Toolchain 确认：** 帧/多帧序列捕获（对应 B2「连续遮挡帧数」类字段）、遮挡像素测量（玩家剪影 vs HUD/特效重叠）、支持集 {16:9,16:10,21:9} 命名帧矩阵、build identity/evidence index 链接（§4.1 行 1/2/4）。
- **QA 独立 verdict 需求：** Gate 3 blocker = **obscured player/danger/space or focus failure**（Charter §10 Gate 3 行）——定性红线 QA 可独立判定；量化值（B2/B4 候选值）未获用户批准前**不得作为 blocker 依据**（仅记录测量值——CARDS_DC_ACC_02 §4 各选项 QA 观察要求自声明）；QA 确认候选数值仅作证据字段命名而非判据（回应 DC-ACC-01 §3.5 依赖 3）。
- **与 DC-PLAY-01 衔接：** S3（B2 不遮蔽玩家/危险/波/空间）与 Gate 3 occlusion 红线同源——QA 观察协议与帧矩阵可共享（S3 判据语义归 Systems；遮挡红线判据归 Gate 3，两者证据载体可复用，判据不混合）。

---

## 5. 分层声明与不变量保留

- **`user_confirmed`（本文件引用，未新增）：** 22 项原始决策（Charter §6）；revision-02 #6（可玩性门候选方向）/ #7（性能候选预算）/ #8（平台候选方向）；PRECHARTER-01..11；Batch 1 决策（DC-PLAT-01→P1；DC-ARCH-01→A1；DC-PLAT-02→Option 2，§8.1 R01–R03）；AUTH-01（P1–P3、D1–D3、硬边界四项，§8.2）；cr-113 / cr-202 `needs_user_decision`；Gate 语义现状（Gate 0/1 `ready_for_next_review` 静态复审、Gate 2–6 `not_run / not_ready`、无 runtime 证据）；QA/Release 门权威（Charter §10、Evidence schema §1.1/§7）。
- **`team_proposal`（本文件产出物级别）：** DC-REL-01 全部选项（§2.3）、专业推荐（§2.4）、DC-PLAY-01 门权威结构（§3）、波 1 QA 审计输入（§4）。不因本文件而升为任何产品/流程决策。
- **`assumption` / `unresolved`：** 未新增假设；发布判据构成、证据容差、Gate 6 判据、可玩性门正式化与否、判据数值与观察证据均保持 `unresolved` 或仅候选，**全量保留**（不变量）。
- **不变量保留声明：** 22 项原始 user_confirmed 未改写、未重分类；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（8+1，无第九项）；PRECHARTER-01..11 全部保留；四层 provenance 全程区分；unresolved 全量保留；六项候选预算与 `1280×720` 红线保持仅候选（未被本文件提升）；**QA 独立性硬边界未变**（非豁免、不减少任何 QA/证据门）。本文件为**新增唯一产物**，未修改任何其它文档（含 Systems 卡、波 1 卡、CR 台账、Charter、Tech/UX 合同、ADR、证据 index）。

---

## 6. 边界声明与 closure

- 本文件未替用户选择 DC-REL-01 任何选项（D2 整卡呈交用户）；未替用户决定 DC-PLAY-01 是否正式化；未批准或冻结任何合同/ADR/Gate 判据；未豁免 QA blocker；未替 Independent QA 下任何 verdict；未替用户选择波 1 卡选项或改判其推荐；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布；**未执行任何 QA 观测或验收**（Gate 2–6 无证据可观测）；未读取授权清单之外的任何文件；未调用 subagent / subagent_fork / workflow 或任何嵌套派发。
- **Evidence inspected（static/source only）：** `DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（全 439 行）；`CHANGE_REQUESTS_v0_1.md`（全 345 行）；`CARD_DC_PLAY_01_OPTIONS_v0_1.md`（全 160 行）；`CARDS_DC_PERF_01_OPTIONS_v0_1.md`（全 315 行）；`CARDS_DC_ACC_01_DC_ACC_02_OPTIONS_v0_1.md`（全 308 行）；`KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md`（全 248 行）。
- **Closure:** `closure_ready = yes` **仅对本静态选项制备产物**；非 kickoff pass、非实现授权、非合同批准、非验收 verdict、非发布决策。Kickoff 仍 `not_ready`；implementation 仍 `NOT_AUTHORIZED`；Gate 0/1 `ready_for_next_review`（仅静态复审）；Gate 2–6 仍 `not_run / not_ready`；cr-113 与 cr-202 仍在等待用户决策。