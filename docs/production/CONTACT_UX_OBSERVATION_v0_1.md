# CONTACT UX OBSERVATION v0.1 — C5 life 扣减呈现绑定清单 + C6 玩家伤害体验观察目标（提案）

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DESIGN ONLY` — 本文件为 **UX/UI 唯一新产物**：把 C5（`segments_lost` 从 0 结构位 → 实际扣减的呈现绑定清单）与 C6（玩家伤害体验观察目标）合并交付。**不落地实现**——落地归 Engineer（经 GDMCP，接触单元 C4/C5）；观察执行归 Independent QA（Gate 3 前段，接触单元 T）。
> **Role / owner (sole author):** UX/UI Designer（UX/UI 设计师）——C5+C6 提案唯一 OWNER；落地归 Engineer；观察验收归 QA。
> **Report ID:** `CONTACT_UX_OBSERVATION_v0_1`
> **Expert capability:** `godot-ux-ui-expert` — 解析路径 `C:\Users\User\.agents\skills\godot-ux-ui-expert\SKILL.md`。**接口实测结论（DSH 2026-08-16 实测纪律）:** 本会话运行时**未提供** `skill` / `tools.skill` 可调用工具（本会话可用函数面不含该接口，无法发起实际调用；非凭函数清单伪报「接口不存在」以外的降级判断——即无法实测调用，只能诚实记为接口不可用）。**能力证据等级 = `static_skill_load`**（已实际读取精确 SKILL.md 全文并引用其岗位边界/反模式/证据契约，见 §2）；非首选等级，但为只读设计任务的可审计兼容回退。未使用 `parent_route_fallback`（本会话父线程未注入能力摘要，且不满足其最低等级替代条件的时间点——自读 SKILL.md 已达成本预检）。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本文件仅依据任务允许的 8 份指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；无 runtime/visual/QA 证据）。
> **前置事实（仅可使用这些）:** ADR-TECH-01..06 已批准（R11，含 ADR-TECH-02 read-model / ADR-TECH-05 contact 机制边界「单次伤害+轻分离，精确数值语义延后」）；决策 #4（contact 单次伤害事件）`user_confirmed`；决策 #5（life 三格 & 同帧生命优先）`user_confirmed`；决策 #19（非色彩可读）`user_confirmed`；UX-03 S1–S3 已固化观察目标（no-target quiet/不伪造）；life 现状 = `LIFE [o][o][o] segments_lost=0` 结构位已呈现（R2 落地）、**无扣减行为**；life 数值语义 unresolved（归 Systems 在 contact 单元定义）；Producer 排程 `NEXT_IMPL_UNIT_PLAN_v0_3.md` 已定义本单元 C5（UX 落地清单）+ C6（UX 观察目标），AUTH-01 判定**本单元无前置强制 D2、推荐默认全程 D1**；单元 1/2 已验收 pass；候选预算仅候选、本清单不触碰数值；O8（真人键盘自由操作未全量验收）约束观察边界。

---

## 1. Expert preflight（godot-ux-ui-expert，应用于本 C5+C6 任务）

- **目标玩家/上下文:** PC-first 单人玩家进入 8 分钟有界 Slice；本单元（接触单元）关键旅程 = 「移动 → 接触（合法）→ 伤害 → 生命损失可读 → 撤离/恢复 → 下一决策」。C5 = 让 `segments_lost` 从结构恒 0 变为**实际扣减的可读呈现**；C6 = 固化该伤害体验的**可观察目标**（可读、非色彩、可归因、非惩罚），支撑 QA Gate 3 前段独立观察。
- **关键理解风险（本清单须防）:** ① life 扣减若只以色彩传达 → 违反 UX-13 / 决策 #19（非色彩可读）；② HUD/伤害反馈若遮挡 player/danger/space → 违反 UX-09（§6.2 第一读优先）；③ 扣减反馈若脱离接触伤害事件/规则核 life 状态因果 → 不可归因、违 ADR-TECH-02（presentation 不成为第二规则权威、不伪造）；④ 伤害形态若被玩家读成惩罚/锁死 → 违反 Pillar 4 非惩罚 / 决策 #12（defeat=light interruption）；⑤ 「接触合法 vs 连续重叠」不可辨 → 违反决策 #4（单次伤害事件）+ Systems §6.1（区分 legal contact 与 continuous overlap）。
- **目标窗口/输入条件:** 16:9 基线 + {16:9, 16:10, 21:9} 方向性候选（DC-PLAT-02 Option 2 / R03）；键盘 WASD/方向键；`1280×720` 红线仅候选。
- **范围内状态（本单元）:** `segments_lost` 实际扣减呈现（life 三格非色彩可读）+ 玩家伤害体验观察目标（接触→伤害→生命损失→撤离/恢复）；**不在范围内**：生命耗尽后的终局仲裁 / 重试（`segments_lost=3` 的终结语义属 terminal 单元，本单元仅提供字段骨架与「同帧生命优先」锚点字段，不实现终局）；升级/B2/终结/focus/spawn；life 数值语义（扣几点归 Systems ledger）。
- **证据路线:** 本清单（UX 提案）→ Engineer 落地（GDMCP，C4/C5）→ Independent QA 独立观察（Gate 3 前段接触惩罚/分离/生命扣减可读、UX-13、UX-09、玩家伤害可归因非惩罚）。本文件只提供**呈现绑定清单 + 观察目标**，**不声称任何 runtime/visual/QA 证据**。
- **所有权边界（不代权）:** UX 提案 presentation-facing 呈现绑定 + 观察目标；**不代 Systems 定规则语义**（life 数值语义 / 接触判定语义归 Systems CONTACT ledger）；**不代 Tech 定 tick/event schema**；**不代 Engineer 落地**（C5 落地归 Engineer 经 GDMCP）；**不代 QA 下 verdict**；不批准/冻结任何合同/数值/表现形态；不豁免 QA。
- **停止条件:** 唯一 C5+C6 交付物文件写入即停；不进入实现、不派发任何成员。

---

## 2. 实际工具顺序与专家能力加载（真实记录）

> **接口实测诚实记录（DSH 2026-08-16 实测纪律）:** 不得仅凭函数清单判断 `skill`/`tools.skill` 不可用，必须以实际发起调用验证。**本会话运行时可用工具面中不存在 `skill` 或 `tools.skill` 这一可调用函数**——我作为本会话成员**无法对其发起实际调用**（它不是本会话暴露的可执行工具）；这不是「我查了清单后伪报不存在」，而是「本会话根本没有该接口可被调用」。据此诚实判定：**首选的 `strong_member_skill` / `strong_direct_skill` 均不可达**（无法实测调用），转入可审计的 `static_skill_load` 兼容回退。若本会话实际暴露 `skill` 接口，将重新实测并升级证据等级。

| # | 工具/动作 | 结果 |
|---|---|---|
| 1 | `skill({ name: "godot-ux-ui-expert" })` — 意图发起调用 | ⚠️ **不可发起**：本会话可用函数面未包含 `skill` / `tools.skill` 可调用工具，无法实测调用；诚实记为接口不可调用，非伪报 |
| 2 | 读取 `C:\Users\User\.agents\skills\godot-ux-ui-expert\SKILL.md`（static_skill_load） | ✅ **实际读取成功**（102 行全文）；应用其岗位边界/反模式/证据契约（presentation 只消费 read-model、feedback closes the loop、hierarchy beats decoration、非色彩可读、不推断 runtime 行为） |
| 3 | 并行 read `NEXT_IMPL_UNIT_PLAN_v0_3.md` / `READ_MODEL_MINIMAL_FIELDS_v0_1.md` | ✅ 全部实际读取成功 |
| 4 | 并行 read `READ_MODEL_IMPLEMENTATION_LIST_v0_1.md` / `UX_OBSERVATION_TARGETS_CR001_v0_1.md` | ✅ 全部实际读取成功 |
| 5 | 并行 read `KICKOFF_UX_UI_CONTRACTS_v0_1.md` / `QA_PLAYABLE_SLICE_VERDICT_v0_1.md` | ✅ 全部实际读取成功 |
| 6 | 并行 read `KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md` / `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` | ✅ 全部实际读取成功 |

> **能力证据等级:** `static_skill_load`（首选接口不可达时，已实际读取精确 SKILL.md 并引用其岗位边界）。**接口实测结论:** `skill`/`tools.skill` 本会话不可调用（无法实测）；未伪报「接口不存在」——如实记录「本会话可用函数面无此接口、无法发起调用」。未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

---

## 3. 设计原则（对齐已批准契约，C5/C6 的硬边界）

1. **presentation 只消费 read-model，不成为规则权威**（ADR-TECH-01/02）：life 扣减呈现与伤害反馈必须回溯到域事件（接触伤害事件）或规则核 life 状态（`segments_lost` 实际值）；presentation 不得从视觉状态自我推断伤害、不得在无接触事件时扣格、不得伪造生命损失。
2. **不伪造、feedback-binding**（ADR-TECH-02 R4 / UX-03 S1/S2 同族纪律）：每一条 life 扣减/伤害反馈类都须携带与**接触伤害事件 / 规则核 life 状态**的因果绑定标记（反馈类 ↔ 规则源），供 Gate 3「反馈类与规则源因果一致」观察直接对齐；`segments_lost` 只在规则核实测扣减时变化，presentation 永不自行扣减。
3. **非色彩、非仅色彩**（UX-13 / 决策 #19 / UX 合同 §7）：life 三格状态与伤害反馈均需以形状/文本/分区等**结构化非色彩信号**可读；色彩（如格子变暗）仅作可选装饰，不作唯一通道。
4. **HUD 不遮挡**（UX-09 / UX 合同 §6.2）：life HUD 与伤害反馈不得遮挡 player silhouette / nearest danger / enemy tide / recovered space（第一读优先）。
5. **非惩罚**（Pillar 4 / 决策 #12 / ADR-TECH-05 机制边界）：contact 为「light interruption」而非惩罚锁死；合法的「一次伤害 + 短暂无敌 + 轻分离」可被玩家读为**可恢复**而非 sticky lock；「接触合法 vs 连续重叠」可辨（决策 #4），连续重叠不重复扣血（无敌期内无重复伤害）。
6. **呈现为可观察信号，不提升为判据**（AUTH-01 §6 / 接触单元 §7 D2-Card）：本清单全部为「字段 → 呈现绑定 → 观察对接」的结构契约；无像素、无阈值、无刻点数、无 timing、无文字稿、无资产；**不把任何字段呈现或数值升级为 Gate 判据 / 发布承诺**。

---

## 4. C5 — life 扣减呈现绑定清单

### 4.1 绑定对象与基础（`segments_lost` 从 0 结构位 → 实际扣减）

> 约定：**字段**——**类型**——**来源**（`RULES`=规则核 trace 直读 / `EVENT`=adapter 由域输出翻译的 presentation 面向字段 / `SESSION`=session 生命周期）——**呈现绑定方式**——**关联 UX 观察目标**——**禁止项**（Engineer 落地时不得做）。

| 字段 | 类型 | 来源 | 呈现绑定方式 | 关联 UX 观察目标 | 禁止项 |
|---|---|---|---|---|---|
| `life` | 结构枚举/分段（`segments_lost:int(0..3)` + `life_state:enum`）——**从恒 0 结构位 → 实际扣减** | `RULES`（接触伤害事件的规则核效果：合法接触 → 单次伤害 → 规则核把 `segments_lost` 从 N 增到 N+1；life 数值语义归 Systems）+ `EVENT`（adapter 翻译规则核 life 状态为 presentation 面向）+ `SESSION` run 生命周期 | 三格生存面以**形状/文本分区**（非色彩）呈现每格 segment 状态：`o`（存活格）与 `x`（已失格）**由 `segments_lost` 实际值驱动、逐位变化**；例如 `segments_lost=1 → LIFE [x][o][o]` 的呈现规则——已失格以形状替换/分区标记（如空心、灰化、缺口符号）表达，保留当前格式 `LIFE [<状态>][<状态>][<状态>] segments_lost=N` 的延续（N 为实测值） | UX-09（HUD life 持久/不被遮挡）；UX-13（非色彩可读）；UX-10 终局前段（本单元仅字段骨架）；对齐 S5 life 字段 + READ_MODEL_IMPLEMENTATION_LIST §4.1 扩展 | 不得在无接触伤害事件时扣格（伪造扣减 → 违 ADR-TECH-02）；不得以色彩作为格子状态唯一可读方式（UX-13/E6）；不得赋予/写死 life 数值语义（扣几点归 Systems ledger，写死即 D2 升级）；不得移除三格结构位 |
| `segments_lost` | `int(0..3)`（实际扣减值） | `RULES`（规则核 contact 单元定义其数值语义；presentation 只读实测值） | 作为 read-model 呈现的字段骨架：呈现反映「已失几格」的实测统计；其呈现绑定驱动 §4.2 的扣减反馈类 | UX-13; UX-09; 对齐 READ_MODEL_IMPLEMENTATION_LIST §4.1 | 不得由 presentation 自行决定何时从 0 变 1（必须回溯接触伤害事件）；不得把 segments_lost 数值升级为 Gate 判据/发布承诺（E10） |
| `life_state` | `enum`（life 存活 / 生命耗尽等状态位） | `RULES`（规则核 life 生命周期状态）+ `SESSION` | 作为可观察的「生命状态可读」结构位：本单元只提供字段骨架（存活态正常呈现）；`segments_lost=3` 的终结态呈现语义属 terminal 单元，本单元不实现终局仲裁 | UX-10 终局前段（本单元仅结构骨架） | 不得本单元实现生命耗尽后的终局结果/重试（cr-014..015 延后）；不得把 life_state 升级为 Gate 判据 |

**基础确认（承接 R2 落地）:** 本单元把 `segments_lost` 从「结构位恒 0」扩展为「接触伤害事件驱动、实际扣减可读呈现」。呈现仍只消费规则核 life 状态（ADR-TECH-01）：`LIFE [x][o][o] segments_lost=1` 这一形态的**驱动源是规则核的 contact 伤害结算**，绝不由呈现层自行推断。

### 4.2 扣减反馈类（逐一绑定规则源——feedback-binding marker）

**通用规则（所有反馈类）：** 每条 life 扣减/伤害反馈类 emit 时必须携带其因果源引用（如 `feedback.life_loss ← contact_damage_event{contact_id, tick}`、`feedback.hit_fb ← contact_damage_event`），供 Gate 3「反馈类 ↔ 接触伤害规则源 因果一致」观察直接对齐（UX-03 S2 同族纪律 + ADR-TECH-02）。

| 反馈类 | 绑定规则源（非空才可 emit） | 呈现绑定方式 | 关联 UX 观察目标 | 禁止项 |
|---|---|---|---|---|
| **life loss（生命格扣失）** | 规则核 `segments_lost` **实测增加**（合法接触伤害事件结算后，从 N→N+1） | 三格中对应格从「存活形态」切换为「已失形态」（形状/分区非色彩），HUD 呈现 `segments_lost=N` 新值；扣失反馈短而克制 | UX-09（不遮挡）；UX-13（非色彩）；UX-02 归因；Gate 3 前段「生命扣减可读」 | `segments_lost` 未变时禁止 emit（不伪造扣血）；不得对连续重叠重复扣血（无敌期内无重复伤害，决策 #4/S2）；不得引入惩罚性音画/震动/慢动作（非惩罚 Pillar 4） |
| **invulnerability（无敌态可读）** | 规则核允许接触后进入的无敌状态（short contact invulnerability，机制边界 ADR-TECH-05） | 作为「本接触周期内不再重复扣血」的可读信号：呈现（如格子的临时保护状态/文本标记）表明已进入无敌、连续重叠不再扣格；可选无限/克制、非色彩 | Gate 3 前段「CONTACT-overlap（无敌内无重复伤害）」；UX-13 | 不得冻结无敌时长的精确表现（时长归 Systems ledger）；不得用色彩作唯一通道；不得把无敌态呈现成惩罚/负面反馈 |
| **separation（轻分离可读）** | 规则核/引擎接触后果（light separation，机制边界 ADR-TECH-05） | 作为「接触后恢复可读间距」的可读信号：被分离的 pair 呈现可恢复的空间关系（可结合移动观察，不代替移动本身） | Pillar 4 非惩罚（可恢复而非 sticky lock）；中阶 C6 §6 撤离/恢复观察 | 不得把分离呈现成强制击退/惩罚击飞；distance/direction 归 Systems ledger；不得本单元冻结分离反馈形态 |
| **re-arm（再武装可恢复）** | 分离谓词满足后重新合法的接触资格（re-arm，Systems §6.1） | 作为「一次新合法接触可发生」的可读前提：分离后 pair 的接触资格恢复→未来可能再触发一次扣血（而非连续重叠重复扣血） | C6「接触合法 vs 连续重叠」可辨（决策 #4） | 不得把 re-arm 呈现成「连续重叠也重复扣血」（持久重叠不重复伤害，决策 #4/S2/re-arm 语义）；re-arm 精确谓词归 Systems ledger |

### 4.3 禁止 emit 汇总闸门（Engineer 落地为硬性 gate）

1. `segments_lost` 未实测变化 → **life loss 反馈类禁止 emit**（不伪造扣血/无 phantom damage）。
2. 反馈类与绑定规则源不符 → 禁止（如 life loss 反馈但规则核 `segments_lost` 未变、invulnerability 反馈但无敌状态未进入）。
3. 无敌期内同一 pair 连续重叠 → **禁止重复扣血反馈**（只允许无敌态可读，不重复扣格）。
4. marker 缺失（life/damage 反馈类未附接触伤害事件因果源引用）→ 禁止 emit（否则 Gate 3 无法归因）。

---

## 5. C6 明确排除清单（本单元 C5/C6 **不得**落地——防蔓延红线）

| # | 排除项 | 依据 | 边界（什么不得做） |
|---|---|---|---|
| E1 | **life 数值语义（接触扣几点 / 三格如何消耗）** | `life segments_lost` 数值语义 `unresolved`，归 Systems 在 contact 单元 CONTACT ledger 定义（READ_MODEL_MINIMAL_FIELDS / READ_MODEL_IMPLEMENTATION_LIST 已定位；Producer 排程 §4.2 P2） | UX 不代 Systems 定「一次接触扣多少」；不写死为规则常数/Gate 判据（写死即 D2 升级，AUTH-01 / D2-Card 1） |
| E2 | **连续重叠 / 同时接触 / 分离数值语义** | cr-006..009 精确值全 `unresolved`；Systems §6.2（damage、invulnerability timing、separation distance/direction、stacking、boundaries） | UX 不代 Systems 定数值/多目标堆叠规则；不冻结无敌/分离精确时长距离方向 |
| E3 | **伤害反馈/无敌/分离的精确表现形态（音画/震动/文字稿）** | `unresolved`；占位表现（ColorRect/Line2D/Label）由 Engineer 承担 | 不冻结文案/符号/时长/震动/音色为批准形态；不把占位表现当发布承诺 |
| E4 | **HUD 布局 / 锚点 / 安全区 / 缩放** | `unresolved`（UX 合同 §6.1/§7）；UX-09 只保证字段先于布局、不遮挡 | 无像素/间距/对齐/字体冻结；NEXT_IMPL_UNIT_PLAN §5 明确「hint/文案/布局/资产不冻结」 |
| E5 | **资产 / 动画 / 音频 / 数值** | NEXT_IMPL_UNIT_PLAN §8 范围边界 | 使用最小占位表现；无数值提升；接触数值走 ledger 候选、promotion=User |
| E6 | **生命耗尽终局 / 重试 / terminal 结果呈现** | cr-014..015 延后；Pr2 本单元仅提供 life 扣减字段骨架与「同帧生命优先」锚点字段，不实现终局仲裁 | 不实现生命耗尽后的结果呈现/自动重试；不把 `life_state` 终结态呈现本单元落地 |
| E7 | **升级 / B2 / focus / spawn / 敌人多段 HP** | cr-010..013, 016..019 延后；spawn 显式留空 | 不挤入；只保留结构位 |
| E8 | **升级 Gate/发布判据** | AUTH-01 §6 / Producer 排程 §7 D2-Card 1/2/3 | 不把任何 contact 数值/字段呈现升级为 Gate 判据/发布会文案；条件触发 D2 立即呈交用户 |
| E9 | **候选预算 / 性能测量** | 六项候选 + `1280×720` 红线仅候选 | 本单元不测量、不判定、不升级 |
| E10 | **内部分级细节** | ADR-TECH-02 R3/R4 注记 | 接触的内部 drain/碰撞几何细节不进 presentation 子集（presentation 只消费 read-model 信号，ADR-TECH-01） |

---

## 6. C6 — 玩家伤害体验观察目标清单

> 观察目标总体：**接触→伤害→生命损失→撤离/恢复** 的**可读、非色彩、可归因、非惩罚**维度（**对齐 UX-02/03 + Pillar 4 + 决策 #4/#5/#19**）。观察执行归 Independent QA，在 Gate 3 前段独立观察；**本文件只固化观察目标，不声称观察已执行**。

### 6.1 观察目标（逐项：可观察面 → 绑定信号 → 关联 UX 观察目标 → 禁止/边界）

| # | 观察目标 | 可观察面（绑定 read-model 信号） | 关联既有 UX 观察目标 | 禁止项 / 边界 |
|---|---|---|---|---|
| **D1 接触伤害可归因** | 合法接触 → 单次伤害 → `segments_lost` 实测 +1 → life 格扣失可读，玩家可把「扣掉一格」归因到「一次合法接触」 | `contact_damage_event`（域事件）→ `life.segments_lost` 实测变化 → life loss 反馈类 emit（feedback-binding marker）；三格从 `[o][o][o]`→`[x][o][o]` 变化可观察 | UX-02 N3（攻击→结果归因同族）；UX-13（非色彩）；Gate 3 前段「生命扣减可读」 | 不得把扣失读成无接触的随机掉血（S2 无 phantom damage）；不得把扣失读成惩罚 |
| **D2 「接触合法 vs 连续重叠」可辨**（决策 #4） | 一次合法接触 = 单次伤害事件（无敌吞并连续重叠）；连续重叠**不**重复扣血（无敌态可读）；二者在可观察面上边界分明 | invulnerability 可读信号（无敌期内无重复扣失）+ re-arm 可读（分离后重新合法）；`segments_lost` 只在一次合法接触结算时 +1、连续重叠不 +1 | 决策 #4; ADR-TECH-05; Systems §6.1; Gate 3 前段 CONTACT-overlap | 不得把连续重叠被无敌吞并呈现成「无反馈/卡住」；不得把同时接触设计为 N× 重复扣血（改决策 #4 → D2-Card 2 升级） |
| **D3 非色彩可读**（UX-13 / 决策 #19） | life 格已失/存活、伤害反馈、无敌态、re-arm 全部以形状/文本/分区非色彩传达；色彩仅装饰 | life 格 `x`/`o` 形状标记 + `segments_lost=N` 文本 + 伤害/无敌态文本/形状信号 | UX-13; UX 合同 §7 | 不得让任何状态仅以色彩传达；不得依赖色值作唯一通道 |
| **D4 非惩罚 / 可恢复**（Pillar 4 / 决策 #12） | 生命周期损失被读为 light interruption（短、可恢复）而非 sticky lock；分离后玩家可撤离/恢复、不会被连续粘住重复扣血 | separation/re-arm 可读（恢复可读间距与再武装资格）+ 无敌吞并（不被连续重叠惩罚）→ 保留可恢复通道 | Pillar 4; 决策 #12（defeat=light interruption）; UX 合同 §3 Defeat 行（life depletion 后立即重试，终局语义延后） | 不得把伤害呈现成惩罚性击退/强制/惩罚性慢动作/震动；不得把接触做成 sticky lock（Systems §6.1「可恢复而非粘住」） |
| **D5 反馈类 ↔ 规则源因果一致**（可归因闸门） | 每条 life loss/invulnerability/separation/re-arm 反馈类都带接触伤害事件/规则核 life 状态的因果源引用 | feedback-binding marker（同 §4.2 通用规则） | UX-03 S2（反馈绑定同族）; ADR-TECH-02 | 无 marker 禁止 emit；无接触事件禁止扣失反馈（S1/S2 不伪造） |
| **D6 HUD 不遮挡**（UX-09） | life HUD 与伤害反馈不覆盖 player silhouette / nearest danger / enemy tide / recovered space | runtime frame 观察：player/danger/space 与 HUD/反馈无重叠 | UX-09; UX 合同 §6.2 第一读优先 | 不得让 HUD/伤害反馈遮挡可玩区；`1280×720` 红线仅候选 |

### 6.2 与真实移动联动（U2-B/C 场景衔接）

- **移动 → 撤离/恢复关联:** 玩家用真实移动（U2-B 移动改变簇、U2-C 移动不改变簇——均已在单元 2 独立观察 R1 input→movement 因果）在接触后**撤离**（移离危险、重获间距）与**恢复**（回到安全通道、可继续攻击）。C6 观察把「接触伤害后玩家仍可用移动撤离/恢复」与既有 U2-B/C 移动基线联动——接触体验不剥夺既有移动控制、不把移动读成纯闪避（UX 合同 §1.2）。
- **可观察绑定:** 接触伤害后玩家 position 变化（可恢复移动）→ 间距恢复 → re-arm 资格 → 未来一次新合法接触可发生，而非连续重叠重复扣血。与 `[RUNTIME] player_moved`（QA_PLAYABLE_SLICE §3.1）同族联动。

### 6.3 支撑 QA Gate 3 前段判据 + 诚实边界（O8 受限）

- **支撑判据（供 QA 制判据，非本文件冻结）:** 接触惩罚/NOT 连续重叠重复扣血 / 分离可恢复 / 生命扣减非色彩可读（UX-13）/ HUD 不遮挡（UX-09）/ 玩家伤害可归因非惩罚（对应 `NEXT_IMPL_UNIT_PLAN_v0_3.md §5` Gate 3 前段行 + D2-Card）。
- **诚实边界（O8）:** 依 QA_PLAYABLE_SLICE §6 O8——**真人键盘自由操作全程未完全独立验收**（单元 2 为受限 key 注入 D/W）。因此 C6 的接触体验观察同样受此约束：真实移动→接触→撤离/恢复的完整演示以**受限注入/有界演示**观察、如实声明，C6 不把 O8 未覆盖的「真人自由操作」当作已完成验收；不因 C6 固化观察目标而豁免 QA 或授予任何 Gate 3+ 免除。
- **观察执行依赖:** 未来授权 fixture（CONTACT-\*）+ runtime frame + Independent QA 独立观察（Gate 3 前段）。本文件**不执行、不声称观察**。

---

## 7. 与 QA 验收衔接（支撑未来 Gate 3 前段观察）

- **C5 呈现对接（READ_MODEL_IMPLEMENTATION_LIST §4.1 扩展）:** `life` 字段从「`segments_lost` 恒 0 结构位」扩展为「实测扣减呈现」——QA 以 runtime frame 观察 `[x][o][o] segments_lost=1` 形态、非色彩可读（UX-13）、HUD 不遮挡（UX-09）、反馈类绑定接触伤害事件（feedback-binding marker）。
- **C6 观察对接（NEXT_IMPL_UNIT_PLAN §5 / C6 行）:** 玩家伤害体验形态——接触→伤害→生命损失→撤离/恢复**可归因、非色彩、非惩罚**（UX-02/03 + Pillar 4）；「接触合法 vs 连续重叠」可辨（决策 #4）；与真实移动（U2-B/C）联动。
- **对齐 CONTACT-\* fixture（Systems §6.3 / Producer 排程 C3）:** CONTACT-single（恰一次合法伤害、无敌进入、分离 emit）/ CONTACT-overlap（无敌内无重复伤害、re-arm=false）/ CONTACT-separate-rearm（分离后恰一次新合法接触）/ CONTACT-simultaneous（并/堆叠——边界作明确未决上报、推荐默认单次伤害事件+无敌吞并）/ CONTACT-boundary（边界分离与可恢复）/ CONTACT-removal（保护期移除→状态清理+未来 re-arm）。

---

## 8. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed（含决策 #4 contact 单次伤害事件 / #5 life 三格&同帧生命优先 / #12 defeat=light interruption / #19 非色彩可读）；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11（含 PRECHARTER-03 接触合法性）；ADR-TECH-01..06 批准（R11，含 TECH-05 机制边界 / TECH-02 read-model）；UX-03 S1–S3；AUTH-01（R13 实现授权）；单元 1/2 QA verdict `pass`。本清单不重写、不重分类任何一项；life 数值语义 unresolved 归 Systems。
- **`team_proposal`（本清单实质贡献）:** C5 life 扣减呈现绑定清单（`segments_lost` 从结构恒 0 → 实测扣减呈现：life 三格形状/文本分区非色彩、扣减反馈类逐一绑定接触伤害规则源 + 禁止 emit 汇总闸门）+ C6 玩家伤害体验观察目标（D1..D6：接触伤害可归因 / 接触合法 vs 连续重叠可辨 / 非色彩可读 / 非惩罚可恢复 / 反馈因果一致 / HUD 不遮挡；与真实移动 U2-B/C 联动；支撑 QA Gate 3 前段 + O8 诚实边界）。全部为提案，供 Engineer（落地）与 QA（观察判据）参考，**不升级任何契约**。
- **`assumption`:** ① 接触伤害事件的规则核效果（`segments_lost` 实测扣减）可在已批准 read-model 契约内落地且可被独立 QA 前段观察归因（需 Engineer 落地 + QA 观察验证）；② 非色彩可读可由占位表现（形状/文本/分区）满足（需 QA 观察验证）；③ life 扣减反馈绑定接触伤害规则源后可在 runtime frame 可读（需未来观察验证）；④ C6 观察受 O8 边界约束（真人自由操作受限，仅限受限注入/有界演示）。未观察前不得视为成立。
- **`unresolved`（全量保留，未关闭）:** `life segments_lost` 数值语义（归 Systems CONTACT ledger 定义）；cr-006..009 精确值（接触判定/无敌时长/分离距离方向/堆叠同时接触/边界/分离失败）；连续重叠/同时接触/分离的精确数值语义与表现形态；伤害/无敌/分离/re-arm 反馈的精确表现种类与时长；生命耗尽终局/重试（cr-014..015）；升级/B2/focus/spawn/敌人多段 HP；HUD 布局/文案/资产；O8 真人键盘自由操作未全量验收；候选预算（六项 + `1280×720` 红线）——全部保持 open，本清单不闭合、不升级任何项。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本清单未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升；未批准/冻结任何契约/规则语义/数值/表现形态。

---

## 9. 边界声明与 Closure

- **本文件是 C5+C6 UX 提案**：C5 为 Engineer 落地参考（范围 = `segments_lost` 从结构位到实际扣减呈现绑定）；C6 为 QA Gate 3 前段观察目标固化的输入。最终产品裁决与验收归属 User 与 Independent QA。
- **未落地实现**：未写/改任何 `.gd`/`.tscn`/`.tres`；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；无 runtime/visual/QA 证据。
- **未批准/冻结任何合同/ADR/Systems 终裁/fixture schema/数值/表现形态**：life 数值语义、cr-006..009 精确值、伤害反馈表现形态、布局/文案/资产均不冻结；候选数值不提升；QA 不豁免。
- **未替 QA 下 verdict / 未豁免 QA blocker / 未替 Engineer 落地 / 未替 Systems 定规则语义（life 数值、接触判定、无敌/分离/re-arm 数值）。**
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。
- **写入面**：仅本唯一 C5+C6 交付物文件 `CONTACT_UX_OBSERVATION_v0_1.md`；未修改任何其它文档。

**Closure:** `closure_ready = yes`（仅限本 C5+C6 UX 提案 artifact）。本提案非实现派发、非契约批准、非 QA 验收、非产品裁决；父协调器依据本清单派发 Engineer（落地 C5）与 Independent QA（观察 C6 Gate 3 前段）。写入后停止，不进入下一阶段、不派发任何成员。

---

## 10. 版本与变更记录

- **v0.1（本文件）:** UX/UI Designer 唯一新产物——接触单元 C5+C6 提案合并交付。C5：`segments_lost` 从结构恒 0 → 实际扣减呈现绑定清单（life 三格形状/文本分区非色彩可读、扣减反馈类逐一绑定接触伤害规则源 + 禁止 emit 汇总闸门、继承 READ_MODEL_IMPLEMENTATION_LIST §4.1 扩展语义）；C6：玩家伤害体验观察目标 D1..D6（接触伤害可归因 / 「接触合法 vs 连续重叠」可辨（决策 #4）/ 非色彩可读（UX-13）/ 非惩罚可恢复（Pillar 4）/ 反馈因果一致（feedback-binding marker）/ HUD 不遮挡（UX-09））+ 与真实移动 U2-B/C 联动 + 支撑 QA Gate 3 前段判据 + O8 诚实边界（受限注入/有界演示）；明确排除清单（life 数值语义 / 接触数值 / 伤害反馈表现形态 / HUD 布局 / 资产 / 终局重试 / 升级 B2 focus spawn / 升级 Gate / 性能候选 / 内部分级）。只提案，落地归 Engineer，观察归 QA；未修改任何其它文档。
