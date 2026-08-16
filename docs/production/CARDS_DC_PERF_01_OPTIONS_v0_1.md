# CARD DC-PERF-01 — OPTIONS PACKAGE v0.1（选项制备产物，非决策）+ 附节：DC-PLAT-02 Option 2 可行性输入

> **状态：** `PROPOSAL / OPTION PREPARATION / NOT A USER DECISION / NOT APPROVED`
>
> **生命周期：** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`。
>
> **制备角色（本文件唯一 owner）：** Tech Lead（`godot-tech-lead-expert`）
>
> **本卡是什么：** 按 `CHANGE_REQUESTS_v0_1.md §8` 固定卡片结构，为 **DC-PERF-01「性能候选预算：软候选 vs 正式门槛（cr-109）」** 制备 2–4 个精准、互斥的整体选项（含子维度：哪些数值、软/硬属性、测量后复审规则、命名硬件基线如何挂钩），提交父协调器汇成选项卡片供用户选择；并按 **AUTH-01 §8.2.3 D2** 对每个选项标注升级判定。
>
> **本卡不是什么：** 不是用户最终决策；不替用户选择选项（DC-PERF-01 为升级类卡片，用户必须亲自选择）；不批准/冻结/定稿任何合同或 ADR；不豁免 QA blocker；不替 Independent QA 下 verdict；不把任何候选预算提升为正式门槛；不把任何 `team_proposal`/`assumption`/`unresolved` 升级为 `user_confirmed`。
>
> **证据类别：** `static/source` only。未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布；性能测量协议与硬件基线均为后续授权动作。
>
> **版本：** `v0.1`（选项制备产物；非决策、非合同、非批准）。

---

## 0. 不变量与来源边界

- 不变量保留声明（与 Charter §1/§9、CR ledger §9 一致）：
  - **22 项**原始 `user_confirmed` 决策：保持候选约束原状；
  - **恰好 8 项** canonical `v0.1-revision-02` 输入 + **独立**的 Charter authorization record（无第九项）；
  - **PRECHARTER-01..11**：全部保留，unresolved 字段未动；
  - **四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）全程区分；
  - **全部 unresolved 保留 unresolved**：cr-107/108/109 及测量协议/硬件基线/percentile/时钟权威相关细节在用户决策前一律 open。
- 被本卡**未提升**的候选预算（原样保留）：`1080p/60`、`50 FPS minimum`、input `≤50ms`、hit-feedback start `≤100ms`、cold start `<3s`、restart `<1s` —— 全部仅候选（Charter §6；PRECHARTER-10；revision-02 #7；ADR-TECH-07）。
- 实际读取来源（仅 static/source）：`DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（§6 性能候选边界/决策 #21/PRECHARTER-10/§10 Gate 4/§12 开放决策行）、`KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（ADR-TECH-07 协议模板/ADR-TECH-08）、`CHANGE_REQUESTS_v0_1.md`（§3–§8.2：cr-107/108/109、§8 卡片结构、§8.1 R01–R03、§8.2 AUTH-01 P2/D1–D3/硬边界）、`KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md`（采样/percentile/时钟权威相关行，供 cr-108 依据引用）、`CARD_DC_PLAT_02_OPTIONS_v0_1.md`（识别「需 Tech 确认」条目，供附节 B）。
- 本卡内所有候选数值（含六项性能预算）凡涉及处均标注：
  > 「仅候选，须经 CR + 用户批准才成为正式门槛。」

---

## 1. 待决项（linked cr_ids + 来源原始表述 + 当前状态）

| 字段 | 记录 |
|---|---|
| Card ID | `DC-PERF-01` |
| 待决项 | **cr-109「性能阈值权威：候选预算是否提升为正式门槛」**（CR ledger §4；§7 Batch 2 行：Tech Lead 制备 + QA 审计输入） |
| 来源原始表述 | Charter §12 性能行：「Make performance candidates hard gates? — Keep 1080p/60 target and other numbers provisional until measurement and named hardware / Promote selected numbers to hard Charter gates」；revision-02 #7（六项候选预算，非硬门、非已观测结果、非发布承诺）；PRECHARTER-10（`team_proposal` 候选预算）；ADR-TECH-07（协议模板；候选预算不是硬门槛且未测量） |
| 受影响的 user_confirmed 边界 | 决策 **#21**（「PC-first 性能方向，数值预算保持候选直至 Tech/Systems 提案与 User 确认」）；PRECHARTER-10；revision-02 #7；DC-PLAT-01 P1（本期不发布） |
| 当前状态 | cr-109 = `needs_user_decision`（决策包 DC-PERF-01）；候选预算保持仅候选；未测量（Gate 2/4 `not_run / not_ready`）；依赖 cr-107（命名硬件基线）/ cr-108（采样方法与 percentile/时钟权威）——二者 `absorb_within_authority`（Tech 提案 + QA 审计），均在途 |
| AUTH-01 判定 | **升级类卡片（D2）**：AUTH-01 §8.2.3 明列「DC-PERF-01（阈值权威卡，cr-109）」——**任何模式均不可自动采纳，必须呈交用户亲自选择** |
| 依赖 | cr-107（Tech 提案协议 + QA 审计；硬件规格若进发布承诺 → 升级 cr-109）、cr-108（Tech 提案 + QA 审计；硬门槛化 → cr-109）、批量测量授权（Gate 2/4，尚未授权）、Independent QA 观察（Gate 2/4，仍 `not_run`）、DC-REL-01（cr-113 发布放行条件，后续批） |
| 下游影响 | Gate 4 判据（性能）、Gate 6 放行（若提升入 Gate 判据）、发布文案范围（若承诺化）、范围/平台拓展自由度、cr-107/108 协议的验收姿态 |

---

## 2. 共同前提（所有选项适用；不因选项不同而改变）

1. **六项候选预算原样保留为候选**：`1080p/60`、`50 FPS minimum`、`≤50ms`、`≤100ms`、`<3s`、`<1s`（Charter §6 / PRECHARTER-10 / revision-02 #7 / ADR-TECH-07）——「仅候选，须经 CR + 用户批准才成为正式门槛」。
2. **任何选项都不改变决策 #21 的候选语义结构本身**：提升与否是 cr-109 决策内容，本卡只制备；未选项保持 `unresolved`/`team_proposal`。
3. **cr-107 / cr-108 为前提依赖（非本卡可消解）**：未经命名硬件基线（cr-107）与采样/percentile/时钟权威（cr-108），任何「正式门槛」都不可审计（ADR-TECH-07 stop condition：「candidate treated as hard gate without a named decision」/「missing any required identity or raw sample」即停）。两 CR 均为 `absorb_within_authority`：Tech Lead 提案 → QA 审计，可在本卡制备并行推进。
4. **P1（本期不发布）降低承诺化紧迫性**：无商店/渠道/发布文案承诺（cr-103 已按 R01 决策），Gate 6 按内部复审姿态；任何选项若引入发布承诺/发布文案引用 → 触发 `reauthorize_charter` 检查（CR §6 Producer note）。
5. **性能验收纪律（Charter §10 / CR §9 沿用）**：unresolved thresholds 需 named decision record（owner/authority）；性能证据 = 命名硬件 + raw samples + percentiles + 独立 QA 观察；Gate 4 `not_run / not_ready`，本卡任何选项不构成测量或验收。
6. 所有选项保持 Tech/Systems/UX 合同与 ADR `PROPOSAL / DRAFT / NOT APPROVED` 状态不变（本卡不更新任何文档）。

---

## 3. 选项（4 个，精准、互斥）

> 互斥性说明：四个选项在「提升哪些数值 × 何时生效」两轴上互斥——**A** 一个都不提升（测量后复审再提案）；**B** 全量立即生效；**C** 全量提升但激活以测量证据为条件（证据失败自动回退候选）；**D** 仅提升结构性子集（1080p/60 + 50 FPS minimum）并挂钩命名硬件基线，其余四项保持候选至测量后复审。用户选择其一即为整体决策（含其子维度说明）；未选项保持 `unresolved`/`team_proposal`。

---

### Option A — 「保持候选直至测量证据」（Status Quo + 测量后复审规则）

**名称（一句话）：** 六项候选预算全部保持仅候选，不提升任何数值；命名硬件基线（cr-107）与采样/percentile/时钟权威（cr-108）以 Tech 协议 + QA 审计推进为**测量身份**（非门槛），Gate 4 测量证据齐备后由 Tech 以新 CR 重新提案（cr-109 再次呈交用户）。

- **依据**
  - Charter §12 性能行备选原文「provisional until measurement and named hardware」；决策 #21（预算保持候选直至 Tech/Systems 提案与 User 确认）；revision-02 #7「Not hard gates, not observed results, not release commitments」；PRECHARTER-10。
  - ADR-TECH-07 stop condition：缺任何 identity/raw sample 或「候选被当作硬门槛」即停——提升在测量协议与身份就绪前不可审计。
  - Charter §10 Gate 4 行：「Threshold unresolved until named decision record with owner/authority」；cr-109 依赖 cr-107/108 与测量后证据（CR ledger cr-109 行）。
  - DC-PLAT-01 P1（本期不发布）——无近期发布文案/承诺需求，无立即提升的紧迫性。
  - 与已批准路径一致：DC-PLAT-02 Option 2 已确立「红线数值仅候选、待测量」的同型姿态（§8.1 R03）。

- **影响**
  - 产品：承诺面最小、确定面最小——不向玩家/发布侧承诺任何性能数字；不因门槛提前锁死范围/平台自由度。
  - 创意：无性能门槛对视觉/特效预算的硬约束；导演/美术提案空间保持开放（仍受候选预算引导）。
  - 技术：cr-107/108 协议先行（命名硬件 + 采样/percentile/时钟权威）只作为测量身份与可审计性要求；无门槛强制失效处理。
  - 范围：本期零门槛新增；Gate 4 判据仍 `not_run`，测量证据后再定。
  - 进度：零门槛返工成本；测量协议可在获批后并行推进，不占用用户窗口。

- **风险**：发布确定性推迟到测量后（但 P1 本期不发布，风险有限）；若测量结果显示某个数字达不到，届时需要「候选修订 vs 门槛外扩」的用户决策——**回滚成本：零（本期零承诺）**；**验证成本：cr-107/108 协议文档 + Gate 4 测量（后续授权）**。

- **D2 升级判定（AUTH-01 §8.2.3）**：
  - (a) 候选→正式门槛数值提升：**否**（不提升任何数值）
  - (b) 写入发布承诺/发布文案/Gate 判据：**否**（明示排除；测量后复审再提案）
  - (c) 命名发布渠道：否
  - (d) promise/immutable/platform 变更：否
  - (e) threshold/release crossing：否
  - → **未命中升级判定（本选项内容为非升级路径）**；但整卡 cr-109 仍按 **D2 呈交用户亲自选择**（AUTH-01 §8.2.3 明列 DC-PERF-01 不可自动采纳）。

- **候选预算相关：**
  > `1080p/60`、`50 FPS minimum`、input `≤50ms`、hit-feedback start `≤100ms`、cold start `<3s`、restart `<1s` 全部**仅候选，须经 CR + 用户批准才成为正式门槛**。本选项不提升其中任何一项。

---

### Option B — 「立即全量提升」（Firm gates now）

**名称（一句话）：** 六项候选预算即刻全部成为正式门槛（Gate 4 判据基准），不等测量——测量仅是事后验证而非激活条件。

- **依据**
  - Charter §12 性能行备选对偶「Promote selected numbers to hard Charter gates」；PRECHARTER-10 与 revision-02 #7 的候选边界需用户显式解除——本选项即该解除动作。
  - cr-107/108 尚未产生命名硬件基线与采样/percentile/时钟权威（均 `unresolved`）；本选项将其降级为「门槛后的验证细节」。

- **影响**
  - 产品：六个数字即刻成为正式承诺（一旦进入发布文案/Gate 判据即承诺化）；发布确定性最高，范围/平台自由度最低。
  - 创意：门槛即刻约束视觉/特效/场景预算，导演/美术须按门槛设计。
  - 技术：门槛在测量方法（cr-108）与硬件基线（cr-107）就绪前即生效——**技术不可审计**（无 identity/raw sample 即无法验证，违反 ADR-TECH-07 stop condition 与 Charter §10 named decision record 纪律）。
  - 范围：任何性能不达标的设计/资产选择 = 门槛失败，范围拓展自由度被压缩。
  - 进度：风险最高——未测量即承诺，Gate 4 可能全量失败或需要降级（重新走 CR）。

- **风险**：未经命名硬件/采样方法的门槛不可执行、不可审计；测量后若任一数字不达 → 门槛失败或回退（回退 = CR + 用户，成本中等：Gate 判据/记录返工）；**回滚成本：中等（正式记录改动 + 判据重写）**；**验证成本：先补齐 cr-107/108 再测量（顺序颠倒反而更高）**。

- **D2 升级判定（AUTH-01 §8.2.3）**：
  - (a) 数值提升：**是**（六项候选→正式门槛，全量）
  - (b) 发布承诺/发布文案/Gate 判据：**是**（生效即 Gate 4 判据基准；发布文案若引用即承诺化）
  - (c) 命名发布渠道：否
  - (d) promise/immutable/platform 变更：否
  - (e) threshold/release crossing：**是**（正式门槛 + 放行交叉）
  - → **命中升级判定 (a)(b)(e)**——即便 AUTH-01 无明列，本选项单独也触 D2 呈交。

- **候选预算相关：**
  > 若用户选择本选项，六项数值由「仅候选」变为正式门槛——该提升本身须经 CR + 用户批准；**本制备产物不执行提升**。提升决定前六项仍「仅候选，须经 CR + 用户批准才成为正式门槛」。

---

### Option C — 「全量提升、激活延迟（挂钩测量证据 + 回退条款）」（Anchored promotion with fail-open）

**名称（一句话）：** 用户现在**采纳**六项数值为正式门槛（原则层面提升），但**激活条件**是 Gate 2/4 在命名硬件（cr-107）上的原始采样证据（cr-108 定义 percentile/时钟权威）确认达标；证据缺失或失败 → 相关数值自动回退候选（fail-open），并启动测量后复审 CR。

- **依据**
  - Charter §12「Ask UX/Tech for measured recommendation, then User selects」与 §10「threshold unresolved until named decision record」——本选项把「named decision」与「measurement」以条件激活方式绑定，使两者同时成立。
  - cr-109 依赖 cr-107/108 与测量后证据——本选项把派生关系写进生效条款而非消灭它。
  - P1 本期不发布：生效延迟不产生发布空窗。

- **影响**
  - 产品：六个数字在原则层面确立（团队可依设计），但对玩家/发布侧仅在证据达标后被激活；承诺面介于 A 与 B 之间。
  - 创意：原则性预设引导视觉/特效预算，但未验证项不产生硬约束。
  - 技术：门槛与测量协议（cr-107/108）形成强制配对——每项阈值必须有对应 raw samples + percentile + 时钟权威记录；结构性成本高于 A。
  - 范围：原则层面锁定的数字会引导范围决策（若某数字不达标，范围/平台选项受限于「修订或外扩」）。
  - 进度：测量授权（Gate 4）成为激活前置；若证据延期，门槛状态悬置（fail-open 保持候选），无硬失败。

- **风险**：原则提升但激活延迟可能造成「已定未验」的心理预设（团队按未验证数字设计）；证据部分达标时的逐项激活/回退仲裁成本；**回滚成本：低-中（fail-open 自动回退 + 复审 CR）**；**验证成本：cr-107/108 协议 + Gate 2/4 raw samples + 逐项激活判定（QA 审计）**。

- **D2 升级判定（AUTH-01 §8.2.3）**：
  - (a) 数值提升：**是**（采纳即原则提升；激活以测量为条件——提升决定本身在本卡作出）
  - (b) 发布承诺/发布文案/Gate 判据：**是**（激活后即 Gate 4 判据基准；发布文案若引用即承诺化）
  - (c) 命名发布渠道：否
  - (d) promise/immutable/platform 变更：否
  - (e) threshold/release crossing：**是**（正式门槛 + 放行交叉，激活时点生效）
  - → **命中升级判定 (a)(b)(e)**（生效延迟不改变「提升决定」的升级属性）——D2 呈交。

- **候选预算相关：**
  > 六项数值在被本卡采纳后、测量激活前仍为原则性正式门槛候选——**提升动作本身须经 CR + 用户批准**；未激活前不视为已生效门槛，仍标注「仅候选，须经 CR + 用户批准才成为正式门槛」。

---

### Option D — 「结构性子集先行（1080p/60 + 50 FPS minimum 挂钩命名硬件）；其余四项测量后复审」（Phased structural subset）

**名称（一句话）：** 只把「可见输出底线对」`1080p/60` + `50 FPS minimum` 提升为正式门槛（绑定命名硬件基线 cr-107），input `≤50ms`、hit-feedback `≤100ms`、cold start `<3s`、restart `<1s` 四项保持候选直至 Gate 2/4 测量证据齐备后复审（新 CR）。

- **依据**
  - 决策 #21 候选方向的核心是「可读输出底线 + 响应节奏」两族；输出底线对（分辨率×帧率）有明确的物理观测点（帧时间），cr-107 命名硬件即可测量；而响应族（≤50ms/≤100ms）依赖输入-观测延迟定义与反馈起点定义（cr-108 采样/时钟权威），在协议定稿前无法构成门槛——ADR-TECH-07 协议模板 Input method / Feedback method 行。
  - PRECHARTER-10 数值族内部本就分层（目标/最低/响应/启动），为分阶段提升提供文档基础。
  - Charter §10 Gate 4 行：良构证据（命名硬件 + raw samples + percentiles）可先行支撑可测族。

- **影响**
  - 产品：承诺「以命名硬件为准的可读输出底线」，不给玩家/发布侧承诺响应族数字；承诺面与确定面居 A 与 C 之间。
  - 创意：仅输出底线约束渲染分辨率/帧率预算；响应族保持探索空间。
  - 技术：cr-107 成为子集门槛的强制依赖（测量身份 = 门槛身份）；cr-108 仍为其余四项的前置；协议成本低于 C、高于 A。
  - 范围：1080p 输出底线与 P1 单 Windows 目标、Gate 5 导出分辨率配置自然衔接（ADR-TECH-08 身份字段输入）。
  - 进度：子集可先行测量验证；其余四项随 cr-108 协议定稿后复审，两段式推进。

- **风险**：子集/剩余四项的边界判定本身需要裁决（哪些数字「可测即门槛」）；若 50 FPS minimum 在命名硬件上不达 → 门槛失败或修订（CR + 用户）；**回滚成本：低-中（子集记录回退 + 复审 CR）**；**验证成本：cr-107 协议 + Gate 2/4 子集 raw samples；剩余四项测量后复审（QA 审计）**。

- **D2 升级判定（AUTH-01 §8.2.3）**：
  - (a) 数值提升：**是**（子集 2 项候选→正式门槛；其余 4 项不提升）
  - (b) 发布承诺/发布文案/Gate 判据：**是**（子集进入 Gate 4 判据基准；发布文案若引用即承诺化）
  - (c) 命名发布渠道：否
  - (d) promise/immutable/platform 变更：否
  - (e) threshold/release crossing：**是**（子集正式门槛 + 放行交叉）
  - → **命中升级判定 (a)(b)(e)**——D2 呈交。

- **候选预算相关：**
  > `1080p/60` 与 `50 FPS minimum` 在被本卡采纳前仍「仅候选，须经 CR + 用户批准才成为正式门槛」；`≤50ms`、`≤100ms`、`<3s`、`<1s` 保持仅候选至测量后复审（同样须 CR + 用户批准）。

---

## 4. 专业推荐（唯一）

> **推荐 Option A —「保持候选直至测量证据」。**

- **一句理由：** cr-109 的前提 cr-107/108（命名硬件基线 + 采样/percentile/时钟权威）尚为在途提案、未产任何测量证据（Gate 2/4 `not_run`），此时提升任何数值都是「在不可审计条件下定门槛」（违反 ADR-TECH-07 stop condition 与 Charter §10 named decision record 纪律）；而 P1 本期不发布取消了近期承诺化压力，先以 Tech 协议 + QA 审计把测量身份与方法定稿、测量后以新 CR 复审，是与「候选→门槛必须 CR + 用户批准」纪律同构且成本最低的路径。
- **异议（并列，不替用户消解）：**
  1. Option D 的「结构性子集先行」对希望尽早锚定输出底线（1080p/60 + 50 FPS）的团队有吸引力——但子集边界判定本身需要裁决，且同样依赖 cr-107，不构成比 A 更早的可审计事实。
  2. Option C 的「原则提升 + 激活延迟」可给设计侧更早的方向感——但「已定未验」的心理预设风险与本卡纪律相悖；测量后复审 CR 在 A 中同样能达成方向感（以提案而非门槛形式）。
  3. 若用户以「发布确定性优先于一切」为第一权重，B/C 才是合理备选——该优先级属产品级裁决，由用户定夺。
- **依赖（本推荐不冻结任何依赖方）：** cr-107 / cr-108（Tech 提案 + QA 审计，在途）；测量授权（Gate 2/4，后续）；Independent QA 观察；DC-REL-01（cr-113，发布放行条件在其后批次）。

---

## 5. 决策后记录规则（按 CHANGE_REQUESTS_v0_1.md §8 引用）

- **用户选择某项 → 记为 `user_confirmed`（provenance = 用户决策）**，并更新受影响文档状态：若选择任一提升选项（B/C/D），新增/更新性能门槛决策记录（owner/authority/有效边界）与 Gate 4 判据引用；若选择 A，记录「保持候选 + 测量后复审」评审规则并由 Tech 推进 cr-107/108 提案。**任何 status 更新均在用户选择之后、由对应 owner 执行；本制备产物不更新任何文档。**
- **未选项保持 `unresolved`/`team_proposal`**：不删除、不静默推广（CR §8；Charter §2.3 沉默不为同意）。
- **若所选选项改变 promise / immutable / platform / threshold / release**（例：把候选数值写入发布承诺、发布文案、Gate 判据）→ 走 **reauthorize_charter** 检查路径（Charter §2.3；CR §6 Producer note）——本卡四选项均由用户亲自选择，选择记录即该判定点。
- 本卡任何选项**不视为**对 Tech/Systems/UX 合同的批准或冻结；三份合同与 ADR 保持 `PROPOSAL / DRAFT / NOT APPROVED`。

---

## 6. 决策窗口与截止依赖（按 §7 Batch 2）

- **窗口：** **Batch 1 之后、性能测量协议授权之前**（CR ledger §7 Batch 2 DC-PERF-01 行，2026-08-16 起启用）。错过窗口的项目保持 `unresolved` 顺延至下一窗口，绝不由沉默通过。
- **并行/依赖：** 与 DC-ACC-01（cr-106）同期制备；依赖 cr-107/108（在途吸收项）；Gate 4 测量授权依赖本卡结论（任何提升选项都要求测量协议先行定稿）；DC-REL-01（cr-113）在其后批次。

---

## 7. 批准后的新 owner 与验收标准（§8 末两字段 + 任务指定）

- **批准后新 owner：**
  - **Tech Lead**：性能测量协议（cr-107 命名硬件基线 + cr-108 采样/percentile/时钟权威）定稿与更新；测量执行（Gate 2/4 授权后）；
  - **Toolchain Engineer**（归 Tech Lead 基础设施伞下）：build identity / artifact digest / target 身份字段（cr-112，P1 后已激活），测量构建与日志身份；
  - **Independent QA / Release**：证据审计与 pass/block（Gate 2/4 路径）；Producer 无豁免权；
  - 若选项含提升（B/C/D）：Producer 同步更新 Gate 判据引用与发布承诺面核查（reauthorize_charter 判定点）。
- **批准后验收标准：** 性能验收以**命名硬件 + raw samples + percentile/时钟权威 + Independent QA 观察**为准（Gate 2/4 路径，仍 `not_run / not_ready`）；任何候选数值成为验收门槛前**必须先经 CR + 用户批准成为正式门槛**（本卡 §2-1 标注规则）；静态文本/自测不可替代独立观察。

---

## 8. 不变量、边界与 closure

- **本任务只读**了 §0 所列 static/source 文档（+ DC-PLAT-02 卡用于识别「需 Tech 确认」条目，B 附节使用）；**只写入**本文件（唯一新产物）。
- 未修改任何既有文档（ADR/合同/CR 台账未触碰——ADR-TECH-01..08 状态行更新为 AUTH-01 P2 授权的唯一例外，见下方「已执行例外编辑」说明，由本任务在 ADR 文件内完成并在报告中列出精确位置）。
- 未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布；未替用户选择选项、未提升任何候选数值、未批准/冻结任何合同或 ADR、未豁免 QA blocker、未替 Independent QA 下 verdict、未把任何 `team_proposal`/`assumption`/`unresolved` 升级为 `user_confirmed`。
- 数据不变量保留：22 / 8+1 / PRECHARTER-01..11 / 四层 provenance / unresolved 全量（§0）；六项候选预算与 `1280×720` 红线均未被本卡提升。
- **Closure：** `closure_ready = yes` **仅针对本静态选项制备产物**（+ ADR 状态行例外编辑 + 报告附节计划）；不是 kickoff 通过、不是实施授权、不是合同批准、不是验收 verdict。Kickoff 保持 `not_ready`；implementation 保持 `NOT_AUTHORIZED`；Gate 0/1 `ready_for_next_review`（仅静态复审）；Gate 2–6 `not_run / not_ready`。

---

# 附节 B — DC-PLAT-02 Option 2（Balanced）可行性 / 实现成本输入（Tech Lead）

> **定位：** 这是 `CARD_DC_PLAT_02_OPTIONS_v0_1.md` 中所有标注「需 Tech 确认」条目的 Tech Lead 可行性/实现成本输入（CR ledger §7：DC-PLAT-02 制备角色 = UX/UI + Tech Lead 可行性输入）。**本输入不冻结 DC-PLAT-02 验收路径（Gate 3/5 保持 `not_run`）；不替用户确认 Option 2；不更新任何文档。**
>
> **证据等级声明：** 本附节为 `static/source + 工程判断`（Godot 4.x 平台能力为文档知识，**未访问引擎/项目**）；具体 API 事实须在实现授权后按项目 Godot 版本文档复核（tech-lead skill：版本敏感事实须对项目 Godot 文档核对，本任务禁止访问引擎/代码/资源，故列为待验项）。

## B.0 适用范围（DC-PLAT-02 卡内「需 Tech 确认」条目清单）

| 来源选项 | 「需 Tech 确认」条目（DC-PLAT-02 卡原文标注） |
|---|---|
| Option 1 / 2 / 3 | letterbox vs stretch：Godot stretch mode / aspect keep 配置、黑边/空隙渲染、性能影响（`1080p/60` 仅候选） |
| Option 2 | UI 相对缩放 + 安全区 clamp：`CanvasLayer`/`Control` scale 与布局重算时机、720p vs 1080p 两档红线缩放规格实现成本 |
| Option 2 | 空隙是否渲染氛围/景深层（创意未决项）的实现成本 |
| Option 3 | 混合分档（4:3 letterbox、21:9 fit、16:10 居中）；多档 UI 缩放 / 低分辨率文本渲染（亚像素/AA） |
| Option 1 / 2 / 3 | 插值缩放 vs 像素艺术策略（Anchor = 锈蚀工业/剪影方向，**非像素化结论**） |
| Option 1 / 2 / 3 / 4 | 全屏/窗口化/HiDPI 行为（依赖 cr-101；P1 后 = Windows x86_64 单一 target） |
| Option 4 | 后期从 16:9 单一布局扩展到 21:9/16:10 的再布局与资产影响（Gate 3 前评估输入） |

## B.1 Godot stretch mode / aspect（缩放框架总纲）

- **可行性：高。成本：低。风险：低-中。**
- **技术输入（工程判断，API 名待项目 Godot 文档复核）：** Godot 4 的 `display/window/stretch` 提供 mode × aspect 组合：
  - `mode=canvas_items`：2D 画布（含 Control UI）整体按窗口等比缩放——适合本项目 2D 切片基线；`mode=viewport` 按基分辨率渲染再缩放（画质更一致但内存/填充开销更高），不推荐作为唯一方案。
  - `aspect=keep`：等比 fit，超出部分 letterbox（黑边空隙）——对应 UX §7「prefer additional safe space over stretching」与 Option 2「fit + letterbox 空隙、禁 stretch」。
  - `aspect=expand`：不出现空隙、额外显示画布外空间——对本项目「单屏限定工业竞技场」需谨慎：扩展视野会改变竞技场边界语义（游戏性影响），**不建议**作为 Option 2 默认；除非创意明确要 21:9 纵深视野（需 Director 输入，本任务未读）。
  - 禁 stretch / 禁 crop 在 Godot 中即**禁用 `aspect=ignore`（拉伸）**、不切裁画布——语义可满足。
- **两档红线（720p vs 1080p，均仅候选）实现成本：** 单一基画布（如 1920×1080）+ `aspect=keep` 即可覆盖两档；低档仅验证密度（UX-09），无额外机制。成本：低。
- **性能影响（`1080p/60` 仅候选）：** stretch 本身不增加渲染负载（画布分辨率不变，仅呈现缩放）；负载由实际渲染分辨率/窗口缩放决定（见 B.4 HiDPI）。成本：可忽略，需测量佐证（cr-108）。
- **回滚成本：** 未承诺化前零成本（project settings 改动即可）；承诺化后回退 = CR + 用户（与红线同款）。

## B.2 CanvasLayer + Control UI 相对缩放 / 安全区 clamp

- **可行性：高。成本：低-中。风险：中（字体/密度是主要风险点）。**
- **技术输入（工程判断，API 名待项目 Godot 文档复核）：** `CanvasLayer` 提供 transform（offset/rotation/scale），可用于整层 UI 平移/缩放；但**对文本类 Control 直接 scale 会引入模糊/密度失真**——推荐安全实践是：锚点 + 容器（anchors/containers）相对布局为主，缩放档位通过 theme 字号/间距规格切换，而非对 Control 树整体 scale。
- **安全区 clamp（Windows）：** 桌面 Windows 无 notch/safe-area 概念，安全区 = 窗口 client rect；clamp 即「锚定边距 + 窗口 resized 时布局重算」的工程规范，不需要 OS 查询（若后续移动平台则另议，本期 P1 Windows 不涉及）。实现：每档（720p/1080p 候选）一套安全边距表，锚点布局自动跟随。
- **21:9 下 UI：** HUD 锚定安全区（不铺开两侧），卡牌三列按 16:9 基线宽度、不拉伸（禁 stretch）；两侧空隙留给清屏视野或氛围层（创意项，见 B.3）。
- **布局重算时机：** 窗口 resize / 全屏切换 / DPI 变化时重算一次；成本：低（事件驱动）。
- **风险：** 低档（720p 候选）HUD 密度/字号可读性需 UX-09 实测；卡牌不拉伸需要布局规则固化（防容器自动扩宽）。
- **回滚成本：** 低（布局档位表调整）；验证成本 = UX-09/UX-12 帧观察（Gate 3）。

## B.3 Letterbox 空隙实现（含氛围/景深层创意未决项）

- **可行性：高。成本：低。风险：低（需与后处理边界约定）。**
- **技术输入：** `aspect=keep` 下空隙由引擎自动产生（画布外区域）；空隙呈现 = 纯色填充（默认黑）或氛围层（渐变/景深/环境噪声）——**创意决定，需 Director 输入**（本任务未读 Director 意见，列为待协调输入）。
- **性能：** 空隙为非渲染区域或简单层，对候选 `1080p/60` 预算开销可忽略（需测量佐证，cr-108）。
- **风险：** 若全窗口后处理/FX（如全屏模糊、扫描线）作用于空隙区，需明确「空隙是否参与 FX」；建议 FX 限画布内或与氛围层统一处理——实现上是一处约定，成本低。
- **验证成本：** UX-12 每比例命名帧（21:9 两侧空隙、16:10 上下空隙）截图笔录（Gate 3）。

## B.4 全屏 / 窗口化 / HiDPI 行为（Windows，依赖 cr-101 = P1 后单一 target）

- **可行性：高。成本：低-中。风险：中（HiDPI 填充率）。**
- **技术输入（工程判断）：** Windows x86_64 单一 target（P1）收窄矩阵：
  - **窗口化：** 任意窗口尺寸下 `aspect=keep` 等比 fit，黑边随尺寸变化——行为一致，成本低；
  - **全屏：** 独占/无边框全屏切换；`aspect=keep` 在超宽显示器（21:9）上左右空隙、16:10 上下空隙；
  - **HiDPI：** OS 缩放（100/125/150/200%）下窗口物理分辨率高于逻辑分辨率；`allow_hidpi` 时画布按物理分辨率渲染再缩放——**填充率随实际渲染分辨率上升**（4K 缩放下约为 1080p 的 4×），性能影响必须在 cr-108 测量协议中记录 `settings` 行（分辨率/窗口模式/VSync/帧上限）并以命名硬件实测；`1080p/60` 候选预算测量时必须声明窗口/渲染分辨率，避免「4K 物理渲染冒充 1080p」式错配。
- **成本：** 窗口模式与全屏由引擎提供，低；HiDPI 行为验证 = 测试矩阵行（结合 cr-112 build identity 记录设置身份）。
- **回滚成本：** 低（行为约定未承诺化前零成本）。

## B.5 插值缩放 vs 像素艺术策略

- **可行性：高（插值）。成本：低。风险：低。**
- **技术输入：** Anchor 为锈蚀工业/剪影方向（`synthetic/anchor` 静态基线，**非像素化结论**）→ 默认线性插值（texture filter = Linear）与当前美术方向一致；最近邻/整数缩放仅在美术方向转向像素艺术时才成为策略选择——**该转向未确认**（`unresolved`），若未来转像素化需经 CR（影响资产管线、导入规格、art 契约），本次不结论、不预设。
- **21:9 表现：** 插值下 21:9 两侧空隙（B.3）不涉及缩放失真；画布内呈现在三比例下一致。
- **验证成本：** UX-12 帧观察 + 低档（720p 候选）可读性在 Gate 3 覆盖。

## B.6 专项补充：Option 3（混合分档）与 Option 4（延迟定标）的成本/风险输入

- **Option 3（Broad，混合分档 + 1024×576 候选低档）：** 技术上可行（分档判定 = aspect 分支 + 档位表），但成本/风险为四选项最高：3–4 档安全区/字号/焦点规格 + 低档（1024×576 候选）文本渲染密度风险（亚像素抗锯齿在低分辨率下有收益，但 UI 拥挤风险最高——UX-09 最易触线）；`1080p/60` 候选预算下低档渲染负载反而更低（分辨率低），风险主要在密度与档位维护，不在性能。若非用户以最大覆盖为第一权重，不建议（与 UX 卡 Option 3 自身标注一致）。
- **Option 4（Defer，单个 16:9 先行、Gate 3 前再定标）：** 后期从 16:9 扩展到 21:9/16:10 的再布局影响 = **小-中**：锚点+容器布局下约 80% 布局可复用；返工点集中在 (1) HUD 安全边距表新增 2 档、(2) 21:9 空隙/氛围层（若选氛围层，资产量依赖创意决定）、(3) 字体/密度档位在 720p 候选点的验证——评估成本低，可作为 Gate 3 前输入；风险为「定标推迟 → 栅格排版返工」的进度不确定性（UX 卡已列）。
- **本条输入不改变任何 DC-PLAT-02 选项的验收路径：Gate 3/5 保持 `not_run`，cr-104/105 保持 `unresolved` / 决策引用（R03 已定：Option 2 选定、红线仅候选）。**

## B.7 附节结论

- 对 **Option 2（Balanced）**：所有「需 Tech 确认」条目**可行性成立、成本中等偏低、风险可控**（字体直接 scale 是唯一需要规范化的风险点）；无技术障碍导致 Option 2 不可行。
- **不冻结声明：** 本输入是 DC-PLAT-02 验收路径（Gate 3/5）**不冻结的依赖**——选项由用户最终选择；可行性输入仅供汇卡时背书（CR ledger：DC-PLAT-02 制备角色 = UX/UI + Tech Lead 输入）；任何实现须待 kickoff 授权与项目 Godot 文档复核。