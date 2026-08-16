# NEXT IMPL UNIT PLAN v0.1 — 下一实现单元排程建议（sequencing）

> **Status:** `SEQUENCING RECOMMENDATION` — 仅排程建议，不派发实现、不批准/冻结契约、不替用户做产品/验收裁决、不豁免 QA。父协调器按本建议派发。
> **Role / owner (sole author):** Executive Producer / Lead Producer（执行制作人 / 首席制作人）
> **Report ID:** `NEXT_IMPL_UNIT_PLAN_v0_1`
> **Expert capability:** `godot-executive-producer-expert` — 实测 `skill({name:"godot-executive-producer-expert"})` **调用成功**（返回值完整 SKILL 指令），能力证据等级 = `strong_direct_skill`（首选等级）。无需 fallback 到 SKILL.md 读取。
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **Evidence class:** `static/source` only（本建议仅依据全部指定只读文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试；未派发任何成员）。
> **前置事实（Gate 2 已通过）:** `rules_core.gd` + `session.gd` + `rules_core_test.gd`（7 用例，target 语义 + session）经 Independent QA Gate 2 独立验收 = **verdict `pass`**（`QA_GATE2_VERDICT_v0_1.md`），附非阻断观察项 O1/O2/O3。

---

## 1. Expert preflight（本排程任务的执行前置）

| 项 | 值 |
|---|---|
| 契约 | ADR-TECH-01..06 已批准（seam/纯度/read-model/确定性/target 快照/headless）；ADR-TECH-05 机制边界已批准（contact/upgrade/focus/terminal），精确数值语义延后（cr-006..020 Systems in_flight）；cr-001 已决（Option A 键序）；cr-002/004/005 仍 unresolved（吸收路径，提案 M-1 / (ii) / quiet-cycle 在库） |
| 用户指令 | 「继续实现（adapter/presentation 或下一块——按 slice 推进）」 |
| 本建议不替代 | 用户产品裁决；Independent QA verdict；Systems 语义定裁；Tech ADR 批准；任何数值提升 |
| 停止条件 | 唯一排程建议文件写入即停；不进入下一阶段、不派发任何成员 |

---

## 2. 边界与已确认事实（仅使用这些）

- **不变量:** 22 项原始 `user_confirmed`；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；unresolved 全量保留。
- **已实现并通过 Gate 2:** 规则核心（target 语义：pre-fire refresh→stable-sort→lock、no-target、失效 drain 点 (ii)、trace 字段）+ session（tick/seed/reset）+ 7 用例测试。
- **Slice（交接包）:** 8 分钟有界 Slice；**移动 + 自动攻击 + 接触 + 两次升级暂停 + 结局与重试**；PC-first 键盘；低认知清屏控制。
- **ADR-TECH-01 seam（已批准）:** rules core → session → adapter → presentation/read-model。
- **未实现:** adapter、presentation/read-model、接触（cr-006..009）、升级（cr-010..011）、B2（cr-016..019）、终局/重置（cr-014..015）、**敌人 HP/死亡/生成语义（未登记为独立 CR——属 Systems 语义范围）**。
- **QA 观察项 O1/O2/O3:** 非阻断，供后续精化。
- **候选预算（六项 + `1280×720` 红线）:** 仅候选，本任务不涉及、不提升。

---

## 3. Slice 目标与下一单元应证明的最小垂直切片

Slice 的最小可玩垂直切片 = `移动 → 自动攻击 → 命中 → 清屏`（movement → auto-attack → hit → kill → clear-screen）。其**完成判定**是：一次自动攻击命中可导致敌人被击杀/清除、压力降低、可再生移动空间恢复（Systems §9.2 可玩性观察项之一：「attack/kill results reducing pressure and recovering a corridor」）。

下一单元必须把上述因果环中**至少前四个动词可观察地落地**：玩家可移动；自动攻击可见地指向被锁定快照目标并开火；命中可读（绑定 `hit_results`，非伪造）；**击杀→清除**可观察。

---

## 4. 两条路径分析（Scheduling 决策核心）

### 4.1 路径 A — Adapter 层 + 最小运行时场景

**范围:** 输入设备→domain input envelope；规则核 `step` 驱动（session）；域事件→引擎反馈；玩家移动 + 敌人 + 自动攻击可见；最小 read-model（HUD 最小面）。

**依赖分析:**
- ✅ **target 语义**（已实现、Gate 2 pass）——adapter 可直接把引擎实体翻译为 `ordered_candidates` 输入的 candidates（stable_id + position + alive），喂给纯函数 `step`/`ordered_candidates`。**机械翻译可实现**。
- ✅ **session**（已实现）——adapter 经 session 驱动 run 生命周期。
- ⚠️ **敌人 HP/死亡/生成语义（缺口）:** 规则核心当前 resolve `hit_results`，但**无敌人 HP、命中伤害→死亡、清除/波次缩减**概念。要让「自动攻击→击杀→清屏→走廊恢复」可观察，adapter 必须从某处获得「该目标被一击是否死亡、死亡后如何从 live 集移除」。此语义**未登记为独立 CR、未定**（Systems 语义范围）。
- ❌ **接触 / 升级 / B2 / 终局 / 重置:** 本单元**不需要**（slice 前四个动词不含接触惩罚、升级暂停、B2 三弧、结局表现）。

**结论（Path A 单独）:** 可交付**机械接线**（输入、移动、锁定目标自动攻击、命中反馈、最小 render）。但**无法满足 slice 完成判定**（命中→击杀→清除），因为 kill/clear 需要一个最小敌人生命周期规则——这正是 Systems 语义缺口。若只做 Path A，会得到「玩家朝看不见死亡的目标开火」的残缺闭环，撞上前述 Systems 缺口被迫中断。

### 4.2 路径 B — 先扩展规则语义（Systems 提案：接触/HP/死亡/生成/升级最小集）

**范围:** 先用纯规则核扩展 Systems 语义（接触、敌人 HP/死亡/生成、升级、B2、终结等的最小集），**再**做运行时。

**依赖分析:**
- ✅ 把 slice 完成判定（击杀→清除）落在**确定性纯规则核**内，fixture 证据可继续走 Gate 2 扩展、可复现。
- ⚠️ **零玩家可见进展:** Path B 单独产出更多 fixture/测试，但**无输入、无移动、无可见自动攻击、无清屏**。它不是垂直切片，违反「最小可玩」意图与用户「adapter/presentation 或下一块」的明确命名。
- ❌ **失控风险:** contact(006..009)+HP/death/spawn+upgrade(010..011)+B2(016..019)+terminal/reset(014..015) 全 unresolved，若一次性全扩 = 无界规则扩张、延后「首见可玩」无限期——违反 vertical-slice 纪律。

**结论（Path B 单独）:** 不能单独作为下一单元。它是**前置语义**，但不是交付完整切片。

### 4.3 综合（依赖的真相）

- **真正卡住「下一可玩单元」的硬前置** = **最小敌人生命周期子集（HP + 命中伤害→死亡 + 死亡/清除缩减）**。它是 Systems 语义范围、未登记为独立 CR，**但**它是在已批准契约内实现 slice 完成判定的**必需语义**。
- **接触 / 升级 / B2 / 终局 / 重置** 与 slice 前四个动词**可分离**——不需本单元做，留后续单元。
- 因此：**不可纯 A、不可纯 B**。正确的是**单一下一单元**：把「最小击杀清除语义」作为**同单元内的薄 Systems 语义前置**先落（仅自动攻击 kill 路径），再在其上实现 adapter + 最小运行时场景——即 **Path B 的最小子集前置 + Path A 全量叠加于同一单元**。

---

## 5. 推荐方案（建议）

### 5.1 推荐：下一实现单元 = 「移动→自动攻击→命中→击杀清除」最小可玩垂直切片（A+，含最小击杀/清除语义前置）

**一句话:**
> 下一单元在一个有界范围内同时 (1) 由 Systems 落一条**最小敌人命中生命周期 ledger 行**（仅自动攻击 kill 路径：敌人 HP、单击伤害→死亡、死亡→live/清理缩减；range+starting_point，promotion_authority=User，不锁常数），(2) 实现 adapter seam + 最小运行时场景，把「移动→锁定目标自动攻击→命中→击杀→清除」变成可观察的可玩切片；接触/升级/B2/终局/重置**明确延后**。

### 5.2 单元范围（做什么）

| 子块 | Owner | 交付物 | 写 ownership |
|---|---|---|---|
| **S1 最小敌人命中生命周期语义（薄前置）** | Systems/Rules Designer | `enemy_lifetime` ledger 行/最小规程：敌人 HP（段）、自动攻击单击伤害→死亡、死亡→live 集/清理缩减；range+starting_point；**明确声明此为最小 kill 路径语义，不含接触/升级/B2/终结**；`PROPOSAL` 级 | Systems ledgner（唯一） |
| **S2 规则核扩展（仅 kill 路径）** | Godot Gameplay Engineer（实现 owner） | 在 `rules_core` 内新增敌人 HP/命中结算→死亡/清除的**确定性纯逻辑** + 对应 fixture（`KILL-single` / `KILL-multi` / `KILL-death-removal`）；扩展 `TARGET-*` fixture 族以兼容 enemy-lifetime 字段 | Engineer（Godot mutation） |
| **S3 Adapter seam** | Godot Gameplay Engineer | 输入设备→domain input envelope；规则核 `step` 驱动（session）；域事件→引擎反馈（移动、锁定目标自动攻击、命中/kill 反馈，**绑定 `hit_results`**，空射不伪造锁定/命中——ADR-TECH-02/UX-03 S2）；`adapter` 契约测试 | Engineer（Godot mutation） |
| **S4 最小运行时场景** | Godot Gameplay Engineer | player sprite/node、≥1 enemy node（作为 `ordered_candidates` 输入）、自动攻击可见指向锁定快照目标、击杀→敌人移除→清除可见 | Engineer（Godot mutation） |
| **S5 最小 read-model（presentation 最小面）** | UX/UI Designer + Engineer | 最小 player-facing read-model：life/timer/B2 阶段/HUD 最小集 + no-target/attack-resolution + feedback-binding marker（ADR-TECH-02 / UX R3–R4）；空射安静形态（UX-03 S1–S3） | UX（read-model 字段）+ Engineer（落地） |
| **T non-Godot 测试** | Engineer + QA 独立 | kill-path fixture 确定性验证（headless gdUnit4）；adapter 契约测试 | 实现 owner 自证 / QA 独立复核 |

### 5.3 本单元明确**不做**（范围边界，防漂移）

- ❌ **接触（cr-006..009）**：玩家-敌人重叠伤害/无敌/分离——延后独立单元。
- ❌ **升级（cr-010..011）/ 两次升级暂停**：触发/XP/卡牌——延后。
- ❌ **B2（cr-016..019）/ `扇裂` 三弧**：延后；本单元只有单中心方向自动攻击（B2 前形态）。
- ❌ **终局/结局表现与自动重试（cr-014..015）**：延后。
- ❌ **focus-loss epoch / 失焦缓冲（cr-012..013）**：延后（本单元不引入窗口失焦交互）。
- ❌ **候选预算提升 / 性能测量（TECH-07/08）**：不进入；六项候选 + `1280×720` 红线仍仅候选。
- ❌ **资产生产 / 视觉基线 v0.2 / 动画 / 音频 / 数值平衡定稿**：不进入；本单元用占位/最小表现，无美术验收承诺。
- ❌ **玩家可见 Replay（cr-203）**：明确缺席（QA/debug 可复现性仅为本单元 fixture 承继）。
- ❌ **持久化 / 存档 / 网络 / 发布 / 导出**：不进入。

### 5.4 依赖与 Systems/UX 语义前置（明确回答「哪些前置、哪些可现做」）

**需要一个最小 Systems 语义前置（本单元内、薄）：**
> 敌人 HP + 自动攻击命中伤害→死亡 + 死亡后 live/清理缩减（仅 kill 路径）。理由：slice 完成判定「击杀→清除→走廊恢复」依赖它；规则核当前无此概念。该前置由 Systems 以 ledger 行（range + starting_point，PROMOTION=User）产出，**不是契约冻结、不触碰已批准 ADR 语义**。

**可在已批准契约内直接实现（无需新语义前置）：**
> adapter seam 机械翻译（输入↔domain envelope）、session 驱动、锁定目标自动攻击、命中/kill 反馈绑定 `hit_results`（ADR-TECH-02/UX-03 S2 已批准边界）、最小 HUD/read-model 字段（life/timer/B2 + no-target + feedback-binding，ADR-TECH-02 R3/R4 已批准边界）、no-target 安静形态（cr-005 quiet-cycle 提案可在吸收路径内实现，不触碰承诺）。

**明确不需要（本单元）的 Systems/UX 前置:**
> 接触伤害、升级触发/卡牌、B2 几何/重复命中、focus epoch、终局/重置仲裁 —— 均与 slice 前四个动词可分离，留后续单元，**不挤入本单元**。

---

## 6. 角色分工（成员 → 交付物 → 写 ownership）

| 成员 | 关键性 | 交付物 | 写 ownership（单一） |
|---|---|---|---|
| Systems/Rules Designer | 非关键（单发） | S1 最小敌人命中生命周期 ledger 行/规程（`PROPOSAL` 级，数值仅候选） | Systems ledger（唯一写 owner） |
| Godot Gameplay Engineer | **关键（实现 owner）** | S2 规则核 kill 路径扩展 + fixture；S3 adapter seam + 契约测试；S4 最小运行时场景；S5 read-model 落地 | Godot 构件唯一写 owner（经 GDMCP） |
| UX/UI Designer | 非关键 | S5 read-model 字段提案（life/timer/B2 + no-target + feedback-binding）+ 空射不伪造形态确认（UX-03 S1–S3 原则） | read-model 字段提议（UX）/ 落地归 Engineer |
| Independent QA / Release | **关键（独立验收）** | 本单元确定性 fixture 独立复核（Gate 2 扩展）+ runtime/read-model 可观察性观察（Gate 3 前段） | 验收报告（QA 唯一） |
| （不派发）Tech Lead / Game Director / Balance / Art / Audio | — | 本单元不派发（无 ADR 变更、无创意/视觉验收、无数值平衡、无资产/音频开工） | — |

> 依团队执行纪律：本单元**至少 Engineer（关键）+ QA（关键）**；Systems/UX 为非关键单发。父协调器组建最小 roster。

---

## 7. 验收路径（哪些进 Gate 2 扩展、哪些进 Gate 3）

| 验收面 | 归属 | 判据 / 证据 |
|---|---|---|
| **S2 规则核 kill 路径确定性** | **Gate 2 扩展** | headless gdUnit4 `KILL-*` / 扩展 `TARGET-*` fixture 独立重跑（exit 0，跨 run 逐位一致）；参照 O1 补充逐族容器方差变体（QA 可裁决是否修订判据表述） |
| **S3 adapter 契约测试** | Gate 2 扩展 | adapter 输入↔domain envelope、事件路由契约测试独立复核；空射不伪造绑定 `hit_results`（UX-03 S2） |
| **S5 read-model / 最小 HUD + 可玩性** | **Gate 3 前段（视觉/UX）** | runtime frame + Independent QA：移动→锁定目标自动攻击→命中→击杀→清除可观察；player/danger/space 层级不被 HUD 遮挡（UX-09/UX-10 前段）；non-color 区分基础面 |
| **O1/O2/O3 观察项** | 非阻断精化 | 逐族方差变体（O1）、决策键 trace 落点（O2）、外层 fixture envelope 落盘（O3）——按后续 evidence-harness 层承接或裁决，**不阻塞本单元** |
| QA 独立观察 | Independent QA 独立 | QA 依当前版本基线独立观察，不沿用 builder 自评；不豁免 QA |

> 域事件归 Engineer；语义归 Systems；观察归 UX；验收归 QA；产品裁决归 User。本单元不授予任何 Gate 3+ 免除。

---

## 8. 范围边界（防漂移——明确不做什么）

见 §5.3。要点重述：
- **候选预算（六项 + `1280×720` 红线）不提升**——本单元更不涉及数值定稿。
- **接触/升级/B2/终局/重置/focus-epoch 全部延后**，不挤入本单元。
- **资产 / 动画 / 音频 / 数值平衡 / 视觉基线 v0.2 / 导出 / 发布 / 持久化 / Replay 不进入**。
- **不批准/冻结任何新 ADR / Systems 终裁 / fixture schema / 数值**（最小 kill 语义仅在吸收路径内以 ledger 行产出，PROMOTION=User）。
- **QA 不豁免**；本单元产出为其接受的证据输入，非自证。

---

## 9. 备选方案

### 9.1 备选 A′ — 纯 Adapter + 最小运行时场景（不带 kill 语义前置）
若父协调器/用户倾向最小接线先行：
- 仅交付 S3+S4+S5，S2 敌人生命周期延后到下一单元。
- **代价（如实）:** 本单元无法满足 slice 完成判定「击杀→清除」——自动攻击可见指向目标并命中，但**无死亡/清除结果**，清屏目标不可证。会把「首见可玩完整性」与敌人生命周期语义缺口切在单元边界上，局部 ok 但完整的可玩闭环要等下一单元。
- **适用情形:** 若希望最小化本单元 Systems 依赖、先把机械 seam 与输入/移动跑通（sandbox 验证 adapter 可行性），再在下一步叠加 kill 语义。

### 9.2 备选 B′ — 纯规则核 kill 语义扩展（不带 adapter）
若父协调器/用户首选纯语义先行：
- 仅交付 S1+S2（+ 扩展 fixture），adapter/运行时延后。
- **代价（如实）:** 充足确定性 fixture 证据，但**零玩家可见进度**；违反 vertical-slice「最小可玩」意图与用户命名 adapter/presentation；有往 contact/upgrade/B2/terminal 无界扩展的漂移风险（已在 §4.2 分析）。
- **适用情形:** 反复出现确定性/语义不确定性以致运行时 wiring 无法稳定的罕见情况（当前 target 语义已稳定通过 Gate 2，此风险低）。

### 9.3 推荐理由（为何推荐 A+ 而非备选）
- **满足 slice 完成判定**：A+ 首次让「击杀→清除→走廊恢复」可观察（slice 目标的最小可玩证明）。
- **唯一真正硬前置（敌人 kill 语义）在单元内以薄 Systems ledger 前置解决**，不扩大为无界规则扩张；接触/升级/B2/终结可分离、明确延后。
- **对齐已批准契约与用户指令**：ADR-TECH-01 seam 全链（session→adapter→presentation）首次贯通；用户点名 adapter/presentation，A+ 正是其实现载体。
- **确定性证据可延续 Gate 2 扩展**：kill 语义落在纯规则核，fixture 独立复核可复现，延续最小核心已建立的证据纪律。

---

## 10. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；revision-02 #3/#4；PRECHARTER-01..11；cr-001 Option A (R09)；ADR-TECH-01..06 批准 (R11)；AUTH-01 (R13 实现授权)。本建议不重写、不重分类任何一项。
- **`team_proposal`（本建议的实质贡献）:** 「移动→自动攻击→命中→击杀清除」最小可玩垂直切片作为下一单元；最小敌人命中生命周期 ledger 前置；adapter+最小 read-model 接线；接触/升级/B2/终结延后的排程顺序。全部为**排程建议**，供父协调器决策使用；不升级任何契约。
- **`assumption`:** ① 敌人 HP/死亡/生成语义可在已批准契约内以最小 kill 路径 ledger 行解决而不触发升级（不触碰承诺——**判断依据：** 它与切片「auto-attack→kill→clear」是同一已确认方向，未改写「移动→自动攻击」承诺，最小生命为机制推进而非新系统；但**若 Systems 审理认为触及承诺/性能/平台边界则须升级**）；② 前四动词与接触/升级/B2/终结可分离（Systems §4 时序 + 切片交接支持）。均需 Systems 审理确认，未在此代决。
- **`unresolved`（全量保留，未关闭）:** 本单元不关闭任何 unresolved 项——敌人 kill 语义的精确 HP 值/伤害值仍在 ledger 候选；接触/升级/B2/终结/focus-epoch/性能候选等全部维持原状。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本建议未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升；未批准/冻结任何契约/规则语义/数值。

---

## 11. 边界声明与 Closure

- **未替用户做产品/验收裁决**：本文件是**排程建议**；最终产品裁决与验收归属 User 与 Independent QA。
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。
- **未触碰 Godot / 运行时 / 数值 / 契约**：未访问/修改 Godot、代码、场景、资源；未运行/构建/测试；未批准/冻结任何 ADR/Systems 终裁/fixture schema/数值；候选预算不提升；QA 不豁免。
- **写入面**：仅本唯一排程建议文件 `NEXT_IMPL_UNIT_PLAN_v0_1.md`；未修改任何其它文档。

**Closure:** `closure_ready = yes`（仅限本排程建议 artifact）。本建议非实现派发、非契约批准、非 QA 验收、非产品裁决；父协调器据本建议决策是否/如何派发下一实现单元。

---

## 12. 版本与变更记录

- **v0.1（本文件）:** Executive Producer / Lead Producer 唯一新产物——下一实现单元排程建议。分析 Path A（adapter+运行时）与 Path B（先扩规则语义）依赖，推荐 **A+ 混合单单元**（最小敌人 kill 语义 ledger 前置 + adapter + 最小运行时场景 + 最小 read-model），明确延后接触/升级/B2/终结/focus；给出角色分工、验收路径（kill-fixture → Gate 2 扩展；read-model/可玩 → Gate 3 前段）、范围边界与备选（A′/B′）。未修改任何其它文档。
