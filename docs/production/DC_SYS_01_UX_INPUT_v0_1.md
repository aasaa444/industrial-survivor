# DC-SYS-01 — UX/UI Input：可读性观察目标输入 v0.1

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`
>
> **Artifact type:** UX 输入小节（决策卡输入端），**非主产物**。供 Systems/Rules Designer 主制备 `DC-SYS-01`（cr-001 Target 语义原则）时引用。
>
> **标注：`UX-INPUT`，供 DC-SYS-01 卡引用。本输入不替 Systems 选规则语义、不替用户做决策。**
>
> **Evidence class:** `static/source` only。本文件不包含 runtime / visual QA / usability / accessibility / performance / export / release 证据，也不声称任何此类证据。

---

## 0. 专家能力加载与实际工具顺序（真实记录）

- **角色专家 Skill:** `godot-ux-ui-expert`，解析路径 `C:\Users\User\.agents\skills\godot-ux-ui-expert\SKILL.md`。
- **加载等级:** `static_skill_load`（本会话运行时未暴露 `tools.skill` / `skill` 工具接口，依任务允许的回退链直接读取精确 Skill 文件；已完整读取 102 行并在本输入中应用其职位边界、反模式与证据契约）。
- **实际工具顺序:** ① read `SKILL.md`（static_skill_load）→ ② 并行 read UX 合同 / Systems 合同 / CR 台账 → ③ read CR 台账续段（§8.2 AUTH-01 完整）+ 并行 read Charter 草案 → ④ read Charter 尾部 → ⑤ write 本输入文件。
- **本任务未调用** `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

## 1. 专家 preflight（godot-ux-ui-expert，应用于本输入）

- **目标玩家/上下文:** PC-first 单人玩家进入一个 8 分钟有界 Slice；关键旅程为「移动 → 下一次自动攻击可归因 → 清理/空间恢复 → 下一决策」。
- **关键理解风险:** 移动可能被读成单纯闪避而非攻击控制（UX 合同 §1.2）；目标排序若依赖玩家不可感知的度量则「下一发打谁」不可归因；no-target 若反馈误伪造命中则违反产品边界。
- **目标窗口/输入条件:** 16:9 基线 + {16:9, 16:10, 21:9} 方向性支持承诺候选；键盘 WASD/方向键（DC-PLAT-02 Option 2 / R03，已决策引用）；最小分辨率红线 `1280×720` **仅候选**。
- **范围内状态:** combat / no-target / entry-hint / 结果与重试路径中与 target 语义相关的全部状态（UX 合同 §3 矩阵对应行）。
- **证据路线:** 未来授权的 fixture + runtime trace + QA 独立观察（UX-02/UX-03，`not_run / not_ready`）；本输入仅提供静态可观察性要求与观察目标方案。
- **所有权边界:** UX/UI 提供玩家可观察性要求与观察目标；Systems 拥有规则语义提案；Tech 拥有机制/确定性字段；QA/Release 拥有独立验收；用户拥有产品裁决。
- **停止条件:** 止于本静态输入。未访问 Godot/代码/场景/资源；未运行、构建、测试、导出、发布；未批准或冻结任何合同。

## 2. 可读性观察目标输入（cr-001：对 Target 语义原则的玩家可观察性要求）

### 2.1 必须可读的因果链

按 UX 专家工作流「player goal → affordance → action → feedback → next decision」展开，Target 语义必须支撑玩家读到以下链条（与 Systems 合同 §2 causal loop 对齐）：

```text
移动（输入）→ [pre-fire refresh 重建威胁簇/候选] → [stable 排序 → 锁定本发快照]
→ 攻击执行（不中途重定位）→ 首击/命中/清屏结果 → 空间恢复或危险变化 → 下一决策
```

四个须可观察的节点：

| 节点 | 玩家必须读到 | 对应证据面 |
|---|---|---|
| N1 移动→目标变化 | 两次攻击之间，因移动造成簇构成/排序变化时，**下一次**攻击的优先级随之改变且可归因于该移动 | UX-02（movement trace + attack trace） |
| N2 目标→攻击 | 锁定的快照按锁定执行（无飞行中重定位），飞行方向/优先级在刷新时点即可预期 | 确定性 trace（candidate_ids / ordered_ids / target_snapshot_ids） |
| N3 攻击→结果 | 首击目标在命中/击杀反馈层级中可见（UX 合同 §6.2 第二读）；命中反馈短且分层 | before/impact/after 帧 + hit_results |
| N4 结果→空间 | 清屏回收可移动空间，移动因果兑现为路径恢复（UX 合同 §8、§9 UX-02） | 前后帧 + clearing 对比 |

### 2.2 观察目标（可观察信号，非阈值）G1–G4

以下为 UX 建议的观察目标：**可观察信号 + 证据形态**，不设定任何数值/阈值（阈值均 `unresolved`，若未来提升为 Gate 判据须 CR + 用户批准，见 §4.4）。

- **G1 稳定可重复性（stable reproducibility）:** 相同场景 + 相同移动输入 + 相同 seed → 多次运行产生相同 `ordered_ids / target_snapshot_ids` 与相同的首击优先级。玩家侧表现为行为一致（同一站位与移动，攻击优先级可预期）。**UX 约束的实质主张:** 排序不得依赖隐藏的容器顺序；tie-break 必须落到玩家可推断或至少可审计的稳定字段（对应 cr-002/003 的确定性命中面）。证据：UX-02 重复运行 trace 对比。
- **G2 移动引发目标变化（movement-caused change）:** 当移动改变了簇构成或排序时，下一次攻击（一个攻击周期内）的优先级发生变化；当移动未改变簇时优先级不变（对照组）。证据：确定性 fixture 对（移动前/移动后），tick 对齐的 movement trace 与 attack trace。
- **G3 感知威胁对应（perceived-threat correspondence）:** 首击/优先命中目标须与玩家空间读出的「最近威胁簇中心」一致；若 tie-break 或度量语义导致不一致，该 mismatch fixture 必须显式记录（该排序不可感知部分付出的可读性税，需由 hint/反馈补偿）。证据：G3 mismatch fixture 清单 + QA 观察。
- **G4 无幻影期望（no-phantom expectation）:** 空场 no-target 周期后，玩家不因期待命中而回探空区（行为轨迹可观察）。这是 UX-03 在行为侧的可观察面（详见 §3）。

### 2.3 候选规则影响面对比（UX 视角影响面；非代选）

> 按任务边界：本输入**只分析各候选方向对可读性的影响面**，由 Systems 主制备负责规则语义提案与唯一专业推荐，由用户在 DC-SYS-01 上裁决。

| 候选方向（占位描述） | 可读性影响面（UX 视角） | 观察目标适配性 | 风险 / 需支付的 UX 成本 |
|---|---|---|---|
| 确认 revision-02 #4 候选：nearest-threat cluster → stable-sort → lock 快照 | 与 G1–G3 天然对齐；锁语义利于归因（N2）；簇中心概念符合玩家「威胁团块」空间直觉 | 高：可直接生成 UX-02/UX-03 所需 fixture 类型 | 簇度量若玩家不可感知 → G3 mismatch；tie-break 若不稳定 → G1 破坏；需 hint（§5）与分层反馈补偿 |
| 替代：朝向/扇形选目标 | 移动因果最显性（移动≈改变选择），但引入「朝向」概念（不在已确认合同内），与「nearest threat」承诺可能冲突；玩家需追踪额外状态 | 中：G2 易读，G3 可能转移为「朝向 vs 威胁」双读 | 认知负担上升（pillar 5 低认知选择风险）；若入合同需 CR 评估（不在本输入范围） |
| 替代：簇内随机选择 | 破坏 G1（不可重复）与 G2（移动不可归因）；与 pillar 2「移动影响下一次自动攻击」直接冲突 | 低：无稳定 fixture 可生成 | UX 侧强烈风险信号（影响面声明）——因果链 N1 不可读 |
| 替代：威胁权重合成 | 需可见的「威胁权重」概念才可归因，否则排序不可观察 | 低–中 | 认知负担/额外 HUD 需求风险（pillar 5） |
| 替代：推迟待 ADR（Defer） | UX-02/03 观察目标悬挂为 `not_run / not_ready`；最小确定性核心 seam 契约冻结依赖 cr-001 先定（CR 台账 §7 批次逻辑） | 暂不可用 | 时间/排程滑移风险；由 Tech/Producer 评估 |

## 3. no-target 反馈形态输入（UX-03：安静且不误导）

### 3.1 安静/不误导如何成为观察目标（cr-005 联动）

UX-03 行（`not_run / not_ready`）要求 no-target 分支「quiet and non-misleading」。UX 将之操作化为三个**可观察信号**：

- **S1 无伪造目标:** 空 refresh 时不产生锁定指示/目标标识/瞄准框（「No fabricated target or misleading lock indicator」——UX 合同 §3 no-target 行；Systems §5.1 规则 5：never invent a target）。
- **S2 无伪造命中:** hit/kill 反馈类（打击特效、伤害数字、击杀确认）**仅在 `hit_results` 非空时 emit**。绑定 Systems §5.2 的未来记录字段 `feedback class`：反馈类必须依赖合法的命中结果，绝不独立于命中结果产生。
- **S3 分支可辨:** no-target 周期与命中周期可区分——玩家不会把空枪误读为「对一个真实存在目标的 miss」；也不会期待后续命中。区分手段（克制性状态提示等）本身为 `team_proposal / unresolved`（Systems §5.2），UX 在此仅规定可观察要求：**区分必须存在、且不得以伪造命中为代价**。

### 3.2 quiet cycle 形态建议（team_proposal，非批准）

- **quiet cycle 建议形态:** 攻击周期照常推进（节奏不被惩罚，对应 pillar 4 非惩罚节奏），但空场上不出现命中火花/伤害数字/击杀确认；可选一次性、非色彩的克制性「无目标」状态提示（非颜色通信——UX 合同 §7）。**任何与真实命中不可区分的反馈都是违规**（禁止幽灵命中）。
- **记录字段对齐（引用 Systems §5.2）:** 未来 no-target 记录须含 branch ID、input state、timer effect、feedback class、next eligible fire point；UX 输入补充：`feedback class` 必须与 `hit_results` 因果绑定（S2），timer effect 不得产生隐藏惩罚（安静 ≠ 拖延）。
- **cr-004 联动:** 锁定后目标被移除/失效的分辨（removal fixture）不得产生与真实命中不可区分的反馈；移除目标不得被当作有效命中（Systems §5.1 规则 6 边界）。
- **升级判定（引用 CR 台账 §3 cr-005 行）:** cr-005 当前 `absorb_within_authority`（Systems 提案形态 → UX 观察目标 UX-03）；若选定形态触碰产品承诺（如「自动攻击始终可见」被改写成「攻击可被省略」），按台账规则升级 `needs_user_decision`。

## 4. 观察目标与 UX-02/UX-03 绑定（选定后证据行覆盖）＋ Gate 3 证据收紧（B3）完整性

### 4.1 绑定声明

本输入**不修改** UX 合同证据矩阵（UX-01..13 行仍 `not_run / not_ready`，UX 合同保持 `PROPOSAL / DRAFT / NOT APPROVED`）。以下为**供 DC-SYS-01 卡引用的证据行覆盖建议**：用户经 DC-SYS-01 选定原则（→ cr-001 记 `user_confirmed（决策引用）`）后，依选定语义固化下列场景（建议作为 card 的「批准后验收标准」输入；最终行更新由未来 UX 合同修订流程完成）。

### 4.2 UX-02 应覆盖的状态 / 输入序列 / 帧（场景矩阵建议）

| 场景 | 覆盖的观察目标 | 输入序列/状态 | 帧覆盖 |
|---|---|---|---|
| U2-A 相同场景重复 | G1 稳定可重复性 | 同 seed + 同移动序列，运行 ≥2 次 | ordered_ids/target_snapshot_ids 对比（trace），无需逐帧 |
| U2-B 移动改变簇构成/排序 | G2 移动引发目标变化 | 移动使目标入簇/出簇或重排 → 下一次攻击优先级变化 | 移动前帧 → pre-fire 刷新前最后一帧 → 攻击帧 → 结果帧（before/impact/after） |
| U2-C 移动无簇变化（对照） | G2 反例 | 移动但簇构成/排序不变 → 优先级不变 | 同上对比，证明无变化可归因 |
| U2-D 簇中心最近威胁首击 | G3 感知威胁对应 | 标准威胁布局，选簇中心最近目标 | 首击命中帧 + hit_results 顺序 |

字段要求（对齐 UX 合同 §9 与 Systems §5.3/§11）：fixture/seed、movement trace、attack trace（candidate_ids/ordered_ids/target_snapshot_ids/hit_results）、before/after 帧引用、observer、verdict。

### 4.3 UX-03 应覆盖的状态 / 输入序列 / 帧（场景矩阵建议）

| 场景 | 覆盖的观察目标 | 输入序列/状态 | 帧覆盖 |
|---|---|---|---|
| U3-A 空 refresh 确定性分支 | S1/S2 | 确定性空场 fixture → no-target 分支 | trace（no_target_branch=true）+ 分支帧/log 引用；反证无锁指示/无命中反馈 |
| U3-B 邻接边界目标 | S1/S3 | 目标恰在簇边界外（相邻）→ 正确进入 no-target | 边界布局帧 + trace；不得出现误导性锁定 |
| U3-C 锁定后目标移除 | S2（cr-004 联动） | 射击中目标被移除/失效 | removal trace + 反馈类记录（无幽灵命中） |
| U3-D 连续 no-target 周期节奏 | S3 + pillar 4 | 连续数个空场周期 | timer effect 前后对比（无隐藏惩罚）+ 反馈类时间线 |

### 4.4 Gate 3 证据收紧（B3，已确认决策引用）下的完整性要求

- **引用** DC-ACC-02 → Option B3「证据收紧」（cr-114，R06，`user_confirmed（决策引用）`）：Gate 3 证据接受阈值 = 严格完整性规则；Charter §10 全部 mandatory 字段齐备才可判定；缺失任何字段 = `not_run`（不是 pass）；静态/Anchor 不可替代 runtime/视觉证据；retest 保留原失败并新增证据 ID。
- **UX-02/UX-03 必填字段清单（建议以本清单为 card 验收标准引用）:** evidence ID；fixture ID；seed；config version；tick（movement/attack trace 对齐）；trace 引用（movement + attack）；candidate_ids / ordered_ids / target_snapshot_ids；no_target_branch；hit_results；before/after 帧引用；build identity；observer；timestamp；verdict；unresolved deviations；retest linkage。
- **阈值纪律:** 本输入全部观察信号均为定性可观察目标，**不设数值/阈值**；任何观察阈值若未来写入 Gate 3 判据/发布判据 → 须 CR + 用户批准（D2 升级类判定 / 候选预算纪律，AUTH-01 §8.2.3–8.2.4；`1280×720` 等候选红线同理保持仅候选）。

## 5. §6.3 causal movement hint 与目标锁定的衔接

- **hint 的角色（引用 UX 合同 §6.3 / PRECHARTER-07 / 决策 #15–16）:** hint 教「移动会改变下一次自动攻击的目标选择」（pillar 2「movement affects the next automatic attack」），而非仅宣传操作。
- **与锁定语义的关系:** 在决策 #3（pre-fire 刷新 + 锁定快照）下，hint 教导的因果是：移动改变**下一次**攻击的 pre-fire 簇/排序——**不是**飞行中重定位。hint 不得过度承诺。
- **时点衔接:** entry 出现（UX-01：hint 出现 → 首次有效移动 → 淡出一次/局）；「有效移动」的定义须由 Systems/Tech/UX 联合锚定到**「改变下次 pre-fire refresh 候选或排序」的可观察语义**（而非仅位移距离），否则 hint 承诺的因果可能未发生——hint 淡出时点应与 UX-02 场景（U2-B）的开头对齐。
- **内容一致性依赖:** 若 card 选择替代规则（如朝向制），hint 的教导内容随之变化；hint 文案/本地化/淡出时序仍 `unresolved`（UX 合同 §6.3，不属 cr-001 范围，**本 card 不得冻结 hint 文案**）。
- **观察目标:** 首次有效移动后的一次攻击须可归因（G2 信号）；此要求应作为 UX-01/UX-02 证据行联动输入。

## 6. 供 DC-SYS-01 卡引用的要点索引

1. 可读性观察目标 G1–G4（§2.2）与因果链节点 N1–N4（§2.1）——属玩家可观察性要求，**不代选规则**。
2. 候选规则影响面对比表（§2.3）——UX 视角影响面，标注为 `team_proposal` 影响分析；规则语义提案与专业推荐归 Systems 主制备。
3. no-target 观察目标 S1–S3 与 quiet cycle 形态建议（§3）——绑定 UX-03 与 cr-005；反馈类必须与 `hit_results` 因果绑定。
4. UX-02/UX-03 场景矩阵与 B3 完整性清单（§4）——选定原则后方可固化为证据行；card 批准后验收标准可引用本清单。
5. hint 衔接依赖（§5）——「有效移动」定义需 Systems/Tech/UX 联合；hint 文案不属 cr-001。
6. 任何观察阈值提升为 Gate/发布判据 → 须 CR + 用户批准（§4.4 纪律）。

## 7. Provenance layering、不变量与显式边界声明

### 7.1 分层声明

- **`user_confirmed`（仅引用，不新增）:** 22 项原始决策（含决策 #3 pre-fire 刷新+锁定、#15–16 hint、#18–19 可读性/可访问性边界）；revision-02 #4（candidate 方向）；PRECHARTER-02/07；DC-PLAT-02 Option 2（R03，支持集/缩放/红线仅候选）；DC-ACC-02 Option B3（R06）；AUTH-01（D1–D3/P1–P3/硬边界）。本输入不重写、不重分类任何一项。
- **`team_proposal`:** 本输入全部观察目标（G1–G4、S1–S3）、场景矩阵建议、quiet cycle 形态建议、影响面对比分析、hint「有效移动」锚定建议。全部需相应评审/观察，未获批准。
- **`assumption`:** 可读性期望（相同场景+相同移动 → 相同优先级；玩家可感知簇中心；一周期内归因）需未来观察验证；未观察前不得视为成立。
- **`unresolved`（全量保留）:** 簇定义、距离度量、tie-break、stable-ID 生命周期、失效时机、no-target 节奏与反馈形态细节、hint 文案/时点、观察阈值——均保持 open；沉默不解决。cr-001 保持 `needs_user_decision / unresolved` 直至用户在 DC-SYS-01 上裁决。

### 7.2 不变量保留声明

22 项 / exactly 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量——本输入未改动上述任何一项；未把任何 `team_proposal` / `assumption` / 候选数值升级为 `user_confirmed`。

### 7.3 显式边界声明

- **未选择规则语义:** 本输入不替 Systems 选簇/排序规则，不替代 Systems 的规则提案与唯一专业推荐；card 选项与专业推荐由 Systems 主制备装配。
- **未做用户决策:** 本输入不替用户裁决 DC-SYS-01；cr-001 保持呈交用户。
- **未批准/冻结任何合同:** UX/Systems/Tech 合同、ADR、cr 台账均未修改（本任务仅新增本输入文件）；不豁免 QA blocker；不替 Independent QA 下 verdict。
- **未触碰 Godot/运行时:** 未访问/修改 Godot、代码、场景、资源；未运行、构建、测试、导出、发布；无 runtime/视觉/性能/QA 证据。
- **写入面:** 仅新增 `docs/production/DC_SYS_01_UX_INPUT_v0_1.md`，未修改任何既有文档。

## 8. Closure status

- **Artifact status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`（UX 输入小节）。
- **Closure-ready:** `yes`（仅限本静态 UX 输入）；不是 kickoff-ready / acceptance-ready verdict。
- **Next handoff:** 父协调器将本输入与 Systems 主制备、Tech 机制输入装配为 DC-SYS-01 选项卡呈交用户；批准后按 §4 建议固化 UX-02/UX-03 证据行（届时走 UX 合同修订流程与独立 QA 观察）。