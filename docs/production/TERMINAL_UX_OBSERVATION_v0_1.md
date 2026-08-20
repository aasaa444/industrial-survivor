# TERMINAL UX OBSERVATION v0.1 — T5 结局呈现观察目标 + 结局状态字段 → 呈现绑定清单（提案）

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DESIGN ONLY` — 本文件为 **UX/UI 唯一新产物**：交付 T5 结局呈现观察目标（victory/defeat 可读、非惩罚、非色彩 UX-13、不遮挡 UX-09、立即重试节奏）+ 结局状态字段 → 呈现绑定清单（presentation 只消费 read-model，ADR-TECH-01/02）。**不落地实现**——落地归 Engineer（经 GDMCP，终结/重置单元 T2/T4）；观察执行归 Independent QA（Gate 3 前段，终结/重置单元 T）。**结局可玩性门（M1）确认留用户**（授权边界外），本文件不下通过/阻断结论。
> **Role / owner (sole author):** UX/UI Designer（UX/UI 设计师）——T5 提案唯一 OWNER；落地归 Engineer；观察验收归 QA；产品可玩性门裁决归 User。
> **Report ID:** `TERMINAL_UX_OBSERVATION_v0_1`
> **Expert capability:** `godot-ux-ui-expert` — 解析路径 `C:\Users\User\.agents\skills\godot-ux-ui-expert\SKILL.md`。**接口实测结论（DSH 实测纪律）:** 本会话运行时**实际发起 `skill({ name: "godot-ux-ui-expert" })` 调用并成功**（返回完整 SKILL 指令；未报 unknown tool / 接口不存在错误）；`tools.skill` 包装器在本运行时不独立存在，以直接 `skill(...)` 调用成功。**能力证据等级 = `strong_member_skill`（首选等级）**；无需 fallback 到 SKILL.md 读取（虽按纪律亦已实际读取 SKILL.md 头部佐证文件存在性）。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本文件仅依据任务允许的 9 份指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；无 runtime/visual/QA 证据）。
> **前置事实（仅可使用这些）:** AUTH-01（R13）实现授权已生效；Producer 排程 `NEXT_IMPL_UNIT_PLAN_v0_4.md`（单元 4：终结/重置，cr-014/cr-015，AUTH-01 判定 D1、结局可玩性门 M1 留用户）已落；单元 1/2/3 已验收（单元 3 life `LIFE [o][o][o]` 结构位呈现、`segments_lost` 真实扣减、contact read-model 绑定）；ADR-TECH-01/02 已批准（presentation 只消费 read-model、不伪造、不成为第二规则权威）、ADR-TECH-05 终局仲裁+重置机制边界已批（同帧生命优先、result/input lock、short clear result、one canonical automatic reset；精确数值语义延后）；决策 #5（life 三格&同帧生命优先；结果+立即重试）、#11（victory=控制完成）、#12（defeat=light interruption）、#17（失焦安全方向）、#19（非色彩可读）`user_confirmed`；UX-03 S1–S3 已固化（no-target quiet/不伪造）；Pillar 4 非惩罚、§9.2 playability gate（「immediate retry after failure without punitive delay」首次实测点，确认留用户）；候选预算仅候选、本清单不触碰数值。

---

## 1. Expert preflight（godot-ux-ui-expert，应用于本 T5 任务）

- **目标玩家/上下文:** PC-first 单人玩家进入 8 分钟有界 Slice；本单元（终结/重置）关键旅程 = 「接触使生命可耗尽 → 生命耗尽（defeat #12）或八分钟完成（victory #11）→ 终局仲裁 → result/input lock → **短而清晰的结果呈现** → **自动立即重置/重试** → 新局无越局损失」。T5 = 固化该结果呈现的**可观察目标**（victory/defeat 可读、非惩罚、非色彩、不遮挡、立即重试节奏），并给出**结局状态字段 → 呈现绑定清单**（Engineer 可执行，只消费 read-model），支撑 QA Gate 3 前段独立观察。
- **关键理解风险（本清单须防）:** ① 结局结果若只以色彩区分 / 遮挡 player/danger/space → 违反 UX-13 / 决策 #19（非色彩可读）+ UX-09（不遮挡）；② 结局呈现若被玩家读成惩罚/卡死/锁死 → 违反 Pillar 4 非惩罚 / 决策 #12（defeat=light interruption）；③ 结果/重试延迟或呈现造成「输入被锁但玩家不知可重试」的卡死感 → 违反 §9.2「immediate retry after failure without punitive delay」；④ 结局状态字段若由 presentation 自我推断/伪造（如无生命耗尽事件却呈现 defeat）→ 违反 ADR-TECH-02（不伪造）/ ADR-TECH-01（presentation 不成为第二规则权威）；⑤ 结果呈现若被提升为 Gate 判据 / 发布承诺 → 违反 AUTH-01（条件触发 D2 升级，D2-Card 1/3）。
- **目标窗口/输入条件:** 16:9 基线 + {16:9, 16:10, 21:9} 方向性候选（DC-PLAT-02 Option 2 / R03）；键盘 WASD/方向键；`1280×720` 红线仅候选。
- **范围内状态（本单元 T5）:** 结局状态字段（victory/defeat/result、结果时长、自动重置触发）→ 呈现绑定；victory/defeat/result lock 期间玩家的可读状态；自动立即重试节奏的呈现绑定。**不在范围内**：终局仲裁的数值/时序语义（归 Systems T1 ledger）、升级/B2/focus-full/O11/spawn/候选预算、结局呈现精确形态/hint/文案/布局/资产冻结。
- **证据路线:** 本清单（UX 提案）→ Engineer 落地（GDMCP，T2/T4）→ Independent QA 独立观察（Gate 3 前段：结局/重试可读、非惩罚、立即重试、O10 终局帧补捕获）。本文件只提供**呈现绑定清单 + 观察目标**，**不声称任何 runtime/visual/QA 证据**。
- **所有权边界（不代权）:** UX 提案 presentation-facing 呈现绑定 + 观察目标；**不代 Systems 定规则语义**（终局判定/同帧时序/结果时长/重置触发/陈旧输入拒绝精确语义归 Systems T1 ledger，PROPOSAL、promotion=User、不锁常数）；**不代 Tech 定 tick/event/session 重置事务**；**不代 Engineer 落地**（T2/T4 落地归 Engineer 经 GDMCP）；**不代 QA 下 verdict**；**不代用户确认结局可玩性门（M1）**；不批准/冻结任何合同/数值/表现形态；不豁免 QA。
- **停止条件:** 唯一 T5 交付物文件写入即停；不进入实现、不派发任何成员。

---

## 2. 实际工具顺序与专家能力加载（真实记录）

| # | 工具/动作 | 结果 |
|---|---|---|
| 1 | `skill({ name: "godot-ux-ui-expert" })` | ✅ **实测成功**（返回完整 SKILL 指令；未报 unknown tool / 接口不存在）。能力证据等级 = `strong_member_skill`（首选）。按 DSH 实测纪律（2026-08-16），不以函数清单判断接口不可用——已实际发起调用验证。`tools.skill` 包装器本会话不独立存在，以直接 `skill(...)` 调用成功。 |
| 2 | 读取 `C:\Users\User\.agents\skills\godot-ux-ui-expert\SKILL.md` 头部（佐证文件存在性） | ✅ 实际读取成功（文件存在、header 完整）。作为 `strong_member_skill` 之外的可审计佐证。 |
| 3 | 并行 read `NEXT_IMPL_UNIT_PLAN_v0_4.md` / `CONTACT_UX_OBSERVATION_v0_1.md` | ✅ 全部实际读取成功 |
| 4 | 并行 read `READ_MODEL_MINIMAL_FIELDS_v0_1.md` / `READ_MODEL_IMPLEMENTATION_LIST_v0_1.md` / `UX_OBSERVATION_TARGETS_CR001_v0_1.md` | ✅ 全部实际读取成功 |
| 5 | 并行 read `KICKOFF_UX_UI_CONTRACTS_v0_1.md` / `KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md` / `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` | ✅ 全部实际读取成功 |

> **能力证据等级:** `strong_member_skill`（首选接口直接调用成功并返回完整 SKILL）。**接口实测结论:** `skill` 接口本会话**可调用且实测成功**；`tools.skill` 不独立存在（直接 `skill(...)` 成功）。未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

---

## 3. 设计原则（对齐已批准契约，T5 的硬边界）

1. **presentation 只消费 read-model，不成为规则权威**（ADR-TECH-01）：victory/defeat/result 呈现与自动重置节奏必须回溯到规则核终局消息或域事件（终局仲裁输出），不得从视觉状态自我推断结局、不得在无终局信号/触发时呈现结果、不得伪造 defeat/victory。
2. **不伪造、feedback-binding**（ADR-TECH-02 / UX-03 S1/S2 同族纪律）：每一条结局呈现/结果反馈类都须携带与终局规则源（terminal outcome / result lock / reset trigger）的因果绑定标记（反馈类 ↔ 规则源），供 Gate 3「反馈类与规则源因果一致」观察直接对齐；defeat 只在生命耗尽事件实测发生时呈现、victory 只在控制完成（八分钟）实测完成时呈现。
3. **非色彩、非仅色彩**（UX-13 / 决策 #19 / UX 合同 §7）：victory/defeat/result 状态与 result-lock 可读状态均需以形状/文本/分区等**结构化非色彩信号**可读；色彩仅作可选装饰，不作唯一通道。
4. **不遮挡**（UX-09 / UX 合同 §6.2）：结果呈现不得遮挡 player silhouette / nearest danger / enemy tide / cleared space / restart entry（第一读优先；result 期「result priority 高于装饰」仅在终结态成立，不得遮挡可玩/可读主区）。
5. **非惩罚 / 立即重试**（Pillar 4 / 决策 #12 / §9.2「immediate retry after failure without punitive delay」）：defeat = light interruption（短、可恢复、非惩罚锁死）；结果短而清晰 bounded；自动立即重置路径呈现在输入锁解除后可辨、非惩罚延迟；玩家在 result/input lock 期间**输入被锁但可辨、非卡死感**。
6. **呈现为可观察信号，不提升为判据**（AUTH-01 §6 / 排程 §6 D2-Card 1/3）：本清单全部为「字段 → 呈现绑定 → 观察对接」的结构契约；无像素、无阈值、无刻点数、无 timing 常数、无文字稿、无资产；**不把任何结局字段呈现升级为 Gate 判据 / 发布承诺**；结局呈现形态触碰 player promise（非惩罚）/核心支柱/被提议为发布文案 → 条件触发 D2-Card 3 呈交用户。
7. **不冻结 hint/文案/布局/资产**（范围边界惯例 / NEXT_IMPL_UNIT_PLAN §5/§8）：结局呈现的精确文案/布局/资产/时长形态 `unresolved`，本清单只固化观察目标与呈现绑定，不冻结任何形态。

---

## 4. T5A — 结局状态字段 → 呈现绑定清单（Engineer 可执行）

> 约定：**字段**——**类型**——**来源**（`RULES`=规则核终端消息直读 / `EVENT`=adapter 由域输出翻译的 presentation 面向字段 / `SESSION`=session 生命周期重置事务）——**呈现绑定方式**——**关联 UX 观察目标**——**禁止项**（Engineer 落地时不得做）。
>
> 字段名以 `PROPOSAL` 级命名（对齐 READ_MODEL_MINIMAL_FIELDS / READ_MODEL_IMPLEMENTATION_LIST / Systems §5.3 fixture schema 的 `terminal_candidate`/`terminal_result`/`reset_epoch` / ADR-TECH-05）；**不具备规则语义**——精确终局判定/结果时长/重置触发语义归 Systems T1 ledger（PROPOSAL、promotion=User、不锁常数），本清单只做呈现绑定。

### 4.1 结局状态字段（victory / defeat / result 呈现源）

| 字段 | 类型 | 来源 | 呈现绑定方式 | 关联 UX 观察目标 | 禁止项 |
|---|---|---|---|---|---|
| `terminal_outcome` | enum（`victory`=控制完成八分钟 #11 / `defeat`=生命耗尽 light interruption #12 / `none`=非终局态） | `RULES`（规则核终局仲裁输出；同帧生命优先已批、精确时序归 Systems ledger）+ `EVENT`（adapter 翻译为 presentation 面向） | 驱动结果呈现**唯一权威信号**：`victory` → 短而清晰的「控制完成」结果呈现（非色彩）；`defeat` → 短而清晰的「light interruption」结果呈现（非色彩非惩罚）；`none` → 不呈现任何结果。呈现绝不自我推断结局 | UX-13（非色彩可读）；UX-09（不遮挡）；Pillar 4 / 决策 #12；Gate 3 前段「结局可读、非惩罚」 | presentation 不得在 `terminal_outcome` 未变/无终局信号时呈现 or 伪造结果（ADR-TECH-02）；不得以色彩作为 victory/defeat 唯一区分（UX-13 / #19）；不得把结局呈现形态冻结/提升为 Gate 判据（D2-Card 3） |
| `result` | 结构态（`result_active:bool` + 语义继承 `terminal_outcome`） | `RULES`（规则核 result/input lock 已批机制边界 ADR-TECH-05；精确时长归 Systems ledger）+ `SESSION` result 生命周期 | 「玩家正处结果呈现/输入锁」的可读结构位：`result_active=true` → 呈现迭代表明「本 run 已终结、结果可读」并进入输入锁；`false` → 正常 combat 呈现。结果标签/状态在视觉与语义上被置于可读优先（对齐 UX 合同 §3 Result 行） | UX-09；UX-13；Gate 3 前段「result 可读、非惩罚」 | 不得用 `result_active` 自我推断 `terminal_outcome`（呈现只消费规则核结果态）；不得把 result 呈现为多一步「确认输入」（结果不需确认，输入不用于重启，决策 #5）；不得让 result 期遮挡 player/danger/space 主区（UX-09） |
| `result_duration` | 只读呈现节（`result_active` 起讫可观察；**时长数值归 Systems ledger，不写常数值**） | `RULES`（规则核 result/input lock 边界+结束触发语义）+ `EVENT`/`SESSION` | 供「结果短而清晰、然后自动重置」的**可读节奏**观察：结果时长作为可观察长度（bounded、短）供 QA 计时观察；呈现绑定不引入数值承诺 | UX 合同 §3 Result 行（duration unresolved）；§9.2 立即重试节奏；Gate 3 前段「立即重试无惩罚延迟」 | 不得把 result 时长写为规则常数/Gate 判据/发布承诺（promotion=User；写死即 D2 升级 D2-Card 1）；不得由 presentation 决定何时结束 result（结束触发归规则核/session） |
| `victory_distinction` / `defeat_distinction` | 非色彩结构化信号（形状/文本/分区符号） | `EVENT`（由 `terminal_outcome` 驱动呈现；非色彩形态为守卫要求非冻结形态） | victory 与 defeat 以**非色彩信号**可读区分（如文本「VICTORY 控制完成」/「DEFEAT light interruption」+ 形状/分区标记），不以色值作唯一通道；两态彼此**可区分可读** | UX-13 / 决策 #19；UX 合同 §7 非色彩通信；Gate 3 前段「结局非色彩可读、victory/defeat 区分」 | 不得让 victory/defeat 仅依赖色彩区分（UX-13）；不得冻结精确呈现形态（文案/符号/布局 unresolved）；不得把 defeat 呈现成惩罚锁死（Pillar 4 / #12） |

### 4.2 result / input lock 期间玩家的可读状态（输入被锁但可辨、非卡死感）

| 字段 | 类型 | 来源 | 呈现绑定方式 | 关联 UX 观察目标 | 禁止项 |
|---|---|---|---|---|---|
| `result_lock_active`（presentation 可读节） | bool（`true`=result/input lock 生效，gameplay/confirmation 输入被锁） | `RULES`（ADR-TECH-05 result/input lock 已批机制边界；陈旧输入拒绝精确语义归 Systems）+ `EVENT` | 「输入被锁但玩家可辨」的可读信号：`result_lock_active=true` → 呈现明示 result 态 + 输入锁（移动/确认输入在 result 锁内不产生玩法后果），而非「无反馈卡死」；锁期拒 gameplay/confirmation 输入（对齐决策 #17 方向 + TECH-05） | UX-09（可读优先级）；Gate 3 前段「input lock 期间可读、非卡死感、陈旧输入拒绝」；UX-08（fresh epoch/拒陈旧同族） | 不得把 input lock 呈现成「无任何反馈的卡死」（非卡死感要求）；不得冻结陈旧输入拒绝的精确实现（归 Systems/Engineer）；不得让锁期呈现成惩罚锁死（Pillar 4）；不得由 presentation 决定解锁时机（解锁归规则核/session） |
| `pending_reset`（reset/自动重试触发呈现节） | 结构态（result 结束 → 自动重置准备的可读标记，**触发语义归规则核/session**） | `RULES`（ADR-TECH-05 one canonical automatic reset 机制边界）+ `SESSION`（session 唯一 owner 重置事务，RNG/ID/session 重置归 session） | 「自动立即重试将在 result 后出现」的可读衔接：result 呈现短暂 → 自动重置路径呈现在输入锁解除后**可辨**（玩家可读「将重新开始」而非突兀无接续）；不引入多一步确认 | §9.2 立即重试节奏；UX 合同 §3 Result/Restart 行；Gate 3 前段「立即重试无惩罚延迟、无越局损失视觉」 | 不得把自动重置呈现成需玩家多一步确认（决策 #5 结果不需确认）；不得把重置读成越局损失（`RESET-no-cross-run-loss` 观察）；不得冻结重置触发精确时序（归 Systems/Engineer）；不得由 presentation 决定重置执行（执行归 session） |

### 4.3 自动立即重试节奏的呈现绑定

| 字段 | 类型 | 来源 | 呈现绑定方式 | 关联 UX 观察目标 | 禁止项 |
|---|---|---|---|---|---|
| `auto_restart_visible`（retry 节奏呈现节） | bool/节（自动重置后新局可辨、无越局损失） | `SESSION`（session owner 自动立即重试路径 + 新局无越局损失；entry 层级可读由 presentation 呈现） | 「自动立即重试后可辨新局」的可读衔接：reset 后 entry 层级可识别（对齐 UX 合同 §3 Restart 行），玩家可读新 run 开始、可立即移动/观察；节奏呈现场景 = result → auto reset → 新局 entry（无越局损失视觉） | §9.2 立即重试节奏；UX 合同 §3 Restart；Gate 3 前段「自动立即重试、新局无越局损失」 | 不得把 auto-restart 呈现成惩罚性延迟/多步确认；不得让新局携带上局脏状态（`RESET-no-cross-run-loss`）；不得冻结 retry 节奏精确形态（归 Systems/Engineer）；不得由 presentation 决定何时 reset（执行归 session） |
| `reset_epoch_visible`（可选，结构位） | 仅结构占位（`reset_epoch` 语义归 Systems/Tech 会话事务，本清单不引入行为） | `SESSION`（session 重置/RNG/ID/输入清理）+ `RULES`/`EVENT`（作为可观察「新 run 身份已轮换」的结构位，非冻结） | 作为「新局已开始、无越局损失」的可审计结构位默认呈现/记录；**本单元仅保留结构位**，不引入运行行为 | `RESET-no-cross-run-loss`（无越局脏状态）观察；Gate 3 前段重试节奏 | 不得本单元实现完整 focus-epoch/session 重置事务细节（T4 reset 事务归 Engineer；精确语义归 Systems）；不得把 reset_epoch 升级为 Gate 判据（D2-Card 1） |

### 4.4 禁止 emit 汇总闸门（Engineer 落地为硬性 gate）

1. `terminal_outcome` 未变化为 `victory`/`defeat` → **结局反馈类禁止 emit**（不伪造结果）。
2. `terminal_outcome=defeat` 但无生命耗尽规则源 → 禁止（defeat 只绑定生命耗尽事件）。
3. `terminal_outcome=victory` 但无控制完成（八分钟）规则源 → 禁止（victory 只绑定控制完成事件）。
4. 反馈类与绑定规则源不符（如 result 呈现但 `result_active=false`）→ 禁止。
5. marker 缺失（结局/result/retry 反馈类未附终局规则源因果引用）→ 禁止 emit（否则 Gate 3 无法归因）。
6. `result_lock_active` 期间否决任何陈旧 gameplay/confirmation 输入后果的唯一权威在规则核/session——presentation 不得自行对输入"放行/拒绝"（只呈现锁态与结果）。

---

## 5. 明确排除清单（本单元 T5 **不得**落地——防蔓延红线，复用 CONTACT_UX 排除原则扩展）

| # | 排除项 | 依据 | 边界（什么不得做） |
|---|---|---|---|
| E1 | **结局呈现精确形态（victory/defeat/result 文案、符号、时长、布局、资产）** | `unresolved`（NEXT_IMPL_UNIT_PLAN §5/§8「hint/文案/布局/资产不冻结」；UX 合同 §7/§12 result copy/timing unresolved；Systems §3.2） | 不冻结任何结局文案/符号/时长/布局/资产为批准形态；占位表现（ColorRect/Line2D/Label）由 Engineer 承担；不把占位当发布承诺 |
| E2 | **hint 字段（valid-move 关联）** | ADR-TECH-02 UX R3；UX 合同 §6.3（hint 文案/触发/effective-movement 全 unresolved）；READ_MODEL_MINIMAL_FIELDS §4.4 明确排除 | 本清单**不提案** hint 字段；Engineer 不得擅自落地 hint 关联字段/因果 hint 呈现；留后续单元 |
| E3 | **结局呈现升级为 Gate 判据 / 发布承诺** | AUTH-01 §6 / 排程 §6 D2-Card 3「结局呈现形态触碰 player promise（非惩罚）/核心支柱/被提议为发布文案 → D2 升级呈交用户」 | 不把任何结局呈现形态/字段（terminal_outcome 呈现、result 时长、retry 节奏）升级为 Gate 判据或发布会文案；条件触发 D2 立即呈交用户；**不预授权结局可玩性门（M1）** |
| E4 | **终局/重置数值与精确时序** | SYSTEMS T1 ledger（终局判定/同帧时序/结果时长/清理时序/RNG·ID 重置范围/自动重置触发/陈旧输入拒绝精确语义 `PROPOSAL`、promotion=User、不锁常数）；ADR-TECH-05「exact intra-tick ordering / result duration / cleanup / RNG·ID reset / stale-input rejection remain unresolved」 | UX **不代 Systems** 定终局判定/结果时长/自动重置触发/陈旧输入拒绝语义；**不写死为规则常数/Gate 判据**（写死即 D2 升级，AUTH-01 / D2-Card 1） |
| E5 | **result 时长的数值承诺** | decision #5（结果+立即重试）user_confirmed；时长数值 `unresolved` 归 Systems | 本清单只固化可观察长度方向（bounded/短/立即），**不写秒数**；不把 result 时长升级为 release/性能承诺 |
| E6 | **完整 focus-epoch / session 重置事务细节** | 排程 §4.2 P4（自动重置/session 重置事务归 Engineer 机制）+ §4.3（focus-full 延后；本单元仅 result-lock 内最小陈旧输入拒绝）+ ADR-TECH-05（reset 契约未冻结） | 本清单不实现/不冻结完整 focus/session 重置事务；只提供 result-lock 内陈旧输入拒绝的呈现可读节 |
| E7 | **升级 / B2 / focus-full / O11 / spawn / 敌人多段 HP** | 排程 §4.3 可分离延后 | 不挤入；只保留结构位（life/b2_phase/attack_state） |
| E8 | **性能候选 / 测量** | 六项候选预算 + `1280×720` 红线仅候选 | 本单元不测量、不判定、不升级；result/retry 时长不得提升为性能判据 |
| E9 | **内部分级细节** | ADR-TECH-02 R3/R4 注记 | 终局仲裁/重置的内部 drain/event ordering 细节不进 presentation 子集（presentation 只消费 read-model 信号，ADR-TECH-01） |
| E10 | **QA 豁免 / M1 预授权 / 替 Systems/Tech/QA 代权** | 排程 §6/§7/§8（QA 不豁免；结局可玩性门确认留用户） | 不豁免 QA blocker；**不预授权 M1**；不代 Systems 定语义；不代 Tech 定事务；不代 Engineer 落地；不代 QA 下 verdict |

---

## 6. T5B — 结局呈现观察目标清单（victory / defeat / result）

> 观察目标总体：**victory（控制完成 #11）/ defeat（life interruption #12）结果呈现的 可读、非惩罚、非色彩（UX-13）、不遮挡（UX-09）、立即重试节奏（§9.2）**。观察执行归 Independent QA，在 Gate 3 前段独立观察；**本文件只固化观察目标，不声称观察已执行**；**结局可玩性门（M1）确认留用户，本文件不下通过/阻断结论**。

### 6.1 观察目标（逐项：可观察面 → 绑定信号 → 关联 UX 观察目标 → 禁止/边界）

| # | 观察目标 | 可观察面（绑定 read-model 信号） | 关联既有 UX 观察目标 | 禁止项 / 边界 |
|---|---|---|---|---|
| **R1 结局可读（victory/defeat 可辨）** | 生命耗尽 → `terminal_outcome=defeat` → defeat 呈现可读；八分钟完成 → `terminal_outcome=victory` → victory 呈现可读；两态**可区分可读**（非色彩） | `terminal_outcome`（victory/defeat）+ `victory_distinction`/`defeat_distinction`（非色彩结构化信号）+ `result_active`；终局帧 runtime 捕获（O10 补段） | UX-13（非色彩）；UX-09（不遮挡）；UX 合同 §3 Victory/Defeat 行；Gate 3 前段「结局可读」 | 不得把 defeat 读成不可辨/与 victory 混淆（状态呈现不清晰）；不得把 victory 读成普通通关无结束感（#11 控制完成）；不得缺 O10 终局帧捕获（`segments_lost=3` 或 defeat 呈现帧，尽量补单元 3 缺口） |
| **R2 非色彩可读**（UX-13 / 决策 #19） | victory/defeat/result/result-lock 全以形状/文本/分区非色彩传达；色彩仅装饰 | `victory_distinction`/`defeat_distinction` + `result_active` + `result_lock_active` 的结构化非色彩信号 | UX-13；UX 合同 §7 | 不得让任何结局/锁态仅以色彩传达；不得依赖色值作唯一通道 |
| **R3 非惩罚 / 可恢复**（Pillar 4 / 决策 #12） | defeat 读为 light interruption（短、可恢复、非惩罚锁死）而非 sticky lock/惩罚屏幕；result 期可辨非卡死 | `terminal_outcome=defeat`（#12）呈现短而清晰 + `result_lock_active` 在锁内呈现「输入被锁但玩家可辨、非卡死感」+ 自动重置衔接可辨 | Pillar 4；决策 #12；UX 合同 §3 Defeat/Result 行；§9.2 非惩罚 | 不得把 defeat/result 呈现成惩罚性延迟/慢动作/震动/惩罚屏；不得把 input lock 呈现成无反馈卡死；不得引入多步确认/惩罚菜单（决策 #5 结果不需确认） |
| **R4 不遮挡**（UX-09） | 结局呈现不得遮挡 player silhouette / nearest danger / enemy tide / cleared space / restart entry（第一读优先；result 期 result 优先级高于装饰，但不得遮可玩/可读主区） | runtime frame 观察：player/danger/space 与结局呈现无重叠（占用遮挡安全区） | UX-09；UX 合同 §6.2 第一读优先 | 不得让结局/result 层遮挡可玩区或 new-run entry；`1280×720` 红线仅候选 |
| **R5 立即重试节奏**（§9.2） | result 短而清晰 → 自动立即重置/重试 → 新局 entry 可辨、无越局损失；**无惩罚延迟** | `result_duration`（bounded/短，QA 计时）+ `auto_restart_visible` + `pending_reset`（自动重置衔接可辨）；reset 后 entry 可读、可立即移动/观察 | §9.2「immediate retry after failure without punitive delay」；决策 #5（结果+立即重试）；UX 合同 §3 Restart 行；Gate 3 前段重试节奏 | 不得把自动重试呈现成惩罚性延迟/多步确认/突兀无接续；不得让新局携带上局脏状态（`RESET-no-cross-run-loss`）；**结局可玩性门（M1）通过/阻断权确认留用户，本清单不代决** |
| **R6 反馈类 ↔ 规则源因果一致**（可归因闸门） | 每条结局/result/retry 反馈类都带终局规则源（`terminal_outcome`/`result_active`/`result_lock_active`/reset trigger）因果引用 | feedback-binding marker（同 §4.4 闸门） | UX-03 S2（反馈绑定同族）；ADR-TECH-02 | 无 marker 禁止 emit；无终局信号禁止结局反馈；defeat/victory 严格绑定对应规则源 |

### 6.2 同帧生命优先的呈现衔接（ADT-TECH-05 已批机制边界）

- **同帧生命优先锚点:** 生命耗尽优先于八分钟完成（决策 #5 + PRECHARTER-11 + ADR-TECH-05），且 lif 三格真实扣减已就位（单元 3）。T5 呈现观察使其**在结局可读面体现**：同帧内若生命耗尽，则呈现 `defeat`（而非 victory）；可观察绑定 `terminal_outcome=defeat` 对应生命耗尽规则源。
- C5 承接：life 格从 `[x][o][o]` 逐位扣减（`segments_lost` 实际值）→ 直至 `segments_lost=3` → 触发终局仲裁（defeat）——T5 使单元 3 的扣减呈现与结局呈现**因果衔接**：最终失格即 defeat 的可读前导信号（非色彩）。
- 本观察不代 Systems 定义同帧精确时序（`exact intra-tick ordering` 归 Systems T1 ledger），只按要求其在呈现面的可读结果对齐。

### 6.3 与 QA Gate 3 前段判据衔接 + 诚实边界（O8/O12 + M1）

- **支撑判据（供 QA 制判据，非本文件冻结）:** 结局/重试**可读、非惩罚、非色彩**（UX-13）/ 不遮挡（UX-09）/ **立即重试无惩罚延迟**（§9.2）/ O10 终局帧补捕获（`segments_lost=3` 或 defeat 呈现帧的 runtime 捕获，尽量补单元 3 O10 缺口）。对齐 `NEXT_IMPL_UNIT_PLAN_v0_4.md §5` Gate 3 前段行 + D2-Card 1/3。
- **诚实边界（O8/O12 + M1）:** ① **O8/O12 延续**——真人键盘自由操作「移动→耗尽→重试」完整玩家体验**未全量独立验收**（单元 2/3 为受限 key 注入/有界演示）；本清单结局/重试观察以受限确定性（self-test）+ runtime 呈现观察为主，且不把 O8/O12 未覆盖的「真人自由操作」当作已完成验收；② **M1 可玩性门确认留用户**——结局呈现为 §9.2 playability gate 首次实测点，其**确认（通过/阻断权激活）明确归属授权边界外用户**（排程 §6/§8），本清单不下通过/阻断结论、不预授权；③ 观察执行依赖未来授权 fixture（TERMINAL-\*/RESET-\*）+ runtime frame + Independent QA 独立观察（Gate 3 前段）。本文件**不执行、不声称观察**。
- 观察执行不豁免 QA；本单元不授予任何 Gate 3+ 免除。

---

## 7. 与 QA 验收衔接（支撑未来 Gate 3 前段观察）

- **结局呈现对接（NEXT_IMPL_UNIT_PLAN §5 / T5 行 + Gate 3 前段）:** `terminal_outcome`（victory/defeat）→ 结局呈现（R1/R2：可读、非色彩）；`result_active`/`result_lock_active`/`result_duration` → result/input lock 可读（R3：非惩罚、非卡死感）；`pending_reset`/`auto_restart_visible` → 自动重试节奏（R5：立即重试无惩罚延迟）；O10 终局帧补捕获。
- **TERMINAL-\*/RESET-\* fixture 对齐（Systems §6.3 / 排程 §3 T3 + ADR-TECH-06）:** `TERMINAL-victory`（控制完成 #11）→ `terminal_outcome=victory` 呈现；`TERMINAL-defeat-light-interruption`（#12）→ `terminal_outcome=defeat`；`TERMINAL-life-depletion-first`（同帧生命优先）→ 同帧相耗呈现 defeat 而非 victory；`TERMINAL-result-lock` → result/input lock 可读非卡死感；`TERMINAL-stale-input-rejected` → 结果锁内废旧输入无玩法后果（呈现节）；`RESET-auto-restart` → 自动立即重试；`RESET-no-cross-run-loss` → 新局无越局脏状态（无越局损失视觉）。
- **QA 独立观察:** 依当前版本基线独立观察；不沿用 builder 自评；不豁免 QA；本单元不授予任何 Gate 3+ 免除；**结局可玩性门 M1 确认留用户**。

---

## 8. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed（含决策 #5 life 三格&同帧生命优先/结果+立即重试、#11 victory=控制完成、#12 defeat=light interruption、#17 失焦安全方向、#19 非色彩可读）；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11（含 PRECHARTER-11 同帧生命耗尽优先于八分钟胜利）；ADR-TECH-01..06 批准（R11，含 TECH-05 终局仲裁+重置机制边界 / TECH-02 read-model 不伪造）；UX-03 S1–S3；Pillar 4 非惩罚；§9.2 playability gate（判据结构已生效、阻断权延后经 CR+用户批准激活，DC-PLAY-01 R08）；AUTH-01（R13 实现授权）；单元 1/2/3 QA verdict `pass`。本清单不重写、不重分类任何一项。
- **`team_proposal`（本清单实质贡献）:** T5A 结局状态字段 → 呈现绑定清单（`terminal_outcome`/`result`/`result_duration`/`victory_distinction`/`defeat_distinction`/`result_lock_active`/`pending_reset`/`auto_restart_visible`/`reset_epoch_visible` 全部 `PROPOSAL` 命名、只消费 read-model、禁止 emit 汇总闸门）+ T5B 结局呈现观察目标（R1..R6：结局可读/victory-defeat 区分、非色彩、非惩罚可恢复、不遮挡、立即重试节奏、反馈因果一致）+ 同帧生命优先呈现衔接（ADR-TECH-05 + C5 承接）+ 明确排除清单（E1..E10）+ QA Gate 3 前段衔接 + O8/O12/M1 诚实边界。全部为提案，供 Engineer（落地）与 QA（观察判据）参考，**不升级任何契约/数值**。
- **`assumption`:** ① 结局呈现可直接绑定规则核终局消息（`terminal_outcome`）且可在 Gate 3 前段被独立 QA 观察归因（需 Engineer 落地 + QA 观察验证）；② 非色彩可读要求可由占位表现（形状/文本/分区）满足（需 QA 观察验证）；③ result/input lock 期「输入被锁但可辨、非卡死感」可在不引入完整 focus-epoch 的前提下有界落地（ADR-TECH-05 + 决策 #17 方向，需 Engineer 落地 + QA 观察验证）；④ 结局观察受 O8/O12 边界约束（真人自由操作受限，仅受限注入/有界演示）。未观察前不得视为成立。
- **`unresolved`（全量保留，未关闭）:** 终局判定/同帧精确时序/结局时长/清理时序/RNG·ID 重置范围/陈旧输入拒绝精确语义（归 Systems T1 ledger，PROPOSAL、promotion=User、不锁常数）；结局呈现精确表现形态（文案/符号/时长/布局/资产）；hint 文案/触发/effective-movement / hint valid-move 关联字段正式落点；升级/B2/focus-full/O11/spawn/敌人多段 HP；life `life_state` 终结态枚举精确呈现；O8/O12 真人键盘自由操作未全量验收；**结局可玩性门（M1）确认归用户**；候选预算（六项 + `1280×720` 红线）——全部保持 open，本清单不闭合、不升级任何项。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本清单未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升；未批准/冻结任何契约/规则语义/数值/表现形态；**结局可玩性门确认未预授权（留用户）。**

---

## 9. 边界声明与 Closure

- **本文件是 T5 UX 提案**：T5A = 结局状态字段 → 呈现绑定清单（Engineer 落地参考，范围 = 只消费 read-model 的结局/result/重试呈现绑定）；T5B = 结局呈现观察目标（QA Gate 3 前段观察输入）。最终产品裁决与验收归属 User 与 Independent QA。
- **未落地实现**：未写/改任何 `.gd`/`.tscn`/`.tres`；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；无 runtime/visual/QA 证据。
- **未批准/冻结任何合同/ADR/Systems 终裁/fixture schema/数值/表现形态**：终局/重置数值语义、结局精确呈现形态、hint/文案/布局/资产、result 时长均不冻结；候选数值不提升；QA 不豁免。
- **未预授权结局可玩性门（M1）**：结局呈现为 §9.2 playability gate 首次实测点，其**确认（通过/阻断权激活）明确归属授权边界外用户**，本清单不下通过/阻断结论、不预授权。
- **未替 QA 下 verdict / 未豁免 QA blocker / 未替 Engineer 落地 / 未替 Systems 定规则语义（终局判定/同帧时序/结果时长/重置触发/陈旧输入拒绝）。**
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。
- **写入面**：仅本唯一 T5 交付物文件 `TERMINAL_UX_OBSERVATION_v0_1.md`；未修改任何其它文档。

**Closure:** `closure_ready = yes`（仅限本 T5 UX 提案 artifact）。本提案非实现派发、非契约批准、非 QA 验收、非产品裁决、**非结局可玩性门（M1）确认**；父协调器依据本清单派发 Engineer（落地 T2/T4 + T5 呈现）与 Independent QA（观察 Gate 3 前段），并在授权边界内呈交用户可玩性门确认。写入后停止，不进入下一阶段、不派发任何成员。

---

## 10. 版本与变更记录

- **v0.1（本文件）:** UX/UI Designer 唯一新产物——终结/重置单元 T5 结局呈现观察目标 + 结局状态字段 → 呈现绑定清单（提案）。承接 Producer 排程 `NEXT_IMPL_UNIT_PLAN_v0_4.md` 单元 4 T5 定义 + 单元 3 `CONTACT_UX_OBSERVATION_v0_1.md` 接触呈现/观察惯例 + ADR-TECH-01/02/05 + READ_MODEL_MINIMAL_FIELDS / READ_MODEL_IMPLEMENTATION_LIST 字段层。T5A：结局状态字段（`terminal_outcome`/`result`/`result_duration`/`victory_distinction`/`defeat_distinction`/`result_lock_active`/`pending_reset`/`auto_restart_visible`/`reset_epoch_visible`，全部 `PROPOSAL` 命名、只消费 read-model、禁止 emit 汇总闸门——不伪造、不成第二规则权威）；T5B：结局呈现观察目标（R1..R6：结局可读/victory-defeat 非色彩区分、非色彩 UX-13、非惩罚可恢复 Pillar 4/#12、不遮挡 UX-09、立即重试节奏 §9.2、反馈因果一致 ADR-TECH-02）+ 同帧生命优先呈现衔接（ADR-TECH-05 + C5 承接）；明确排除清单（结局形态/hint/Gate 判据/数值时序/result 时长/focus-full/升级 B2 O11 spawn/性能/内部分级/QA 豁免与 M1 预授权 E1..E10）；QA Gate 3 前段衔接（TERMINAL-\*/RESET-\* fixture、O10 终局帧补捕获）+ O8/O12/M1 诚实边界（真人自由操作未全量；可玩性门确认留用户、不预授权）。只提案，落地归 Engineer，观察归 QA，可玩性门裁决归 User；未修改任何其它文档。
