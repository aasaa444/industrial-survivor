# READ MODEL MINIMAL FIELDS v0.1 — S5 最小 player-facing read-model 字段提案

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DESIGN ONLY` — 本文件为 **S5 最小 read-model 字段提案**，仅供 Engineer 落地参考，**不落地实现**。
> **Role / owner (sole author):** UX/UI Designer（UX/UI 设计师）——字段提案 OWNER；**落地归 Engineer**（本单元 S5 落地按 NEXT_IMPL_UNIT_PLAN_v0_1 §5.2/§6，由 Engineer 经 GDMCP 实施）。
> **Report ID:** `READ_MODEL_MINIMAL_FIELDS_v0_1`
> **Expert capability:** `godot-ux-ui-expert` — 实测 `skill({ name: "godot-ux-ui-expert" })` **调用成功**（运行时返回完整 SKILL 指令）。能力证据等级 = `strong_member_skill`（首选等级）。无需 fallback 到 SKILL.md 读取。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本文件仅依据全部指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布）。
> **前置事实（仅可使用这些）:** ADR-TECH-01..06 已批准（R11）；ADR-TECH-02 已含 no-target/attack-resolution/feedback-binding/accessibility/hint 关联（UX 评审 R3–R5 补缺）；UX-03 S1–S3 已固化观察目标（no-target quiet/不伪造）；Gate 2 已通过（最小确定性核心 seam，`QA_GATE2_VERDICT_v0_1.md` verdict `pass`）；本单元范围 = 移动→自动攻击→命中→击杀→清除，接触/升级/B2/终结/focus 延后；候选预算仅候选、本任务不牵扯数值；AUTH-01（R13 实现授权）已生效。

---

## 1. Expert preflight（godot-ux-ui-expert，应用于本 S5 字段提案任务）

- **目标玩家/上下文:** PC-first 单人玩家进入 8 分钟有界 Slice；本单元关键旅程 = 「移动 → 自动攻击指向锁定目标 → 命中 → 击杀 → 清除可见 → 空间/压力缓解」，玩家须可归因「下一次自动攻击结果」（pillar 2）而不被伪造反馈误导。
- **关键理解风险（本字段提案须防）:** ① no-target 若误伪造锁指示/命中 → 违反 UX-03 S1/S2 / ADR-TECH-02 R4 / Systems §5.1 规则 5/6；② HUD 抢占 player/danger/space（UX 合同 §6.2 第一读优先）；③ 反馈类脱离 `hit_results` 因果 → 不可归因、无法支撑 Gate 3 U2/U3 观察。
- **目标窗口/输入条件:** 16:9 基线 + {16:9, 16:10, 21:9} 方向性候选（DC-PLAT-02 Option 2 / R03）；键盘 WASD/方向键；`1280×720` 红线仅候选。
- **范围内状态（本单元）:** combat movement-to-attack / no-target / attack-resolution（hit/kill/clear 可读）+ 最小 HUD 面；**不在范围内**：接触（cr-006..009）、升级（cr-010..011）、B2 三弧（cr-016..019）、终局/重置（cr-014..015）、focus-epoch（cr-012..013）。
- **证据路线:** 本字段提案 → Engineer 落地 → 未来授权 fixture/runtime frame + Independent QA 观察（Gate 3 前段 U2/U3）。本文件只提供 read-model 字段，**不声称任何 runtime/visual 证据**。
- **所有权边界（不代权）:** UX 提案 presentation-facing 字段集；**不代 Systems 定规则语义**（目标/HP/死亡语义归 Systems，S1 薄前置）；**不代 Tech 定 tick/event schema**；**不代 Engineer 落地**（字段落地在本单元归 Engineer 经 GDMCP）；**不代 QA 下 verdict**；不批准/冻结任何合同/数值。
- **停止条件:** 唯一字段提案文件写入即停；不进入实现、不派发任何成员。

---

## 2. 实际工具顺序与专家能力加载（真实记录）

| # | 工具/动作 | 结果 |
|---|---|---|
| 1 | `skill({ name: "godot-ux-ui-expert" })` | ✅ **实测成功**（返回完整 SKILL 指令；未报 unknown tool / 接口不存在）。能力证据等级 = `strong_member_skill`（首选）。按 DSH 实测纪律（2026-08-16），不以函数清单判断接口不可用——已实际发起调用验证。 |
| 2 | 并行 read `NEXT_IMPL_UNIT_PLAN_v0_1.md` / `KICKOFF_UX_UI_CONTRACTS_v0_1.md` / `UX_OBSERVATION_TARGETS_CR001_v0_1.md` / `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` / `QA_GATE2_VERDICT_v0_1.md` / `IMPL_MINIMAL_CORE_v0_1.md` | ✅ 全部实际读取成功 |
| 3 | read `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` 续段（§12/§13/§18） | ✅ 确认 ADR-TECH-01/02 read-model 与 R3–R5 文本、跨角色依赖 |

> **接口实测说明（DSH 实操纪律, 2026-08-16）:** `skill` 接口并非从函数清单假设可用——本次**实际发起调用并成功**，未发生 unknown tool / 接口不存在错误，故不触发 fallback。唯 `tools.skill` 包装器在本运行时不独立存在（直接以 `skill(...)` 调用成功并按 `skill` 返回完整 SKILL）。未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

---

## 3. 设计原则（对齐已批准契约，字段层的硬边界）

1. **presentation 只消费 read-model，不成为规则权威**（ADR-TECH-01）：所有字段必须可回溯到 rules-core trace 字段或域事件；presentation 不得从视觉状态自我推断新规则、不得隐式重算目标/命中。
2. **最小面**：只提本单元（移动→自动攻击→命中→击杀→清除）player-facing 所需字段；接触/升级/B2/终结/focus 相关字段**仅保留结构性占位**（如 B2 阶段枚举本单元恒为前-B2 形态），不扩增至运行时行为。
3. **空射不伪造**（ADR-TECH-02 R4 / UX-03 S1/S2 / Systems §5.1 规则 5-6）：锁指示/lock 类反馈只在 `hit_results` 非空时才有资格 emit；`no_target_branch=true` 的可观察信号不得伴随任何伪锁/伪命中；可选一次性非色彩克制「no-target 提示」只绑定 no-target 分支本身，绝不产生幻影命中。
4. **feedback-binding marker**：每个命中/击杀反馈类都带 `← hit_results` 因果绑定标记，供 Gate 3「反馈类与 hit_results 因果一致」观察直接对齐（UX-03 S2）。
5. **可溯源性**：字段来源分两类——**规则核 trace**（`rules_core.gd` 已落 `target_snapshot_ids` / `no_target_branch` / `next_eligible_fire_tick` / `hit_results` / `resolution_outcome` / `ordered_ids` / `(k1_bucket,k2_bucket,stable_id)` / `refresh_tick` / `lock_tick`，见 IMPL_MINIMAL_CORE_v0_1 §4.4 / QA_GATE2 §2）与**域事件**（adapter 从域输出翻译为 presentation 面向字段）。字段只在 presentation-facing 子集内提案；内部稳定排序细节留在 ADR-TECH-03/04 trace 字段，不进入 read-model（ADR-TECH-02 R3/R4 注记）。
6. **不提升任何数值 / 不冻结布局**：全部字段为命名/类型/来源/用途/证据归属的结构契约；无像素、无阈值、无色值、无 timing、无文字稿。占位表现完全由 Engineer 落地时处理（resource 占位/最小 Control），本提案不涉及视觉布局/资产。

---

## 4. 字段提案（分组）

> 约定：字段名——**类型**——**来源**（`RULES`=规则核 trace 直读 / `EVENT`=adapter 由域输出翻译的 presentation 面向字段 / `SESSION`=session 生命周期）——**presentation 用途**——**证据归属**（UX-02/UX-03/UX-09 等）。

### 4.1 HUD 最小面（对齐 UX 合同 §6.1 / §9 UX-09）——life / timer / B2 阶段

| 字段 | 类型 | 来源 | presentation 用途 | 证据归属 |
|---|---|---|---|---|
| `life` | 结构枚举/分段（三segment 模型，`segments_lost:int(0..3)` + `life_state:enum`） | `RULES`（命中→击杀→清除本单元不直接耗 life；life 语义 Sources=Systems，数值延后）+ `SESSION` run 生命周期 | HUD 恒定三格生存面；本单元无接触伤害，`segments_lost` 恒 0、仅结构呈现；提供「生命优先」观察的字段骨架 | UX-09（HUD life 持久/不被遮挡）；UX-10 终局前段 |
| `timer` | 当前 run 时刻/剩余边界（`current_tick:int` + `run_duration_bound:opaque`（8 分钟，定时值延后 Systems） | `SESSION`（session 驱动 tick，见 IMPL_MINIMAL_CORE session.gd）+ `RULES` run 生命周期 | HUD 顶部/角落时长读数；关联「下一次自动攻击可归因」视角（pillar 2） | UX-09（timer 持久）；UX-02（移动→攻击归因时间窗） |
| `b2_phase` | 枚举（本单元唯一合法值 = 前-B2 形态；`penetration→fission` 结构保留为占位） | `RULES`/`SESSION` 阶段位；B2 三弧语义延后（cr-016..019） | HUD 阶段标签占位，保证「阶段可读」的结构恒在而不引入本单元不存在的 B2 行为 | UX-09（B2 阶段持久）；UX-11（B2 前段全读） |

**最小面说明:** 本单元仅需 life/timer 真实可读 + B2 阶段结构位；三格 life 的 `segments_lost` 只作观察骨架（数值/损失语义属 Systems、接触单元），timer 反映 session 驱动 tick 的确定性边界。不引入 XP/fragments 节点（其竞争可读性，UX §6.1 次序）。

### 4.2 no-target 分支可观察状态（quiet 形态，S1/S2）

| 字段 | 类型 | 来源 | presentation 用途 | 证据归属 |
|---|---|---|---|---|
| `no_target_branch` | bool（`true`=本 fire 周期无合法目标） | `RULES`（`rules_core.gd` 已落 `no_target_branch`，IMPL §4.4） | 驱动「本周期安静 / 可选克制提示」的唯一权威信号；**不得**借此发出锁指示/命中反馈 | UX-03 S1/S2 / U3-A（空 refresh 确定性分支）；UX-02 G4 队列 |
| `no_target_cue_emitted` | bool（一次性、可空） | `EVENT`（presentation 由 `no_target_branch=true` 决定是否 emit 可选一次性非色彩克制提示；**种类为 `team_proposal / unresolved`，非本字段冻结**） | 支撑「可选 no-target cue 与 no-target 分支绑定、绝不独立于分支」的可观察信号；供 U3-D 连续空周期时确认无隐藏反馈 | UX-03 S3（分支可辨）；U3-D 节奏 |

**quiet 形态确认（UX-03 S1–S3）:** `no_target_branch=true` 时，read-model 不携带任何 lock/targeting 数据、不携带任何 hit/kill 负载；唯一允许的额外信号是 `no_target_cue_emitted`（可选、一次性、非色彩、克制）。空 refresh 绝不产生「锁定指示/瞄准框/命中/击杀」反馈（S1/S2 满足）；不把空枪读成对真实目标的 miss、不期待后续命中（G4）。

### 4.3 attack-resolution 状态（锁定目标 / 命中结果，绑定 `hit_results`——feedback-binding marker）

| 字段 | 类型 | 来源 | presentation 用途 | 证据归属 |
|---|---|---|---|---|
| `locked_target`（只读快照，不派生） | `target_snapshot_ids` 的 presentation 子集（本 shot 锁定 ID 集，不可变） | `RULES`（`target_snapshot_ids` 已落，IMPL §4.4 / ADR-TECH-04） | 「自动攻击指向被锁定快照目标」的可观察指示——锁定向玩家可见的目标即锁定集，不实时重定位 | UX-02 N2 / G3（锁定的最近威胁簇中心）；U2-D 首击 |
| `attack_state` | enum（`idle → resolving → resolved`（本 shot 结算完成）；可空 `no_target`） | `RULES`（由 `no_target_branch` + 结算推进）+ `EVENT` | 呈现「本次攻击正在结算/已结算」的归因窗口；`no_target` 分支与 `resolved` 分支区分可读 | UX-02 N2/N3；UX-03 S3（分支可辨） |
| `hit_results_feedback`（**feedback-binding marker**） | 每条反馈类（`hit` / `kill` / `no_hit_invalid`）绑定所属反馈的 `hit_results` 因果 ID | `RULES`（`hit_results` / `resolution_outcome` 已落）+ `EVENT`（presentation 仅当 `hit_results` 非空才 emit 反馈类） | **核心不伪造闸门**：任何 lock/hit/kill 反馈类必须携带此 marker 且仅在 `hit_results` 非空时 emit；`no_hit_invalid`（锁定后失效目标，`resolution_outcome`）不带伪命中 | UX-03 S2 / U3-C（锁定后移除→无幽灵命中）；UX-02 N3 |
| `kill_state` | enum（`none → killed`（本单元击杀→清除的最小结算态）） | `RULES`（S2 kill 路径新增的死亡/清理语义，来源归 Systems 薄前置）+ `EVENT` | 「击杀→清除→压力降低→空间恢复」可观察闭环的击杀面 | UX-02 N4（结果→空间）；slice 完成判定 |
| `invalidation_event`（presentation 可见部分） | `invalidation_event(id,tick)` 的可观察节（仅「本 shot 目标失效、无命中」信号，不展开内部 drain 细节） | `RULES`（`invalidation_event(id,tick)` 已落，ADR-TECH-04 / IMPL §4.4） | 支撑「失效目标不产生命中、下一 shot 才生效」的可读表述；U3-C 无幽灵命中 | UX-03 S2 / U3-C |

### 4.4 边界说明（最小面外延/延后字段——不提案或仅结构占位）

- **内部分级策略细节不进入 read-model**：`ordered_ids` / `(k1_bucket, k2_bucket, stable_id)` / `refresh_tick` / `lock_tick` 等内部稳定排序与快照时序字段属 ADR-TECH-03/04 trace（Gate 2 已验），**不进 presentation 子集**（ADR-TECH-02 R3/R4 注记）。
- **B2 / contact / upgrade / terminal / focus-epoch** 均不在本单元：不新增其 runtime 字段，仅保留结构位（如 `b2_phase` 枚举形态、`attack_state` 可扩展态）。**不挤入**。
- **hint valid-move 关联（ADR-TECH-02 UX R3 提到的 hint 关联字段）**：本单元**不提案** `hint` 字段——hint 文稿/触发/effective-movement 均为 `unresolved`（UX §6.3）；本单元最小面不含 causal hint，Engineer 不得擅自落地 hint 关联字段（留后续单元）。此为一处**明确排除提案项**。

---

## 5. 空射不伪造形态确认（UX-03 S1–S3 原则 → read-model 落地形态）

| 原则 | read-model 落地形态（供 Engineer） | 证据面 |
|---|---|---|
| **S1 无伪造目标（无锁指示）** | `no_target_branch=true` 时：`locked_target`=空/不呈现瞄准框；`attack_state` 可= `no_target`（而非 `resolved-with-hit`）；绝无 `hit_results_feedback` 负载 | U3-A / U3-B（邻接边界目标）；UX-03 S1 |
| **S2 无伪造命中（反馈绑定）** | `hit_results_feedback` marker 保证 hit/kill 反馈只在 `hit_results` 非空时 emit；`kill_state` 只在真实死亡/清理时置位；失效目标（`invalidation_event`）绝不产生 `hit_results_feedback` | U3-C；UX-03 S2 |
| **S3 分支可辨（quiet 不惩罚）** | `no_target` 分支与 normal `resolved` 可区分；可选 `no_target_cue_emitted`（一次性、克制、非色彩）仅供「分支可辨」、不承担节奏/计时惩罚信息（`timer_effect` 空白，无隐藏惩罚） | U3-D；UX-03 S3 + pillar 4 |
| **G4 无幻影期望** | `no_target_branch` 的呈现不引导玩家「回探空区期待命中」；呈现保持中立安静 | UX-02 G4（与 UX-03 联动） |

> 以上全部为**形态/信号约束**，无数值、无布局、无色彩；Engineer 落地时以占位/最小表现承担，不触碰承诺（cr-005 quiet-cycle 为吸收路径内实现，不冻结形态为批准）。

---

## 6. 与 UX-02/UX-03 观察目标的衔接（支撑未来 Gate 3）

本字段集为未来 Gate 3 前段（U2/U3 场景）提供**可直接对齐的可观察信号**：

### 6.1 对接 UX-02（movement → next automatic attack → clearing，CR001 §3）

- **U2-A（同场景重复，G1 稳定可重复性）:** 以 `locked_target`（由 `target_snapshot_ids` 派生、不可变）+ `attack_state` 跨 run 对比——`locked_target` 逐位一致 → 归因稳定。
- **U2-B / U2-C（移动改变/不改变簇构成，G2 移动因果）:** 以 `locked_target` 的 before/impact 变化反映移动对下次攻击锁定集的因果；对照场景（簇不变）下 `locked_target` 不变即可独立验证。
- **U2-D（最近威胁簇中心首击，G3 感知威胁对应）:** 以 `locked_target` + `hit_results_feedback`（首击命中帧）顺序核对锁定目标与命中结果因果。

### 6.2 对接 UX-03（no-target quiet & non-misleading，CR001 §4）

- **U3-A（空 refresh 确定性分支，S1/S2）:** `no_target_branch=true`，且 read-model 无任何 lock/hit 负载（`locked_target` 空、`hit_results_feedback` 空）→ 反证无锁指示/无命中。
- **U3-B（邻接边界目标，S1/S3）:** 边界外目标 → `no_target_branch=true`，不得出现误导性 lock。
- **U3-C（锁定后目标移除，S2 / cr-004 (i) 联动）:** `invalidation_event(id,tick)` 的 presentation 节 → `hit_results_feedback` 无 `no_hit_invalid` 虚拟命中；下一 shot 才生效。
- **U3-D（连续空周期节奏，S3 + pillar 4）:** `attack_state`/`no_target_cue_emitted` 时间线 + `timer_effect` 空白（无隐藏惩罚）。

### 6.3 支撑 UX-09 / UX-13（可读性/无障碍基础）

- `life` / `timer` / `b2_phase` 即 §6.1 最小 HUD 面（UX-09 观察：player/danger/space 不被 HUD 遮挡——本提案不设计布局，仅保证字段先于布局存在）。
- 全部色彩可辨字段（`attack_state` / `no_target_cue_emitted` / `hit_results_feedback` / `life` loss）均需以**非色彩/非仅色彩**方式可读（UX-13 / §7 非色彩通信）——字段本身携带结构化信号，不依赖色值。

> 观察执行依赖未来授权 fixture + runtime frame + Independent QA 独立观察（Gate 3 前段），**本提案不执行、不声称观察**。

---

## 7. 边界说明（字段提案 vs 落地）

- **只提案字段，不落地实现**：本文件为字段契约；Engineer 经 GDMCP 在本单元 S5 落地（运行时场景/HUD 字段映射）。UX 不写 `.gd`/`.tscn`/`.tres`，不触碰 Godot。
- **字段不涉及视觉布局/资产**：无 pixel/threshold/font/color/asset/动画；占位表现归 Engineer。
- **不提升任何数值**：life segment 数、timer 时长、kill 结算等均为结构/来源契约，数值语义归 Systems/adapter，未提升。
- **未触碰 contract 冻结/QA 豁免**：未批准/冻结任何 ADR/Systems 终裁/fixture schema；未豁免 QA 门；未替 QA 下 verdict。
- **写入面**：仅本唯一字段提案文件 `READ_MODEL_MINIMAL_FIELDS_v0_1.md`。未修改任何其它文档。

---

## 8. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；cr-001 Option A (R09)；ADR-TECH-01..06 批准 (R11)；UX-03 S1–S3 固化观察目标（R-crystallized）；AUTH-01 (R13 实现授权)。本文件不重写、不重分类任何一项。
- **`team_proposal`（本文件实质贡献）:** 最小 player-facing read-model 字段集分组提案（§4）；空射不伪造落地形态确认（§5）；与 UX-02/03 Gate 3 衔接（§6）；`no_target_cue_emitted` / hint 字段的排除/候选标注。全部为字段提案，供 Engineer 落地参考，**不升级任何契约**。
- **`assumption`:** ① 生命/timer/B2 为 presentation 最小面且不依赖接触/B2 行为即可呈现（依据：UX §6.1 持久 HUD 与 slice 分离）；② 反馈类绑定 `hit_results` 后可在 Gate 3 被独立观察归因（需未来观察验证）。未观察前不得视为成立。
- **`unresolved`（全量保留，未关闭）:** cluster membership / metric / quantization / tie-break / stable-ID 生命周期 / no-target cycle 精确周期与提示形态；life 数值语义（Systems contact 单元）；timer 精确时长与 tick 频率；B2 三弧；hint 文案/触发/effective-movement；hint valid-move 关联字段的正式落点；`no_target_cue_emitted` 的精确表现种类；全部候选预算（六项 + `1280×720` 红线）——保持 open。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本文件未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升。

---

## 9. 边界声明与 Closure

- **本文件是字段提案**：仅供 Engineer 在本单元 S5 落地时参考；最终产品裁决与验收归属 User 与 Independent QA。
- **未落地实现**：未写/改任何 `.gd`/`.tscn`/`.tres`；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布。
- **未批准/冻结任何合同/ADR/Systems 终裁/fixture schema**：cr-006..020 等 unresolved 项维持原状；候选数值不提升；QA 不豁免。
- **未替 QA 下 verdict / 未豁免 QA blocker。**
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。
- **写入面**：仅本唯一字段提案文件 `READ_MODEL_MINIMAL_FIELDS_v0_1.md`；未修改任何其它文档。

**Closure:** `closure_ready = yes`（仅限本 S5 字段提案 artifact）。本提案非实现派发、非契约批准、非 QA 验收、非产品裁决；父协调器与 Engineer 据本字段集落地 read-model。

---

## 10. 版本与变更记录

- **v0.1（本文件）:** UX/UI Designer 唯一新产物——S5 最小 player-facing read-model 字段提案。依 ADR-TECH-02（no-target/attack-resolution/feedback-binding/accessibility/hint 关联，R3–R5）与 UX 合同 §6.1/§9、UX-02/03 固化观察目标，产出 HUD 最小面（life/timer/B2）+ no-target quiet 态 + attack-resolution（hit_results 绑定）+ 空射不伪造形态确认（UX-03 S1–S3）；明确排除 hint valid-move 关联字段（unresolved）；只提案、落地归 Engineer。未修改任何其它文档。
