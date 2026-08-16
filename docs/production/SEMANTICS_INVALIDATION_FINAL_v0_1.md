# SEMANTICS INVALIDATION FINAL v0.1 — 失效语义 (i)/(ii) 终裁裁定书

> **Status:** `RULES SEMANTIC ADJUDICATION / SYSTEMS FINAL RULING / NOT AN ADR / NOT APPROVING ANY CONTRACT OR QA VERDICT`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`（本裁定不改变）；Gate 2 `not_run / not_ready`（本裁定不改变）。
>
> **Artifact owner (sole author):** Systems / Rules Designer（`godot-systems-rules-expert`），cr-004 语义 owner（`absorb_within_authority` 路径）。
>
> **Role:** 规则语义 owner 对 cr-004「失效时机 / 射击中目标移除」的 (i)/(ii) 二选一作**终裁**（语义裁定），消除提案推荐、QA 判据、实现三方的不一致。
>
> **Evidence class:** `static/source` only。本裁定只读来源、只写本文件；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未批准/冻结任何 ADR / 合同 / fixture schema；未豁免 QA blocker；未替 Independent QA 下 verdict；未触碰任何产品承诺（决策 #3 / revision-02 #4）。
>
> **不触碰承诺声明:** 本裁定**不改变、不重写、不重分类**决策 #3「pre-fire refresh + 锁定」与 revision-02 #4「refresh → stable-sort → lock that shot's target snapshot」的已确认方向。裁定仅在二者的已确认边界内，为 cr-004 的失效语义落点做唯一化。

---

## 0. 前置：专家能力加载、来源与边界

### 0.1 专家能力加载（真正工具顺序，实测记录）

- **接口实测顺序（真实记录）:**
  1. `pwsh Get-Content` 读取角色专家 Skill 精确定位文件 `C:\Users\User\.agents\skills\godot-systems-rules-expert\SKILL.md`（`static_skill_load` 备份路径，成功）。
  2. **实际发起调用 `skill({ name: "godot-systems-rules-expert" })`**，**调用成功**，返回完整 SKILL 指令内容（`strong_direct_skill` 等级，首选等级）。
- **能力证据等级:** `strong_direct_skill`——运行时 `skill` 接口确实实测成功返回，非仅凭函数清单判断，非伪报不可用。
- **应用证据:** 本裁定按该 Skill 的专业方法执行——mechanics 以 `player intent -> input -> rule/state change -> feedback -> next decision` 描述；规则语义终裁以「player promise 前的可执行定义」交付；对「锁定语义」「移除不得命中」做一致性核对；诚实边界（不虚报运行时/QA 证据）全程遵守；角色边界（Systems 裁规则语义，不代 Tech 机制实现、不代 UX 观察、不代 QA verdict、不越用户裁决权）严格遵守。

### 0.2 授权衔接（引用，不重投）

- 用户经 `/godot-game-team` 方向 B 选择「先协调失效语义 (i)/(ii)」（即：先定语义，再 QA 验收）。
- 本任务 = cr-004（`absorb_within_authority`）语义 owner 对失效语义 (i)/(ii) 的**终裁**。终裁不触碰承诺 → 不需要用户裁决；若判接触承诺/键序 → 立即标注升级路径（本裁定经核查**未接触**）。
- 已确认事实（仅可使用这些）: 22 项原始 user_confirmed；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；unresolved 全量保留；cr-001（R09 Option A）键序；决策 #3；revision-02 #4；Systems §5.1 规则 6 禁令；cr-004 提案 (i) 推荐 + (ii) 注记；QA 验收计划 TARGET-removal 期望事实；实现（rules_core.gd）(ii)-方向落地 + 张力记录。候选预算仅候选，本任务不涉及。
- **不变量声明（本裁定遵守）:** 22 / 恰好 8+1（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量保留——本裁定未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算未被动用/提升。

### 0.3 只读来源与写入边界

- **只允许读取（已实际读取）:**
  1. `docs/production/PROPOSALS_CR002_004_005_v0_1.md`（§3 cr-004：命名 drain 点 + (i)/(ii) 二选一 + 推荐 (i)）；
  2. `docs/creative/KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md`（§5.1 规则 6 禁令）；
  3. `docs/production/QA_ACCEPTANCE_PLAN_v0_1.md`（§3.4 TARGET-removal 期望事实）；
  4. `docs/production/IMPL_MINIMAL_CORE_v0_1.md`（§4.4/§6：实现按 (ii) 落地 + 红队记录）；
  5. `docs/DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（决策 #3、revision-02 #4、PRECHARTER-02）；
  6. `docs/production/DC_SYS_01_TECH_INPUT_v0_1.md`（§2.4 失效 drain 点机制约束，可选）。
- **唯一写入（本文件）:** `docs/production/SEMANTICS_INVALIDATION_FINAL_v0_1.md`。
- **只读只写边界（明确）:** 本裁定未修改任何其它文档（cr-004 提案、QA 计划、实现代码、CR 台账等一律未触碰；需修订处已在 §6 标注「由对应 owner 执行」）；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未批准或冻结任何 ADR/合同；未豁免 QA blocker；未替 Independent QA 下 verdict。
- **禁止派发:** 本会话未调用 `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。

---

## 1. Expert preflight（按 godot-systems-rules-expert §Expert preflight，应用于本终裁任务）

- **Mission outcome:** 在决策 #3 / revision-02 #4「锁定」已确认边界内，对 cr-004 失效语义 (i)/(ii) 做唯一化终裁，产出一句可执行的一致语义定义，并标注对 QA 判据 / 实现代码 / cr-004 提案推荐的影响面。
- **Player promise / slice（裁定的服务目标）:** 简单直接移动 + 自动攻击的可读、有重量感的清屏控制；因果链 `movement → pre-fire target consequence → readable hit/contact → space recovery → stronger B2 → victory/defeat → reset`。本裁定服务 pillar 2「移动→下一次自动攻击」归因可读 + pillar「非惩罚节奏」，以及 S2「无伪造命中」、G4「无幻影期待」。
- **Known constraints（裁定内不可触碰）:** 22 项 user_confirmed；决策 #3「pre-fire 刷新 + 锁定」；revision-02 #4「refresh → stable-sort → lock that shot's target snapshot」；Systems §5.1 规则 6「移除/失效目标不得作为有效命中」；Systems §3.2 preserved product boundary「post-fire target set does not continuously retarget」；PRECHARTER-02 键序；cr-001（R09）Option A 键序。任何触碰以上者 → 升级 `needs_user_decision` / `reauthorize_charter`，本裁定即停。
- **Top three design risks（裁定需防）:**
  1. 采 (i) 会把「锁定后目标已移除」当作本 shot 仍命中 → 违反规则 6「不得作为有效命中」（S2 / G4 破坏）；
  2. 采 (ii) 若无命名 drain 点约束 → 解析「解析时可变」滑向非确定（G1 破坏）；
  3. 三方不一致未消解 → QA 判据与实现不符，或实现与提案字面推荐冲突，造成不可验收。
- **Unknowns:** invalidation 精确 drain 实现细节（归 Tech）、`TARGET-removal` 期望事实的最终 execute 验证（归 QA 授权后）、no-target 联动形态（归 cr-005，本裁定不代决）。
- **Required evidence:** 本裁定为规则语义终裁，产出「可执行定义」；执行证据（TARGET-* fixture + seed 复现 + QA Gate 2 独立观察）归授权实现后 + QA（Gate 2 仍 `not_run / not_ready`）。
- **Decision boundary / stop condition:** 本裁定只在 cr-004 absorb 路径裁**失效语义**，不裁簇定义/metric/键序/no-target 形态/其它 cr。若判接触承诺/键序 → 升级路径；本裁定经逐项核查**未接触**，故不需要用户裁决，属 Systems 职权内终裁。停止条件 = 写出本唯一裁定书。

---

## 2. 三方（+Tech）语义诉求逐项核对

下表逐项清点各来源对失效语义的事实诉求，并把「时间点」作为消解分歧的主键。

| 来源（段） | 表达的语义诉求 | 时间点相关诉求 | 落点指向 |
|---|---|---|---|
| **cr-004 提案 v0.1 §3.4（推荐 (i)）** | 快照完全权威：锁定后失效本 shot 不可见，失效下一 shot 生效；提议推荐 (i)，但注明 (ii) 更贴「移除不得命中」字面 | 失效在**本 shot 解析时不可见**;失效（若采 (i)）在**下一 shot pre-fire refresh** 生效 | **(i)** 方向（字面推荐） |
| **Systems §5.1 规则 6** | 「Removed/invalid targets must be excluded from **later resolution**」；「移除/失效目标不得参与**后续结算**」 | 失效读作**解析之前**即被排除 → 该目标在**本 shot 结算**中不得命中 | **(ii)** 方向 |
| **QA 计划 §3.4 TARGET-removal** | 锁定含 ID X；解析前 X 被移除 → **X 无命中；`invalidation_event` 带 tick 入 trace；快照 ID 集不变** | 失效事件携带 tick 且发生在**解析前**；X 无命中 = 移除即失效 | **(ii)** 方向 |
| **实现 IMPL_MINIMAL_CORE_v0_1 §4.4/§6** | 快照 ID 集不可变 + 解析只读快照 + 失效目标经 drain 点被排除于命中结算（(ii)-方向落地）；头部注释/报告显式记录张力 | drain 点在**命名点**排空显式失效事件；失效目标**不产生命中** | **(ii)** 方向（已落地） |
| **TC-INPUT §2.4（可选参考）** | 锁定后失效/移除为显式领域事件在命名 drain 点排空；失效目标 ⇒ 该 ID 不产生命中、不伪造命中；二选一须全 run 一致并被 trace | 命名 drain 点（解析子步起点）排空；机制二选一由 Systems 定 | 机制中立，语义权归 Systems |

**核对结论:** 四份来源中**三份（规则 6 / QA 判据 / 实现落地）直接指向 (ii)**；唯一与 (ii) 不一致的是 **cr-004 提案 §3.4 的推荐表述 (i)**（且其自身已注明「(ii) 更贴合『移除不得命中』字面边界」）。因此，本次红队所指的「契约张力」实为**提案推荐（(i)）与规则 6 + QA 判据 + 已落地实现（(ii)）之间的文本不一致**，而非 (i)/(ii) 各自内部的矛盾处。

---

## 3. 终裁：采用 (ii)「确定性合法性谓词（非移除即失效），落点在命名 drain 点」

### 3.1 裁定结论

**终裁采用 (ii)，并对 (ii) 做「命名 drain 点 + 不可变快照 ID 集 + 只读解析」的约束化表述，使其与决策 #3 / revision-02 #4 的「锁定」语义完全一致。**

**一致语义定义（一句可执行，供 QA / 实现 / 提案对齐）:**

> **失效语义（终裁 (ii)）:** 每次开火在命名 drain 点（本步解析子步起点）排空显式失效事件；已锁定的本 shot 快照 **ID 集保持不可变**，解析**只读**该快照、绝不回查 live 实体、绝不连续重定位；任何在解析前已被 `invalidation_event(id, tick)` 声明的目标，在本 shot **不产生命中、不伪造命中**（Systems §5.1 规则 6），失效自**下一 shot 的 pre-fire 刷新**被踢出候选集而自然生效。即：**`锁定 ≠ 保证命中`；`锁定 = 固定 ID 集 + 不重定位`；`移除即失效 ⇒ 无命中`。**

### 3.2 裁定理由（按规则语义逐项）

1. **与决策 #3 / revision-02 #4「锁定」语义的一致性:**
   - 决策 #3「post-fire 固定目标」与 revision-02 #4「lock that shot's target snapshot」确认的**是快照 ID 集的固定与不重定位**，**不是**「对已移除目标的命中保证」。
   - (ii) 完整保留锁定: 快照 ID 集在 [e] 锁定后不可变 [f] 只读；shot 不重定位、不连续 retarget（Systems §3.2 preserved product boundary / Charter §5「post-fire fixed target set」）。
   - 唯一新增的是: 命中结算只作用于「未在解析前被显式失效」的锁定 ID。这不改变 ID 集、不重定位，故**不触碰**任何锁定承诺。**「锁定 ≠ 保证命中」是本裁定不新增承诺的关键澄清——决策 #3 从未承诺「已消失的目标仍被打中」。**

2. **与规则 6 禁令的一致性:**
   - 规则 6 明文:「Removed/invalid targets must be excluded from **later resolution**」。在 cr-004 单步模型中，移除事件在 [g]-start 的 drain 点排空、先于解析结算 → 该次结算即「later resolution」→ 被移除目标**必须被排除、不得命中**。
   - (ii) 正是「移除即失效 ⇒ 无命中」，**字面满足规则 6**；(i) 若按字面（本 shot 仍命中）则与「excluded from later resolution」直接冲突。

3. **对移动归因可读性（UX-02/G3）与 S2 无幽灵命中的影响:**
   - (ii) 下，玩家看到「目标已在解析前消失 → 该发不产生命中反馈」——**不会把打了空气记成命中**（S2 无伪造命中成立）、**不会以为已死/已移目标产出了本次命中**（无幽灵命中，G4 无幻影期待成立）。
   - (i) 则会记「锁定后本 shot 仍命中已失效目标」→ 形成玩家可感知的「假命中/打空气却算中」错位（G3 mismatch 风险更高），且违反 S2/G4。
   - 因此 (ii) 在移动→命中的因果读上**比 (i) 更诚实、更可读**，更贴合 pillar 2 归因。

4. **确定性 / fixture 可测性（G1）:**
   - (ii) 的「解析时判定」只读已排空的显式失效事件集（该集在命名 drain 点 [b]/[g]-start **固定**），是纯函数、无墙钟、无 live 实体查询 → **确定、可复现**。
   - `TARGET-removal` 期望事实「X 无命中；`invalidation_event` 带 tick；快照 ID 集不变」成为 (ii) 的精确可断言面，零容差可测（对齐 O2/B3）。

5. **对 TARGET-removal fixture 与 QA 判据的一致性:**
   - QA §3.4 期望事实与 (ii) **逐条一致**：X 无命中 ✓、`invalidation_event(id, tick)` 入 trace ✓（drain 点排空）、快照 ID 集不变 ✓（X 仍在锁定 ID 集，仅结算无命中）。
   - 命中 outcome 记为 `resolution_outcome = no-hit-invalid`（Trace 字段，与 proposal §3.5 一致）。

---

## 4. 影响面标注（终裁后各方待办）

| 方 | 当前状态 | 终裁后动作 | owner | 是否需改 |
|---|---|---|---|---|
| **QA 验收计划 §3.4 TARGET-removal 期望事实** | 已按 (ii)（X 无命中 + invalidation_event 带 tick + 快照 ID 集不变） | **无需修订**；直接作为 (ii) 终裁的可执行判据引用 | Independent QA | **否** |
| **实现（rules_core.gd）** | 已按 (ii)-方向落地（快照 ID 集不可变 + 只读解析 + drain 点排除失效命中） | **无需改代码**（已符合终裁）；仅需把 §4.4 红队记录/§6 的「待 Systems 定裁」状态**重标注为「已对齐终裁语义 (ii)」**（文档注记，非工程变更） | Engineer（归 Tech） | **否（代码）；仅重标注状态** |
| **cr-004 提案 v0.1 §3.4 推荐 (i)** | 字面推荐 (i)，与终裁 (ii) 不一致 | **需修订**: Systems owner 将提案 v0.1 的推荐自 (i) 改 (ii)，使提案推荐与规则 6 / QA 判据 / 实现一致。修订后提案 v0.1 → v0.2（或修订注记），属 Systems 后续在 cr-004 absorb 路径内执行，本裁定书不直接改动提案文件 | Systems（本角色） | **是（需后续修订提案）** |
| **TC-INPUT §2.4** | 机制中立、二选一由 Systems 定 | 无需改；终裁 (ii) 即为其「机制推荐二」的语义确认，供 ADR-TECH-04 语义段收敛 | Tech（引用） | 否（机制中立） |
| **ADR-TECH-04 / ADR-TECH-06** | `draft / not approved` | 终裁 (ii) 作为 cr-004 语义输入，供其以后定稿被引用；本裁定**不批准/冻结**任何 ADR | Tech + 评审路径 | 否（仅后续引用） |

**锁定判定:** 采用 (ii) 使 **QA 判据、实现代码、规则 6、决策 #3/revision-02 #4 四者完全一致**；唯一需要修订的文件是 **cr-004 提案的推荐表述（Systems 自持产物）**。不存在需要改 QA 计划或改实现代码的情形。（对比采 (i)：则需 QA 计划改 TARGET-removal 期望事实 + Engineer 改 rules_core.gd 失效逻辑 + 与规则 6 冲突——显然劣于 (ii)。）

---

## 5. 边界声明（明确）与升级路径

- **这是规则语义终裁（cr-004 absorb 路径），不是:**
  - **ADR/合同批准/冻结**: 未批准/冻结任何 ADR（含 ADR-TECH-04/06）或合同；cr-002/004/005 仍 `unresolved` 直至证据 + 评审；本裁定不闭合任何 unresolved 项。
  - **QA 豁免 / verdict**: 未豁免任何 QA blocker；未替 Independent QA 下 verdict；Gate 2 仍 `not_run / not_ready`。
  - **产品承诺变更**: 决策 #3 / revision-02 #4 / 22 项 / PRECHARTER / 四层 provenance / unresolved 全量保留，未改动任何一项。
  - **键序变更**: cr-001（Option A）键序未触碰；本裁定只裁失效语义时不涉及排序键序。
  - **实现 / Godot / 运行时**: 未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；无 runtime/视觉/性能/QA 证据。
- **升级触发条件（标注，本裁定未触发）:** 若终裁采用的方式触碰以下任一项，则升级 `needs_user_decision` / `reauthorize_charter` 交由用户亲自裁决——
  - 改变决策 #3「pre-fire 刷新 + 锁定」或 revision-02 #4「lock that shot's target snapshot」的已确认方向；
  - 改变 cr-001（R09 Option A）键序；
  - 把「移除目标不得命中」改读为「移除目标仍须命中」（违反规则 6，属承诺级反转）。
  - **经逐项核查，本裁定采 (ii) 不触碰上述任一项** → 属 Systems 职权内终裁，**不需要用户裁决**。

---

## 6. 明确要求「由对应 owner 执行」的后续动作（本裁定不直接执行）

1. **[Systems] 修订 cr-004 提案推荐**: 将 `PROPOSALS_CR002_004_005_v0_1.md §3.4` 的推荐自 (i) 改为 (ii)，并同步 §3.4 表格与 §3.6 的 QA 衔接行，使提案推荐与规则 6 / QA 判据 / 实现一致。作为 cr-004 absorb 路径内的后续修订（提案 v0.1 → v0.2 或修订注记），由 Systems 唯一 owner 执行；本裁定书不直接改动该提案文件。
2. **[Tech / Engineer] 实现状态重标注**: 将 `IMPL_MINIMAL_CORE_v0_1.md §4.4` 红队记录与 §6 的「失效语义待定裁」重标注为「已对齐 Systems 终裁语义 (ii)」，消除「待确认」悬置（文档注记，**不改代码**）。
3. **[QA] 判据引用**: 将 `QA_ACCEPTANCE_PLAN_v0_1.md §3.4 TARGET-removal` 期望事实作为 (ii) 终裁的可执行判据保留（无需改文本；授权实现后于 Gate 2 独立观察）。
4. **[Tech] ADR-TECH-04 语义段**: 终裁 (ii) 作为 cr-004 语义输入供其以后定稿收敛（仍经评审路径，不冻结）。

---

## 7. Provenance 分层与不变量保留声明

- **`user_confirmed`（仅引用，不新增）:** 22 项原始决策（含 #3 pre-fire 刷新+锁定）；revision-02 #4（refresh → stable-sort → lock that shot's target snapshot）；PRECHARTER-02；cr-001（Option A，R09）；Systems §5.1 规则 6 禁令（引用）。本裁定不重写、不重分类任何一项。
- **`team_proposal`（本裁定实质结论）:** 终裁采用 (ii)「确定性合法性谓词（移除即失效），落点在命名 drain 点」，及一致语义定义。此语义终裁供 QA / 实现 / 提案对齐，不升级为产品承诺；仍需授权实现后证据 + 评审确认方为规则定案。
- **`assumption`:** (ii) 下解析「解析时判定」的输入集在命名 drain 点固定 → 确定性（技术可行性需授权后 fixture 验证，TC-INPUT 已给出二选一可行性）。
- **`unresolved`（全量保留，未关闭）:** cluster membership；metric/quantization 精确数值与单位；tie-break 可读性语义；stable-ID 生命周期细节；invalidation 精确 drain 实现细节；no-target cycle 精确周期与提示形态；B2 多弧中间态；tick 频率；fixture_schema_version。—— 本裁定只收敛「失效语义的 (i)/(ii) 唯一化」，未把上述任何其它项升级或闭合。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本裁定未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升。

---

## 8. 边界声明与 Closure

- **未选择规则语义以外的裁决。** 本裁定只裁 cr-004 失效语义 (i)/(ii) 二选一 = **采用 (ii)**；未裁簇定义/metric/键序/no-target 形态/其它 cr。
- **未批准/冻结任何 ADR / 合同 / fixture schema / build-config identity / evidence index。** ADR-TECH-04/06 与 Tech/Systems/UX 合同均保持 `PROPOSAL / DRAFT / NOT APPROVED`；本裁定为其语义输入，不替代批准流程；不豁免任何 QA 门。
- **未豁免 QA blocker / 未替 Independent QA 下 verdict。** Gate 2 仍 `not_run / not_ready`；QA 独立观察。
- **未触碰 Godot / 运行时。** 未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；无 runtime/视觉/性能/QA 证据。
- **写入面。** 仅新增 `docs/production/SEMANTICS_INVALIDATION_FINAL_v0_1.md`；未修改任何既有文档。
- **未派发任何成员。** 未调用 `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。
- **完成了终裁即停。** 本裁定后不自行进入下一阶段、不派发任何成员。

**Closure:** `closure_ready = yes`（仅限本静态规则语义终裁书 artifact）。不是 kickoff pass、不是实现授权、不是合同/ADR 批准、不是 Gate 2 验收 verdict。Kickoff 仍 `not_ready`；implementation 仍 `NOT_AUTHORIZED`；Gate 2–6 仍 `not_run / not_ready`。

---

## 9. 版本与变更记录

- **v0.1（本文件）:** Systems / Rules Designer 唯一新产物——cr-004 失效语义 (i)/(ii) 终裁裁定书。终裁结论: **采用 (ii)**（移除即失效 ⇒ 无命中，落点在命名 drain 点，快照 ID 集不可变 + 只读解析不重定位），消除提案推荐 (i) 与规则 6 / QA 判据 / 实现 (ii) 三方不一致，产出一句一致语义定义；QA 判据与实现代码无需改（仅提案推荐由 Systems 后续修订 + 实现状态重标注）。未修改任何其它文档。
