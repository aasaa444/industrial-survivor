# DC-SYS-01 TECH LEAD INPUT v0.1 — Target 语义原则：机制与确定性字段输入（TC-INPUT）

> **TC-INPUT — Tech Lead 机制 / 确定性字段输入小节，供 DC-SYS-01 决策卡（cr-001，Batch 3）引用**
>
> **Status:** `INPUT / PROPOSAL / NOT A DECISION / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`。
>
> **性质声明：** 本文件是 Tech Lead 按 CR §7/§8 固定结构，为 Systems/Rules Designer 主制备 DC-SYS-01 卡提供的**机制与确定性字段输入**（卡片主产物归 Systems；可读性观察目标输入归 UX；选项与最终规则语义归 Systems + User）。本输入**不选择规则语义、不批准/冻结任何 ADR 或合同、不替用户做产品决策、不豁免 QA blocker、不替 Independent QA 下 verdict**。

## 0. 任务范围、授权与不变量

### 0.1 授权衔接（引用，不重投）

- `AUTH-01`（混合授权包，2026-08-16，`user_confirmed`）：流程层 P1 连续推进 Batch 2 → Batch 3 → DC-ANCH-01；决策层 D1/D2/D3；硬边界四项（实现仍 `NOT_AUTHORIZED`；QA 独立性；父线程边界；候选预算仅候选）。
- `cr-001`：`needs_user_decision`（CR §6/§7：DC-SYS-01，Batch 3 窗口已启用）。候选方向 = `refresh nearest-threat cluster → stable-sort → lock target snapshot`（revision-02 #4；决策 #3 pre-fire 刷新+锁定）。卡片选项内容由 Systems 制备；用户裁决或按 AUTH-01 D 层规则登记，均不由本输入决定。
- `cr-002..cr-005`、`cr-020`：`absorb_within_authority`，依赖 cr-001 选定原则；本输入给出各词条的**机制约束**，供 Systems 卡引用后承接。
- Batch 1/2 已决策（引用，不重投）：DC-PLAT-01 → P1；DC-ARCH-01 → Option A1（**ADR-TECH-01..08 定稿路径已授权启动**，ADR 仍 `PROPOSAL / DRAFT / NOT APPROVED`）；DC-PLAT-02 → Option 2（Balanced）；DC-PERF-01 → Option A（六项候选预算全保持仅候选）；DC-ACC-01 → A2；DC-ACC-02 → B3；DC-REL-01 → O2；DC-PLAY-01 → Option 2。

### 0.2 只读来源（证据类别：static/source only）

1. `docs/architecture/KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（重点：ADR-TECH-03 reproducibility、ADR-TECH-04 target snapshot、ADR-TECH-06 headless seam、§12 decision table）。
2. `docs/creative/KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md`（§4 规则顺序、§5.1 target 簇/排序、§5.3 fixture 字段、§11 QA handoff、§6 CONTACT fixture 矩阵、§13 provenance）。
3. `docs/production/CHANGE_REQUESTS_v0_1.md`（§3 cr-001..005、cr-020；§7 Batch 3；§8.1 R01–R03；§8.2 AUTH-01；§8.3 R04–R08）。
4. `docs/DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（revision-02 #3/#4、PRECHARTER-01..11、22 决策、§10 Gate 0–6）。

未读取任何其它文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未派发任何成员。

### 0.3 写入边界与不变量保留

- 本文件是本次任务**唯一**写入的新产物；未修改任何既有文档（Tech/Systems/UX 合同、ADR、CR 台账等一律未触碰）。
- 不变量声明：**22 项原始 `user_confirmed`**、**恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）**、**PRECHARTER-01..11**、**四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）、**unresolved 全量保留**——本输入不把任何 unresolved 项升级为决策；cr-001 保持 `needs_user_decision / unresolved` 直至用户裁决。候选预算（六项 + `1280×720` 红线）均仅候选，本输入不涉及、不提升。

---

## 1. Expert preflight（按 godot-tech-lead-expert SKILL.md §Expert preflight）

- **Architecture context read：** 上述四份静态输入全部实际读取；无项目代码、无 Godot 项目/GDMCP 状态、无 runtime。
- **Blast radius：** 规则核（rules core）排序/快照/失效子步、session tick/seed/ID 上下文、trace/fixture 证据 schema（ADR-TECH-03/06）、ADR-TECH-04 未决寄存器、Systems §5.1/§5.3 与 §11 QA handoff、UX 可读性观察目标（cr-005）。若排序逻辑泄漏到 adapter/presentation，blast radius 扩散到行为契约与证据链，属 ADR-TECH-01 反模式（第二个规则权威）。
- **Decisions to be made（本输入职责内）：** 机制可行性判定、确定性纪律（排序/ID/锁定失效/tick 时机/seed 复现）、fixture 形状与比较面建议、与 ADR-TECH-04/06 的衔接、风险/成本静态评估。**职责外（不代作）：** 簇成员、度量与量化数值/单位、tie-break 字段的规则语义、no-target 节奏形态（Systems + UX）；最终选项（User）。
- **Assumptions（观测待验，非证据）：** 纯规则 seam 可无引擎实现排序/快照；候选集本身在给定 seed + 输入序列 + 固定 tick 下确定（生成时序确定）；headless fixture 可对纯规则行为做精确比较。
- **Top risks：** 浮点非确定性、容器顺序依赖、stable-ID 复用、锁定后失效语义歧义（“打空气”或误命中）、B2 同步多弧次序歧义、trace/schema 静默不兼容。
- **Required future evidence：** 授权实现后 —— 确定性 fixture（tie/removal/no-target/container-order/float-epsilon/B2 弧序）、seed 复现 trace、QA Gate 2 独立观察。
- **Decision boundary / stop condition：** 机制可行性属 Tech；规则语义归 Systems；最终裁决归 User。若选定原则隐含 no-target、tie 依赖容器顺序、或锁定后目标可未经显式契约改变 → 触发 ADR-TECH-04 stop condition，升级返回（CR §14 / AUTH-01 D2）。本输入在此边界内制备，触碰即停。

---

## 2. 确定性机制输入（对应 cr-001 候选方向的技术可实现性）

### 2.1 总评

**可行性判定：候选方向 `refresh nearest-threat cluster → stable-sort → lock snapshot` 在纯规则核（engine-free）内技术可实现，且可达到容器顺序无关的确定性，前提是满足 §2.2–§2.6 的五项纪律。** 该方向不要求引擎排序 API/容器迭代顺序的任何假设；引擎只通过 adapter 提供规范化后的候选观察记录。

### 2.2 排序算法确定性要求（容器顺序无关性）

1. **全序键链（total order key chain）取代“依赖稳定排序本身”。** 比较器必须按离散键链字典序比较：`k1 = 量化后的 nearest-threat 距离` → `k2 = 量化后的 cluster-center 距离`（PRECHARTER-02 顺序）→ `k3 = stable_id`（唯一）。因 `k3` 全局唯一，键链构成**全序** → 排序结果唯一，与输入/容器顺序无关。**关键理解：仅“stable-sort”不充分**——稳定排序保留等键元素的输入顺序，而输入顺序正是引擎依赖面；“stable candidate ordering/stable ID”（PRECHARTER-02 / ADR-TECH-04）应读作**跨 run 稳定（确定性）**，由全序键链保证，而非保持容器插入序。
2. **不得原地排序、不得排序引擎容器。** 排序在规则的候选**不可变副本**上推导有序 ID 列表（`ordered_ids`）；引擎/live 容器顺序永不作为比较输入。原地 mutation 同时污染其它系统并使等键序依赖容器。
3. **浮点安全。** comparator 禁止浮点相等比较；距离先量化到固定精度整数桶（fixed-scale integer bucket）再入键链。近等距离必须在量化桶相等时落入下一级键（cluster-center 桶 → stable_id），不得用 epsilon 在 comparator 内“判平”。
4. **Comparator 纯净性。** 不读墙钟、不查引擎状态、不读迭代计数/枚举次序、不取全局随机数；比较是候选属性（键）的纯函数。
5. **排序输入本身的确定性前提。** 候选集必须确定：生成调度确定 + 固定 tick 下移动确定 + 移除也是领域事件、在命名 drain 点生效（§2.4）。否则排序确定性无从谈起。

### 2.3 stable-ID（cr-003）分配 / 复用纪律

- **Session 持有、run 作用域的单调分配器**（计数器派生自确定性 seed/序列），不得使用引擎身份（`InstanceID`/`NodePath`/内存地址）作领域 ID——引擎身份跨 run/跨容器不可复现。
- **run 内永不复用；run 间随 run 重置**（与 RNG 重置同一事务边界，见 ADR-TECH-05 reset 候选）。复用历史 ID 是 fixture 比较/证据链污染的经典确定性缺陷。
- **序列化：** snapshot/trace 中 ID 以 `(run_id, id)` 组合出现，随 schema 版本（ADR-TECH-03 config version / ADR-TECH-08 build identity）。
- **生成顺序确定：** 实体生成次序是确定性调度的一部分，使 ID 分配次序跨 run 一致。
- **ID 作最终 tie-break 的语义注记：** 两距离键相等后以 ID 决序保证了全序，但该“次序”对玩家可能是任意的——tie-break 是否有可读语义（cr-002 的 tie-break 字段）由 Systems 定、UX 观察；机制层仅要求最终落到唯一 ID 以保证全序与复现。

### 2.4 快照锁定与失效（cr-004）的事件排序

- **锁定时机：** 在命名规则步边界（pre-fire refresh 子步）内：评估候选集 → 推导 `ordered_ids`（§2.2）→ 锁定本 shot 快照（不可变：有序 ID 列表 + 锁定时刻合法性标记）。
- **解析只读快照：** shot 解析只读其快照，绝不回查 live 实体列表（“不连续 retarget”机制的强制形态）。
- **失效/移除的事件排序：** 锁定后目标失效或移除，必须作为**显式领域事件**在命名点（解析子步起点）排空，绝不允许中途/回调序内生效。失效目标 ⇒ 该 ID 不产生命中、不伪造命中（保留用户边界：“Removed/invalid targets must not be applied as valid hits”，Systems §5.1-6；ADR-TECH-04 高level语义）。
- **机制推荐（规则语义由 Systems 定，二选一须一致并被 trace）：** (i) 解析按锁定时刻合法性标记（快照完全权威——失效在飞行中不可见）；或 (ii) 解析对快照 ID 重新评估**确定性合法性谓词**（移除即失效——与“移除目标不得命中”边界更贴合）。无论哪种，必须是全 run 一致的唯一选择，并在 trace 记录。
- **Trace 必含：** `refresh_tick`、`lock_tick`、`invalidation_event(id, tick)`、`resolution_outcome`（ADR-TECH-04 候选字段 + ADR-TECH-03 trace scope）。

### 2.5 tick 语义（cr-020）下排序评估时机

- **单一固定步评估边界（ADR-TECH-03 候选契约）：** 规则核内所有求值（refresh/sort/lock/resolve/invalidate/terminate）都发生在与 tick 关联的一次规则步内；无墙钟、无引擎 mid-frame 回调渗入规则核。
- **“立即于每次开火前刷新”的 tick 语义：** 开火 = adapter 在 tick 边界入队的领域事件；刷新在该开火事件被处理的同一规则步内、锁定之前执行（符合 Systems §4 规范序：`pre-fire refresh → no-target branch or snapshot lock → ...`）。refresh/lock 时间戳以 tick 值记录，非墙钟。
- **B2 三弧同步（`扇裂` 后）：** 每弧 = 独立 shot = 各自 refresh+lock，弧序固定（先中心、后左右）；**同一步内多弧的中间态语义（“全部按步前态评估” vs “依序中间态”）为开放机制选择**，必须与 Systems 一次定死、单一一致、并被 trace——这是 cr-020 下需要明确记录的机制决定，不由本输入代选。
- **no-target 分支（cr-005）计时：** 分支触发 tick、`next_eligible_fire_tick` 以 tick 值入 trace；节奏形态归 Systems/UX，机制层只约束其 tick 表达。

### 2.6 seed 固定复现（PRECHARTER-01 / ADR-TECH-03）

- **复现等式（候选契约）：** 相同 `config_version` + 相同 `seed` + 相同版本化输入序列 + 相同 build identity ⇒ 逐元素相同的 `ordered_ids`/目标快照/事件序列。排序是确定性状态的纯函数 ⇒ 该候选方向**构造性可复现**。
- **RNG 纪律：** session 持有单一 seed 上下文；随机流命名、定序、有界（ADR-TECH-03）；规则核无全局随机。
- **复现证明形态：** 授权实现后，同 seed 两次 run 的 trace 逐位一致即 fixture 断言（§3）；无 player Replay 承诺（revision-02 #3 边界保留，ADR-TECH-03 stop condition：任何 player-visible Replay 提议 → CR + 用户）。

---

## 3. Fixture 语义输入（配合 ADR-TECH-06 seam 与 Systems §5.3/§11）

### 3.1 Fixture 形状（建议，team_proposal）

| 区块 | 内容（对齐 ADR-TECH-06 seam 输入输出 + Systems §5.3 schema） |
|---|---|
| header | `fixture_id`、`config_version`、`seed`、`tick_budget`、版本化 `input_sequence` |
| initial snapshot | `player_state`；`entities[{stable_id, kind, position(量化), alive, contact_state}]`；`attack_phase`；`timer_before` |
| expected facts | 每条断言给出**显式期望值或显式不变量** + 允许偏差清单；unresolved 阈值标注为 `unresolved`（Systems §11-3） |
| comparison surface | 确定性字段**精确匹配**：`ordered_ids`、`target_snapshot_ids`、`hit_results`、事件序列（含失效事件）；失败类固定为 `exact_mismatch / allowed_nondeterministic / schema_incompatible / missing_evidence`（ADR-TECH-06）× 默认零容差（R07/O2 证据规则：无命名授权偏差即不允许容差） |
| 范围 | 规则 fixture 全部 headless，无视觉/帧断言；run on 授权后的确定性 runner（Gate 2 证据输入，Independent QA 观察） |

### 3.2 目标相关 fixture 族（ties / removal / no-target 如何进入 fixture 设计）

每个 família 固定包含：(a) 精确输入场景；(b) 期望事实为精确值；(c) **容器顺序方差变体**（同场景两种实体插入顺序 → 期望 `ordered_ids` 相同）；(d) trace 断言（失效事件、no-target 分支 ID、ordered_ids、hit_results）。

| Fixture 族（建议名，与 Systems §11-2 矩阵衔接） | 场景 | 期望事实示例（机制层面） |
|---|---|---|
| `TARGET-tie` | 两候选按度量等距 | `ordered_ids` 精确等于键链次序（cluster-center 优先，最终 stable_id 决序） |
| `TARGET-tie-cluster-center` | 距离桶与簇心桶均相等 | 落到 stable_id 决序；跨 run 一致 |
| `TARGET-removal` | 锁定快照含 ID X；解析前 X 被移除 | X 无命中；`invalidation_event` 带 tick 入 trace；快照 ID 集不变 |
| `TARGET-no-target` | 刷新得空合法集 | `no_target_branch=true`；无伪造目标；`next_eligible_fire_tick` 记录 |
| `TARGET-container-order` | 同场景两种插入序 | `ordered_ids` 逐位相同（**关键确定性回归族，Tech 建议新增**） |
| `TARGET-float-epsilon` | 距离落入量化桶内近等 | 两次同 seed run 的排序结果一致（防浮点抖动回归） |
| `B2-arc-order` / `B2-ties` | 三弧同一步各锁一 shot | 弧序固定；各弧 shot 快照与命中独立（决策 #6 独立计数） |

- tie/removal/no-target 是容器顺序依赖与因果可读性风险最高的三类场景（ADR-TECH-04 stop condition / Charter §9 首行风险），故各自成族且强制携带容器方差变体。
- 本清单是 **fixture 提案**，非已执行测试；执行须在实现授权后（当前 `NOT_AUTHORIZED`），由 Engineer 依已批准合约产出，QA/Release 独立观察（Systems §11 handoff 项 2、Charter §10 Gate 2）。

---

## 4. 契约衔接

### 4.1 与 ADR-TECH-04（target snapshot）定稿的关系

- ADR-TECH-04 现为 `unresolved` → **A1 定稿路径中**（DC-ARCH-01 → Option A1，R02，2026-08-16：draft → 跨角色评审 → 依评审逐条进入批准流程；总状态仍 `PROPOSAL / DRAFT / NOT APPROVED`）。
- **DC-SYS-01（cr-001）的裁决将收窄 ADR-TECH-04 §"Unresolved detail register" 的子集：** cluster 定义、metric/quantization、tie-break 字段、stable-ID 生命周期、invalidation timing、no-target 周期、refresh/fire timing。本输入是这些字段的**机制约束来源**；字段的规则语义归 Systems；用户裁决后才写入 ADR 草稿更新（仍经评审方可批准）。
- **Stop-condition 交叉检查：** 任何被选原则若隐含 no-target、tie 依赖容器顺序、或锁定后目标可未经显式契约改变 → ADR-TECH-04 stop condition 命中，走 CR §14 / AUTH-01 D2 升级，不得由实现便利硬化。

### 4.2 ADR-TECH-06 headless seam 下排序的可测性

- **排序必须在规则核，不在 adapter：** adapter 只把引擎观测规范化为候选记录；`refresh+sort+lock` 是规则核纯子步（ADR-TECH-01 契约、ADR-TECH-02 purity）。
- **Seam 形态（提案，非冻结）：** `step(domain_input_envelope, prior_state, tick) → (new_state, events, diagnostics)`，另暴露纯函数 `ordered_candidates(state, params) → ordered_ids` 供 fixture 直接调用。该 seam 可在无渲染场景下调用（ADR-TECH-06 前置提案）→ 排序/刷新/锁定/失效全部 headless 可测，无需 Godot runtime 证据即可比较纯规则行为。
- 满足 tech-lead 原则：**无 headless 测试路径的模块，其设计未完成**；fixture 同时是 QA Gate 2 的独立证据输入（Systems §11-1..5；Charter §10 Gate 2 判定握在 Independent QA，生产者不得自证）。

### 4.3 决策后承接（cr-002..005、cr-020，`absorb_within_authority`）

选定原则后，各词条按本输入承接（全部保持 `team_proposal` 直至证据 + 评审）：

- `cr-002`（metric/quantization/tie-break）：受 §2.2 约束（离散键链、量化桶、stability 由全序保证）。
- `cr-003`（stable-ID 生命周期）：§2.3（Session 分配器、不重用、run 重置、非引擎身份）。
- `cr-004`（失效时机）：§2.4（命名 drain 点、事件含 tick、二选一一致语义）。
- `cr-005`（no-target 节奏）：§2.5 + §3.2（tick 表达；形态归 Systems/UX）。
- `cr-020`（tick 频率/同帧语义）：§2.5（固定步边界；B2 多弧中间态为开放机制决定）；频率若影响产品/性能范围 → 升级用户。

---

## 5. 风险 / 成本（静态工程判断，待项目 Godot 文档复核）

> 以下均为**静态工程判断**，未测量、未实现；引擎版本相关事实（排序/容器迭代保证、量化实现细节）须在授权实现阶段对照项目 Godot 4.7 文档复核（skill honesty boundary：version-sensitive facts 不得凭记忆断言）。

| ID | 风险 | 缓解（§2 纪律） | 验证 | 成本 / 回滚 |
|---|---|---|---|---|
| R1 | 浮点距离跨平台/构建非确定 | 量化桶 + 离散键链；comparator 禁浮点相等 | `TARGET-float-epsilon` + 复现 fixture | 低；回滚 = 撤排序纯函数（规则核内） |
| R2 | 容器顺序依赖渗入排序（原地排序/迭代计数/哈希枚举） | 不可变副本推导 `ordered_ids` + 容器方差变体回归 | `TARGET-container-order` | 低；守恒在规则核 |
| R3 | stable-ID run 内复用/用引擎身份 | Session 分配器、不重用、run 重置（§2.3） | run/reset trace + ID 审计 | 中（涉及 session 状态清点，与 ADR-TECH-05 reset 同事务） |
| R4 | 失效语义歧义 → “打空气”或误命中 | 锁定 + 命名 drain 点 + 事件含 tick（§2.4） | `TARGET-removal` + 同 tick trace | 中（语义一旦由 Systems 定死，改动成本主要在 fixture 重述） |
| R5 | B2 同步多弧中间态语义未定 | 与 Systems 一次定死、单一一致（§2.5） | `B2-arc-order` | 低（纯机制选择，player-visible 影响小） |
| R6 | trace/schema 静默不兼容比较（假 pass） | `config_version` + `schema_incompatible` 失败类 + 零容差默认（R07） | compare 行为契约审计 | 低 |
| R7 | 过度工程（泛型排序框架/ECS 服务化） | 有界候选数（单敌族、单屏）→ 简单键链比较即可；禁止投机抽象（ADR-TECH-01 anti-proposal） | 代码评审 | 低 |

**成本结构（静态）：** 排序/ID/锁定机制本体小（纯函数，数十行级）；主导成本 = fixture 套件（含容器方差与浮点回归族）+ trace/失效事件字段 + QA 审计。**回滚面：** 若排序逻辑严格留在规则核单一 owner，回滚 = 撤排序函数 + fixture，无 adapter/presentation 涟漪；若泄漏至 adapter/presentation（第二规则权威），成本随证据链扩散显著上升。
**性能注记：** 每次开火 O(n log n)（n = 有界候选数）可忽略，非预算风险；六项候选预算与 `1280×720` 红线全部保持**仅候选**（R04 已决，本输入不涉及预算提升）。

---

## 6. Provenance 分层与不变量保留

- **`user_confirmed`（引用，不重投）：** 22 项原始决策（含 #3 pre-fire 刷新+锁定、#6 独立弧计数）；revision-02 #4（refresh → stable-sort → lock）；PRECHARTER-01/-02/-11；AUTH-01；Batch 1/2 决策（P1 / A1 / Option 2 / Option A 等）。
- **`team_proposal`：** 本输入全部机制建议（键链全序、量化桶、ID 分配纪律、失效 drain 点、tick 表达、fixture 族、seam 形态）与 §3/§4 提案。
- **`assumption`：** 确定性排序保持可读；纯 seam 可 headless 实现；候选集在 seed+输入序列+固定 tick 下确定。
- **`unresolved`（全量保留，未关闭）：** cluster 成员；metric/quantization 数值与单位；tie-break 字段规则语义；stable-ID 生命周期细节；invalidation timing；no-target 节奏形态与周期；refresh/fire timing；B2 同步多弧中间态；tick 频率。—— 本输入未把任何一项升级。
- **不变量保留声明：** 22 / 8+1（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量保留——全部维持原状；`cr-001` 保持 `needs_user_decision / unresolved` 直至用户裁决；ADR-TECH-01..08 与 Tech/Systems/UX 合同保持 `PROPOSAL / DRAFT / NOT APPROVED`。

---

## 7. 边界声明与 Closure

- 未选择规则语义（归 Systems + User）；未批准/冻结任何 ADR 或合同；未豁免 QA blocker；未替 Independent QA 下 verdict；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未派发或扩展任何成员；未修改任何既有文档。
- 候选预算状态未变更（全保持仅候选）。
- **Closure：** 本文件作为 **TC-INPUT 静态输入小节** closure-ready（供 Systems 卡引用、供父协调器装配 Batch 3 / DC-SYS-01）；**卡片裁决、ADR-TECH-04 定稿、最小确定性核心 seam 契约冻结、实现授权均为未授权/后续事件。**

---

### 附：如何被 Systems/Rules 主制备引用

- DC-SYS-01 卡「选项·技术影响/风险」行可引用 §2（机制可实现性 + 五项纪律）、§4.1（ADR-TECH-04 stop-condition 交叉检查）、§5（风险/成本）。
- 卡「决策后验收标准」行可引用 §3.2 fixture 族 + §4.2 headless seam 形态 + Systems §11 QA handoff，作为 Gate 2 证据计划输入。
- 本输入不代填卡内任何选项内容、不提供专业推荐之外的裁决；最终选项与规则语义呈交 Systems 组装 + 用户裁决/登记。