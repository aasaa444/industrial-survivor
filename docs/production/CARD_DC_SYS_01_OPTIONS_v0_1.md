# CARD DC-SYS-01 — Target 语义原则 · 选项制备（Batch 3）

> **状态:** `PROPOSAL / DRAFT / NOT APPROVED`（选项制备产物，非决策、非合同批准、非实现授权）
>
> **生命周期:** `development governance / kickoff readiness preparation`
>
> **制备角色:** Systems / Rules Designer（主制备）；Tech Lead（机制/确定性字段输入）与 UX（可读性观察目标输入）由父协调器并行派发，本卡将其作为「依赖输入」引用（见 §9）。
>
> **证据类别:** `static/source` only。未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未批准任何合同或 ADR；未豁免 QA blocker；未替用户做最终决策。

---

## 1. Card ID / 待决项

| 字段 | 记录 |
|---|---|
| Card ID | `DC-SYS-01` |
| Linked cr_ids | **cr-001**（Target 语义原则——簇定义与排序原则） |
| 决策包归属 | Batch 3 — Rules core semantics（CHANGE_REQUESTS §7） |
| 当前状态 | `needs_user_decision`；cr-001 `unresolved` / `team_proposal`（exact cluster membership/metric 未决） |
| 选项制备角色 | Systems/Rules Designer（主）+ Tech Lead（机制/确定性字段输入）+ UX（可读性观察目标输入）（CR 台账 §7 Batch 3 行） |
| 建议决策窗口 | 不晚于最小确定性核心 seam 契约冻结；可与 Batch 1/2 并行制备（本卡已按此并行制备） |

### 1.1 待决项来源原始表述（引用原文，均属已确认事实或既有文档文本）

- **决策 #3（`user_confirmed`）**：「Refresh nearest-threat cluster before each shot; fix this shot's targets after firing.」（Charter §6 决策 3）
- **revision-02 #4（`user_confirmed`）**：「Before firing, refresh the nearest-threat cluster; stable-sort and lock that shot's target snapshot.」边界：「Exact cluster, distance, tie-break, ID lifecycle, and timing remain unresolved.」（Charter §2.1 决策包第 4 项）
- **PRECHARTER-02（`user_confirmed`）**：「attack in no-target case; otherwise nearest threat, cluster-center distance, then stable ordering/stable ID. Cluster definition, metric, tie-break fields, ID lifecycle and timing are unresolved.」（Charter §6 PRECHARTER-02）
- **cr-001 注册行（CHANGE_REQUESTS §3）**：「Target 语义原则（簇定义与排序原则）」——「refresh the nearest-threat cluster → stable-sort → lock that shot's target snapshot」(revision-02 #4)；「nearest threat, cluster-center distance, then stable ordering/stable ID」(PRECHARTER-02)；exact cluster membership/metric unresolved（ADR-TECH-04 unresolved detail register；Systems §5.1）。
- **ADR-TECH-04（`team_proposal`，A1 draft/review 路径中，未批准）**：required high-level semantics 与候选方向一致；unresolved detail register = cluster definition；distance metric and quantization；tie-break fields；stable-ID lifecycle；invalidation timing；target removal during a shot；exact no-target cycle timing；fire/refresh timing；arc geometry；duplicate-hit policy；shared target policy；attenuation and hit budget；whether diagnostics expose all candidates or only selected IDs。
- **Systems §5.1（`team_proposal`）**：pre-fire refresh → stable candidate ordering → select/lock target snapshot → 射击中不连续重定位 → 空集进 no-target 分支、绝不伪造目标 → 移除/失效目标不得参与后续结算。
- **no-target 边界（候选边界，非新事实）**：no-target 分支明确存在、禁止伪造目标（PRECHARTER-02；决策 #3）。
- **UX 观察目标（`team_proposal` / `unresolved`，行状态 `not_run / not_ready`）**：UX-02「Movement relates to next automatic attack and clearing」；UX-03「No-target branch is quiet and non-misleading」；§6.3 因果移动提示 = 未来理解观察目标（UX 合同 §9、§6.3、§3 no-target 行）。

---

## 2. 选项（4 个，精准、互斥）

> 四个选项在同一张卡上严格互斥：A 锁定既有三键序原则；B 取消「簇」抽象改用全局距离单调排序；C 保留簇但以中心距离加权重建键序；D 不选原则、整体推迟。用户在其中唯一选择（或推迟）。

### Option A — 确认候选方向「refresh 簇 → stable-sort → lock snapshot」

- **名称:** 确认候选方向——pre-fire refresh nearest-threat cluster → stable-sort → lock that shot's target snapshot；排序键序 = 最近威胁 → 簇中心距离 → 稳定排序/稳定 ID。
- **依据:** 三项 `user_confirmed` 记录同向收敛：决策 #3（pre-fire 刷新 + 锁定，方向已确认）；revision-02 #4（refresh 簇 → stable-sort → lock snapshot；exact 细节 unresolved）；PRECHARTER-02（nearest threat → cluster-center distance → stable ordering/stable ID；细节 unresolved）。ADR-TECH-04「Alternatives / consequences」（team_proposal）已记录 continuous retargeting 与 arbitrary list order 均不采用（削弱移动→下次射击因果可读性 / 非确定），与本方向一致。本选项仅在「语义原则」层确认既有方向，**不决定** exact cluster membership、metric、quantization、tie-break 字段、stable-ID 生命周期、失效/时点（保持 `unresolved`，移交 cr-002..005）。
- **影响:**
  - 产品: 固化「移动→下一次自动攻击」归因链（pillar 2「Active control while moving: movement preserves routes and affects the next automatic attack」；Slice intent「expose movement-to-next-attack causality」）——refresh 反映移动结果、lock 使结果可事后归因；不动摇 pillar 4 非惩罚节奏。
  - 创意: 与 Slice intent 与 UX-02 观察目标一致；无新创意承诺。
  - 技术: 为 ADR-TECH-04/06 提供可冻结的排序语义输入；锁定后不重定位 → 确定性排序基础（ADR-TECH-04: arbitrary list order 非确定、不采用）；exact metric/tie-break 留 cr-002、稳定 ID 留 cr-003。
  - 范围: 不新增内容/系统；在决策 #3 及 revision-02 #4 已确认边界内（无范围扩张）。
  - 进度: 解除 target fixture 系列（no-target/ties/removal）的定型前提（cr-001 注册行「被挤出：target fixture 系列无法定型直到原则选定」）；最小确定性核心 seam 契约可进入冻结路径。
- **风险 / 回滚或验证成本:** 低——方向已确认，主要风险是「原则选定后细节仍 unresolved」被误读为完结；验证成本 = cr-002..005 提案 + fixture 系列 + Gate 2（确定性）证据；回滚 = 用户日后改选替代规则时走 CR/升级路径（无固化资产，零沉没成本）。
- **候选预算相关:** 本选项不涉及任何数值门槛；若日后引用任何候选预算数值（含 1080p/60 等六项性能候选与 1280×720 红线）→ 仅候选，须经 CR + 用户批准才成为正式门槛。
- **D1/D2 升级判定（AUTH-01 §8.2.3 (a)–(e) 逐条）:**
  - (a) 候选→正式门槛数值提升: 不命中（无任何数值）。
  - (b) 写入发布承诺/发布文案/Gate 判据: 不命中（本卡不写入任何 Gate/发布承诺）。
  - (c) 命名发布渠道: 不命中。
  - (d) promise/immutable/platform 变更: **不命中——仅确认既有 `user_confirmed` 方向，决策 #3、revision-02 #4、PRECHARTER-02 语义均不变**。
  - (e) threshold/release crossing: 不命中。
  - **结论: 非升级**（若单独成卡且为推荐项，符合 D1 自动采纳资格；本卡整体判定见 §5）。

### Option B — 替代规则：全局距离单调排序（取消「簇」抽象）

- **名称:** 替代规则——对全体合法目标按距离单调排序（nearest-first，无簇概念）→ 取序首 → lock snapshot。
- **依据:** 提出为替代候选（Batch 3 选项集合范围）；其语义与既有已确认记录**相异**，改变点如下（change declaration）：
  - **决策 #3**：confirmed 语义「Refresh nearest-threat cluster before each shot」中的「簇」失去操作对象——刷新对象由「威胁簇」变为「全体合法目标按距玩家距离」→ **改变已确认决策 #3 语义**。
  - **revision-02 #4**：「nearest-threat cluster」与「stable-sort」的簇排序语义被全局单调排序替换 → 改变已确认语义。
  - **PRECHARTER-02**：「cluster-center distance」键被删除 → 改变已确认键序语义。
  - ADR-TECH-04 的 required high-level semantics 亦含簇引用/簇中心字段 → 若采用需重写 ADR-TECH-04 语义段候选契约字段。
- **影响:**
  - 产品: 单一距离维度更简单直接，但「近处杂兵抢占排序、忽略簇中心危险」时移动归因可能出现反直觉读法，与 pillar 2 的路线型归因产生张力。
  - 创意: 削弱「威胁簇」心智模型；与 UX-02「movement relates to next automatic attack」观察目标的归因预期需重新校。
  - 技术: 单键排序确定性强、fixture 更简；但 ADR-TECH-04 候选契约字段（cluster reference、ordering keys 层级）失效，需语义重写；cr-002 的 metric/tie-break 提案面缩小。
  - 范围: 不新增系统，但改写已确认边界内一处关键语义（决策 #3 的「簇」）。
  - 进度: 需重开 ADR-TECH-04 语义段与 cr-002 定义；相比 A 多一轮跨角色评审。
- **风险 / 回滚或验证成本:** 高——改变 `user_confirmed` 语义 → 若选定需走 `reauthorize_charter` 检查（Charter §2.3 / CR §6 Producer note）；验证成本 = 重写 fixture 语义 + 归因观察目标重校 + QA Gate 2 重新观察；回滚 = 回归 A 需新 CR + 用户。
- **候选预算相关:** 本选项不涉及任何数值门槛；若日后引用任何候选预算数值 → 仅候选，须经 CR + 用户批准才成为正式门槛。
- **D1/D2 升级判定（(a)–(e) 逐条）:**
  - (a) 不命中；(b) 不命中；(c) 不命中；
  - (d) promise/immutable/platform 变更: **命中——改变决策 #3（簇语义）与 PRECHARTER-02（键序语义）已确认边界**；
  - (e) 不命中。
  - **结论: 升级——命中 (d)**。

### Option C — 替代规则：中心距离加权（保留簇，重建键序）

- **名称:** 替代规则——威胁距离 × 簇中心距离加权打分排序（cluster 保留，但排序不再由既有三键序决定）→ 取序 → lock snapshot。
- **依据:** 提出为替代候选；其语义与既有已确认记录**相异**，改变点如下（change declaration）：
  - **PRECHARTER-02**：已确认键优先级「nearest threat → cluster-center distance → then stable ordering/stable ID」被加权合并替换，「最近威胁」不再严格第一键 → **改变已确认键序语义**。
  - **revision-02 #4**：「stable-sort」的排序原则被加权打分替换（排序结果由权重参数与两距离共同决定）→ 改变已确认语义。
  - **决策 #3**：pre-fire refresh → lock 框架保留，但簇 membership 的语义受权重打分扰动（同一移动下排序可能随权重翻转）→ 归因可预测性降低。
  - 引入参数化权重 → 属 PRECHARTER-04 ledger 对象（range + starting point；不锁常数）。
- **影响:**
  - 产品: 攻击可偏向「威胁簇中心」，但移动归因的可预测性下降（同一次移动下排序结果随权重翻转的可能性，归因需二次认知）→ 与 low-cognition choice pillar 张力。
  - 创意: 簇概念保留，但「簇中心距离」从第二键升为权重键 → UX-02 观察目标需在权重参数下重校。
  - 技术: 新增权重参数 → 确定性输入面扩大（键序 + 权重两处都需要 trace 字段）；ADR-TECH-04 ordering keys 字段需改为加权字段。
  - 范围: 不新增系统，但引入参数化排序（新候选数值面）。
  - 进度: 决策面扩大（权重成为新候选数值，未来可能触碰 (a)）；cr-002 提案需含权重范围。
- **风险 / 回滚或验证成本:** 高——键序改变 = (d)；权重参数化 = 未来候选→正式规则/门槛的 (a) 升级风险（本卡未选定数值，故现在不命中 (a)）；验证成本 = 加权排序 fixture + 归因观察；回滚 = 回归 A 需 CR + 用户。
- **候选预算相关:** 本选项不涉及性能/分辨率数值门槛；权重为规则参数而非性能预算，若其数值未来写入 Gate 判据/发布承诺 → 仅候选，须经 CR + 用户批准才成为正式门槛。
- **D1/D2 升级判定（(a)–(e) 逐条）:**
  - (a) 不命中（本卡未选定任何权重数值）；(b) 不命中；(c) 不命中；
  - (d) promise/immutable/platform 变更: **命中——改变 PRECHARTER-02 已确认键优先级与 revision-02 #4 的排序原则**；
  - (e) 不命中。
  - **结论: 升级——命中 (d)**。

### Option D — 推迟待 ADR-TECH-04 定稿

- **名称:** 推迟——保持 cr-001 `unresolved`，待 ADR-TECH-04（A1 draft/review 路径）定稿收敛后再制备本卡。
- **依据:** cr-001 当前 disposition = `needs_user_decision` 且未决；ADR-TECH-04 现处 A1 draft/review 路径（DC-ARCH-01 R02：授权启动 ADR-TECH-01..08 定稿，draft → 跨角色评审 → 依评审结果逐条进入批准流程），其 unresolved detail register 尚未收敛；Charter §12 与 Systems §5.1 均将正式 target-cluster 语义列为待 ADR/待用户选择项。
- **影响:**
  - 产品: 语义保持开放期内无新承诺；但移动归因的观察目标（UX-02/03）继续挂起，因果可读性仍不可观察。
  - 创意: 无变化；UX §6.3 因果提示的观察目标继续挂起。
  - 技术: ADR-TECH-04 可在无本卡输入下继续草拟（其 required high-level semantics 已含候选方向），但 unresolved register 无法收敛；ADR-TECH-06 fixture schema 与最小核心 seam 契约待定。
  - 范围: 无变化。
  - 进度: 违反 §7 批次窗口建议（「不晚于最小确定性核心 seam 契约冻结」）——seam 契约冻结与 cr-002..005、target fixture 系列继续阻塞。
- **风险 / 回滚或验证成本:** 中等——推迟不违约但延迟契约面收敛与 fixture 排期；验证成本 = 无新证据产生（无进展，契约冻结顺延）；回滚 = 任意时刻可重启本卡（无固化，零成本）。
- **候选预算相关:** 本选项不涉及任何数值门槛；若日后引用任何候选预算数值 → 仅候选，须经 CR + 用户批准才成为正式门槛。
- **D1/D2 升级判定（(a)–(e) 逐条）:** (a)(b)(c)(d)(e) 全部不命中（不改变任何已确认语义/数值，只是不决策）。
  - **结论: 非升级**（符合 D1 资格；本制备方不推荐——见 §6）。

---

## 3. D1/D2 归类结论（本卡整体判定，按 AUTH-01 §8.2.3 如实标注）

- **本卡含升级选项：Option B 与 Option C 均命中 (d)（promise/immutable 语义变更，改变决策 #3 / PRECHARTER-02 / revision-02 #4 已确认边界）。**
- 按 AUTH-01 §8.2.3 D2 明文：「任一命中即升级，整卡呈交用户」「凡含 (a)-(e) 的选项即使同卡其余选项不升级，该卡也呈交用户」→ **本卡整卡呈交用户亲自选择，不走 D1 自动采纳**。
- 判定结论: **升级类卡片（D2 路径）**。父协调器按此标注执行归类；用户选择结果按 §7 决策后记录规则登记为 `user_confirmed`（provenance = 用户决策）。
- 附注（如实说明，非规避建议）: 若未来父协调器希望就「确认候选方向」单独走 D1 自动采纳，唯一合规路径是该事项单独成卡（不含任何 (a)-(e) 选项）；本卡按任务指示保留替代规则选项，故按 D2 呈交。A、D 的「非升级」标注不影响整卡判定。

---

## 4. 专业推荐（唯一）

**推荐 Option A —— 确认候选方向「refresh nearest-threat cluster → stable-sort → lock that shot's target snapshot」（键序 = 最近威胁 → 簇中心距离 → 稳定排序/稳定 ID）。**

- **一句理由:** 它将三项已 `user_confirmed` 记录（决策 #3、revision-02 #4、PRECHARTER-02）同向收敛为一个可冻结、可 fixture 化的语义原则，零 promise 变更、零数值承诺，直接解锁 cr-002..005 与最小确定性核心 seam 的契约冻结，是唯一在当前不变量框架内无需升级即可推进的选项。
- **异议（如实列出，未发现专业意见冲突，不触发 D3）:** 无根本性异议。记录两项监督点：① 原则选定 ≠ 细节完结——exact metric/tie-break/ID 生命周期/时点仍 unresolved，不得被实现便利硬化（ADR-TECH-04 stop condition；PRECHARTER-04）；② 若未来观察显示簇/键序读法伤害移动归因（Charter §9 风险行「Target semantics and stable ties make movement causality unclear」），应经新 CR/用户回归本卡替代选项，而非静默改规则。
- **依赖并列（「依赖输入」，本制备方不代做、不自造内容）:**
  - **Tech 依赖**：Tech Lead 机制/确定性字段输入（cr-002 metric/quantization、cr-003 stable-ID 生命周期、ADR-TECH-04/06 机制确认）——父协调器并行派发中，本会话**未到齐**；按 ADR-TECH-04 unresolved detail register 与 Systems §5.3 fixture schema 提案标注假设来源。父协调器汇卡时须附上 Tech 输入文件作为依赖输入。
  - **UX 依赖**：UX 可读性观察目标输入（UX-02 移动归因、UX-03 no-target 安静不误导）——本会话**未到齐**；按 UX 合同 §3 no-target 行、§6.3、§9 UX-02/UX-03 行标注假设来源。父协调器汇卡时须附上 UX 输入文件作为依赖输入。
  - **cr-002..005 依赖**：本卡选定原则后，cr-002..005 按 `absorb_within_authority` 由 Systems + Tech 提案、fixture 验证（详见 §8）。
  - **ADR-TECH-04 衔接**：本卡选定后，ADR-TECH-04 语义段以本卡为输入继续定稿；ADR 保持 `PROPOSAL / DRAFT / NOT APPROVED` 直至正式评审（A1 路径，DC-ARCH-01 R02）。

---

## 5. 下游影响（选定原则后，依赖路径）

- **cr-002（距离度量/量化与 tie-break 字段）**：依 A 的键序由 Systems + Tech 提案 metric/quantization 与 tie-break 字段（排序 fixture + trace 字段验证）；`absorb_within_authority`，不触碰承诺。
- **cr-003（stable-ID 生命周期）**：Tech 提案 allocation/reuse/serialization（ADR-TECH-03）；Session 持有；QA 复现审计。
- **cr-004（失效时机/射击中目标移除）**：Tech + Systems 提案事件排序与失效语义；removal fixture；保留「移除/失效目标不得作为有效命中」禁令（Systems §5.1；ADR-TECH-04）。
- **cr-005（no-target 节奏与反馈形态）**：Systems 提案形态（ADR-TECH-04 未决；Systems §5.2：quiet cycle / 受限可用提示 / 延迟重试等）；UX 接 UX-03 观察目标；若形态触碰产品承诺 → 升级 `needs_user_decision`。
- **最小确定性核心 seam 契约**：target snapshot 契约字段（ADR-TECH-04 candidate contract fields + Systems §5.3 fixture schema 提案）可依选定原则收敛；该 seam 契约冻结在本卡决策之后、实现授权之前。
- **Fixture 系列（no-target / ties / removal）**：以选定原则定型（ADR-TECH-06 future evidence IDs 已预留；Systems §11 QA handoff 清单含 no-target/ties/removals 等）。
- **Gate 2 证据形状**：fixture ID + seed + tick/config version + trace（含 candidate_ids / ordered_ids / target_snapshot_ids / no_target_branch / invalidation reason 等字段），headless 比较 + QA 独立观察；Gate 2 维持 `not_run / not_ready` 直至授权实现与授权证据产生。

---

## 6. 候选预算相关声明（本卡不涉及数值门槛）

本卡所有选项**均不涉及任何性能/分辨率数值门槛**，不引用 1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s 或 1280×720 红线作为决策输入或依据。（若未来任何选项/决策文本引用上述候选预算数值 → 一律标注「仅候选，须经 CR + 用户批准才成为正式门槛」；本卡无此引用。）

---

## 7. 决策后记录规则（按 CR §8 模板）

- 用户（本卡 D2 呈交）亲自选择某项 → 记为 `user_confirmed`（provenance = 用户决策），并更新受影响 cr 行状态与对应合同/ADR 的 status 字段（仍为 `PROPOSAL / DRAFT / NOT APPROVED` 直至契约评审）。
- 未选项保持 `unresolved` / `team_proposal`（不删除、不静默推广）。
- 若用户选择 **Option B 或 Option C**（改变决策 #3 / PRECHARTER-02 / revision-02 #4 已确认语义）→ 走 `reauthorize_charter` 检查（Charter §2.3 回滚/再授权规则；CR §6 Producer note「任何选项选定后改变 promise/immutable/platform/release → 升级为 reauthorize_charter」）。
- 选择 Option A 或 Option D → 不触发 `reauthorize_charter`（A 不改已确认语义；D 为不决策）。

---

## 8. 决策窗口与截止依赖

- 按 CR §7 Batch 3 行：**不晚于最小确定性核心 seam 契约冻结**；可与 Batch 1/2 并行制备（本卡已并行制备）。
- AUTH-01 P1：Batch 2 → Batch 3 连续推进，批间不征询「是否继续」；但本卡为 D2 升级类 → 仍呈交用户亲自选择，不可自动采纳。
- 依赖：cr-002..005 的推进、最小核心 seam 契约冻结、ADR-TECH-04 语义段收敛均以本卡决策为前提；决策前保持 `unresolved` 且不静默通过。

---

## 9. 依赖输入衔接（并行输入未到齐时的假设来源标注）

- **Tech Lead 机制/确定性字段输入**（父协调器并行派发，各产唯一输入文件）：本会话未到齐。本卡在其到达前按既有文档标注假设来源：ADR-TECH-04 unresolved detail register（cluster、metric、quantization、tie-break、stable-ID、invalidation、timing）、Systems §5.3 fixture schema 提案。父协调器汇卡时须把 Tech 输入文件作为依赖输入附入；本卡不代做、不自造 Tech 机制内容。
- **UX 可读性观察目标输入**：本会话未到齐。按 UX 合同现有文本标注假设来源：§3 no-target 行（quiet/non-misleading）、§6.3 因果移动提示（未来理解观察目标）、§9 UX-02/UX-03 行（`not_run / not_ready`）。父协调器汇卡时须把 UX 输入文件作为依赖输入附入；本卡不代做、不自造 UX 观察目标内容。
- 若并行输入到齐后与本卡引用文本冲突 → 以父协调器附入的并行输入文件为准更新本卡的依赖衔接段落（由父协调器或新修订版执行，本卡 v0.1 不自行追改既有合同）。

---

## 10. 批准后的 owner 与验收标准

| 角色 | Owner 范围（批准后） | 验收标准（命名证据/门 + 独立观察要求） |
|---|---|---|
| **Systems / Rules**（语义） | 依选定原则提案 cr-002（metric/tie-break 语义）、cr-004（失效语义）、cr-005（no-target 形态）；维护 ledger（PRECHARTER-04：range + starting point） | 提案逐项落入 `absorb_within_authority` 路径；无任何候选数值被提升为常数；no-target 形态不触及产品承诺（触碰则升级） |
| **Tech**（机制/fixture 契约） | cr-002/003/004 机制提案；ADR-TECH-04/06 语义段与 fixture schema 更新；最小确定性核心 seam 契约 | 契约字段可审计（候选 ID/排序键/锁定快照/no-target 分支/失效原因）；ADR 保持提案态直至正式评审；契约冻结在实现授权之前 |
| **UX / UI**（观察目标） | 按选定原则定义移动归因与 no-target 的观察目标（UX-02/UX-03） | UX-02/UX-03 行具备可执行观察字段（fixture/seed、trace、frame refs、observer、verdict），状态仍 `not_run / not_ready` |
| **Independent QA / Release**（Gate 2 独立观察） | 独立观察确定性证据：fixture、seed/tick/config version、trace、no-target/ties/removal 场景 | Gate 2 pass/block 权不变、无豁免；证据字段按 Charter §10 全量齐备；Gate 2 维持 `not_run / not_ready` 直至授权实现；QA 独立 verdict，不受本卡推荐影响 |

---

## 11. 不变量与分层声明（本卡遵守）

- **22 项原始 `user_confirmed`**（Charter §6）：未改写、未重分类；本卡仅引用决策 #3/#22 等作为依据。
- **Exactly 8 canonical revision-02 inputs + 独立 Charter authorization record（8+1）**：未变、无第九项；本卡引用 revision-02 #4 仅为既有输入，不新增。
- **PRECHARTER-01..11**：全部保留；本卡引用 PRECHARTER-02 仅为既有输入。
- **四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）：全程区分，无任何静默提升；选项依据仅引用已确认事实与既有文档文本（`team_proposal` 标记为 proposal），未引用未经证据的事实。
- **Unresolved 全量保留**：cr-001（及 cr-002..005）在本卡决策前保持 `unresolved`；本卡不关闭任何 unresolved 细节；未选项不删除、不静默通过。
- **候选预算**保持仅候选（六项性能候选与 1280×720 红线均未被动用/提升）。
- **本卡不修改任何其它文档**（Charter、Systems/Tech/UX 合同、ADR、CR 台账、证据 index 均未触碰），仅新增本唯一产物文件。

---

## 12. 证据边界与本卡用途

- 证据类别：`static/source` only（本卡引用 5 份授权文档文本 + 专家能力 Skill）。
- 本卡不构成：合同批准、ADR 批准、实现授权、kickoff pass、任何 runtime/QA/perf/export/release 证据、用户决策。
- 用途：供父协调器按 AUTH-01 §8.2.3 D2 判定装配为 Batch 3 选项卡片，**呈交用户亲自选择**（本卡含升级选项 B/C）；选定后按 §7 记录规则登记。

---

## 13. 版本与变更记录

- **v0.1（本文件）**：Systems/Rules Designer 制备的唯一新产物；4 个互斥选项 + D1/D2 逐条判定 + 唯一推荐 + 下游影响 + owner/验收标准。未修改任何其它文档。