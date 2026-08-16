# NEXT IMPL UNIT PLAN v0.3 — 下一实现单元排程建议（B 接触单元完整排程）· cr-006..009

> **Status:** `SEQUENCING RECOMMENDATION — 升格候选 B 为正式下一单元排程`。仅排程建议，不派发实现、不批准/冻结契约、不替用户做产品/验收裁决、不豁免 QA、不替 Independent QA 下 verdict。父协调器据本建议决策是否/如何派发。
> **Role / owner (sole author):** Executive Producer / Lead Producer（执行制作人 / 首席制作人）
> **Report ID:** `NEXT_IMPL_UNIT_PLAN_v0_3`
> **Expert capability:** `godot-executive-producer-expert` — 实测 `skill({name:"godot-executive-producer-expert"})` **调用成功**（返回值完整 SKILL 指令；未发生 unknown tool / 接口不存在错误）。能力证据等级 = `strong_direct_skill`（首选等级，与 v0.2 §报头一致，即本运行时 `skill` 接口实测可用；`tools.skill` 包装器在本运行时非独立存在，以直接 `skill(...)` 成功）。无需 fallback 到 SKILL.md 读取。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本建议仅依据任务允许的指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试；未派发任何成员）。
> **排程依据（承接）:** 单元 1（垂直切片，v0.1 方案 A+）已验收 = `QA_VERTICAL_SLICE_VERDICT_v0_1.md` verdict `pass`（O4/O5/O6 非阻断）；单元 2（可玩切片，v0.2 方案 A）已验收 = `QA_PLAYABLE_SLICE_VERDICT_v0_1.md` verdict `pass`（O7/O8/O9 非阻断），**真实键盘移动基线已就位**。git：Godot 构件 commit `194618d` + docs commit `2a1dc51`；working tree 干净。**Gate 3+ 未验收**（本单元仍只含 Gate 2 扩展 + Gate 3 前段）。

---

## 1. Expert preflight（本排程任务的执行前置）

| 项 | 值 |
|---|---|
| 契约 | ADR-TECH-01..06 已批准（R11）；**ADR-TECH-05 机制边界已批准（contact 单次伤害+轻分离 / 升级两阶段 / focus epoch / 同帧生命优先），精确数值语义延后**（cr-006..020 Systems in_flight）；决策 #4（contact 单次伤害事件）`user_confirmed`；S1 kill ledger（PROPOSAL，promotion=User，格式参考 `ENEMY_LIFETIME_LEDGER_v0_1.md`）；S5 read-model 字段（life `segments_lost` 结构位落地，life 数值语义 unresolved 归 Systems contact 单元） |
| 用户指令 | 「继续下一单元」持续生效；R13 实现授权生效（契约内：ADR-TECH-01..06 + 已决决策范围；候选预算不提升；QA 不豁免） |
| 本建议不替代 | 用户产品裁决；Independent QA verdict；Systems 语义定裁；Tech ADR 批准；任何数值提升（promotion_authority=User） |
| 停止条件 | 唯一排程建议文件写入即停；不进入下一阶段、不派发任何成员 |

---

## 2. 边界与已确认事实（仅使用这些）

- **不变量:** 22 项原始 `user_confirmed`；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；unresolved 全量保留。
- **contact 已确认面:** 决策 #4（contact 单次伤害事件）`user_confirmed`；ADR-TECH-05 机制边界已批准（contact 单次伤害+轻分离）；slice 交接含「移动 + 自动攻击 + 接触 + 两次升级暂停 + 结局与重试」。
- **contact unresolved 面:** cr-006..009 精确值全 unresolved（cr-006 接触无敌时长/全局 vs 成对、cr-007 分离距离/方向/边界行为、cr-008 堆叠/同时接触、cr-009 玩家/敌人边界与分离失败）；`life segments_lost` 数值语义 unresolved（归 Systems 在 contact 单元定义）；玩家伤害体验形态需 UX 观察。cr-006..009 disposition = `absorb_within_authority`（Systems ledger，promotion=User；触碰承诺即升级 `needs_user_decision`）。
- **单元 2 已就位（真实移动基线）:** 真实键盘移动（WASD/箭头→adapter envelope→player 位移→移动因果→锁定重定位，`QA_PLAYABLE_SLICE_VERDICT §3.1` GDMCP key 注入 D/W 位移独立观察成立；self-test 保留为确定性回归）；kill 路径（HP/单击击杀/死亡移除，S1 ledger + S2 + adapter 移除）；失效语义 (ii)；life HUD 结构位（`LIFE [o][o][o] segments_lost=0`，无扣减行为，`READ_MODEL_IMPLEMENTATION_LIST §4.1`）；read-model 呈现 seam（attack_state 四态 / feedback-binding marker / kill_state / invalidation 节 / no-target quiet）；adapter seam（input/envelope/feedback gating / 空射不伪造）。
- **O7/O8/O9（非阻断）:** O8 = 真人键盘自由操作全程未完全独立验收（受限 key 注入验证 input→movement 因果，完整玩家可玩性未全量独立观察）。**本单元的接触体验 UX 观察仍受此边界约束**（见 §5/§6 诚实边界）。
- **候选预算（六项 + `1280×720` 红线）仅候选**，本单元不涉及。
- **范围边界惯例:** 每单元有界、可验收、可玩家可见；延后项不挤入。

---

## 3. 单元定义 — 下一实现单元 = 「候选 B：接触语义 + 玩家伤害（cr-006..009）」最小可玩扩展

**一句话:**
> 本单元在有界范围内 (1) 用 **S1 模式 CONTACT ledger 薄前置**（Systems 唯一 owner：接触判定、单次伤害、无敌时长、分离距离/方向、堆叠/同时接触、边界、life 数值语义——全部 `PROPOSAL`、range+starting_point、promotion=User、**不锁常数**）(2) 规则核 **contact 扩展**（接收 adapter 提供的接触合法性输入，ADR-TECH-01 seam；不拥有引擎实体）(3) **CONTACT-\* fixture**（含同时接触 / 边界案例）(4) adapter/运行时 **接触检测 → 伤害 → 短暂无敌 → 轻分离 → 再武装** (5) **life 扣减 read-model 呈现**（`segments_lost` 从 0 结构位变为实际扣减呈现）+ UX 玩家-伤害体验观察。接触使玩家第一次「能被威胁伤害并获得可读惩罚 + 通过移动/撤离恢复」——是 slice 从「清屏控制」迈向「非惩罚节奏 + 生命三格 + 压力/可恢复」的玩法深度台阶。

| 子块 | Owner | 交付物 | 写 ownership（单一） |
|---|---|---|---|
| **C1 CONTACT ledger 薄前置** | Systems / Rules Designer | S1 模式 ledger 行：接触判定（eligibility）/ 单次伤害（对齐决策 #4）/ 无敌时长 / 分离距离·方向 / 堆叠·同时接触 / 边界行为 / **life segments_lost 数值语义** —— `PROPOSAL`，range+starting_point，promotion_authority=User，不锁常数；与 ADR-TECH-05 + 失效 (ii) + TECH-04 衔接 | CONTACT ledger（Systems 唯一） |
| **C2 规则核 contact 扩展** | Godot Gameplay Engineer | `rules_core` contact 纯逻辑：接收 adapter 触点输入 → 判定合法接触 → 单次伤害事件 → 无敌状态 → 分离/再武装语义（引擎 free）；确定性，零 RNG；不拥有引擎实体 | rules_core（Engineer，经 GDMCP） |
| **C3 CONTACT-\* fixture** | Godot Gameplay Engineer（Owner）+ QA 复核 | `CONTACT-single` / `CONTACT-overlap` / `CONTACT-separate-rearm` / `CONTACT-simultaneous`（堆叠/同时，边界作明确未决上报）/ `CONTACT-boundary` / `CONTACT-removal`（对齐 Systems §6.3 fixture 矩阵）确定性 fixture——含同时接触 / 边界案例 | fixture（Engineer 唯一）；复核（QA） |
| **C4 adapter / 运行时接触·伤害·分离** | Godot Gameplay Engineer | adapter：接触/碰撞检测（引擎侧，ADR-TECH-01 seam）→ domain 触点输入；运行时：重叠→接触伤害→无敌→轻分离→再武装 → life 扣减；引擎实体物理移动/再武装归 adapter | Godot 构件（Engineer 唯一，经 GDMCP） |
| **C5 life 扣减 read-model 呈现** | UX/UI Designer（落地清单）+ Engineer（落地） | life 呈现绑定扩展：`segments_lost` 从结构位恒 0 → 实际扣减呈现（非色彩、非仅色彩，UX-13）；对齐 S5 life 字段 + READ_MODEL_IMPLEMENTATION_LIST §4.1 扩展；**hint/文案/布局/资产不冻结** | 落地清单（UX 提案唯一）；落地（Engineer 唯一） |
| **C6 UX 观察** | UX/UI Designer（观察目标）+ Independent QA（独立观察） | 玩家伤害体验形态观察目标（接触→伤害→生命损失→撤离/恢复的可读、非色彩、可归因；对齐 UX-02/03 + Pillar 4 非惩罚）；QA 独立执行前段观察 | 观察目标（UX 提案）；验收（QA 唯一） |
| **T 测试与观察** | Engineer + QA 独立 | CONTACT-\* 确定性复跑（含同时接触/边界）；Gate 3 前段独立观察（接触惩罚/分离/生命扣减可读、UX-13） | 实现 owner 自证 / QA 独立验收 |

---

## 4. 依赖分析（已就位 vs 需前置 vs 可分离延后）

### 4.1 已就位（本单元直接复用/衔接）

| 面 | 已就位 | 证据/出处 |
|---|---|---|
| **真实移动基线（前提）** | 真实键盘移动已建立（QA 单元 2 `pass`：GDMCP key 注入 D/W → player 位移 + `[RUNTIME] player_moved`；`_read_movement_input` 单一正式输入路径）；self-test 保留为确定性回归 | QA_PLAYABLE_SLICE §3.1；IMPL_PLAYABLE_SLICE §4.1 |
| **kill 路径** | S1 kill ledger + S2 规则核 kill（HP 参数化 / 死亡移除）+ adapter 引擎实体移除 | ENEMY_LIFETIME_LEDGER；QA_VERTICAL_SLICE |
| **失效语义 (ii)** | 终裁 (ii) 已实现（移除即失效→无命中；`invalidation_event`）；contact 的「失效目标不重复命中」复用同一 drain 语义 | QA_PLAYABLE_SLICE §2；SEMANTICS_INVALIDATION_FINAL |
| **life 结构位** | `LIFE [o][o][o] segments_lost=0` 呈现在位（结构骨架），但无扣减行为 | READ_MODEL_IMPLEMENTATION_LIST §4.1；QA_PLAYABLE_SLICE §3.2 |
| **read-model 呈现 seam** | attack_state 四态 / feedback-binding marker / kill_state / invalidation 节 / no-target quiet 已落地（presentation 只消费 read-model，ADR-TECH-01） | IMPL_PLAYABLE_SLICE §4.2 |
| **adapter seam** | input/envelope/feedback gating（lock/hit/kill 只在规则源非空 emit）/ 空射不伪造 | adapter_contract_test；QA_PLAYABLE_SLICE §2 |
| **契约** | ADR-TECH-05 机制边界已批（contact 单次伤害+轻分离）；决策 #4（contact 单次伤害事件）`user_confirmed` | KICKOFF_TECH_ADR §8；CR §3 cr-006..009 |

### 4.2 需前置（本单元必须先行/在单元内完成）

| # | 前置项 | 归属 | 性质 |
|---|---|---|---|
| P1 | **CONTACT ledger 薄前置**（S1 模式）：接触判定、单次伤害语义、无敌时长、分离距离/方向、堆叠/同时接触、边界行为 | Systems | `PROPOSAL`，promotion=User，不锁常数；本单元实施与 fixture 的语义前置 |
| P2 | **life segments_lost 数值语义**（接触伤害→生命扣减的规则定义：一次接触扣多少 / 三格如何消耗） | Systems（本单元定义） | unresolved → 归 Systems 在 contact 单元定义（`READ_MODEL_MINIMAL_FIELDS` / READ_MODEL_IMPLEMENTATION_LIST 已定位） |
| P3 | **接触检测/碰撞几何边界**（引擎侧接触检测在 adapter，规则核只收接触合法性输入） | Engineer（机制，ADR-TECH-01 seam） | Tech 机制边界已批准（TECH-05）；实现归 Engineer |
| P4 | **玩家伤害体验形态观察目标**（接触→伤害→生命损失可读、可归因、非色彩、非惩罚） | UX | 观察目标先行固化（对齐 UX-02/03 + Pillar 4） |

> 决策要点：本单元是 v0.2 §9.2 备选 B 的正式排程化。**v0.2 明确：真实移动若不先行，接触体验基础不足；单元 2 已建立真实移动基线，故该前提已满足。** 本单元由此具备排程可行性。

### 4.3 可分离延后（明确不进本单元）

- **升级（cr-010..011）/ 两次暂停 + 卡牌** — 依赖 B2 弧 + focus epoch（未定语义），延后独立单元（与 v0.2 §4 C defer 一致）。
- **B2（cr-016..019）/ `扇裂` 三弧** — 保持前-B2 单中心形态，`b2_phase` 结构位不变。
- **终结 / 重置（cr-014..015）** — 延后（contact 本单元生命耗尽后的结果呈现/重试属后续 terminal 单元；但 life 扣减呈现与「同帧生命优先」锚点本身由本单元提供字段骨架，不实现终局仲裁）。
- **focus epoch（cr-012..013）** — 延后。
- **spawn 节奏** — 延后（显式留空，`ENEMY_LIFETIME_LEDGER §5` 惯例）。
- 资产 / 动画 / 音频 / 数值定稿（含 HP 多段）/ 视觉基线 v0.2 / 导出 / 发布 / 持久化 / 玩家可见 Replay / O6 外层 evidence envelope。

---

## 5. 验收路径（哪些进 Gate 2 扩展、哪些进 Gate 3）

| 验收面 | 归属 | 判据 / 证据 |
|---|---|---|
| **C2+C3 CONTACT-\* fixture 确定性**（含同时接触 / 边界案例） | **Gate 2 扩展** | Independent QA 独立 headless gdUnit4 复跑（≥2 次 exit 0 逐位一致）：`CONTACT-single`（恰好一次伤害）/ `CONTACT-overlap`（无敌内无重复伤害、re-arm=false）/ `CONTACT-separate-rearm`（分离后恰一次新合法接触）/ `CONTACT-simultaneous`（堆叠/同时——**边界作明确未决上报**，断言「单次伤害事件 + 无敌吞并」为推荐默认、若改 N× 则升级 §7）/ `CONTACT-boundary`（边界分离与可恢复）/ `CONTACT-removal`（保护期移除→状态清理+未来 re-arm）。零容差断言纪律（O2/B3） |
| **C4 adapter/运行时 接触→伤害→无敌→分离→再武装** | **Gate 3 前段** | Independent QA 观察：真实移动（或受限注入）→ 接触重叠 → 单次伤害 → 生命扣减 → 无敌无重复伤害 → 分离 → 再武装可恢复（对齐 ADR-TECH-05 + Systems §6.1 合法接触转移链）；adapter 接触检测在 seam（ADR-TECH-01，规则核只收合法性输入） |
| **C5 life 扣减呈现** | **Gate 3 前段（视觉/UX，前段观察）** | runtime frame + Independent QA：`segments_lost` 从 0 实测扣减呈现（非色彩、非仅色彩，UX-13）；life 三格结构位在读 model 呈现；HUD 不遮挡 player/danger/space（UX-09）；hint/文案/布局/资产不冻结 |
| **C6 UX 玩家伤害观察** | **Gate 3 前段（重点）/ UX 观察目标** | 玩家伤害体验形态：接触→伤害→生命损失→撤离/恢复**可归因、非色彩、非惩罚**（UX-02/03 + Pillar 4）；「接触合法 vs 连续重叠」可辨（决策 #4）；与真实移动（U2-B/C）联动 |
| **Gate 判据更新** | 不经本单元 | 本单元不把任何 contact 数值/字段呈现升级为 Gate 判据/发布承诺（AUTH-01；若未来升级 → D2，见 §7） |
| QA 独立观察 | Independent QA 独立 | QA 依当前版本基线独立观察；不沿用 builder 自评；不豁免 QA；本单元不授予任何 Gate 3+ 免除 |

> 域事件归 Engineer；语义归 Systems；观察归 UX；验收归 QA；产品裁决归 User。

---

## 6. AUTH-01 升级判定（重点 — 明确标注）

> AUTH-01（R13）：process-level 连续推进；非升级项自动接受专家建议（D1）；升级项（阈值/发布/平台/锚点类）用户亲自决策（D2）；冲突升级（D3）。本单元按此判定。

| 子块/项 | 判定 | 依据 |
|---|---|---|
| **CONTACT ledger 制式前置（C1）** | **非升级（D1 自动推进）** | 接触机制在已批准 ADR-TECH-05 机制边界 + 决策 #4（contact 单次伤害事件）`user_confirmed` 内；CONTACT ledger 按 S1 模式（`ENEMY_LIFETIME_LEDGER_v0_1`）作为 `PROPOSAL`、range+starting_point、promotion=User、**不锁常数**——机制落地不触碰 promise/immutable/platform/threshold/release，无数值写死。 |
| **life segments_lost 数值语义（P2）** | **非升级机制前置；写死即 D2 升级** | `life` 数值语义明确归 Systems 在 contact 单元定义（`READ_MODEL_MINIMAL_FIELDS / READ_MODEL_IMPLEMENTATION_LIST` 已定位），走 ledger、promotion=User；**若接触伤害→生命扣减的数值被写为规则常数/Gate 判据/发布承诺 → D2 升级**。 |
| **规则核 + adapter + 运行时 contact 扩展（C2/C3/C4）** | **非升级（D1）** | 在已批准 seam（ADR-TECH-01/02 + TECH-05）内实施；接触检测的碰撞/几何在 adapter、规则核只收接触合法性输入——不越 seam；不新增系统、不越过 TECH-05 机制边界；数值全部走 ledger 候选。 |
| **玩家伤害体验形态 UX 观察（C6）** | **非升级前提（D1 观察）**；触碰 promise 即 D2 升级 | 接触是已确认的 slice 交接动词（非新系统）；玩家伤害是已批准生命三格系统（决策 #5 defeat=light interruption）+ TECH-05 机制边界内的合法行为。按 UX-02/03 + Pillar 4 做**观察目标**（非冻结形态）。**若接触→伤害反馈形态触碰 player promise（非惩罚）/ 核心支柱，或写入 Gate 判据 / 发布承诺文案 → D2 升级呈交用户亲自决策。** |

> ### 条件触发的 D2 升级卡片（明确列出，需用户亲自决策的具体情形）
>
> 本单元**无前置强制 D2 升级**——机制全部在已批准契约内、可按 S1 模式 ledger 推进。但以下**条件一旦命中，立即升级 `needs_user_decision`**（呈交用户亲自决策，非静默吸收）：
>
> | 卡片 | 触发条件 | 用户需决策的具体问题 |
> |---|---|---|
> | **D2-Card 1** | 接触伤害 / 无敌时长 / 分离距离·方向 / life 扣减链接 任一数值被提议**写为规则常数 / Gate 判据 / 发布承诺** | 该接触数值是否提升为正式规则/门槛/承诺？取值范围与起始点？ |
> | **D2-Card 2** | 同时接触/堆叠被设计为 **N× 多次伤害**（改变决策 #4「单次接触伤害事件」）；或无敌模型被设计为改变「单次伤害事件」承诺 | 多次同时接触是「一次伤害事件（无敌吞并，推荐默认，非升级）还是 N× 叠加（改 #4 → 升级）」？ |
> | **D2-Card 3** | 玩家伤害体验形态触碰 player promise（非惩罚）/ 核心支柱 / 被提议为发布文案 | 该接触→伤害反馈形态是否越 promise？是否成为发布承诺？ |
>
> **推荐默认（非升级路径）:** (a) 单次接触伤害 + 短无敌吞并同时接触（保持决策 #4）；(b) 全部 contact 数值走 ledger 候选、promotion=User；(c) 玩家伤害体验以 UX 观察目标固化、不冻结形态。**本单元按推荐默认执行即全程 D1。**

---

## 7. 角色分工（成员 → 交付物 → 写 ownership）

> 依团队执行纪律：本单元至少 **Systems（C1 关键前置）+ Engineer（C2/C3/C4/C5 落地关键）+ QA（独立验收关键）**；UX 为非关键单发（观察目标 + life 呈现清单）。父协调器组建最小 roster。

| 成员 | 关键性 | 交付物 | 写 ownership（单一） |
|---|---|---|---|
| **Systems / Rules Designer** | **关键（C1 语义前置）** | CONTACT ledger 薄前置（S1 模式：接触判定/单次伤害/无敌/分离/堆叠/边界/life 数值语义，PROPOSAL，promotion=User，不锁常数）+ 与 ADR-TECH-05/失效 (ii)/TECH-04 衔接 | CONTACT ledger（Systems 唯一） |
| **Godot Gameplay Engineer** | **关键（实现 owner）** | C2 规则核 contact 扩展；C3 CONTACT-\* fixture（含同时接触/边界）；C4 adapter/运行时接触·伤害·无敌·分离·再武装；C5 life 扣减 read-model 呈现落地（对齐 UX 清单）；GDMCP 预检 + start 证据 + 实现报告 | Godot 构件唯一写 owner（经 GDMCP） |
| **UX/UI Designer** | 非关键（单发） | player 伤害体验观察目标（C6）+ life 扣减呈现绑定清单（C5，S5 life 字段扩展）；明确排除 hint/文案/布局/资产冻结 | 观察目标 + life 呈现清单（UX 提案唯一；落地归 Engineer） |
| **Independent QA / Release** | **关键（独立验收）** | Gate 2 扩展 CONTACT-\* 独立复跑（含同时接触/边界；堆叠边界作明确未决上报）；Gate 3 前段独立观察（接触惩罚/分离/生命扣减可读、non-color UX-13、UX-09 不遮挡、玩家伤害可归因非惩罚）；独立 verdict | 验收报告（QA 唯一） |
| （不派发）Tech Lead / Director / Balance / Art / Audio | — | 本单元无 ADR 变更、无创意/视觉验收、无数值平衡定稿、无资产/音频开工；TECH-05 机制边界已批（无需 Tech 新裁决）；contact 碰撞/几何 seam 已由 TECH-01 覆盖（Engineer 落地） | — |

---

## 8. 范围边界（明确不做）

- ❌ **升级（cr-010..011）/ 两次暂停 + 卡牌**：延后（依赖 B2 + focus）。
- ❌ **B2（cr-016..019）/ `扇裂` 三弧**：保持前-B2 结构位，不引入 B2 行为。
- ❌ **终结 / 重置（cr-014..015）**：本单元仅提供 life 扣减字段骨架与「同帧生命优先」锚点字段，不实现终局仲裁/自动重试。
- ❌ **focus epoch（cr-012..013）**：延后。
- ❌ **spawn 节奏 / 敌人多段 HP / 走廊恢复可读反馈精细形态 / hint 字段 / no_target_cue 精确表现**：延后或 unresolved，不冻结。
- ❌ **O6 外层 fixture envelope / evidence-harness / Producer index**：不进入（ADR-TECH-06 执行层后续）。
- ❌ **候选预算提升 / 性能测量（TECH-07/08）**：不进；六项候选 + `1280×720` 红线仅候选。
- ❌ **资产 / 动画 / 音频 / 数值定稿 / 视觉基线 v0.2 / 导出 / 发布 / 持久化 / 玩家可见 Replay**：不进；占位/最小表现（ColorRect/Line2D/Label）。
- ❌ **不批准/冻结任何 ADR / Systems 终裁 / fixture schema / 数值 / 表现形态**（本单元所有 contact 数值走 ledger 候选，promotion_authority=User；条件触发 D2 卡片见 §7）。

---

## 9. 备选方案（若父协调器/用户偏好其它方向）

### 9.1 备选 A′ — 纯精化单元（O4/O5 收尾 + read-model 呈现精化，不带接触伤害）
若父协调器/用户倾向先收束工程与呈现精化：
- 仅交付 C5 life 呈现精化 + O4/O5 既有精化收尾，C1–C4 延后。
- **代价（如实):** 玩家伤害/生命三格体验仍未落地——slice「非惩罚节奏 + 生命三格 + 压力/可恢复」台阶未达成；**零新玩家可见玩法扩展**（违反「有界 + 可玩家可见」推进纪律）。不独立成立为下一玩法单元。

### 9.2 备选 B′ — 升级前置单元（先做 UPGRADE ledger / B2 前置）
若用户点名优先升级：
- **如实结论:** 升级依赖 B2 弧效果 + focus epoch 语义（均未定/延后）——「穿透/扇裂」无载体、升级暂停确认无失焦安全语义。**判 defer**（与 v0.2 §9.3/§4 C 一致）。B2/focus 未定则本备选暂不可排。

### 9.3 备选 B″ — 接触 + 升级合并单元
若用户偏好一次推进更多玩法：
- **如实结论:** 依赖链过深（升级依赖 B2/focus），合并后单元范围过大（行为语义 ×2 + 全链路 + 玩家伤害 + 卡牌呈现 + 暂停确认），违反「单元有界 + 可验收」纪律。**不推荐本阶段。**

### 9.4 推荐理由（为何推荐 B 而非备选）
- **玩家可见唯一性:** B 是把 slice 从「人可玩清屏」推向「非惩罚节奏 + 生命三格 + 压力/可恢复」的下一个**最大玩家可见玩法台阶**（接触→伤害→撤离→恢复）；A′ 不可见，B′/B″ 依赖未定语义。
- **依赖真相:** 单元 2 已建立真实移动基线（接触体验的前提已满足）；接触机制在已批准 TECH-05 + 决策 #4 内、按 S1 模式 ledger 即可推进（无新契约批准、无数值写死）；升级（B′）仍强依赖 B2/focus（未定）。**依赖真相支持 B 现排、升级后续。**
- **契约在授权内:** ADR-TECH-05 机制边界已批 + 决策 #4 user_confirmed + S1 ledger 模式已验（单元 1）——本单元无前置强制 D2，按推荐默认全程 D1。

---

## 10. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed（含决策 #4 contact 单次伤害事件 / #5 life 三格&同帧生命优先 / #19 非色彩可读）；revision-02 #3/#4/#5/#8；PRECHARTER-01..11（含 PRECHARTER-03 contact 合法性）；cr-001 (R09)；ADR-TECH-01..06 批准（R11，含 TECH-05 机制边界）；UX-03 S1–S3；AUTH-01（R13 实现授权）；单元 1/2 QA verdict `pass`（验收记录）。本建议不重写、不重分类任何一项。
- **`team_proposal`（本建议的实质贡献）:** 候选 B 升格为正式下一单元排程（C1 CONTACT ledger / C2 规则核 contact / C3 CONTACT-\* fixture / C4 adapter·运行时接触·伤害·分离 / C5 life 扣减呈现 / C6 UX 观察）；依赖分析；AUTH-01 升级判定（无前置强制 D2 + 条件触发 D2 卡片 D2-Card 1/2/3）；角色分工；验收路径；范围边界；备选 A′/B′/B″。全部为**排程建议**，供父协调器决策；不升级任何契约/数值。
- **`assumption`:** ① 接触检测/碰撞几何可在已批准 TECH-01 seam 内由 adapter 承担、规则核只收合法性输入（需 Engineer 落地 + QA 观察验证）；② 推荐默认（单次伤害 + 无敌吞并同时接触）保持决策 #4 非升级（需 Systems 在 ledger 确认 + UX/QA 观察，未确认前为假设）；③ life 扣减呈现可在已批准 read-model 契约内扩展且可被独立 QA 观察（需落地 + 观察验证）；④ O8（真人键盘自由操作未全量验收）在接触 UX 观察中同样受限（受限注入/有界演示，如实声明）。均未在此代决。
- **`unresolved`（全量保留，未关闭）:** cr-006..009 精确值（接触判定/无敌时长/分离距离方向/堆叠/边界/分离失败）；`life segments_lost` 数值语义（归 Systems 在 contact 单元定义）；玩家伤害体验精确形态；无敌全局 vs 成对模型；分离失败/边界行为精确规则；spawn 节奏；敌人多段 HP；走廊恢复精细反馈形态；hint；no_target_cue 种类；O6 evidence-harness/外层 envelope/raw 留存；fixture_schema_version；O8 真人键盘自由操作未全量验收——全部维持 open，本建议不闭合、不升级任何项。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本建议未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升；未批准/冻结任何契约/规则语义/数值/表现形态。

---

## 11. 边界声明与 Closure

- **未替用户做产品/验收裁决**：本文件是**排程建议**；最终产品裁决与验收归属 User 与 Independent QA。本单元中如任一条件触发 D2 卡片（§7），需用户亲自决策，本排程不代办。
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。
- **未触碰 Godot / 运行时 / 数值 / 契约**：未访问/修改 Godot、代码、场景、资源；未运行/构建/测试；未批准/冻结任何 ADR/Systems 终裁/fixture schema/数值/表现形态；候选预算不提升；QA 不豁免；未替任何角色代权（Systems/UX/Tech/QA 语义均未代决）。
- **写入面**：仅本唯一排程建议文件 `NEXT_IMPL_UNIT_PLAN_v0_3.md`；未修改任何其它文档。

**Closure:** `closure_ready = yes`（仅限本排程建议 artifact）。本建议非实现派发、非契约批准、非 QA 验收、非产品裁决；父协调器据本建议决策是否/如何派发 B 接触单元。写入后停止，不进入下一阶段、不派发任何成员。

---

## 12. 版本与变更记录

- **v0.3（本文件）:** Executive Producer / Lead Producer 唯一新产物——承接单元 1/2 均已验收 + 真实移动基线就位后的下一实现单元排程建议。把 v0.2 §4 候选 B / §9.2 备选 B 升格为**正式完整排程**：单元定义（C1 CONTACT ledger 薄前置 + C2 规则核 contact + C3 CONTACT-\* fixture + C4 adapter/运行时接触·伤害·分离 + C5 life 扣减 read-model 呈现 + C6 UX 观察）；依赖分析（已就位移动基线/kill/失效(ii)/life 结构位/read-model seam；需前置 CONTACT ledger + life 数值语义 + 接触检测 seam + 玩家伤害观察目标；延后升级/B2/终结/focus/spawn）；**AUTH-01 升级判定（无前置强制 D2，推荐默认全程 D1；条件触发 D2 卡片 D2-Card 1/2/3 明确列出）**；角色分工（Systems + Engineer + QA 关键，UX 单发）；验收路径（Gate 2 扩展 CONTACT-\* 含同时接触/边界 + Gate 3 前段接触惩罚/分离/生命扣减可读非色彩 UX-13）；范围边界；备选 A′/B′/B″；Provenance 分层与不变量保留完整。未修改任何其它文档。
