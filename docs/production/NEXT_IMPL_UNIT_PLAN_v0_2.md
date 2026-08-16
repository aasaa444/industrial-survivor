# NEXT IMPL UNIT PLAN v0.2 — 下一实现单元排程建议（sequencing）

> **Status:** `SEQUENCING RECOMMENDATION` — 仅排程建议，不派发实现、不批准/冻结契约、不替用户做产品/验收裁决、不豁免 QA。父协调器按本建议决策派发。
> **Role / owner (sole author):** Executive Producer / Lead Producer（执行制作人 / 首席制作人）
> **Report ID:** `NEXT_IMPL_UNIT_PLAN_v0_2`
> **Expert capability:** `godot-executive-producer-expert` — 实测 `skill({name:"godot-executive-producer-expert"})` **调用成功**（返回值完整 SKILL 指令），能力证据等级 = `strong_direct_skill`（首选等级）。无需 fallback 到 SKILL.md 读取。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本建议仅依据全部指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试；未派发任何成员）。
> **前置事实（承接上一单元 A+）:** 上一单元「移动→自动攻击→命中→击杀清除」最小可玩垂直切片已交付并经 Independent QA 独立验收 = **verdict `pass`**（`QA_VERTICAL_SLICE_VERDICT_v0_1.md`，Gate 2 扩展 29/29×2 exit 0 + 垂直切片前段 self-test 闭环 + runtime smoke 观察成立），附非阻断观察项 O4/O5/O6。git：Godot 构件 commit `822c51e`；docs commit `eef5691`；working tree 干净。

---

## 1. Expert preflight（本排程任务的执行前置）

| 项 | 值 |
|---|---|
| 契约 | ADR-TECH-01..06 已批准（seam/纯度/read-model/确定性/target 快照/headless）；ADR-TECH-05 机制边界已批准（contact 单次伤害+轻分离/升级两阶段/focus epoch/同帧生命优先），精确数值语义延后（cr-006..020 Systems in_flight）；TECH-07/08 未批准（draft_in_review，不进入实现）；S1 kill ledger（PROPOSAL，promotion=User）；S5 read-model 字段提案（PROPOSAL，落地归 Engineer） |
| 用户指令 | 「继续实现……按 slice 推进」方向持续生效；R13 实现授权仍有效（契约内：ADR-TECH-01..06 + 已决决策范围；候选预算不提升；QA 不豁免） |
| 本建议不替代 | 用户产品裁决；Independent QA verdict；Systems 语义定裁；Tech ADR 批准；任何数值提升（promotion_authority=User） |
| 停止条件 | 唯一排程建议文件写入即停；不进入下一阶段、不派发任何成员 |

---

## 2. 边界与已确认事实（仅使用这些）

- **不变量:** 22 项原始 `user_confirmed`；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；unresolved 全量保留。
- **已实现并通过验收（上一单元）:** S1 最小敌人命中生命周期 ledger（`ENEMY_LIFETIME_LEDGER_v0_1.md`：HP range[1,5]/starting_point=1、单击伤害→死亡、死亡→live 集/清理缩减，PROPOSAL，promotion_authority=User）+ S2 规则核 kill 路径（`rules_core.gd`：hp 默认 1、attack_damage 参数化、`kill_outcomes`/`kill_event`、死亡目标从后续候选消失、与失效语义 (ii) 一致）+ S3 adapter seam（`adapter.gd`：input→domain envelope、step/session 驱动、反馈绑定 `hit_results`、空射不伪造、不泄漏规则语义）+ S4 最小运行时场景（`runtime/main.gd` + `scenes/main.tscn`：player/enemy/attack line/HUD 占位/self-test）+ S5 read-model 字段提案（`READ_MODEL_MINIMAL_FIELDS_v0_1.md`：life/timer/B2 + no-target quiet + attack-state/hit_results_feedback/kill_state/invalidation 节，只提案、落地归 Engineer）。
- **测试:** 29 用例（14 rules 含 KILL-* 7 = 既有 7 target/session + KILL-single/multi/death-removal + TARGET-* enemy-lifetime 兼容；15 adapter 契约）经 Independent QA 独立重跑 2 次 exit 0 逐位一致；S4 self-test 独立复跑 2 次 exit 0 闭环（`[AUTO-ATTACK] locked → [HIT] → [KILL] → [CLEAR] → live enemies=0 → [SELF-TEST-CLEAR]`）。
- **当前运行态事实（QA 独立观察）:** 垂直切片前段成立——player 渲染、enemy 作为 `ordered_candidates` 输入被锁定并命中、击杀→引擎 queue_free 移除→清除→quiet 后态可观察；HUD 占位 `LIFE [o][o][o] TIMER pre-8min B2 pre-fission` / `no target (quiet)` / `attack: resolved` 从画面呈现且非色彩可读。**注意:** 移动在 self-test 模式为确定性空移（`position += Vector2(0,0)`）；非 self-test 时 `[RUNTIME] player_moved dir=...` 走 `_read_movement_input`（真实输入路径已存在但未被独立 QA 作为「玩家可玩」验收）。**缺口:** 真实输入驱动移动未经独立验收；read-model 仅落了占位子集，非全部字段。
- **延后未做（明确不进上一单元，后续处理）:** 接触（cr-006..009）/ 升级（cr-010..011）/ B2（cr-016..019）/ 终结（cr-014..015）/ focus（cr-012..013）/ spawn 节奏 / 资产 / 动画 / 音频 / 数值定稿 / 视觉基线 v0.2 / 导出 / 发布 / 持久化 / 玩家可见 Replay。
- **O4/O5/O6 非阻断观察项（顺延 Gate 2 O1/O2/O3）:** O4=KILL-* fixture 逐族容器方差变体未补齐；O5=kill 决策键（k1/k2/stable_id 桶）未在 diagnostics 层导出为独立只读 trace 元组；O6=外层 fixture-schema envelope（evidence_id/digest/build_identity/Producer index 链路）未落盘（ADR-TECH-06 evidence-harness 层完成项）。均为精化/工程项，不阻断。
- **候选预算（六项 + `1280×720` 红线）:** 仅候选，本任务不涉及、不提升。
- **可选读取补充:** `KICKOFF_UX_UI_CONTRACTS_v0_1.md` 未另读（S5 提案与 QA verdict 已充分引用 UX-02/03/09/13 判据，足以支撑 read-model 落地边界）；`QUEUE_OF_*` 在 docs/production/ 无匹配文件（glob 无结果）。

---

## 3. 现状盘点（上一单元后：已存在 vs 缺失）

### 3.1 已存在（上一单元完成后）

| 面 | 已存在 | 证据/出处 |
|---|---|---|
| 引擎侧 | rules core target 语义 + kill 路径（hp/attack_damage 参数化）；adapter seam（input 映射/envelope/feedback-binding/no-leakage/空射不伪造）；最小运行时场景（player、enemy 节点、attack line、HUD 占位、self-test）；session 生命周期 | commit `822c51e`；QA verdict §7；IMPL_VERTICAL_SLICE §3 |
| 语义侧 | S1 最小 kill 路径 ledger（HP[1,5]/起始=1、单击击杀、死亡→live 缩减、promotion=User）；失效语义 (ii) 终裁已实现一致 | ENEMY_LIFETIME_LEDGER_v0_1；QA verdict §4 |
| UX 侧 | S5 read-model 字段提案（结构契约：life/timer/b2 + no-target quiet + attack-state + feedback-binding marker + kill_state + invalidation 节）；空射不伪造形态（UX-03 S1–S3）已固化为观察目标 | READ_MODEL_MINIMAL_FIELDS_v0_1 |
| 契约侧 | ADR-TECH-01..06 已批准（生效技术契约）；TECH-05 机制边界批准；R13 实现授权生效（契约内） | KICKOFF_TECH_ADR_CONTRACTS_v0_1 §4–§9/§12/§18；CR §8.6/§8.7 |

### 3.2 缺失（下一单元候选池）

| # | 缺失项 | 归属面 | 性质 |
|---|---|---|---|
| M1 | **真实输入驱动移动**（当前自测脚本化空移；`_read_movement_input` 路径已存在但未作为玩家可玩独立验收） | 引擎侧 | 玩家可见打磨缺口 |
| M2 | **read-model 完整字段落地**（当前仅 HUD 占位子集：life/timer/b2/no-target/attack_state；`hit_results_feedback` marker 的逐反馈类因果绑定、`kill_state`、invalidation presentation 节、attack_state 四态切换未完整呈现） | UX 侧落地（归 Engineer） | 玩家可见打磨缺口 |
| M3 | **O4/O5/O6 精化**（KILL-* 方差变体 / kill 决策键 trace 元组 / 外层 fixture envelope） | 引擎侧 + evidence-harness 层 | 非阻断工程项 |
| M4 | **接触（cr-006..009）**（接触伤害/无敌/分离/堆叠/边界；TECH-05 机制边界已批准、精确值 unresolved） | 语义侧 | 玩法深度（延后独立单元） |
| M5 | **升级（cr-010..011）**（触发窗口/XP/卡牌；决策 #7/#8/#9 结构已确认；数值候选） | 语义侧 + UX 侧 | 强依赖 B2/focus，延后 |
| M6 | **B2（cr-016..019）/ 终结（cr-014..015）/ focus（cr-012..013）/ spawn 节奏 / life 数值语义 / 走廊恢复反馈形态 / hint 字段** | 语义侧 + UX 侧 | 全部 unresolved，延后 |

> **决策要点:** 上一单元把 slice 前四动词「移动→自动攻击→命中→击杀→清除」在**引擎内**闭环（self-test + runtime smoke）。下一单元的可玩性台阶 = 把闭环从「脚本驱动」升为「**真人键盘驱动**」，并把 read-model 从「占位子集」升为「**全字段落地**」——这是让最小垂直切片第一次成为「人可玩的切片」的收尾。

---

## 4. 下一实现单元候选（2–4 候选 + 组合；每项含依赖分析/交付物/验收路径/风险）

### 候选 A — read-model 正式落地 + 输入驱动真实移动（打磨可玩切片）

- **范围:** 把已有 `_read_movement_input` 输入路径正式化为玩家可玩移动（WASD/方向键 → adapter envelope → player 位移 → 移动因果 → 自动攻击锁定重定位）；S5 字段集完整落地（`hit_results_feedback` marker 逐反馈类绑定、`kill_state`、invalidation presentation 节、attack_state 四态、no-target quiet 形态确认）；minimal HUD 面完整呈现（life/timer/b2）。
- **依赖分析:**
  - ✅ **无新 Systems 语义前置**——不触碰任何 unresolved 数值（life 数值语义、HP 多段、spawn 均延后）；不需要新 ledger 行。
  - ✅ adapter input 映射已实现且过契约测试（`test_input_*` 5 例，QA verdict §2）；`_read_movement_input` 非 self-test 路径已在 main.gd 存在。
  - ✅ S5 字段提案已到齐；ADR-TECH-02 read-model/空射不伪造契约已批准；UX-03 S1–S3 观察目标已固化。
  - ⚠️ 唯一技术不确定 = 「真实输入」的独立 QA 观察协议（input 注入或有界键盘演示的自动化路线，QA 制定；self-test 保留为确定性回归，不冒充玩家可玩证据）。
  - ❌ 不依赖接触/升级/B2/终结/focus（全部可分离）。
- **交付物:** 真实键盘驱动玩家移动（去脚本化空移，保留受限 self-test 为回归）；S5 全字段落地（Engineer 经 GDMCP）+ 相应 read-model/契约测试扩展；HUD 完整呈现帧证据输入。(可选精化子块：O4/O5，见 §5.1。)
- **验收路径:** Gate 3 前段（重点）——真实输入移动可观察（输入→移动→锁定重定位因果）、read-model 全字段呈现、非色彩可读（UX-13）、player/danger/space 不被 HUD 遮挡（UX-09）；Gate 2 扩展——新增 fixture/契约测试独立复跑（exit 0 逐位一致）。
- **风险:** ① 「真实输入」自动化验收成本/观察协议未定（QA 须先定协议，否则以受限输入注入或人工演示有限度观察，如实声明边界）；② 「read-model 完整落地」边界需防蔓延（hint 字段明确排除、文案/布局/资产不冻结、不把字段呈现升级为 Gate 判据）；③ O4 判据表述修订若吸收需 Systems/Tech/QA 共裁（轻量，非阻断）。

### 候选 B — 接触语义 + 玩家伤害（cr-006..009）

- **范围:** Systems CONTACT ledger 薄前置（contact 单次伤害+轻分离、无敌时长、分离距离、堆叠、边界行为——range+starting_point，PROPOSAL，promotion=User）+ 规则核 contact 扩展 + CONTACT-* fixture + adapter + 运行时接触/伤害/分离 + life 扣减呈现。
- **依赖分析:**
  - ✅ ADR-TECH-05 机制边界已批准（contact 单次伤害+轻分离）；决策 #4（contact 单次伤害事件）user_confirmed——机制在授权内。
  - ❌ cr-006..009 精确值全 unresolved（无敌时长、分离距离/方向、边界行为、堆叠/同时接触）；`life` segments_lost 数值语义延后归 Systems（S5 占位，需 Systems 在接触单元定义）——需要 S1 式薄 ledger 前置。
  - ⚠️ 玩家伤害是玩家可见惩罚行为——体验形态需 UX 观察；「接触→玩家伤害→生命损失」若触碰 promise/体验边界 → 升级判定（见 §6）。
- **交付物:** CONTACT ledger（Systems 唯一 owner）+ rules_core contact 纯逻辑 + fixture + adapter/运行时（重叠→伤害→无敌→轻分离→再武装）+ life 扣减 read-model 呈现。
- **验收路径:** Gate 2 扩展（CONTACT-* fixture 确定性，含同时接触/边界案例）+ Gate 3 前段（接触惩罚/分离/生命扣减可读、非色彩反馈）。
- **风险:** 单元范围显著大于 A（行为语义前置 + 全链路）；contact 解析需碰撞/几何（引擎侧接触检测边界在 adapter，规则核只收接触合法性输入——ADR-TECH-01 seam）；数值写死即 D2 升级；真实移动若不先行，接触体验基础（能移动到威胁/撤离）尚未成立。

### 候选 C — 升级路径（cr-010..011）

- **范围:** UPGRADE ledger（触发计时窗口候选 2–3min/4.5–6min、XP 来源/数值——PROPOSAL，promotion=User）+ 升级事务（保证触发→全场暂停→三同关键词卡选择→反馈→恢复，决策 #7/#8/#9 已确认结构）+ 卡牌呈现。
- **依赖分析:**
  - ✅ 决策 #7（三张同关键词卡）/ #8（两次保证暂停）/ #9（XP 仅中间物）user_confirmed；ADR-TECH-05 升级事务两阶段机制边界已批准。
  - ❌ **强前置缺失:** B2 三弧（cr-016..019）延后——第一卡「穿透」的效果（弧）无载体，升级意义不可体验；focus epoch（cr-012..013）延后——升级暂停确认依赖失焦安全（拒绝陈旧 Enter/Space）；触发窗口/XP 数值 unresolved（cr-010/011 候选）。
  - ⚠️ 依赖链最长（升级→B2、升级→focus、升级→计时窗口观察），实施面大（暂停/卡牌 UI/UX-04/05）。
- **交付物:** UPGRADE ledger + upgrade 事务状态机（暂停/选择/恢复）+ 卡牌最小呈现 + 触发计时（候选）+ 相关 fixture。
- **验收路径:** Gate 3 前段（暂停→卡牌选择→恢复可观察；UX-04/05 卡牌可比较性）
- **风险:** 写死触发窗口/XP 数值 = D2 升级；B2/focus 未定则升级暂停确认无失焦安全语义（触碰 focus epoch 拒绝陈旧输入承诺）；本阶段做 C 违反「依赖真相先定」纪律——**判 defer**（在 B2 语义落定后的单元再做，卡效果有载体、暂停确认有 focus 语义）。

### 候选 D — 纯精化（O4/O5/O6 + fixture envelope）

- **范围:** KILL-* 逐族容器方差变体（O4）；kill 决策键 trace 元组导出（O5）；外层 fixture-schema envelope 落盘（O6：evidence_id/digest/build_identity/seed/run_id 等，对齐 QA_ACCEPTANCE_PLAN §4.1 + ADR-TECH-06）。
- **依赖分析:** ✅ 无新语义依赖；❌ O6 涉及 evidence-harness/Producer index 链路与 raw 留存契约（ADR-TECH-06 执行层、raw-retention 为 finalize-in-approval-path 项，未冻结）。
- **交付物:** 方差变体 fixture + diagnostics trace 元组 + envelope 记录样例 + Producer index 衔接提案。
- **验收路径:** Gate 2 扩展复跑（29+ 用例）；envelope 层由 QA 审计可审计性。
- **风险:** **零玩家可见进展**——违反 slice「每次有界、可验收、**可玩家可见**」推进纪律；O4/O5/O6 均非阻断、可顺延。**不独立成立为下一单元**（可作吸收子块或独立 evidence-harness 工程单元）。

### 组合

- **A+D（推荐主路径）:** 真实可玩打磨 + 工程收尾（O4/O5 低风险吸收进 A；O6 归 evidence-harness 后续）。单元内**无新行为语义前置**，是上一单元 A+ 模式的自然收尾。
- **A→B（时序组合，非合并）:** B 列为紧随 A 之后的玩法深度候选——真实移动先成立（接触体验需要玩家能移动/撤离），A 为 B 提供可玩家基线；若合并则单元过大（行为语义 + 全链路 + 玩家伤害体验）。
- **B+C / 深层组合:** 依赖链过深（C 依赖 B2/focus），不推荐本阶段。

---

## 5. 推荐方案（建议）

### 5.1 推荐：下一实现单元 = 「候选 A — read-model 正式落地 + 输入驱动真实移动（打磨可玩切片）」，吸收 O4/O5 为单元内精化子块

**一句话:**
> 下一单元在一个有界范围内 (1) 把已有输入路径正式化为**真人键盘驱动的玩家移动**（self-test 降级为确定性回归，不再冒充玩家可玩证据），(2) 将 S5 字段提案**完整落地**（HUD 最小面 + no-target quiet + attack-state/feedback-binding marker/kill_state/invalidation 节，ADR-TECH-02 + UX-03 S1–S3 已批准边界内），(3) 吸收 **O4/O5**（KILL-* 方差变体 + kill 决策键 trace 元组）为低风险精化子块；接触/升级/B2/终结/focus **明确延后**。

### 5.2 推荐理由（argue）

1. **slice 推进纪律（有界 + 可验收 + 可玩家可见）:** A 让垂直切片第一次从「引擎内闭环（self-test 脚本）」升级为「**人可玩的切片**」——玩家真实按键移动、HUD 完整可读、击杀→清除→quiet 在真人驱动下可体验。这是上一单元完成后的最大玩家可见台阶；单元有界（无新行为语义）。
2. **依赖真相:** A 是**唯一无 Systems 语义前置**的候选——不需要新 ledger 行、不触碰 unresolved 数值（life/HP/spawn/hint 全延后）；接触（B）需要 CONTACT ledger 薄前置（TECH-05 机制已批、精确值 unresolved）；升级（C）依赖 B2 + focus 强前置（未定）——**依赖真相支持 A 先行、B 随后、C 延后**。移动还是接触体验的前置（接触重叠/撤离都要求玩家能真实移动），故 A 是 B 的前提单元。
3. **R13 授权范围:** A 全部落在已批准契约内——ADR-TECH-02 read-model（含空射不伪造 R4）、adapter input 映射（已批 seam）、user_confirmed「PC-first 键盘 / 移动」方向；无候选预算涉及、无数值写死、无 TECH-07/08 越界（见 §6 升级判定）。
4. **延续上一单元成功模式:** 上一单元 A+ 混合单单元证明「薄前置 + 全链路落地」纪律可行；A 是此模式**无需新前置的收尾**，风险最低；O4/O5 是纯规则核精化，不扩大语义面。

### 5.3 单元范围（做什么）

| 子块 | Owner | 交付物 | 写 ownership |
|---|---|---|---|
| **R1 真实输入驱动移动** | Godot Gameplay Engineer（实现 owner） | 正式化 `_read_movement_input` 路径：WASD/方向键 → adapter envelope → player 位移 → 移动因果 → 自动攻击锁定重定位；self-test 保留为**受限确定性回归**（明确标注非玩家可玩证据）；输入→移动 fixture/契约测试扩展 | Engineer（Godot mutation，经 GDMCP） |
| **R2 read-model 全字段落地** | Godot Gameplay Engineer（落地）+ UX/UI Designer（落地清单） | S5 字段集完整落地：`hit_results_feedback` marker 逐反馈类绑定、`kill_state`（none→killed）、invalidation presentation 节、attack_state 四态（idle/resolving/resolved/no_target）、no-target quiet 形态；HUD 最小面（life/timer/b2）完整呈现；**hint 字段明确排除** | 落地清单（UX 提案，唯一）/ 落地（Engineer 唯一） |
| **R3 精化子块（吸收 O4/O5）** | Godot Gameplay Engineer + QA 复核 | KILL-* 逐族容器方差变体 fixture（O4）；kill 决策键（k1/k2/stable_id 桶）独立只读 trace 元组导出（O5）；判据表述修订如需由 Systems/Tech/QA 轻量共裁（结果不阻断主交付） | Engineer（fixture 精化）；QA（复核） |
| **T 测试与观察** | Engineer + QA 独立 | 扩展 fixture/契约测试确定性复跑；真实输入观察协议（input 注入/有界演示）由 QA 制定并独立观察 | 实现 owner 自证 / QA 独立验收 |

### 5.4 本单元明确**不做**（范围边界，防漂移）

- ❌ **接触（cr-006..009）**：即时伤害/无敌/分离/堆叠/边界——**延后到紧随单元（候选 B）**，需要 CONTACT ledger 前置。
- ❌ **升级（cr-010..011）/ 两次暂停**：触发/XP/卡牌——延后（依赖 B2 + focus，见 §4 C）。
- ❌ **B2（cr-016..019）/ `扇裂` 三弧**：延后；本单元保持前-B2 单中心形态（S5 `b2_phase` 结构占位不变）。
- ❌ **终结（cr-014..015）/ focus-epoch（cr-012..013）**：延后。
- ❌ **spawn 节奏 / life 数值语义 / 走廊恢复可读反馈形态 / hint 字段 / no_target_cue 精确表现**：全部 unresolved 或延后；不冻结、不落地正式形态。
- ❌ **O6 外层 fixture envelope / evidence-harness / Producer index 链路**：不进入本单元（ADR-TECH-06 执行层后续工程，raw 留存契约为 finalize-in-approval-path 项）。
- ❌ **候选预算提升 / 性能测量（TECH-07/08）**：不进入；六项候选 + `1280×720` 红线仍仅候选。
- ❌ **资产 / 动画 / 音频 / 数值平衡定稿 / 视觉基线 v0.2 / 导出 / 发布 / 持久化 / 玩家可见 Replay**：不进入；占位/最小表现（ColorRect/Line2D/Label），无美术验收承诺。
- ❌ **不批准/冻结任何 ADR / Systems 终裁 / fixture schema / 数值**（本单元无新语义前置；所有数值仍候选，promotion_authority=User）。

---

## 6. AUTH-01 升级判定（明确标注）

| 方案 | 判定 | 依据 |
|---|---|---|
| **推荐 A（read-model 落地 + 输入驱动移动 + O4/O5）** | **非升级（D1 自动推进）** | read-model 全字段落地在 ADR-TECH-02（已批准）+ S5 提案（PROPOSAL）边界内；输入驱动移动在已批准 adapter seam + user_confirmed「PC-first 键盘 / 移动」方向内；不触碰 promise/immutable/platform/threshold/release；不涉及候选预算；无数值写死；无新 Systems 语义前置。**本单元无用户亲自决策项。** |
| 候选 B（接触伤害） | 机制非升级；**数值写死 = D2 升级** | TECH-05 机制边界已批准 + 决策 #4 user_confirmed → 机制在授权内可按 S1 模式 ledger 前置推进；但接触伤害/无敌时长/life 扣减数值若提升为规则常数/Gate 判据/发布承诺 → D2 升级呈交用户亲自决策；`life` 数值语义归 Systems 定义（promotion=User）。 |
| 候选 C（升级路径） | **D2 升级面 + 强前置缺失 → defer** | cr-010（触发窗口 2–3min/4.5–6min）/ cr-011（XP 数值）写死即升级；依赖 B2 + focus 未定语义——不经用户升级也暂不可排。 |
| 候选 D（纯精化） | 非升级 | 纯工程/证据项，不触碰任何承诺；但零玩家可见，不独立成立。 |

> **AUTH-01 结论:** 推荐方案 **A 不需要 User 升级决策**（非 threshold/release/platform/anchor 类），按 D1 自动推进路径执行；父协调器按惯例透明报告采纳记录，用户保留否决权。唯一需用户/父协调器决策的是「是否派发本单元」这一排程动作本身（非 AUTH-01 D2 升级类）。若未来实施中任何 read-model 字段呈现升级为 Gate 判据/发布承诺文案，或接触/升级单元中任何候选数值被写死 → 立即按 §6 判定升级至用户。

---

## 7. 角色分工（成员 → 交付物 → 写 ownership）

| 成员 | 关键性 | 交付物 | 写 ownership（单一） |
|---|---|---|---|
| UX/UI Designer | 非关键（单发） | R2 落地清单：S5 字段集 → 呈现绑定（feedback-binding marker、kill_state、invalidation 节、attack_state 四态、no-target quiet）+ 明确排除 hint/文案/布局/资产冻结 | read-model 落地清单（UX 唯一提案；落地归 Engineer） |
| Godot Gameplay Engineer | **关键（实现 owner）** | R1 真实输入驱动移动；R2 S5 全字段落地；R3 O4/O5 精化；扩展 fixture/契约测试；GDMCP 预检 + start 证据 + 实现报告 | Godot 构件唯一写 owner（经 GDMCP） |
| Independent QA / Release | **关键（独立验收）** | 真实输入观察协议制定；Gate 3 前段独立观察（输入→移动→锁定重定位因果、read-model 全字段呈现、非色彩可读 UX-13、UX-09 遮挡红线）；Gate 2 扩展独立复跑（新增 fixture）；独立 verdict | 验收报告（QA 唯一） |
| （不派发）Systems / Tech Lead / Director / Balance / Art / Audio | — | 本单元**无 Systems 语义前置**（不需 ledger 行）、无 ADR 变更、无创意/视觉验收、无数值平衡、无资产/音频开工；O4 判据表述若需修订由 Systems/Tech/QA 轻量共裁（父协调器协调，不派发常规成员） | — |

> 依团队执行纪律：本单元至少 **Engineer（关键）+ QA（关键）**；UX 为非关键单发。父协调器组建最小 roster。

---

## 8. 验收路径（哪些进 Gate 2 扩展、哪些进 Gate 3）

| 验收面 | 归属 | 判据 / 证据 |
|---|---|---|
| **R1 真实输入驱动移动**（输入→移动→锁定重定位因果） | **Gate 3 前段（重点）** | Independent QA 按观察协议观察：真实键盘输入（或受限 input 注入/有界演示）→ player 位移 → 自动攻击锁定快照随移动重定位（对齐 ADR-TECH-04「移动→下一次自动攻击因果可读」、UX-02 U2-B/C）；self-test 保留为确定性回归但不作为玩家可玩证据（如实声明边界） |
| **R2 read-model 全字段落地** | **Gate 3 前段（视觉/UX）** | runtime frame + Independent QA：HUD 最小面（life/timer/b2）+ no-target quiet（无锁/无幻影命中，UX-03 S1/S2）+ attack_state 四态 + feedback-binding marker（反馈类 ↔ `hit_results` 因果）+ kill_state；player/danger/space 不被 HUD 遮挡（UX-09）；非色彩可读（UX-13） |
| **R3 O4/O5 精化 + 新增 fixture** | **Gate 2 扩展** | 扩展 fixture（KILL-* 方差变体 / trace 元组导出）headless 独立重跑 exit 0 逐位一致；零容差断言纪律（O2/B3）；判据表述修订如需由 Systems/Tech/QA 共裁 |
| **观察项 O6 等 evidence-harness** | 后续工程 | 外层 envelope/Producer index 链路属 ADR-TECH-06 执行层后续，**不阻塞本单元** |
| QA 独立观察 | Independent QA 独立 | QA 依当前版本基线独立观察，不沿用 builder 自评；不豁免 QA；本单元不授予任何 Gate 3+ 免除 |

> 域事件归 Engineer；语义归 Systems；观察归 UX；验收归 QA；产品裁决归 User。

---

## 9. 备选方案

### 9.1 备选 A′ — 纯 read-model 落地（不带真实输入驱动移动）
若父协调器/用户倾向最小化输入自动化成本：
- 仅交付 R2（+可选 O4/O5），R1 延后。
- **代价（如实）:** 玩家仍不能亲手移动（self-test 脚本驱动）；「人可玩的切片」台阶未达成，垂直切片仍为引擎内闭环。
- **适用情形:** 真实输入观察协议成本短期不可接受，先落 read-model 再补移动。

### 9.2 备选 B — 接触伤害单元（紧随 A 之后的玩法深度候选）
若父协调器/用户偏好玩法推进：
- 交付 CONTACT ledger 前置 + 规则核 contact + fixture + 运行时接触/伤害/分离 + life 扣减（依赖 A 已建立的真实移动基线为体验前提）。
- **代价（如实):** 需要 Systems ledger 前置（S1 模式）→ 单元有语义前置、范围大于 A；life 数值语义需 Systems 定义；玩家伤害体验需 UX 观察与升级判定兜底（数值写死 = D2）。
- **适用情形:** A 落地并验收后作为**下一单元二号候选**（真实移动先成立，接触才有体验基础）。

### 9.3 备选 C — 升级路径（defer）
若用户点名优先升级：
- **如实结论:** 依赖 B2 弧效果 + focus-epoch 语义（均延后/未定），「穿透」卡无载体、暂停确认无失焦安全语义；触发窗口/XP 数值候选写死即 D2 升级。**建议延后**至 B2 语义落定后的单元再排，届时以 UPGRADE ledger 前置（S1 模式）推进。

### 9.4 备选 D — evidence-harness 工程单元（O6 + envelope + Producer index）
若用户偏好先收束证据纪律：
- 独立小工程单元（非玩家可见）：外层 fixture envelope 落盘、raw 留存契约定稿、Producer index 链路；QA 审计可审计性；验收 = Gate 2 扩展复跑 + envelope 审计。
- **代价（如实):** 零玩家可见进展；可作为**与 A 并行或紧随其后**的低风险工程收尾，不阻塞 A。

### 9.5 推荐理由（为何推荐 A 而非备选）
- **玩家可见唯一性:** A 是当前唯一把 slice 从「引擎内闭环」推向「真人可玩」的候选；B 依赖 A 的移动基线，C 依赖 B2/focus，D 不可见。
- **无前置、风险最低:** A 无 Systems 语义前置（不需要新 ledger），全在已批准契约内、非升级（D1）；是上一单元 A+ 模式的自然收尾。
- **为 B/C 铺路:** 真实移动先成立 → 接触体验（B）可玩可验；contact/upgrade 数值走 ledger（S1 模式）时机成熟后按序推进。

---

## 10. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；revision-02 #3/#4；PRECHARTER-01..11；cr-001 Option A (R09)；DC-ARCH-01 A1 / DC-PLAT-01 P1 / DC-PLAT-02 Option 2 / DC-PERF-01 Option A / DC-ACC-01 A2 / DC-ACC-02 B3 / DC-REL-01 O2 / DC-PLAY-01 Option 2 / DC-ANCH-01 Option 1（R01–R10）；ADR-TECH-01..06 批准（R11）；UX-03 S1–S3；R12 owner 任命；AUTH-01（R13 实现授权，契约内）。本建议不重写、不重分类任何一项。
- **`team_proposal`（本建议的实质贡献）:** 候选 A 推荐（真实输入驱动移动 + S5 全字段落地 + 吸收 O4/O5）；候选 B 列为其后玩法深度单元；候选 C defer（依赖 B2/focus）；候选 D 不独立成立；O6 归 evidence-harness 后续；角色分工与验收路径。全部为**排程建议**，供父协调器决策；不升级任何契约/数值。
- **`assumption`:** ① 真实输入驱动移动可在已批准 adapter 契约内实现且可被独立 QA 观察（需 QA 制定 input 注入/有界演示观察协议，未制定前为待验证）；② read-model 全字段落地不触发任何升级（判断依据：字段集已在 S5 提案 + ADR-TECH-02 已批准 read-model 契约边界内，未写入 Gate 判据/发布承诺/发布文案；若实施中字段呈现升级为 Gate/发布承诺 → D2 升级）；③ 接触/升级/B2 与真实移动可分离且移动是接触体验前置（Systems §6.2/切片交接支持）。均需对应角色/QA 审理确认，未在此代决。
- **`unresolved`（全量保留，未关闭）:** 本建议不关闭任何 unresolved 项——接触/升级/B2/终结/focus 精确语义（cr-006..020）、life 数值语义、spawn 节奏、走廊恢复可读反馈形态、hint 文案/触发、no_target_cue 精确表现、O6 evidence-harness/外层 envelope/raw 留存契约、fixture_schema_version、决策键 trace 元组导出形态（O5，吸收后仍为工程精化，不升格为 Gate 判据）等全部维持原状。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本建议未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升；未批准/冻结任何契约/规则语义/数值。

---

## 11. 边界声明与 Closure

- **未替用户做产品/验收裁决**：本文件是**排程建议**；最终产品裁决与验收归属 User 与 Independent QA。
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。
- **未触碰 Godot / 运行时 / 数值 / 契约**：未访问/修改 Godot、代码、场景、资源；未运行/构建/测试；未批准/冻结任何 ADR/Systems 终裁/fixture schema/数值；候选预算不提升；QA 不豁免；未替任何角色代权（Systems/UX/Tech/QA 语义均未代决）。
- **写入面**：仅本唯一排程建议文件 `NEXT_IMPL_UNIT_PLAN_v0_2.md`；未修改任何其它文档。

**Closure:** `closure_ready = yes`（仅限本排程建议 artifact）。本建议非实现派发、非契约批准、非 QA 验收、非产品裁决；父协调器据本建议决策是否/如何派发下一实现单元。

---

## 12. 版本与变更记录

- **v0.2（本文件）:** Executive Producer / Lead Producer 唯一新产物——承接垂直切片验收通过（QA verdict `pass` + O4/O5/O6）后的下一实现单元排程建议。盘点现状（引擎/语义/UX 三侧已存在 vs 缺失 M1–M6）；提出候选 A（read-model 落地 + 输入驱动真实移动）/ B（接触伤害）/ C（升级路径）/ D（纯精化）四项 + 组合；推荐 **A（吸收 O4/O5）**，argue 依据 slice 推进纪律、依赖真相（C 依赖 B2/focus 强前置判 defer）、R13 授权范围；AUTH-01 升级判定 **A 非升级（D1）**、B 数值写死即 D2、C 升级面 + defer；角色分工（Engineer + QA 关键，UX 单发）、验收路径（Gate 3 前段重点 + Gate 2 扩展）、范围边界与备选（A′/B/C/D）。未修改任何其它文档。