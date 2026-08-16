# ADR REVIEW — UX/UI INPUT v0.1（ADR-TECH-01 / 02 / 05 跨角色评审输入）

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`。
>
> **Artifact type:** UX/UI Designer 的**跨角色评审输入**（唯一新产物）。依 **A1（DC-ARCH-01 → Option A1，cr-201，R02，已决）** 的「draft → 跨角色评审 → 依评审结果逐条进入批准流程」阶梯，本文件为 ADR-TECH-01/02/05 提供 **UX 评审输入（交互 / read-model / 可读性视角）**。
>
> **关键边界：** 本文件是**评审输入**，**不批准任何 ADR**；**不修改任何 ADR 文件正文**（ADR 均保持 `PROPOSAL / DRAFT / NOT APPROVED`）。评审意见单独成文，供 Tech Lead 采纳修订后逐条走批准流程。
>
> **Evidence class:** `static/source` only。本文件不包含 runtime / visual QA / usability / accessibility / performance / export / release 证据，也不声称任何此类证据。

---

## 0. 专家能力加载与实际工具顺序（真实记录）

- **角色专家 Skill:** `godot-ux-ui-expert`，解析路径 `C:\Users\User\.agents\skills\godot-ux-ui-expert\SKILL.md`。
- **加载等级:** `strong_direct_skill` —— 首选实证：本会话**实际调用 `skill({ name: "godot-ux-ui-expert" })` 成功**，运行时返回完整 SKILL 指令内容（非仅凭函数清单判断、非伪报不可用）。按 DSH 实测纪律（2026-08-16），skill/tools.skill 均可能「未列入 schema 但实际可调用」，故以实际调用验证；本会话 `skill` 接口**实测成功**，接口失败不存在，未降级。
- **实际工具顺序:** ① `read(SKILL.md)`（能力预读）→ ② `skill({ name: "godot-ux-ui-expert" })`（**strong_direct_skill，成功**）→ ③ 并行 read `UX_OBSERVATION_TARGETS_CR001_v0_1.md` / `CHANGE_REQUESTS_v0_1.md` → ④ read `CHANGE_REQUESTS_v0_1.md` 续段（§8.1 R02 / §8.3 R06、R08 / §8.4 R09）→ ⑤ read `KICKOFF_UX_UI_CONTRACTS_v0_1.md` → ⑥ read `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（ADR-TECH-01/02/04/05 全文 + §18 dossier）→ ⑦ read `DC_SYS_01_UX_INPUT_v0_1.md`（UX-INPUT 基线，可选）→ ⑧ write（本评审输入文件）→ ⑨ read 回读核验本文件。
- **本任务未调用** `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

## 1. 专家 preflight（godot-ux-ui-expert，应用于本评审）

- **目标玩家/上下文:** PC-first 单人玩家进入 8 分钟有界 Slice；本评审聚焦 ADR 中与「presentation/read-model / focus epoch / 交互契约」相交的玩家可读性、observability 与状态可见性。
- **关键理解风险:** presentation 是否被允许/必读 stable 序与 no-target 分支（否则 hint 承诺的因果不成立、no-target 非误导不可观察）；focus epoch 机制是否满足「冻结/保留/新鲜输入/拒陈旧」四要素（PRECHARTER-09 / 决策 #17）；read model 是否漏掉 accessibility / no-target / feedback-binding 状态。
- **目标窗口/输入条件:** 16:9 基线 + {16:9, 16:10, 21:9} 方向性支持承诺候选（DC-PLAT-02 Option 2 / R03）；键盘 WASD/方向键；`1280×720` 红线**仅候选**。
- **范围内状态:** combat / no-target / upgrade pause / focus loss / resume / result-restart（UX 合同 §3 矩阵对应行）+ 对应 read-model 字段与 focus-epoch 语义。
- **证据路线:** 静态核对已决决策（22 项 #15–19、B3/R06、R08、R09）与 UX 合同、UX-OBSERVATION-TARGETS、UX-INPUT、CR 台账；不执行 runtime/视觉观察。
- **所有权边界（不代权）:** UX/UI 提供评审意见与阻断项；**不批准 ADR**、**不替 Systems 定规则语义**、**不替 Tech 定机制**、**不替 QA 下 verdict**、**不替用户裁决**；ADR 批准由 A1 阶梯其后单独完成。
- **停止条件:** 止于本静态评审输入。未访问/修改 Godot、代码、场景、资源；未运行、构建、测试、导出、发布；未批准或冻结任何 ADR/合同；未豁免 QA blocker。

## 2. 评审基准与已决决策锚（仅引用，不重投）

本评审以以下**已决锚**核 ADR 语义一致性，不修改、不重分类任何一项：

- **22 项原始 `user_confirmed` 决策**：**#15–16（causal hint）**、**#17（focus loss 安全 / 拒绝陈旧确认）**、**#18（16:9 基线 + 可读红线）**、**#19（基本可访问性基线）**（另涉 #3 pre-fire 刷新+锁定等）。
- **B3（DC-ACC-02 → Option B3，cr-114，R06，`user_confirmed（决策引用）`）：** Gate 3 证据收紧 = 严格完整性规则；静态/Anchor 不可替代 runtime/视觉证据；retest 保留原失败；read-model 字段须可追溯到权威线上。
- **R08（DC-PLAY-01 → Option 2，cr-202，`user_confirmed（决策引用）`）：** 可玩性门判据结构先行、阻断权延后经 CR + 用户批准激活。
- **R09（DC-SYS-01 → Option A，cr-001，`user_confirmed（决策引用）`）：** pre-fire refresh nearest-threat cluster → stable-sort → lock snapshot；键序 = 最近威胁 → 簇中心距离 → 稳定排序/稳定 ID；exact 细节仍 `unresolved` 移交 cr-002..005。
- **R02（DC-ARCH-01 → Option A1，cr-201，`user_confirmed（决策引用）`）：** ADR-TECH-01..08 定稿路径已授权；ADR 保持 `PROPOSAL / DRAFT / NOT APPROVED`。

## 3. 评审结论总表

| ADR | UX 评审结论 | 关键依据 | 阻断进入批准？（UX 视角） |
|---|---|---|---|
| **ADR-TECH-01** 边界 / presentation / read-model 语义 | `align`（附少量 revise 提示） | 边界正确：presentation 只消费 read model + interaction intent，不 mutate 规则；`UI-owned gameplay state` 仍被拒绝；与 UX 合同 §11 依赖一致 | 否（本 ADR 无 UX 阻断项） |
| **ADR-TECH-02** purity / lifecycle / read model | `revise-needed`（实质） | read model 字段清单漏 **no-target / attack-resolution / feedback-binding** 与 **accessibility-relevant 状态**；B3「字段须可追溯权威」下 UX-03 S1/S2 与 UX 合同 §7 无法由当前 read model 满足 | **是（弱阻断，修订后可解除）**：字段覆盖不足 → 无 UX 权威线可追溯 → B3 完整性不成立 |
| **ADR-TECH-05** focus epoch / 升级事务 / 终局仲裁（交互契约部分） | `align`（附一致性提示） | focus-epoch 机制与 UX 合同 §4 + PRECHARTER-09 + 决策 #17 一致（冻结/保留/拒陈旧/新鲜 epoch）；升级事务与 UX 合同 §5.1 一致；终局仲裁与 PRECHARTER-11 一致 | 否（UX/epoch 部分无阻断；Systems 契约缺失为跨角色依赖，不属 UX 阻断权） |

> **评审权限边界重申：** 上表「阻断进入批准」仅表示**本 ADR 在通过 A1 阶梯逐条批准前，UX 视角下尚需修订/依赖满足的条件**；最终批准由 A1 阶梯其后的正式评审流程执行，UX/UI 不批准任何 ADR。

## 4. ADR-TECH-01 评审（boundary / presentation / read-model 语义）

### 4.1 正确性（与已决决策及 UX 合同一致性）

- **一致：** §「Candidate decision」第 4 项 —— presentation 消费 read model + explicit interaction intents（HUD/hint/cards/result/focus/feedback），明确「cannot become a second rules implementation」。这与 UX 合同 §11 依赖（Tech 作者实施 contract/ADR；UX owns 玩家面向 contract）及「presentation 不 mutate 规则」一致。反提案「UI-owned gameplay state：rejected because presentation would become authoritative and focus/presentation changes could alter rules」与 UX 合同 §4.6/§11 的可见性/失焦安全边界一致。
- **一致：** 依赖方向 inward（adapter/presentation → session → rules core；rules core engine-free / UI-free / skill-free）不改变任何玩家可见语义，不越权 product/UX/Systems 边界。

### 4.2 完备性（UX 职责面表述）

- **覆盖面：** 明确列出 read model 消费者的功能面（HUD、hint、cards、result、focus、feedback）。**缺漏提示（revise 建议，非阻断）：**
  1. 未显式点名 **accessibility / non-color / disabled-frozen 状态** 作为 read-model 需要支撑的面——UX 合同 §7 的非颜色通信、焦点可见、frozen/disabled 状态需要 read-model 提供可呈现信号；建议 ADR-TECH-01 presentation 责任项补一句「含 accessibility 状态（non-color/frozen/disabled）的派生」。
  2. 未显式点名 **no-target 分支的可观察信号**（不应产生伪造锁定/伪造命中的状态）——建议在 feedback/focus 项后补「no-target 分支与 feedback 绑定」的表述，与 UX-03 S1/S2 对齐。

### 4.3 边界（越权检查）

- **无越权：** 本 ADR 明确「does not approve the boundary」「User must decide any alternative crossing boundary」，无把提案当批准的表述。presentation 未成为第二规则权威。**通过**。

### 4.4 意见（修订点 + 建议）

1. 在 presentation 责任描述中显式增补 accessibility 面与 no-target/feedback-binding 面（建议行文见 4.2）。
2. 建议在「评审状态与跨角色依赖」中把 UX/UI 依赖状态从 `in_flight / missing` 更新为「**由 ADR_REVIEW_UX_INPUT_v0_1.md 提供**」——本文件即为 presentation/read-model 需求的 UX 输入，解除「missing」。
3. 建议把「requires future evidence」中的 read-model 观察与 UX 合同 §9 UX-01..13 证据矩阵 ID 引用关联（可追溯性，符合 B3）。

## 5. ADR-TECH-02 评审（purity / lifecycle / read model）

### 5.1 正确性

- **一致：** rules purity（不读 wall-clock/device/scene-tree/UI 控件/全局随机）与 UX 合同 §4 失焦安全、§11 依赖一致——UI focus 不会改变规则。
- **一致：** Session 单一 owner（run start / active / paused / result / reset）与 UX 合同 §3 restart、§5.3 非法输入不泄漏入新局一致。
- **一致：** 「Feedback causality：domain events may be rendered as feedback, but presentation must not infer a new rule from visual state」——与 UX-03 S2（feedback 类必须绑 `hit_results`）方向一致。**但字段覆盖不足（见 5.2），此 clause 无法在当前字段集下被 UX 观察目标满足。**

### 5.2 完备性（read model 字段 vs UX-02/03 观察目标 + accessibility）——**实质 gap**

ADR-TECH-02 §「Presentation read model」字段清单 = `life, timer, B2 phase, hint visibility, upgrade cards/focus, result state, player/danger/space cues as later defined`。

对照 UX-02/03 观察目标（UX_OBSERVATION_TARGETS_CR001_v0_1 §3–§4）与 UX 合同 §7/§9：

| 缺失/未足字段 | 观察目标 / 合同要求 | 影响 |
|---|---|---|
| **no-target 分支 / attack-resolution 状态** | UX-03 S1（空 refresh 不产生锁指示/瞄准框）、S2（hit 反馈仅 `hit_results` 非空时 emit） | 若 read model 不暴露「本拍无目标/未命中/命中」，presentation 无法正确抑制或绑定反馈 → 伪造锁定/幽灵命中风险；B3 下无权威线可追溯 |
| **feedback-binding 记号（feedback class ↔ hit_results）** | UX-03 S2 / UX 合同 §3 no-target 行 / UX-INPUT §3.1 | 反馈类必须因果绑定命中结果；read model 需承载该绑定可观察信号 |
| **accessibility-relevant 状态**（frozen/disabled/non-color/焦点可见） | UX 合同 §7（非颜色通信、focus visibility、disabled/frozen）、决策 #19 | read model 目前隐含 focus 字段，但未含 disabled/frozen/non-color 派生状态；失焦冻结与恢复（§4）在 read model 上无对应可呈现字段 |
| **hint「有效移动」关联到 stable 序/候选变化** | UX-INPUT §5 / UX 合同 §6.3 / 决策 #15-16 | hint 教学「移动改变下一次 pre-fire 候选/排序」；read model 需承载「候选/排序变化」是否发生的可观察信号，否则 hint 因果可能未发生仍淡出（过度承诺） |

> **核心判断（B3 / R09 联动）：** R09 已确认键序 = 最近威胁 → 簇中心 → 稳定序，且 UX-02 G1–G3 要求该稳定序可观察/可审计。**稳定排序的优先级通常作为 trace 字段（ADR-TECH-03/04）而非展示型 read model 字段**——本评审认可这一划分，不要求把内部 stable-ordering 全量暴露给 presentation。**本 gap 专指** presentation 必须知道的「本拍结果类型 / feedback 绑定 / no-target / accessibility」状态，而非内部排序细节。

### 5.3 边界/阻断

- **阻断（弱，UX 视角）：** read model 字段覆盖不足 → 在 B3「read-model 字段须可追溯到已授权规则/read-model 契约」下，ADR-TECH-02 的 read model 无法作为 UX-03 S1/S2 与 UX 合同 §7 的呈现权威线。**修订方向**：在 read model 字段清单中加入 §5.2 四类状态（至少 no-target / attack-resolution / feedback-binding、accessibility frozen/disabled/non-color），并在「Stop condition」（required player-visible field cannot be traced）之后补一句「read model 须覆盖 UX-03 S1/S2 与 UX 合同 §7 所需状态」。修订后本阻断可解除。
- **无越权：** 未发现 presentation 成为第二规则权威的表述。

### 5.4 意见（修订点 + 建议）

1. read model 字段清单增补：`no-target_branch/attack-resolution 状态`、`feedback 绑定记号（feedback class ← hit_results）`、`accessibility 派生状态（frozen/disabled/non-color/焦点可见）`、`hint 有效移动-候选变化关联`。
2. 「Feedback causality」clause 后面补一句：presentation 的 no-target 与 hit 反馈**只在 hit_results 非空时 emit 命中类反馈、空拍不产生伪造反馈**（对齐 UX-03 S1/S2）。
3. 把 UX/UI 依赖状态从 `in_flight 字段未定`更新为「read model 字段清单 v0.1 已由 ADR_REVIEW_UX_INPUT_v0_1.md 提供，须在批准前合并」。
4. 与 ADR-TECH-04 trace 字段（candidate/ordered/target_snapshot）区分：read model 承载呈现面，trace 承载审计面；不要在 read model 强制全量暴露内部排序。

## 6. ADR-TECH-05 评审（focus epoch / 交互契约相关部分）

> 按任务要求，本评审聚焦 ADR-TECH-05 的 **focus epoch / 升级事务 / 交互契约** 部分（contact/reset 属 Systems/Tech 面，仅作一致性旁注）。

### 6.1 正确性（focus-loss epoch/buffer vs UX 合同 §4 + PRECHARTER-09 + 决策 #17）

- **一致：** 「On focus loss, immediately freeze combat and upgrade confirmation, preserve focus/selection, reject stale Enter/Space, and require a fresh explicit legal input after return」——与 UX 合同 §4.1–§4.4（combat focus loss 立即冻结 / upgrade focus loss 保留选择 / fresh input epoch / stale input rejection）、PRECHARTER-09（冻结/保留/新鲜输入/拒陈旧）、决策 #17 完全对齐。
- **一致：** 「increment epoch on loss and again at resume boundary, discard buffered confirmation events from prior epochs, accept only newly observed legal input」——为 UX 合同 §4.3「fresh input epoch」与 §4.4「stale rejection」提供了一个未冻结的机制 proposal，机制层由 Tech 掌握，UX 语义面被本评审视为符合。✓
- **一致性提示（revise 建议，非阻断）：** 机制为 candidate（`This is a mechanism proposal, not a frozen implementation contract`），与 UX 合同 §4.8「open implementation questions：focus event policy / pause scope / return-focus target / epoch representation / buffering-flushing semantics / platform behavior / resume messaging」一致保持 `unresolved`。建议在批准前把「combat freeze scope」「return-focus target」「平台事件政策」作为 UX 已 `unresolved` 项标注为 UX-06/07/08 观察目标的前置依赖（对齐 UX 合同 §9 与 cr-012/013）。

### 6.2 升级事务一致性与边界

- **一致：** transaction = guarantee trigger → full combat pause → valid stage-appropriate choice → selected/acquired feedback → combat resume；第一阶 `穿透`、第二阶 `扇裂`；三张同关键词变体；无 skip/reroll——与 UX 合同 §5.1 逐条一致。
- **边界检查：** ADR-TECH-05 明确「Product-visible timing or threshold decision remains User/System-owned」——未越权、未把提案当批准。**通过**。

### 6.3 完备性（UX 观察目标衔接）

- focus-epoch 语义可直接支撑 UX-06/07/08（失焦战斗冻结 / 失焦卡牌选择保留 / 新鲜 epoch + 拒陈旧）的观察目标定义（`not_run / not_ready`）。ADR-TECH-05 未在文本中点名 UX-06/07/08，建议在「评审状态」区补一句指向这些证据 ID，以符合 B3 可追溯性。

### 6.4 阻断（UX 视角）

- **UX/epoch 部分无阻断：** focus-epoch 与失焦安全（PRECHARTER-09）一致，不构成 UX 层面的进入批准阻断。
- **跨角色依赖警示（非 UX 阻断权）：** dossier §18.1 标记 ADR-TECH-05 的 **Systems 契约（contact/upgrade/reset 语义）absent（assumption source）**。contact 耐久/分离、upgrade trigger/XP、terminal 排序属 Systems/Rules 与 Tech 面，对 UX 的可恢复性（pillar：非惩罚节奏）、升级可读性（UX-04/05）、终局优先级（PRECHARTER-11）有联动；**该依赖缺失不豁免、不由 UX 代填**。进入批准前需 Systems 契约就位，此点按父协调器跨角色依赖处理，非 UX 阻断。

## 7. 特别核对

### 7.1 ADR-TECH-02 read-model ↔ UX-02/03 观察目标（U2-A..D / U3-A..D）衔接

- **衔接判断：`partial / 需补缺`。** UX-02 的可观察面（G1 稳定序 trace / G2 移动引发变化 / G3 感知威胁对应）主要靠 ADR-TECH-03/04 的 trace/快照字段（candidate_ids / ordered_ids / target_snapshot_ids / hit_results）承载，ADR-TECH-02 的 read model 是 presentation 输入面。**本文档认可该划分**，不做 read model 强制暴露内部排序。
- **但 UX-03 的 S1/S2（no-target / feedback 绑定）与 UX 合同 §7 accessibility 必须在 read model 上有对应呈现字段**——ADR-TECH-02 当前缺这些字段（§5.2）。因此「ADR-TECH-02 read-model 与 UX-02/03 衔接」结论 = **部分衔接、需补 read-model 字段后才能完整衔接**。

### 7.2 ADR-TECH-05 focus epoch ↔ 失焦安全（PRECHARTER-09）一致性

- **一致：通过。** focus-epoch mechanism proposal 完整覆盖 PRECHARTER-09 的冻结/保留/新鲜输入/拒陈旧四要素（§6.1）；不产生隐藏进度、不丢弃选择、不伪肯定陈旧 Enter/Space。UX 视角无阻断。

## 8. 评审输入交付（供 Tech Lead 采纳修订）

对 ADR-TECH-01/02/05 的建议修订统一汇总（供 A1 阶梯其后的正式批准流程参照；本文件不代改 ADR 正文）：

| # | ADR | 建议修订 | 优先级 |
|---|---|---|---|
| R1 | TECH-01 | presentation 责任增 accessibility 面与 no-target/feedback-binding 面表述 | 中 |
| R2 | TECH-01 | UX 依赖状态改「由本评审输入提供」，关联 UX 证据矩阵 ID（B3 可追溯） | 中 |
| R3 | TECH-02 | read model 字段增补 no-target/attack-resolution、feedback-binding、accessibility frozen/disabled/non-color、hint 有效移动关联 | **高（阻断修订）** |
| R4 | TECH-02 | 补「空拍不伪造命中反馈」clause；与 trace 面（ADR-TECH-03/04）区分呈现面/审计面 | 高 |
| R5 | TECH-02 | UX 依赖状态更新为「字段清单已由本评审输入提供，批准前须合并」 | 中 |
| R6 | TECH-05 | 批准前把 combat freeze scope / return-focus target / 平台事件政策标注为 UX-06/07/08 前置依赖（保持 unresolved） | 中 |
| R7 | TECH-05 | 「评审状态」区点名 UX-06/07/08 证据 ID（B3 可追溯） | 低 |

## 9. Provenance 分层与不变量保留

### 9.1 分层声明

- **`user_confirmed`（仅引用，不新增）：** 22 项原始决策（#3、#15–16、#17、#18、#19 等）；revision-02 相关；PRECHARTER-02/06/07/09/11；**R02（A1）**、**R06（B3）**、**R08（可玩性门分阶）**、**R09（cr-001 Option A）**、R03（DC-PLAT-02 Option 2，支持集/缩放/红线仅候选）；AUTH-01。本文件不重写、不重分类任何一项。
- **`team_proposal`（本文件实质建议）：** 本评审对 ADR-TECH-01/02/05 的全部意见（R1–R7）与 read model 字段补缺建议；均属 UX 跨角色评审输入，待 Tech Lead 采纳修订后逐条走 A1 批准流程，**未获批准**。
- **`assumption`：** 玩家可感知簇中心 / read model 字段补缺后能支撑 UX-03 S1/S2 等可读性期望，需未来观察验证；未观察前不得视为成立。
- **`unresolved`（全量保留）：** ADR-TECH-01/02/05 的 exact read-model 字段、layout/copy/threshold、focus-epoch 精确机制、combat freeze scope、return-focus target、平台事件政策、Systems 契约（contact/upgrade/reset）、hint 有效移动定义等——ADR 已有 `unresolved` 全部保留 open；沉默不解决。

### 9.2 不变量保留声明

**22 项 / exactly 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 / 候选预算（六项 + `1280×720` 红线仅候选）** —— 本文件未改动上述任何一项；未把任何 `team_proposal` / `assumption` / 候选数值升级为 `user_confirmed`。

### 9.3 显式边界声明

- **未批准任何 ADR：** ADR-TECH-01/02/05 保持 `PROPOSAL / DRAFT / NOT APPROVED`「draft_in_review」；批准由 A1 阶梯其后正式流程执行。
- **未修改任何 ADR 文件正文：** 已读取 `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（含 §18 dossier）但**未修改**；本文件仅新增唯一产物 `ADR_REVIEW_UX_INPUT_v0_1.md`。
- **未修改其它文档：** UX 合同、UX-OBSERVATION-TARGETS、CHANGE_REQUESTS、DC_SYS_01_UX_INPUT 均只读取未修改。
- **未代 Systems 定规则语义 / 未代 Tech 定机制 / 未替 Independent QA 下 verdict / 未豁免 QA blocker / 未替用户裁决。**
- **未触碰 Godot/运行时：** 未访问/修改 Godot、代码、场景、资源；未运行、构建、测试、导出、发布；无 runtime/视觉/性能/QA 证据。
- **未派发任何成员：** 未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

## 10. Closure status

- **Artifact status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`（UX 评审输入小节）。
- **Closure-ready:** `yes`（仅限本静态 UX 跨角色评审输入任务）；不是 kickoff pass、不是实现授权、不是 ADR 批准、不是验收 verdict。Kickoff 仍 `not_ready`；implementation 仍 `NOT_AUTHORIZED`；Gate 3 仍 `not_run / not_ready`。
- **Next handoff:** 父协调器将本评审输入转交 Tech Lead（ADR-TECH-01/02/05 作者）按 §8 R1–R7 采纳修订，经 A1 阶梯逐条进入批准流程；Systems 契约缺失（TECH-05/04 跨角色依赖）由父协调器协调补位。

## 11. 版本与变更记录

- **v0.1（本文件）：** UX/UI 唯一新产物——ADR-TECH-01/02/05 跨角色评审输入；逐 ADR 给 `align / revise-needed / align` 结论 + 修订建议 R1–R7 + 阻断项；特别核对 ADR-TECH-02 read-model ↔ UX-02/03、ADR-TECH-05 focus epoch ↔ PRECHARTER-09；未修改任何其它文档。
