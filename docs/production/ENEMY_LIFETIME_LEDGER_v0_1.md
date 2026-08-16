# ENEMY LIFETIME LEDGER v0.1 — 最小敌人命中生命周期 ledger（仅自动攻击 kill 路径）· Systems S1 薄前置

> **Status:** `PROPOSAL / TEAM_PROPOSAL / DRAFT / NOT APPROVED`——本文件是**最小 kill 路径语义的 ledger 行/规程（PRECHARTER-04 形态）**，供 Engineer 在规则核（S2）+ adapter（S3）+ 最小运行时（S4）实现、并供 QA 独立验收使用。
> **Promotion authority:** `User`——本文件不批准/冻结任何契约、ADR、语义或数值；任何候选数值/阈值提升为正式规则、门槛或 Gate 判据，必经 CR + 用户批准。
> **Lifecycle:** `development governance / implementation authorization effective (R13)`；本单元 = S1 薄前置（同单元最小击杀/清除语义前置），按 Producer `NEXT_IMPL_UNIT_PLAN_v0_1.md` 路径 A+ 派发。
> **Role / owner (sole author):** Systems / Rules Designer（系统与规则设计师，S1 唯一写 owner）
> **Report ID:** `ENEMY_LIFETIME_LEDGER_v0_1`
> **Expert capability:** `godot-systems-rules-expert` — 实测 `skill({name:"godot-systems-rules-expert"})` **调用成功**（返回值完整 SKILL 指令）。能力证据等级 = `strong_direct_skill`（首选等级，运行时 `skill` 接口真实返回，非仅凭函数清单判断，亦未伪报不可用）。无需 fallback 到 `C:\Users\User\.agents\skills\godot-systems-rules-expert\SKILL.md`。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本 S1 仅依据指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未批准/冻结任何契约或 ADR；未豁免 QA blocker；未替 Independent QA 下 verdict；未替用户做产品裁决）。

---

## 0. Expert preflight（按 godot-systems-rules-expert §Expert preflight）

| 项 | 值 |
|---|---|
| Mission outcome | 产出**最小敌人命中生命周期 ledger 行/规程**（仅自动攻击 kill 路径：敌人 HP、单击伤害→死亡、死亡→live 集/清理缩减回收走廊）；`PROPOSAL` 级，range + starting_point，promotion_authority = User，不锁常数 |
| Player promise / slice | 简单直接移动 + 自动攻击的可读、有重量感的清屏控制；slice 完成判定 = `attack/kill results reducing pressure and recovering a corridor`（KICKOFF §9.2 可玩性观察项 2——本 ledger 即该判据的硬语义前置） |
| Known constraints | 22 项原始 user_confirmed（仅引用）；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；unresolved 全量保留；ADR-TECH-01..06 已批准（R11）；R13 实现授权生效；候选预算（六项 + `1280×720` 红线）仅候选、本任务不涉及 |
| 已实现并通过 Gate 2 的规则核事实 | `step`/`ordered_candidates` 纯逻辑；target 语义（pre-fire refresh → stable-sort → M-1 → lock 不可变快照）；no-target 分支；失效 drain 点 (ii)（锁定 = 固定 ID 集 + 不重定位；锁定 ≠ 保证命中；移除即失效 ⇒ 无命中）；`hit_results` + `resolution_outcome`（每 ID `hit` / `no-hit-invalid`） |
| 本单元范围 | 仅自动攻击 kill 路径；**接触（cr-006..009）/ 升级（cr-010..011）/ B2（cr-016..019）/ 终结（cr-014..015）/ focus（cr-012..013）明确延后**；生成（spawn）仅标注为后续项 |
| Top three design risks | ① kill 语义误触碰已批准 ADR-TECH-04 锁定/invalidation 语义（重复命中/幽灵命中）→ 红队核查、以 (ii) 一致性为准；② 敌人 HP 过早写成常数/门槛 → 违反 PRECHARTER-04，全部走 ledger、promotion=User；③ 死亡目标的 clean 信号与规则核纯逻辑边界混淆（规则核不拥有引擎 live 集）→ 明确规则核只发 `kill`/death 事件，adapter 负责从引擎 live 集移除（引擎实体归 adapter，非规则核） |
| Unknowns | 敌人 spawn 节奏（后续项）；敌人 HP 多段是否引入（本 ledger 建议起始=单击击杀，多段留候选）；走廊恢复的可读反馈形态（归 UX 观察，本 ledger 只出 signal）；fixture_schema_version（cr-110，未定，本文件不改） |
| Required evidence | 授权实现后 — `KILL-single` / `KILL-multi`（若采多段候选）/ `KILL-death-removal` fixture 确定性 + adapter 移除引擎 live 实体的 runtime 观察 + QA 独立验收（S2→Gate 2 扩展；S4 可玩性走廊恢复 → Gate 3 前段观察） |
| Decision boundary / stop condition | 语义归 Systems（本 ledger）；机制落实归 Engineer；观察归 UX；验收归 QA；最终裁决归 User。若本语义触碰 promise/immutable/platform/threshold/release → 升级路径（见 §6，本任务预期不触碰，但如实判断）。文件写入即停，不进入下一阶段、不派发任何成员 |

---

## 1. 语义范围（明确什么包含、什么不包含）

### 1.1 本 ledger 覆盖（= kill 路径完整因果链）

```
auto-attack hit（绑定 hit_results）→ 敌人 HP 扣减 → HP ≤ 0 ⇒ death/kill → 死亡目标从候选集/未来 refresh 移除 → live 集/清理缩减 → 压力降低、走廊/移动空间恢复（可观察 signal）
```

三个语义字段为交付主体：

1. **敌人 HP（段/候选值）** — PRECHARTER-04 ledger；
2. **自动攻击单击伤害→死亡** — 单击击杀 vs 需多击的最小语义建议，含范围；
3. **死亡→live 集/清理缩减** — 死亡目标从候选集移除、清理缩减/走廊恢复信号。

### 1.2 本 ledger 明确不包含（语义边界，防漂移）

- **接触伤害（cr-006..009）**：玩家-敌人重叠伤害 / 无敌 / 分离 / 再武装 — 延后独立单元。
- **升级触发/卡牌（cr-010..011）**：XP、两次升级暂停 — 延后。
- **B2（cr-016..019）**：弧几何 / 穿透 / 独立计数 — 延后；本 ledger 仅单中心方向自动攻击（B2 前形态）。
- **终结（cr-014..015）**：终端仲裁 / 重置事件排序 — 延后。
- **focus epoch（cr-012..013）** — 延后。
- **生成节奏（spawn cadence）**：本 ledger **仅标注为后续项**（spawn 的节奏/密度/涌现进入 live 集的方式不是本 kill 路径语义；本 ledger 不产出 spawn ledger 行）— 显式留空，见 §5。
- 任何敌人数值定稿 / 平衡证据 — 本文件不产生。

---

## 2. 最小 kill 路径语义（核心 ledger 行）

> 按 PRECHARTER-04 形态（range / starting_point / assumption / dependency / signal / promotion_authority / stop-rollback）。以下所有数值**仅候选**，promotion_authority = **User**，不锁常数。

### 2.1 敌人 HP（minimal kill-path HP）

**一句话最小语义建议：** 敌人有效 HP 起始 = **1（单击即可击杀）**，作为自动攻击 kill 路径的最简可证形态；多段 HP 作为候选范围保留，供后续平衡/节奏实验（不写入本 slice 常量）。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 敌人有效 HP：`[1, 5]`（单位 = 自动攻击命中 hit 数；候选多段 HP 枚举 `1（单击击杀）/ 2 / 3 / 5`）。**排除值：0 或负数 HP（无效/已死实体不得再次命中）、非整数分数段（本 slice 无分数伤害语义）。** |
| `starting_point` | **1**（单击 auto-attack hit = 1 HP 扣减 = 死亡）。即 enemy effective HP = 1 hit。**非平衡/实现证据**，仅实验初始值。 |
| `assumption` | 单击击杀是本 slice 达成「attack/kill results reducing pressure and recovering a corridor」的最小可证形态（KICKOFF §9.2-2）：一次可读命中直接释放一个压力源，最快显现走廊恢复；多段 HP 属后续 balance（godot-balance-expert）实验，非本 ledger 起判。 |
| `dependency` | `hit_results`（已实现，Gate 2 pass）；`resolution_outcome` 每 ID `hit`（已实现）→ 本字段把「一次 `hit` 记入该敌人 HP 扣减」；目标失效语义 (ii)（已终裁）— 死亡目标绝不再命中（见 §2.3）。engine 实体 HP 记录归 adapter（`ordered_candidates` 输入可携带 `alive`/HP 字段，Engineer 机械翻译）。 |
| `signal` | `KILL-single` fixture：单次 hit ⇒ 该敌人 HP `1→0` ⇒ 产生 `kill`/death 事件且不再出现在候选集。可观察=死亡目标从后续 `ordered_candidates` 输入消失 + `hit_results` 承载该 hit。 |
| `promotion_authority` | **User**（任何 HP 值/多段枚举写入正式规则、门槛或 Gate 判据 = 升级，必经 CR + 用户批准）。 |
| `stop/rollback` | 若 HP 语义破坏「单击释放压力/恢复走廊」的可读性 → 回退至 HP=1 并重跑 `KILL-*` fixture；若某 HP 值被提议写死为规则常数 → 停止本路径并升级 User。 |

### 2.2 自动攻击单击伤害→死亡

**一句话最小语义建议：** **单击击杀（one-shot）**。命中结算中，一次 auto-attack `hit` 对目标扣减其当前 HP；HP ≤ 0 ⇒ 死亡。起始 = 每次 `hit` 伤害 `1`、敌人 HP `1` ⇒ `1 击 = 死`。多击（伤害 < 剩余 HP）作为候选范围保留（§2.1 range），但本 slice 起始建议单击击杀，原因：它是「移动→自动攻击→命中→击杀→清除」前四动词**最小、可证、最快显现走廊恢复**的闭合；多击将引入每敌人 HP 簿记与节奏辨析，超出本 slice 最小可玩证明所需（vertical-slice 纪律）。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 单击命中伤害：`1`（候选多击时各击伤害 `[1, N]`，且需 单击伤害 < 剩余 HP 才能构成多击；**排除值：0（无效命中，禁止）；伤害 > 目标当前 HP 而目标已死后仍重复计入（重复命中/幽灵命中，见 §2.3 依赖 (ii)）**）。单击起始已由 HP 起始（§2.1）决定。 |
| `starting_point` | 单击 auto-attack hit ⇒ 目标死亡（1 击 = 死亡）。多击候选（若有）留后续 balance 实验，非本 ledger 起判。 |
| `assumption` | 单击击杀在视觉/操作上足以构成 slice 判据「kill results reducing pressure」（一次明确命中 = 一次明确死亡 = 一次明确释放）；多击必要性由后续 balance/体验观察决定，非本 slice 前提。 |
| `dependency` | 每击对 HP 的扣减须与锁定快照只读解析一致（不得破坏 ADR-TECH-04 锁定 = 固定 ID 集）；hit 只施加于解析前未被显式失效的锁定 ID（终裁 (ii)），死亡目标不得再次被扣（防重复）| 见 §2.3 与 §3.1 — 边界与 (ii) 一致 |
| `signal` | `KILL-single`：1 hit ⇒ kill event；若采多击候选，`KILL-multi` fixture 断言「多次 hit 累计扣减至 0 才死亡」。 |
| `promotion_authority` | **User** |
| `stop/rollback` | 若单击击杀导致走廊恢复被判定过弱/过强（观察到压力不降或清屏瞬间完成无张力）→ 回退单击并提交多段 HP 实验（仍 ledger，不锁常数）；不得在此阶段擅自改伤害公式。 |

### 2.3 死亡 → live 集 / 清理缩减

**一句话最小语义建议：** 死亡目标是 `kill`/death 事件的载体，必须 (a) 与失效合法性谓词 (ii) 一致——死亡目标即移除即失效，**绝不产生后续命中/重复命中**；(b) 从**后续 pre-fire refresh 候选集**（`ordered_candidates` 输入）消失；(c) 生成一个可观察的**清理缩减/走廊恢复 signal**（kill event + live-set reduction / pressure-drop），供 QA 依 KICKOFF §9.2-2 验收。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | live 集缩减形式：`移除 1 个死亡目标`（本 slice 最小）；多目标同 tick 死亡时逐 ID 移除（候选；顺序由确定性 ID/候选序决定，不依赖容器插入序）。**排除值：把死亡目标保留在候选集/重复结算（恢复为可命中）；移除顺序依赖引擎容器插入序。** |
| `starting_point` | 每次 kill 移除 1 个死亡目标；死亡 ID 在命名 drain 点被标记为 invalid/removed，本 shot 及后续 refresh 不再命中。 |
| `assumption` | 「移除死亡目标 ⇒ 后续候选集含该敌人数量 −1 ⇒ live 威胁密度降低 ⇒ 玩家可移动空间（走廊）恢复」是可观察、可被 QA 判定的（KICKOFF §9.2-2）。规则核只产出 kill 事件 + 候选集缩减的 trace；**引擎实体（live 集）的物理移除归 adapter**——规则核不拥有引擎实体（ADR-TECH-01 seam 已批准）。 |
| `dependency` | 目标失效语义 (ii)（已终裁，一致）；`hit_results` / `resolution_outcome`；adapter 把 kill 事件映射为引擎 live 集移除（S3，Engineer）；slice 完成判定依赖该信号（KICKOFF §9.2-2）。 |
| `signal` | `KILL-death-removal` fixture：死亡目标从后续候选集消失 + kill/death 事件入 trace + live 缩减计数；S2 确定性；S4 运行时「击杀→敌人移除→压力降→走廊可通行」可观察（Gate 3 前段）。 |
| `promotion_authority` | **User** |
| `stop/rollback` | 若死亡目标的移除会造成「幽灵命中/重复命中」或与失效 (ii) 冲突 → 回退至纯 (ii) 语义（移除即失效）重跑 fixture；若「live 集缩减」需写回规则核/越界到引擎 → 停并留给 adapter/Engineer（不能把引擎实体所有权并入规则核）。 |

---

## 3. 与已批准契约的衔接（红队核查：不触碰已批准 ADR 语义）

### 3.1 目标失效语义 (ii) 一致性

- 本 kill 路径**完全建立在已终裁/已批准的目标失效语义 (ii) 之上**：死亡 = 移除 = 失效 ⇒ 无命中。
- 锁定快照 ID 集**不可变**（ADR-TECH-04）；解析只读锁定快照，绝不回查 live；锁定 ≠ 保证命中。
- 本 ledger 只**新增一个跨度**：把「一次 `hit`（`resolution_outcome=hit`）对该敌人 HP 扣减至 ≤0」定义为「死亡 ⇒ 后续候选集移除」；**不改变**任何已批准锁定/invalidation/命中语义。死亡目标在命名 drain 点被排除于命中结算（与 (ii) 逐条一致），并进一步从**未来** refresh 候选集消失（adapter 机械翻译，非规则核越界）。

### 3.2 不触碰项（明确）

- **不触碰** ADR-TECH-01..06（seam/纯度/确定性/target snapshot/headless）——kill 语义全部落在经批准的规则核纯逻辑 seam 内（步骤 §4），引擎实体归属 adapter。
- **不触碰** 接触（cr-006..009）、升级（cr-010..011）、B2（cr-016..019）、终结（cr-014..015）、focus（cr-012..013）——全部延后（§1.2）。
- **不新增/不重分类** 任何 `user_confirmed`；不把任何 `team_proposal`/`assumption`/候选数值提升为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）不涉及。

---

## 4. 规则核 kill 路径建议事件/步序（供 Engineer S2 落地参考，机制归 Engineer）

> 以下为**语义事件建议**（`team_proposal`），供 Engineer 在已批准规则核纯逻辑 seam 内落地（S2）。规则核不拥有引擎 live 集。

```text
[1] pre-fire refresh（adapter 提供 ordered_candidates 输入）→ 现有 target 语义
[2] stable-sort → lock 不可变快照（既有）
[3] 解析只读快照（既有，不重定位）
[4] 结算 hit：对 resolution_outcome=hit 的目标，扣减 HP 1（§2.2）
[5] HP ≤ 0 ⇒ 该目标死亡：emit kill/death 事件（含 stable_id + tick）
[6] 死亡目标在命名 drain 点标记为 invalid/removed（与 (ii) 一致）→ 本 shot 及后续不再命中
[7] kill 事件交给 adapter →（S3）把引擎 live/ordered_candidates 输入中该实体移除 → live 集缩减
[8] 后续 refresh 候选集不含死亡目标 ⇒ 走廊/移动空间恢复（KICKOFF §9.2-2 可观察）
```

- 步骤 [4][5][6] 属规则核纯逻辑（引擎 free）；步骤 [7] 的**引擎实体物理移除归 adapter**（ADR-TECH-01 seam）。
- 该步序不重复计算 hit、不引入随机（规则核零 RNG，确定性 by-construction，延续 Gate 2 纪律）。

---

## 5. 生成（spawn）标注——后续项，非本 ledger

- **敌人生成节奏/密度/涌现（spawn cadence）不在本 ledger 语义范围**。本 slice kill 路径只需「已存在的敌人可被击杀并清除」。
- S4 最小运行时只需 ≥1 enemy node 作为 `ordered_candidates` 输入（Producer `NEXT_IMPL_UNIT_PLAN_v0_1.md` §5.4）；「敌人从何处/何时/数量进入 live 集」是**后续生成节奏项**，不在本单元。
- 未来 spawn ledger 行（spawn 速率、波次密度、压力曲线）暂不产出；如需进入正式开发，须独立 CR/单元，并保持 PRECHARTER-04 ledger + promotion_authority=User。

---

## 6. 升级路径判定（如实评估：本任务预期不触碰，但如实判断）

- **判断：本最小 kill 路径语义不触碰产品承诺 / 性能 / 平台边界。** 依据：它是 KICKOFF §9.2 可玩性观察项 2（「attack/kill results reducing pressure and recovering a corridor」）的形式化前置，属于已确认的「移动→自动攻击」方向与 slice 目标；不新增系统（接触/升级/B2/终结是机制推进而非新系统）；不施加性能承诺（无导出/测量）；不改变平台（PC-first 键盘不动）；候选预算（六项 + `1280×720` 红线）不涉及。
- **触发升级路径的条件（若发生即停并上报）：**
  1. 若 HP 数值/多段枚举被写为正式规则常数、门槛或 Gate 判据 → 升级 `needs_user_decision` / `reauthorize_charter`（promotion=User）。
  2. 若 kill 语义改写「自动攻击始终可见」或引入 player-visible Replay/持久化/新性能承诺 → 升级（对齐 cr-203 / DC-PLAY-01 边界）。
  3. 若 kill 语义与已批准 ADR-TECH-04 锁定/invalidation 冲突而需改 ADR → 交 Tech/User，非本 ledger 职权。
- 当前**未触碰**任何上述升级触发条件。

---

## 7. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；revision-02 #3/#4；PRECHARTER-01..11；cr-001 (R09)；ADR-TECH-01..06 批准 (R11)；R12 owner 任命；AUTH-01 (R13 实现授权)。本 ledger 不重写、不重分类任何一项。
- **`team_proposal`（本 ledger 的实质贡献）:** 最小 kill 路径语义三字段 ledger 行（敌人 HP 起始=1/单击击杀/死亡→live 集缩减与走廊恢复 signal）+ 规则核 kill 步序建议 + 语义边界声明。全部为 PROPOSAL 级，供 Engineer 实现 + QA 验收，**不升级任何契约**。
- **`assumption`:** 单击击杀构成「kill results reducing pressure and recovering a corridor」的最小可证形态（需 QA/UX 观察验证，未观察前不成立）；规则核只发 kill 事件、引擎 live 集物理移除归 adapter（本 slice 内可行，待真实引擎验证）；死亡移除后的走廊恢复可观察（KICKOFF §9.2-2 为依据，未观察前不成立）。
- **`unresolved`（全量保留，未关闭）:** 敌人多段 HP 精确值/是否引入、spawn 节奏（后续项）、走廊恢复的可读反馈形态（归 UX）、kill 相关的 fixture envelope（cr-110，未定）、`KILL-*` fixture 精确 schema——全部保持 `unresolved`，本 ledger 不闭合、不升级任何一项（失效语义 (i)/(ii) 已由 `SEMANTICS_INVALIDATION_FINAL_v0_1.md` 终裁为 (ii)，本 ledger 依此一致，不重新开口）。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本 ledger 未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升；未批准/冻结任何契约/规则语义/数值。

---

## 8. 边界声明与 Closure

- **本文件为 `PROPOSAL` 级（S1 交付物），非契约冻结、非数值提升、非 QA 验收、非产品裁决。** 全部数值仅候选；promotion_authority=User。
- **未触碰已批准 ADR 语义**：kill 路径建立在已终裁失效语义 (ii) 之上，与 ADR-TECH-01..04/05 机制边界一致；不触碰接触/升级/B2/终结/focus（全部延后）。
- **未替用户做产品/验收裁决；未豁免 QA blocker；未替 Independent QA 下 verdict**。
- **未访问/修改 Godot、代码、场景、资源**；未运行/构建/测试/导出/发布；无 runtime/视觉/性能/QA 证据（本文件仅 static/source）。
- **写入面**：仅新增本唯一 ledger 文件 `docs/production/ENEMY_LIFETIME_LEDGER_v0_1.md`；未修改任何其它文档。
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。

**Closure:** `closure_ready = yes`（仅限本 S1 ledger artifact）。本文件供父协调器作为 S1 薄前置派发 S2（Engineer 规则核 kill 扩展）+ 后续（S3 adapter / S4 最小运行时）的语义输入；非实现派发、非契约批准、非 QA 验收、非产品裁决。写入后停止，不进入下一阶段、不派发任何成员。

---

## 9. 版本与变更记录

- **v0.1（本文件）:** Systems / Rules Designer 唯一新产物——S1 最小敌人命中生命周期 ledger。产出一段完整 kill 路径因果链（hit → HP 扣减 → 死亡 → live 集缩减 → 走廊恢复）；三个语义字段 ledger 行（敌人 HP range[1,5]/starting_point=1、单击伤害→死亡起始=单击击杀、死亡→live 集/清理缩减 signal）全部 PRECHARTER-04 形态、promotion_authority=User；与目标失效语义 (ii) 一致；语义边界明确不含接触/升级/B2/终结/focus（延后），生成仅标注后续项；升级路径如实判断（预期不触碰）；Provenance 分层与不变量保留声明完整。未触碰任何已批准契约/ADR/其它文档。
