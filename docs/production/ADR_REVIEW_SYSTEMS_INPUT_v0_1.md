# ADR REVIEW — SYSTEMS/RULES CROSS-ROLE INPUT v0.1

> **Status:** `REVIEW INPUT / TEAM_PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`。
>
> **Artifact:** Systems/Rules Designer 依 A1（DC-ARCH-01 → Option A1，`CHANGE_REQUESTS §8.1 R02`）授权「draft → 跨角色评审 → 依评审结果逐条进入批准流程」中的**跨角色评审输入**（draft_in_review 的评审意见）。
>
> **Author role:** Systems and Rules Designer（godot-systems-rules-expert）。
>
> **Review object:** `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` 之 **ADR-TECH-01 / 02 / 03 / 04 / 05** 草案（规则语义视角）。
>
> **本文件是什么:** Systems 对 ADR-TECH-01..05 草案的**规则语义正确性/完备性/越权检查 + 意见 + 阻断项**。它不是批准、不是冻结、不是验收 verdict；它不修改任何 ADR 正文。

---

## 0. 声明与边界

### 0.1 本评审输入的性质

- A1（`DC-ARCH-01 → Option A1`，R02）授权各 ADR 走 draft → 跨角色评审 → 逐条批准。本文件是 Systems 一方的**评审输入**：给 Tech Lead（ADR 作者）、与父协调器/UX/QA 提供 Systems 视角的可修订意见。
- **本文件不批准任何 ADR（批准归用户 / 架构风险穿越），不修改任何 ADR 文件正文**（`KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` 一律未触碰）。
- **本文件不豁免 QA blocker、不替 Independent QA 下 verdict、不替用户做产品/架构/阈值裁决。**

### 0.2 评审基准与被评审对象

- **评审基准（Systems 合同）：** `docs/creative/KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md`（`PROPOSAL / DRAFT / NOT APPROVED`）。
- **已决决策（决策级引用）：** 22 项原始 `user_confirmed`；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；unresolved 全量保留。
- **cr-001（R09，DC-SYS-01 → Option A，`user_confirmed（决策引用）`）:** 键序 = 最近威胁 → 簇中心距离 → 稳定排序/稳定 ID；exact cluster membership / metric / quantization / tie-break / stable-ID 生命周期 / 失效·时点保持 `unresolved`，移交 cr-002..005。
- **提案在库（供语义核对）:** `docs/production/PROPOSALS_CR002_004_005_v0_1.md`（cr-002 → M-1 距离度量；cr-004 → 命名 drain 点 + 二选一语义 (i) 推荐；cr-005 → quiet cycle no-target 形态）。
- **候选预算:** 六项性能候选 + `1280×720` 红线仍仅候选；本评审不涉及、不提升。

### 0.3 证据边界

- **Evidence class:** `static/source` only。本评审只读前述静态文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；无任何 runtime/视觉/性能/QA 证据；未派发任何成员（未调用 `subagent`/`subagent_fork`/`workflow`/嵌套派发）。

---

## 1. Expert preflight（按 godot-systems-rules-expert）

- **Mission outcome:** 对 ADR-TECH-01..05 逐条给 `align` / `revise-needed` / `block` + 依据；给出具体到小节的修订意见与阻断项。
- **Player promise / slice（评审背后的承诺约束）:** 低认知清屏控制 + 因果可读 `movement → pre-fire target consequence → readable hit/contact → space recovery → stronger B2 → victory/defeat → reset`；slice 一人一敌族一自动攻击族一同源 B2 一工业屏，八分钟一局。
- **Top semantic risks being checked:**
  1. ADR 是否把「提案/假设」当成已批准语义（越权 ③）。
  2. ADR-TECH-04 是否把 cr-001 键序 + cr-002(M-1) 一致落地、unresolved 如实保留。
  3. ADR-TECH-05 的 contact/upgrade/terminal 语义是否与 Systems 合同一致、有无 Systems 语义被 Tech 代定。
  4. 各 ADR 的 Systems 依赖标记（in_flight / missing / assumption source）是否诚实、是否越权去代定 Systems 语义。
- **Decision boundary:** 只出评审意见；不批准、不改 ADR、不豁免 QA、不下 verdict、不裁决产品/架构。
- **Stop condition:** 若发现 ADR 改变 promise/immutable/platform/threshold/release → 标注意升路径；本文件依 A1 停在评审输入层。

---

## 2. 逐 ADR 评审结论

### 2.1 ADR-TECH-01 — Candidate rules/session/adapter/presentation boundary

**规则语义视角核对:**

- 正确性：草案把「Rules core 拥有 target snapshot interpretation、contact legality、upgrade eligibility、terminal arbitration **once Systems/Rules meanings are specified**」——与 Systems 合同 §3.2/§12 的职责边界一致（Systems 定义规则含义/状态语义/机制/progression/failure；Tech 以 seam 承接，不代定规则语义）。未与任何已决决策冲突。
- 完备性：Systems 面（规则含义、状态转移、奖励/失败/恢复）未被 ADR 正文自身展开——这是**正确分工**（Systems 语义另由 Systems 合同 + cr 提案给出），不是缺漏。
- 越权检查：无。草案明确标注「一旦 Systems/Rules 含义被指定」「Tech 不代理 Systems 语义」（§4 评审状态段系统依赖 in_flight + 无 Systems 提案在我读集内 → assumption source）。
- **结论：`align`（规则语义视角），无阻断项。**
- 意见（非阻断，供收束）:
  - 虽为 align，但 ADR-TECH-01 的 draft 依赖 = 「Systems/Rules 定义规则含义」属 `in_flight`。本评审输入本身即 Systems 规则的**可评审输入载体**之一；建议父协调器把本文件标为 Systems 规则语义输入的「评审证据引用」，以便 ADR-TECH-01 的 Systems 依赖从 `in_flight` 逐项核销。

### 2.2 ADR-TECH-02 — Purity, lifecycle ownership, presentation read model

**规则语义视角核对:**

- 正确性：'Rules purity'（不进墙钟/设备/场景树/UI 控件/全局可变随机）与 Systems 合同 §3.1 状态语义（entry/combat/no-target/target snapshot/contact invur/upgrade-pause/card choice/focus-loss/resume/victory/defeat/result/reset）不冲突；'presentation read model' 只载 player-facing 字段，不成为第二规则引擎，未与已决决策冲突。
- 完备性：read-model 字段（life/timer/B2 phase/hint/cards/focus/result/player-danger-space cues）与 Systems §9.1 HUD 观察层级（life/timer/B2 恒显，XP 从属）一致；'exact read-model fields are Systems/UX co-owned' 的分工正确。
- 越权检查：草案把「session lifecycle = 唯一 owner of start/active/paused/result/reset」定为 Tech/Session 机制层；Systems §3.1 的 section 状态语义（victory/defeat/result/reset）是**含义**层，机制 owner 归 Session 不 conflict。无越权。
- **结论：`align`，无阻断项。**
- 意见（非阻断）:
  - read-model 的 'paused' 状态含 upgrade-pause 与 focus-loss-pause 两种 pause（Systems §3.1 `upgrade pause` 与 `focus-loss` 是不同语义）。建议 ADR-TECH-02 或相关契约在 read-model 捕获顺序里把两者**分别命名**，否则 QA 的 pause 场景类型可能混并为一种。

### 2.3 ADR-TECH-03 — Determinism, reproducibility, trace scope

**规则语义视角核对:**

- 正确性：草案保留「fixed tick, seed, snapshots, constrained light randomness 仅 QA/debug 复现」+「无 player-visible Replay 承诺」——与 revision-02 #3、cr-203（Replay explicit absent）、Systems §3.2（tick 频率/tick 语义 unresolved）一致。与已决决策无冲突。
- 完备性：B2 多弧中间步排序（Systems §8.2 弧序 unresolved）被标注为「mechanism open choice, co-owned with Systems」（§7 评审状态，DC_SYS_01_TECH_INPUT §2.5 引述）——Systems 合同 §8.2 声明 B2 弧序 unresolved，本 ADR 如实保留、未代决。Sysm run 不涉 priority。OK。
- 越权检查：'Snapshot storage/cadence'、'trace verbosity' 明显是 Tech 机制面；Systems 语义（fixture/trace 需含哪些规则事实）由 Systems §5.3/§11 提供，本 ADR 未把提案当批准。无越权。
- **结论：`align`，无阻断项。**
- 意见（非阻断）:
  - 草案引「reproducibility equality（config_version + seed + versioned input + build identity ⇒ elementwise-same order/snapshot/events）作 feasibility 输入」。Systems 语义建议：此 equality 只是**复现目标声明**，不是已发生事实；请确保后续授权实现后的 fixture 才去验证，ADR 正文保持「未测量/未验证」姿态。

### 2.4 ADR-TECH-04 — Target snapshot contract

**规则语义视角核对（本次重点）：**

- **cr-001 键序落地 → 一致。** 草案 §7「Required high-level semantics」写入排序键序 = `最近威胁 → 簇中心距离 → 稳定排序/稳定 ID`，与 R09（DC-SYS-01 → Option A）一致；快照锁定后不连续重定位、空刷新走显式 no-target 分支、移除/失效目标不得作有效命中、per-arc 独立计数——均与 Systems §5.1/§8.1、决策 #3、revision-02 #4、PRECHARTER-02 一致。
- **cr-002 M-1 提案 → 需「一致落地」核对点（见 §3 阻断项 A）。**
  - ADR 正文与 cr-002 的语义接口：cr-002 推荐 **M-1 = 离散键链（两个量化标量键 k1/k2 + stable_id 决序）**，并把「两级量化桶宽窄」明确为**规则参数走 ledger、非常数**。ADR-TECH-04 §7 的 candidate fields（ordering keys / chosen-locked IDs）未与 M-1 冲突，但**正文未显式「选用 M-1」或保留为候选**。
  - cr-002 是 `absorb_within_authority` 提案，**仍 `unresolved` 直到证据 + 评审**；故 ADR-TECH-04 当前**正确姿态 = 把键序语义记作已决、把 metric/quantization 记作仍 unresolved/candidate**，不得把 cr-002 当成已批准语义写入正文正文。
- **unresolved 保留 → 基本如实。** 草案 §7「Unresolved detail register」保留 cluster definition / distance metric+quantization / tie-break fields / stable-ID lifecycle / invalidation timing / target removal during shot / no-target cycle timing / fire-refresh timing / arc geometry / duplicate-hit / shared target / attenuation+hit budget / 诊断暴露程度——与 Systems §3.2/§5.1 未决清单一致。
- **越权检查：`assumption source` 诚实标记。** 草案 §7 评审状态明确「PROPOSALS_CR002_004_005_v0_1.md 未在我（Tech）读集（file absent 2026-08-16）→ Systems 语义 = assumption / parent-coordinated in-flight，Tech 不 proxy Systems 语义」。**该判断在 Tech 起草时点成立**；但**本任务中该提案已在库**——见 §3 阻断项 A。
- **结论：`revise-needed`（非 block，单点收束依赖提案核对）。**
- 意见（到小节）:
  1. **§7「评审状态与跨角色依赖」（line ~222）**：`PROPOSALS_CR002_004_005_v0_1.md` 已在本任务库（`docs/production/PROPOSALS_CR002_004_005_v0_1.md`，v0.1）。建议把该行的「file absent 2026-08-16 → assumption source」更新为「Systems proposal artifact available → in_flight（待 Rules 语义评审确认）+ 本评审输入为 Systems 语义核对载体」，去掉「absent」前提（否则后续评审会把已到库的提案继续误标为缺失）。**这是评审意见，不改 ADR 正文**——由 Tech Lead 依此更新 ADR-TECH-04 的依赖标记。
  2. **§7「Required high-level semantics」（line ~204）**：语义已与 cr-001 一致；建议在后续 Tech 修订时把「metric/quantization 从 Systems 合同经 cr-002/004/005 收敛」作为语义来源显式引用（当前仅隐式引用 PRECHARTER/cr-001）。

### 2.5 ADR-TECH-05 — Contact/re-arm, upgrade transaction, focus epoch, terminal arbitration/reset

**规则语义视角核对:**

- 正确性：'one legal contact → one damage → brief invul → slight separation → re-arm after separation' 与 Systems §6.1、决策 #4、PRECHARTER-03 一致；'upgrade transaction 穿透→扇裂、三同关键词、no skip/reroll' 与 Systems §7.1、决策 #7/#8、PRECHARTER-05 一致；'同 tick 生命耗尽优先于八分钟胜利' 与 PRECHARTER-11 一致。无冲突。
- 完备性：焦点（focus-loss starvation → fresh input → reject stale Enter/Space）与 PRECHARTER-09 一致；'sticky contact / stale confirm / nondeterministic reset' stop conditions 与 Systems §6.2/§7.2 边界一致。
- 越权检查：focus-epoch 被标注为「机制提案（Tech），非冻结实现契约」；contact/upgrade/reset 语义被标注为 `in_flight` / `missing`（parent-coordinated）——Tech 未代定 Systems 规则含义。无越权。
- 阻断项检查：**与 cr-002/004/005 的边界**——cr-002/004/005 只覆盖 TARGET 语义（metric/失效/no-target），**不触及 contact/upgrade/reset 语义**；cr-006..020（contact 时长/分离/B2 等）仍 `unresolved`，本 ADR 如实保留。无阻断。
- **结论：`align`（规则语义视角），无阻断项。**
- 意见（非阻断）:
  1. 草案 focus-loss epoch 与 Systems §7.2「focus validity before confirmation / buffered stale input 拒绝」语义对齐；建议后续 Tech 修订把「epoch 起点/终点与 upgrade-pause 边界」与 Systems §3.1 `upgrade pause` 语义显式勾连，避免 focus 与 pause 两种输入场景混并。
  2. 'candidate order ... evaluate legal events → arbitrate terminal → result lock → auto reset'（同 tick 仲裁）与 Systems §4 步骤 4–6 一致；建议保留「life 优先」已决语义并继续把 intra-tick 排序留 unresolved（当前正确）。

---

## 3. 阻断项与收束建议（Systems 视角）

### 阻断项列表（当前是否「不可进入批准」）

| ADR | 阻断项 | Systems 判定 |
|---|---|---|
| TECH-01 | 无 | 非阻断 |
| TECH-02 | 无 | 非阻断 |
| TECH-03 | 无 | 非阻断 |
| TECH-04 | **单点收束依赖**（见阻断 A） | `revise-needed`（A1 路径内收敛，非全局 block） |
| TECH-05 | 无 | 非阻断 |

### 阻断 A（ADR-TECH-04 单点）— 提案在库状态未反映 + cr-002 M-1 是否「一致落地」未显式挂钩

- **现状冲突:** ADR-TECH-04 §7 评审状态声明 `PROPOSALS_CR002_004_005_v0_1.md` file absent（2026-08-16）→ Systems 语义标记 assumption source。**该文件在本任务已实际存在**（`docs/production/PROPOSALS_CR002_004_005_v0_1.md` v0.1），且 cr-002 推荐 **M-1 离散键链双标量距离**、cr-004 推荐**命名 drain 点 + 二选一语义 (i) 快照完全权威**、cr-005 推荐 **quiet cycle no-target 形态**。
- **为什么这构成 Tech ADR 的修订项而非本评审 block 全部:** 本文件是 Systems 对 ADR-TECH-01..05 的**评审输入**，其中 ADR-TECH-04 的 draft 依赖 = Systems 提案。既然提案已到库，ADR-TECH-04 的「缺失」标记应更新为「在库、in_flight、待本评审确认」；否则批准路径上会把已存在的提议继续当作缺失，导致语义段在错误前提上评审。
- **Systems 语义建议（供 Tech 修订时采用，不是本文件批准）:**
  - 键序：已由 cr-001（R09）`user_confirmed`，ADR-TECH-04 正文正确——不动。
  - **M-1（cr-002）:** Systems 推荐在 ADR-TECH-04 语义段把「量化后的两级距离桶 + stable_id 决序」记录为**从 cr-002 收敛的候选语义**（metric/quantization 数值仍走 ledger，`unresolved`）。桶宽为规则参数、非性能预算——若未来写入 Gate/发布判据 → 升级路径。
  - **失效语义（cr-004）:** Systems 推荐 (i) 快照完全权威——解析只读锁定快照、失效下一 shot 生效、全 run 唯一 + trace `resolution_outcome`。(i) 与 decision #3 / revision-02 #4「lock that shot's target snapshot」字面一致。是否采用归 Tech 机制 + 证据 + 评审，本文件不代决。
  - **no-target（cr-005）:** Systems 推荐 quiet cycle（周期照常、无伪命中反馈、可选非色彩一次性提示）+ 反馈类与 hit_results 因果绑定；触及产品承诺时升级 `needs_user_decision`。
- **Systems 层结论:** ADR-TECH-04 的**语义正文不冲突**、键序一致、unresolved 保留属实 → 非 block 全 ADR；但**「提案在库状态」与「M-1 落地挂钩」两点需 Tech 修订**，故 `revise-needed`。批准仍归 A1 阶梯后续步骤（用户/架构）。

### 收束建议（给父协调器 / 后续评审顺序）

1. **Provenance / in-flight 修正优先:** 先让 Tech Lead 依本评审输入更新 ADR-TECH-04 的「Systems proposal absent」标记为「在库、待规则语义确认」，再走 TECH-04 逐条批准；否则该 ADR 会在缺失假设上被评审。
2. **cr-002/004/005 仍是 `unresolved`:** 本评审输入只把它标为「候选语义可挂钩」，不批准；需授权实现后的 TARGET-* fixture + seed 复现 + QA Gate 2 独立观察才收敛（Gate 2 `not_run / not_ready`）。
3. **不变量确认:** 本评审输入未新增/改写任何 `user_confirmed`、未改变 22 / 8+1 / PRECHARTER-01..11 / 四层 provenance / unresolved 全量；候选预算（六项 + `1280×720` 红线）保持仅候选。

---

## 4. 本评审输入自身的不变量与 provenance 分层

- **`user_confirmed`（仅引用，不新增）:** 22 项；revision-02 #3/#4/#6/#7；PRECHARTER-02/03/05/09/11；cr-001（R09 决策引用）；DC-ARCH-01 → A1（R02）；DC-PERF-01 → A（R04）；DC-ACC-02 → B3（R06）；DC-PLAY-01 → 2（R08）。本文件未重写、未重分类任何一项。
- **`team_proposal`（本文件全部实质意见）:** ADR-TECH-01/02/03/04/05 的逐条评审结轮 + 修订意见 + 阻断 A 的建议；cr-002(M-1)/cr-004(i)/cr-005(quiet cycle) 的「可挂钩语义」表述。均需 Tech/UX/QA 评审 + 证据 + 用户授权后才可推进。
- **`assumption`:** 上述 TARGET-* fixture 与 Gate 2 观察可验证确定性/可读性；未观察前不成立。
- **`unresolved`（本文件未关闭任何一项）:** cluster membership / metric 数值与单位 / quantization 桶宽 / tie-break 可读性语义 / stable-ID 生命周期 / invalidation 精确时机与 drain 实现 / no-target 精确周期 / B2 弧序 / tick 频率 / contact 时长·分离·堆叠·边界 / upgrade 数值与卡池 / focus 与 pause 边界语义 —— 全部保持 `unresolved`。
- **候选预算:** 六项 + `1280×720` 红线未被本文件提升。
- **不变量保留声明:** 22 / 恰好 8 + 独立 Charter authorization（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量——本文件未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`。

---

## 5. 边界声明与 Closure

- **未批准任何 ADR:** ADR-TECH-01..05 保持 `PROPOSAL / DRAFT / NOT APPROVED`；本文件是评审输入，不是批准/冻结/验收。
- **未修改任何 ADR 文件:** `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` 及其它既定文档一律未触碰；本文件为本任务**唯一新写文件**。
- **未豁免 QA blocker / 未替 Independent QA 下 verdict:** Gate 2 等仍 `not_run / not_ready`。
- **未触碰 Godot / 运行时:** 未访问/修改 Godot、代码、场景、资源；未运行、构建、测试、导出、发布；无 runtime/视觉/性能/QA 证据。
- **未派发任何成员:** 未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。
- **写入面:** 仅新增 `docs/production/ADR_REVIEW_SYSTEMS_INPUT_v0_1.md`，未修改任何既有文档。

**Closure:** `closure_ready = yes`（仅限本静态评审输入 artifact）。不是 kickoff pass、不是实现授权、不是合同/ADR 批准、不是验收 verdict。Kickoff 仍 `not_ready`；implementation 仍 `NOT_AUTHORIZED`；Gate 2–6 仍 `not_run / not_ready`。

---

## 6. 版本与变更记录

- **v0.1（本文件）:** Systems / Rules Designer 唯一新产物；ADR-TECH-01..05 逐条评审（align/revise-needed/block）+ §3 阻断项 A + 收束建议；未修改任何其它文档。
