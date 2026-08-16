# PROPOSALS CR-002 / CR-004 / CR-005 v0.2 — 距离度量·失效时机·no-target 形态提案合集

> **Status:** `PROPOSAL / TEAM_PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`（本 v0.2 仅作 cr-004 §3.4 推荐同步，属性不变）
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`。
>
> **⚠️ 失效语义终裁注记（文件级）:** cr-004 的失效语义 (i)/(ii) 已由 **`SEMANTICS_INVALIDATION_FINAL_v0_1.md`（2026-08-16，Systems 唯一裁定书）终裁为 (ii)**：「移除即失效 ⇒ 无命中，落点在命名 drain 点；锁定 = 固定 ID 集 + 不重定位；锁定 ≠ 保证命中」。本提案 **v0.1 → v0.2** 仅作为 `absorb_within_authority` 路径内的**提案推荐同步**：将 cr-004 §3.4 推荐自 (i) 改为 (ii)，并同步 §3.6 QA 衔接行，使提案推荐与规则 6 / QA 判据 / 实现 / 终裁书四方一致（终裁书 §6 动作 1）。本修订不触碰产品承诺、不批准/冻结任何 ADR、不豁免 QA。
>
> **Artifact:** Systems / Rules Designer 依已决 cr-001 (`DC-SYS-01 → Option A`，R09) 产出的 **cr-002 / cr-004 / cr-005** 三份 `absorb_within_authority` 提案合集（团队提案级）。
>
> **Evidence class:** `static/source` only。未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未批准或冻结任何合同或 ADR；未豁免 QA blocker；未替 Independent QA 下 verdict；未替用户做最终产品决策；未将任何候选数值提升为正式常数/门槛。

---

## 0. 前置：专家能力加载、授权衔接与提案级声明

### 0.1 专家能力加载（godot-systems-rules-expert）

- **接口实测顺序（真实记录）:** ① `pwsh Get-Content` 读取角色专家 Skill 精确定位文件（`static_skill_load` 备份路径）→ ② 实际调用 `skill({ name: "godot-systems-rules-expert" })`，**调用成功**，返回完整 SKILL 指令内容（`strong_direct_skill` 等级）。
- **能力证据等级:** `strong_direct_skill`（首选等级；运行时 `skill` 接口确实成功返回，非仅凭函数清单判断，亦非伪报不可用）。
- **应用证据:** 本合集按该 Skill 的专业方法执行——mechanics 以 `player intent -> input -> rule/state change -> feedback -> next decision` 描述；数值全部视为假设（`numbers are hypotheses`，range + starting point，不锁常数）；state transition / feedback / failure-recovery / acceptance example 逐项给出；诚实边界（`honesty boundary` 不虚报运行时/QA 证据）全程遵守；角色边界（Systems 提案规则语义，不代 Tech 机制实现、不代 UX 观察、不代 QA verdict、不越用户裁决权）严格遵守。

### 0.2 授权衔接（引用，不重投）

- **cr-001 已决 = Option A「确认候选方向」**(R09, provenance=`user_confirmed`（决策引用）)。键序固定 = **最近威胁 → 簇中心距离 → 稳定排序/稳定 ID**。exact cluster membership / metric / quantization / tie-break 字段 / stable-ID 生命周期 / 失效·时点 **保持 `unresolved`**，移交 cr-002..005。
- 本三份提案全部属 `absorb_within_authority`（R09 owner 提示）：**不触碰承诺**；数值走 ledger（PRECHARTER-04：range + starting point，不锁未验证常数）；提案结果保持 `team_proposal` 直至证据 + 评审。
- **Tech 机制约束（引用 TC-INPUT）:** 全序键链 k1/k2/stable_id、量化桶禁浮点相等、stable-ID 分配纪律（Session 单调分配、run 内不复用）、失效命名 drain 点、tick 表达、fixture 族（TARGET-tie / removal / no-target / container-order / float-epsilon / B2-arc-order）。
- **UX 观察目标（引用 UX-INPUT）:** G1 稳定可重复性、G2 移动引发目标变化、G3 感知威胁对应、G4 无幻影期望；S1 无伪造目标、S2 无伪造命中、S3 分支可辨。
- **不变量（本合集遵守）:** 22 项原始 user_confirmed；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；unresolved 全量保留（cr-002/004/005 在吸收路径进行中仍为 `unresolved`，直至证据 + 评审）。
- **候选预算:** 六项性能候选（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线**全部保持仅候选**，本合集不涉及、不提升。

### 0.3 写入边界与唯一产物

- 本次修订的唯一写入产物 = **本文件原位修订**：`docs/production/PROPOSALS_CR002_004_005_v0_1.md`（v0.1 → v0.2），仅改 cr-004 相关行（§3.4 推荐 (i)→(ii) 及 §3.6 对齐）。未修改任何其它文档（终裁书、QA 计划、实现报告、CR 台账、Systems 合同、Tech/UX 输入、Charter、ADR、证据 index 等一律未触碰）；cr-002（M-1）与 cr-005（quiet cycle）内容保持不变。
- 禁止调用 `subagent` / `subagent_fork` / `workflow` 或任何嵌套派发——本会话未调用任何此类接口。

---

## 1. Expert preflight（按 godot-systems-rules-expert §Expert preflight）

- **Mission outcome:** 在 cr-001 Option A 键序框架内，产出 cr-002（距离度量/量化与 tie-break 字段）、cr-004（失效时机/射击中目标移除）、cr-005（no-target 节奏与反馈形态）三份静态规则提案，全部落入 `absorb_within_authority` + PRECHARTER-04 ledger 形态。
- **Player promise / slice:** 简单直接移动 + 自动攻击的可读、有重量感的清屏控制；因果链 `movement → pre-fire target consequence → readable hit/contact → space recovery → stronger B2 → victory/defeat → reset`。第三方案服务的因果可读性核心 = pillar 2「移动→下一次自动攻击」归因 + pillar 4「非惩罚节奏」。
- **Known constraints:** c-三键序为 `user_confirmed` 决策引用；不触碰承诺；数值仅候选；提案级不升级；cr-002/004/005 保持 `unresolved` 直至证据+评审；Gate 2 仍 `not_run / not_ready`。
- **Top three design risks:**
  1. **浮点/容器顺序非确定** → 破坏 G1（可重复性）与复现（R1/R2 in TC-INPUT）。缓解：量化桶 + 离散键链 + 不可变副本推导 ordered_ids + `TARGET-container-order` / `TARGET-float-epsilon` 回归族。
  2. **失效语义歧义**  → 锁定后目标移除被误判为「有效命中」或「打空气」（违反 Systems §5.1 规则 6 禁令）。缓解：命名 drain 点 + 二选一一致语义 + `TARGET-removal`。
  3. **no-target 误导性命中反馈** → 违反产品边界（S2）、幻影期待（G4）。缓解：quiet cycle 形态建议 + 反馈类与 hit_results 因果绑定 + `TARGET-no-target` / UX-03 场景矩阵。
- **Unknowns:** cluster membership / metric 数值与单位 / 精确 tie-break 措辞的 UX 可读性 / tick 频率 / B2 多弧中间态语义（部分归 cr-020 / cr-003 / cr-016，本合集不代决）。
- **Required evidence:** 授权实现后 — TARGET-* fixture 族（精确期望值 + 容器方差变体）+ seed 复现 trace + QA Gate 2 独立观察（`not_run / not_ready`）。
- **Decision boundary / stop condition:** 语义归 Systems（本合集）；机制落实归 Tech；观察归 UX；验收归 QA；最终裁决归 User。若提案触碰 promise/immutable/platform/threshold/release（如 cr-005 形态触及「自动攻击始终可见」改写、或键序语义变更）→ 升级 `needs_user_decision` / `reauthorize_charter`，本合集即停并标注升级触发条件。

---

## 2. PROPOSAL A — CR-002：距离度量 / 量化与 tie-break 字段

**状态声明（提案级）:** 本份为 `team_proposal`，不因此升级；cr-002 保持 `unresolved`（absorb 路径进行中）直至证据 + 评审。所有数值仅候选。

### 2.1 依据（引用已确认事实 / 输入文件）

- **键序框架（cr-001 R09，user_confirmed 决策引用）:** 最近威胁 → 簇中心距离 → 稳定排序/稳定 ID。
- **PRECHARTER-02:** nearest threat → cluster-center distance → stable ordering/stable ID；cluster definition、metric、tie-break fields 等 unresolved。
- **TC-INPUT §2.2:** 全序键链 `k1 = 量化后的 nearest-threat 距离` → `k2 = 量化后的 cluster-center 距离` → `k3 = stable_id`（唯一）；comparator 禁浮点相等、先量化到固定精度整数桶；排序在不可变副本上推导 `ordered_ids`，不排序引擎容器。（本份只承接 metric/quantization/tie-break **语义**，机制落实归 Tech。）
- **UX-INPUT G1/G3:** G1 要求排序不得依赖隐藏容器顺序、tie-break 落到可推断或可审计的稳定字段；G3 要求首击与玩家感知的「最近威胁簇中心」一致，否则 mismatch 须显式记录。
- **Systems §5.1 / §3.2:** 簇定义、距离度量、tie-break 字段设置为 unresolved；明确 `nearest-threat cluster` 是产品层方向、非完整算法。

### 2.2 提案内容

#### 2.2.1 距离度量选择（三候选 + 唯一推荐）

> 语义提案；精确数值与实现归 Tech ledger。所有距离度量须满足 TC-INPUT 全序键链纪律。

| 候选 | 描述 | 可读性（UX 视角） | 确定性 / fixture 影响 | 冲突/风险 |
|---|---|---|---|---|
| **M-1（推荐）** | **离散键链距离 = 两个量化后的标量键：(a) nearest-threat 距离 = 玩家到「最近合法威胁」的量化距离；(b) cluster-center 距离 = 玩家到威胁簇中心的量化距离**。按 cr-001 键序做 p1 优先、p2 次之、p3=stable_id 决序。 | 与 G3「威胁簇中心」空间直觉对齐；键序单一、可 trace、可审计（G1）。 | 两个离散键 + 唯一 ID = **天然全序**；fixture 期望值精确（`TARGET-tie` / `TARGET-tie-cluster-center` / `TARGET-container-order`）。 | mismatch 需 G3 fixture 显式记录；量化桶宽窄影响「最近威胁」与「簇中心」相对优先级（可感知差异）。
| **M-2** | 单一欧氏距离直接排序（无簇中心键） | 更简单，但删除 cluster-center 键 → 与 cr-001 键序（保留簇中心）相异、改变已确认键序语义 → **(d) 升级边界**。 | 单键 + ID 仍是全序；但偏离已确认键序。 | 触碰已确认键序 → 触发升级路径，**本候选仅在需替换键序时才进入 CR**（本提案不推荐）。
| **M-3** | 加权合成（威胁距离 × 簇中心距离加权打分） | 归因可预测性下降（同一次移动排序可能随权重翻转）→ G2 弱化。 | 引入候选权重参数（新数值面，属 ledger）。 | 改变已确认键优先级（PRECHARTER-02）→ **升级边界**；本提案不推荐。

**唯一推荐：M-1（离散键链双标量距离）。**
- **一句理由:** 它原样落地 cr-001 已确认的三键序，天然满足 TC-INPUT 全序键链纪律（确定性→G1），且保留「最近威胁」与「威胁簇中心」两级键，与玩家 G3 空间直觉对齐，零承诺变更、零键序改写。
- **异议（如实）:** ①「簇中心」本身依赖 cluster definition（cr-001 遗留 unresolved 之一），本提案只承接排序键语义，**不代决簇 members 定义**（仍 unresolved，归 cr-001 遗留/后续 ADR-TECH-04 语义段）；② 两级量化桶的宽窄是**规则参数而非性能预算**，一旦未来写入 Gate/发布判据 → 升级路径（此处仅候选）。

#### 2.2.2 量化方案（对齐 TC-INPUT 量化桶）

- **桶表达:** 两条距离分别量化为**固定精度整数桶** `fixed-scale integer bucket`（等价 TC-INPUT §2.2-3）。近等距离在量化桶相等时落入下一级键（cluster-center 桶 → stable_id），**不得在 comparator 内用 epsilon“判平”**。
- **桶宽属性:** 桶宽（scale 的分母粒度）为**规则参数**，走 PRECHARTER-04 ledger（range + starting point），**不确定为常数**。桶宽越大，等距并桶越易（更依赖 stable_id 决序）；桶宽越小，距离区分越细（更贴近连续几何，但浮点抖动风险上升）——需 `TARGET-float-epsilon` 回归验证。
- **桶粒度单位:** 与位置坐标量化一致（TC-INPUT fixture initial snapshot `position(量化)`）；具体尺度归 Tech 定稿，Systems 只声明「必须量化、禁浮点相等」语义纪律。

#### 2.2.3 tie-break 字段形态（最终 stable_id 决序）

- **键序终点:** 两级距离桶都相等时，以 **`stable_id`** 决序（唯一、全局、run 作用域）→ 构成全序，排序结果唯一、跨 run 稳定、可复现（TC-INPUT §2.2-1 关键理解）。
- **字段元组（候选 trace）:** `ordered_ids` 由 `(k1_bucket, k2_bucket, stable_id)` 字典序推出；trace 记录每个候选的 `k1_bucket` / `k2_bucket` / `stable_id` 与最终 `ordered_ids`、`target_snapshot_ids`。
- **可读性注记:** 两距离键相等后以 ID 决序的次序对玩家可能是**任意的**（TC-INPUT §2.3 注记；UX-INPUT G1 要求 tie-break 可推断或至少可审计）。Systems 语义建议：**tie-break 不承诺“可感知正确”的优先级语义**，只承诺**确定、可复现、可审计**；若未来观察显示该次序伤害 G2/G3 归因，经新 CR/用户回归，而非静默改规则（监督点，引用 CARD DC-SYS-01 §4 异议 ②）。

#### 2.2.4 对 G1/G3 可读性的语义影响

- **G1（稳定可重复性）:** 满足 — 全序键链使排序与容器顺序无关；同场景 + 同 seed + 同移动 → 相同 `ordered_ids`/`target_snapshot_ids`。证据：`TARGET-container-order` + `TARGET-float-epsilon` 复现。
- **G3（感知威胁对应）:** 大体满足 — 两级键保留「最近威胁」+「威胁簇中心」，与玩家空间直觉对齐；但两级桶边界与 stable_id 决序段**可能是不可感知部分**（付出的“可读性税”），须由 hint（UX §6.3 因果移动提示）与分层反馈补偿；mismatch 断言显式记录于 `TARGET-tie` / 未来 G3 mismatch fixture。

### 2.3 影响（产品·创意·技术·范围·进度）

- **产品:** 键序可观察 → 移动→下一次攻击归因链落地（pillar 2）；两级键保留「威胁簇」心智模型（pillar 5 低认知）。
- **创意:** 无新创意承诺；与 Slice intent 一致。
- **技术:** 为 TC-INPUT 全序键链提供规则语义输入；metric/quantization（数值尺度）交 Tech ledger；不代决簇 members 定义。
- **范围:** 不新增内容/系统；在 cr-001 键序框架内。
- **进度:** 解锁 `TARGET-tie` / `TARGET-tie-cluster-center` / `TARGET-container-order` / `TARGET-float-epsilon` fixture 定型；ADR-TECH-04 语义段可依此收敛。

### 2.4 风险 / 回滚或验证成本

- 风险：量化桶宽窄不当 → 距离区分行为与 G3 感知错位；浮点抖动 → 复现失败（TC-INPUT R1）。缓解：桶宽走 ledger + `TARGET-float-epsilon`；不可变副本 + 容器方差变体（R2）。
- 回滚：纯规则核单一 owner，回滚 = 撤排序函数 + fixture，无 adapter/presentation 涟漪（TC-INPUT §5）。
- 验证：排序 fixture 精确匹配 `ordered_ids` + seed 复现 trace + QA Gate 2（`not_run / not_ready`）。

### 2.5 Ledger 行（数值仅候选，不锁常数）

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | `k1_bucket` / `k2_bucket` 的 fixed-scale 桶宽：候选范围待 Tech 给出（单位 = 坐标量化单位）；排除值 = comparator 内 epsilon 判平（禁） |
| `starting_point` | 由 Tech ledger 给出候选初始尺度；**非平衡/实现证据** |
| `assumption` | 两级距离量化后可被玩家感知/审计（G1/G3）；桶宽不破坏「最近威胁」主导 |
| `dependency` | 位置坐标量化、cluster definition（cr-001 遗留）、stable-ID 分配（cr-003）、tick 表达（cr-020） |
| `signal` | `TARGET-tie` / `TARGET-tie-cluster-center` / `TARGET-container-order` / `TARGET-float-epsilon` 精确 `ordered_ids`；UX-02/03 观察（movement/attack trace 对齐） |
| `promotion_authority` | **User**（任何候选数值提升为正式规则/门槛/Gate 判据必经 CR + 用户批准） |
| `stop/rollback` | 桶宽破坏复现 → 回滚尺度并重跑 fixture；两键序改变已确认键序 → 升级，停止本路径 |
| `evidence_id` | 空白（未及证据）；授权实现后才填充 |

### 2.6 与 fixture 族衔接（TARGET-*）

- `TARGET-tie`（两级距离桶等距）→ `ordered_ids` 精确 = 键链次序（cluster-center 优先，最终 stable_id 决序）。
- `TARGET-tie-cluster-center`（距离桶与簇心桶均相等）→ 落 stable_id 决序，跨 run 一致。
- `TARGET-container-order`（同场景两种插入序）→ `ordered_ids` 逐位相同（容器无关确定性回归）。
- `TARGET-float-epsilon`（距离落入量化桶内近等）→ 两次同 seed run 排序一致。
- 衔接：`B2-arc-order` 弧序单独为 shot，本 metrics 逐 shot 独立应用（B2 弧 order 归 cr-016，不在此件代决）。

---

## 3. PROPOSAL B — CR-004：失效时机 / 射击中目标移除

**状态声明（提案级）:** `team_proposal`，不因此升级；cr-004 保持 `unresolved`（absorb 路径进行中）直至证据 + 评审。

### 3.1 依据（引用已确认事实 / 输入文件）

- **Systems §5.1 规则 6 / 边界:** 「Removed/invalid targets must be excluded from later resolution」；「移除/失效目标不得参与后续结算」。**禁令明确**：移除目标不得被当作有效命中。
- **决策 #3 / revision-02 #4（user_confirmed 决策引用）:** pre-fire 刷新 + post-fire 锁定；快照在开火后固定。
- **TC-INPUT §2.4:** 锁定后失效/移除必须作为**显式领域事件**在命名 drain 点（解析子步起点）排空；失效目标 ⇒ 该 ID 不产生命中、不伪造命中。机制二选一（快照完全权威 vs 确定性合法性谓词）须一致并被 trace；trace 必含 `refresh_tick` / `lock_tick` / `invalidation_event(id, tick)` / `resolution_outcome`。
- **UX-INPUT §3.1 S2 / §4.3 U3-C:** 射击中目标被移除 → removal trace + 反馈类记录（无幽灵命中）。

### 3.2 命名 drain 点事件排序（Systems 语义建议）

在 cr-001 键序框架 + TC-INPUT tick 语义内，本提案**命名 drain 点与事件排序**如下（`team_proposal`，供 ADR-TECH-04 语义段参考，机制落实归 Tech）：

```text
同一规则步内（adapter 在 tick 边界入队开火事件）：
  [b] drain-in 失效事件（本步起点进入规则核的失效/移除事件在此排空）
  → [c] 评估候选集
  → [d] 推导 ordered_ids（TC-INPUT §2.2）
  → [e] 锁定本 shot 快照（不可变：有序 ID 列表 + 锁定时刻合法性标记）
  → [f] 解析只读快照（绝不回查 live 实体列表）
  → [g] 结算失效/命中：
         · 显式失效事件携带 tick；失效目标 ID 在该步被标记为 invalid
         · 无效 ID ⇒ 不产生命中、不伪造命中（Systems §5.1-6 禁令）
  → [h] 下一 tick
```

- **关键排序原则:** 失效事件在**解析子步（[g]）起点**作为显式 drain 排空，**绝不在中途/回调序内生效**（TC-INPUT §2.4「命名点」）；锁定快照的 ID 集在锁定后**不可变**（[e]），与「不连续 retarget」强制形态一致。

### 3.3 「移除/失效目标不得作为有效命中」禁令落实

- **语义落实方式:** 锁定快照内的 ID 若在其后的 drain 点被声明失效（`invalidation_event(id, tick)`），则该 ID **被排除出命中结算**（不产生 hit，不产生伪造 hit）。此即 Systems §5.1 规则 6 保留并落实。
- **不改变已确认语义:** 决策 #3（post-fire 固定）、规则 6（移除不得命中）均原样保留；本提案只指定失效的**时点与事件表达**。

### 3.4 二选一语义（Systems 语义建议，须与 Tech 机制一致、全 run 唯一）

> **⚠️ 终裁对齐（v0.2）:** 本小节推荐已由 `SEMANTICS_INVALIDATION_FINAL_v0_1.md`（2026-08-16，Systems 唯一裁定书）**终裁为 (ii)**。下列表格与建议段落据此同步；(i) 仅保留作对照候选，不再作为推荐。

| 选项 | 描述 | Systems 语义建议 | 一致性要求 |
|---|---|---|---|
| **(i) 快照完全权威** | 解析只依锁定时刻合法性标记——飞行中失效在快照解析中对**本 shot 不可见**（该 ID 仍按锁定时刻命中；失效在下一 shot 生效） | **不再推荐（v0.2）**：字面与本 shot 命中「已失效目标」与规则 6「excluded from later resolution」冲突；若按字面采 (i) 会生成 S2 幽灵命中 / G4 幻影期待，且与 QA 判据与实现不一致。仅保留作对照候选。 | 若历史评审回看 (i)，须以规则 6 为准重议；本提案以终裁 (ii) 为推荐。 |
| **(ii) 确定性合法性谓词** | 解析对快照 ID 重新评估确定性合法性谓词——移除即失效（与「移除目标不得命中」字面贴合） | **本提案推荐 (ii)（v0.2，终裁对齐）**：移除即失效 ⇒ 无命中，落点在命名 drain 点；合法性谓词为确定性纯函数（不读容器顺序/墙钟/不重定位）。快照 ID 集保持不可变、解析只读不重定位——与「锁定 = 固定 ID 集 + 不重定位；锁定 ≠ 保证命中」完全一致。 | 谓词**必须是确定性纯函数**并全 run 唯一 + trace；`TARGET-removal` 期望事实「X 无命中；`invalidation_event` 带 tick；快照 ID 集不变」成为精确可断言面（零容差可测，G1）。 |

**Systems 语义建议：采用 (ii) 确定性合法性谓词（终裁对齐，源自 SEMANTICS_INVALIDATION_FINAL_v0_1）。**
- **一句理由（与终裁 §3 一致）:** (ii) 字面满足 Systems §5.1 规则 6「Removed/invalid targets must be excluded from later resolution」——每次开火在命名 drain 点（解析子步起点）排空显式失效事件；已锁定的本 shot 快照 **ID 集不可变**、解析**只读**、绝不回查 live 实体、绝不连续重定位（决策 #3 / revision-02 #4 的「锁定」原样保留）；任何在解析前已被 `invalidation_event(id, tick)` 声明的目标本 shot 不产生命中、不伪造命中，失效自下一 shot 的 pre-fire 刷新被踢出候选集而自然生效。即：`锁定 ≠ 保证命中；锁定 = 固定 ID 集 + 不重定位；移除即失效 ⇒ 无命中`。S2（无幽灵命中）与 G4（无幻影期待）由此成立，G2/G3 归因更诚实（玩家不会把「打了空气」记成命中，也不把已死/已移目标记为本发命中）；drain 点输入集固定 → 确定性纯函数 → G1 可测。
- **异议（如实）:** 决策 #3 的「post-fire 固定目标」与 revision-02 #4「lock that shot's target snapshot」确认的是**快照 ID 集的固定与不重定位**，**不是**「对已移除目标的命中保证」；(ii) 完整保留锁定、唯一新增「命中只作用于解析前未被显式失效的锁定 ID」，不触碰任何锁定承诺——故采纳 (ii) **不触发升级路径**（终裁 §5 逐项核查未接触承诺/键序）。若未来观察到「解析时判定」的实现滑向非确定（读容器顺序/墙钟）→ 由 `TARGET-removal` fixture + QA Gate 2 独立验证，而非静默改规则。

> **注:** 无论选 (i) 还是 (ii)，都必须是**全 run 一致的唯一选择**并在每份 trace 记录 `resolution_outcome`（TC-INPUT §2.4 / ADR-TECH-04）；本提案不做实现，只在语义层给 Tech 一个可冻结输入。

### 3.5 Trace 字段（提案，供 fixture/schema）

| 字段 | 含义 |
|---|---|
| `refresh_tick` | 预开火刷新发生所在的 tick 值 |
| `lock_tick` | 快照锁定发生的 tick 值 |
| `invalidation_event(id, tick)` | 目标失效/移除事件（显式领域事件，含事件 tick） |
| `resolution_outcome` | 解析结果（每 ID：hit / no-hit-invalid / no-hit due to resolution） |
| `target_snapshot_ids` | 锁定时刻的快照 ID 集（不变） |
| `no_target_branch` | 空合法集标志（联动 cr-005） |

### 3.6 影响 / 风险+回滚 / Ledger / fixture / QA 衔接

- **产品:** 锁定语义落地 → 归因链 N2 稳定；失效目标不误命中（S2、G4 无幻影）。
- **创意:** 无新承诺；不改变 Slice 进程。
- **技术:** 为 ADR-TECH-04 提供失效 drain 点与二选一语义输入；机制落实归 Tech（会话/session drain 实现）。
- **范围:** 不新增规则；在决策 #3 / revision-02 #4 已确认边界内。
- **进度:** 解锁 `TARGET-removal` / `TARGET-out-of-bound` 相关 fixture；最小确定性核心 seam 失效语义可收敛。
- **风险 / 回滚:** 失效语义一旦由 Systems 定死，改动成本主要在 fixture 重述（TC-INPUT R4，中）；回滚 = 撤快照/失效语义 + fixture。
- **Ledger 行:** 本件主要定义**事件排序与语义**（非数值）；若引入任何阈值/时长 → 走 PRECHARTER-04（range+starting_point；promotion_authority=User）。
- **Fixture 衔接（TARGET-*）:** `TARGET-removal`（锁定含 ID X；解析前 X 被移除 → X 无命中、`invalidation_event` 带 tick、快照 ID 集不变）——**与终裁 (ii) 一致**：X 仍在锁定快照 ID 集内，仅结算无命中（`resolution_outcome = no-hit-invalid`）；联动 `TARGET-no-target`（若失效使候选集变空 → no-target 分支）。
- **QA 衔接:** Gate 2 仍 `not_run / not_ready`；removal fixture 精确期望值 + seed 复现 + QA 独立观察（B3 证据完整性）。`TARGET-removal` 期望事实（QA_ACCEPTANCE_PLAN §3.4：X 无命中、`invalidation_event` 带 tick、快照 ID 集不变）即 (ii) 终裁的可执行判据引用；命中 outcome 记 `no-hit-invalid`（Trace 字段 §3.5）。

---

## 4. PROPOSAL C — CR-005：no-target 节奏与反馈形态

**状态声明（提案级）:** `team_proposal`，不因此升级；cr-005 保持 `unresolved`（absorb 路径进行中）直至证据 + 评审。

### 4.1 依据（引用已确认事实 / 输入文件）

- **决策 #3 / revision-02 #4 / PRECHARTER-02:** no-target 分支明确存在、禁止伪造目标（never invent a target / no pseudo-target）。
- **Systems §5.2:** no-target 分支须保留可读自动攻击循环，不伪造战斗成功；反馈形态（quiet cycle / 受限可用提示 / 延迟重试等）为 `team_proposal / unresolved`。
- **UX-INPUT S1–S3:** S1 无伪造目标（空 refresh 不产生锁定指示/瞄准框）；S2 无伪造命中（hit/kill 反馈类仅在 `hit_results` 非空时 emit、与命中结果因果绑定）；S3 分支可辨（no-target 周期与命中周期可区分）。
- **UX-INPUT G4 / §3.2:** G4 空场 no-target 后玩家不因期待命中而回探空区；quiet cycle 形态建议：周期照常、节奏不被惩罚（pillar 4）、无命中火花/伤害数字/击杀确认、可选一次性非色彩的克制提示。
- **cr-005 注册行:** Systems 提案形态 → UX 观察目标 UX-03；若形态触碰产品承诺 → 升级 `needs_user_decision`。

### 4.2 no-target 分支形态建议（quiet cycle）

**唯一推荐形态：quiet cycle + 可选克制性一次性状态提示（非色彩）。**

- **quiet cycle 内容（Systems 语义提案）:**
  - 攻击周期**照常推进**（自动攻击循环节奏不因 no-target 被惩罚或拖延）——对齐 pillar 4 非惩罚节奏；
  - 空场时**不发出**命中火花 / 伤害数字 / 击杀确认 / 瞄准锁定框 —— 对齐 S1 / S2（无伪造目标、无伪造命中）；
  - **可选**一次性、非色彩（UX 合同 §7 可访问性：非颜色通信）、克制性的「无目标」状态提示 —— 帮助 S3 分支可辨，且不以伪造命中为代价；
  - timer effect 不得产生**隐藏惩罚**（安静 ≠ 拖延 / 掉频）——对齐 G4（无幻影期待）与 pillar 4。
- **反馈类与 hit_results 因果绑定（S2 落实）:**
  - 攻击反馈类（打击特效 / 伤害数字 / 击杀确认）**仅当 `hit_results` 非空时 emit**；
  - 反馈类**绝不独立于命中结果产生**（no-target 周期零命中反馈）；
  - `feedback class` 记录为 Systems §5.2 未来字段，与 `hit_results` 显式绑定（UX-INPUT §3.1）。
- **分支可辨（S3 落实）:** 空场周期与命中周期通过「无命中反馈 + （可选）明确 no-target 提示」区分——玩家不会把空枪误读为「对一个真实目标的 miss」，也不会期待后续命中（G4）；区分手段本身为 `team_proposal / unresolved`（Systems §5.2）。

### 4.3 与 cr-004 联动（失效后 no-target）

- 若锁定后目标被移除/失效导致候选集清空或在解析中无合法命中：**不产生与真实命中不可区分的反馈**（UX-INPUT §3.1 cr-004 联动 / U3-C）；失效目标不得被当作有效命中（Systems §5.1-6）。quiet cycle 的「无命中反馈」原则在此同样适用。

### 4.4 记录字段与 tick 表达（对齐 TC-INPUT / Systems §5.2）

- `no_target_branch`（true/false）、`branch_id`、`input state`、`timer_effect`（不得隐藏惩罚）、`feedback class`、`next_eligible_fire_tick`（以 tick 值入 trace；节奏形态归 Systems/UX，机制层只约束其 tick 表达——TC-INPUT §2.5）。
- 相邻 future fire 点的计算（以 tick 为单位的 next eligible fire point）由 Systems 给语义（周期照常推进）、Tech 落实 tick 计数；具体周期数值为候选，走 ledger。

### 4.5 升级触发条件（needs_user_decision 标注）

- 若所选 quiet cycle 形态**触碰产品承诺**（例如：把「自动攻击始终可见」改写成「攻击可被省略 / 静默跳过」，或使 no-target 体验变成玩家不可读的空转）→ 按 CR 台账 §3 cr-005 行 + CARD DC-SYS-01 §5，**升级 `needs_user_decision`**，交由用户亲自裁决；本提案在遇此情形即停并标注触发条件。
- **本提案未触此升级**：quiet cycle 保留自动攻击循环照常推进，「攻击始终可见」未被改写（仅空场不伪造命中反馈）；但仍为 `team_proposal`，须经 UX-03 观察 + 评审确认后才非升级。

### 4.6 影响 / 风险+回滚 / Ledger / fixture / QA 衔接

- **产品:** 自动攻击循环可读（quiet 不惩罚 pillar 4）；S1–S3 对齐 → 无幻影期待（G4）。
- **创意:** 无新承诺；不产生「空打」奇观。
- **技术:** 机制层只约束 tick 表达与 `next_eligible_fire_tick`；反馈发射仅在 `hit_results` 非空（S2 机制落实归 Tech/Engineer）。
- **范围:** 不新增反馈系统承诺；在已确认 no-target 边界内。
- **进度:** 解锁 `TARGET-no-target` / `TARGET-out-of-bound` / UX-03 场景（U3-A..D）定型。
- **风险 / 回滚:** 误导性命中反馈违反产品边界（风险最高）；缓解 = S1–S3 三管齐下 + fixture/trace；回滚 = 撤拒绝命反馈类 + 回归 quiet cycle，成本低（无数值承诺）。
- **Ledger 行:** 周期节奏/提示时长若引入数值，全部走 PRECHARTER-04（range+starting_point；promotion_authority=User；未锁常数）。
- **Fixture 衔接（TARGET-*）:** `TARGET-no-target`（刷新空合法集 → `no_target_branch=true`、无伪造目标、`next_eligible_fire_tick` 记录）；联动 `TARGET-removal`（失效致空）。
- **QA 衔接:** UX-03 行 `not_run / not_ready` — S1/S2/S3 场景矩阵（U3-A 空 refresh 确定性分支 / U3-B 邻接边界目标 / U3-C 锁定后移除 / U3-D 连续 no-target 节奏）命中后独立 QA 观察（B3 证据完整性）。

---

## 5. 三份提案汇总（Provenance 分层与不变量保留）

### 5.1 分层声明

- **`user_confirmed`（仅引用，不新增）:** 22 项原始决策（含 #3 pre-fire 刷新+锁定、#6 独立弧计数、#15–16 hint、#18–19 可读性/可访问性边界）；revision-02 #4（refresh→stable-sort→lock）；PRECHARTER-02 / -04；cr-001（Option A，R09 决策引用）；DC-PLAT-01/02、DC-ARCH-01、DC-PERF-01、DC-ACC-02、DC-REL-01、DC-PLAY-01（R01–R08 决策引用）；AUTH-01。本合集不重写、不重分类任何一项。
- **`team_proposal`（本合集全部实质建议）:** cr-002 的 M-1 距离度量 / 量化桶 / tie-break 形态；cr-004 的命名 drain 点事件排序 / 二选一语义 **(ii) 推荐（v0.2，终裁对齐）** / trace 字段；cr-005 的 quiet cycle 形态 / 反馈类与 hit_results 绑定 / S1–S3 落实。全部需评审 + 证据，未获批准。
- **`assumption`:** 确定性排序保持可读（G1/G3 期望需观察）；玩家可感知 clufe 中心 / 两级键；quiet cycle 不损害自动攻击可见性；失效 drain 点可 headless 实现。均需未来观察，未观察前不成立。
- **`unresolved`（全量保留，未关闭）:** cluster members / metric 数值与单位 / quantization 桶宽精确值 / tie-break 可读性语义 / stable-ID 生命周期细节 / invalidation **drain 实现细节** / no-target cycle 精确周期 / B2 弧序 / tick 频率——**cr-002 / cr-004 / cr-005 均保持 `unresolved`**（absorb 路径进行中），直至证据 + 评审。本合集未把任何一项升级。（注 v0.2：失效语义的 **(i)/(ii) 二选一本身**已由 `SEMANTICS_INVALIDATION_FINAL_v0_1.md` 终裁决为 (ii)，本提案推荐随之对齐；但 invalidation 的**命名 drain 点实现细节**与其余 unresolved 项仍保留，未闭合。）

### 5.2 不变量保留声明

22 项 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本合集未改动上述任何一项；未把任何 `team_proposal` / `assumption` / 候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升。

### 5.3 cr-002/004/005 保持 unresolved 的明确标注

- **cr-002 / cr-004 / cr-005** 当前 disposition = `absorb_within_authority`（R09）——本合集给出**提案/实验形态**（ledger、fixture、机制语义输入），**不是批准、不是 closure**；它们保持 `unresolved`，直到：① 证据（TARGET-* fixture + seed 复现 + QA Gate 2 观察）产生；② 相应评审/决策（若触承诺/键序等 → 升级用户）推进。本合集不替用户做任何最终规则裁决。

---

## 6. 边界声明与 Closure

- **未选择规则语义（最终裁决归 User）:** 本合集推荐 M-1 / **(ii)（cr-004，终裁对齐，见 §3.4）** / quiet cycle；cr-002/004/005 仍 unresolved 呈交评审。失效语义 (i)/(ii) 二选一已由 `SEMANTICS_INVALIDATION_FINAL_v0_1.md` 终裁为 (ii)，本提案推荐同步，最终规则裁决仍归 User。
- **未批准/冻结任何合同或 ADR:** Tech/Systems/UX 合同与 ADR-TECH-04/06 均保持 `PROPOSAL / DRAFT / NOT APPROVED`；本合集是语义提案输入，不写死实现。
- **未豁免 QA blocker / 未替 Independent QA 下 verdict:** Gate 2 仍 `not_run / not_ready`；QA 独立观察。
- **未触碰 Godot / 运行时:** 未访问/修改 Godot、代码、场景、资源；未运行、构建、测试、导出、发布；无 runtime/视觉/性能/QA 证据。
- **写入面:** 本文件为本次修订的**唯一写入产物**（原位修订，v0.1 → v0.2）。未修改任何其它文档（终裁书、QA 计划、实现报告、CR 台账、Charter、ADR 等一律未触碰）。
- **未派发任何成员:** 未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

**Closure:** `closure_ready = yes`（仅限本静态提案合集 artifact）。不是 kickoff pass、不是实现授权、不是合同批准、不是验收 verdict。Kickoff 仍 `not_ready`；implementation 仍 `NOT_AUTHORIZED`；Gate 2–6 仍 `not_run / not_ready`。

---

## 7. 版本与变更记录

- **v0.1:** Systems / Rules Designer 唯一新产物；三份提案（cr-002 / cr-004 / cr-005）合集，全部 `absorb_within_authority` + PRECHARTER-04 ledger 形态。
- **v0.2（本文件，2026-08-16 · cr-004 推荐同步）:** 失效语义已由 `SEMANTICS_INVALIDATION_FINAL_v0_1.md` **终裁为 (ii)**。本提案据此**原位修订**：① §3.4 推荐自 (i) 改为 **(ii)**（确定性合法性谓词 + 命名 drain 点 + 快照 ID 集不可变 + 只读解析不重定位），同步表格与「Systems 语义建议」段落为终裁语义，并标注终裁来源；② §3.6 Fixture/QA 衔接行同步对齐（`TARGET-removal` X 无命中 / `invalidation_event` 带 tick / 快照 ID 集不变 / `no-hit-invalid`）；③ 文件级注记 + §5.1/§6 相关行同步。cr-002（M-1）与 cr-005（quiet cycle）内容**保持不变**；未触碰其它文档。提案属性仍 `PROPOSAL / TEAM_PROPOSAL / DRAFT / NOT APPROVED`；cr-002/004/005 仍 `unresolved` 直至证据 + 评审。
