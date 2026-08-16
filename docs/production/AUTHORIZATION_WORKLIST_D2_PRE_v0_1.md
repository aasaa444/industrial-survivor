# AUTHORIZATION WORKLIST — D2-PRE (D2 升级卡片之前的授权范围工作清单) v0.1

> **Status:** `AUTHORIZATION-SCOPE WORKLIST（授权范围工作清单，PROPOSAL）` — 划出「当前接触单元之后，到**第一个必然触发 D2 升级卡片 / 强制用户介入点之前**」的全部可自动推进开发工作，供用户审阅并作**最终一次性授权**。本清单是**范围界定建议**，不派发实现、不批准/冻结任何契约/数值、不豁免 QA、不替用户做产品/验收裁决、不替 Independent QA 下 verdict。
> **Role / owner (sole author):** Executive Producer / Lead Producer（执行制作人 / 首席制作人）
> **Report ID:** `AUTHORIZATION_WORKLIST_D2_PRE_v0_1`
> **Expert capability:** `godot-executive-producer-expert` — 实测 `skill({name:"godot-executive-producer-expert"})` **调用成功**（返回完整 SKILL 指令；未发生 unknown tool / 接口不存在错误）。能力证据等级 = `strong_direct_skill`（首选等级；本运行时 `skill` 接口实测可用，`tools.skill` 包装器非独立存在）。无需 fallback 到 SKILL.md 读取。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本清单仅依据任务允许的指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未派发任何成员）。
> **git 基线（仅引用）:** `822c51e` → `eef5691` → `194618d` → `2a1dc51` → `db5616f` → `29c874e`；working tree 有接触单元 docs/QA 待提交（`CONTACT_LEDGER_v0_1.md` / `CONTACT_UX_OBSERVATION_v0_1.md` / `NEXT_IMPL_UNIT_PLAN_v0_3.md`，均 untracked）。

---

## 0. 授权背景与本清单的用途（用户最终授权前必读）

- **您（用户）的最新指令**：「我授权在 D2 升级卡片前的所有开发工作，你先列一下清单再让我进行最终授权。」——您要一次性授权「在触发任何 D2 升级卡片之前」的全部可自动推进开发工作（按 D1，见 AUTH-01），但**先拿到一份明确的授权范围清单**（单元序列 + 边界 + 每单元 D1/D2），经您审阅并最终授权后，父协调器即可按本清单自动推进（每单元仍 QA 独立验收 + 透明报告，无需逐单元等您「继续」）。
- **本清单交付**：① 明确的授权边界（止于哪）；② 边界内全部可自动推进单元（范围/owner/依赖/验收路径/D1）；③ D1/D2 判定表（每单元逐项标注，含必须排除在授权外的工作）；④ 护栏（执行仍受约束）；⑤ 授权边界外仍必须用户介入的里程碑清单。
- **本清单不替代**：用户产品裁决；Independent QA verdict；Systems 语义定裁；Tech ADR 批准；任何数值提升（promotion_authority=User）；Gate 3 视觉验收；发布/导出。**本清单只界定「哪些开发工作可自动推进到哪儿停」**，不改变任何已决契约/决策/数值。

---

## 1. 已确认事实与不变量（仅使用这些）

- **不变量：** 22 项原始 `user_confirmed`；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；unresolved 全量保留。
- **AUTH-01（R13）**：D1 非升级自动接受专家建议；**D2 升级卡片（阈值/发布/平台/锚点类）用户亲自决策**；D3 冲突升级。promotion_authority=User。
- **D2 升级卡片机制（Contact ledger §6 / v0.3 §6）：** D2-Card 1 = 数值写死为规则常数/Gate 判据/发布承诺；D2-Card 2 = 改变已确认决策（如堆叠改 #4，N× 多次伤害）；D2-Card 3 = 触碰 player promise（非惩罚）。升级路径：cr-010/011（XP/触发窗口）写死数值即 D2；候选预算（六项 + `1280×720` 红线）提升为正式门槛即 D2；发布/平台/导出类即 D2。
- **已批准契约：** ADR-TECH-01..06（seam/纯度/read-model/确定性/snapshot/headless）；ADR-TECH-05 **机制边界已批准**（contact 单次伤害+轻分离 / 升级两阶段 / focus epoch / 同帧生命优先 / 终局仲裁与重置），精确数值语义延后（cr-006..020 Systems in_flight）。
- **已确认决策：** 决策 #4（contact 单次伤害）、#5（life 三格&同帧优先；结果/立即重试）、#7/#8/#9（升级三同关键词卡 / 两次全场暂停 / XP 仅中间物）、#11（victory=控制完成）、#12（defeat=light interruption）、#5、#17（失焦安全）、#19（非色彩可读）—— 结构均已确认、数值 unresolved。
- **已实现并验收：** 单元 1（垂直切片）/单元 2（可玩切片，真实键盘移动基线）QA verdict `pass`；不同接触单元（候选 B）波 1 实现完成 + 波 2 QA 独立验收进行中。接触数值全 ledger 候选、未锁。
- **slice 交接：** 8 分钟有界 Slice = 移动 + 自动攻击 + 接触 + 两次升级暂停 + 结局与重试；PC-first 键盘；低认知清屏控制；Pillar 4 非惩罚。
- **候选预算（六项 + `1280×720` 红线）仅候选。**
- **unresolved/延后：** cr-006..009 精确值（接触，候选起点在 CONTACT ledger）；cr-010/011（升级触发窗口/XP）；cr-012/013（focus epoch）；cr-014/015（终结/重置）；cr-016..019（B2 三弧）；spawn；O6 evidence-harness；O8 真人自由操作验收。

---

## 2. 授权边界（本清单的核心里程碑界定）

### 2.1 边界判定（第一个必然触发 D2 / 强制用户介入的硬点）

基于依赖真相（非偏好），**授权范围的硬边界 = 把「移动 + 自动攻击 + 接触 + 终结/重置 + 立即重试」这条核心可玩闭环完整落地并经 Independent QA 独立验收、成为「可完整玩一遍并自动重试」的可玩切片之后**。该边界正是**可玩性观察门（revision-02 #6 / DC-PLAY-01 Option 2）+ 首次 D2 升级卡片（升级触发/XP 数值）**交汇点。

**依据（依赖真相）：**
1. **核心闭环依赖序：** 接触单元让 `segments_lost` 成为真实扣减（非结构位）→ 玩家生命可耗尽 → **游戏必须处理「耗尽后发生什么」** → 终结/重置（cr-014/015）是依赖真相上的**必然下一步**（否则循环不可玩）。此单元在已批准契约内：ADR-TECH-05 终局仲裁+重置**机制边界已批准**；决策 #5（结果+立即重试）、#12（defeat=light interruption）、#11（victory=控制完成）均 `user_confirmed`；cr-014/015 disposition = `absorb_within_authority`；**结果时长等数值走 ledger 候选、promotion=User**。→ **可作为 D1 自动推进**。
2. **首个必然 D2 点：** 核心闭环完成后，要进入**任何更深玩法深度**，触碰的都是「升级侧」：
   - **升级（cr-010/011）**：触发窗口（2–3min / 4.5–6min）与 XP 数值是 **D2-Card 候选**（v0.3 §6 / Contact ledger §6 明示「cr-010/011 XP/触发窗口 写死数值即 D2」）。升级事务**要在真实运行中触发暂停，就必须在事务内实例化一个可工作的触发窗口值** —— 这是边界后第一个必须写死一个**操作性 Gate 值**的单位，**必然触发 D2-Card 1，需用户亲自决策**。
   - **B2（cr-016..019）**：`扇裂` 三弧依赖升级事务与穿透规则；其几何/数值/重复命中策略是展开时的**定义检阅 + 数值提升面**，且 B2 呈现触碰 UX-11 / playability gate。
   - **可玩性观察门（DC-PLAY-01 Option 2，R08）**：其**阻断权延后，激活必经 CR + 用户批准**。核心闭环完成 = §9.2 playability gate 判据的首次实测点（"immediate retry after failure without punitive delay" 等）。
3. **结论：** 接触收尾 + 终结/重置把核心闭环做成可玩切片；**一旦超过此闭环去触碰升级/B2/候选预算/Gate3/发布 任一 → 必触发 D2 或强制用户介入**。故授权边界 = **核心可玩闭环完成并经 QA 验收，止步于任何升级侧单元 / Gate 3 视觉验收 / 候选预算提升 / O8 全量真人验收 / 发布导出之前**。

### 2.2 授权边界（一句话，供用户确认）

> **授权范围 = 「接触单元收尾 + 终结/重置体验（core loop 闭环）」，全部数值走 ledger 候选、promotion=User、不写死常数；止于「核心可玩闭环完成并经 Independent QA 独立验收成为可玩切片」这一硬点，绝不越过跟升级/B2/候选预算/Gate 3 视觉验收/O8 真人全量/发布导出 相关的任何 D2 升级卡片或强制用户里程碑。**

### 2.3 边界判定的排除项（为什么不是其它候选）

| 候选边界 | 判定 | 理由 |
|---|---|---|
| 升级单元数值（cr-010/011） | **不是边界本身，而是边界后第一个 D2 点** | 升级依赖 B2 + focus（均延后），非核心闭环依赖；且升级是首个**必须写死操作性触发值**的单位 → 属边界后的 D2，不作为授权边界内的单元 |
| 候选预算提升 | 边界后强制 D2 | 六项候选 + `1280×720` 红线提升为正式门槛即 D2（cr-109 / DC-PERF-01 已选「保持仅候选」）；任何时候触碰即停 |
| Gate 3 视觉验收 | **边界后强制用户里程碑** | DC-ACC-02（B3 红 line UX-09..13）+ playability gate 属用户保留的视觉/可玩性验收；不进入授权内 |
| B2 定义检阅（cr-016..019） | 边界后强制用户里程碑 | B2 是玩法扩张（`扇裂` 三弧），触碰 UX-11 / playability gate + 数值提升面 |

---

## 3. 单元序列（边界内全部可自动推进开发单元）

> 每单元：范围 / owner / 依赖 / 验收路径（Gate 2 扩展 vs Gate 3 前段）/ AUTH-01 判定（见 §4 判定表）。所有单元**保持候选数值走 ledger、promotion=User、不写死常数**。

### 单元 3 — 接触单元收尾（already-authorized, D1，QA 独立验收进行中）

- **范围：** 承接 v0.3 候选 B 波 2 —— C2 规则核 contact 扩展 / C3 CONTACT-\* fixture（含同时接触/边界）/ C4 adapter·运行时接触·伤害·无敌·分离·再武装 / C5 life 扣减 read-model 呈现（`segments_lost` 从 0 结构位 → 实测扣减）/ C6 玩家伤害体验 UX 观察目标；**数值全走 CONTACT ledger 候选，不锁**。
- **Owner：** Engineer（实现）+ Systems（C1 ledger 语义）+ UX（C5/C6 提案）+ QA（独立验收）。
- **依赖：** 已就位（真实移动基线/失效 (ii)/read-model seam/adapter seam）；前置 CONTACT ledger + life 数值语义 + 接触检测 seam + 玩家伤害观察目标（均已产出）。
- **验收路径：** Gate 2 扩展（CONTACT-\* headless 复跑 exit 0 逐位一致）+ Gate 3 前段（接触惩罚/分离/生命扣减可读、UX-13 非色彩、UX-09 不遮挡、玩家伤害可归因非惩罚）。
- **AUTH-01：** **D1 自动推进**（机制在已批准 ADR-TECH-05 + 决策 #4/#5 内，S1 模式 ledger；无前置强制 D2）。
- **边界警示：** 若实施中任一 contact 数值被写为规则常数/Gate 判据/发布承诺 → D2-Card 1 立即暂停升级；若堆叠改 #4（N×）→ D2-Card 2；若触碰 player promise → D2-Card 3。

### 单元 4 — 终结/重置体验（cr-014, cr-015；core loop 闭环，D1 边界内）

- **范围：** 终结仲裁实现（`life` 耗尽 vs 8 分钟完成**同帧生命优先**，ADR-TECH-05 已批）+ 短结局呈现（victory = 控制完成 #11 / defeat = light interruption #12，非惩罚）+ **立即自动重置 / 立即重试**（决策 #5，无越局损失）→ 形成「可完整玩一遍并自动重试」的**核心可玩闭环**。结局时长 / 清理时序 / RNG·ID 重置 / 陈旧输入拒绝等**数值与精确语义全部走 ledger 候选、promotion=User，不锁**。
- **Owner：** Systems（终局/重置语义 ledger 前置，S1 模式）+ Engineer（终局仲裁 + result/reset 实现 + fixture）+ QA（独立验收）。
- **依赖：** 单元 3 验收 pass（`life` 扣减真实、可耗尽）；ADR-TECH-05 终局仲裁+重置机制边界已批；决策 #5/#11/#12 `user_confirmed`；cr-014/015 `absorb_within_authority`。
- **验收路径：** Gate 2 扩展（`TERMINAL-*` / `RESET-*` fixture：同帧生命优先、结果时长、自动重置、无越局脏状态）+ Gate 3 前段（结局/重试可读、非惩罚、立即重试）。
- **AUTH-01：** **D1 自动推进**（机制已批 + 决策 #5/#11/#12 已确认 + 数值走候选 ledger）；**但该单元的玩家可见结局呈现是 §9.2 playability gate 首次实测点** → 其 playability 门确认属授权边界（见 §6 边界外里程碑）。
- **边界警示：** 结局呈现若触碰 player promise（非惩罚）/ Pillar / 被提议为发布文案 → D2-Card 3；任一终局/重置数值写为规则常数/Gate 判据 → D2-Card 1；**本单元完成即作者达授权边界，随后必须停下等用户做可玩性门 + 首个升级 D2 决策**。

### 单元 5（可选，边界内或并入）— focus 前段最小失焦冻结（cr-012 前段）

- **范围：** 窗口/应用失焦时立即冻结战斗与确认（PRECHARTER-09 + 决策 #17：冻结/保留选择/新鲜输入/拒陈旧 Enter-Space）；事件 epoch 机制（ADR-TECH-05 focus epoch **机制提案已批**）。
- **Owner：** Engineer（机制）+ UX（UX-06/07/08 观察目标封闭，未决前置 R6）+ QA（观察）。
- **依赖：** ADR-TECH-05 focus epoch 机制边界已批；决策 #17 `user_confirmed`；cr-012/013 `absorb_within_authority`。
- **验收路径：** Gate 2 扩展（`FOCUS-*` fixture）/ Gate 3 前段（失焦冻结可观察）。**注意：** focus 的核心价值最明显在「升级暂停确认」——由于升级（cr-010/011）延后，本单元多为**前段基础**；可作独立 D1 单元，或与终结/重置并存（终端重置也需拒绝陈旧输入）。若 UX R6 未决前置（combat-freeze scope / return-focus target / platform event policy）无法在有界内封闭 → 如实标注 unresolved，**不把 focus 复杂化推进为升级暂停确认**。
- **AUTH-01：** **D1 自动推进**（机制边界已批 + 决策 #17 已确认；若失焦语义触碰 UX-06/07/08 观察门判据 → Gate 3 / user 里程碑见 §6）。

> **单元 4 完成即达授权边界。** 单元 5（若纳入）应在单元 4 前或与之并行作为前段基础；两者均不越升级/B2/Gate 3 视觉/候选预算/O8/发布。

### 明确不进入边界内（依赖/升级门，见 §6）

- **升级（cr-010/011）**、**B2（cr-016..019）**、**spawn 正式化**、**候选预算提升**、**Gate 3 视觉验收**、**O6 外层 evidence-harness finalization**、**O8 真人自由操作全量验收**、**发布/导出**、**资产/动画/音频/数值定稿 / 视觉基线 v0.2** —— 全部边界后 / 边界外。

---

## 4. D1/D2 判定表（每单元逐项标注）

> AUTH-01：非升级项自动接受专家建议（D1）；升级项（阈值/发布/平台/锚点类）用户亲自决策（D2）；冲突升级（D3）。

| 单元 / 工作项 | AUTH-01 判定 | 依据 / 触发条件 |
|---|---|---|
| **单元 3 接触收尾（C1..C6 + T）** | **D1（自动推进）** | 机制在已批准 ADR-TECH-05 + 决策 #4/#5 内；数值全 ledger 候选；S1 模式 ledger 模式已验证。**无前置强制 D2。** |
| ├ 接触数值写为规则常数/Gate 判据/发布承诺 | **若触发 → D2-Card 1（暂停升级）** | v0.3 §6 / CONTACT ledger §6；promotion=User |
| ├ 堆叠/同时接触改 #4（N× 多次伤害） | **若触发 → D2-Card 2（暂停升级）** | 改变「单次伤害事件」已确认决策 |
| ├ 玩家伤害形态触碰 player promise/Pillar | **若触发 → D2-Card 3（暂停升级）** | 非惩罚 Pillar 4 / 决策 #12 |
| **单元 4 终结/重置（cr-014, cr-015）** | **D1（自动推进）** | ADR-TECH-05 终局仲裁+重置**机制边界已批**；决策 #5（结果+立即重试）/ #11（victory）/ #12（defeat=light interruption）`user_confirmed`；结果时长等数值走 ledger 候选。 |
| ├ 终局/重置数值写为规则常数/Gate 判据/发布承诺 | **若触发 → D2-Card 1（暂停升级）** | cr-014/015 absorb；promotion=User |
| ├ 结局呈现触碰 player promise/Pillar / 发布文案 | **若触发 → D2-Card 3（暂停升级）** | 非惩罚 Pillar 4 / #12 |
| └ 结局呈现（可玩性门首次实测） | **D1 实现 + QA 前段观察；playability 门确认留边界外（User）** | §9.2 playability gate；DC-PLAY-01 R08 阻断权延后经 CR+用户 |
| **单元 5 focus 前段（cr-012/013）** | **D1（自动推进，若有界封闭）** | ADR-TECH-05 focus epoch 机制边界已批；决策 #17 `user_confirmed`；若 UX-06/07/08 未决前置无法有界封闭 → 如实 unresolved、不复杂化 |
| **候选预算提升（六项 / 1280×720）** | **强制 D2（升级任何候选为正式门槛）** | cr-109 / DC-PERF-01；任何时刻触碰即停，绝不进入授权内 |
| **升级触发窗口 / XP（cr-010/011）** | **强制 D2（写死操作性触发/XP 值）** | 升级事务内需实例化触发窗口 → 首次必须写死 Gate 值；边界后首个 D2-Card 1 |
| **B2 三弧（cr-016..019）定义检阅** | **强制用户里程碑 + 数值面 D2** | 玩法扩张（`扇裂`）；UX-11 + playability gate + 数值提升面；边界后 |
| **Gate 3 视觉验收（UX-09..13 红 line）** | **强制用户里程碑（user-reserved）** | DC-ACC-02（B3）；完整可玩切片结局的视觉/可用性验收由用户裁决 |
| **O8 真人自由操作全量验收** | **强制用户里程碑** | 需实际人类自由操作；QA 不能全量模拟（O8 未决） |
| **发布 / 导出 / 平台承诺** | **强制 D2（发布类）** | cr-101..105 / ADR-TECH-08；任何发布/导出姿态即用户决策 |
| **O6 外层 evidence-harness / raw 留存定稿** | 边界外工程（非 D2，但非核心闭环） | 授权范围聚焦核心可玩闭环；O6 属 ADR-TECH-06 执行层后续，可独立授权工程单元 |

**判定结论：授权范围内全部单元为 D1（自动推进），无数值写死、无 D2 前置触发；任何条件触发 D2-Card 1/2/3 或触碰候选预算/Gate 3/O8/发布 → 立即暂停自动推进并升级到用户。** 授权边界 = 单元 4 完成并经 QA 验收（core loop 闭环），随后停下交用户。

---

## 5. 护栏（授权范围内的执行仍受约束）

授权（若用户最终给予）**不豁免**以下任何一条 —— D1 自动推进 ≠ 无约束：

1. **每单元 Independent QA 独立验收：** 每单元仍由 Independent QA 依当前版本基线独立执行 Gate 2 扩展（确定性 fixture 复跑，exit 0 逐位一致）+ Gate 3 前段观察并给独立 verdict；实现者不自证；Producer 不豁免 QA blocker；缺失 mandatory 证据字段 = `not_run`（不是 pass，B3）。
2. **每单元透明报告 + 用户保留否决权：** 父协调器对每单元作透明报告（含证据边界、O8/O7 受限声明）；**用户保留任何时刻的否决权**——清单授权是「减少逐单元等待」，不是剥夺用户叫停。
3. **任一 D2-Card 触发立即暂停并升级：** 接触/终局任一数值被写为规则常数/Gate 判据/发布承诺 → D2-Card 1；堆叠改 #4 → D2-Card 2；触碰 player promise（非惩罚）→ D2-Card 3 —— **立即暂停自动推进，呈交用户亲自决策**，绝不静默吸收。
4. **不批准/冻结任何契约：** 授权内不批准/冻结任何 ADR、Systems 终裁、fixture schema、数值、表现形态；不把任何 `team_proposal`/`assumption`/候选数值提升为 `user_confirmed`。
5. **候选数值不提升：** 全部 contact/终局数值走 ledger 候选（range+starting_point，promotion_authority=User），不写死常数；候选预算（六项 + `1280×720` 红线）不触碰。
6. **范围纪律：** 每单元有界、可验收、可玩家可见；延后项（升级/B2/spawn/资产/音频/O6/O8/发布）不挤入；hint/文案/布局/资产不冻结。
7. **GDMCP 铁律：** Godot 项目任何检查/变更必须经 gdmcp 预检（doctor / editor-state）+ 记录实际 start 证据；实现 owner 唯一写 owner。
8. **git/版本控制：** 每单元实现与文档分别 commit，保留 source-revision 可溯源性（ADR-TECH-03/08 隐含依赖）。
9. **不替用户做产品/验收裁决：** 授权内所有单元的实现与 QA 观察**不代用户做任何产品级裁决**；终局呈现的可玩性门确认、升级/B2/候选预算/Gate 3/O8/发布 全部留边界外用户决策。

---

## 6. 授权边界外余项（之后仍必须用户介入的里程碑清单）

> 边界 = 单元 4（终结/重置）完成并经 QA 独立验收（核心可玩闭环）。此后以下每一里程碑仍必须**用户亲自介入**（并入 CRC/U 决策包或逐次验收/授权），父协调器不得越过边界自动推进：

| # | 里程碑 | 用户需介入的具体决策 | 类别 |
|---|---|---|---|
| M1 | **可玩性观察门确认（核心闭环成果）** | 核心闭环（移动+自动攻击+接触+结局+立即重试）可否玩性门（§9.2 / revision-02 #6）通过；是否激活阻断权（DC-PLAY-01 R08） | playability gate / user |
| M2 | **Gate 3 视觉验收（完整切片结局）** | 完整可玩切片的视觉/可用性（UX-09..13 红 line，DC-ACC-02 B3）达到用户验收标准 | visual acceptance / user |
| M3 | **升级（cr-010/011）数值与事务** | 触发窗口（2–3min/4.5–6min 候选）与 XP 数值是否提升为正式规则/Gate 判据（**D2-Card 1**）；卡牌池/变体/文案（cr-011） | upgrade D2 / user |
| M4 | **B2 定义检阅（cr-016..019）** | `扇裂` 三弧几何/数值/重复命中策略定义检阅；UX-11 不遮蔽红线；数值提升面 | expansion D2 / user |
| M5 | **候选预算提升（六项 / 1280×720）** | 任何候选性能/分辨率值提升为正式门槛（cr-109 / DC-PERF-01——目前均保持仅候选） | threshold D2 / user |
| M6 | **O8 真人自由操作全量验收** | 实际人类键盘自由操作全程验收（依赖真人；QA 不能全量模拟） | validation / user |
| M7 | **发布 / 导出 / 平台承诺** | 任何发布姿态 / 导出产物 / 平台承诺（cr-101..105 / ADR-TECH-08 / Gate 5-6） | release / user |
| M8 | **O6 evidence-harness finalization（可选工程单元）** | 外层 fixture envelope / raw 留存 / Producer index 链路（ADR-TECH-06 执行层）定稿——可按独立工程授权处理，非玩家可见 | engineering / user |

> 边界后的推进**不自动发生**；父协调器在 M1/M2 处即应向用户呈交里程碑决策包，逐次获得授权后再推进 M3/M4 等。本清单不预授权任何边界外项。

---

## 7. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed（含决策 #3/#4/#5/#7/#8/#9/#11/#12/#17/#19）；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；cr-001 (R09)；ADR-TECH-01..06 批准（R11，含 TECH-05 机制边界）；UX-03 S1–S3；AUTH-01（R13）；单元 1/2 QA verdict `pass`。本清单不重写、不重分类任何一项。
- **`team_proposal`（本清单的实质贡献）:** 授权边界判定（core loop 闭环 = 首个必然 D2/强制介入点，升级/B2/Gate3/候选预算/O8/发布为边界外）；边界内单元序列（接触收尾 / 终结·重置 / [可选] focus 前段）；D1/D2 判定表；护栏；边界外里程碑清单（M1–M8）。全部为**范围界定建议**，供用户审阅并作最终授权；不升级任何契约/数值。
- **`assumption`:** ① 终结/重置（cr-014/015）作为 D1 自动推进的前提是其机制在已批 ADR-TECH-05 + 决策 #5/#11/#12 内、结果时长等数值走候选 ledger（需用户对「终结/重置纳入授权内」的认可 + Engineer 落地 + QA 观察验证）；② focus 前段（cr-012/013）若有界封闭可作为 D1（需 UX-06/07/08 前置可封闭，未封闭前为待验证）；③ 可玩性门（revision-02 #6 / DC-PLAY-01 R08）作为边界后的强制用户点（判据结构已生效、阻断权延后经 CR+用户激活）。均未在此代决。
- **`unresolved`（全量保留，未关闭）:** cr-006..009 精确值；cr-010/011 升级触发/XP 数值；cr-012/013 focus 精确语义；cr-014/015 终结/重置精确时长/清理；cr-016..019 B2；spawn 节奏；O6 evidence-harness；O8 真人自由操作；life `life_state` 枚举；伤害反馈表现形态；候选预算（六项 + `1280×720` 红线）——全部保持 open，本清单不闭合、不升级任何项。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本清单未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升；未批准/冻结任何契约/规则语义/数值/表现形态。

---

## 8. 边界声明与 Closure

- **未替用户做产品/验收裁决**：本清单是**授权范围界定建议**；最终一次性授权由用户作出；终局可玩性门、Gate 3、升级/B2、候选预算、O8、发布等产品/验收裁决均归属 User。
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。
- **未触碰 Godot / 运行时 / 数值 / 契约**：未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未批准/冻结任何 ADR/Systems 终裁/fixture schema/数值/表现形态；候选预算不提升；QA 不豁免；未替任何角色代权（Systems/UX/Tech/QA 语义均未代决）。
- **写入面**：仅本唯一授权范围工作清单文件 `AUTHORIZATION_WORKLIST_D2_PRE_v0_1.md`；未修改任何其它文档（CR 台账、合同、排程、ledger 等一律未触碰）。
- **git 状态**：接触单元 docs/QA 待提交本属既有状态，本清单不强推任何提交。

**Closure:** `closure_ready = yes`（仅限本授权范围工作清单 artifact）。本清单非实现派发、非契约批准、非 QA 验收、非产品裁决、**非最终授权本身**；用户审阅并作最终一次性授权后，父协调器方按 §3 单元序列自动推进（仍受 §5 护栏、逐单元 QA + 透明报告、任一 D2 触发即暂停升级）。写入后停止，不进入下一阶段、不派发任何成员。

---

## 9. 版本与变更记录

- **v0.1（本文件）:** Executive Producer / Lead Producer 唯一新产物——依据用户「在 D2 升级卡片前的所有开发工作先列清单再作最终授权」指令，界定授权范围工作清单：授权边界（核心可玩闭环完成并经 QA 验收 = 首个必然 D2/强制介入点，理由依据依赖真相）；边界内单元序列（接触收尾 / 终结·重置 / [可选] focus 前段，均 D1，数值走候选 ledger）；D1/D2 判定表（逐项，含必须排除项：升级数值/B2/Gate3/候选预算/O8/发布）；护栏（QA 独立验收/透明报告/D2 暂停/不冻结/数值不提升/GDMCP/git/不代裁决）；边界外里程碑 M1–M8；Provenance 分层与不变量保留完整。未修改任何其它文档。
