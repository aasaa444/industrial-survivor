# RELEASE-POLISH USER ANCHORS v0.1 — 两条用户产品意图锚点登记 + 影响评估

> **Status:** `USER-INTENT ANCHOR REGISTRATION — 仅登记两条已确认用户产品意图 + 评估其对现有文档/排程的影响`（2026-08-17 用户对话 + 选项卡片确认）。
> **Role / owner (sole author):** Executive Producer / Lead Producer（执行制作人 / 首席制作人）
> **Report ID:** `RELEASE_POLISH_USER_ANCHORS_v0_1`
> **Expert capability:** `godot-executive-producer-expert` — 实测 `skill({name:"godot-executive-producer-expert"})` **调用成功**（返回完整 SKILL 指令；未发生 unknown tool / 接口不存在错误）。能力证据等级 = `strong_direct_skill`（首选等级；本运行时 `skill` 接口实测可用，`tools.skill` 包装器非独立存在，以直接 `skill(...)` 成功）。无需 fallback 到 SKILL.md 读取。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本文件仅依据任务允许的指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未派发任何成员）。
> **Lifecycle / authorization context:** 实现授权生效（R13，契约内 ADR-TECH-01..06 + 已决决策范围；候选预算不提升、QA 不豁免、GDMCP 预检前置）；单元 4（终结/重置）波 1 正在实现中（Systems T1 / Engineer T2-T4 / UX T5，QA 未回）—— **与本次登记无冲突、可并行**；Gate 3–6 未验收。

---

## 0. 本任务边界（一句话）

本文件只完成**两条用户产品意图锚点的登记固化 + 影响评估**，给出**与 CR 台账的衔接建议**（编号/格式建议，供后续 Doc Scribe 依据采纳，**不改写 CR 台账正文**）。不构成实现授权、不预授权视觉/美术启动、不改变平台承诺、不触发 reauthorize_charter、不变更单元 4 推进节奏、不下 QA verdict。

---

## 1. 锚点登记（两条，均已 `user_confirmed`）

### 锚点 A — 「精致」质量硬标尺（产品级）

| 字段 | 纪录 |
|---|---|
| 锚点 ID | `ANCHOR-POLISH`（本文件内部引用名；CR 衔接建议见 §3） |
| 用户原话（来源原始表述） | 「这个游戏绝不会按『玩具』标准制作，最终交付为**肉眼明显精致的成品游戏**」 |
| Provenance | 2026-08-17 用户对话确认 — `user_confirmed`（产品意向；用户明确陈述，非团队提案） |
| 分层 | `user_confirmed` 产品意向（质量硬标尺）—— **不构成实现授权**（见 §1.3） |
| 落点（范围） | ① 视觉/美术/动画（最终美术目标 + 动效一致）；② **手感/反馈一致性**（动作反馈、节奏、手感链路的统一达标）；③ **验收**（Gate 3 精致度验收标的上的硬标高；作为后续视觉/UX 验收标准的约束面） |
| 与既有视觉基线的衔接 | 视觉方向「锈蚀末日霓光」`user_confirmed` + Anchor v0.1（用户接受基线）+ Style Manual v0.2（提案）+ GDD §7/§13 最终美术目标 —— **均为引用**；本锚点是其上的**产品级硬标尺**（提升验收要求，非替换上述任何基线；v0.2 仍为候选、需 Director 复审 + 用户决定） |
| 不构成 | 不预授权视觉/美术启动；不自动批准 Style Manual v0.2 / Anchor v0.2 / 最终资产 / 资产生产；不视为 Gate 3 已通过 |

**判定（本锚点性质）：** 用户已明确陈述的产品质量标准 → **已经 `user_confirmed`，非待决需求**。登记为产品级硬标尺，供后续视觉/美术/动画/手感/验收阶段对标；**当前阶段只登记、不吸收进任何具体行列与实现**。

### 锚点 B — 「完整游戏＋发布门必须」（发布目标）

| 字段 | 纪录 |
|---|---|
| 锚点 ID | `ANCHOR-RELEASE-MUST`（本文件内部引用名；CR 衔接建议见 §3） |
| 用户选择来源 | 2026-08-17 用户经选项卡片选择 **Recommended**（「完整游戏＋发布门必须」） |
| 含义 | ① 正式 Demo/产品目标是**未来可发布成品**；② **Gate 5/6（导出/发布门）为必须项**；③ **发行平台与时间权保留用户**（不锁死平台、不触发 reauthorize_charter） |
| 分层 | `user_confirmed` 产品意向（发布目标）—— **final goal 姿态** |
| 与 P1 的关系（不冲突） | **P1（cr-103，DC-PLAT-01 → Option P1）是『本期』姿态**——本期不发布、无渠道/商店/发布文案承诺；**锚点 B 是『最终目标』**——未来可发布成品、Gate 5/6 必须。两者时间尺度不同、不矛盾：P1 约束「当前 units 不得提前写死发布承诺」，锚点 B 确立「Gate 5/6 与未来可发布性是最终验收目标」。 |
| 与现有决策的衔接 | DC-PLAT-01 → P1（Windows x86_64 单导出、本期不发布，Gate 6 内部复审姿态）；DC-REL-01 → O2（evidence-complete release）；cr-103（P1：无商店/渠道/发布文案承诺）—— **均为引用**；Anchor 不与上述任一冲突，只在「最终目标」层面明确 Gate 5/6 必须 |
| 平台/时间权 | **保留用户**：本登记不命名发行平台、不承诺时间、不触发 reauthorize_charter（见 §1.3） |
| 不构成 | 不批准/派发任何导出/发布；不改变 Gate 5/6 `not_run` 状态；不授权发布；平台承诺仍由用户决定 |

### 1.3 不变量与授权边界核验（本登记未跨越）

- **不构成实现授权：** 两条锚点均为「产品意图登记」，任何一项都不让位为 Art/Engineer/Release 的开工授权；实现授权仍限于 R13 已批契约（ADR-TECH-01..06 + 已决决策范围），本登记不含新授权。
- **不改变平台承诺：** 锚点 A/B 均未命名发行平台/渠道/时间；保留 cr-103（本期不发布）、Charter §12 「Retain PC-first without a release-platform commitment until the User chooses」。
- **不触发 reauthorize_charter：** 无 promise/immutable/platform/release 承诺被改动；Gate 5/6 必须性是对「最终目标」的确认，不是对本期 Gate 判据/发布承诺的写入。
- **不变更单元 4 推进节奏：** 锚点 A 涉及视觉/美术/手感（单元 4 不触碰美术/发布）；锚点 B 涉及 Gate 5/6（单元 4 为终结/重置，`NEXT_IMPL_UNIT_PLAN_v0_4` §8 范围边界明确「导出/发布不进」）。**两者均不改变单元 4 排程、不派发、不并行阻塞。**
- **不变量保留：** 22 项原始 `user_confirmed`；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；unresolved 全量；候选预算（六项 + `1280×720` 红线）仅候选 —— 本登记未改动上述任何一项、未升级任何 `team_proposal`/`assumption`/候选数值。

---

## 2. 影响评估（对现有文档/排程/后续阶段）

> 预期结论：**不改排程节奏、不影响单元 4；仅为后续视觉/发布阶段确立标尺。** 分项如下。

### 2.1 对 Gate 5/6（导出/发布门）与发布阶段

- **现状：** Gate 5（Export smoke）/ Gate 6（Independent release review）定义存在但 `not_run / not_ready`（Charter §3 门状态 + §10 QA Gate 表）。
- **关系：** 锚点 B 明确「Gate 5/6 为必须项 + 未来可发布成品」——这是对这些门的**最终目标姿态确认**，**不改变它们当前 `not_run` 状态、不改写 Gate 判据、不触发导出/发布。**
- **影响：** 为 Gate 5/6 的**未来准备**确立方向（Gate 5/6 将作为可发布性的必须门槛），但具体判据、证据包、放行仍待后续阶段（M7 发布/导出/平台 = 用户里程碑，授权清单 §6；cr-113 O2 evidence-complete 承接）。Anchor B 使后续发布阶段不会被误读为「可不做导出/发布门」。

### 2.2 对视觉/美术/动画/手感阶段（锚点 A）与 Gate 3

- **现状：** 视觉方向「锈蚀末日霓光」`user_confirmed`；Anchor v0.1 用户接受（基线）；Style Manual v0.2 提案（awaiting Director + user）；GDD §7/§13 最终美术目标；Gate 3（Visual/UI）`not_run`。
- **关系：** 锚点 A 设立「肉眼明显精致的成品游戏」产品级硬标尺，且明确包含**手感/反馈一致性**与**验收（Gate 3 精致度）**。
- **影响：** 收紧了**未来**视觉/美术/动画/UX 验收的及格线（高于「玩具」标准、要求手感/反馈链路一致），但**不预授权视觉/美术/动画启动、不批准 Style Manual v0.2、不通过 Gate 3**。Gate 3 视觉验收仍是用户保留里程碑（M2，授权清单 §6；DC-ACC-02 B3）。Style Manual v0.2 仍为候选、需 Director 独立复审 + 用户最终审美接受。
- **精致度验收落点（未来）：** 建议后续视觉/UX 阶段把「肉眼可辨精致（非玩具）」拆为可观察验收面（美术最终度 / 动画与反馈时序一致 / 手感节奏统一），但具体判据与阈值仍留 Gate 3 / 用户里程碑，本登记不代决。

### 2.3 对 Dev Charter / GDD / 授权清单 / 当前逐单元推进

| 面 | 影响 |
|---|---|
| **Dev Charter v0.1** | `不变`。锚点 A/B 均未改写 Charter 正文；release/platform 边界（§6/§12）与 Gate 门状态保持原样；无 promise/immutable/platform/release 变更 → reauthorize 未触发。 |
| **GDD v0.1（§7/§13）** | `不变`（本登记不改写 GDD）。锚点 A 引用并**提升**其视觉/手感验收意图；GDD §7/§13 最终美术目标仍为静态设计基线，非本登记取代。 |
| **授权清单 `AUTHORIZATION_WORKLIST_D2_PRE_v0_1`** | `不变`。M2（Gate 3 视觉验收）、M7（发布/导出/平台承诺）仍为授权边界外用户里程碑；锚点 A/B 分别与 M2/M7 **目标一致并强化其必要**，不预授权 M2 或 M7。 |
| **单元 4 排程 `NEXT_IMPL_UNIT_PLAN_v0_4`** | `不受影响`。单元 4（终结/重置）不触碰美术/发布；锚点 A/B 不改变其范围、验收路径、AUTH-01 判定或节奏。 |
| **Style Manual v0.2（视觉基线候选）** | `引用不改写`。锚点 A 是产品级硬标尺（非替换 v0.2）；v0.2 保持 `draft`、awaiting Director + user 最终审美接受。 |
| **候选预算 / 其他 unresolved** | `不变`。六项候选 + `1280×720` 红线仅候选；unresolved 全量保留。 |

**总预期：** 两条锚点均为「最终目标/硬标尺」登记，是**未来视觉/发布阶段的对标基准**；当前 unit 4 与整体逐单元推进节奏不受任何影响。

---

## 3. 与 CR 台账的衔接建议（供后续 Doc Scribe 依据采纳 — 本文件不改写台账正文）

> **重要：** 本节是**建议**，不修改 `CHANGE_REQUESTS_v0_1.md` 正文。以下编号/格式为推荐提案，最终由父协调器派发的 **Doc Scribe** 依据团队纪律采纳后方落账。

### 3.1 现状核对（编号序列）

- CR 台账现有编号：Cluster ① 规则 `cr-001..020`；Cluster ② 平台与验收 `cr-101..114`；Cluster ③ 治理/邻近 `cr-201..203, cr-301`。
- 发布相关现有：`cr-103`（P1：本期不发布）、`cr-113`（DC-REL-01 → O2 证据完整放行）。
- 视觉/邻近现有：`cr-301`（Anchor 基线是否升级 v0.2，已决策 Option 1 维持 v0.1）。

### 3.2 建议 CR 编号与登记

| 建议 CR | 关联锚点 | 待决项核心 | 受影响决策面 | 建议 disposition |
|---|---|---|---|---|
| **`cr-115`** | 锚点 B「完整游戏＋发布门必须」 | 正式 Demo/产品目标 = 未来可发布成品；**Gate 5/6（导出/发布门）为必须项**；平台与时间权保留用户（不锁死、不触发 reauthorize） | 发布/Gate 5-6 / cr-103(P1) / cr-113(O2) / Charter §12 platform | **`absorb_within_authority`**（用户已确认的最终发布目标，登记为 Gate 5/6 未来准备的标尺；不改变本期 P1「不发布」姿态、不命名平台/时间；Gate 5/6 判据与放行仍留后续阶段 + 用户） |
| **`cr-302`** | 锚点 A「精致」质量硬标尺 | 用户明确不按「玩具」标准制作；最终交付 = 肉眼明显精致的成品游戏；覆盖视觉/美术/动画 + 手感/反馈一致性 + Gate 3 精致度验收 | 视觉/美术/动画 / 手感反馈 / Gate 3 精致度验收 / cr-301(Anchor) / cr-114(视觉可用性验收) / GDD §7/§13 | **`absorb_within_authority`**（用户已确认的产品质量标准，登记为后续视觉/UX/动画阶段的验收硬标尺；不构成实现授权、不预授权视觉/美术启动、不通过 Gate 3；精致度判据留给 Gate 3 / 用户里程碑 M2） |

**disposition 判据说明：** 两条锚点均已是 `user_confirmed` 用户明确意向，**不是待决疑难项**，故建议 disposition = `absorb_within_authority`（作为已确认边界，后续工作在其内提案/证明），而非 `needs_user_decision`（无需再呈报新决策——平台/时间权与精致度判据仍各自保留用户，但那是既定里程碑而非本次新决策）。两者均**未触发 `reauthorize_charter`**（无 promise/immutable/platform/release/charter 变更），也未建议 `reject`/`defer`（均为有效最终目标登记）。

### 3.3 建议落账格式要点（给 Doc Scribe）

- 延续 §3 CR 注册表格式（cr_id / 待决项·来源原始表述核心 / 当前 Charter 版本·受影响 immutable / 产品创意技术范围进度影响 / 被挤出工作·依赖·风险·回滚 / disposition）。
- Provenance 标注：锚点 A = `user_confirmed`（2026-08-17 用户对话）；锚点 B = `user_confirmed`（2026-08-17 选项卡片选 Recommended）。
- 在 §6 Producer disposition summary 增加两行计数；在 §7 decision batching 不新增需决策卡（两条均为已确认意向，非 needs_user_decision）。
- 明确 `reauthorize_charter` 未触发之注记（对齐既有各批次结论表述）。

---

## 4. 明确不做（Boundary — 本任务未执行）

- ✅ **未改写任何既有文档正文**：CR 台账、Dev Charter、GDD、Style Manual、ANCHOR_DECISION、授权清单 `AUTHORIZATION_WORKLIST_D2_PRE_v0_1`、单元排程 `NEXT_IMPL_UNIT_PLAN_v0_4`、CREATIVE_BRIEF、SLICE_PRECHARTER —— 全部只读；唯一写入 = 本文件 `RELEASE_POLISH_USER_ANCHORS_v0_1.md`。
- ✅ **未改变平台承诺**：未命名发行平台/渠道/时间；保留 cr-103 P1（本期不发布）+ Charter §12 platform 边界。
- ✅ **未触发 reauthorize_charter**：无 promise/immutable/platform/release/charter 变更；Gate 5/6 必须性为「最终目标」确认，非本期 Gate/发布承诺写入。
- ✅ **未改变当前单元 4 推进**：终结/重置排程与节奏不受影响；本登记不派发、不并行阻塞。
- ✅ **未预授权视觉/美术启动**：锚点 A 是质量硬标尺，不批准 Style Manual v0.2 / Anchor v0.2 / 最终资产 / 资产生产 / 动画 / 音频。
- ✅ **未批准/派发任何导出/发布**：Gate 5/6 保持 `not_run`；平台/时间权留用户（M7）。
- ✅ **未替 Independent QA 下 verdict**：无 QA 结论；Gate 3–6 未验收状态不变。
- ✅ **未豁免 QA / 未替 Systems/UX/Tech/QA 代权**：语义/数值/验收均未代决。
- ✅ **未调用嵌套派发**：本会话未调用 `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。

---

## 5. Provenance 分层与不变量保留

- **`user_confirmed`（新增登记，源自用户明确意向）:** 锚点 A「精致」质量硬标尺（2026-08-17 用户对话：绝不按玩具标准、肉眼明显精致成品游戏）；锚点 B「完整游戏＋发布门必须」（2026-08-17 选项卡片选 Recommended：未来可发布成品 + Gate 5/6 必须 + 平台/时间权留用户）。**除这两条新登记外，其余 `user_confirmed` 均仅引用、不新增、不重写、不重分类。**
- **`team_proposal`（本文件的实质贡献）:** 两条锚点的**登记固化**（ID/原话/provenance/分层/落点/权限边界）、**影响评估**、**CR 衔接建议**（cr-115 / cr-302 编号 + `absorb_within_authority` disposition + 落账格式要点）。全部为登记与建议，不升级任何契约/数值、不构成实现授权。
- **`assumption`:** ① 锚点 A 可被拆为未来可观察的精致度验收面（美术最终度/动画与反馈时序一致/手感节奏统一，需后续视觉/UX 阶段拆判据并用证据验证）；② 锚点 B 与 cr-103(P1) 的时间尺度分离（本期不发布 vs 最终可发布）需后续 Gate 5/6 准备阶段落地验证。均未在此代决。
- **`unresolved`（全量保留，未关闭）:** cr-006..009 精确接触值；cr-010/011 升级触发/XP；cr-012/013 focus 精确语义；cr-014/015 终局/重置精确语义；cr-016..019 B2；cr-009 边界；spawn；life 呈现；结局呈现形态；Style Manual v0.2 待 Director+user；Anchor v0.2 候选；候选预算（六项 + `1280×720` 红线）；Gate 3 精致度具体判据；Gate 5/6 判据与发布平台/时间 —— 全部保持 open，本文件不闭合、不升级任何项。

**不变量保留声明:** 22 项原始 `user_confirmed` / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本登记未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升；未批准/冻结任何契约/规则语义/数值/表现形态；未改变平台承诺；未触发 reauthorize_charter。

---

## 6. 边界声明与 Closure

- **未替用户做产品/验收裁决**：本文件是**意图登记 + 影响评估 + 衔接建议**；精致度判据（Gate 3 / M2）与发布/导出/平台（Gate 5-6 / M7）仍归属 User 与 Independent QA，本登记不代决、不预授权。
- **衔接为建议非落账**：cr-115 / cr-302 编号与 disposition 为**推荐提案**，最终由父协调器派发的 Doc Scribe 依据团队纪律采纳后方落 CR 台账；本文件**未改写台账正文**。
- **未派发任何成员 / 未触碰 Godot / 运行时 / 数值 / 契约**：本登记仅静态只读 + 写入唯一新文件；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未批准/冻结任何契约/数值；候选预算不提升；QA 不豁免。
- **写入面**：仅本唯一登记文件 `RELEASE_POLISH_USER_ANCHORS_v0_1.md`；未修改任何其它文档。

**Closure:** `closure_ready = yes`（仅限本登记文件 artifact）。本文件非实现派发、非契约批准、非 QA 验收、非产品裁决、非发布/导出授权、非结局可玩性门确认；两条锚点已固化，供后续视觉/发布阶段对标。写入后停止，不进入下一阶段、不派发任何成员。

---

## 7. 版本与变更记录

- **v0.1（本文件）:** Executive Producer / Lead Producer 唯一新产物——登记两条用户产品意图锚点：**锚点 A「精致」质量硬标尺**（2026-08-17 对话：绝不按玩具标准 / 肉眼明显精致成品游戏；落点视觉美术动画 + 手感反馈一致性 + Gate 3 精致度验收；不构成实现授权）+ **锚点 B「完整游戏＋发布门必须」**（2026-08-17 选项卡片 Recommended：未来可发布成品 + Gate 5/6 必须 + 平台/时间权留用户；与 P1 本期不发布不冲突；不触发 reauthorize）+ **影响评估**（Gate 5/6 最终姿态、视觉/美术/动画/手感对标、Dev Charter / GDD / 授权清单 / 单元 4 均不受影响，仅确立后续阶段标尺）+ **CR 衔接建议**（cr-115 / cr-302 + `absorb_within_authority` disposition + 落账格式要点）+ **明确不做摘要**。未修改任何其它文档。
