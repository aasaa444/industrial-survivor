# NEXT IMPL UNIT PLAN v0.4 — 下一实现单元排程建议（单元 4：终结/重置体验完整排程）· cr-014/cr-015

> **Status:** `SEQUENCING RECOMMENDATION — 单元 4（终结/重置体验）完整排程建议（供逐单元推进流程作为输入）`。仅排程建议，不派发实现、不批准/冻结契约/数值、不替用户做产品/验收裁决、不豁免 QA、不替 Independent QA 下 verdict。父协调器据本建议检查 AUTH-01 后决定是否/如何派发。
> **Role / owner (sole author):** Executive Producer / Lead Producer（执行制作人 / 首席制作人）
> **Report ID:** `NEXT_IMPL_UNIT_PLAN_v0_4`
> **Expert capability:** `godot-executive-producer-expert` — 实测 `skill({name:"godot-executive-producer-expert"})` **调用成功**（返回完整 SKILL 指令；未发生 unknown tool / 接口不存在错误）。能力证据等级 = `strong_direct_skill`（首选等级；本运行时 `skill` 接口实测可用，`tools.skill` 包装器非独立存在，以直接 `skill(...)` 成功）。无需 fallback 到 SKILL.md 读取。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本建议仅依据任务允许的指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未派发任何成员）。
> **排程依据（承接）:** 单元 1（垂直切片）/单元 2（可玩切片，真实键盘移动基线）已验收 `pass`；单元 3（接触单元）已验收 = `QA_CONTACT_SLICE_VERDICT_v0_1.md` verdict `pass`（O10–O12 非阻断），`life` 已从 0 结构位变为**真实扣减**（`segments_lost` 0→3、每接触扣 1 格）；`CONTACT_LEDGER_v0_1.md` 已定义 life segments_lost 数值语义与同帧生命优先锚点。git：`baf211f`。**Gate 3+ 未验收**（本单元仍只含 Gate 2 扩展 + Gate 3 前段；结局可玩性门属授权边界外用户点 M1）。
> **用户最新指令（本排程的前提）:** 用户**拒绝** `AUTHORIZATION_WORKLIST_D2_PRE_v0_1.md` 的一次性批量授权，改**逐单元推进**——每个单元由 Producer 出排程建议 → 父协调器检查 AUTH-01 → 派发实现/QA → 用户看验收摘要后再决定是否继续下一单元。**本排程建议本身即逐单元推进流程的输入**，供父协调器检查 AUTH-01 后决定是否派发；不替代用户对「继续单元 4」的逐单元认可，也不预授权任何后续单元。

---

## 1. Expert preflight（本排程任务的执行前置）

| 项 | 值 |
|---|---|
| 契约 | ADR-TECH-01..06 已批准（R11）；**ADR-TECH-05 机制边界已批准（contact 单次伤害+轻分离 / 升级两阶段 / focus epoch / 同帧生命优先 / 终局仲裁与重置）**，精确数值语义延后（cr-014/015 Systems in_flight）；决策 #5（life 三格&同帧优先；结果+立即重试）、#11（victory=控制完成）、#12（defeat=light interruption）、#17（失焦安全方向）`user_confirmed`；失效语义 (ii) 终裁；ADR-TECH-01 seam / TECH-02 read-model / TECH-04 目标快照已批准；S1 ledger 制式（`ENEMY_LIFETIME_LEDGER`/`CONTACT_LEDGER`）已验证（PROPOSAL，promotion=User，range+starting_point，不锁常数） |
| 用户指令 | 逐单元推进（拒绝一次性批量授权）；R13 实现授权生效（契约内：ADR-TECH-01..06 + 已决决策范围；候选预算不提升；QA 不豁免） |
| 本建议不替代 | 用户产品裁决；Independent QA verdict；Systems 语义定裁；Tech ADR 批准；任何数值提升（promotion_authority=User）；**结局可玩性门（M1）确认留用户** |
| 停止条件 | 唯一排程建议文件写入即停；不进入下一阶段、不派发任何成员 |

---

## 2. 边界与已确认事实（仅使用这些）

- **不变量:** 22 项原始 `user_confirmed`；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；unresolved 全量保留。
- **已批准机制面（本单元直接依据）:** ADR-TECH-05 已批准**终局仲裁与重置机制边界**（§8）——「Life depletion takes priority over eight-minute completion when both occur in the same tick. Candidate order: evaluate legal events → arbitrate terminal outcome → enter result/input lock → emit short clear result → run one canonical automatic reset. Exact intra-tick ordering, simultaneous damage/completion semantics, result duration, cleanup list, RNG/ID reset, stale-input rejection remain unresolved.」；Systems §4 canonical rules-order 步骤 4–6（terminal arbitration → result/input lock → reset）；Systems §3 vocabulary（victory=控制完成 #11 / defeat=light interruption #12 / result=short clear lock / reset=canonical clearing 无越局损失）。
- **已确认决策:** 决策 #5（life 三格&同帧生命优先；**结果+立即重试**）、#11（victory=控制完成）、#12（defeat=light interruption）、#17（失焦安全方向/拒陈旧）全部 `user_confirmed`。
- **cr-014/015 disposition = `absorb_within_authority`**（Systems ledger，promotion=User；触碰承诺即升级 `needs_user_decision`）。
- **单元 3 已就位（本单元前置）:** `life.segments_lost` 真实扣减（0→3、每接触扣 1 格）；life 三格结构位 read-model 呈现（`LIFE [o][o][o]`）；真实键盘移动基线；kill 路径；失效语义 (ii)（移除即失效）；read-model 呈现 seam（presentation 只消费 rules trace）；adapter seam（ADR-TECH-01，规则核只收域输入）。
- **O10/O11/O12（单元 3 非阻断观察项）:** O10 = 正常模式运行时未独立捕获「生命扣减发生帧」（`segments_lost=1` 画面），以 self-test 为准——**终结单元可补**（`segments_lost=3` 终局帧的 runtime 捕获）；O11 = 运行时边界分离不去轴（cr-009 延后，unresolved）；O12 = O8 真人键盘自由操作未全量（延续，非本单元）。
- **候选预算（六项 + `1280×720` 红线）仅候选**，本单元不涉及。
- **范围边界惯例:** 每单元有界、可验收、可玩家可见；延后项不挤入。
- **结局呈现 = §9.2 playability gate 首次实测点**；其判据结构已生效、**阻断权延后经 CR + 用户批准激活**（DC-PLAY-01 R08）。

---

## 3. 单元定义 — 下一实现单元 = 「候选：终结/重置体验（cr-014/cr-015）」核心可玩闭环收口

**一句话:**
> 本单元在有界范围内 (1) 用 **T1 Systems 终局/重置语义 ledger 前置**（Systems 唯一 owner：终局判定、同帧生命优先、结局状态、结果时长、重置/重试语义、陈旧输入拒绝——全部 `PROPOSAL`、range+starting_point、promotion=User、**不锁常数**）(2) 规则核 **terminal 扩展**（纯逻辑、确定性、引擎 free，ADR-TECH-01 seam）(3) **TERMINAL-*/RESET-\* fixture**（同帧生命优先、结局状态、自动重置、无越局脏状态、陈旧输入）(4) adapter/运行时 **结局仲裁 → 呈现 → 立即重试**（victory=控制完成 #11 / defeat=light interruption #12 非惩罚）(5) **UX 结局呈现观察目标**（非惩罚可读、非色彩 UX-13、不遮挡 UX-09）。本单元把接触使生命可真实耗尽的机制**收口成「可完整玩一遍并自动立即重试」的核心可玩闭环**——是 slice 从「清屏控制 + 生命三格存在」迈向「完整可玩 + 结局 + 立即重试」的结构闭合。

| 子块 | Owner | 交付物 | 写 ownership（单一） |
|---|---|---|---|
| **T1 Systems 终局/重置语义 ledger** | Systems / Rules Designer | S1 模式 ledger 行：终局判定（life 耗尽 vs 8 分钟完成）、**同帧生命优先**、结局状态（victory/defeat）、结果时长、重置/重试语义（自动立即重置、无越局损失）、陈旧输入拒绝（结果锁内拒 gameplay/confirmation）——`PROPOSAL`，range+starting_point，promotion_authority=User，不锁常数；与 ADR-TECH-05 + 失效 (ii) + TECH-02 read-model 衔接 | 终局/重置 ledger（Systems 唯一） |
| **T2 规则核 terminal 扩展** | Godot Gameplay Engineer | `rules_core` terminal 纯逻辑：接收域输入（life/timer/legal events）→ 同帧仲裁（life depletion 优先于完成）→ terminal 结局状态 → 结果/输入锁 → 自动重置语义（RNG/ID/输入清理）；确定性、零 RNG、引擎 free；不拥有引擎实体 | rules_core（Engineer，经 GDMCP） |
| **T3 TERMINAL-\* / RESET-\* fixture** | Godot Gameplay Engineer（Owner）+ QA 复核 | `TERMINAL-life-depletion-first`（同帧生命优先）/ `TERMINAL-victory`（控制完成）/ `TERMINAL-defeat-light-interruption` / `TERMINAL-result-lock`（输入锁）/ `TERMINAL-stale-input-rejected` / `RESET-auto-restart`（自动立即重试）/ `RESET-no-cross-run-loss`（无越局脏状态）确定性 fixture——对齐 Systems §6.3 / ADR-TECH-06 | fixture（Engineer 唯一）；复核（QA） |
| **T4 adapter / 运行时结局仲裁·呈现·立即重试** | Godot Gameplay Engineer | adapter：规则核 terminal 输出翻译为结局呈现（result 态输入锁、victory/defeat 呈现、立即重置/自动重试路径）；运行时：终端 disable gameplay 输入 → 呈现结果 → 自动立即重置 → 新局无越局损失；RNG/ID/session 重置归 session/adapter 机械处理（ADR-TECH-01/TECH-02） | Godot 构件（Engineer 唯一，经 GDMCP） |
| **T5 UX 结局呈现观察目标** | UX/UI Designer（观察目标 + 呈现清单）+ Engineer（落地） | 结局呈现观察目标（victory/defeat 可读、非惩罚、非色彩 UX-13、不遮挡 UX-09、立即重试节奏）+ 呈现绑定清单（结局状态字段 → 呈现，只消费 read-model）；**hint/文案/布局/资产不冻结** | 观察目标 + 清单（UX 提案唯一）；落地（Engineer 唯一） |
| **T 测试与观察** | Engineer + QA 独立 | TERMINAL-\*/RESET-\* 确定性复跑（同帧生命优先/结局状态/自动重置/无越局脏状态/陈旧输入）；Gate 3 前段独立观察（结局/重试可读、非惩罚、立即重试、O10 终局帧补捕获） | 实现 owner 自证 / QA 独立验收 |

> 域事件归 Engineer；语义归 Systems；观察归 UX；验收归 QA；产品裁决归 User。

---

## 4. 依赖分析（已就位 vs 需前置 vs 可分离延后）

### 4.1 已就位（本单元直接复用/衔接）

| 面 | 已就位 | 证据/出处 |
|---|---|---|
| **life 真实扣减（前提）** | 单元 3 已使 `segments_lost` 从 0 结构位变为真实扣减（0→3、每接触扣 1 格、同帧生命优先锚点一致）；生命可真实耗尽 | QA_CONTACT_SLICE_VERDICT §2/§3；CONTACT_LEDGER §2.7 |
| **真实移动基线** | 单元 2 已建立真实键盘移动（GDMCP key 注入 → player 位移） | QA_PLAYABLE_SLICE §3.1 |
| **kill 路径 / 失效语义 (ii)** | S1/S2 kill + adapter 移除；失效 (ii)（移除即失效→无命中）已落地 | QA_PLAYABLE_SLICE；SEMANTICS_INVALIDATION_FINAL |
| **read-model 呈现 seam** | presentation 只消费 rules trace（ADR-TECH-01）；life/timer/b2 结构位在读 model 呈现；contact read-model 绑定事件 | IMPL_PLAYABLE_SLICE；READ_MODEL_MINIMAL_FIELDS；READ_MODEL_IMPLEMENTATION_LIST |
| **adapter seam** | adapter 纯翻译（输入/envelope/feedback gating），空射不伪造 | adapter_contract_test |
| **契约** | ADR-TECH-05 **终局仲裁与重置机制边界已批**；决策 #5（结果+立即重试）/ #11（victory）/ #12（defeat=light interruption）`user_confirmed`；Systems §4 步骤 4–6（result lock → reset）| KICKOFF_TECH_ADR §8；KICKOFF_SYSTEMS §4/§3；CR §3 cr-014/015 |

### 4.2 需前置（本单元必须先行/在单元内完成）

| # | 前置项 | 归属 | 性质 |
|---|---|---|---|
| P1 | **终局/重置语义 ledger**（T1，S1 模式）：终局判定、同帧生命优先、结局状态、结果时长、重置/重试语义、陈旧输入拒绝 | Systems | `PROPOSAL`，promotion=User，不锁常数；本单元实施与 fixture 的语义前置 |
| P2 | **同帧生命耗尽的精确时序语义**（同帧 × 明确：life depletion 优先，但精确 intra-tick ordering 需 ledger 定义） | Systems（本单元定义） | unresolved → 归 Systems 在终结单元定义（ADR-TECH-05 已列「exact intra-tick ordering」） |
| P3 | **结局状态呈现绑定**（victory/defeat/result 态 → read-model 呈现） | UX（呈现清单前置）+ Engineer（落地） | 观察目标先行固化（对齐 UX-10/UX-13 + Pillar 4） |
| P4 | **自动重置/session 重置事务**（RNG/ID/输入清理，无越局损失） | Engineer（机制，session/adapter seam 内） | Tech 机制边界已批准（TECH-02/05）；实现归 Engineer |

> 决策要点：单元 3 已使生命可耗尽 —— 这是依赖真相上的**必然下一步**：接触后玩家生命可耗尽，游戏必须处理「耗尽后发生什么」。单元 4 在已批准 TECH-05 终局仲裁+重置机制边界 + 决策 #5/#11/#12 内收口核心闭环。本单元由此具备排程可行性。

### 4.3 可分离延后（明确不进本单元）

- **升级（cr-010..011）/ 两次暂停 + 卡牌** — 依赖 B2 弧 + focus epoch（未定语义），延后独立单元。
- **B2（cr-016..019）/ `扇裂` 三弧** — 保持前-B2 单中心形态，`b2_phase` 结构位不变。
- **focus epoch（cr-012..013）完整失焦语义** — 延后（单元 5/后续独立单元）；本单元**仅**在终结 result-lock 边界做最小「陈旧输入拒绝」（拒 result 态内的 gameplay/confirmation 输入，ADR-TECH-05 result/input lock + 决策 #17 方向），**不引入完整 focus-epoch 缓冲/刷新语义**（cr-013 延后）。
- **spawn 节奏** — 延后（显式留空）。
- **O11 边界不去轴（cr-009）** — 延后（unresolved，本单元不趋轴）。
- 资产 / 动画 / 音频 / 数值定稿（含 HP 多段）/ 视觉基线 v0.2 / 导出 / 发布 / 持久化 / 玩家可见 Replay / O6 外层 evidence envelope / Gate 3 视觉全量 / O8 真人自由操作全量。

---

## 5. 验收路径（哪些进 Gate 2 扩展、哪些进 Gate 3）

| 验收面 | 归属 | 判据 / 证据 |
|---|---|---|
| **T2+T3 TERMINAL-\*/RESET-\* fixture 确定性** | **Gate 2 扩展** | Independent QA 独立 headless gdUnit4 复跑（≥2 次 exit 0 逐位一致）：`TERMINAL-life-depletion-first`（同帧生命优先）/ `TERMINAL-victory`（控制完成 #11）/ `TERMINAL-defeat-light-interruption`（#12）/ `TERMINAL-result-lock`（输入锁）/ `TERMINAL-stale-input-rejected`（陈旧输入拒绝）/ `RESET-auto-restart`（自动立即重试）/ `RESET-no-cross-run-loss`（无越局脏状态，RNG/ID/输入清理）。零容差断言纪律（O2/B3） |
| **T4 运行时 结局仲裁 → 呈现 → 立即重试** | **Gate 3 前段** | Independent QA 观察：生命耗尽 → defeat 呈现（light interruption）→ 自动立即重置 → 新局无越局损失；8 分钟完成 → victory（控制完成）；同帧生命耗尽优先（确定性对照）。presentation 只消费 read-model（ADR-TECH-01） |
| **T5 结局呈现观察** | **Gate 3 前段（视觉/UX，前段观察）** | runtime frame + Independent QA：结局/重试**可读、非惩罚、非色彩**（UX-13）、不遮挡 player/danger/space（UX-09）、立即重试节奏（§9.2「immediate retry after failure without punitive delay」前段）；**O10 终局帧补捕获**（`segments_lost=3` 或 defeat 呈现帧的 runtime 捕获，尽量补单元 3 O10 缺口） |
| **Gate 判据更新** | 不经本单元 | 本单元不把任何终局数值/字段呈现升级为 Gate 判据/发布承诺（AUTH-01；若未来升级 → D2，见 §6） |
| QA 独立观察 | Independent QA 独立 | QA 依当前版本基线独立观察；不沿用 builder 自评；不豁免 QA；本单元不授予任何 Gate 3+ 免除 |

> **诚实边界（O8/O12 延续）:** 结局呈现/立即重试前段观察仍以受限确定性（self-test）+ runtime 呈现观察为主；完整「真人键盘自由操作→耗尽→重试」玩家体验未全量独立验收（延续 O8/O12）。

---

## 6. AUTH-01 升级判定（重点 — 明确标注）

> AUTH-01（R13）：process-level 连续推进；非升级项自动接受专家建议（D1）；升级项（阈值/发布/平台/锚点类）用户亲自决策（D2）；冲突升级（D3）。本单元按此判定。

| 子块/项 | 判定 | 依据 |
|---|---|---|
| **终局/重置语义 ledger 制式前置（T1/P1）** | **非升级（D1 自动推进）** | 终局仲裁+重置**机制边界已批准**（ADR-TECH-05 §8）、决策 #5（结果+立即重试）/ #11（victory）/ #12（defeat=light interruption）`user_confirmed`；T1 按 S1 模式作为 `PROPOSAL`、range+starting_point、promotion=User、**不锁常数**——机制落地不触碰 promise/immutable/platform/threshold/release，无数值写死。 |
| **同帧生命耗尽精确时序语义（P2）** | **非升级机制前置；写死即 D2 升级** | 同帧优先边界已确认（decision #5 + ADR-TECH-05），精确 intra-tick ordering 归 Systems 终结 ledger 定义；**若终局时序/数值被写为规则常数/Gate 判据/发布承诺 → D2 升级**。 |
| **规则核 + adapter + 运行时 terminal 扩展（T2/T3/T4）** | **非升级（D1）** | 在已批准 seam（ADR-TECH-01/02 + TECH-05）内实施；规则核 terminal 纯逻辑、adapter 翻译、engine/session 重置机械处理——不越 seam；数值全部走 ledger 候选。 |
| **结局呈现观察目标（T5）** | **非升级前提（D1 观察）**；触碰 promise 即 D2 升级 | 结局是已确认决策（#11 victory=控制完成 / #12 defeat=light interruption）+ TECH-05 机制边界内的合法状态；按 §9.2 + Pillar 4（非惩罚）做**观察目标**（非冻结形态）与呈现绑定清单。**若结局呈现形态触碰 player promise（非惩罚）/ 核心支柱，或写入 Gate 判据 / 发布承诺文案 → D2 升级呈交用户亲自决策。** |
| **结局可玩性门（M1，核心闭环首次实测点）** | **D1 实现 + QA 前段观察；playability 门确认留边界外（User）** | §9.2 playability gate「immediate retry after failure without punitive delay」= 本单元首次实测点；判据结构已生效、**阻断权延后经 CR + 用户批准激活**（DC-PLAY-01 R08）。**本单元实现走 D1，但结局可玩性门通过与否（是否激活阻断权、是否可继续推进）明确留用户——本排程不预授权此确认。** |

> ### 条件触发的 D2 升级卡片（明确列出，需用户亲自决策的具体情形）
>
> 本单元**无前置强制 D2 升级**（终局+重置机制边界已批准 + 决策 #5/#11/#12 已确认 + 数值走 ledger 候选）。但以下**条件一旦命中，立即升级 `needs_user_decision`**（呈交用户亲自决策，非静默吸收）：
>
> | 卡片 | 触发条件 | 用户需决策的具体问题 |
> |---|---|---|
> | **D2-Card 1** | 结局时长 / 同帧时序 / 清理时序 / RNG·ID 重置范围 / 自动重置触发 任一数值或语义被提议**写为规则常数 / Gate 判据 / 发布承诺** | 该终局/重置数值或语义是否提升为正式规则/门槛/承诺？取值范围与起始点？ |
> | **D2-Card 3** | 结局呈现形态触碰 player promise（非惩罚）/ 核心支柱 / 被提议为发布文案 | 该胜利/失败/重试呈现是否越 promise？是否成为发布承诺？（defeat=light interruption #12 + Pillar 4 非惩罚） |
>
> > **推荐默认（非升级路径）:** (a) 终局仲裁按已批机制边界（同帧生命优先）+ 决策 #5/#11/#12 落地；(b) 全部终局/重置数值走 ledger 候选、promotion=User；(c) 结局呈现以 UX 观察目标固化、不冻结形态；(d) **结局可玩性门确认留用户**。本单元按推荐默认执行即全程 D1，但**结局可玩性门确认为边界后强制用户点（M1）**。

---

## 7. 角色分工（成员 → 交付物 → 写 ownership）

> 依团队执行纪律：本单元至少 **Systems（T1 关键前置）+ Engineer（T2/T3/T4/T5 落地关键）+ QA（独立验收关键）**；UX 为非关键单发（结局呈现观察目标 + 呈现清单）。父协调器组建最小 roster。仿 v0.3 §7。

| 成员 | 关键性 | 交付物 | 写 ownership（单一） |
|---|---|---|---|
| **Systems / Rules Designer** | **关键（T1 语义前置）** | 终局/重置语义 ledger（T1，S1 模式：终局判定/同帧生命优先/结局状态/结果时长/重置重试语义/陈旧输入拒绝，PROPOSAL，promotion=User，不锁常数）+ 与 ADR-TECH-05/失效 (ii)/TECH-02 衔接 | 终局/重置 ledger（Systems 唯一） |
| **Godot Gameplay Engineer** | **关键（实现 owner）** | T2 规则核 terminal 扩展；T3 TERMINAL-\*/RESET-\* fixture（同帧生命优先/结局状态/自动重置/无越局脏状态/陈旧输入）；T4 adapter/运行时结局仲裁·呈现·立即重试；T5 结局呈现落地（对齐 UX 清单）；GDMCP 预检 + start 证据 + 实现报告 | Godot 构件唯一写 owner（经 GDMCP） |
| **UX/UI Designer** | 非关键（单发） | 结局呈现观察目标（T5，victory/defeat 可读/非惩罚/非色彩 UX-13/不遮挡 UX-09/立即重试）+ 结局状态呈现绑定清单；明确排除 hint/文案/布局/资产冻结 | 观察目标 + 呈现清单（UX 提案唯一；落地归 Engineer） |
| **Independent QA / Release** | **关键（独立验收）** | Gate 2 扩展 TERMINAL-\*/RESET-\* 独立复跑（同帧生命优先/结局状态/自动重置/无越局脏状态/陈旧输入；确定性逐位一致）；Gate 3 前段独立观察（结局/重试可读、非惩罚、立即重试、O10 终局帧补捕获）；独立 verdict | 验收报告（QA 唯一） |
| （不派发）Tech Lead / Director / Balance / Art / Audio | — | 本单元无 ADR 变更、无创意/视觉验收、无数值平衡定稿、无资产/音频开工；TECH-05 终局仲裁+重置机制边界已批（无需 Tech 新裁决）；terminal 纯逻辑 seam 已由 TECH-01 覆盖（Engineer 落地） | — |

---

## 8. 范围边界（明确不做）

- ❌ **升级（cr-010..011）/ 两次暂停 + 卡牌**：延后（依赖 B2 + focus）。
- ❌ **B2（cr-016..019）/ `扇裂` 三弧**：保持前-B2 结构位，不引入 B2 行为。
- ❌ **focus epoch 完整失焦语义（cr-012..013）**：延后（单元 5/后续）；本单元仅边界内最小「陈旧输入拒绝」（result-lock 内拒 gameplay/confirmation，ADR-TECH-05 + 决策 #17 方向），不引入完整 focus-epoch 缓冲/刷新。
- ❌ **O11 边界不去轴（cr-009）**：延后（unresolved；本单元不趋竞技场轴）。
- ❌ **spawn 节奏 / 敌人多段 HP / 结局呈现精细形态 / hint 字段 / no_target_cue 精确表现**：延后或 unresolved，不冻结。
- ❌ **O6 外层 fixture envelope / evidence-harness / Producer index**：不进入（ADR-TECH-06 执行层后续）。
- ❌ **候选预算提升 / 性能测量（TECH-07/08）**：不进；六项候选 + `1280×720` 红线仅候选。
- ❌ **资产 / 动画 / 音频 / 数值定稿 / 视觉基线 v0.2 / 导出 / 发布 / 持久化 / 玩家可见 Replay / O8 真人自由操作全量 / Gate 3 视觉全量**：不进；占位/最小表现（ColorRect/Line2D/Label）。
- ❌ **结局可玩性门（M1）确认**：**本单元实现 D1、QA 前段观察照常，但可玩性门通过/阻断权激活留用户（授权边界外）**——父协调器不得代用户确认此门。
- ❌ **不批准/冻结任何 ADR / Systems 终裁 / fixture schema / 数值 / 表现形态**（本单元所有终局/重置数值走 ledger 候选，promotion_authority=User；条件触发 D2 卡片见 §6）。

---

## 9. 备选方案（若父协调器/用户偏好其它方向）

### 9.1 备选 A — 纯终局语义先行（T1+T2+T3 先行，T4 呈现/重试延后一次）
若父协调器/用户倾向先把终局仲裁与 fixture 语义落定，再呈现结局：
- 先派 T1（终局/重置 ledger）+ T2（规则核 terminal）+ T3（TERMINAL-\*/RESET-\* fixture）与 Gate 2 扩展验收；T4（adapter/运行时呈现）+ T5（UX 呈现/重试）作为一个后续子批。
- **代价（如实):** 呈现/立即重试延后一次会**延迟「可完整玩一遍并自动立即重试」这个玩家可见闭环的收口**（核心可玩闭环未在本子批闭合）；但作为逐步推进是安全的（fixture 语义先于呈现稳定）。若目标是最小化失败面/风险，可选。

### 9.2 备选 B — 精化/观察先行（先收 O10 终局帧捕获 + read-model 呈现精化，不带自动重试）
若父协调器/用户倾向先收束观察缺口再推进闭环：
- 仅交付 T5 呈现绑定 + O10 终局帧捕获协议，T1–T4 延后。
- **代价（如实):** 终结/重置**语义与自动重试均未落地**——核心可玩闭环未收口，slice 仍在「生命可耗尽但耗尽后无结局呈现/无重试」的半状态，**零新增玩家可见闭环价值**。不独立成立为下一玩法单元（万一单元推进纪律「有界 + 可玩家可见」被破坏）。
> **推荐理由:** 主方案（含 T1–T5 + T 测试/观察）按依赖真相把终结/重置语义先行（T1 ledger）+ 规则核 + fixture 落定（T2/T3）→ 再呈现 + 立即重试（T4）+ 观察目标（T5）收口核心闭环；A/B 备选仅在父协调器/用户特殊偏好（风险暴露优先 / 观察缺口优先）时启用。**主方案推荐，因其一次性把「可完整玩一遍并自动立即重试」做成玩家可见闭环**，且符合逐单元推进的有界+可玩家可见纪律。

---

## 10. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed（含决策 #5 life 三格&同帧生命优先/结果+立即重试、#11 victory=控制完成、#12 defeat=light interruption、#17 失焦安全方向）；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11（含 PRECHARTER-11 同帧生命耗尽优先于八分钟胜利）；cr-001 (R09)；ADR-TECH-01..06 批准（R11，含 TECH-05 终局仲裁+重置机制边界）；失效语义 (ii)；UX-03 S1–S3；AUTH-01（R13 实现授权）；单元 1/2/3 QA verdict `pass`；DC-PLAY-01 R08（playability 判据结构生效、阻断权延后）。本建议不重写、不重分类任何一项。
- **`team_proposal`（本建议的实质贡献）:** 单元 4（终结/重置体验，cr-014/cr-015）完整排程建议（T1 终局/重置语义 ledger / T2 规则核 terminal / T3 TERMINAL-\*/RESET-\* fixture / T4 adapter·运行时结局仲裁·呈现·立即重试 / T5 UX 结局呈现观察目标 / T 测试观察）；依赖分析；AUTH-01 升级判定（无前置强制 D2 + 条件触发 D2-Card 1/3 + **结局可玩性门 M1 明确留用户**）；角色分工；验收路径；范围边界；备选 A/B。全部为**排程建议**，供父协调器检查 AUTH-01 后决策；不升级任何契约/数值。
- **`assumption`:** ① 终局/重置（cr-014/015）作为 D1 自动推进的前提是其机制在已批 ADR-TECH-05 + 决策 #5/#11/#12 内、结果时长等数值走候选 ledger（需用户对「终结/重置纳入逐单元推进」的认可 + Engineer 落地 + QA 观察验证）；② 结果锁内最小「陈旧输入拒绝」可在不引入完整 focus-epoch（cr-012/013 延后）的前提下有界落地（ADR-TECH-05 result/input lock + 决策 #17 方向，需 Enginee 落地 + QA 观察验证）；③ 结局呈现为 §9.2 playability gate 首次实测点、其确认留用户（判据结构已生效、阻断权延后经 CR+用户激活）。均未在此代决。
- **`unresolved`（全量保留，未关闭）:** cr-014/015 精确同帧时序/结局时长/清理时序/RNG·ID 重置范围/陈旧输入拒绝精确语义；cr-010/011 升级触发/XP 数值；cr-012/013 focus 精确语义；cr-016..019 B2；cr-009 边界（O11）；spawn 节奏；life `life_state` 终结态枚举精确呈现；结局呈现精确表现形态；O6 evidence-harness；O8/O12 真人键盘自由操作未全量验收；候选预算（六项 + `1280×720` 红线）——全部保持 open，本建议不闭合、不升级任何项。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本建议未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升；未批准/冻结任何契约/规则语义/数值/表现形态；**结局可玩性门确认未预授权（留用户）。**

---

## 11. 边界声明与 Closure

- **未替用户做产品/验收裁决**：本文件是**排程建议**；最终产品裁决与验收归属 User 与 Independent QA。本单元中如任一条件触发 D2 卡片（§6），需用户亲自决策；**结局可玩性门（M1）确认明确归属授权边界外用户，本排程不代办、不预授权。**
- **逐单元推进流程边界**：本排程建议是**单元 4 的派发输入**，供父协调器检查 AUTH-01 后决定是否派发；**不替代**用户对「继续单元 4」的逐单元认可（本单元实现 AUTH-01 判定为 D1，但结局可玩性门确认留用户）；**不预授权单元 5/后续任何单元**。
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。
- **未触碰 Godot / 运行时 / 数值 / 契约**：未访问/修改 Godot、代码、场景、资源；未运行/构建/测试；未批准/冻结任何 ADR/Systems 终裁/fixture schema/数值/表现形态；候选预算不提升；QA 不豁免；未替任何角色代权（Systems/UX/Tech/QA 语义均未代决）。
- **写入面**：仅本唯一排程建议文件 `NEXT_IMPL_UNIT_PLAN_v0_4.md`；未修改任何其它文档（CR 台账、合同、ledger、排程 v0.3、QA verdict 等一律未触碰）。

**Closure:** `closure_ready = yes`（仅限本排程建议 artifact）。本建议非实现派发、非契约批准、非 QA 验收、非产品裁决、非结局可玩性门确认；父协调器据本建议检查 AUTH-01 后决定是否/如何派发单元 4。写入后停止，不进入下一阶段、不派发任何成员。

---

## 12. 版本与变更记录

- **v0.4（本文件）:** Executive Producer / Lead Producer 唯一新产物——承接单元 1/2/3 均已验收（接触使生命可耗尽、QA `pass`）+ 用户**拒绝批量授权、改逐单元推进**后的下一实现单元（单元 4：终结/重置体验，cr-014/cr-015）**完整排程建议**。把 `AUTHORIZATION_WORKLIST_D2_PRE_v0_1.md` §3「单元 4」概要细化为可派发完整排程：单元定义（T1 Systems 终局/重置语义 ledger / T2 规则核 terminal / T3 TERMINAL-\*/RESET-\* fixture / T4 adapter·运行时结局仲裁·呈现·立即重试 / T5 UX 结局呈现观察目标 / T 测试观察）；依赖分析（已就位 life 真实扣减/真实移动/kill/seam；需前置终局 ledger + 同帧时序 + 结局呈现绑定 + 重置事务；延后升级/B2/focus-full/O11/spawn/资产）；**AUTH-01 升级判定（D1 自动推进——机制边界已批 + 决策 #5/#11/#12 user_confirmed + 数值走 ledger；条件触发 D2-Card 1/3；结局可玩性门 M1 明确留边界外 User）**；角色分工（Systems + Engineer + QA 关键，UX 单发）；验收路径（Gate 2 扩展 TERMINAL-\*/RESET-\* + Gate 3 前段结局/重试可读·非惩罚·立即重试·O10 终局帧补捕获）；范围边界；备选 A/B；Provenance 分层与不变量保留完整。未修改任何其它文档。
