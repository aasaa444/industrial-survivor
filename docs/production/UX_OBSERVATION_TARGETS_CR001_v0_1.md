# UX OBSERVATION TARGETS — CR-001 (UX-02 / UX-03) v0.1 观察目标固化详单

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`。
>
> **Artifact type:** UX/UI 唯一新产物——依**已决 cr-001（R09，Option A）**将 UX 合同 §9 **UX-02 / UX-03** 两行的「future observation target」固化（证据类、所需字段、`not_run / not_ready` 状态）。**观察目标固化 ≠ 观察执行**；Gate 3 仍 `not_run / not_ready`。
>
> **Evidence class:** `static/source` only。本文件不包含 runtime / visual QA / usability / accessibility / performance / export / release 证据，也不声称任何此类证据。

---

## 0. 专家能力加载与实际工具顺序（真实记录）

- **角色专家 Skill:** `godot-ux-ui-expert`，解析路径 `C:\Users\User\.agents\skills\godot-ux-ui-expert\SKILL.md`。
- **加载等级:** `strong_member_skill` —— 首选实证：本会话**实际调用 `skill({ name: "godot-ux-ui-expert" })` 成功**，运行时返回完整 SKILL 指令内容（非仅凭函数清单判断、非伪报不可用）。按 DSH 实测纪律（2026-08-16），skill/tools.skill 均可能「未列入 schema 但实际可调用」，故必须以实际调用验证；本会话 `skill` 接口实测成功。
- **实际工具顺序:** ① `skill("godot-ux-ui-expert")`（strong_member_skill，成功）→ ② 并行 read `KICKOFF_UX_UI_CONTRACTS_v0_1.md` / `DC_SYS_01_UX_INPUT_v0_1.md` → ③ 并行 read `PROPOSALS_CR002_004_005_v0_1.md` / `CHANGE_REQUESTS_v0_1.md` → ④ read `CHANGE_REQUESTS_v0_1.md` 续段（§8.2 AUTH-01 + §8.4 R09）→ ⑤ edit（UX 合同 §9 UX-02/UX-03 行）→ ⑥ write（本详单文件）→ ⑦ read 回读核验两处产物。
- **本任务未调用** `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

## 1. 专家 preflight（godot-ux-ui-expert，应用于本固化任务）

- **目标玩家/上下文:** PC-first 单人玩家进入 8 分钟有界 Slice；关键旅程为「移动 → 下一次自动攻击可归因（pillar 2）→ 清理/空间恢复 → 下一决策」。
- **关键理解风险:** 移动可能被读成单纯闪避而非攻击控制（UX 合同 §1.2 / UX-INPUT N1）；no-target 若误伪造命中则违反产品边界（UX-INPUT S2 / Systems §5.1 规则 6；cr-004 禁令）。
- **目标窗口/输入条件:** 16:9 基线 + {16:9, 16:10, 21:9} 方向性支持承诺候选（DC-PLAT-02 Option 2 / R03）；键盘 WASD/方向键；最小分辨率红线 `1280×720` **仅候选**。
- **范围内状态:** combat movement-to-attack / no-target / entry-hint / 空间清理与结果（UX 合同 §3 对应行；本次仅固化 UX-02/UX-03 两行）。
- **证据路线:** 未来授权的 fixture + runtime trace + 独立 QA 观察；UX-02/UX-03 保持 `not_run / not_ready`，本任务仅固化其观察目标描述。
- **所有权边界（不代权）:** UX/UI 固化「未来观察目标」（证据类/字段/观察信号）；Systems 拥有规则语义提案（cr-002 M-1 / cr-004 (i) / cr-005 quiet cycle 均为 team_proposal，非批准）；Tech 拥有机制落实；QA/Release 拥有独立验收；用户拥有产品裁决。本任务**不代 Systems 定规则语义**、**不替 QA 下 verdict**。
- **停止条件:** 止于本静态固化。未访问/修改 Godot、代码、场景、资源；未运行、构建、测试、导出、发布；未批准或冻结任何合同；未豁免 QA blocker。

## 2. cr-001 Option A 作为固化基准（决策引用，不重投）

- **cr-001 已决 = Option A（R09，provenance = `user_confirmed`（决策引用））:** `pre-fire refresh nearest-threat cluster → stable-sort → lock that shot's target snapshot`；**键序 = 最近威胁 → 簇中心距离 → 稳定排序/稳定 ID**。
- 语义原则已固化，但 **exact cluster membership / metric / quantization / tie-break 字段 / stable-ID 生命周期 / 失效·时点保持 `unresolved`**，移交 cr-002..005 由对应角色 `absorb_within_authority` 提案 + fixture 验证。
- 本详单的职责边界：**把这些已决/提案衔接进 UX-02/UX-03 的可观察信号与证据字段**，不选择规则语义、不动摇 cr-001 已确认语义、不提升任何候选数值。

## 3. UX-02 观察目标固化（movement relates to next automatic attack and clearing）

### 3.1 绑定目标与可观察面

| 观察目标（UX-INPUT） | 类型 | cr-001 Option A / M-1 可观察面 |
|---|---|---|
| **G1** 稳定可重复性 | 稳定排序 | 键序的 stable-order 面：同场景 + 同移动 + 同 seed → 相同 `ordered_ids / target_snapshot_ids`；tie-break 不依赖隐藏容器顺序（M-1 两级离散键 + `stable_id` 全序） |
| **G2** 移动引发目标变化 | 移动因果 | nearest-threat / 簇成员变化面：移动改变簇构成/排序 → 一次攻击周期内优先级变化；移动未改变簇 → 优先级不变（对照组） |
| **G3** 感知威胁对应 | 最近威胁 + 簇中心 | 最近威胁与簇中心面：首击与玩家空间读出的「最近威胁簇中心」一致；两级键边界 / stable_id 决序段可能不可感知 → mismatch fixture 显式记录（可读性税） |
| **G4** 无幻影期望 | （行为侧，供 UX-03 联动） | 空场 no-target 后玩家不因期待命中而回探空区（本文 §4 承接；G4 行为面归属 UX-03 观察） |

- **因果链节点衔接（UX-INPUT §2.1）:** N1（移动→目标变化）靠 UX-02 movement-trace＋attack-trace 对齐；N2（目标→攻击）靠 `candidate_ids / ordered_ids / target_snapshot_ids`（锁定快照）；N3（攻击→结果）靠 `hit_results` + before/impact/after 帧；N4（结果→空间）靠前后帧 clearing 对比。
- **Systems 提案衔接:** cr-002 **M-1（离散键链双标量距离）** 提供两级键（nearest-threat 距离 / cluster-center 距离）+ `stable_id` 决序——即 UX-02 的「最近威胁 → 簇中心 → 稳定序」可观察面。UX-02 只把它当观察信号，**不代 Systems 选/固化 M-1 为批准**（M-1 仍 `team_proposal`）。

### 3.2 场景矩阵（U2-A..D，cr-001 Option A 下固化）

| 场景 | 覆盖的观察目标 | 输入序列/状态 | 帧覆盖 |
|---|---|---|---|
| **U2-A** 相同场景重复 | G1 稳定可重复性 | 同 seed + 同移动序列，运行 ≥2 次 | `ordered_ids/target_snapshot_ids` 跨 run 对比（trace，无需逐帧） |
| **U2-B** 移动改变簇构成/排序 | G2 移动引发目标变化 | 移动使目标入簇/出簇或重排 → 下一次攻击优先级变化 | 移动前帧 → pre-fire refresh 前最后一帧 → 攻击帧 → 结果帧（before/impact/after） |
| **U2-C** 移动无簇变化（对照） | G2 反例 | 移动但簇构成/排序不变 → 优先级不变 | 同上对比，证明无变化可归因 |
| **U2-D** 簇中心最近威胁首击 | G3 感知威胁对应 | 标准威胁布局，选簇中心最近目标（两级键序） | 首击命中帧 + `hit_results` 顺序 |

### 3.3 所需字段（对齐 UX 合同 §9 + B3 完整性；本清单为观察目标字段，非当前证据）

evidence ID；fixture ID；seed；config version；tick（movement/attack trace 对齐）；movement trace；attack trace（`candidate_ids / ordered_ids / target_snapshot_ids / hit_results`）；before/after 帧引用；观察场景标识（U2-A..D）；observer；timestamp；verdict；unresolved deviations；retest linkage。

### 3.4 状态与重测

- **状态:** `not_run / not_ready`（Gate 3 未执行）。
- **重测字段:** 同场景 + 新 build/config identity；保留原失败，新增证据 ID；重观察因果（G1/G2/G3）与空间恢复（N4）。

## 4. UX-03 观察目标固化（no-target quiet and non-misleading）

### 4.1 绑定目标与可观察信号

| 观察目标（UX-INPUT） | 类型 | 衔接（cr-005 quiet cycle / cr-004 (i) / 已确认边界） |
|---|---|---|
| **S1** 无伪造目标 | 无锁指示 | 空 refresh 不产生锁定指示/瞄准框；「never invent a target」（Systems §5.1 规则 5；已确认 `user_confirmed` 引用，非 UX 新增） |
| **S2** 无伪造命中 | 反馈类绑定 | hit/kill 反馈类**仅在 `hit_results` 非空时 emit**、绝不独立于命中结果产生；绑定 cr-004 (i) 快照语义——快照内合法 ID 才产生 hit，失效在下一 pre-fire refresh 被踢出（无幽灵命中）；移除目标不得当有效命中（Systems §5.1 规则 6） |
| **S3** 分支可辨 | no-target 与命中周期可区分 | quiet cycle：周期照常推进、不伪造命中；可选一次性非色彩克制提示（种类本身 `team_proposal / unresolved`）；玩家不把空枪误读为对真实目标的 miss、不期待后续命中（G4） |

### 4.2 连接 cr-004 (i) 快照语义（联动，不代决）

- cr-004 推荐 **(i) 快照完全权威**（Team Systems 提案，`team_proposal` 非批准）：解析只依锁定时刻合法性标记，飞行中失效对本 shot 不可见、在下一 refresh 生效。UX-03 只要求该语义在 UX 可观察面的结果满足 S1/S2/S3（失效目标不产生命中、不伪造命中），**不代 Systems 固化/批准 (i)**。

### 4.3 场景矩阵（U3-A..D，cr-001 Option A 下固化）

| 场景 | 覆盖的观察目标 | 输入序列/状态 | 帧覆盖 |
|---|---|---|---|
| **U3-A** 空 refresh 确定性分支 | S1/S2 | 确定性空场 fixture → no-target 分支 | trace（`no_target_branch=true`）+ 分支帧/log 引用；反证无锁指示/无命中反馈 |
| **U3-B** 邻接边界目标 | S1/S3 | 目标恰在簇边界外（相邻）→ 正确进入 no-target | 边界布局帧 + trace；不得出现误导性锁定 |
| **U3-C** 锁定后目标移除 | S2（cr-004 (i) 联动） | 射击中目标被移除/失效 | removal trace（`invalidation_event(id,tick)`）+ 反馈类记录（无幽灵命中；下一 shot 生效） |
| **U3-D** 连续 no-target 周期节奏 | S3 + pillar 4 | 连续数个空场周期 | timer effect 前后对比（无隐藏惩罚）+ 反馈类时间线 |

### 4.4 所需字段（对齐 UX 合同 §9 + Systems §5.2 未来字段 + B3）

evidence ID；fixture ID；seed；config version；tick（事件对齐）；`no_target_branch`（true/false）；`branch_id`；`feedback class`（须与 `hit_results` 因果绑定，S2）；`hit_results`；`next_eligible_fire_tick`（节奏形态，quiet 不惩罚）；`invalidation_event(id,tick)`（U3-C）；`timer_effect`（不得隐藏惩罚）；trace / 帧 / log 引用；observer；timestamp；verdict；unresolved deviations；retest linkage。

### 4.5 状态与重测

- **状态:** `not_run / not_ready`（Gate 3 未执行）。
- **重测字段:** 重复 no-target 与相邻目标边界用例；保留原失败，新增证据 ID。
- **升级触发标注:** 若所选 quiet cycle 形态触碰产品承诺（如把「自动攻击始终可见」改写为「可省略/静默跳过」）→ 按 CR 台账 §3 cr-005 行 + AUTH-01 §8.2.3 D2 升级为 `needs_user_decision`——本详单采用 cr-005 未触此升级的解读（quiet cycle 保留攻击循环照常推进），但该解读本身仍为 `team_proposal`，须经 UX-03 观察 + 评审确认后方非升级。

## 5. B3（Gate 3 证据收紧，已确认决策引用）完整性字段清单

引用 **DC-ACC-02 → Option B3（cr-114，R06，`user_confirmed（决策引用）`）**: Gate 3 证据接受阈值 = 严格完整性规则；Charter §10 全部 mandatory 字段齐备才可判定；缺失任何字段 = `not_run`（不是 pass）；静态/Anchor 不可替代 runtime/视觉证据；retest 保留原失败并新增证据 ID。

**UX-02 / UX-03 未来必填字段清单**（固化；作为 future observation target 的字段要求，非当前证据）：

`evidence ID`；`fixture ID`；`seed`；`config version`；`tick`（movement/attack 事件对齐）；`fixture_build_identity`（build/digest，revision-02 #3 / cr-112 方向）；`trace` 引用（movement + attack / no-target）；`candidate_ids`；`ordered_ids`；`target_snapshot_ids`；`no_target_branch`；`hit_results`；`next_eligible_fire_tick`；`invalidation_event(id,tick)`（如适用）；`feedback class`（绑定 hit_results）；before/after 帧引用；`observer`；`timestamp`；`verdict`；`unresolved deviations`；`retest linkage`。

**阈值纪律:** 本详单全部观察信号为**定性可观察目标，不设数值/阈值**；任何观察阈值若未来写入 Gate 3 / 发布判据 → 须 **CR + 用户批准**（AUTH-01 §8.2.3 D2；候选预算纪律——六项性能候选 + `1280×720` 红线全部保持仅候选）。

## 6. 与 Systems 提案（cr-002/004/005）的衔接声明

| Proposal | 提案内容 | UX-02/UX-03 衔接 | 边界 |
|---|---|---|---|
| **cr-002 / M-1** | 离散键链双标量距离 + stable_id 决序 | UX-02 最近威胁/簇中心/稳定序三可观察面 | UX 只取为观察信号；不代 Systems 选/固化 M-1（`team_proposal`） |
| **cr-004 / (i)** | 快照完全权威 + 命名 drain 点 | UX-03 S2 / U3-C（失效无幽灵命中、`invalidation_event`） | UX 只要求语义在可观察面满足 S1–S3；不代 Systems 定裁 (i) |
| **cr-005 / quiet cycle** | no-target 节奏与反馈形态 | UX-03 S1/S2/S3 / U3-A..D（quiet 不惩罚、反馈类绑定） | UX 观察执行后验证；不代 Systems 批准形态 |

**三条 Systems 提案全部保持 `team_proposal`、cr-002/004/005 保持 `unresolved`**（absorb 路径进行中直至证据 + 评审）。本详单仅把它们的可观察结果接入 UX-02/UX-03，未批准、未冻结、未替 Systems 定规则语义。

## 7. QA 独立观察要求（future, Gate 3 未执行）

- 未来 Gate 3 由 **Independent QA** 独立观察 UX-02/UX-03 场景（U2-A..D / U3-A..D），独立记录 `observer` / `verdict`，不因本详单自动判定。
- **B3 完整性**：字段齐备才可判定；缺失任何 mandatory 字段 = `not_run`。
- **无自证闭环**：UX/UI 固化观察目标，但不得替 QA 下 verdict、不得豁免 QA blocker。

## 8. Provenance 分层与不变量保留

### 8.1 分层声明

- **`user_confirmed`（仅引用，不新增）:** 22 项原始决策（含 #3 pre-fire 刷新+锁定、#15–16 hint、#18–19 可读性/可访问性边界）；revision-02 #4；PRECHARTER-01/02/06；**cr-001（Option A，R09 决策引用）**；DC-PLAT-02 Option 2（R03）；DC-ACC-02 Option B3（R06）；DC-PERF-01 Option A / DC-REL-01 Option 2 / DC-PLAY-01 Option 2（R04/R07/R08 决策引用，涉阈值/发布/可玩性门边界）；AUTH-01。本文件不重写、不重分类任何一项。
- **`team_proposal`（本文件实质建议）:** UX-02/UX-03 观察目标固化描述（证据类/字段/场景矩阵）；本文 §4.5 / §6 引用的 Systems quiet-cycle / (i) / M-1 均按 `team_proposal` 引用，不代升级。
- **`assumption`:** 可读性期望（同场景+同移动+同 seed → 相同优先级；玩家可感知簇中心/两级键；一周期内归因；quiet 不损害自动攻击可见性）需未来观察验证，未观察前不得视为成立。
- **`unresolved`（全量保留）:** cluster members / metric / quantization / tie-break 字段 / stable-ID 生命周期 / 失效·时点（cr-001 遗留 → cr-002..005）；M-1 两级键桶宽 / (i) 是否选定 / quiet cycle 精确周期与提示形态；hint 文案/时点；观察阈值——均保持 open；**cr-002 / cr-004 / cr-005 保持 `unresolved`**；沉默不解决。

### 8.2 不变量保留声明

**22 项 / exactly 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 / 候选预算（六项 + `1280×720` 红线仅候选）** —— 本文件未改动上述任何一项；未把任何 `team_proposal` / `assumption` / 候选数值升级为 `user_confirmed`。

### 8.3 显式边界声明

- **观察目标固化 ≠ 观察执行：** 本任务只固化 UX-02/UX-03 的「future observation target」描述；** Gate 3 仍 `not_run / not_ready`**；未运行任何 runtime/视觉观察。
- **不代 Systems 定规则语义：** M-1 / (i) / quiet cycle 均为 `team_proposal`，本详单只做观察衔接，未选规则、未批准、未冻结。
- **未批准/冻结任何合同：** UX 合同保持 `PROPOSAL / DRAFT / NOT APPROVED`（仅 §9 UX-02/UX-03 行更新；§13 总状态未动）；Systems 合同、CR 台账、Tech/其它文档均未修改。
- **未豁免 QA blocker / 未替 Independent QA 下 verdict。**
- **未触碰 Godot / 运行时：** 未访问/修改 Godot、代码、场景、资源；未运行、构建、测试、导出、发布；无 runtime/视觉/性能/QA 证据。
- **写入面仅两处：** `KICKOFF_UX_UI_CONTRACTS_v0_1.md`（仅 §9 UX-02/UX-03 行）+ 本详单文件 `UX_OBSERVATION_TARGETS_CR001_v0_1.md`。未修改任何其它既有文档。
- **未派发任何成员：** 未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

## 9. Closure status

- **Artifact status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`。
- **Closure-ready:** `yes`（仅限本静态观察目标固化任务）；不是 kickoff pass、不是实现授权、不是合同批准、不是验收 verdict。Kickoff 仍 `not_ready`；implementation 仍 `NOT_AUTHORIZED`；Gate 3 仍 `not_run / not_ready`。
- **Next handoff:** 父协调器可将本详单与 UX 合同 §9 UX-02/UX-03 行作为 kickoff 就绪评审输入；**观察执行依赖未来实现授权 + TARGET-* fixture + 独立 QA 观察**（届时走正式证据流程）。

---

## 10. 版本与变更记录

- **v0.1（本文件）:** UX/UI 唯一新产物——依已决 cr-001 Option A 固化 UX-02/UX-03 观察目标；与 UX INPUT G1–G4 / S1–S3、场景矩阵 U2-A..D / U3-A..D、B3 完整性字段、cr-002/004/005 提案衔接明确；未修改任何其它文档。
