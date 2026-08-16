# READ MODEL IMPLEMENTATION LIST v0.1 — R2 read-model 呈现绑定落地清单（提案）

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DESIGN ONLY` — 本文件为 **R2 read-model 呈现绑定落地清单（提案)**，把 S5 最小 player-facing read-model 字段提案（`READ_MODEL_MINIMAL_FIELDS_v0_1.md`）转译为 **Engineer 可执行的呈现绑定清单**；**不落地实现**——落地归 Engineer（经 GDMCP，本单元 R2，见 `NEXT_IMPL_UNIT_PLAN_v0_2.md` §5.3）。
> **Role / owner (sole author):** UX/UI Designer（UX/UI 设计师）——R2 落地清单 OWNER；**落地归 Engineer**。
> **Report ID:** `READ_MODEL_IMPLEMENTATION_LIST_v0_1`
> **Expert capability:** `godot-ux-ui-expert` — 实测 `skill({ name: "godot-ux-ui-expert" })` **调用成功**（运行时返回完整 SKILL 指令）。能力证据等级 = `strong_direct_skill`（首选等级；本运行时无独立 `tools.skill` 包装器，直接 `skill` 调用成功，未发生 unknown tool / 接口不存在错误）。无需 fallback 到 SKILL.md 读取。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本清单仅依据任务允许的指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；无 runtime/visual/QA 证据）。
> **前置事实（仅可使用这些）:** ADR-TECH-01..06 已批准（R11）；ADR-TECH-02 已含 no-target/attack-resolution/feedback-binding/accessibility/hint 关联（UX 评审 R3–R5 补缺）；UX-03 S1–S3 已固化观察目标（no-target quiet/不伪造）；垂直切片已通过 Independent QA 验收 = verdict `pass`（`QA_VERTICAL_SLICE_VERDICT_v0_1.md`），当前 HUD 占位 = `LIFE [o][o][o]` / `TIMER pre-8min` / `B2 pre-fission` / `no target (quiet)` / `attack: resolved`；本单元范围 = R1 真实输入驱动移动 + R2 read-model 全字段落地 + R3 O4/O5 精化；接触(B)/升级(C)/B2/终结/focus 延后；候选预算仅候选、本清单不触碰数值；AUTH-01（R13 实现授权）生效；Producer 排程已判本单元 **非升级（D1 自动推进）**。

---

## 1. Expert preflight（godot-ux-ui-expert，应用于本 R2 落地清单任务）

- **目标玩家/上下文:** PC-first 单人玩家进入 8 分钟有界 Slice；本单元（R1+R2）关键旅程 = 「真实键盘移动 → 下一次自动攻击可归因（pillar 2）→ 命中 → 击杀 → 清除可见 → 空间/压力缓解」；本清单目标 = 让 read-model 全字段在**呈现层**可绑可读，支撑「下一次自动攻击结果可归因」而不被伪造反馈误导。
- **关键理解风险（本绑定清单须防）:** ① no-target 若误伪造锁指示/命中 → 违反 UX-03 S1/S2 / ADR-TECH-02 R4 / Systems §5.1 规则 5/6；② HUD 抢占 player/danger/space（UX 合同 §6.2 第一读优先 / UX-09）；③ 反馈类脱离 `hit_results` 因果 → 不可归因、无法支撑 Gate 3 U2/U3 观察（UX-03 S2）；④ presentation 层自我推断规则 → 违反 ADR-TECH-01（presentation 只消费 read-model，不成为第二规则权威）。
- **目标窗口/输入条件:** 16:9 基线 + {16:9, 16:10, 21:9} 方向性候选（DC-PLAT-02 Option 2 / R03）；键盘 WASD/方向键；`1280×720` 红线仅候选。
- **范围内状态（本单元 R2）:** 移动→attack-resolution→hit/kill/clear 可读（attack_state 四态 / feedback-binding marker / kill_state / invalidation presentation 节 / no-target quiet）+ HUD 最小面（life/timer/b2_phase）；**不在范围内**：接触（cr-006..009）、升级（cr-010..011）、B2 三弧（cr-016..019）、终局/重置（cr-014..015）、focus-epoch（cr-012..013）、hint（UX §6.3 unresolved）。
- **证据路线:** 本落地清单（UX 提案）→ Engineer 落地（GDMCP，R2）→ 未来授权 fixture/runtime frame + Independent QA 观察（Gate 3 前段 U2/U3 + UX-09/UX-13）。本文件只提供**呈现绑定清单**，**不声称任何 runtime/visual 证据**。
- **所有权边界（不代权）:** UX 提案 presentation-facing 呈现绑定；**不代 Systems 定规则语义**（目标/HP/死亡语义归 Systems，S1 薄前置）；**不代 Tech 定 tick/event schema**；**不代 Engineer 落地**（绑定落地在本单元归 Engineer 经 GDMCP）；**不代 QA 下 verdict**；不批准/冻结任何合同/数值/表现形态。
- **停止条件:** 唯一落地清单文件写入即停；不进入实现、不派发任何成员。

---

## 2. 实际工具顺序与专家能力加载（真实记录）

| # | 工具/动作 | 结果 |
|---|---|---|
| 1 | `skill({ name: "godot-ux-ui-expert" })` | ✅ **实测成功**（返回完整 SKILL 指令；未报 unknown tool / 接口不存在）。能力证据等级 = `strong_direct_skill`（首选）。按 DSH 实测纪律（2026-08-16），不以函数清单判断接口不可用——已实际发起调用验证。 |
| 2 | 并行 read `READ_MODEL_MINIMAL_FIELDS_v0_1.md`（S5 字段提案） / `NEXT_IMPL_UNIT_PLAN_v0_2.md`（R2 定义） / `KICKOFF_UX_UI_CONTRACTS_v0_1.md` / `UX_OBSERVATION_TARGETS_CR001_v0_1.md` | ✅ 全部实际读取成功 |
| 3 | 并行 read `QA_VERTICAL_SLICE_VERDICT_v0_1.md` / `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` / `IMPL_VERTICAL_SLICE_v0_1.md` | ✅ 全部实际读取成功 |
| 4 | read `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` 续段（§12–§18，ADR-TECH-04 trace/target_snapshot_ids/invalidation_event、R3–R5 文本） | ✅ 确认 ADR-TECH-01/02/04 read-model 契约文本与 TECH-04 候选字段（`run_id`/`tick`/`shot_id`/锁定 ID/失效原因/分辨率结果——字段名 proposal 级） |

> **接口实测说明（DSH 实操纪律, 2026-08-16）:** `skill` 接口本次**实际发起调用并成功**，未发生 unknown tool / 接口不存在错误，故不触发 fallback；`tools.skill` 包装器在本运行时不独立存在（直接以 `skill(...)` 调用成功并按 `skill` 返回完整 SKILL）。未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

---

## 3. 设计原则（对齐已批准契约，绑定层的硬边界）

1. **presentation 只消费 read-model，不成为规则权威**（ADR-TECH-01）：所有呈现绑定必须回溯到 S5 字段 / 规则核 trace（`target_snapshot_ids` / `no_target_branch` / `hit_results` / `resolution_outcome` / `kill_outcomes` / `invalidation_event(id,tick)`）或域事件（adapter 翻译）；presentation 不得从视觉状态自我推断新规则、不得隐式重算目标/命中/死亡。
2. **最小面完整呈现**：本单元只把 S5 已提案字段**完整呈现**（HUD 最小面 + no-target quiet + attack_state 四态 + feedback-binding marker + kill_state + invalidation 节）；接触/升级/B2/终结/focus 相关字段**只保留结构占位**（b2_phase 前-B2 形态），不扩增至运行时行为。
3. **空射不伪造**（ADR-TECH-02 R4 / UX-03 S1/S2 / Systems §5.1 规则 5-6）：锁指示/lock 类反馈只在 `target_snapshot_ids` 非空时才有资格 emit；hit/kill 类反馈只在 `hit_results` / `kill_outcomes` 非空时才有资格 emit；`no_target_branch=true` 时不得伴随任何伪锁/伪命/伪击杀；可选一次性非色彩克制「no-target 提示」（`no_target_cue_emitted`）只绑定 no-target 分支本身，绝不产生幻影命中。
4. **feedback-binding marker**：每条反馈类（lock / hit / kill / no_hit_invalid）都必须带与规则源（`target_snapshot_ids` / `hit_results` / `kill_outcomes` / `resolution_outcome`）的因果绑定标记，供 Gate 3「反馈类与 hit_results 因果一致」观察直接对齐（UX-03 S2）。
5. **呈现为可观察信号，不提升为判据**：本清单全部为「字段 → 呈现绑定 → 观察对接」的结构契约；无像素、无阈值、无色值、无 timing、无文字稿、无资产；不把任何字段呈现升级为 Gate 判据/发布承诺（AUTH-01 §6：若未来升级需 D2 判定）。
6. **非色彩可读**（UX-13 / UX 合同 §7）：所有色彩可辨字段（attack_state 四态 / no_target_cue_emitted / hit_results_feedback / kill_state / life 格）均需以**非色彩/非仅色彩**方式可读——绑定只指定结构化信号（文本/形状/分区/占位符号），色值仅作可选装饰，不作唯一通道。

---

## 4. 呈现绑定清单（每个 S5 字段 → 落地形态）

> 约定：**字段**——**类型**——**来源**（`RULES`=规则核 trace 直读 / `EVENT`=adapter 由域输出翻译的 presentation 面向字段 / `SESSION`=session 生命周期）——**呈现绑定方式**——**关联 UX 观察目标**——**禁止项**（Engineer 落地时不得做）。

### 4.1 HUD 最小面完整呈现（对齐 UX 合同 §6.1 / §9 UX-09）——life / timer / b2_phase

| 字段 | 类型 | 来源 | 呈现绑定方式 | 关联 UX 观察目标 | 禁止项 |
|---|---|---|---|---|---|
| `life` | 结构枚举/分段（`segments_lost:int(0..3)` + `life_state:enum`） | `RULES`（命中→击杀→清除本单元不直接耗 life；life 语义 Sources=Systems，数值延后）+ `SESSION` run 生命周期 | HUD 恒定三格生存面（延续 QA 已观察的 `LIFE [o][o][o]` 占位形态）：每格以**形状/文本分区**（非色彩）呈现 segment 状态；`segments_lost` 本单元恒 0、结构位恒在，不呈现扣减行为 | UX-09（HUD life 持久/不被遮挡）；UX-10 终局前段（本单元仅结构骨架） | 不得赋予 life 数值语义/扣减行为（归 Systems contact 单元）；不得因本单元无接触伤害而移除三格结构位；不得以色彩作为格子状态的唯一可读方式（UX-13） |
| `timer` | `current_tick:int` + `run_duration_bound:opaque`（8 分钟边界，定时值延后 Systems） | `SESSION`（session 驱动 tick，见 session 生命周期）+ `RULES` run 生命周期 | HUD 顶部/角落时长读数（延续 `TIMER pre-8min` 占位形态）：由 session 驱动 tick 推进呈现时间/进度结构位；关联「下一次自动攻击可归因」时间窗（pillar 2） | UX-09（timer 持久）；UX-02（移动→攻击归因时间窗） | 不得冻结 timer 精确时长/频率（归 Systems）；不得把 timer 呈现升级为 Gate 判据；不得引入 XP/fragments 节点（竞争可读性，UX §6.1 次序） |
| `b2_phase` | 枚举（本单元唯一合法值 = 前-B2 形态；`penetration→fission` 结构保留为占位） | `RULES`/`SESSION` 阶段位；B2 三弧语义延后（cr-016..019） | HUD 阶段标签占位（延续 `B2 pre-fission` 形态），保证「阶段可读」的结构恒在而不引入本单元不存在的 B2 行为 | UX-09（B2 阶段持久）；UX-11（B2 前段全读，本单元仅结构位） | 不得引入 B2 三弧行为/光场（cr-016..019 延后）；不得冻结 B2 阶段视觉表现（UX §5.1 exact visual treatment unresolved） |

**最小面说明:** 本单元仅需 life/timer 真实可读 + B2 阶段结构位；三格 life 的 `segments_lost` 只作观察骨架（数值/损失语义属 Systems、接触单元），timer 反映 session 驱动 tick 的确定性边界。不引入 XP/fragments 节点。

### 4.2 no-target quiet 形态（S1/S2——无锁/无幻影命中）

| 字段 | 类型 | 来源 | 呈现绑定方式 | 关联 UX 观察目标 | 禁止项 |
|---|---|---|---|---|---|
| `no_target_branch` | bool（`true`=本 fire 周期无合法目标） | `RULES`（`rules_core.gd` 已落 `no_target_branch`） | 驱动「本周期安静 / 可选克制提示」的唯一权威信号：`true` 时 read-model 不携带任何 lock/targeting 数据、不携带任何 hit/kill 负载；HUD 呈现 quiet 形态（延续 `no target (quiet)` 占位）；攻击线隐藏（无锁定指向，对齐 QA 已观察的 quiet 后态） | UX-03 S1/S2 / U3-A（空 refresh 确定性分支）；UX-02 G4 队列 | 不得借此发出锁指示/瞄准框/命中/击杀反馈（S1/S2）；不得把空枪读成对真实目标的 miss、不得期待后续命中（G4）；不得添加隐藏计时惩罚（`timer_effect` 空白，S3 / pillar 4） |
| `no_target_cue_emitted` | bool（一次性、可空） | `EVENT`（presentation 由 `no_target_branch=true` 决定是否 emit 可选一次性非色彩克制提示；**种类为 `team_proposal / unresolved`，非本字段冻结**） | 可选一次性的非色彩克制提示——仅绑定 no-target 分支本身、绝不独立于分支产生、绝不伴随幻影命中；仅供「分支可辨」（S3）；供 U3-D 连续空周期确认无隐藏反馈 | UX-03 S3（分支可辨）；U3-D 节奏 | **不得冻结提示种类**（文案/符号/时长/触发细节均 unresolved——Engineer 只能以占位表现承担，不得把精确表现写死为批准形态）；不得承担节奏/计时惩罚信息；不得用色彩作唯一通道（UX-13） |

**quiet 形态确认（UX-03 S1–S3）:** `no_target_branch=true` 时，呈现层无锁指示、无瞄准框、无命中/击杀反馈；唯一允许的额外信号是 `no_target_cue_emitted`（可选、一次性、非色彩、克制）。空 refresh 绝不产生「锁定指示/瞄准框/命中/击杀」反馈；不把空枪读成对真实目标的 miss、不期待后续命中（G4）。

### 4.3 attack_state 四态切换呈现绑定（idle / resolving / resolved / no_target）

| 字段 | 类型 | 来源 | 呈现绑定方式 | 关联 UX 观察目标 | 禁止项 |
|---|---|---|---|---|---|
| `attack_state` | enum（`idle → resolving → resolved`（本 shot 结算完成）；可空分支 `no_target`） | `RULES`（由 `no_target_branch` + 结算推进）+ `EVENT` | 四态驱动可观察标签/形态（延续 QA 已观察的 `attack: resolved` 占位 Label，升级为状态驱动而非静态文本）：<br>• `idle`：无进行中结算（安静基线，下一 eligible fire tick 前）——不展示目标/结果；<br>• `resolving`：lock 已定、结果未出（锁定快照已获取、`hit_results` 尚未结算）——呈现「本次攻击正在结算」归因窗口，可结合 lock 目标指示（仅 `target_snapshot_ids` 非空时）；<br>• `resolved`：本 shot 结算完成（`hit_results`/`resolution_outcome` 已落）——呈现「已结算」，hit/kill 具体反馈由 4.4 feedback-binding marker 驱动；<br>• `no_target`：由 `no_target_branch=true` 驱动的分支态——呈现 quiet 形态，与 `resolved` 分支**可区分可读** | UX-02 N2/N3；UX-03 S3（分支可辨） | attack_state 取值只由 read-model 字段派生，**不得自我推断结算结果**（TECH-01）；不得在 `no_target` 态显示 lock/hit 反馈；不得冻结状态标签的精确文案/表现（占位表现归 Engineer，文案不冻结） |

### 4.4 feedback-binding marker 逐反馈类绑定（核心不伪造闸门——lock / hit / kill / no_hit_invalid）

**通用规则（所有反馈类）：** 每条反馈类 emit 时必须携带其因果源引用（如 `feedback.lock ← target_snapshot_ids`、`feedback.hit ← hit_results{ids}`、`feedback.kill ← kill_outcomes{ids}`、`feedback.no_hit_invalid ← resolution_outcome=="no-hit-invalid"` 对应的 shot ID/tick），供 Gate 3「反馈类 ↔ hit_results 因果一致」观察直接对齐（UX-03 S2）。

| 反馈类 | 绑定规则源（非空才可 emit） | 呈现绑定方式 | 关联 UX 观察目标 | 禁止项 |
|---|---|---|---|---|
| **lock（锁指示/瞄准框/攻击线指向）** | `target_snapshot_ids` 非空 | 锁定向玩家可见的快照目标（攻击线/瞄准框只指向锁定快照集，**不实时重定位**，对齐 ADR-TECH-04 snapshot-lock ≠ live-retarget + QA 已观察的攻击线指向锁定敌人） | UX-02 N2/G3（锁定的最近威胁簇中心）；U2-D 首击 | `target_snapshot_ids` 为空时禁止 emit（空 refresh 无锁）；不得随移动实时重画目标（本 shot 锁定不可变）；不得把锁指示画到快照集之外 |
| **hit（命中反馈/受击表现）** | `hit_results` 非空（对应 ID 在命中集） | 命中反馈只对 `hit_results` 含有的 ID emit（QA 已观察 `[HIT] target id=...` 形态）；hit 反馈短而克制 | UX-02 N3（攻击→结果归因）；UX-03 S2 | `hit_results` 为空时禁止 emit（空射不伪造）；不得对失效/死亡 ID emit（无幽灵命中，S2）；不得推断 hit 数值/伤害量（数值归 Systems，S1 薄前置） |
| **kill（击杀/清除反馈）** | `kill_outcomes` 非空（对应 ID 在击杀集） | 击杀反馈只对 `kill_outcomes` 含有的 ID emit（QA 已观察 `[KILL]` → `[CLEAR]` → live 缩减闭环）；kill → 引擎移除 → 清除可见 | UX-02 N4（结果→空间）；slice 完成判定 | `kill_outcomes` 为空时禁止 emit；不得对未死/失效 ID emit；不得引入击杀计数/分数（XP/fragments 延后）；不得触碰 HP 多段数值（S1 range[1,5] 候选，promotion=User） |
| **no_hit_invalid（锁定后失效目标）** | `resolution_outcome == "no-hit-invalid"`（锁定后目标失效，drain 点 `invalidation_event`） | 失效呈现为「本 shot 无命中」：不产生任何命中/击杀视觉，下一 shot 才生效 | UX-03 S2 / U3-C（锁定后移除→无幽灵命中） | **不得携带伪命中/伪击杀**（失效 ≠ 被击中）；不得把失效呈现成 miss 动画/负面反馈（G4 无幻影期望）；呈现层不得重算失效（只消费 read-model 信号） |

**什么时候禁止 emit（汇总闸门，Engineer 落地为硬性 gate）：**
1. `no_target_branch=true` → lock / hit / kill 三类**全部禁止**（S1/S2）；仅允许可选 `no_target_cue_emitted`（种类 unresolved、非色彩、克制）。
2. 反馈类与绑定源不符 → 禁止（如 lock 反馈但 `target_snapshot_ids` 空、hit 反馈但 `hit_results` 空、kill 反馈但 `kill_outcomes` 空）。
3. 该 ID 不在绑定源集合内（例如失效/死亡 ID）→ 禁止对该 ID emit 任何命中/击杀。
4. marker 缺失（反馈类未附因果源引用）→ 禁止 emit（否则 Gate 3 无法归因）。

### 4.5 kill_state 呈现绑定（none → killed）

| 字段 | 类型 | 来源 | 呈现绑定方式 | 关联 UX 观察目标 | 禁止项 |
|---|---|---|---|---|---|
| `kill_state` | enum（`none → killed`（本单元击杀→清除的最小结算态）） | `RULES`（S2 kill 路径死亡/清理语义，来源归 Systems 薄前置）+ `EVENT` | 「击杀→清除→压力降低→空间恢复」可观察闭环的击杀面：`none`（本 shot 无击杀）→ `killed`（`kill_outcomes` 非空且已清除）转换可观察；呈现击杀反馈 + 敌人移除 + live 缩减（QA 已观察 `[KILL]` → `[CLEAR]` → `live enemies=0` 闭环） | UX-02 N4（结果→空间）；slice 完成判定 | `kill_outcomes` 为空时不得置 `killed`；不得引入击杀计数/分数（XP/fragments 延后）；不得触碰 HP 多段精确数值（S1 range[1,5] 候选，promotion=User）；不得把 kill_state 升级为 Gate 判据 |

### 4.6 invalidation_event presentation 节（失效事件如何进入呈现层）

| 字段 | 类型 | 来源 | 呈现绑定方式 | 关联 UX 观察目标 | 禁止项 |
|---|---|---|---|---|---|
| `invalidation_event(id,tick)`（presentation 可见部分） | `invalidation_event(id,tick)` 的**可观察节**（仅「本 shot 目标失效、无命中」信号，不展开内部 drain 细节） | `RULES`（`rules_core.gd` 已落 `invalidation_event(id,tick)`，ADR-TECH-04 / 失效语义 (ii) 终裁） | 失效目标进入呈现层的方式 = **「无命中」的可读信号**：呈现层保持 quiet/不产生命中反馈；attack_state 正常推进结算（不失速、不停滞）；下一 shot 才生效（快照权威，cr-004 (i) 候选语义衔接，不代决） | UX-03 S2 / U3-C（锁定后目标移除→无幽灵命中、下一 shot 生效） | 不展开内部 drain/移除实现细节（内部机制不进 presentation）；不得把失效呈现成命中/击杀；不得冻结失效反馈的精确形态（unresolved）；presentation 不得重算失效（只消费 read-model 信号，TECH-01） |

---

## 5. 明确排除清单（本单元 R2 **不得**落地——防蔓延红线）

| # | 排除项 | 依据 | 边界（什么不得做） |
|---|---|---|---|
| E1 | **hint 字段（valid-move 关联）** | ADR-TECH-02 UX R3 hint 关联字段；UX 合同 §6.3（hint 文案/触发/effective-movement 全 `unresolved`）；S5 §4.4 明确排除提案项 | Engineer **不得**擅自落地 hint 关联字段/因果 hint 呈现；留后续单元 |
| E2 | **no-target cue 精确表现种类** | `no_target_cue_emitted` 种类 `team_proposal / unresolved` | **不得冻结**提示文案/符号/时长/触发细节为批准形态；只能占位表现承担 |
| E3 | **文案/拷贝** | 全部 HUD 标签、attack_state 标签、no-target 提示、失效呈现文案均为占位表现 | 不冻结任何文本为正式文案；不把占位文案当作发布承诺 |
| E4 | **布局** | HUD 位置/锚点/安全区/缩放层级 unresolved（UX 合同 §6.1/§7） | 无像素/间距/对齐/字体/层级冻结；不设计正式布局，只保证字段先于布局存在 |
| E5 | **资产/动画/音频** | NEXT_IMPL_UNIT_PLAN §5.4 | 使用 ColorRect/Line2D/Label 最小占位（延续上一单元）；无美术/动画/音频提示与承诺 |
| E6 | **数值** | life segment 数、timer 时长/频率、feedback timing、任何阈值 | 不提升任何候选数值；不把数值写为规则常数/Gate 判据（promotion=User；数值写死即 D2 升级，AUTH-01） |
| E7 | **性能候选** | 六项候选预算 + `1280×720` 红线 | 候选保持仅候选；本单元不测量、不判定、不升级 |
| E8 | **内部分级细节** | ADR-TECH-02 R3/R4 注记 | `ordered_ids` / `(k1_bucket, k2_bucket, stable_id)` / `refresh_tick` / `lock_tick` 等内部稳定排序与快照时序细节**不进 presentation 子集** |
| E9 | **B2 / contact / upgrade / terminal / focus** | cr-006..020 延后 | 不引入其 runtime 行为；仅保留结构位（b2_phase 枚举形态、attack_state 可扩展态）；不挤入 |
| E10 | **呈现升级 Gate/发布判据** | AUTH-01 §6 / Producer 排程 §8 | 不把任何字段呈现（attack_state 形态、no-target cue、HUD 面等）升级为 Gate 判据/发布承诺文案；若未来升级 → 立即 D2 判定呈交用户 |

---

## 6. 与 QA 验收衔接（支撑未来 Gate 3 前段观察判据）

本绑定清单为未来 Gate 3 前段（U2/U3 场景 + UX-09/UX-13）提供**可直接对齐的可观察绑定**：

### 6.1 R1 真实输入 → 移动 → 锁定重定位因果（QA 重点，UX-02 U2-B/C）

- `locked_target`（由 `target_snapshot_ids` 派生、不可变）+ `attack_state` + `hit_results_feedback` 供 QA 观察「真实键盘输入（或受限 input 注入/有界演示，QA 制定协议）→ player 位移 → 下一次自动攻击锁定快照随移动重定位」因果（对齐 ADR-TECH-04「移动→下一次自动攻击因果可读」、UX-02 U2-B/C）。
- 对照场景（移动但簇不变，U2-C）：`locked_target` 不变即可独立验证无变化可归因。
- self-test 保留为**确定性回归**，不作为玩家可玩证据（QA verdict §0/§3 已声明；真实输入观察协议由 QA 制定）。

### 6.2 read-model 全字段呈现（QA 前段观察，UX-03 S1–S3 / U3-A..D）

- **U3-A（空 refresh 确定性分支，S1/S2）:** `no_target_branch=true` → 呈现层无 lock/hit/kill 负载（攻击线隐藏、无 `hit_results_feedback`）→ 反证无锁指示/无命中。
- **U3-B（邻接边界目标，S1/S3）:** 边界外目标 → `no_target_branch=true`，不得出现误导性 lock。
- **U3-C（锁定后目标移除，S2）:** `invalidation_event(id,tick)` presentation 节 → 无 `no_hit_invalid` 虚拟命中/无幽灵击杀；下一 shot 才生效。
- **U3-D（连续空周期节奏，S3 + pillar 4）:** `attack_state` / `no_target_cue_emitted` 时间线 + timer 无隐藏惩罚。

### 6.3 非色彩可读（UX-13 / UX 合同 §7）

- 全部色彩可辨字段（attack_state 四态、no_target_cue_emitted、hit_results_feedback、kill_state、life 格损耗）均需以**非色彩/非仅色彩**方式可读——本清单要求每个绑定携带结构化信号（文本/形状/分区/占位符号），不依赖色值；QA 按 UX-13 checklist 观察。

### 6.4 HUD 不遮挡（UX-09）

- life/timer/b2_phase 常量面 + no-target 呈现 + attack_state 呈现不得遮挡 player silhouette / nearest danger / enemy tide / clear space（第一读优先，UX §6.2 次序）；QA 以 runtime frame 观察（player/danger/space 不被 HUD 覆盖），`1280×720` 红线仍仅候选。

### 6.5 观察执行依赖

> 观察执行依赖未来授权 fixture + runtime frame + Independent QA 独立观察（Gate 3 前段），**本清单不执行、不声称观察**；不豁免 QA；本单元不授予任何 Gate 3+ 免除（QA verdict / Producer 排程 §8）。

---

## 7. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；cr-001 Option A (R09)；ADR-TECH-01..06 批准 (R11)；UX-03 S1–S3 固化观察目标；AUTH-01 (R13 实现授权)；垂直切片 QA verdict `pass`（验收记录，非决策 R 编号）。本清单不重写、不重分类任何一项。
- **`team_proposal`（本清单实质贡献）:** R2 呈现绑定清单（S5 字段 → 绑定形态：HUD 最小面、no-target quiet、attack_state 四态、feedback-binding 逐类绑定、kill_state、invalidation presentation 节）；禁止 emit 汇总闸门；明确排除清单（§5）；与 Gate 3 前段观察衔接（§6）。全部为呈现落地清单，供 Engineer 落地参考，**不升级任何契约**。
- **`assumption`:** ① 呈现绑定可在已批准 read-model 契约内落地且可在 Gate 3 前段被独立 QA 观察归因（需 Engineer 落地 + QA 观察验证）；② 非色彩可读要求可由占位表现（文本/形状/分区）满足（需 QA 观察验证）；③ marker 绑定后的反馈因果可在 runtime frame 中可读（需未来观察验证）。未观察前不得视为成立。
- **`unresolved`（全量保留，未关闭）:** cluster membership / metric / quantization / tie-break / stable-ID 生命周期 / no-target cycle 精确周期与提示形态（含 `no_target_cue_emitted` 精确表现种类）；life 数值语义（Systems contact 单元）；timer 精确时长与 tick 频率；B2 三弧；hint 文案/触发/effective-movement / hint valid-move 关联字段正式落点；失效反馈精确形态；布局/文案/色值/阈值；全部候选预算（六项 + `1280×720` 红线）——保持 open。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本清单未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升。

---

## 8. 边界声明与 Closure

- **本文件是呈现绑定清单（R2 落地清单提案）**：仅供 Engineer 在本单元 R2 落地（展示/S5 字段 → 呈现绑定）时参考；最终产品裁决与验收归属 User 与 Independent QA。
- **未落地实现**：未写/改任何 `.gd`/`.tscn`/`.tres`；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布。
- **未批准/冻结任何合同/ADR/Systems 终裁/fixture schema/数值/表现形态**：cr-006..020 等 unresolved 项维持原状；候选数值不提升；no_target_cue 种类、hint、失效反馈形态、布局文案均不冻结；QA 不豁免。
- **未替 QA 下 verdict / 未豁免 QA blocker / 未替 Engineer 落地 / 未替 Systems 定规则语义。**
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。
- **写入面**：仅本唯一落地清单文件 `READ_MODEL_IMPLEMENTATION_LIST_v0_1.md`；未修改任何其它文档。

**Closure:** `closure_ready = yes`（仅限本 R2 呈现绑定落地清单 artifact）。本清单非实现派发、非契约批准、非 QA 验收、非产品裁决；父协调器与 Engineer 据本清单在本单元 R2 落地 read-model 呈现绑定。

---

## 9. 版本与变更记录

- **v0.1（本文件）:** UX/UI Designer 唯一新产物——R2 read-model 呈现绑定落地清单（提案）。依 S5 字段提案（`READ_MODEL_MINIMAL_FIELDS_v0_1.md`）与 ADR-TECH-01/02/04（read-model 契约、R3–R5、target_snapshot_ids/invalidation_event）及 UX-02/03/09/13 观察目标，把每个 S5 字段转为 Engineer 可执行的呈现绑定（HUD 最小面 life/timer/b2_phase、no-target quiet（S1/S2、cue 种类 unresolved 不冻结）、attack_state 四态、feedback-binding marker 逐反馈类绑定（lock←target_snapshot_ids / hit←hit_results / kill←kill_outcomes / no_hit_invalid←resolution_outcome）+ 禁止 emit 汇总闸门、kill_state（none→killed）、invalidation presentation 节）；明确排除清单（hint/文案/布局/资产/数值/性能/内部分级/B2 等 E1–E10）；QA Gate 3 前段衔接（真实输入→移动→锁定重定位因果、非色彩 UX-13、HUD 不遮挡 UX-09、U2/U3 场景映射）。只提案，落地归 Engineer；未修改任何其它文档。