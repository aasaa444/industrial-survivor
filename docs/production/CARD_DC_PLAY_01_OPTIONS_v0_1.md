# CARD DC-PLAY-01 OPTIONS v0.1 — 可玩性观察门正式化（Systems/Rules 判据部分）

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`。
>
> **Evidence class:** `static/source` only。无 runtime、build、test、QA-execution、performance、export、release 证据。
>
> **Card:** 升级类（D2）——整卡呈交用户亲自选择；本文件只制备选项与判据，**不代用户选择**。
>
> **制备角色分配（CR §7）：** Systems/Rules Designer（判据，本文件）＋ Independent QA/Release（门权威结构，由独立 QA 成员另行制备——本文件标注衔接依赖，不代做）。
>
> **Provenance / 不变量（先声明，后文不再逐条重复）：** 22 项原始 `user_confirmed` 决策；恰好 **8** 项 canonical `v0.1-revision-02` inputs（无第九项）+ 独立 Charter authorization record；**PRECHARTER-01..11**；四层 provenance（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）；**unresolved 全量保留**。本文件不新增、不重分类任何已确认事实；所有判据构成为**提案内容**。

---

## 1. 元数据

| 字段 | 记录 |
|---|---|
| Card ID | `DC-PLAY-01` |
| Linked cr | `cr-202`（`needs_user_decision`） |
| 待决项 | 「Make playability observation a formal gate?」（revision-02 #6 候选方向；Charter §12 open-decision 行；Systems §9.2） |
| 当前状态 | 正式化与否 = `user_reserved` / `unresolved`；判据观察项 = `team_proposal`（`KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md` 为 `PROPOSAL / DRAFT / NOT APPROVED`）；门现状 = `not_run / not_ready` |
| 决策类别 | **D2（升级类）**：正式 gate 写入流程与判据 → 命中 AUTH-01 §8.2.3（b）/（d）类，整卡呈交用户（逐选项标注见 §3） |
| 决策窗口 | Batch 2；与 DC-ACC-02 同期；在范围扩张讨论前（CR §7） |
| 批准后 owner | Systems/Rules（判据构成与观察协议维持）＋ Independent QA/Release（门权威 / 独立观察）＋ Executive Producer/Lead Producer（排程与证据装配） |
| 批准后验收标准 | 真实 runtime 观察（Gate 2 起，现仍 `not_run`），由 Independent QA 观察并 verdict；**静态文档、静态 prose、Anchor 不能通过门**（Charter §6；Systems §9.2） |

## 2. 待决项与已确认事实基线（仅引用已确认事实与既有文档）

- **cr-202 原文要点（CR §3 行，复述不新增）：** 「Make playability observation a formal gate?」(revision-02 #6; Charter §12 row; Systems §9.2)；Charter v0.1；revision-02 #6（候选方向）；**产品/范围：正式门可阻止内容扩张；静态文档不能通过**；被挤出：gate 判据 + QA 预检；风险：正式门成本 vs 咨询性降级；验证：门内观察；Disposition：`needs_user_decision`（决策包 DC-PLAY-01；Systems + QA 制备）。
- **revision-02 #6（Charter §2.1 第 6 行，`user_confirmed` 候选输入）：** 在范围扩张前把核心可玩性观察作为正式门：移动因果、波数削减/走廊恢复、`穿透 → 扇裂` 理解、失败后立即重试。证据必须被观察；主观乐趣与静态文档不能通过它。当前状态 `not_run / not_ready`。
- **Charter §6 「Playability evidence gate candidate」：** 任何范围扩张前，未来授权复审必须观察：移动→下一次攻击因果、敌波削减与走廊恢复、`穿透 → 扇裂` 理解、失败后立即重试。为正式未来证据门候选，现 `not_run/not_ready`；主观乐趣、静态 prose、Anchor 不能通过；Independent QA/Release 保留 pass/block 权威。
- **Charter §12 open-decision 行：「Make playability observation a formal gate?」** 推荐 = Yes（正式门，可停止内容扩张；现 `not_run/not_ready`，静态文档不能通过）；替代 = Treat as advisory only。
- **Systems §9.2（`team_proposal` 合同文本）：** 范围扩张前，未来授权观察须经独立复审检查：① 移动引起下次自动攻击的可读变化；② 攻击/击杀结果降低压力并恢复走廊或移动空间；③ `穿透 → 扇裂` 力量步被理解为同一来源变强；④ B2 理解不因特效遮蔽玩家/危险/波/空间；⑤ 失败后无惩罚性延迟地立即重试。为未来证据门；现 `not_run / not_ready`；无静态文档、Anchor、assumption 或 proposal 能通过。
- **Gate 语义现状（CR 头 + Charter §3）：** Gate 0/1 = `ready_for_next_review`（仅静态复审，非 kickoff pass、非实现授权）；Gate 2–6 = `not_run / not_ready`；可玩性观察目前**无 runtime 证据**；缺失强制 preflight/start 证据 = `not_run`，不是 pass（Charter §10 操作规则）。
- **AUTH-01 §8.2.3 D2 升级类别（逐选项标注依据）：** (a) 候选→正式门槛的数值提升；(b) 写入发布承诺 / 发布文案 / **Gate 判据**；(c) 命名发布渠道；(d) **promise / immutable / platform 变更**；(e) threshold / release crossing。任一命中即升级、整卡呈交用户；「凡含 (a)-(e) 的选项即使同卡其余选项不升级，该卡也呈交用户」（DC-ACC-01 同款规则）。
- **判据数值底线（已确认规则）：** PRECHARTER-04「ranges + experimental starting points; 不锁未验证常数」；Systems §10 ledger 模板（`promotion_authority`：产品/阈值/Charter crossing 须 User）；CR §9「候选预算保持仅候选」。任何判据数值/阈值在本卡均为「仅候选，须经 CR + 用户批准才成为正式门槛」。

## 3. 选项（3 个，精准、互斥）

> 互斥依据：整体选项在「正式化的时间点与阻断权的来源」上互斥——Option 1 = 现在即正式 + 立即阻断权；Option 2 = 现在正式化结构 + 阻断权延后激活；Option 3 = 不建正式门、无阻断权。三个选项不能同时成立。

### Option 1 — 「正式门（立即生效）：新增独立可玩性门 Gate P」

- **名称（一句话）：** 把可玩性观察正式化为独立正式门（Gate P），对内容扩张拥有阻断权；首次判定须等待真实 runtime 证据。
- **依据：** revision-02 #6 候选方向（正式门可阻止内容扩张、静态文档不能通过）；Charter §6/§12 同向；Systems §9.2 五项观察项（`team_proposal`）；Gate 语义现状（Gate 2–6 `not_run / not_ready`）。
- **影响：**
  - 产品：任何范围扩张候选必须先过真实可玩性观察；主观乐趣/静态文档不能通过（Charter §6）。
  - 创意：观察项覆盖 Director 质量红线（移动因果、清屏恢复、同源强化理解、非惩罚重试）——Systems §9.2 五项的创意一致性由 Director 复审方向支撑（Matrix §7.1：涉及 B2 可读性/清屏结果须 Director 复审）。
  - 技术：门判定需要可审计 runtime 证据载体（fixture、seed/tick、输入序列、trace——Charter §10/Matrix §6）；无新数值进入实现。
  - 范围：范围保护最强——正式门可阻止内容扩张（cr-202 行；Charter §12）；不改变 22 项决策与 strict caps 文本本身。
  - 进度：任何内容扩张候选进入下一阶段前需先过门 → 排程约束最明显；决策窗口 = Batch 2（范围扩张讨论前）。
- **风险：** 在零 runtime 证据、判据无观测基线时建立阻断权，初始判定只能 `not_run`（无「有罪推定」也无 pass），且候选阈值未经校准存在日后误阻断风险；回滚/验证成本：门判据与权威均经 CR 可撤销（回滚路径记录于 CR 台账），验证成本 = 首次真实 runtime 观察（Gate 2 起）排程与证据装配。
- **候选阈值标注：** 本选项不提升任何数值；全部判据阈值「仅候选，须经 CR + 用户批准才成为正式门槛」。
- **与 Gate 2–6 衔接：** Gate P 定位于 Gate 2（deterministic/runtime）首次证据就绪后挂接，作为叠加于 Gate 2–6 之上的独立可玩性核验；内容扩张候选进入下一阶段前复检；不改变 Gate 2–6 语义（仍 `not_run` 直至证据；QA final pass/block 保留——Charter §10）。
- **D2 标注：** 命中 **(b)**（判据写入 Gate P 的 Gate 判据）＋ **(d)**（正式门把 revision-02 #6 的「候选方向」落实为流程/范围承诺——新增可阻断内容扩张的门阶梯结构，属 immutable 边界相关承诺变更）。整卡呈交用户。

### Option 2 — 「分阶正式化：判据结构先行，阻断权经 CR + 用户批准后激活」【推荐】

- **名称（一句话）：** 立即正式化判据构成与观察协议（结构），门权威（阻断权）暂不激活，待真实 runtime 观察证据校准后经 CR 呈交用户批准再激活。
- **依据：** 同 Option 1 的全部来源；另援引 PRECHARTER-04（ranges + experimental starting points；不锁未验证常数）与 Systems §10 ledger（`promotion_authority` = 产品/阈值/Charter crossing 须 User）——数值与权威激活均须证据 + 授权；「证据必须被观察、静态文档不能通过门」（revision-02 #6）同时约束结构与权威两步。
- **影响：**
  - 产品：判据/信号/放行规则即日可评审；阻断权未激活期间内容扩张仍受现有 Gate 2–6 判定与 CR 流程约束。
  - 创意：观察项与 Director 输入一致（同 Option 1）；观察期即积累创意复审所需证据。
  - 技术：判据定义不硬编码阈值；观察载体（fixture/seed/输入序列/记录字段）先于门激活设计完成。
  - 范围：立即交付 cr-202「被挤出：gate 判据」中 Systems 判据部分；阻断权路径明确但延后，范围保护有观察期空窗（依赖现有 gate/CR 兜底）。
  - 进度：对当前排程影响最小（门权威只有在首次 runtime 观察证据后才进入激活窗口）；决策窗口 = Batch 2 不变。
- **风险：** 若用户期望「立即能挡内容扩张」，观察期存在保护空窗；回滚/验证成本：判据不冻结 budget/阈值（全部仅候选），未激活即无门权威副作用，回滚成本最低；验证成本 = 真实 runtime 观察 → 校准报告 → 激活 CR。
- **候选阈值标注：** 同 Option 1——全部判据阈值「仅候选，须经 CR + 用户批准才成为正式门槛」。
- **与 Gate 2–6 衔接：** 观察期随 Gate 2 证据流进行（advisory 状态 + 校准输出）；激活后按 Option 1 位置挂接为 Gate P；Gate 2 仍为该阶段主门（QA final pass/block 不变）。
- **D2 标注：** 命中 **(b)**（判据结构写入 Gate 判据/观察协议）＋ **(d)**（门阶梯与激活条款属流程/范围承诺变更）。整卡呈交用户。

### Option 3 — 「咨询性观察（不正式化）」

- **名称（一句话）：** 可玩性观察保持咨询性（advisory），记录信号与建议但不设任何阻断权，内容扩张由现有 Gate 2–6 判定与 CR 流程约束。
- **依据：** Charter §12 行记录的替代方向「Treat as advisory only」；Systems §9.2 观察项仍可作为咨询输入保留；现有门语义（Gate 2–6 `not_run / not_ready`，无 runtime 证据）使正式门此时无可校准判据。注意：revision-02 #6 已把「正式化」设为 `user_confirmed` 候选方向，本选项作为被记录在册的替代保留（未选项不删除、不静默推广）。
- **影响：**
  - 产品：内容扩张门控回归现有 gates；可玩性风险可能到后续 gate 观察时才发现。
  - 创意：观察项作为给 Director 复审与 QA 观察的 advisory 参考，无阻断力。
  - 技术：免去门判据/门权威设计成本；但仍需最小观察协议，否则连 advisory 信号也无载体。
  - 范围：范围保护最弱（无专门可玩性阻断）；依赖 CR 流程与 Gate 2–6 兜底。
  - 进度：排程最轻；但 cr-202 的「正式门可阻止内容扩张」收益不落地。
- **风险：** cr-202 行原文「风险：正式门成本 vs 咨询性降级」——咨询性降级 = 可玩性缺陷可能在内容扩张后才被 gate 捕获；回滚/验证成本：不建门即无门回滚负担（≈0），验证成本 = 仍需最小观察协议与未来 runtime 观察才能产生信号。
- **候选阈值标注：** 无正式阈值；若观察协议内出现任何参考区间，一律「仅候选，须经 CR + 用户批准才成为正式门槛」。
- **与 Gate 2–6 衔接：** 不建门；观察信号作为 Gate 2–6 既有判定的 advisory 输入（由 QA 按现有证据规则处理）。
- **D2 标注：** 本选项自身**不命中 (b)/(d)**（不写入 Gate 判据、不改变 promise/immutable/platform 承诺）。但依据 AUTH-01 §8.2.3「凡含 (a)-(e) 的选项即使同卡其余选项不升级，该卡也呈交用户」——本卡因 Option 1/2 命中 D2 类别，**整卡仍呈交用户**；用户选定本选项后，cr-202 在决策层面记为 `user_confirmed`（用户选择「不正式化」），细节仍走既有 absorptive/advisory 途径。

## 4. 专业推荐（唯一）

**推荐 Option 2「分阶正式化」。**

- **一句理由：** 在零 runtime 证据（Gate 2–6 全 `not_run`）、判据无观测基线、且「静态文档不能通过门」已确认的前提下，先形式化判据构成与观察协议（结构即日可评审）、把阻断权推迟到真实观察证据校准并经 CR + 用户批准后激活，是唯一同时满足「正式门可阻止内容扩张」候选方向、PRECHARTER-04「不锁未验证常数」、以及验收必须真实 runtime 观察的路径。
- **异议（并列）：**
  - 若用户期望最强范围保护且接受首判据未经校准：Option 1 更直接（成本 = 早期 runtime 观察排程 + 未校准阈值风险）。
  - 若用户优先排程最轻：Option 3 更轻（代价 = cr-202 正式门收益不落地）。
- **依赖（并列）：**
  - **QA 门权威结构依赖：** 门裁决执行（verdict/block/retest、独立观察、证据审计）属 Independent QA/Release 权威（Charter §6/§10；Matrix §3.2 #7）——其「门权威结构」由独立 QA/Release 成员按 CR §7 另行制备，本判据部分必须与其衔接；本文件不代做该部分。
  - **判据所需观察证据类型：** 真实 runtime 观察（Gate 2 起 deterministic/runtime 证据：fixture、seed/tick、输入序列、trace、observer/verdict 记录——Systems §11 QA handoff 五项 + Charter §10 证据字段）；静态/Anchor/截图不可替代 runtime（Charter §10）。
  - **与 Gate 2 的关系：** 可玩性门以 Gate 2 证据为载体、**叠加而非替代**；Gate 2 仍为 deterministic/runtime 主门，QA final pass/block 不变；当前无 runtime 证据 → 首次判定只能是 `not_run / not_ready`。

## 5. 判据构成提案（正式化所需 —— Systems 判据部分；提案内容，非批准）

> 下列全部为 `team_proposal` 级别的判据构成。任何数值/阈值均为「**仅候选，须经 CR + 用户批准才成为正式门槛**」，不写入合同/ADR，不提升任何候选预算。

### 5.1 玩家可见行为信号（Player-Visible Behavior Signals）

| 信号 ID | 观察内容（源自 Systems §9.2 / revision-02 #6 / Charter §6） | 溯源 |
|---|---|---|
| S1 | 移动因果：移动引起下一次自动攻击的可读变化 | revision-02 #6；Charter §6；Systems §9.2 ① |
| S2 | 清屏/空间恢复：攻击/击杀结果降低压力、恢复走廊或移动空间 | revision-02 #6；Charter §6；Systems §9.2 ② |
| S3 | 同源强化理解：`穿透 → 扇裂` 被理解为同一来源变强；中心+左右弧不遮蔽玩家/危险/波/空间；B2 理解 | revision-02 #6；Charter §6；Systems §9.2 ③④ |
| S4 | 失败立即重试：失败后无惩罚性延迟地立即重试 | revision-02 #6；Charter §6；Systems §9.2 ⑤；约束于决策 #5/#12 与 PRECHARTER-11 |

补充说明（提案级）：S1–S4 为**必选信号**；观察须覆盖「代表性输入 → 可观察规则/状态变化 → 反馈 → 下一决策」链（Systems 合同 §2 循环合同文本），但本卡不新增任何未既定事实。

### 5.2 观察方法（Observation Methods）

1. 结构化观察协议：seed/tick 固定（PRECHARTER-01）+ 预置 fixture（Systems §5.3 fixture 字段 + §11 QA handoff 矩阵）驱动的真实 runtime 航行；记录输入序列（Matrix §6 `input_sequence_ref`）。
2. 独立观察：由 Independent QA/Release 按 Gate 规则观察并记录 verdict/block/retest（Charter §6/§10）；观察者身份、build/config 身份、fixture/seed 等强制 preflight/start 字段先行（Charter §10）。
3. 记录字段：evidence_id、observer、verdict、unresolved_deviations、retest 链（Matrix §6 信封字段按 QA 门权威结构最终定稿）。
4. 证据类别边界：runtime 观察为唯一可过门证据；静态/Anchor/截图不可替代（Charter §10）；无证据 = `not_run`，不是 pass。

### 5.3 阻断 / 放行规则（Block / Release Rules）

- **阻断（block）：** 任一必选信号（S1–S4）无真实 runtime 观察证据，或观察未达（仅候选）阈值 → 门判定 `not_ready`，内容扩张候选不得进入下一阶段（正式门可阻止内容扩张——cr-202/Charter §12）。
- **放行（pass）：** 全部必选信号均有真实 runtime 观察、达（仅候选）阈值、由 Independent QA 独立观察并记录 verdict → 记录门 pass。
- **状态语义：** 无 runtime 证据 → 门保持 `not_run / not_ready`，**永不「静态通过」**；静态文档/静态 prose/Anchor 不能通过门（revision-02 #6；Charter §6；Systems §9.2）。
- **激活语义（Option 2 专属）：** 阻断权激活 = 校准报告（基于真实观察）+ 命名判据阈值 CR + 用户批准；激活前门输出 advisory 状态。

### 5.4 阈值声明（强制标注）

本文件出现的任何判据数值、区间、判定边界均为「**仅候选，须经 CR + 用户批准才成为正式门槛**」；候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 1280×720 红线与本卡无涉且继续保持仅候选（CR §9/§8.2.4）。判据阈值的形态（如：发生率、延迟窗、理解通过判据等）待真实观察后以 ledger 行（Systems §10：range/starting_point/assumption/dependency/signal/promotion_authority/stop-rollback）提出，`promotion_authority` = User。

### 5.5 与 QA 门权威结构的衔接依赖（不代做）

- Systems 交付：判据构成（§5.1–5.3）+ 期望观察事实（Systems §11 QA handoff）。
- Independent QA/Release（另行制备）交付：门权威结构（门裁决执行、独立观察、verdict/block/retest 授权、证据审计）。
- 衔接点：门的位置/激活条款必须以 QA 门权威结构落定为准；本判据部分不定义 QA 如何裁决、不替代 QA 预检；两部分的合并评审由父协调器装配为最终选项卡片供用户选择。

## 6. 决策后记录规则 / 决策窗口 / 批准后 owner 与验收标准（CR §8 模板）

- **决策后记录规则：** 用户选择某选项 → 记为 `user_confirmed`（provenance = 用户决策），并更新 cr-202 状态与相关合同/Gate 判据 status 字段；其余选项保持 `unresolved` / `team_proposal`（不删除、不静默推广）；若选定项把判据/门语写入发布承诺或发布文案（本期 P1 不发布，无渠道承诺）或改变 promise/immutable/core scope → 走 `reauthorize_charter` 路径（触发条件按 CR §6 Producer note）。
- **决策窗口与截止依赖：** Batch 2，与 DC-ACC-02 同期，在范围扩张讨论前；独立于 DC-PERF-01/DC-ACC-01 可并行。
- **批准后的新 owner：** Systems/Rules（判据与观察协议维持、阈值走 ledger）；Independent QA/Release（门权威/独立观察，其结构为本卡衔接依赖）；Executive Producer/Lead Producer（排程、证据装配、决策窗口执行）。
- **批准后的验收标准：** 真实 runtime 观察（**Gate 2 起，现仍 `not_run`**），由 Independent QA 独立观察并给出 verdict；静态文档不能通过门；首次门判定前强制 preflight/start 证据完备（Charter §10）。

## 7. 分层声明与不变量保留

- **`user_confirmed`（本卡引用，未新增）：** 22 项原始决策；revision-02 #6 候选方向（「正式化」为候选、判据须观察、静态文档不能通过）；PRECHARTER-01..11；Gate 语义现状（Gate 0/1 静态复审就绪、Gate 2–6 `not_run / not_ready`、无 runtime 证据）；Batch 1 决策（DC-PLAT-01→P1；DC-ARCH-01→A1；DC-PLAT-02→Option 2）；AUTH-01（P1–P3、D1–D3、硬边界）——含 D2 升级类别 (b)/(d)；cr-202 `needs_user_decision`。
- **`team_proposal`（本卡产出物级别）：** 全部选项（§3）、判据构成提案（§5）、专业推荐（§4）。不因本文件而升为任何产品/流程决策。
- **`assumption` / `unresolved`：** 未新增假设；正式化与否、门位置/激活条款、判据阈值与观察证据均保持 `unresolved` 或仅候选，**全量保留**（不变量）。
- **不变量保留声明：** 22 项原始 user_confirmed（Charter §6）未改写、未重分类；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（8+1，无第九项）；PRECHARTER-01..11 全部保留；四层 provenance 全程区分；unresolved 全量保留；候选预算保持仅候选。本文件为**新增唯一产物**，未修改任何其它文档（含 Systems 合同本体、CR 台账、Charter、Tech/UX 合同、ADR）。

## 8. 边界声明与 closure

- 本文件未替用户选择「可玩性门是否正式化」；未批准或冻结任何合同/ADR；未豁免 QA blocker；未替 Independent QA 下 verdict；未制作 QA 门权威结构（衔接依赖见 §5.5，由独立 QA 成员另行交付）；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未读取授权清单之外的任何文件（含 DSH playbook 等任务外路径）。
- **Evidence inspected（static/source only）：** `DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（全 439 行）；`KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md`（全 329 行）；`CHANGE_REQUESTS_v0_1.md`（全 345 行）；`KICKOFF_CROSS_REVIEW_MATRIX_v0_1.md`（全 259 行）。
- **Closure:** `closure_ready = yes` **仅对本静态选项产物**；非 kickoff pass、非实现授权、非合同批准、非验收 verdict。Kickoff 仍 `not_ready`；implementation 仍 `NOT_AUTHORIZED`；Gate 2–6 仍 `not_run / not_ready`。