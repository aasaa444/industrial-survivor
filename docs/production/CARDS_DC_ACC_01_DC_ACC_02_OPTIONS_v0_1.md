# CARDS DC-ACC-01 + DC-ACC-02 — OPTIONS PACKAGE v0.1（选项制备产物，非决策）

> **状态：** `PROPOSAL / OPTION PREPARATION / NOT A USER DECISION / NOT APPROVED`
>
> **生命周期：** `development governance / kickoff readiness preparation`
>
> **制备角色（本文件唯一 owner）：** UX/UI Designer（`godot-ux-ui-expert`）
>
> **本文件是什么：** 按 `CHANGE_REQUESTS_v0_1.md §8` 固定卡片结构，为 **DC-ACC-01（cr-106 可访问性阈值）** 与 **DC-ACC-02（cr-114 视觉/可用性验收标准）** 各制备 2–4 个精准、互斥的整体选项（含子维度），提交父协调器汇成两张选项卡片交用户选择。
>
> **本文件不是什么：** 不是用户最终决策；不替用户选择可访问性/验收数值；不批准/冻结任何 Tech/Systems/UX 合同或 ADR；不豁免 QA blocker；不替 Independent QA 下 verdict；不把任何 `team_proposal`/`assumption`/`unresolved` 升级为 `user_confirmed`。
>
> **升级类判定（AUTH-01 §D2）：** 本文件两张卡均为升级类——DC-ACC-02（cr-114，Gate 判据）在 §8.2.3 明确列名，命中 (b) 类，整卡呈交用户；DC-ACC-01（cr-106）按本任务授权级别（D2 升级类卡片，由用户亲自选择）整卡呈交用户，各选项逐条标注 (a)-(e) 命中情况。
>
> **证据类别：** `static/source` only。未访问 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布；未调用 subagent / subagent_fork / workflow 或任何嵌套派发。

---

## 0. 不变量与来源边界

- 不变量保留声明（与 Charter §1、CR ledger §9 一致）：
  - **22 项**原始 `user_confirmed` 决策：保持候选约束原状；
  - **恰好 8 项** canonical `v0.1-revision-02` 输入 + **独立**的当前 Charter authorization record（**无第九项**）；
  - **PRECHARTER-01..11**：全部保留，unresolved 字段未动；
  - **四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）全程区分，无静默提升；
  - **全部 unresolved 保留 unresolved**：cr-106 / cr-114 及本卡全部子维度数值在用户选择前一律 open；本制备不提升任何候选数值。
- 实际读取来源（仅 static/source）：Charter v0.1（决策 #18/#19、PRECHARTER-06/09、§10 Gate 3 行、§12 开放决策行）；UX 合同 v0.1（§7、§9 UX-09..13、§12）；CR ledger v0.1（§3–§8.2：cr-106/cr-114、§8 卡片结构、§8.1 R01–R03、§8.2 AUTH-01）；`ANCHOR_DECISION.md`（Anchor v0.1 用户接受静态基线、v0.2 未接受候选）；`CARD_DC_PLAT_02_OPTIONS_v0_1.md`（Option 2 Balanced 上下文，Batch 1 已决策引用）。
- 本卡内所有数值均为**候选提议**，凡涉及处必标注：
  > 「仅候选，须经 CR + 用户批准才成为正式门槛。」

---

## 1. 待决项（linked cr_ids + 来源原始表述 + 当前状态）

### 1.1 DC-ACC-01 — 可访问性阈值（cr-106）

| 字段 | 记录 |
|---|---|
| Card ID | `DC-ACC-01`（Batch 2，§7 决策批次行；制备角色 = UX/UI） |
| 待决项 | **cr-106（可访问性阈值）**：「contrast, min text/focus-target size, flash frequency, motion duration, reduced-motion unresolved (UX §7; PRECHARTER-06/09; Charter 决策 #19)」 |
| 当前状态 | `unresolved` / `needs_user_decision`（Producer disposition；决策包 DC-ACC-01，UX/UI 制备） |
| 受影响的 user_confirmed 边界 | Charter 决策 **#19**（基本可访问性基线：**非颜色通信、聚焦可见、节制闪动**——方向已确认，数值未决）；PRECHARTER-06（持久 HUD = 生死/计时/B2、最小化 XP；布局/copy/最小分辨率/安全区 unresolved）；PRECHARTER-09（失焦冻结/保留选中/新鲜输入/拒陈旧——机制属 Tech）；UX §7「Reserved thresholds …… remain `unresolved` and user-reserved where they become product or release commitments」 |
| 依赖 | **DC-ACC-02（cr-114）**：Gate 3 判据与证据接受阈值依赖本卡（UX-13 行）；**DC-PLAT-02**（Batch 1 已决策 Option 2：{16:9,16:10,21:9}、fit + UI 缩放、禁 stretch/禁 crop、`1280×720` 红线仅候选——阈值数值的可达性与验证点以该集为前提）；**DC-PLAT-01**（P1：Windows x86_64，本期不发布——发布承诺类选项的语义为「未来放行姿态」，不创建本期发布承诺） |
| 子维度（本卡覆盖） | 对比度（contrast）、最小字号（min text size）、焦点目标最小尺寸（min focus/target size）、闪动频率（flash frequency）、动效时长（motion duration）、减少动效（reduced-motion policy） |

### 1.2 DC-ACC-02 — 视觉/可用性验收标准（cr-114）

| 字段 | 记录 |
|---|---|
| Card ID | `DC-ACC-02`（Batch 2，§7 决策批次行；制备角色 = UX/UI + Game Director 与 QA 输入） |
| 待决项 | **cr-114（视觉/可用性验收标准）**：「visual/usability acceptance criteria, occlusion/readability red line, evidence acceptance thresholds unresolved (UX §12 open decisions; Charter §12)」 |
| 当前状态 | `unresolved` / `needs_user_decision`；§8.2.3 D2 明确列名（Gate 判据类） |
| 受影响的 user_confirmed 边界 | Charter 决策 **#18**（16:9 基线 + 可读红线方向）；**#19**（基本可访问性基线）；Charter §10 Gate 3 行（`visual QA` + `runtime`；blocker = **obscured player/danger/space or focus failure**；`not_run`）；UX §3 跨状态规则、§6.2 空间层级（player → danger → wave flow → clear/movable space → HUD）；UX-09..13 证据矩阵行；Anchor v0.1 用户接受静态基线 |
| 依赖 | **cr-104/105**（已决策引用 R03：支持集 {16:9,16:10,21:9}、fit + UI 缩放、禁 stretch/禁 crop、`1280×720` 红线仅候选——UX-09/UX-12 命名 aspect/resolution 以此为准）；**cr-106（DC-ACC-01，本文件 §3）**：UX-13 行与 Gate 3 可访问性子集的判定/证据阈值随 ACC-01 所选类联动；**cr-113（DC-REL-01，QA/Release 制备，不在本任务读取）**：若本卡选项含未来放行绑定 → 与 Gate 6 判据衔接 |
| 子维度（本卡覆盖） | Gate 3 判据内容（criteria content）、遮挡红线（occlusion/readability red line）、证据接受阈值（evidence acceptance thresholds）、与 UX-09..13 矩阵的绑定 |

---

## 2. 共同前提（两张卡所有选项适用；不因选项不同而改变）

1. **决策 #19 是已确认方向，不是数值**：非颜色通信 / 聚焦可见 / 节制闪动为用户确认基线；本卡所有数值均为候选，用户未选择前一律 `unresolved`。
2. **Batch 1 决策引用（R01–R03，2026-08-16，`user_confirmed`）**：DC-PLAT-01 → P1（Windows x86_64 单一 target；本期**不发布**，Gate 6 按内部复审姿态）；DC-ARCH-01 → A1（seam 保持候选 + ADR 定稿路径）；DC-PLAT-02 → Option 2 Balanced（支持集 {16:9,16:10,21:9} 为**方向性支持承诺候选**；`1280×720` 红线**仅候选**；fit + letterbox 空隙 + UI 相对缩放保护安全区；**禁 stretch / 禁 crop**）。
3. **候选预算标注规则（全场强制）**：本卡任何对比度/字号/尺寸/频率/时长/遮挡/证据阈值数值，以及任何「提升为 Gate 判据 / 发布承诺」的动作，均为**候选提议**，必须标注「仅候选，须经 CR + 用户批准才成为正式门槛」；六项性能候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与本卡互不授信。
4. **Anchor v0.1 = 用户接受的静态/合成视觉基线**；v0.2 = 未接受候选（DC-ANCH-01 不在本任务）。任何选项不得把 v0.2 或静态图像当作运行时/视觉验收替代（UX §10；ANCHOR_DECISION §2/§5）。
5. **QA 与证据纪律**：Independent QA 独立观察、独立 verdict、无豁免；`static/source` 与 `synthetic/anchor` 不可替代 `runtime`/`visual QA`（Charter §10；UX §9 evidence boundary）；retest 保留原失败、新增证据 ID（Charter §10）；缺失 mandatory evidence 字段 = `not_run`，不是 pass。
6. **技术可行性条目**标注「需 Tech 确认」的，本卡不自行背书；由 Tech Lead 在汇卡/批准前给出可行性或实现成本输入。
7. **发布承诺语义（P1 语境）**：本期不发布 → 任何「发布承诺 / 放行条件」类选项表述为**未来放行姿态**，不创建本期发布承诺；一旦写入发布承诺/发布文案/Gate 判据，仍须 CR + 用户批准（并可能触发 `reauthorize_charter`，Charter §2.3）。
8. **本制备不更新任何既有文档**：UX/Tech/Systems 合同与 ADR 保持 `PROPOSAL / DRAFT / NOT APPROVED`；用户选择后的 status 更新由对应 owner 另行执行。

---

## 3. 决策卡 1 — DC-ACC-01（cr-106）

> **互斥性说明：** 四个选项沿「数值权威层级」主轴互斥——对六个子维度数值（对比度/字号/焦点目标尺寸/闪动频率/动效时长/减少动效），分别赋予：**无数值（A1）/ 内部设计参照（A2）/ Gate 3 正式判据（A3）/ 未来发布放行条件（A4）**。用户选择其一即为整体决策；未选项保持 `unresolved`/`team_proposal`。

---

### Option A1 — 「方向保持（Defer）：零数值，纯定性观察」

**名称（一句话）：** 不设任何数值阈值：仅把决策 #19 已确认方向（非颜色通信/聚焦可见/节制闪动）与 PRECHARTER-09 失焦安全表述为 Gate 3 定性观察判据；六个子维度全部维持 `unresolved`，待真实 UI 存在并实测后再经 CR + 用户批准提议。

- **依据**
  - cr-106 原文（UX §7 Reserved thresholds；PRECHARTER-06/09；决策 #19）——方向确认、数值 user-reserved。
  - PRECHARTER-04：用 range + 实验起点，**不锁定未验证常量**——无 UI 前定死数值违反该边界。
  - Charter §10 Gate 3 行当前即定性 blocker（obscured player/danger/space or focus failure）；Gate 3 `not_run`，无帧可测。
  - P1 本期不发布（R01）→ cr-106 风险行「无障碍失败阻塞发布」在发布点前未激活。
- **影响**
  - 产品：零新增承诺；玩家面向可获得的基本保障 = #19 方向三条款（已确认）。
  - 创意：动效/闪动只受定性约束，反馈重量感（pillar 4）不被数值收窄。
  - 技术：零新增实现；失焦/冻结/缓冲机制本就属 Tech（PRECHARTER-09），无新依赖。
  - 范围：UX-13 以定性清单先行；无数值化验收面；无新增设置面（reduced-motion 开关推迟——不触碰「完整菜单」OOS 红线）。
  - 进度：最轻；无逐值返工；Gate 3 前的实测提议留作第二决策点。
- **风险**：无量化词汇 → 设计/QA 判定依赖观察者一致性，Gate 3 主观性风险（cr-114 风险行「无红线则视觉 QA 无法判定」的对立面）；**回滚成本** = 零（无承诺）；**验证成本** = 定性清单 + 命名帧 + QA 独立 verdict（复用 UX-13 现有字段结构）。
- **候选标注**：本选项不提出任何数值；未来实测提议的任何数值仍须 CR + 用户批准才成为正式门槛。
- **UX-13 覆盖说明**：`target settings` = 无数值（方向条款）；`state coverage` = 焦点/文本/卡牌/非颜色状态/动效节制全状态定性检查；evidence = 命名帧 + checklist + **independent verdict**；verdict 判据 = 定性（无 pass/fail 数值线）。
- **升级判定（AUTH-01 §D2）**：**不命中 (a)-(e)**（无候选→门槛提升、无 Gate 数值判据、无发布/渠道/platform 变更、无 threshold/release crossing——Gate 3 的定性判据只复述已确认的 #19/PRECHARTER-09 边界）。按本任务授权级别（DC-ACC-01 为 D2 升级类卡片），**本卡仍整卡呈交用户亲自选择**；是否按 §8.2.3 字面转入 D1 自动采纳路径由父协调器/用户裁定，本制备不代决。

---

### Option A2 — 「轻量候选规范（Internal Candidate Standard）」★ 专业推荐

**名称（一句话）：** 以「内部设计规范（非门槛）」记录一组候选数值范围（对比度/字号/焦点目标尺寸/闪动频率/动效时长/减少动效），仅作 UX 构图、布局与 UX-13 证据字段命名依据；**不写入 Gate 判据、不构成发布承诺、不冻结合同**；全部数值标注「仅候选」。

- **依据**
  - 决策 #19（方向）+ UX §7（阈值 user-reserved 直到成为承诺）+ UX-13（evidence fields 需要 `target settings` 命名，否则证据行无可填字段）。
  - PRECHARTER-04（range + starting point 而不锁定）——候选参照正是「range」形态。
  - 与 cr-106 行「阈值若成发布承诺 → 用户（即本卡）」一致：本选项**不**把数值写入任何承诺/判据。
- **影响**
  - 产品：零承诺；数值仅内部参照，玩家面向保障仍 = #19 方向。
  - 创意：给动效/闪动上限提供形态边界（构图词汇），仍保重量感；上限值未经实测，随时可改。
  - 技术：无新增实现；仅「720p 候选红线处字号/焦点尺寸在 fit 缩放下的实际像素可达性」需 Tech 确认（Option 2 缩放机制依赖）。
  - 范围：UX-13 `target settings` 可命名；无新增验收面、无新增设置面。
  - 进度：轻；数值表随实测修订（不触发合同重批）。
- **风险**：内部规范被误读为门槛 → 每处强制「仅候选」标注并禁止进入 Gate 判据（本选项自约束）；**回滚成本** = 低（数值表替换即回滚）；**验证成本** = 定性清单（候选数值仅参照，不作 pass/fail）。
- **候选标注**：
  > 下表全部数值均为**仅候选**（示例范围，非门槛）：对比度 ≥ 4.5:1（正文级别文本，WCAG AA 参考）或 ≥ 3:1（大字号/粗体）；关键文本字号（卡牌关键词标题）≥ 20px @ 1080p 基线（720p 候选红线处按 fit 缩放折算，数值待实测）；焦点/悬停高亮目标区 ≥ 44×44px 交互区（1080p 基线；方向焦点环 ≥ 2px 可见 + 非颜色指示）；闪动 ≤ 3 次/秒（WCAG 2.3.1 参考）；单次命中/击杀反馈 ≤ 300ms、B2 清屏后辉光衰减 ≤ 800ms；reduced-motion = 候选开关（默认关闭或可选，其设置面属范围事项需 CR）。**以上均须经 CR + 用户批准才成为正式门槛。**
- **UX-13 覆盖说明**：`target settings` = 候选数值表（仅参照，标注候选）；`state coverage` 全量；evidence = 命名帧 + checklist + **independent verdict**；verdict 判据**保持定性**（引用候选数值只作构图一致性参照）。
- **升级判定（AUTH-01 §D2）**：**不命中 (a)-(e)**（数值提升动作被本选项自禁止——无候选→正式门槛、无 Gate/发布写入、无平台/渠道/threshold crossing）。按本任务授权级别，**本卡仍整卡呈交用户亲自选择**；D1/D2 边缘裁定同上（A1 注）。

---

### Option A3 — 「Gate 3 正式判据（Gate Criteria）」

**名称（一句话）：** 把选定数值子集（候选提议）提升为 **Gate 3 视觉/UI 正式判据**（Independent QA pass/block）：子集 = 文本对比度、最小字号（@候选红线）、焦点目标最小尺寸；闪动频率/动效时长/减少动效采用「定性判据 + 候选数值」双轨；**不构成发布承诺**（P1 语境）。

- **依据**
  - cr-106（「阈值若成……门槛 → 用户（即本卡）」——本选项正是把该升级动作作为提议呈交）与 cr-114（UX-13 行及 Gate 3 判据依赖）。
  - Charter §10 Gate 3 行已列定性 blocker（obscured player/danger/space or focus failure）——本选项为其补数值化可判依据。
  - UX-13 行（`visual QA` + `QA`，`target settings / checklist / independent verdict`）——数值判据使 verdict 可量化。
- **影响**
  - 产品：Gate 内承诺面中型——玩家获得可验证的基本可读性/可达性保证（对比度/字号/焦点尺寸三锚点）。
  - 创意：渲染/动效受数值约束；重量感 vs 上限的平衡需 Director 复核（跨角色输入，见 §3.5 异议 1）。
  - 技术：需在 fit 缩放下验证候选尺寸的实际屏幕像素（Option 2 机制，**需 Tech 确认**）；像素级字号/焦点测量手段（**需 Tech 确认**）。
  - 范围：UX-13 升级为数值验收行 + QA 量化检查；无新增设置面（reduced-motion 仍定性）。若后续承诺 reduced-motion 开关 → 触碰「完整菜单」OOS → 需 CR。
  - 进度：中等；Gate 3 判据随所选数值定稿即用；数值返工成本随实测（Charter §10 retest 规则）。
- **风险**：**未实测数值即入判据** → 首查即重测/返工风险最高（与 PRECHARTER-04 张力最大）；**回滚成本** = Gate 判据退回定性（低-中）；**验证成本** = 每帧像素级数值检查 + 命名帧 + QA verdict。
- **候选标注**：
  > 本选项的「提升动作」本身是候选提议——对比度/字号/焦点尺寸数值仍为**仅候选**，须经 CR + 用户批准（本卡）才成为正式门槛；成为 Gate 判据 ≠ 成为发布承诺。
- **UX-13 覆盖说明**：`target settings` = 数值判据（三锚点）；`state coverage` 全量；evidence = 数值检查 + 定性检查 + **independent verdict**；retest 字段按数值维度逐项（保留原失败，Charter §10）。
- **升级判定（AUTH-01 §D2）**：**命中 (a)**（候选 → 正式门槛的数值提升）+ **命中 (b)**（写入 Gate 3 判据）→ **整卡呈交用户亲自选择**。

---

### Option A4 — 「发布绑定（Release-Binding）：未来放行姿态」

**名称（一句话）：** 在 A3 基础上把同一数值子集同时表述为**未来发布承诺/放行条件**（衔接 cr-113 / DC-REL-01 与 Gate 6）；本期 P1 不发布 → 语义 = 「若未来发布，以下为放行门槛」。

- **依据**
  - cr-106：「阈值若成**发布承诺** → 用户（即本卡）」——本选项即该升级动作的呈交。
  - cr-113（发布阈值/放行条件，QA/Release 制备；本选项仅声明衔接，不代填其判据）；Charter §2.3（threshold/release crossing → 用户/重授权）。
- **影响**
  - 产品：承诺面最大；可访问性成为（未来）产品合规/卖点；本期无发布承诺（P1 保留）。
  - 创意：数值约束最强（闪动/动效/对比度全锁定方向）；重量感与合规平衡需 Director/QA 双输入。
  - 技术：实现 + 验证成本最高；reduced-motion 开关需 Settings 表面 → **触碰「完整菜单」OOS 范围红线 → 需 CR 评估**；测量基建需 Tech 确认。
  - 范围：新增设置面/证据面（若选开关）；发布证据包（Gate 6）联动。
  - 进度：最重；Gate 3 与 Gate 6 双重绑定；发布点复测。
- **风险**：未实测即承诺 → 项目最高风险选项（P0 级发布阻塞可能）；**回滚成本** = 重授权成本（`reauthorize_charter` 路径，Charter §2.3）；**验证成本** = 发布点复测 + 完整证据包。
- **候选标注**：
  > 全部数值仍为**仅候选**（同 A2 表，须经 CR + 用户批准才成为正式门槛）；「成为发布承诺/放行条件」本身是本卡交由用户裁决的升级动作。
- **UX-13 覆盖说明**：数值判据 + 发布复测点（Gate 6）；cr-113 证据包联动；QA 在发布判定中独立 verdict。
- **升级判定（AUTH-01 §D2）**：**命中 (a)(b)(e)**（候选→正式门槛提升；写入 Gate/发布判据；threshold/release crossing）；发布承诺化 → **`reauthorize_charter` 路径**（Charter §2.3）→ **整卡呈交用户亲自选择**。

---

### 3.5 DC-ACC-01 专业推荐（唯一）与异议/依赖

> **推荐 Option A2「轻量候选规范（Internal Candidate Standard）」。**

- **一句理由：** 以决策 #19 已确认方向为骨架、以候选数值表作构图与证据字段命名词汇，零门槛承诺（不违背 PRECHARTER-04，P1 语境下无发布阻塞激活），同时让 UX-13 证据行可命名、QA/UX 有共同测量语言，并把「是否/何时把数值正式化」完整保留给用户（A3/A4）与实测（Gate 3 前测量）。
- **异议 / 依赖（并列说明，不替用户消解）：**
  1. **客观面对的异议**：若第一权重是「QA 能直接判定 pass/fail 的硬数值」，A3 更直接但带未实测返工风险；若第一权重是「零任何数值」，A1 更轻；若未来发布合规是硬约束，A4 是必经路径（本卡先行选择可降低后期返工）。
  2. **依赖 Tech（技术可行性）**：720p 候选红线处字号/焦点尺寸在 fit 缩放（Option 2）下的实际像素可达性；像素级检验手段；reduced-motion 若后期承诺则需设置面/实现评估（均「需 Tech 确认」）。
  3. **依赖 Director / QA 输入（跨角色）**：动效/闪动上限与 pillar 4「weighty feedback」的创意平衡（Game Director）；QA 确认候选数值仅作证据字段命名而非判据、QA 独立性不变（Independent QA）。
  4. **与 DC-ACC-02 的衔接**：若用户选 A3/A4 → DC-ACC-02 的 Gate 3 判据必须含数值化 UX-13 子行与量化检查；若选 A1/A2 → DC-ACC-02 保持定性红线 + 严格证据完整性（与 §4 推荐 B3 匹配）。两张卡同批呈交便于用户一次对齐。

---

## 4. 决策卡 2 — DC-ACC-02（cr-114）

> **互斥性说明：** 四个选项沿「判据内容 × 证据接受阈值 × 放行绑定」主轴互斥：**定性观察（B1）/ 量化红线（B2）/ 证据收紧（B3）/ 发布绑定（B4）**。用户选择其一即为 Gate 3 验收标准的整体决策；未选项保持 `unresolved`/`team_proposal`。

---

### Option B1 — 「观察判据（Observation Gate）」

**名称（一句话）：** Gate 3 判据 = 定性红线（决策 #18/#19 + UX §3 跨状态规则 + §6.2 空间层级）；证据接受 = 每状态 × 每支持比例命名帧 + QA 独立 verdict + retest 链接；**不引入任何量化数值**。

- **依据**
  - cr-114（判据/红线/阈值 unresolved）；Charter §10 Gate 3 行（定性 blocker 已存在：obscured player/danger/space or focus failure）；UX §9 各行现有字段；Anchor v0.1 边界（构图参考）。
- **影响**
  - 产品：最低判据承诺；验收语言 = 「遮挡/焦点失败即不通过」的定性红线。
  - 创意：判定留白给 Director 审美判断（清屏表现、B2 可读性的整体观感）。
  - 技术：零新增；帧捕获 / build identity 属既有 QA 证据基础（Charter §10 字段）。
  - 范围：证据面 = 现有 UX-01..13 字段复用；命名 aspect = {16:9, 16:10, 21:9}（Option 2）。
  - 进度：最轻；Gate 3 证据计划可直接沿用 §9 矩阵结构。
- **风险**：判定主观性升高（观察者一致性依赖）——量化缺失时 QA 需明确笔录依据；**回滚成本** = 零；**验证成本** = 每状态×每比例命名帧 + QA 独立 verdict + retest 链接。
- **候选标注**：本选项不提出任何数值。
- **QA 观察要求说明**：Independent QA 在支持集 {16:9, 16:10, 21:9}（命名 aspect/resolution 帧；720p 候选点含入）对所需状态（entry / combat / no-target / upgrade 1·2 / focus-loss / victory / defeat / B2 最强帧 / restart）逐行 UX-01..13 观察，逐行 verdict + retest 链接；被遮挡玩家/危险/波流/可恢复走廊或焦点失败 = **blocker**（沿用 Gate 3 定性 blocker，QA 独立 pass/block）。
- **升级判定（AUTH-01 §D2）**：**命中 (b)**（Gate 3 判据内容本身，§8.2.3 明确列名 DC-ACC-02）→ **整卡呈交用户亲自选择**。

---

### Option B2 — 「量化红线（Quantified Red Lines）」

**名称（一句话）：** 在 B1 定性红线之上新增**候选**量化遮挡红线（玩家剪影可见面积下限、HUD/特效与剪影重叠上限、连续遮挡帧数上限——全部仅候选）与候选证据接受阈值（每状态×比例命名帧数下限、独立观察者数）；**不构成发布承诺**。

- **依据**
  - cr-114 风险行：「无红线则视觉 QA 无法判定」——量化红线给出确定性判词。
  - UX §6.2/§8（player/danger/space 最高优先级；B2 不得成为持续光场）——量化红线正是该优先级的可测形态。
  - UX-09/UX-12 行（命名 aspect/resolution 帧）——量化检查可挂接该帧集。
- **影响**
  - 产品：验收语言更确定（数字红线）；玩家获得可复验的「不被遮挡」保证。
  - 创意：B2 清屏表现受数值约束（最强帧定义、剪影判定依赖真实渲染结果）——**Director 输入为必要前置**。
  - 技术：像素级遮挡检测 / 帧分析工具可行性（**需 Tech/Toolchain 确认**）；剪影判定方法（**需 Tech 确认**）。
  - 范围：新增量化检查面（QA 工具与笔录格式）；证据字段增加量化结果列。
  - 进度：中等；数值定稿 + 工具链成本先于 Gate 3 证据计划。
- **风险**：**未实测即量化的错标风险**（最强帧时刻、特效半透明像素归类、fit 缩放下的像素含义都依赖真实渲染）；**回滚成本** = 退回定性判定（低-中）；**验证成本** = 每命名帧像素级测量 + QA 复核。
- **候选标注**：
  > 示例候选值（仅候选，须经 CR + 用户批准才成为正式门槛）：玩家剪影可见面积 ≥ 85%（B2 最强帧；候选）；HUD/特效与玩家剪影重叠像素 ≤ 5%（候选）；连续完全遮挡玩家剪影 ≤ 2 帧（候选）；证据接受阈值 = 每状态 × 每支持比例命名帧 ≥ 1（候选）、每个 pass 判定由 ≥ 2 名独立观察者复核（候选）。
- **QA 观察要求说明**：QA 在命名帧上执行候选量化检查 + 定性检查 + verdict；**量化值未获用户批准前不得作为 blocker 依据**（仅记录测量值）；retest 保留原失败（Charter §10）。
- **升级判定（AUTH-01 §D2）**：**命中 (a)**（候选数值 → 正式判据提升）+ **命中 (b)**（Gate 3 判据）→ **整卡呈交用户亲自选择**。

---

### Option B3 — 「证据收紧（Evidence-Strict）」★ 专业推荐

**名称（一句话）：** 判据保持定性红线（同 B1），但**证据接受阈值升级为严格完整性规则**：Charter §10 全部 mandatory 字段（build/config 身份、命名帧参照、observer、verdict、retest 链接）齐备才可判定；缺失任何字段 = `not_run`；静态/Anchor 不可替代运行时/视觉证据；retest 保留原失败。

- **依据**
  - cr-114 待决项原文（…**evidence acceptance thresholds** unresolved）——本选项直接回答该子维度。
  - Charter §10 证据纪律（evidence ID/index/observer；证据类不可互换；缺失 mandatory = `not_run`；retest 保留失败）。
  - UX §9 evidence boundary（static/source 与 synthetic/anchor 不能替代 visual QA/runtime）与 Anchor v0.1 边界（构图参考、非验收替代）。
- **影响**
  - 产品：验收=「过程可审计」承诺；判据内容保持定性（不引入未实测数值）。
  - 创意：不受数值约束；Director 仍以定性红线做审美判断。
  - 技术：证据管线 / 帧捕获 / build identity 基建要求（**需 Tech/Toolchain 确认**）；无新渲染约束。
  - 范围：证据包面全量（UX-01..13 逐行完整字段）；命名 aspect = {16:9, 16:10, 21:9}。
  - 进度：高于 B1 低于 B2——证据收集/复核成本居中。
- **风险**：证据成本抬高 Gate 3 门槛（证据面更重）；**回滚成本** = 放宽证据规则（低）；**验证成本** = 全部 mandatory 字段逐行复核 + 证据索引核验。
- **候选标注**：无新数值阈值（「证据阈值」= 完整性规则，非数值门槛；不触发候选→门槛提升）。
- **QA 观察要求说明**：QA 依完整性规则逐行验收（每行 = evidence ID / build/config 身份 / 命名帧参照 / observer / verdict / retest 链接）；**缺失任何 mandatory 字段 → `not_run`（不是 pass）**，期间不改判、不由 Producer 豁免；Anchor v0.1 仅作构图参考，不作验收替代（ANCHOR_DECISION §2/§5）。
- **升级判定（AUTH-01 §D2）**：**命中 (b)**（Gate 3 判据内容本身，§8.2.3 明确列名）→ **整卡呈交用户亲自选择**。

---

### Option B4 — 「发布绑定（Release-Binding）：未来放行姿态」

**名称（一句话）：** B2 量化红线 + 证据接受阈值**升级为未来发布放行条件**（Gate 6 / cr-113 联动）；本期 P1 不发布 → 语义 = 「若未来发布，以下为放行门槛」。

- **依据**
  - cr-114 → cr-113 依赖（「发布阈值 / 放行条件……依赖 cr-109/106/114」）；Charter §10 Gate 6 行；Charter §2.3（release crossing → 用户/重授权）。
- **影响**
  - 产品：承诺面最大（验收标准成为未来发布契约的一部分）；本期无发布承诺。
  - 创意：量化 + 发布双重约束（B2 全量 + 放行绑定）。
  - 技术：测量工具 + 发布证据包（Gate 6）双基建（**需 Tech/Toolchain 确认**）。
  - 范围：最大（quantified checks + release evidence package）。
  - 进度：最重；Gate 3 与 Gate 6 排期联动。
- **风险**：未实测即入发布条件（最高）；**回滚成本** = `reauthorize_charter` 路径（Charter §2.3）；**验证成本** = 发布点复测 + 完整证据包（QA/Release，cr-113 卡承接判据细节）。
- **候选标注**：全数值**仅候选**（同 B2 表，须经 CR + 用户批准才成为正式门槛）；「发布绑定」本身是本卡交由用户裁决的升级动作。
- **QA 观察要求说明**：同 B2 量化检查 + Gate 6 发布复测点；放行裁定归 Independent QA/Release（cr-113/DC-REL-01 承接，Producer 无豁免权）。
- **升级判定（AUTH-01 §D2）**：**命中 (a)(b)(e)**；发布承诺/放行绑定 → **`reauthorize_charter` 路径** → **整卡呈交用户亲自选择**。

---

### 4.5 DC-ACC-02 专业推荐（唯一）与异议/依赖

> **推荐 Option B3「证据收紧（Evidence-Strict）」。**

- **一句理由：** cr-114 的真正痛点 = 「无红线则视觉 QA 无法判定」+「证据接受阈值」未定；在真实 UI 尚不存在（Gate 3 `not_run`、本期不发布）时，量化红线（B2/B4）是把未实测数值提前焊死（违背 PRECHARTER-04、返工风险最高），而 B3 用 Charter §10 已有证据纪律把 Gate 3 变为**可审计、可复验、不可替代**的过程红线——「被遮挡/焦点失败即 blocker」的定性红线 + 全 mandatory 字段强制，正是视觉 QA 可判定的最小完备集；Anchor v0.1 明确为构图参照、不做验收替代。
- **异议 / 依赖（并列说明，不替用户消解）：**
  1. **Game Director 创意输入（跨角色依赖，必要前置）**：「clear-screen dominance」「B2 同源可读」等判据的审美成立性需独立 Director 观察输入；本卡未读取 Director 意见（`ANCHOR_REVIEW_v0_2.md` 亦未读——DC-ANCH-01 不在本任务），**需父协调器在汇卡前补充 Director 输入**。
  2. **依赖 Tech / Toolchain**：帧捕获、build identity、证据管线基建（B3）与像素级遮挡测量（B2）的可行性——均「需 Tech 确认」。
  3. **QA 独立观察**：QA 必须能在其工具链上执行所选证据阈值（QA 可拒绝证据、独立 verdict、无豁免——QA 独立性不变）；若 QA 判定证据字段不可执行，选 B3/B2/B4 前须先确认工具面。
  4. **Anchor v0.1 基准确认**：全部选项以 v0.1（用户接受静态基线）为构图/层级参照；v0.2 未接受候选，不进入任何判据（DC-ANCH-01 独立处理）。
  5. **与 DC-ACC-01 的衔接**：UX-13 行的证据接受阈值随 ACC-01 所选类联动（A1/A2 定性 ↔ B1/B3；A3/A4 数值 ↔ B2/B4）；若两卡所选类不一致（如 A3 + B3），Gate 3 需容纳数值化 UX-13 子行 + 完整性规则并存——两卡同批呈交、用户一次对齐。

---

## 5. 决策后记录规则（按 CHANGE_REQUESTS_v0_1.md §8 引用）

- **用户选择某项 → 记为 `user_confirmed`（provenance = 用户决策）**，并更新对应合同/文档 status 字段：DC-ACC-01 选定后 → UX 合同 §7（对比度/字号/焦点尺寸/闪动/动效/reduced-motion 阈值条目）与 §9 UX-13 行由 UX/UI owner 更新；DC-ACC-02 选定后 → UX 合同 §12 open decisions 与 §9 UX-01..13 证据行/Gate 3 判据由 UX/UI owner 细化，QA/Release 接 Gate 3 独立观察；Tech ADR-TECH-07/08（如涉及测量/缩放可行性）由 Tech Lead 更新；CR ledger cr-106/cr-114 行由 Producer 补记决策引用。**任何 status 更新均在用户选择之后、由对应 owner 执行；本制备产物不更新任何文档。**
- **未选项保持 `unresolved`/`team_proposal`**：不删除、不静默推广（CR §8；Charter §2.3 沉默不为同意）。
- **若所选选项改变 promise / immutable / platform / threshold / release**（A4 / B4 的发布承诺化，或任选值写入发布承诺、发布文案、Gate 判据）→ 走 **reauthorize_charter** 路径（Charter §2.3；CR §8），由 Producer 装配回用户。
- 本卡任何选项**不视为**对 UX/Tech/Systems 合同的批准或冻结；三份合同保持 `PROPOSAL / DRAFT / NOT APPROVED`（Charter §2.2；CR §9）。

## 6. 决策窗口与截止依赖（按 §7 Batch 2）

- **DC-ACC-01（cr-106）**：与 **DC-PERF-01** 同期；在 **UX 契约/无障碍清单定稿前**。
- **DC-ACC-02（cr-114）**：Batch 1 之后（依赖分辨率/支持集——已决 R03）；在 **Gate 3 证据计划前**。
- **AUTH-01 P1（2026-08-16）**：Batch 2 → Batch 3 → DC-ANCH-01 **连续推进，无需批间征询**；但本两卡为 D2 升级类，**始终呈交用户亲自选择，未选项绝不静默通过**（§7 总规则 5；§8.2.3）。
- 错过窗口的项目保持 `unresolved` 顺延至下一窗口，绝不由沉默通过（§7 总规则 1）。

## 7. 批准后的新 owner 与验收标准（§8 末两字段）

- **DC-ACC-01 批准后新 owner**：UX/UI Designer（阈值表细化 / UX-13 证据计划）+ Tech Lead（fit 缩放下字号/焦点尺寸可行性；reduced-motion 若承诺则 Settings 评估）+ Game Director（动效/重量感复核）+ Independent QA/Release（UX-13 观察与 pass/block）。
- **DC-ACC-01 批准后验收标准**：UX-13 行（`visual QA` + `QA`：target settings / state coverage / 命名帧 / checklist / independent verdict）按所选选项执行；数值若成验收门槛，须先经 CR + 用户批准（本卡）成为正式门槛（§2-3 标注规则）。
- **DC-ACC-02 批准后新 owner**：UX/UI Designer（Gate 3 判据细化 + UX-09..13 证据计划）+ Game Director（创意判据输入）+ Tech/Toolchain（证据/测量基建）+ Independent QA/Release（Gate 3 独立观察 pass/block）。
- **DC-ACC-02 批准后验收标准**：Gate 3（`visual QA` + `runtime`：状态面 × 命名 aspect {16:9,16:10,21:9} × 帧参照 × observer × verdict × retest）按所选选项执行；被遮挡玩家/危险/波流/可恢复走廊或焦点失败 = blocker（沿用 Charter §10 Gate 3 行）；量化值未批准前不得作 blocker 依据（B2/B4 若选）。

---

## 8. 不变量、边界与 closure

- **本任务只读**了 §0 所列 static/source 文档；**只写入**本文件（唯一新产物）与 `KICKOFF_UX_UI_CONTRACTS_v0_1.md` §7/§9 的既定 P2 状态行更新（AUTH-01 §8.2.2 P2 授权，§C——见该文件变更记录）。
- 未修改任何其它既有文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布；未调用 subagent / subagent_fork / workflow 或任何嵌套派发。
- 未替用户选择阈值/验收数值；未批准/冻结任何合同或 ADR；未豁免 QA blocker；未替 Independent QA 下 verdict；未把任何 `team_proposal`/`assumption`/`unresolved` 升级为 `user_confirmed`。
- 数据不变量保留：22 / 8+1 / PRECHARTER-01..11 / 四层 provenance / unresolved 全量 / 候选标注未破坏（§0）。
- **Closure：** `closure_ready = yes` **仅针对本静态选项制备产物与 P2 状态行更新**；不是 kickoff 通过、不是实施授权、不是合同批准、不是验收 verdict。Kickoff 保持 `not_ready`；implementation 保持 `NOT_AUTHORIZED`；Gate 0/1 `ready_for_next_review`（仅静态复审）；Gate 2–6 `not_run / not_ready`。