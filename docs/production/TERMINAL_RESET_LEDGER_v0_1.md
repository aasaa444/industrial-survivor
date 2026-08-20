# TERMINAL / RESET LEDGER v0.1 — 终结/重置最小语义 ledger（T1 前置）· Systems S1

>
> 覆盖:终局判定（life 耗尽 vs 8 分钟完成）/ 同帧生命优先（intra-tick ordering）/ 结局状态（victory/defeat）/ 结果时长 / 重置·重试语义（自动立即重置·无越局损失）/ 陈旧输入拒绝（结果锁内拒 gameplay/confirmation）

> **Status:** `PROPOSAL / TEAM_PROPOSAL / DRAFT / NOT APPROVED`——本文件是**终结/重置最小语义的 ledger 行/规程（PRECHARTER-04 形态）**，供 Engineer（T2 规则核 terminal 扩展 + T3 TERMINAL-\*/RESET-\* fixture + T4 adapter/运行时结局仲裁·呈现·立即重试）+ QA（Gate 2 扩展 + Gate 3 前段结局/重试·O10 终局帧补捕获 观察）实现与验收使用。
> **Promotion authority:** `User`——本文件不批准/冻结任何契约、ADR、语义或数值；任何候选数值/阈值提升为正式规则、门槛或 Gate 判据，必经 CR + 用户批准。**（AUTH-01 条件触发 D2-Card 1 / D2-Card 3，见 §6）**
> **Lifecycle:** `development governance / implementation authorization effective (R13)`；本单元 = 候选「终结/重置体验（cr-014/cr-015）」的 **T1 Systems 终局/重置语义 ledger 前置**，按 Producer `NEXT_IMPL_UNIT_PLAN_v0_4.md` §3/§4（P1/P2）派发。
> **Role / owner (sole author):** Systems / Rules Designer（系统与规则设计师，T1 唯一写 owner；本文件 = Systems 唯一写 ownership）
> **Report ID:** `TERMINAL_RESET_LEDGER_v0_1`
> **Expert capability:** `godot-systems-rules-expert` — 实测 `skill({name:"godot-systems-rules-expert"})` **调用成功**（返回值完整 SKILL 指令）。能力证据等级 = `strong_direct_skill`（首选等级；本运行时 `skill` 接口实测可用，`tools.skill` 包装器非独立存在；以直接 `skill(...)` 成功）。无需 fallback 到 `C:\Users\User\.agents\skills\godot-systems-rules-expert\SKILL.md`。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本 T1 只依据任务允许的指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未批准/冻结任何契约或 ADR；未豁免 QA blocker；未替 Independent QA 下 verdict；未替用户做产品裁决）。

---

## 0. Expert preflight（按 godot-systems-rules-expert §Expert preflight）

| 项 | 值 |
|---|---|
| Mission outcome | 产出**终结/重置最小语义 ledger**（S1 模式，PRECHARTER-04 形态）：终局判定（life 耗尽 vs 8 分钟完成）/ **同帧生命优先**（intra-tick ordering 候选）/ 结局状态（victory/defeat）/ 结果时长 / 重置·重试语义（自动立即重置、无越局损失）/ 陈旧输入拒绝（结果锁内拒 gameplay/confirmation）；全部 `PROPOSAL`，range + starting_point，promotion_authority = User，不锁常数；与 ADR-TECH-05（终局仲裁+重置机制边界）+ 决策 #5/#11/#12/#17 + 失效语义 (ii) + TECH-02 read-model 衔接 |
| Player promise / slice | 简单直接移动 + 自动攻击的可读、有重量感的清屏控制；本单元把 slice 从「清屏控制 + 生命三格存在」**收口成「可完整玩一遍并自动立即重试」的核心可玩闭环**——生命可真实耗尽 → 结局仲裁（victory #11 / defeat #12 非惩罚）→ 结果锁 → 自动立即重置（决策 #5）→ 新局无越局损失。slice 完成判定 = 结局/重试**可读、非色彩、立即重试无惩罚延迟**（KICKOFF §9.2 playability gate 观测项 5；UX-13 non-color；Pillar 4 非惩罚） |
| Known constraints | 22 项原始 user_confirmed（仅引用）；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11（含 PRECHARTER-11 同帧生命耗尽优先于八分钟胜利）；四层 provenance；unresolved 全量保留；ADR-TECH-01..06 已批准（R11，含 TECH-05 终局仲裁+重置机制边界）；决策 #5（life 三格&同帧生命优先；结果+立即重试）/ #11（victory=控制完成）/ #12（defeat=light interruption）/ #17（失焦安全方向）`user_confirmed`；失效语义 (ii) 已终裁；cr-014/015 disposition = `absorb_within_authority`（触碰承诺即升级 `needs_user_decision`）；R13 实现授权生效；候选预算（六项 + `1280×720` 红线）仅候选、本任务不涉及 |
| 已确认机制边界（本 ledger 必须一致） | ADR-TECH-05 已批准**终局仲裁与重置机制边界**：**life depletion takes priority over eight-minute completion when both occur in the same tick**；候选顺序 = evaluate legal events → arbitrate terminal outcome → enter result/input lock → emit short clear result → run one canonical automatic reset；**exact intra-tick ordering, simultaneous damage/completion semantics, result duration, cleanup list, RNG/ID reset, and stale-input rejection remain unresolved。** 失效语义 (ii)（移除即失效）。TECH-02: Session 唯一 owner of run start/active/paused/result/reset lifecycle + 一个 canonical restart path；presentation 消费 read-model、不成为规则权威 |
| 本单元范围 | 仅终结/重置语义此前置（T1）；升级/B2/focus-full（cr-012..013 完整语义）/O11/spawn/资产/数值定稿明确延后；不触碰候选预算；不触碰 kill/contact 既有路径；**结局可玩性门（M1）确认留用户，本 ledger 不预授权** |
| Top three design risks | ① 把「同帧生命优先」或任一尾局数值（结果时长/清理时序/RNG·ID 重置范围/自动重置触发）误写为已决/锁死常数 / Gate 判据 / 发布承诺 → 违反 AUTH-01，须标 D2-Card 1 不代决；② 结局呈现形态触碰 player promise（非惩罚）/ 核心支柱 / 发布文案 → 标 D2-Card 3 不代决（归 UX 观察目标，本 ledger 不冻结形态）；③ 终局仲裁/reset 与失效 (ii) / TECH-02 session 生命周期 / TECH-05 边界冲突（eset 留脏状态、life 耗尽与 completion 优先级随回调顺序变动、presentation 成为第二规则权威）→ 红队核查、以 (ii)/TECH-02/TECH-05 为准 |
| Unknowns | 同帧 life 耗尽 vs 8 分钟完成的精确 intra-tick ordering；同时伤害/完成精确语义；结果时长精确值；清理清单/时序精确值；RNG/ID 重置精确范围；自动立即重置触发精确时刻；陈旧输入拒绝精确语义（不引入完整 focus-epoch）；life `life_state` 终结态枚举精确呈现（归 UX）;fixture_schema_version（cr-110，未定，本文件不改） |
| Required evidence | 授权实现后 — `TERMINAL-life-depletion-first`（同帧生命优先）/ `TERMINAL-victory`（控制完成 #11）/ `TERMINAL-defeat-light-interruption`（#12）/ `TERMINAL-result-lock`（输入锁）/ `TERMINAL-stale-input-rejected`（陈旧输入拒绝）/ `RESET-auto-restart`（自动立即重试）/ `RESET-no-cross-run-loss`（无越局脏状态，RNG/ID/输入清理）确定性 fixture + Gate 3 前段结局/重试可读·非色彩·立即重试·**O10 终局帧补捕获** + QA 独立验收 |
| Decision boundary / stop condition | 语义归 Systems（本 ledger）；机制落实归 Engineer；观察归 UX；验收归 QA；**结局可玩性门确认留 User（M1，授权边界外）**；最终裁决归 User。若本语义触碰 promise/immutable/platform/threshold/release，或把任一候选数值写为规则常数/Gate 判据/发布承诺，或结局呈现触碰非惩罚承诺 → 升级路径（见 §6）。文件写入即停，不进入下一阶段、不派发任何成员 |

---

## 1. 语义范围（明确什么包含、什么不包含）

### 1.1 本 ledger 覆盖（= 终结/重置最小语义完整因果链）

```
legal events（life 耗尽触点 / 8 分钟完成触点）
→ 终局仲裁（same-tick: life depletion 优先于 completion，ADR-TECH-05）
→ 结局状态确定（victory=控制完成 #11 / defeat=light interruption #12）
→ 结果/输入锁（enter result state; 段时间内拒 gameplay/confirmation，ADR-TECH-05）
→ emit 短 clear result（范围 + starting_point 候选）
→ 自动立即重置（决策 #5: 无越局损失; TECH-02 session 一个 canonical restart path）
→ 新局无越局脏状态（RNG/ID/输入/session 清理，清理范围候选）
→ 陈旧输入拒绝（结果锁内拒 gameplay/confirmation，ADR-TECH-05 result/input lock + 决策 #17 方向）
```

受 ADR-TECH-05 已批准终局仲裁+重置机制边界（life depletion 优先于 completion、候选顺序 evaluate legal events → arbitrate → result/input lock → short clear result → one canonical automatic reset）+ Systems §4 canonical rules-order 步骤 4–6（terminal arbitration → result/input lock → reset）+ 失效语义 (ii) + TECH-02 session 生命周期约束。本 ledger 把该机制边界内的**精确语义**（range + starting_point）落成可实现、可验收的 ledger 行。

### 1.2 本 ledger 明确不包含（语义边界，防漂移）

- **升级（cr-010..011）/ 两次暂停 + 卡牌**: 延后（依赖 B2 + focus）。
- **B2（cr-016..019）/ `扇裂` 三弧**: 保持前-B2 结构位，不引入 B2 行为。
- **focus epoch（cr-012..013）完整失焦语义**: 延后（单元 5/后续）；本单元**仅**在终结 result-lock 边界做最小「陈旧输入拒绝」（拒 result 态内的 gameplay/confirmation 输入），**不引入完整 focus-epoch 缓冲/刷新语义**。
- **spawn 节奏**: 延后（显式留空）。
- **O11 边界不去轴（cr-009）**: 延后（unresolved，本单元不趋轴）。
- 资产 / 动画 / 音频 / 数值定稿 / 视觉基线 v0.2 / 导出 / 发布 / 持久化 / 玩家可见 Replay / O8 真人自由操作全量 / Gate 3 视觉全量。
- **结局可玩性门（M1）确认**: **本 ledger 不预授权**——判定结构已生效、阻断权延后经 CR + 用户批准激活，确认留 User。
- **候选预算（六项 + `1280×720` 红线）**: 不涉及。

---

## 2. 终结/重置最小语义（核心 ledger 行）

> 按 PRECHARTER-04 形态（range / starting_point / assumption / dependency / signal / promotion_authority / stop-rollback + evidence_id 留空）。以下所有数值**仅候选**，promotion_authority = **User**，不锁常数。

### 2.1 终局判定（terminal adjudication：life 耗尽 vs 8 分钟完成）

**一句话最小语义建议：** 终局由两源中**任一先发生**触发——(a) **life 耗尽**（`life.segments_lost == 3`，三格用尽，生命可真实耗尽——CONTACT_LEDGER §2.7 锚点 + 单元 3 已真实扣减 0→3 每接触扣 1）；(b) **8 分钟完成**（run 计时达到 8 分钟完成边界）。**同帧两者同时发生**（同一 tick 内生命耗尽且 8 分钟完成）时，**life 耗尽优先于 8 分钟完成**（决策 #5 + PRECHARTER-11 + ADR-TECH-05 已确认边界）。这衔接 ADR-TECH-05 终局仲裁 + 决策 #5/#11/#12 词汇（victory=控制完成 / defeat=life 耗尽）。8 分钟时长值本身**仅候选**（promotion=User，不锁常数）。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 终局条件：`[life-depletion (segments_lost==3), 8-min completion]` 两源任一满足即触发终局。8 分钟完成边界：候选**墙钟/计时换算 `[7.5min, 8.5min]`**（单位=分钟，run 计时由 session/TECH-02 驱动 tick；精确时长值未决，promotion=User）。life 耗尽判定 = `segments_lost == 3`（决策 #5 三格、CONTACT_LEDGER §2.7）。**排除值:** life 耗尽与 completion 同帧时按非确定性顺序结算（违反 ADR-TECH-05/PRECHARTER-11）；`segments_lost` 越界 >3；8 分钟被写为规则常数/Gate 判据/发布承诺（→ D2-Card 1）。 |
| `starting_point` | 两源任一独立判定：每 tick 结算后检查 (a) `life.segments_lost == 3` ⇒ defeat 候选；(b) run 计时 ≥ 8 分钟完成边界 ⇒ victory 候选。同帧会同（both candidates in same tick）⇒ **life depletion 优先**，结局 = defeat。**非平衡/实现证据**，仅实验初始值。 |
| `assumption` | 两源任一先达即终局、同帧 life 优先是已确认边界（#5/TECH-05/PRECHARTER-11）的最小可证形态：生命可真实耗尽（单元 3）→ 耗尽即 defeat → 触发重置闭环；存活至 8 分钟完成 → victory（控制完成 #11）。精确时长值（8 分钟完成边界）与同帧结算时序需证据 + User 提升。 |
| `dependency` | `life.segments_lost`（决策 #5 三格、单元 3 已真实扣减、read-model `life` 字段）；run 计时（READ_MODEL_MINIMAL_FIELDS timer 字段，session/TECH-02 驱动 ticking）；ADR-TECH-05 同帧生命优先；决策 #5/#11/#12；Systems §3 vocabulary（victory/defeat）；Systems §4 步骤 4–6（terminal arbitration → result/input lock → reset）。 |
| `signal` | `TERMINAL-life-depletion-first` fixture：同帧 life 耗尽 + 8 分钟完成 → 结局 **defeat**（而非 victory——life 优先）；`TERMINAL-victory`：生存至 8 分钟完成（life 未耗尽）→ **victory**；`TERMINAL-defeat-light-interruption`：life 耗尽（占先）→ **defeat**。O10 终局帧补捕获（`segments_lost=3` 或 defeat 呈现帧 runtime frame）。 |
| `promotion_authority` | **User**（任何终局判定/时长值写入正式规则、门槛或 Gate 判据 = 升级，必经 CR + 用户批准）。 |
| `stop/rollback` | 若终局判定破坏已确认边界（life 耗尽不再优先于 completion，或 8 分钟被写死）→ 回退至纯「life 优先 + 时长候选」语义重跑 TERMINAL-\* fixture；若需把 8 分钟完成边界提升为规则常数/Gate 判据 → 停止并升级 D2-Card 1（§6），本 ledger 不代决。 |
| `evidence_id` | （留空，evidence 未产生） |

### 2.2 同帧生命优先（same-frame life-depletion precedence / intra-tick ordering）

**一句话最小语义建议：** **同帧内 life 耗尽（segments_lost==3）优先于 8 分钟完成**——当同一 tick 内两个终局触点都成立，结局按 **life 耗尽（defeat）** 判定（决策 #5 + PRECHARTER-11 + ADR-TECH-05 已确认）。**精确 intra-tick ordering 给出 range + starting_point 候选，标注 unresolved 不锁常数**：起始候选与 ADR-TECH-05 §8 一致——`evaluate legal events → arbitrate terminal outcome → enter result/input lock → emit short clear result → run one canonical automatic reset`。精确时序（invalidation drain、life 扣减与完成取样的相对顺序、结局事件 emit 点）仍 unresolved，归证据 + User 提升，不在此锁死。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 同帧结算策略：`life-depletion-first`（推荐，与 TECH-05/PRECHARTER-11 完全一致，生命耗尽在本 tick 优先生效为 defeat）vs `completion-first`（反例，已被已确认边界排除）。**intra-tick 候选 ordering:** `evaluate legal events → arbitrate terminal outcome → enter result/input lock → emit short clear result → run one canonical automatic reset`（对齐 ADR-TECH-05 §8 / Systems §4 步 4–6）。**排除值:** 同帧 life 耗尽被 completion 覆盖为 victory（违反 #5/TECH-05/PRECHARTER-11）；结局随回调/事件处理顺序改变（违反确定性，TECH-02 session canonical ownership）；把精确 ordering 写为规则常数（→ D2-Card 1）。 |
| `starting_point` | 每 tick 的命名点：先在命名 drain 点排空显式失效事件（失效 (ii)）→ 结算合法 life 扣减（contact 语义，CONTACT_LEDGER）与 completion 取样 → 在同一点检查终局触点在 [tick-end 判定点]（起始）：若 `life.segments_lost==3` 且同时 completion 达成 → 结局 = **defeat**（life 优先）；→ 进入结果/输入锁（§2.4/§2.6）。精确判定点（tick 内哪个命名子步执行终局仲裁）保持 unresolved，Engineer 在规则核 seam 内落地时按确定性 by-construction 约束。 |
| `assumption` | 同帧生命优先是已确认边界（#5/TECH-05/PRECHARTER-11），本 ledger 只把候选 ordering 落成可测的确定性步序：life 耗尽在 completion 之前判定 → 结局唯一、不随回调顺序变化。精确 tick 内仲裁点（drain 后 / contact 后 / 结算末端）需证据 + User 提升，未提升前保持候选。 |
| `dependency` | ADR-TECH-05（life-depletion-first，one canonical automatic reset）；PRECHARTER-11；决策 #5；失效语义 (ii)（drain 点先于终局结算，不引入失效目标重复命中）；TECH-02（session 唯一 owner of reset 仲裁；adapter 不成为第二规则权威）；Systems §4 步 4–6。 |
| `signal` | `TERMINAL-life-depletion-first` fixture：构造同帧 life 耗尽 + completion 达成 → 断言结局 = **defeat**（life 优先），且结局事件/值唯一、可逐位复现（零容差，O2/B3）;`TERMINAL-stale-input-rejected` 联动（result-lock 内拒陈旧输入）。 |
| `promotion_authority` | **User**（同帧 ordering/判定点任一被写为规则常数/Gate 判据/发布承诺 = 升级，必经 CR + 用户批准）。 |
| `stop/rollback` | 若同帧结算导致结局随回调顺序变化（非确定）或 life 耗尽被 completion 覆盖 → 回退至「life 优先 + 确定性命名点」重跑 fixture；若需把精确 ordering 写死为规则常数 → 停止并升级 D2-Card 1（§6），本 ledger 不代决。 |
| `evidence_id` | （留空，evidence 未产生） |

### 2.3 结局状态（outcome state：victory / defeat）

**一句话最小语义建议：** 终局仲裁后进入 **结局状态（result state）**，值为二选一：**victory（控制完成，决策 #11）**——存活完成 8 分钟；**defeat（light interruption，决策 #12）**——life 耗尽。结局状态驱动结果呈现（read-model `result` 字段，TECH-02 presentation 只消费 read-model）。结局状态是**非惩罚、短、clear** 的（Systems §3 vocabulary result = short clear victory/defeat presentation with input locked；Pillar 4 非惩罚）。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 结局枚举：`victory` | `defeat`（二值；`result_state` read-model 字段候选）。`victory` = 控制完成（决策 #11，存活至 8 分钟完成）;`defeat` = life 耗尽（决策 #12，light interruption）。**排除值:** 三态/含平局（本 slice 无非 victory/defeat 的终局）；把结局呈现形态冻结为发布文案（→ D2-Card 3）。 |
| `starting_point` | 终局仲裁确定 `result_state` ∈ {victory, defeat} 单一值（同帧 life 优先 ⇒ defeat，§2.2）→ 交 read-model；presentation 只消费该字段呈现短 clear result（§2.4）。结局=非惩罚，defeat 为 light interruption（#12 + Pillar 4）。 |
| `assumption` | victory=控制完成 + defeat=light interruption 是已确认决策（#11/#12）；结局状态是「结果+立即重试」闭环（决策 #5）的合法中间态，呈现短、clear、非惩罚（Systems §3 result / §9.2 观测项 5 / UX-13 non-color）。精确呈现形态归 UX 观察（T5），本 ledger 只定义状态语义。 |
| `dependency` | 决策 #11（victory=控制完成）；#12（defeat=light interruption）；Systems §3 vocabulary（victory/defeat/result）；TECH-02 read-model（`result` 字段 presentation 消费）；§2.1 终局判定；§2.2 同帧生命优先；§9.2 playability gate 观测项 5（immediate retry without punitive delay）。 |
| `signal` | `TERMINAL-victory` fixture：存活至 8 分钟 → `result_state=victory`；`TERMINAL-defeat-light-interruption` fixture：life 耗尽 → `result_state=defeat` + 非惩罚语义（presentation 呈现不惩罚性延迟，read-model 不携带惩罚性字段）。O10 终局帧补捕获。 |
| `promotion_authority` | **User**（结局状态/枚举写入规则常数/Gate 判据/发布承诺 = 升级）。**结局呈现形态触碰 promise（非惩罚）/核心支柱/发布文案 = D2-Card 3**（§6，归 UX 观察目标，本 ledger 不冻结形态、不预授权 M1）。 |
| `stop/rollback` | 若结局状态与已确认决策冲突（victory 不再等于控制完成、defeat 不再是 light interruption）→ 停止并升级；若结局呈现形态触碰非惩罚承诺 → 升级 D2-Card 3（§6），本 ledger 不代决。 |
| `evidence_id` | （留空，evidence 未产生） |

### 2.4 结果时长（result duration）

**一句话最小语义建议：** 结局（victory/defeat）呈现后进入一个**短、clear 的结果时长窗口**，在该窗口内输入被锁定（result/input lock，ADR-TECH-05）、呈现短 clear result（Systems §3 result「short, clear victory or defeat presentation with input locked; no punitive result flow」）。结果时长给出 **range + starting_point 候选，标注 unresolved 不锁常数**：起始建议**极短**（端点结果呈现即可读、立即进入自动重置），以服务 §9.2「immediate retry after failure without punitive delay」与 Pillar 4 非惩罚。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 结果时长：候选 **`[0.3s, 2.0s]` 墙钟**（单位=秒；非像素/性能承诺，Engineer 落地以 tick 换算，tick 频率 cr-020 unresolved 故不锁 tick 数）。**排除值:** 0（无结果呈现，结局不可读，违反 §9.2-5「immediate retry」避免惩罚性延迟需可读）；过长（拖延「immediate retry」节奏，惩罚性延迟，违反 Pillar 4/§9.2）。结果时长写为规则常数/Gate 判据/发布承诺 → D2-Card 1。 |
| `starting_point` | 结果时长起始 **≈ 0.8s**（中值：足够短 clear result 可读、不造成明显惩罚性延迟；供 UX/QA 观察调参）。呈现短 clear result（victory/defeat 可读），随后紧接进入自动重置（§2.5）。 |
| `assumption` | 短、非惩罚、即刻可读的结果窗口是实现「immediate retry after failure without punitive delay」（§9.2 观测项 5 + Pillar 4）的最小可证形态：玩家看到 clear 结局 → 自动立即重试，无越局损失、无惩罚性等待。精确时长需 UX/QA 观察验证，未观察前不成立。 |
| `dependency` | ADR-TECH-05（emit short clear result）；Systems §3 result（short clear；输入锁；no punitive result flow）；§9.2 观测项 5；Pillar 4；§2.3 结局状态；§2.5 自动立即重置（时长窗口结束后触发）；决策 #5（结果+立即重试）。 |
| `signal` | `TERMINAL-result-lock` fixture：result 态内输入锁非法、timing（结果呈现窗口）确定性；runtime frame + Independent QA：结局/重试**可读、非色彩（UX-13）、立即重试节奏**（§9.2 前段；Gate 3 前段）。结果呈现窗口时长可由结局→重置 tick 间隔观察（授权后）。 |
| `promotion_authority` | **User**（结果时长任一值写入规则常数/Gate 判据/发布承诺 = 升级，必经 CR + 用户批准）。 |
| `stop/rollback` | 若结果时长破坏「短、非惩罚、可读」（过长拖延惩罚、过短不可读）→ 回退至明确起始值（~0.8s）并重跑 TERMINAL-\* fixture;若该值被提议写为规则常数/Gate 判据/发布承诺 → 停止并升级 D2-Card 1（§6），本 ledger 不代决。 |
| `evidence_id` | （留空，evidence 未产生） |

### 2.5 重置/重试语义（reset / immediate-retry semantics：自动立即重置、无越局损失）

**一句话最小语义建议：** 结果窗口结束后，游戏**自动立即重置**（决策 #5「结果+立即重试」）——不清除玩家进度/无越局损失（Systems §3 reset「canonical clearing and fresh-run transition; no out-of-run loss」）；TECH-02 Session 唯一 owner of run start/active/paused/result/reset lifecycle + **一个 canonical restart path**。重置**清理范围**给出 range + starting_point 候选：RNG/ID/输入/session 清理的候选语义，确保新局**无越局脏状态**（ADR-TECH-05「reset leaves session state, IDs, RNG, focus, or input dirty」禁令）。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 重置触发：`自动立即`（结果窗口结束即自动进入新 run，无需玩家干预，决策 #5）——起始建议。重置清理范围候选：`session/run 域`（RNG/seed 重置、stable-id 生命周期清理、tick 计时归零、输入缓冲/陈旧输入丢弃、result/focus/selection 清除）——session 内部机械处理（TECH-02/ADR-TECH-01），**不越入引擎实体物理移除（归 adapter）**。**排除值:** 越局保留（新 run 继承上一局 RNG/ID/输入脏状态 → 违反 ADR-TECH-05「reset leaves … dirty」禁令 + 决策 #5 无越局损失）；重置触发被写为规则常数/发布承诺。 |
| `starting_point` | 结果窗口结束 → session 执行**一个 canonical reset**：`reset_epoch/duration` 归零、RNG/seed 重设（session-owned，ADR-TECH-03）、run-id/tick 重置、stable-id 生命周期清理（无跨 run 复用冲突）、输入缓冲/陈旧输入丢弃、result/focus/selection 清除 → 进入 entry 态 → 新 run 自动开始，无越局脏状态、无越局损失。RNG/ID 重置精确范围/时序未决（候选）。 |
| `assumption` | 自动立即重置（决策 #5「结果+立即重试」）+ 无越局损失（Systems §3 reset）是实现「可完整玩一遍并自动立即重试」核心闭环的最小可证形态：每次完结即干净重启，新局不继承上一局脏状态。精确清理清单/时序/重置触发精确时刻需证据 + User 提升。 |
| `dependency` | 决策 #5（结果+立即重试，无越局损失）；ADR-TECH-05（run one canonical automatic reset；reset 不得留脏状态）；TECH-02（session 唯一 owner of reset + 一个 canonical restart path）；ADR-TECH-03（session-owned seed/RNG context；stable-id 生命周期）；失效语义 (ii)（drain 清理先行，不在重置后重放失效命中）；Systems §4 步骤 6（reset）。 |
| `signal` | `RESET-auto-restart` fixture：结果窗口结束 → 自动进入新 run（无玩家干预，确定性逐位一致）;`RESET-no-cross-run-loss` fixture：新 run 的 RNG/seed、run-id/tick、stable-id、输入缓冲、result/focus 均无上一局脏状态（逐字段断言干净重置；RNG/ID/输入清理断言）。确定性零容差（O2/B3）。 |
| `promotion_authority` | **User**（重置触发/清理范围任一被写为规则常数/Gate 判据/发布承诺 = 升级，必经 CR + 用户批准）。 |
| `stop/rollback` | 若重置保留越局脏状态（RNG/ID/输入残留，违反 disarm/ADR-TECH-05）→ 回退至「session 一个 canonical reset + 全程清理」语义重跑 RESET-\* fixture;若需把重置触发/清理范围写死为规则常数 → 停止并升级 D2-Card 1（§6），本 ledger 不代决。 |
| `evidence_id` | （留空，evidence 未产生） |

### 2.6 陈旧输入拒绝（stale-input rejection：结果锁内拒 gameplay/confirmation）

**一句话最小语义建议：** **在 result/input lock 状态期间**（进入 result state 到自动重置完成之间，ADR-TECH-05 result/input lock），**拒绝 gameplay 输入与 confirmation 输入**——即 result 态内的移动/攻击/确认输入不驱动任何 gameplay 或被当作有效确认，避免陈旧输入泄入新局。这衔接 ADR-TECH-05 result/input lock + 决策 #17（失焦安全/拒陈旧方向），但**不引入完整 focus-epoch 缓冲/刷新语义**（cr-012..013 延后）——只做 result-lock 边界内的最小「拒陈旧」。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 拒绝范围：result-lock 态内 (a) **gameplay 输入**（移动/攻击等结果态内输入不驱动 gameplay）、(b) **confirmation 输入**（确认/选择键不作为有效确认）。**排除值:** 把完整 focus-epoch 缓冲/刷新语义挤入本单元（cr-012..013 延后，不引入）；result 态内陈旧输入被当作有效 gameplay/confirmed（违反 result/input lock + 决策 #17 方向）；拒绝语义写为规则常数/Gate 判据/发布承诺。 |
| `starting_point` | result-lock 态（进入 result state 起，至自动重置完成）内，presentation/adapter 丢弃 gameplay 与 confirmation 意图（不进规则核评价）；规则核在 result 态不接受 gameplay/confirmation 域输入（只接受 reset 推进输入）。最小、边界内，不扩展为完整 focus-epoch。 |
| `assumption` | result-lock 内拒陈旧输入是可读、安全的收口：result 态内不会因遗留移动/确认造成「结果后误操作泄入新局」或「陈旧确认被接受」；与决策 #17（失焦安全/拒陈旧）同一方向但作用域限定于 result-lock 边界的终点（最小实现，cr-012..013 延后）。 | 
| `dependency` | ADR-TECH-05 result/input lock（enter result state 并 reject gameplay/confirmation input）;决策 #17（失焦安全/拒陈旧方向）;TECH-02（session 生命周期：result 态 = session 状态之一；adapter 不成为规则权威）;§2.4 结果时长（result-lock 窗口）;§2.5 自动重置（result 态结束即干净重启）。 |
| `signal` | `TERMINAL-stale-input-rejected` fixture：result 态内注入 gameplay/confirmation 输入 → 断言不产生 gameplay 效果、不作为有效确认（结果与无输入时逐位一致）;`RESET-no-cross-run-loss` 联动（陈旧输入不泄入新局）。decision #17 方向保持。 |
| `promotion_authority` | **User**（陈旧输入拒绝精确语义/范围写入规则常数/Gate 判据/发布承诺 = 升级，必经 CR + 用户批准）。 |
| `stop/rollback` | 若陈旧输入拒绝导致 result-lock 外误拒合法输入，或把完整 focus-epoch（cr-012..013）语义挤入本单元 → 回退至最小 result-lock 拒 gameplay/confirmation 语义并重跑 fixture;若需把拒绝范围/时序写死为规则常数 → 停止并升级 D2-Card 1（§6），本 ledger 不代决。 |
| `evidence_id` | （留空，evidence 未产生） |

---

## 3. 与已批准契约的衔接（红队核查：不触碰已批准 ADR 语义）

### 3.1 与 ADR-TECH-05 机制边界一致（终局仲裁 + 重置）

- 本 ledger 完全建立在已批准 ADR-TECH-05 终局仲裁+重置机制边界之上：**life depletion takes priority over eight-minute completion when both occur in the same tick**；候选顺序 `evaluate legal events → arbitrate terminal outcome → enter result/input lock → emit short clear result → run one canonical automatic reset`；**exact intra-tick ordering, result duration, cleanup list, RNG/ID reset, stale-input rejection 归本 ledger 定候选（unresolved → 候选，不锁常数）**。
- §2.1/§2.2 直接展开 TECH-05 的「life-depletion-first + 同帧优先 → 结局 → 输入锁 → 结果 → 重置」候选顺序;§2.4/§2.5/§2.6 展开 TECH-05 的 result duration / cleanup / RNG-ID reset / stale-input rejection。
- 本 ledger 只在该边界内落**精确语义候选**（range + starting_point），不改变任何已批准机制边界。

### 3.2 与已确认决策 #5/#11/#12/#17 一致

- **决策 #5（life 三格 & 同帧生命优先；结果+立即重试）**: §2.1/§2.2（同帧 life 优先）+ §2.5（自动立即重置，无越局损失）直接服务；life 三格 = CONTACT_LEDGER §2.7（单元 3 已真实扣减，0→3 每接触扣 1）。
- **决策 #11（victory=控制完成）**: §2.3 `victory` = 控制完成（存活至 8 分钟完成）。
- **决策 #12（defeat=light interruption）**: §2.3 `defeat` = light interruption（非惩罚，Pillar 4）。
- **决策 #17（失焦安全方向/拒陈旧）**: §2.6 result-lock 内拒 gameplay/confirmation（direction，不引入完整 focus-epoch）。

### 3.3 与失效语义 (ii) 一致（规则核吞并，不重复命中）

- 失效语义 (ii)（已终裁）: `移除即失效 ⇒ 无命中`;落点在命名 drain 点;快照 ID 集不可变;只读解析不重定位。
- 终局仲裁的经 drain 排空显式失效事件（ADT-TECH-05 candidate ordering「evaluate legal events」先于「arbitrate terminal」）与 (ii) 一致——life 扣减只作用于未被显式失效的合法接触目标，终局结算不引入失效目标重复命中。重置清理（§2.5）同样在重建 RNG/ID/session 前以 drain 点完成清理，不重放失效命中。
- 本 ledger 不改变失效 (ii)，只把「终局结算/re-set 的 drain 先行」声明为与 (ii) 一致（invalidation 事件在命名 drain 点排空 → 终局仲裁在干净的事件集上进行）。

### 3.4 与 TECH-02/ADR-TECH-01/03 一致（lifecycle/read-model/确定性 seam）

- **TECH-02:** Session 唯一 owner of run start/active/paused/**result**/reset lifecycle + **一个 canonical restart path**（§2.5 直接引用）;presentation 消费 read-model、不成为规则权威——结局状态（§2.3 `result_state`）经 read-model 呈现（presentation 只消费 rules trace，ADR-TECH-01）。
- **ADR-TECH-03:** 重置的 RNG/seed 重设归 session-owned seed context（§2.5）;run-id/tick/stable-id 生命周期清理（无跨 run 复用冲突）;确定性 by-construction（零 RNG，延续 Gate 2 纪律 O2/B3）。
- **ADR-TECH-01 seam:** 终局仲裁/结果锁/reset 属规则核+session 纯逻辑边界;引擎实体物理移除/呈现翻译归 adapter（规则核不拥有引擎 live 集）。

### 3.5 不触碰项（明确）

- **不触碰** ADR-TECH-01/02/03/04/06（seam/纯度/确定性/target snapshot/headless）——终结/重置语义全部落在已批准 seam 内（终局/结果锁/reset 属规则核+session；呈现翻译归 adapter）。
- **不触碰** 升级/B2/focus-full（cr-012..013 完整语义）/O11/spawn/资产——全部延后（§1.2）。
- **不触碰** kill/contact 既有路径——终结结算不重复 kill/contact 计算;终局仲裁吞并既有 life 扣减结果。
- **不新增/不重分类** 任何 `user_confirmed`（含决策 #5/#11/#12/#17）;不把 `team_proposal`/`assumption`/候选数值提升为 `user_confirmed`;候选预算（六项 + `1280×720` 红线）不涉及。

---

## 4. 规则核 terminal/reset 步序建议（供 Engineer T2 落地参考，机制归 Engineer）

> 以下为**语义事件建议**（`team_proposal`），供 Engineer 在已批准规则核纯逻辑 seam 内落地（T2）。终局仲裁/结果锁/reset 属规则核+session 纯逻辑边界;引擎/呈现翻译归 adapter（T4）。

```text
[A] adapter/session 提供域输入（live 集合法 life 扣减结果 + completion 触点），规则核不拥有引擎 live 集（ADR-TECH-01 seam）
[B] 在命名 drain 点排空显式失效事件（失效 (ii)）→ 终局结算在干净事件集上进行（不引入失效目标重复命中）
[C] 同帧仲裁: 检查 life-depletion（segments_lost==3）与 8 分钟完成——两者同帧 ⇒ life 优先（§2.2）
[D] 确定结局状态 result_state ∈ {victory, defeat}（§2.3; 同帧 life 优先 ⇒ defeat）
[E] 进入 result/input lock（§2.6）: 拒绝 gameplay/confirmation 输入（最小，不引入完整 focus-epoch）
[F] emit 短 clear result（§2.4，结果呈现窗口，起始 ~0.8s 候选）——非惩罚
[G] 结果窗口结束 → session 执行一个 canonical reset（§2.5）: RNG/seed 重设、run-id/tick 归零、stable-id 清理、输入缓冲/陈旧输入丢弃、result/focus/selection 清除
[H] 进入 entry 态 → 新 run 自动开始（自动立即重置，决策 #5; 无越局损失）
[I] 结局/重置事件交给 adapter → 呈现/引擎实体清理归 adapter（ADR-TECH-01/TECH-02）
```

- 步骤 [B][C][D][E] 属规则核+session 纯逻辑（引擎 free）；[A][F][I] 的引擎碰撞/呈现/物理清理归 adapter/session（ADR-TECH-01/TECH-02）。
- 步序确定性 by-construction（命名 drain 点、零 RNG、同 tick、一个 canonical reset），延续 Gate 2 纪律（O2/B3）。精确 intra-tick ordering（[C] 判定点、[G] 清理时序）保持 candidate → 待证据 + User 提升。

---

## 5. 生成（spawn）标注——后续项，非本 ledger

- **敌方生成节奏/密度/涌现不在本 ledger 语义范围**。本终结/重置单元只需「life 可真实耗尽 + 8 分钟计时 + 结局 + 自动立即重置」，与 spawn 无关;「敌人何时/何处/多寡进入 live 集」是后续 spawn 项，不在本单元。
- 未来 spawn ledger 行（spawn 速率、波次密度、压力曲线）暂不产出;如需进入正式开发，须独立 CR/单元，并保持 PRECHARTER-04 ledger + promotion_authority=User。

---

## 6. AUTH-01 升级判定（重点 — 明确标注）

> AUTH-01（R13）: process-level 连续推进;非升级项自动接受专家建议（D1）;升级项（阈值/发布/平台/锚点类）用户亲自决策（D2）;冲突升级（D3）。本 ledger 按此判定。

- **本 ledger 判定（如实）: 全部终结/重置数值仅候选（promotion_authority = User）;本 ledger 是 T1 终局/重置语义前置，本身非升级（D1 自动推进）——机制在已批准 ADR-TECH-05 终局仲裁+重置机制边界 + 决策 #5/#11/#12/#17 `user_confirmed` 内,按 S1 模式作为 PROPOSAL、range+starting_point、不锁常数,无数值写死。**

### 条件触发的 D2 升级卡片（明确列出，需用户亲自决策的具体情形）

> **本 ledger 无前置强制 D2 升级。** 但以下**条件一旦命中，立即升级 `needs_user_decision`**（呈交用户亲自决策，非静默吸收），本 ledger 不代决:

| 卡片 | 触发条件（对本 ledger 数值/语义） | 用户需决策的具体问题 |
|---|---|---|
| **D2-Card 1** | 结局时长 / 同帧时序 / 清理时序 / RNG·ID 重置范围 / 自动重置触发 任一数值或语义被提议**写为规则常数 / Gate 判据 / 发布承诺** | 该终局/重置数值或语义是否提升为正式规则/门槛/承诺？取值范围与起始点？（本 ledger 不锁任何常数,全部候选,先问再升） |
| **D2-Card 3** | 结局呈现形态触碰 player promise（非惩罚）/ 核心支柱 / 被提议为发布文案（归 UX 观察目标，若触碰即升级） | 该胜利/失败/重试呈现是否越 promise？是否成为发布承诺？（defeat=light interruption #12 + Pillar 4 非惩罚） |

> **推荐默认（非升级路径）:** (a) 终局仲裁按已批机制边界（同帧生命优先）+ 决策 #5/#11/#12/#17 落地;(b) 全部终局/重置数值走 ledger 候选、promotion=User;(c) 结局呈现以 UX 观察目标固化、不冻结形态;(d) **结局可玩性门（M1）确认留用户**。**本 ledger 按推荐默认执行即全程 D1，但结局可玩性门确认为边界后强制用户点（M1）。**

> ⚠️ **明确标注:** **结局可玩性门（M1）确认留用户，本 ledger 不预授权**——§9.2 playability gate「immediate retry after failure without punitive delay」= 本单元首次实测点;判据结构已生效、**阻断权延后经 CR + 用户批准激活**（DC-PLAY-01 R08）。本 ledger 只提供结局/重试语义候选与信号,不代决 playability 门通过与否。

---

## 7. AUTH-01 条件触发示例（对齐 Producer NEXT_IMPL_UNIT_PLAN_v0_4 §6）

- **D2-Card 1（数值写死）:** 若 Engineer/T4 在实施中把 §2.x 任一候选值（如结果时长 ~0.8s、rset 清理时序、RNG·ID 重置范围、自动重置触发时刻）写为规则常数 / Gate 判据 / 发布承诺 → 触发 D2 升级，用户亲自决定是否提升为该数值（本 ledger 不代决、不预授权）。
- **D2-Card 3（触碰 promise）:** 若结局呈现形态触碰 player promise（非惩罚）/ 核心支柱 / 发布文案 → 触发 D2 升级（归 UX 观察,若触碰 UI→UX;若触碰产品语义→Systems/User）。**结局可玩性门（M1）确认留用户，本 ledger 不预授权。**

> 本 ledger 全部数值仅候选，无任何值被写死;AUTH-01 判定 = 无前置强制 D2，推荐默认全程 D1，但**结局可玩性门确认为边界外用户点（M1）**。

---

## 8. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed（含决策 #5 life 三格&同帧生命优先/结果+立即重试、#11 victory=控制完成、#12 defeat=light interruption、#17 失焦安全方向）;恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）;PRECHARTER-01..11（含 PRECHARTER-11 同帧生命耗尽优先于八分钟胜利）;cr-001 (R09);ADR-TECH-01..06 批准（R11，含 TECH-05 终局仲裁+重置机制边界）;失效语义 (ii) 终裁;AUTH-01（R13 实现授权）;单元 1/2/3 QA verdict pass。本 ledger 不重写、不重分类任何一项。
- **`team_proposal`（本 ledger 的实质贡献）:** 终结/重置最小语义六字段 ledger 行（终局判定 / 同帧生命优先+intra-tick ordering / 结局状态 / 结果时长 / 重置·重试语义 / 陈旧输入拒绝），全部 PRECHARTER-04 形态、range+starting_point、promotion_authority=User、不锁常数;规则核 terminal/reset 步序建议;语义边界声明;与 ADR-TECH-05 / 决策 #5/#11/#12/#17 / 失效 (ii) / TECH-02 衔接声明。全部为 PROPOSAL 级，供 Engineer 实现 + QA 验收，**不升级任何契约/数值**。
- **`assumption`:** ① 同帧生命优先为已确认边界（#5/TECH-05/PRECHARTER-11）且精确 intra-tick ordering 可在规则核 seam 内确定性落地（需 Engineer 落地 + QA 观察验证）;② 自动立即重置（决策 #5）+ 无越局损失（Systems §3 reset）可在 session seam（TECH-02）内机械清理实现（需 Engineer 落地 + QA 观察验证）;③ result-lock 内最小「陈旧输入拒绝」可在不引入完整 focus-epoch（cr-012..013 延后）的前提下有界落地（ADR-TECH-05 result/input lock + 决策 #17 方向，需 Engineer 落地 + QA 观察验证）;④ 结局呈现为 §9.2 playability gate 首次实测点、**其确认留用户**（判据结构已生效、阻断权延后经 CR+用户激活）。均未在此代决。
- **`unresolved`（全量保留，未关闭）:** cr-014/015 精确同帧时序 / 结局时长 / 清理时序 / RNG·ID 重置范围 / 陈旧输入拒绝精确语义（本 ledger 给出 range+starting_point 候选，但精确提升待证据 + User）;life `life_state` 终结态枚举精确呈现（归 UX）;cr-012..013 focus 完整语义;cr-010/011 升级;cr-016..019 B2;cr-009 边界（O11）;spawn 节奏;结局呈现精确表现形态（归 UX 观察）;O6 evidence-harness;O8/O12 真人键盘自由操作未全量验收;候选预算（六项 + `1280×720` 红线）——全部保持 open，本 ledger 不闭合、不升级任何项。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本 ledger 未改动上述任何一项;未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`;候选预算（六项 + `1280×720` 红线）未被动用/提升;未批准/冻结任何契约/规则语义/数值/表现形态;**结局可玩性门（M1）确认未预授权（留用户）。**

---

## 9. 边界声明与 Closure

- **本文件为 `PROPOSAL` 级（T1 交付物），非契约冻结、非数值提升、非 QA 验收、非产品裁决。** 全部数值仅候选;promotion_authority=User;不锁常数。
- **未触碰已批准 ADR/契约语义**：终结/重置语义建立在已批准 ADR-TECH-05 终局仲裁+重置机制边界（life-depletion-first + result/input lock + short clear result + one canonical automatic reset）+ 已确认决策 #5/#11/#12/#17 + 失效语义 (ii) + TECH-02（session lifecycle/read-model）之上;不触碰 kill/contact 路径、不触碰升级/B2/focus-full/O11/spawn（全部延后）。
- **AUTH-01 标注**：全部终结/重置数值仅候选（promotion=User）;若实施中任一数值被写为规则常数/Gate判据/发布承诺 → D2-Card 1;结局呈现触碰 promise（非惩罚）→ D2-Card 3（均标注、不代决）;**结局可玩性门（M1）确认留用户，本 ledger 不预授权**。
- **未替用户做产品/验收裁决;未豁免 QA blocker;未替 Independent QA 下 verdict。**
- **未访问/修改 Godot、代码、场景、资源**;未运行/构建/测试/导出/发布;无 runtime/视觉/性能/QA 证据（本文件仅 static/source）。
- **写入面**：仅新增本唯一 ledger 文件 `docs/production/TERMINAL_RESET_LEDGER_v0_1.md`;未修改任何其它文档（Systems 合同、CR 台账、排程建议、既有 ledger、ADR 等一律未触碰）。
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。

**Closure:** `closure_ready = yes`（仅限本 T1 ledger artifact）。本文件供父协调器作为 T1 终局/重置语义前置派发 T2（Engineer 规则核 terminal 扩展）+ T3（TERMINAL-\*/RESET-\* fixture）+ T4（adapter/运行时结局仲裁·呈现·立即重试）+ T5（UX 结局呈现观察目标）+ Gate 2 扩展 + Gate 3 前段验收的语义输入;非实现派发、非契约批准、非 QA 验收、非产品裁决、非结局可玩性门（M1）确认。写入后停止，不进入下一阶段、不派发任何成员。

---

## 10. 版本与变更记录

- **v0.1（本文件）:** Systems / Rules Designer 唯一新产物——T1 终局/重置最小语义 ledger（薄前置）。产出完整终结/重置因果链（终局判定 → 同帧生命优先 → 结局状态 → 结果时长 → 自动立即重置 → 无越局脏状态 → 陈旧输入拒绝）;六个语义字段 ledger 行全部 PRECHARTER-04 形态、range+starting_point、promotion_authority=User、不锁常数;与 ADR-TECH-05（终局仲裁+重置机制边界）+ 决策 #5/#11/#12/#17 + 失效语义 (ii) + TECH-02（session/read-model）逐条衔接;AUTH-01 判定（无前置强制 D2 + 条件触发 D2-Card 1/3 + **结局可玩性门 M1 明确留用户**）明确标注;Provenance 分层与不变量保留声明完整。未触碰任何已批准契约/ADR/其它文档。
