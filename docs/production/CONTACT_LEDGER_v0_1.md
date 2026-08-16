# CONTACT LEDGER v0.1 — 接触（contact）最小语义 ledger（薄前置 C1）· Systems S1
>
> 覆盖:接触判定（eligibility）/ 单次伤害 / 无敌时长 / 分离距离·方向 / 堆叠·同时接触 / 边界行为 / life segments_lost 数值语义

> **Status:** `PROPOSAL / TEAM_PROPOSAL / DRAFT / NOT APPROVED`——本文件是**接触（contact）最小语义的 ledger 行/规程（PRECHARTER-04 形态）**，供 Engineer（C2 规则核 contact 扩展 + C3 CONTACT-\* fixture + C4 adapter/运行时）+ QA（Gate 2 扩展 + Gate 3 前段接触惩罚/分离/生命扣减观察）实现与验收使用。
> **Promotion authority:** `User`——本文件不批准/冻结任何契约、ADR、语义或数值；任何候选数值/阈值提升为正式规则、门槛或 Gate 判据，必经 CR + 用户批准。**（AUTH-01 条件触发 D2-Card 1/2/3，见 §6）**
> **Lifecycle:** `development governance / implementation authorization effective (R13)`；本单元 = 候选 B「接触语义 + 玩家伤害（cr-006..009）」的 C1 Systems 薄前置，按 Producer `NEXT_IMPL_UNIT_PLAN_v0_3.md` §3/§4 派发。
> **Role / owner (sole author):** Systems / Rules Designer（系统与规则设计师，C1 唯一写 owner；本文件 = Systems 唯一写 ownership）
> **Report ID:** `CONTACT_LEDGER_v0_1`
> **Expert capability:** `godot-systems-rules-expert` — 实测 `skill({name:"godot-systems-rules-expert"})` **调用成功**（返回值完整 SKILL 指令）。能力证据等级 = `strong_direct_skill`（首选等级；本运行时 `skill` 接口实测可用，`tools.skill` 包装器非独立存在；以直接 `skill(...)` 成功）。无需 fallback 到 `C:\Users\User\.agents\skills\godot-systems-rules-expert\SKILL.md`。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本 C1 只依据任务允许的指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未批准/冻结任何契约或 ADR；未豁免 QA blocker；未替 Independent QA 下 verdict；未替用户做产品裁决）。

---

## 0. Expert preflight（按 godot-systems-rules-expert §Expert preflight）

| 项 | 值 |
|---|---|
| Mission outcome | 产出**接触最小语义 ledger**（S1 模式，PRECHARTER-04 形态）：接触判定（eligibility）/ 单次伤害（对齐决策 #4）/ 无敌时长（全局 vs 成对——范围+起始建议，标注 unresolved 不代决）/ 分离距离·方向 / 堆叠·同时接触（推荐默认「单次伤害+无敌吞并」保持 #4 非升级；若改 N× → 标 D2）/ 边界行为 / **life segments_lost 数值语义**；全部 `PROPOSAL`，range + starting_point，promotion_authority = User，不锁常数；与 ADR-TECH-05 + 失效 (ii) + TECH-04 衔接 |
| Player promise / slice | 简单直接移动 + 自动攻击的可读、有重量感的清屏控制；本单元把 slice 从「清屏控制」推向「非惩罚节奏 + 生命三格 + 压力/可恢复」——接触使玩家第一次「能被威胁伤害并获得可读惩罚 + 通过移动/撤离恢复」。slice 完成判定 = 接触惩罚/分离/生命扣减**可读、非色彩、可归因**（KICKOFF §9.2 可玩性观察; UX-02/03 + Pillar 4 非惩罚节奏） |
| Known constraints | 22 项原始 user_confirmed（仅引用）；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；unresolved 全量保留；ADR-TECH-01..06 已批准（R11，含 TECH-05 机制边界）；决策 #4（contact 单次伤害事件）+ #5（life 三格&同帧生命优先）`user_confirmed`；失效语义 (ii) 已终裁；ADR-TECH-04 已批准；R13 实现授权生效；候选预算（六项 + `1280×720` 红线）仅候选、本任务不涉及 |
| 已确认机制边界（本 ledger 必须一致） | ADR-TECH-05 已批准机制边界：**一次合法接触 = 一次伤害事件**；短暂无敌（无敌内无重复伤害）；轻分离（可恢复间距）；再接触仅在分离后合法；同帧生命耗尽优先于八分钟完成。失效语义 (ii): 接触后失效目标不重复命中（复用 drain 语义）。ADR-TECH-04: target 快照 ID 集不可变、只读解析 |
| 本单元范围 | 仅接触语义薄前置（C1）；升级/B2/终结/focus/spawn 明确延后；不触碰候选预算；不触碰既有 kill 路径（S1/S2 恒以 `hit_results`/`resolution_outcome` 结算，contact 走同一 drain 语义，不重复计算） |
| Top three design risks | ① 把「单次伤害 + 无敌吞并同时接触」的推荐默认误写为已决/锁死常数，或改决策 #4「单次接触伤害事件」为 N× 叠加 → 违反 AUTH-01，须标 D2-Card 2 不代决；② contact 无敌/分离数值过早写成规则常数/Gate 判据/发布承诺 → 违反 PRECHARTER-04 / AUTH-01，标 D2-Card 1 不代决；③ 接触判定与失效语义 (ii) / ADR-TECH-04 快照冲突（已失效目标重复命中、接触后失效目标不再命中被破坏、规则核越界到引擎 live 集）→ 红队核查、以 (ii)/TECH-04/TECH-05 为准 |
| Unknowns | 无敌全局 vs 成对模型（前 80% 推荐成对、后 20% 标 unresolved 由证据 + User 提升）；无敌时长精确值；分离距离/方向精确值；堆叠/同时接触的精确顺序与最大消耗；边界行为/分离失败精确规则；life segments_lost 每格消耗映射（推荐一次合法接触扣 1 格）；玩家伤害体验精确形态（归 UX 观察）；fixture_schema_version（cr-110，未定，本文件不改） |
| Required evidence | 授权实现后 — `CONTACT-single` / `CONTACT-overlap` / `CONTACT-separate-rearm` / `CONTACT-simultaneous`（同时接触——边界作明确未决上报，断言「单次伤害事件 + 无敌吞并」为推荐默认、若改 N× 则升级 §7）/ `CONTACT-boundary`（边界分离与可恢复）/ `CONTACT-removal`（保护期移除→状态清理+未来 re-arm）fixture 确定性（← KICKOFF §6.3 fixture 矩阵）+ Gate 3 前段接触惩罚/分离/生命扣减可读非色彩（non-color UX-13）+ QA 独立验收 |
| Decision boundary / stop condition | 语义归 Systems（本 ledger）；机制落实归 Engineer（碰撞/几何在 adapter，规则核只收接触合法性输入）；观察归 UX；验收归 QA；最终裁决归 User。若本语义触碰 promise/immutable/platform/threshold/release，或把任一候选数值写为规则常数/Gate 判据/发布承诺，或堆叠改 #4 → 升级路径（见 §6）。文件写入即停，不进入下一阶段、不派发任何成员 |

---

## 1. 语义范围（明确什么包含、什么不包含）

### 1.1 本 ledger 覆盖（= 接触最小语义完整因果链）

```
合法接触判定（eligibility）→ 一次合法接触 = 一次伤害事件（决策 #4）
→ life segments_lost 扣减（接触伤害→生命）
→ 短暂无敌（无敌内无重复伤害，ADR-TECH-05）
→ 轻分离（可恢复间距）
→ 再接触仅在分离后合法（re-arm）
→ 边界/分离失败处理
→ 堆叠/同时接触（推荐默认单次伤害+无敌吞并）
```

受 ADR-TECH-05 机制边界（一次合法接触 = 一次伤害 + 短无敌 + 轻分离 + 分离后 re-arm）与失效语义 (ii) 约束。本 ledger 把该机制边界内的**精确语义**（range + starting_point）落成可实现、可验收的 ledger 行。

### 1.2 本 ledger 明确不包含（语义边界，防漂移）

- **升级（cr-010..011）/ 两次暂停 + 卡牌**: 延后（依赖 B2 + focus）。
- **B2（cr-016..019）/ `扇裂` 三弧**: 保持前-B2 结构位，不引入 B2 行为。
- **终结 / 重置（cr-014..015）**: 本 ledger 仅提供 life 扣减字段骨架 + 与 TECH-05「同帧生命优先」锚点一致，不实现终局仲裁/自动重试。
- **focus epoch（cr-012..013）**: 延后。
- **spawn 节奏**: 延后（显式留空，`ENEMY_LIFETIME_LEDGER §5` 惯例）。
- 任何敌人数值/平衡定稿 / 视觉定稿 / 资产 / 动画 / 音频 — 本文件不产生。
- **候选预算（六项 + `1280×720` 红线）**: 不涉及。

---

## 2. 接触最小语义（核心 ledger 行）

> 按 PRECHARTER-04 形态（range / starting_point / assumption / dependency / signal / promotion_authority / stop-rollback + evidence_id 留空）。以下所有数值**仅候选**，promotion_authority = **User**，不锁常数。

### 2.1 接触判定（contact eligibility）

**一句话最小语义建议：** 一次**合法接触** = 玩家本体与一个存活敌人（在锁定快照 / 生命可见域内、未被失效语义 (ii) 排除）的**重叠**在单个 tick 内被判定为有效接触。接触判定区分「合法接触」与「连续重叠」：连续重叠不产生重复伤害（ADR-TECH-05 无敌 + 分离 + re-arm）。这衔接 PRECHARTER-03（contact 合法性）与 ADR-TECH-05 机制边界。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 接触判定模型：`单 tick 重叠判定`（一次合法接触 = 一次重叠成立事件）。**排除值:** 把「持续重叠的每一帧」当作重复合法接触（重复伤害）；把已失效目标（失效 (ii)）当作可接触命中；把规则核外（引擎 live 集所有权）的实体物理状态当作接触输入（collision/几何归 adapter，ADR-TECH-01 seam）。 |
| `starting_point` | 每次有效重叠成立（eligible overlap）产出一个 `contact` 域事件；该事件由 adapter 的碰撞检测（引擎侧）判定并作为 domain contact 输入传给规则核，规则核按 §2.2 结算单次伤害。 |
| `assumption` | 「重叠成立即可合法接触」构成本单元最小可证形态:一次重叠 → 一次可读伤害 → 触发生命/分离/无敌反馈链。规则核只收 adapter 提供的接触合法性输入（ADR-TECH-01 seam 已批准），接触检测的碰撞/几何边界归 adapter（Engineer，P3）。 |
| `dependency` | ADR-TECH-04（快照 / invalidation）: 接触判定发生在已被失效语义 (ii) 排除的目标之外的存活目标上；冲突时以 (ii) 为准（失效即不接触）。ADR-TECH-01 seam（规则核不拥有引擎 live 集）。PRECHARTER-03（接触合法性）。 |
| `signal` | `CONTACT-single` fixture: 一次合法重叠 → 恰好一个 `contact`/伤害事件（不重复）；`CONTACT-overlap` fixture: 持续重叠内不产生第二个合法接触（无敌 + re-arm=false）;`CONTACT-boundary` fixture: 边界重叠仍按一次合法接触处理且可分离恢复。 |
| `promotion_authority` | **User**（任何接触判定模型/值写入正式规则、门槛或 Gate 判据 = 升级，必经 CR + 用户批准）。 |
| `stop/rollback` | 若接触判定误把连续重叠记为重复伤害，或误碰已失效目标（反向于 (ii)）→ 回退至纯 (ii) + 「重叠成立一次」语义重跑 CONTACT-\* fixture；若需把接触检测移入规则核（越界到引擎实体所有权）→ 停并留给 adapter/Engineer。 |
| `evidence_id` | （留空，evidence 未产生） |

### 2.2 单次伤害（one damage event，对齐决策 #4）

**一句话最小语义建议：** **一次合法接触 = 一次伤害事件**（对齐决策 #4「contact 单次伤害事件」+ ADR-TECH-05「One legal contact produces one damage event」）。伤害量语义 = 一次合法接触扣减 **1 格 life**（对接 §2.7 life segments_lost）。**排除 N× 多次伤害作为本 ledger 起判**——那是改决策 #4 的 D2-Card 2 升级项（§6），不代决。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 单次伤害量: **`1` 格 life / 1 次合法接触**（本 ledger 最小建议）。**排除值:** 0 格（无效伤害，禁止：合法接触必须可读）；>1 格（一次接触扣多格 = 改变「生命三格可恢复」节奏，非本单元起判）；N× 多次伤害叠加（同时接触改 #4 → D2-Card 2 升级，本 ledger 不代决）。 |
| `starting_point` | 一次合法接触 → 一次伤害事件 → 扣减 1 格 life（`segments_lost += 1`）。即 contact damage = 1 life segment / legal contact。**非平衡/实现证据**，仅实验初始值。 |
| `assumption` | 单次伤害 + 短无敌吞并同时接触是保持决策 #4 非升级的最简可恢复形态（ADR-TECH-05 机制边界内）：一次明确伤害 = 一次明确惩罚 = 一次明确可恢复。N× 叠加留给后续 gameplay/balance 实验，非本 ledger 起判。玩家伤害是可读、非色彩、非惩罚的（UX-02/03 + Pillar 4）。 |
| `dependency` | `contact` 事件（§2.1）；`life` 字段（§2.7）;ADR-TECH-05（单次伤害 + 无敌内无重复伤害）;失效语义 (ii)（接触后失效目标不重复命中，复用同一 drain 语义）——详见 §3.1。 |
| `signal` | `CONTACT-single` fixture: 恰好一次伤害（`segments_lost` 1 次扣减）;`CONTACT-overlap`: 无敌内无重复伤害（re-arm=false）;`CONTACT-simultaneous`: 「单次伤害事件 + 无敌吞并」为推荐默认（§2.5）。 |
| `promotion_authority` | **User** |
| `stop/rollback` | 若单次伤害导致生命扣减被判定过/过强（可恢复性或压迫感失衡，观察到惩罚不可读/重复伤害/粘滞）→ 回退单次伤害并重跑 CONTACT-\* fixture；若伤害语义被提议改为 N× 叠加（改变 #4）→ 停止本路径并升级 D2-Card 2（§6），本 ledger 不代决。 |
| `evidence_id` | （留空，evidence 未产生） |

### 2.3 无敌时长（contact invulnerability，全局 vs 成对）

**一句话最小语义建议：** 一次合法接触后，玩家进入**短暂无敌**，在无敌窗口内**不产生重复伤害**（ADR-TECH-05「No repeat damage occurs during invulnerability」）。**成对 vs 全局模型**给出范围与起始建议，但标注 unresolved 不代决：起始建议**成对模型**（一对已接触（玩家, 敌人）在分离前的无敌内不重复伤害；它更贴合「分离后 re-arm」语义与多敌可恢复节奏），全局（整个玩家短暂无敌吞并其它接触）作为候选保留。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 无敌时长: 候选 `[0.2s, 1.0s]` 墙钟（单位 = 秒，运行 tick 换算）;按 tick 语义为候选 tick 区间（如 `[N_tick_low, N_tick_high]`，tick 频率 cr-020 unresolved 故不锁 tick 数）。**模型范围:** `成对`（推荐起始）vs `全局`——两者均候选，**未决**。**排除值:** 0（无无敌 → 持续重叠重复伤害，违反 ADR-TECH-05）;无敌覆盖整个 run（粘滞/不可再武装）。 |
| `starting_point` | 成对模型;无敌时长起始 **≈ 0.5s**（≈ 短到不明显停顿、长到吞并同帧同时接触，供 QB/UX/QA 观察调参）。全局无敌作为候选备选，不落盘为起判。 |
| `assumption` | 成对模型让多敌接触逐个结算（不一次扣光），配合短无敌 = 「非惩罚节奏 + 生命三格 + 压力/可恢复」的最小可证形态;全局模型假定一次接触后整玩家无敌一段，可能吞并后续多敌接触（对堆叠影响不同）。两者孰优需证据 + User 提升,本 ledger 仅起判成对。 |
| `dependency` | ADR-TECH-05（无敌内无重复伤害）;§2.4 分离 + re-arm（成对模型的再接触条件）;§2.5 堆叠/同时接触（无敌吞并同时接触）。 |
| `signal` | `CONTACT-overlap` fixture: 无敌窗口内 `re-arm=false`、无重复伤害;`CONTACT-separate-rearm` fixture: 分离后无敌到期 + re-arm=true → 第二次合法接触。无敌窗口时长可由重复接触的 `contact`/伤害事件时间戳间隔观察（授权后 runtime/trace）。 |
| `promotion_authority` | **User**（无敌时长/全局-vs-成对任一数值或模型写入正式规则/Gate 判据 = 升级）。 |
| `stop/rollback` | 若无敌时长导致伤害不可读/压迫失衡，或成对模型与分离/re-arm 冲突（重叠得不到独立结算）→ 回退至明确起始值（~0.5s 成对）并重跑 CONTACT-\*；若需从成对改全局（改语义承诺）→ 停止并升级 D2-Card 2（§6），不代决。 |
| `evidence_id` | （留空，evidence 未产生） |

### 2.4 分离距离/方向（light separation）

**一句话最小语义建议：** 一次合法接触后，玩家与敌人之间应用一次**轻分离**——沿「接触法向」推离一个**足以恢复间距、不会穿越边界**的距离，使该对「可再接触」仅在分离完成 + 无敌到期后成立（re-arm，ADR-TECH-05）。分离方向取「玩家背离敌人接触点」的方向（候选；相对移动方向/碰撞几何法向作候选备选，未决）。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 分离距离: 候选 `[8px, 32px]`（对 16:9 基线内一敌人的最小可感间距建议;非像素承诺，Engineer 落地以世界单位换算）。分离方向: `接触法向 / 背离方向`（起始）vs `相对移动方向`（候选备选,未决）。**排除值:** 0（无分离 → 重叠粘滞、不可 re-arm，违反 ADR-TECH-05 可恢复间距）;过远（逃逸穿界/越过边界）。 |
| `starting_point` | 分离距离起始 **≈ 16px**（中值,供 UX/QA 观察调参）;方向起始 = 沿接触法向背离玩家推离/挪开敌人到最近合法非重叠位置。 |
| `assumption` | 轻分离是实现「可恢复间距（pillar: 非惩罚节奏）」的最小机制:接触后被推开而不是被粘滞吸住，玩家能通过移动/撤离恢复。分离距离/方向需 UX/QA 观察验证，未观察前不成立。 |
| `dependency` | ADR-TECH-05（light separation + 分离后 re-arm）;§2.1 接触判定;§2.3 无敌（分离与应用量一致）;§2.6 边界行为（分离不得穿越边界/逃逸穿界）;TECH-04（若分离改变几何则 target 快照语义由 adapter 机械处理，规则核不变）。 |
| `signal` | `CONTACT-separate-rearm` fixture: 分离后恰好一次新合法接触;`CONTACT-boundary` fixture: 边界处分离可恢复、不越界。分离位移可由接触前后玩家/敌人位置的 runtime 观察（授权后）。 |
| `promotion_authority` | **User** |
| `stop/rollback` | 若分离导致粘滞（不可再武装）/逃逸穿界/边界不可恢复 → 回退至明确起始值（~16px 法向）并重跑 fixture;若需把分离方向改为相对移动方向（改语义承诺）→ 升级，不静默改。 |
| `evidence_id` | （留空，evidence 未产生） |

### 2.5 堆叠 / 同时接触（stacking / simultaneous contacts）

**一句话最小语义建议：** **推荐默认（非升级路径）= 同时接触视为同一帧的一次事件，由无敌吞并（无敌窗口内不重复伤害,ADR-TECH-05），即保持决策 #4「单次伤害事件」非升级。** 若设计为 N× 多次伤害（同时每个接触各扣一次）→ **改变决策 #4，触发 D2-Card 2 升级（§6），不代决**（用户亲自决策「一次伤害事件(无敌吞并,推荐) vs N× 叠加(改 #4 → 升级)」）。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 同时接触结算: `单次伤害事件 + 无敌吞并`（推荐默认,保持 #4）;`N× 叠加`（多敌同时接触每个各结算一次,改变 #4 → 升级）。**排除值:** 在 D2-Card 2 未决前把 N× 写为已决规则常数（停止并升级）。 |
| `starting_point` | 同时接触 = 同一帧多次合法重叠 → 一次 `contact`/伤害事件（无敌吞并）;`segments_lost += 1` 一次。 |
| `assumption` | 无敌吞并同时接触维持「非惩罚节奏 + 生命三格可恢复」:同时被 2 敌夹击不一次扣 2 格,让玩家有撤离/恢复时间。N× 叠加是更硬的惩罚,需用户明确选择才升级（D2-Card 2）。**需 UX/QA 观察验证，未观察前不成立。** |
| `dependency` | 决策 #4（单次伤害事件）;ADR-TECH-05（无敌内无重复伤害,支持吞并）;§2.3 无敌模型（成对 vs 全局决定吞并粒度）。 |
| `signal` | `CONTACT-simultaneous` fixture: 两敌同时接触 → **断言「单次伤害事件 + 无敌吞并」为推荐默认**（`segments_lost` 恰 +1）;**边界作明确未决上报**——若改 N× 则升级 §7（D2-Card 2）。`CONTACT-stack`（若后续 fixture 明确序列）: 堆叠顺序、最大消耗未决上报。 |
| `promotion_authority` | **User** |
| `stop/rollback` | 若堆叠设计触碰到「单次接触伤害事件」承诺（改 N×）→ 停止本路径并升级 D2-Card 2（§6），本 ledger 不代决、不静默吸收;推荐默认（吞并）保持非升级。 |
| `evidence_id` | （留空，evidence 未产生） |

### 2.6 边界行为（boundary behavior + separation failure）

**一句话最小语义建议：** 接触发生在**竞技场边界**时，轻分离必须在「不穿越边界 / 不逃逸出界」的前提下完成，且玩家仍保留可恢复的重叠解除（非粘滞）。若分离方向指向边界使直接法向分离不可行，则分离沿边界切向或转向场内最近合法位置（候选；精确规则未决）。**分离失败**（无法从重叠解除到分离距离）必须有停止面（不无限推、不穿越边界、不卡死）。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | 边界分离: `法向可行`（起始）vs `切向 / 场内转向`（边界处法向不可行时,候选）;分离失败处理: 若无法达到该分离距离,则达到边界内最大可分离量并允许 re-arm 条件（候选）。**排除值:** 分离穿越竞技场边界（逃逸穿界,纪律红线）;分离失败导致无限推挤/卡死/玩家被永久钉在边界无法接收后续接触结算。 |
| `starting_point` | 边界处:若法向分离指向边界内,直接法向;若指向边界外,则沿场内可分离方向挪到最近合法非重叠位置（不越界）。分离失败时仍在无敌窗口内完成 single 结算并标记 re-arm 在边界处暂停。 |
| `assumption` | 边界行为保持「可恢复间距 + 不逃逸穿界」:玩家在边界被接触仍可被推开并恢复（KICKOFF §6.3 CONTACT-boundary 「Separation and recoverability without escape-through-boundary」）。精确切向/转向规则需证据 + User 提升,本 ledger 仅起判。 |
| `dependency` | ADR-TECH-05（light separation + 非粘滞）;§2.4 分离距离/方向;物理边界（adapter 碰撞/几何，P3）;cr-009（玩家/敌人边界与分离失败）。 |
| `signal` | `CONTACT-boundary` fixture: 边界处接触 → 分离可恢复、无越界逃生;`CONTACT-removal` fixture: 保护期/分离中目标被移除 → 状态清理 + 未来 re-arm 正确（无幽灵分离/无卡死）。 |
| `promotion_authority` | **User** |
| `stop/rollback` | 若边界接触导致不可恢复重叠（粘滞）→ 玩家死亡不可读,回退至场内转向/最大可分离量并重跑 fixture;若分离在边界处穿越/逃逸 → 停并标为纪律违规,回退至不越界模型。 |
| `evidence_id` | （留空，evidence 未产生） |

### 2.7 life segments_lost 数值语义（接触伤害→生命扣减）

**一句话最小语义建议：** 玩家有 **3 格 life**（`segments_lost:int(0..3)` + `life_state:enum`，READ_MODEL_MINIMAL_FIELDS §4.1 结构位）。**一次合法接触 = 扣 1 格**（对接 §2.2 单次伤害 + §2.5 同时接触吞并）。3 格按顺序消耗，`segments_lost` 0→3 为耗尽（耗尽属性归终局/重置，本单元只提供扣减骨架 +「同帧生命优先」锚点一致，不实现终局仲裁）。**范围:** 一次接触扣 `[1]` 格（起始）;多敌同时接触一次仅扣 1（吞并）;若设计不同消耗映射 → 走 ledger 候选 + 证据，不改 #4。

| 字段 | 记录（候选，非批准） |
|---|---|
| `range` | life 格数: **3 格**（决策 #5 三格，user_confirmed）。每格消耗: **一次合法接触 = 1 格**（起始）；同时接触（吞并）一次 = 1 格。`segments_lost` 有效范围 `0..3`（`3 = 耗尽`）。**排除值:** 0 格消耗（无效接触,禁止）;一次接触 > 1 格（改变「生命三格可恢复」节奏,非本单元起判）;`segments_lost` 越界 > 3。 |
| `starting_point` | 一次合法接触 → 伤害事件 → `life.segments_lost += 1`（精确一次）;`life_state` 反映当前格状态（如 `full/2/1/empty` 候选枚举，未决）。三格按序消耗,每次扣减可读（非色彩,UX-13）。 |
| `assumption` | 三格 + 每接触扣 1 = 「非惩罚节奏 + 生命三格 + 压力/可恢复」最小可证形态:玩家可吃 2 次接触不阵亡、第 3 次耗尽前可撤离/恢复;同帧生命耗尽优先于八分钟完成（决策 #5,TECH-05）。**life 的精确数值/消耗映射归 Systems 本单元定义（已定位）;实际呈现形态归 UX。** |
| `dependency` | 决策 #5（life 三格 & 同帧生命优先）;§2.2 单次伤害（1 contact = 1 格）;§2.5 同时接触（吞并一次 = 1 格）;TECH-05 同帧生命优先;READ_MODEL_MINIMAL_FIELDS §4.1 `life` 字段（`segments_lost:int(0..3)`）+ `READ_MODEL_IMPLEMENTATION_LIST §4.1`（life 结构位从恒 0 → 实际扣减呈现）。 |
| `signal` | runtime frame + Independent QA: `segments_lost` 从 0 实测扣减（一次接触 +1）;`CONTACT-single`/`CONTACT-simultaneous` fixture: `segments_lost` 精确 +1（吞并）;life 三格结构位在读 model 呈现;非色彩可读（UX-13）。 |
| `promotion_authority` | **User**（life 数值语义/每格消耗写入规则常数/Gate 判据/发布承诺 = D2-Card 1 升级）。 |
| `stop/rollback` | 若 life 扣减破坏「非惩罚 + 可恢复」可读性（一次接触扣多格 / 惩罚不可读 / 三格消耗失衡）→ 回退至「1 contact = 1 格」并重跑 CONTACT-\*;若该数值被提议写为规则常数/Gate判据/发布承诺 → 停止并升级 D2-Card 1（§6），本 ledger 不代决。 |
| `evidence_id` | （留空，evidence 未产生） |

---

## 3. 与已批准契约的衔接（红队核查：不触碰已批准 ADR 语义）

### 3.1 与 ADR-TECH-05 机制边界一致

- 本 ledger 完全建立在已批准 ADR-TECH-05 机制边界之上：**一次合法接触 = 一次伤害事件;**短暂无敌（无敌内无重复伤害）;**轻分离**（可恢复间距）;**再接触仅在分离后合法**（re-arm）;**同帧生命耗尽优先于八分钟完成**。本 ledger 只在该边界内落**精确语义**（range + starting_point），不改变任何已批准机制边界。
- **无敌内无重复伤害** = §2.3 无敌窗口 + §2.5 同时接触吞并的理论依据（`CONTACT-overlap` / `CONTACT-simultaneous` fixture 直接断言）。
- **同帧生命优先** = §2.7 `life` 耗尽面 + §1.2 不实现终局仲裁（只提供字段骨架与锚点一致）。

### 3.2 与失效语义 (ii) 一致（接触后失效目标不重复命中）

- 失效语义 (ii)（已终裁）: `移除即失效 ⇒ 无命中`;落点在命名 drain 点;快照 ID 集不可变;只读解析不重定位。
- contact 复用同一 drain 语义: **接触后失效目标不重复命中**。即:若一个目标在一次合法接触后于 [g]-start drain 点被标记失效/移除，则在后续 contact 结算中不再产生第二次接触伤害。这与 `CONTACT-removal` fixture（保护期移除→状态清理+未来 re-arm）直接一致。
- 本 ledger 不改变失效 (ii)，只把「接触后的目标不重复命中」声明为复用同一 drain 语义（`invalidation_event` 在命名 drain 点排空 → 该 ID 不再被接触结算占用）。

### 3.3 与 ADR-TECH-04 一致（target 快照不可变）

- ADR-TECH-04: target 快照 ID 集不可变、只读、不重定位。contact 判定发生在存活目标上;若接触改变几何（分离移动敌人），target 快照 ID 集不变（快照不可变），engine/geometric 位置变化由 adapter 机械处理（P3），**规则核不因 contact 重定位快照**。
- 接触伤害结算复用 `contact` 事件的确定性通道（同 tick、命名点、零 RNG），延续 Gate 2 确定性纪律（O2/B3 零容差）。

### 3.4 不触碰项（明确）

- **不触碰** ADR-TECH-01/02/03/04/06（seam/纯度/确定性/target snapshot/headless）——contact 语义全部落在已批准 seam 内（碰撞/几何在 adapter、规则核只收接触合法性输入），引擎实体归属 adapter（P3）。
- **不触碰** 升级/B2/终结/focus/spawn——全部延后（§1.2）。
- **不触碰** kill 路径（S1/S2）——contact 走独立 drain 语义 + 独立 `contact` 事件，不重复计算 kill 的 `hit_results`/`resolution_outcome`。
- **不新增/不重分类** 任何 `user_confirmed`（含决策 #4/#5）;不把 `team_proposal`/`assumption`/候选数值提升为 `user_confirmed`;候选预算（六项 + `1280×720` 红线）不涉及。

---

## 4. 规则核 contact 步序建议（供 Engineer C2 落地参考，机制归 Engineer）

> 以下为**语义事件建议**（`team_proposal`），供 Engineer 在已批准规则核纯逻辑 seam 内落地（C2）。碰撞/几何检测在 adapter（C4），规则核只收接触合法性输入。

```text
[A] adapter 提供接触合法性输入（引擎碰撞检测 → domain 触点事件），规则核不拥有引擎 live 集（ADR-TECH-01 seam）
[B] 在命名 drain 点排空显式失效事件（失效 (ii)）→ 失效/移除目标不产生接触命中
[C] 判定: 本次重叠是否构成一次「合法接触」（eligible overlap，§2.1），且该玩家在该 tick 未被相同来源重复接触（无敌/re-arm 检查）
[D] 若合法: emit `contact` 域事件（一次）,对齐决策 #4「单次伤害事件」
[E] 生命结算: `life.segments_lost += 1`（§2.7,一次合法接触扣 1 格）——只读快照结算，不重定位
[F] 进入无敌窗口（§2.3,起始成对 ~0.5s）: 无敌内无重复伤害
[G] 轻分离（§2.4）: 沿法向推离 ~16px,边界处不越界（§2.6）
[H] 同步接触吞并: 同帧多敌接触 = 一次事件（无敌吞并,§2.5）,保持决策 #4
[I] 分离完成 + 无敌到期 → re-arm=true（该对可再合法接触,ADR-TECH-05）
[J] 事件交给 adapter → 反馈/位移/移除归 adapter（引擎实体归 adapter）;同帧生命耗尽 → 交后续终局单元（锚点一致,本单元不实现仲裁）
```

- 步骤 [D]+[E] 属规则核纯逻辑（引擎 free）；步骤 [A][G][J] 的引擎碰撞/物理/移除归 adapter（ADR-TECH-01 seam，P3）。
- 步序确定性 by-construction（命名 drain 点排空、零 RNG、同 tick），延续 Gate 2 纪律（O2/B3）。

---

## 5. 生成（spawn）标注——后续项，非本 ledger

- **接触的对象（敌人从何处/何时/数量进入）不在本 ledger 语义范围**。本 slice 接触路径只需「已经存在于 live 集的敌人可与玩家接触并结算」。
- C4 adapter/运行时只需 ≥1 enemy node 作为接触检测对象;「敌人流入节奏」是后续 spawn 项,不在本单元。

---

## 6. AUTH-01 升级判定（重点 — 明确标注）

> AUTH-01（R13）: process-level 连续推进;非升级项自动接受专家建议（D1）;升级项（阈值/发布/平台/锚点类）用户亲自决策（D2）;冲突升级（D3）。

- **本 ledger 判定（如实）: 全部接触数值仅候选（promotion_authority = User）;本 ledger 是 C1 制式前置,本身非升级（D1 自动推进）——机制在已批准 ADR-TECH-05 机制边界 + 决策 #4/#5 `user_confirmed` 内,按 S1 模式作为 PROPOSAL、range+starting_point、不锁常数,无数值写死。**

### 条件触发的 D2 升级卡片（明确列出，需用户亲自决策的具体情形）

> **本 ledger 无前置强制 D2 升级。** 但以下**条件一旦命中，立即升级 `needs_user_decision`**（呈交用户亲自决策，非静默吸收），本 ledger 不代决:

| 卡片 | 触发条件（对本 ledger 数值/语义） | 用户需决策的具体问题 |
|---|---|---|
| **D2-Card 1** | 接触伤害量 / 无敌时长 / 全局 vs 成对 / 分离距离 / 分离方向 / 边界规则 / life 扣减映射 任一数值被提议**写为规则常数 / Gate 判据 / 发布承诺** | 该接触数值是否提升为正式规则/门槛/承诺？取值范围与起始点？（本 ledger 不锁任何常数,全部候选,先问再升） |
| **D2-Card 2** | 同时接触/堆叠被设计为 **N× 多次伤害**（改变决策 #4「单次接触伤害事件」）;或无敌模型被设计为改变「单次伤害事件」承诺 | 多次同时接触是「一次伤害事件（无敌吞并，推荐默认，非升级）还是 N× 叠加（改 #4 → 升级）」？（本 ledger §2.5 起判吞并=保持 #4 非升级） |
| **D2-Card 3** | 玩家伤害体验形态触碰 player promise（非惩罚）/ 核心支柱 / 被提议为发布文案（归 UX 观察目标,若触碰即升级） | 该接触→伤害反馈形态是否越 promise？是否成为发布承诺？ |

> **推荐默认（非升级路径）:** (a) 单次接触伤害 + 短无敌吞并同时接触（保持决策 #4）;(b) 全部 contact 数值走 ledger 候选、promotion=User;(c) 玩家伤害体验以 UX 观察目标固化、不冻结形态。**本 ledger 按推荐默认执行即全程 D1。** 施/落实现任一数值为规则常数/Gate判据/发布承诺 → D2-Card 1;堆叠改 #4 → D2-Card 2;触碰 promise → D2-Card 3（均标注、不代决）。

---

## 7. AUTH-01 条件触发示例（对齐 Producer NEXT_IMPL_UNIT_PLAN_v0_3 §6/§7）

- **D2-Card 1（数值写死）:** 若 Engineer/C4 在实施中把 §2.x 任一候选值（如无敌 0.5s、分离 16px、扣 1 格）写为规则常数 / Gate 判据 / 发布承诺 → 触发 D2 升级，用户亲自决定是否提升为该数值（本 ledger 不代决、不预授权）。
- **D2-Card 2（堆叠改 #4）:** 若 C3 `CONTACT-simultaneous` 在证据/评审中需要 N× 叠加（改变决策 #4「单次伤害事件」承诺）→ 触发 D2 升级（本 ledger §2.5 默认吞并=非升级;改 N× 即升级）。
- **D2-Card 3（触碰 promise）:** 若玩家伤害体验形态触碰 player promise（非惩罚）/ 核心支柱 / 发布文案 → 触发 D2 升级（归 UX 观察,若触碰 UI→UX;若触碰产品语义→Systems/User）。

> 本 ledger 全部数值仅候选，无任何值被写死;AUTH-01 判定 = 无前置强制 D2，推荐默认全程 D1。

---

## 8. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed（含决策 #4 contact 单次伤害事件 / #5 life 三格&同帧生命优先 / #19 非色彩可读）;revision-02 #4;PRECHARTER-01..11（含 PRECHARTER-03 contact 合法性 / 04 range-starting / 11 同帧生命优先）;cr-001 (R09);ADR-TECH-01..06 批准（R11，含 TECH-05 机制边界 = 一次合法接触单次伤害+轻分离/无敌/同帧生命优先）;失效语义 (ii) 终裁;ADR-TECH-04 批准;AUTH-01（R13 实现授权）。本 ledger 不重写、不重分类任何一项。
- **`team_proposal`（本 ledger 的实质贡献）:** 接触最小语义七字段 ledger 行（接触判定 / 单次伤害 / 无敌时长【全局 vs 成对】 / 分离距离·方向 / 堆叠·同时接触【推荐默认吞并】 / 边界行为 / life segments_lost 数值语义），全部 PRECHARTER-04 形态、range+starting_point、promotion_authority=User、不锁常数;规则核 contact 步序建议;语义边界声明;与 ADR-TECH-05 / 失效 (ii) / TECH-04 衔接声明。全部为 PROPOSAL 级，供 Engineer 实现 + QA 验收，**不升级任何契约/数值**。
- **`assumption`:** ① 重叠成立即可合法接触、规则核只收 adapter 接触合法性输入（P3,需 Engineer 落地 + QA 观察验证）;② 推荐默认（单次伤害 + 无敌吞并同时接触）保持决策 #4 非升级（需 Systems 在此 ledger 确认 + UX/QA 观察）;③ life 扣减呈现可在已批准 read-model 契约内扩展且可被独立 QA 观察;④ 成对无敌 + 分离 ~16px 法向 + 扣 1 格是最小可证可恢复形态（需 UX/QA 观察）。均未在此代决。
- **`unresolved`（全量保留，未关闭）:** 无敌全局 vs 成对模型（首选成对,但全局 vs 成对精确选择由证据 + User 提升）;无敌时长精确值 / 分离距离·方向精确值 / 边界切向转向规则 / 分离失败精确规则 / 堆叠顺序·最大消耗 / life `life_state` 枚举形态 / 玩家伤害体验精确形态（归 UX 观察）/ spawn 节奏 / 敌人多段 HP / fixture_schema_version / O6 evidence-harness——全部保持 open,本 ledger 不闭合、不升级任何项。cr-006..009 精确值 remains **unresolved**（本 ledger 给出 range + starting_point 候选，但精确提升待证据 + User）。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本 ledger 未改动上述任何一项;未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`;候选预算（六项 + `1280×720` 红线）未被动用/提升;未批准/冻结任何契约/规则语义/数值/表现形态。

---

## 9. 边界声明与 Closure

- **本文件为 `PROPOSAL` 级（C1 交付物），非契约冻结、非数值提升、非 QA 验收、非产品裁决。** 全部数值仅候选;promotion_authority=User;不锁常数。
- **未触碰已批准 ADR 语义**：contact 语义建立在已批准 ADR-TECH-05 机制边界（一次合法接触单次伤害 + 短无敌 + 轻分离 + 分离后 re-arm + 同帧生命优先）+ 失效语义 (ii) + ADR-TECH-04（target 快照不可变）之上，与 ADR-TECH-01..06 一致；不触碰 kill 路径、不触碰升级/B2/终结/focus/spawn（全部延后）。
- **AUTH-01 标注**：全部接触数值仅候选（promotion=User）;若实施中任一数值被写为规则常数/Gate判据/发布承诺 → D2-Card 1;堆叠改 #4 → D2-Card 2;触碰 promise → D2-Card 3（均标注、不代决）。
- **未替用户做产品/验收裁决;未豁免 QA blocker;未替 Independent QA 下 verdict。**
- **未访问/修改 Godot、代码、场景、资源**;未运行/构建/测试/导出/发布;无 runtime/视觉/性能/QA 证据（本文件仅 static/source）。
- **写入面**：仅新增本唯一 ledger 文件 `docs/production/CONTACT_LEDGER_v0_1.md`;未修改任何其它文档（Systems 合同、CR 台账、排程建议、既有 ledger、ADR 等一律未触碰）。
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。

**Closure:** `closure_ready = yes`（仅限本 C1 ledger artifact）。本文件供父协调器作为 C1 薄前置派发 C2（Engineer 规则核 contact 扩展）+ C3（CONTACT-\* fixture）+ C4（adapter/运行时接触·伤害·分离）+ C5（life 扣减呈现）+ Gate 2 扩展 + Gate 3 前段验收的语义输入;非实现派发、非契约批准、非 QA 验收、非产品裁决。写入后停止，不进入下一阶段、不派发任何成员。

---

## 10. 版本与变更记录

- **v0.1（本文件）:** Systems / Rules Designer 唯一新产物——C1 接触最小语义 ledger（薄前置）。产出完整接触因果链（合法接触 → 单次伤害 → 生命扣减 → 无敌 → 轻分离 → 再武装 → 边界/堆叠）;七个语义字段 ledger 行全部 PRECHARTER-04 形态、range+starting_point、promotion_authority=User、不锁常数;与 ADR-TECH-05（单次伤害+轻分离/无敌/同帧生命优先）+ 失效语义 (ii)（接触后失效目标不重复命中）+ ADR-TECH-04（target 快照不可变）逐条衔接;AUTH-01 判定（无前置强制 D2 + 条件触发 D2-Card 1/2/3）明确标注;Provenance 分层与不变量保留声明完整。未触碰任何已批准契约/ADR/其它文档。
