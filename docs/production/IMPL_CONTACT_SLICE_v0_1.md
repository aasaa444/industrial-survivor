# IMPL CONTACT SLICE v0.1 — C2/C3/C4/C5 接触语义 + 玩家伤害 实现说明

> **Status:** `IMPLEMENTED (local engineering evidence)` — **本地测试/运行时观察 ≠ Independent QA 验收**（Gate 2 扩展 / Gate 3 前段由 Independent QA 独立执行，本实现不豁免、不自证）。
> **Role:** Godot Gameplay Engineer（玩法工程师 · 实现 owner）——C2/C3/C4/C5 实现 owner。
> **Artifact owner (sole author):** Godot Gameplay Engineer
> **Report ID:** `IMPL_CONTACT_SLICE_v0_1`
> **Version:** v0.1（首版）
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **排程输入:** `NEXT_IMPL_UNIT_PLAN_v0_3.md`（单元 B：接触语义 + 玩家伤害；C2 规则核 contact / C3 CONTACT-\* fixture / C4 adapter·运行时接触·伤害·分离 / C5 life 扣减 read-model 呈现）；Systems §6.1 合法接触转移链 + §6.3 接触 fixture 矩阵（`KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md`）；ADR-TECH-05 接触机制边界（决策 #4 单次伤害事件）。
> **C1 到齐状态标注（如实）：** 会话开始时 `CONTACT_LEDGER_v0_1.md` **尚未存在**（glob 未发现），按 packet「给定 C2 要点」实现；**会话末段 C1 ledger 已到齐（`CONTACT_LEDGER_v0_1.md`）**。本实现已与 C1 逐条对齐（见 §5.2 对齐表）：单次伤害/扣 1 格/吞并/不可重复/fixture 断言均一致；**唯一候选注记 = 无敌模型本实现取「全局窗口」，C1 起始建议为「成对模型」（全局/成对均 `unresolved`，两者都满足 ADR-TECH-05「无敌内无重复伤害」机制边界，fixture 断言模型无关）**；另分离距离候选 26px vs C1 起始 16px（均候选，promotion=User）；边界不去轴（最小切片无竞技场边界，cr-009 延后）。
> **源修订（git）:** 本项目 Godot 构件分支；基于上一单元 `194618d` 新增本单元变更（见 §9 变更清单，经 git 提交）。

---

## 0. 授权与边界声明（总览）

- 本任务为**唯一被派遣成员**执行的实现单元 = **C2 + C3 + C4 + C5**，按 Producer 排程单元 B 派发；R13 实现授权 + `NEXT_IMPL_UNIT_PLAN_v0_3` §6 AUTH-01（无前置强制 D2，推荐默认全程 D1）生效，本单元经 GDMCP 变更 Godot 构件。
- **所有 Godot 构件变更均经 GDMCP**（`execute_editor_script` + FileAccess 权威覆写/追加 + `scripts read` 再检 + `analyze_script` 校验 + `reload_project` 刷新缓存）；**无 shell/direct-write 绕道**（变更源为 `D:\Game\New_Game\dsh_gdmcp_staging\*.v0_3.gd` 草稿，最终磁盘内容经 GDMCP 写入；见 §11 清理声明）。
- **C1 ledger 到齐对齐标注：** `CONTACT_LEDGER_v0_1.md` 会话开始时 glob 未发现，按 packet「给定 C2 要点」实现；**会话末段 C1 已到齐并已逐条对齐**（见 §5.1 对齐表）；无敌模型取全局（候选）、分离距离 26px（候选）、边界不去轴（最小切片无边界）为候选对齐注记。
- **未实现接触之外的延后项**：升级（cr-010..011）/ B2 三弧（cr-016..019）/ 终结/重置（cr-014..015）/ focus epoch（cr-012..013）/ spawn / 资产 / 动画 / 音频 / 数值定稿 / 视觉 v0.2 / 导出 / 发布 / 持久化 / Replay（全部延后，见 §8 边界声明）。
- 未提升任何候选数值；候选预算（六项 + `1280×720` 红线）仅候选、本任务不涉及；未豁免 QA；本任务**不实现终局仲裁**（segments_lost 仅扣减呈现 + 封顶 3，不触发 defeat/reset）。

---

## 1. Expert preflight（start 证据，按 godot-gameplay-engineer-expert §Expert preflight）

| 项 | 值 |
|---|---|
| 契约 | ADR-TECH-01/02/03/04/05/06 已批准（R11；TECH-05 接触机制边界：单次伤害+轻分离）；决策 #4（contact 单次伤害事件）`user_confirmed`；Systems §6.1/§6.3（合法接触转移链 + CONTACT-\* fixture 矩阵）；S5 / READ_MODEL_IMPLEMENTATION_LIST §4.1（life segments_lost 结构位扩展）；QA_ACCEPTANCE_PLAN（Gate 2 扩展 / Gate 3 前段判据）；NEXT_IMPL_UNIT_PLAN_v0_3 单元 B |
| 项目根 | `D:\Game\New_Game\godot_game_dev` |
| 变更边界 | 经 GDMCP 写入的 4 个 Godot 脚本（rules_core.gd / adapter.gd / main.gd / rules_core_test.gd + adapter_contract_test.gd 追加夹具）；1 份实现报告 |
| 当前相关状态 | editor_connected: true；Godot 4.7.1；gdmcp 1.0.7；gdUnit4 6.2.x 已启用；运行时观察后已停 |
| 三大技术风险 | ① C2/C4 接触不成为第二规则权威（规则核收 adapter 触点输入判合法性，引擎只做几何重叠+轻分离，ADR-TECH-01）② 确定性保持（contact 纯逻辑零 RNG、断言零容差；既有 37 用例不回归）③ C5 life 呈现从结构位 0 → 实际扣减且非色彩可读（UX-13） |
| GDMCP 路线 | `doctor` → `editor state` → `execute_editor_script`（FileAccess 覆写/追加）→ `scripts read`/`analyze_script` 再检 → `reload_project` → headless gdUnit4（×2 复跑）→ self-test（×3 复跑）→ `run_project`/runtime 注入观察 → `stop_project` |
| 检查 | headless gdUnit4 **49 用例 = 23 adapter + 26 rules** 全过（×2 exit 0，身份集逐位一致）；self-test ×3 exit 0（run2==run3 逐位一致），含 contact→segments_lost=1→invuln→分离→rearm 全链；GDMCP runtime smoke 观测 LIFE 基线 `segments_lost=0`（未扣减路径正常）+ stop 干净；analyze_script 全通过；reload_project success |
| 回滚计划 | 变更集中于规则核/adapter 纯逻辑扩展 + 运行时接触 + life 呈现 + 测试夹具；回滚 = 撤 4 脚本（经 GDMCP / git）；git diff 可逐条核对（§9）；adapter 不入侵规则核（contact 合法性仍归规则核单一 owner）；规则核 contact 为**加性**（不带 contact_input 的既有 fixture 语义逐位不变——既有 37 用例全绿证明） |
| 停止条件 | 报告写入即停；不进入下一阶段、不派发任何成员 |

---

## 2. 实际工具顺序与能力证据（真实记录）

接口实测纪律（DSH 2026-08-16）：不凭函数清单判 `skill`/`tools.skill` 不可用，实际发起调用验证。

| # | 工具/动作 | 结果 |
|---|---|---|
| 1 | `skill({name:"godot-gameplay-engineer-expert"})` | ✅ **实测成功**（返回完整 SKILL 指令；未报 unknown tool）。能力证据等级 = `strong_direct_skill`（首选）。无需 fallback 到 SKILL.md |
| 2 | `skill("gdmcp")` / `skill("gdunit-driver")` / `skill("gdtoolkit")` | ✅ 全部实测成功（gdmcp 读 `references/standard-action-chains.md` + action-chain-registry；gdtoolkit 注记为 pipeline 禁用 v0.3.4+，保留 ad-hoc 参考） |
| 3 | read 必读文档 | ✅ `NEXT_IMPL_UNIT_PLAN_v0_3` / `CONTACT_LEDGER`（**glob 未发现 → C1 未到齐，标注处理**）/ `IMPL_PLAYABLE_SLICE`（R1/R2/R3 既有）/ `READ_MODEL_IMPLEMENTATION_LIST`（§4.1 life 结构位）/ `READ_MODEL_MINIMAL_FIELDS`（S5 life 字段）/ `QA_ACCEPTANCE_PLAN`（Gate 判据）/ `QA_PLAYABLE_SLICE_VERDICT`（Gate 3 前段）/ `KICKOFF_TECH_ADR_CONTRACTS`（ADR-TECH-01/02/04/05/06）/ `KICKOFF_SYSTEMS_RULES_CONTRACTS`（§6.1/§6.3）/ `KICKOFF_UX_UI_CONTRACTS`（UX-13/UX-09）/ `QA_VERTICAL_SLICE_VERDICT` 全部成功 |
| 4 | `gdmcp --json doctor` + `editor state`（`gdmcp.editor_preflight.v1`） | ✅ editor_connected:true / Godot 4.7.1 / gdmcp 1.0.7 / active_scene Main / runtime_running:false |
| 5 | gdmcp 源码检视 | ✅ `scripts read` rules_core(287 既有)/adapter(139)/main(408)/session(60)/rules_test(494)/adapter_test(230)；git HEAD=`194618d`，工作树 Godot 构件干净 |
| 6 | **C2** `rules_core.gd` 接触扩展（staging 覆写，经 GDMCP） | ✅ `WROTE rules_core.gd bytes=19990`（CONFIG_VERSION `rules-core-v3`；`empty_state` + `segments_lost`/`contact_invulnerable_until_tick`/`contact_rearm`；`_apply_contact` 纯逻辑——re-arm pass（分离→再武装+无敌结束）+ legal contact pass（单次伤害+无敌吞并）；drain 点擦除移除 victim 的 rearm）；`analyze_script` 378 行 RefCounted has_class_name DshRulesCore 通过 |
| 7 | **C3** `rules_core_test.gd` 追加 CONTACT-\*（staging 追加，经 GDMCP） | ✅ `APPENDED rules_core_test.gd bytes=9768`（7 测试：CONTACT-single / overlap / separate-rearm / simultaneous / boundary / removal + additive-compat）；`analyze_script` 705 行 26 测试通过；**headless gdUnit4 rules 26/26 PASS exit 0** |
| 8 | **C4** `adapter.gd` 接触 seam 扩展（staging 覆写） | ✅ `WROTE adapter.gd bytes=10653`（`contact_observations` / `make_envelope` 携带 contact_input+参数 / `contact_feedback_from_result`）；`analyze_script` 196 行通过 |
| 9 | **C4+C5** `runtime/main.gd`（staging 覆写） | ✅ 首写 `WROTE main.gd bytes=26392` → 自测接触回归失败（初始敌 1 与玩家 AABB 重叠，运行开始即接触致 segments_lost=1）→ **红队发现并修正**：初始敌移至非重叠区（`VECTOR2(280,360)`），专用接触阶段放置重叠敌 → 重写 `WROTE main.gd bytes=26631` 通过；`analyze_script` 543 行 14 函数通过 |
| 10 | **C4** `adapter_contract_test.gd` 追加接触契约（staging 追加） | ✅ `APPENDED adapter_contract_test.gd bytes=3168`（5 测试：contact_observations 过滤 / 空无重叠 / envelope 携带 contact + 参数 / contact feedback 绑定事件 / 无事件→无接触反馈）；`analyze_script` 292 行 23 测试通过 |
| 11 | `reload_project(full_scan)` | ✅ status=success（刷新全局类缓存） |
| 12 | **headless gdUnit4 全量 run #1** | ✅ `49 test cases | 0 errors | 0 failures | Exit code: 0`（23 adapter + 26 rules） |
| 13 | **headless gdUnit4 全量 run #2（确定性复跑）** | ✅ 同 49/49 exit 0；XML testcase 身份集（49）与 run1 **逐位一致** |
| 14 | **self-test run #1/#2/#3** | ✅ 三次均 exit 0；run#2 与 run#3 **输出逐位一致**；含 `[SELF-TEST] restricted deterministic regression (scripted zero-move + scripted fire; NOT player-playable input evidence)` 首位标注 + `[CONTACT] damage victim_id=3 segments_lost=1` / `[CONTACT-INVULN]` / `[CONTACT-SEPARATE]` / `[CONTACT-REARM] re-armed ids=[3]` / `[SELF-TEST-CONTACT-PASS]`；无 SCRIPT ERROR/ERROR/WARNING |
| 15 | GDMCP runtime smoke（`gdmcp.runtime_smoke.v1`） | ✅ run_project status=success/session_active/probe_ready；runtime tree 显示 player+Line2D+**9 个 HUD Label**（新增 contact_label）；注入 player 到 (560,200) 后观测 LIFE=`LIFE [o][o][o] segments_lost=0`（当时无活体敌可重叠，未触发新接触）；stop_project 干净收尾。**life 扣减的确定性运行时证据以 self-test 为准**（`[CONTACT] damage victim_id=3 segments_lost=1`） |
| 16 | `detect_broken_scripts`（静态 sanity，如执行） | ⚠️ 既有 gdUnit4 `@abstract func` 已知误报类来源（与上一单元 QA 预检一致）；本任务脚本 analyze_script 全通过 |
| 17 | git | ✅ 工作树 4 Godot 构件改动（rules_core / adapter / main / 两测试文件追加）；另 `NEXT_IMPL_UNIT_PLAN_v0_3.md` 为**只读** Producer 产物（未提交、未修改）；本单元将提交 Godot 构件 + 本报告 |
| 18 | 清理 staging + 最终 doctor | @ 会话末段 pwsh/read 输出出现显示空白（见 §10 诚实边界）；此前 GDMCP 写入与测试证据已完整采集；清理声明见 §11 |

> **本地 staging 直写说明（诚实）：** 变更写入 `godot_game_dev\...` **一律经 `execute_editor_script`（GDMCP）权威覆写/追加**，源内容为 `D:\Game\New_Game\dsh_gdmcp_staging\*.v0_3.gd` 草稿（位于 Godot 项目外，经 write 工具创建）。最终磁盘内容均与 GDMCP 写入一致（`WROTE`/`APPENDED` + `scripts read` 再检核对）。**未用 shell 直写任何最终 Godot 构件。**

---

## 3. 变更文件清单（经 GDMCP 的 Godot 构件）

| 路径 | 类型 | 角色/版本 | 行数（变更前→后） |
|---|---|---|---|
| `res://rules/rules_core.gd` | GDScript（`.gd`） | 规则核（DshRulesCore）+ **C2 contact 纯逻辑扩展**（CONFIG_VERSION `rules-core-v3`） | 287 → 378 |
| `res://adapter/adapter.gd` | GDScript（`.gd`） | adapter seam（DshAdapter）+ **C4 contact 翻译/反馈 seam** | 139 → 196 |
| `res://runtime/main.gd` | GDScript（`.gd`） | 运行时控制器（Node2D）+ **C4 引擎重叠检测/轻分离/再武装 + C5 life 扣减呈现** | 408 → 543 |
| `res://test/rules_core_test.gd` | GDScript（`.gd`） | gdUnit4 套件 | 494 → 705（19 既有 + **7 新增 C3 CONTACT-\***） |
| `res://test/adapter_contract_test.gd` | GDScript（`.gd`） | gdUnit4 **C4 contact seam 契约**套件 | 230 → 292（18 既有 + **5 新增**） |

> `res://rules/session.gd`、`res://scenes/main.tscn` 未改动。全部经 GDMCP 写入（覆写/追加）；创建/修改后经 `scripts read` + `analyze_script` 再检确认内容完整、解析通过。

---

## 4. 契约对照（C2/C3/C4/C5 每个约束如何满足）

### 4.1 C2 — 规则核 contact 扩展（纯逻辑，引擎 free，零 RNG，确定性）

| 约束（packet C2 要点 + Systems §6.1/§6.3） | 实现落点（rules_core.gd） | 证据 |
|---|---|---|
| 规则核接收 adapter 触点输入（contact eligibility）→ 判定合法接触 | `envelope["contact_input"]`（adapter `contact_observations` 翻译的 [{id}]）= 当前 eligible 重叠 victim；`_apply_contact` 在 step 的 drain 点后、任务前运行（加性：无 contact_input 的既有 fixture 语义不变） | `test_contact_absent_preserves_existing_semantics` |
| 单次伤害事件（决策 #4） | `_apply_contact` legal pass：置 `segments_lost += contact_damage`（封顶 3）、`contact_invulnerable_until_tick = tick + invuln`、整个同时重叠集置 rearm=false、emit 恰一个 `contact_damage_event` + `contact_invulnerable_event`、`break` | `test_contact_single_exactly_one_damage_and_invuln`（events 内恰 1 damage + 1 invuln；segments_lost=1） |
| 无敌状态（接触后短暂无敌窗口，无敌内重叠不产生第二次伤害） | `state.contact_invulnerable_until_tick`；legal pass 中 `tick < until → skip` | `test_contact_overlap_no_repeat_damage_rearm_false`（重叠持续 → 无第二次 damage；无敌窗口过后仍因 rearm 无重复） |
| 分离/再武装（分离后无敌结束、未来新接触可再触发） | re-arm pass：rearm-required victim 不在当前重叠集 → rearm=true + **无敌窗口清除（-1）** + emit `contact_rearm_event`；未来新重叠 → 新合法接触 | `test_contact_separate_rearm_exactly_one_new_legal_event`（分离→rearm→新重叠→恰 1 新 damage，segments_lost=2） |
| 引擎 free / 零 RNG / 确定性 / 不拥有引擎实体 | `_apply_contact` 纯字典/事件操作，无 wall-clock/device/scene tree/global RNG；只收 `contact_input`、发 events/state；确定性由固定 tick + 输入序保证 | 源码 + 49/49 复跑逐位一致；零容差断言 |
| life：接触伤害 → `segments_lost` 扣减语义（规则核发 life 事件/状态） | step 返回 `state.segments_lost` + diagnostics `segments_lost`；`contact_damage_event` 携带 `segments_lost`；**无 defeat/terminal 仲裁**（只扣减+封顶 3，终局延后） | READ-MODEL `contact: damage(victim=%d segments_lost=%d)`；C5 呈现 |
| 全部接触数值不锁常数（promotion_authority=User） | `contact_invulnerability_ticks`（默认 30）/ `contact_damage`（默认 1）= **envelope 参数**（调用方/ledger 注入），非规则常量；adapter `make_envelope` 透传 | 源码头注释 + 报告 §8 边界声明 |

### 4.2 C3 — CONTACT-\* fixture（含同时接触/边界；确定性，零容差）

| Fixture（Systems §6.3） | 断言要点 | 证据 |
|---|---|---|
| **CONTACT-single** | 恰好一次 damage；invulnerability 进入；segments_lost=1；rearm=false | `test_contact_single_exactly_one_damage_and_invuln` PASS |
| **CONTACT-overlap** | 无敌内无重复伤害；re-arm=false 保持 | `test_contact_overlap_no_repeat_damage_rearm_false` PASS |
| **CONTACT-separate-rearm** | 分离后恰一次新合法接触 | `test_contact_separate_rearm_exactly_one_new_legal_event` PASS |
| **CONTACT-simultaneous**（堆叠/同时） | **断言「单次伤害事件 + 无敌吞并」为推荐默认；N× 叠加为显式未决边界，不实现** | `test_contact_simultaneous_single_damage_event_merged` PASS（恰 1 damage；segments_lost=1；双 victim 均 rearm=false） |
| **CONTACT-boundary** | 边界分离与可恢复（无 sticky lock） | `test_contact_boundary_separation_and_recoverable` PASS |
| **CONTACT-removal** | 保护期移除 → 状态清理（rearm 擦除）+ 未来 re-arm 行为 | `test_contact_removal_during_protection_cleans_state` PASS |
| 既有 37 用例保持通过 | TARGET-*/KILL-*/session 语义未被接触扩展改变 | 全量 49/49，既有 37 全部 PASS（加性证明） |

### 4.3 C4 — adapter/运行时 接触·伤害·分离·再武装

| 约束（ADR-TECH-01 seam / packet C4） | 实现落点 | 证据 |
|---|---|---|
| adapter 接触/碰撞检测（引擎侧，ADR-TECH-01 seam）→ domain 触点输入 | **adapter** `contact_observations(overlaps)` 纯翻译（引擎 AABB 布尔 → [{id}]）；**main.gd** `_overlapping_enemy_ids` = 引擎几何重叠检测（player 24×24 vs enemy 26×26 AABB） | adapter contract `test_contact_observations_filters_overlaps` / `test_contact_observations_empty_when_no_overlap` PASS |
| 运行时：重叠→接触伤害→无敌→轻分离→再武装 → life 扣减 | **main.gd** 每步 `_overlapping_enemy_ids` → `make_envelope(..., contact_input, contact_invuln_ticks, 1)` → `session.step`（规则判合法/伤害/无敌/再武装）→ `_apply_feedback` 消费 `contact_feedback_from_result` → `_apply_light_separation`（引擎物理轻分离，玩家远离 victim 26px） | self-test 全链确定性运行时证据（`[CONTACT]`/`[CONTACT-INVULN]`/`[CONTACT-SEPARATE]`/`[CONTACT-REARM]`/`[SELF-TEST-CONTACT-PASS]`，segments_lost=1）；runtime smoke 观测 LIFE 基线 `segments_lost=0` |
| 引擎实体物理移动/再武装归 adapter | `_apply_light_separation`（物理位移）在 main.gd；再武装语义由规则核从 contact_input 推导（engine 只继续上报重叠） | self-test `[CONTACT-SEPARATE]`/`[CONTACT-REARM]` |
| 空射不伪造纪律延续 | contact feedback 严格绑定 contact 事件（`contact_feedback_from_result`）：无 contact 事件 → damage/invulnerable/rearm 全空；`test_contact_feedback_empty_when_no_contact_event` | adapter contract PASS |

### 4.4 C5 — life 扣减 read-model 呈现

| 约束（S5 life 字段 / UX-13 / UX-09） | 实现落点（main.gd `_present_read_model`） | 证据 |
|---|---|---|
| `segments_lost` 从结构位恒 0 → 实际扣减呈现 | `LIFE [x][x][o]  segments_lost=N`（每格 `[x]`=lost / `[o]`=alive，从 rules trace `segments_lost` 读取，**非色彩**） | **self-test 确定性运行时证据**：`[CONTACT] damage victim_id=3 segments_lost=1` + READ-MODEL `contact: damage(...) segments_lost=1`（引擎 headless 运行时实测扣减到达 1）；LIFE 呈现代码从同一 `segments_lost` 状态派生 `[x][o][o]` |
| 非色彩、非仅色彩（UX-13） | LIFE 以文本/形状分区（`[x]`/`[o]`）呈现，不依赖色值 | 源码（文本/形状）；HUD 占位 |
| HUD 不遮挡 player/danger/space（UX-09） | contact_label 位于 HUD 左侧文本区（y156），不影响可玩区 | HUD 布局延续（左上角文本）；UX-09 前段观察交由 QA |
| hint/文案/布局/资产不冻结 | 全部 HUD 文案为占位呈现；hint 字段明确未实现（E1）；contact_label 文案占位 | 源码 + 报告 §8 |

---

## 5. 红队发现与修复记录（如实）

1. **C4/C5 接触回归初版自测失败（运行时）**：首写 main.gd 后 self-test 出现 `[SELF-TEST-CONTACT-FAIL] repeat damage; segments_lost=2`。**实测发现**：初始自测敌 1 位于 (300,360)，与玩家 (320,360) 的 AABB 重叠（dx=20 < 25）→ 运行开始即产生一次合法接触伤害（segments_lost=1），随后专用接触阶段敌 3 再触发 → segments_lost=2，被误判为「重复伤害」。**根因是自测布点而非规则错误**（接触规则行为正确）。**修正**：初始敌 1 移至非重叠区 (280,360)（dx=40 > 25），仅专用接触阶段放一个重叠敌 → 全运行恰 1 次接触伤害 → `[SELF-TEST-CONTACT-PASS] segments_lost=1`。二次 `WROTE` 后 self-test ×3 exit 0 逐位一致。
2. **C2 rearm 与无敌窗口交互语义补正**：初版 `_apply_contact` re-arm pass 不清除 `contact_invulnerable_until_tick` → `CONTACT-separate-rearm` fixture 中，分离后新重叠仍在旧无敌窗口内（tick < until）→ 新接触被错误阻断。**对齐 packet「分离后无敌结束、未来新接触可再触发」**：re-arm（分离）时清除无敌窗口（置 -1）。修正后 `CONTACT-separate-rearm` PASS。
3. **既有 37 用例回归**：adapter `make_envelope` 现默认携带 `contact_input=[]`（供每步 rearm 求值）——验证不影响既有 input/envelope/feedback 语义（`test_make_envelope_carries_movement_and_candidates` 等 37 既有用例全绿，加性证明）。

---

## 6. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；cr-001 Option A (R09)；ADR-TECH-01..06 批准 (R11)；决策 #4（contact 单次伤害事件）；UX-03 S1–S3；AUTH-01 (R13 实现授权)；单元 1/2 QA verdict `pass`。本报告不重写、不重分类任何一项。
- **`team_proposal`（本实现引入的机制落点）:** C2 contact 纯逻辑模型（adapter→合法→单次伤害→无敌窗口→分离 rearm、segments_lost 扣减封顶）；C3 CONTACT-\* fixture 断言；C4 引擎重叠检测+轻分离+contact seam 翻译；C5 life 扣减呈现绑定。全部为机制实施，需 QA 复核，未升级。
- **`assumption`:** ① 接触检测/碰撞几何可在已批准 TECH-01 seam 内由 adapter/引擎承担、规则核只收合法性输入（已落地，需 QA 观察验证）；② 推荐默认（单次伤害 + 无敌吞并）保持决策 #4 非升级（`CONTACT-simultaneous` 作为推荐默认断言 + 未决边界上报；需 Systems/UX 确认 + QA 观察）；③ life 扣减呈现可在已批准 read-model 契约内扩展且可被独立 QA 观察（需落地 + 观察验证）。均未在此代决。
- **`unresolved`（全量保留，未关闭，本单元相关）:** cr-006..009 精确值（接触判定/无敌时长/分离距离方向/堆叠 N×/边界/分离失败）；`life segments_lost` 精确数值语义（归 Systems contact 单元，本实现为候选参数+封顶 3 骨架）；同时接触 N× 叠加（推荐默认单次+吞并，显式未决）；接触判定全局 vs 成对模型；分离失败/边界精确规则；spawn 节奏；敌人多段 HP；走廊恢复精细反馈形态；hint；no_target_cue 种类；O6 外层 fixture envelope；`fixture_schema_version`；O8 真人键盘自由操作未全量验收——均保持 open。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本实现未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未动用/提升。

---

## 7. 与 C1 ledger 对齐表（C1 到齐后逐条核对）

> `CONTACT_LEDGER_v0_1.md` 在会话末段到齐，本实现已逐条对齐（下列为核对结果）：

| C1 ledger 行 | 对齐 |
|---|---|
| §2.1 接触判定（单 tick 重叠、连续重叠不重复、碰撞归 adapter/规则核只收合法性输入） | ✅ 对齐（`contact_observations` 引擎→domain；`_apply_contact` 判合法；overlap 不重复） |
| §2.2 单次伤害（一次合法接触 = 一次伤害事件 + 扣 1 格 life，保持决策 #4） | ✅ 对齐（恰 1 `contact_damage_event`；`segments_lost += 1`；`CONTACT-single` 断言） |
| §2.3 无敌时长（无敌内无重复伤害；全局 vs 成对 `unresolved`） | ✅ 机制对齐；**无敌模型注记：本实现取「全局窗口」**（C1 起始建议「成对」；两者均候选 `unresolved`，均满足 ADR-TECH-05「无敌内无重复伤害」，fixture 断言模型无关） |
| §2.4 分离距离/方向（起始 ~16px 法向；方向=背离，均候选） | ✅ 语义对齐（引擎侧 `_apply_light_separation` 玩家背离 victim 推离）；**数值注记：candidate 26px vs C1 起始 16px**（均候选，promotion=User，未锁常数） |
| §2.5 堆叠/同时接触（推荐默认单次伤害 + 无敌吞并，保持 #4；N× → D2-Card 2） | ✅ 对齐（`CONTACT-simultaneous` 断言恰 1 damage + 双 victim 吞并 rearm=false；N× 为显式未决边界不实现） |
| §2.6 边界行为（分离可恢复、不越界） | ✅ 规则层对齐（`CONTACT-boundary` 断言分离+rearm 可恢复、无 sticky lock）；**去轴注记：最小切片无竞技场边界，运行时分离未做边界钳制（cr-009 边界/分离失败延后）** |
| §2.7 life segments_lost（3 格、1 接触=1 格、0..3、非色彩） | ✅ 对齐（`segments_lost` 封顶 3；`LIFE [x][o][o]` 非色彩；`CONTACT-single`/`simultaneous` 精确 +1） |

- **UX-13 / UX-09（life 呈现）:** 本实现 C5 以文本/形状 `[x]`/`[o]` 非色彩呈现 segments_lost 扣减（UX-13），HUD 左上角文本区不遮挡 player（UX-09）——前段观察交由 Independent QA 独立判定。
- **hint 字段（E1）排除核对:** 未实现任何 hint 字段/文案（S5 §4.4 排除项），仅 contact_label 占位呈现。


---

## 8. 边界声明（明确）

- **未实现（本单元明确延后）:** 升级（cr-010..011）/ B2 三弧（cr-016..019）/ 终结/重置（cr-014..015）——**本单元仅提供 life 扣减字段骨架 + 封顶 3，不实现终局仲裁/自动重试**/ focus epoch（cr-012..013）/ spawn 节奏 / 敌人多段 HP / hint / no_target_cue 精确表现 / 资产 / 动画 / 音频 / 数值定稿 / 视觉 v0.2 / 导出 / 发布 / 持久化 / 玩家可见 Replay。
- **未提升候选数值 / 未锁常数:** `contact_invulnerability_ticks`/`contact_damage`/`contact_separate_dist` 均为 **envelope/`@export` 候选参数**，非规则常数/Gate 判据/发布承诺；life 三格 + `segments_lost` 数值语义归 Systems（promotion_authority=User，未写死）；候选预算（六项 + `1280×720` 红线）未涉及。
- **未批准/冻结任何 ADR / Systems 终裁 / fixture schema / 数值 / 表现形态:** 接触数值走 ledger 候选、promotion=User；`CONTACT-simultaneous` N× 叠加为显式未决边界（未实现 N×）；同时接触边界按设计「单次伤害事件 + 无敌吞并」为推荐默认并上报 QA。
- **未豁免 QA:** 本地测试（headless 49/49 ×2 + self-test ×3 + GDMCP runtime smoke 观测 LIFE 基线 `segments_lost=0`）为本地证据，**不代表 Independent QA Gate 2 扩展 / Gate 3 前段验收**；QA 独立观察不豁免，尤其「接触→伤害→生命扣减→分离→再武装」玩家可玩路径须由 QA 独立判定。
- **未替用户做产品/验收裁决；未替 Systems/UX/Tech/QA 代权；未触碰任何被禁止文档（CR 台账、合同、排程建议、C1 ledger、UX 清单等——未读写修改）。**
- **self-test ≠ 玩家可玩输入证据:** self-test 为受脚本化零移动 + 脚本化射击 + 脚本化接触的确定性回归，已显式标注非玩家可玩；真实输入/接触体验由独立 QA 观察。
- **无视觉 QA / E2E / 性能 / 导出 / 发布证据（如实）。** life 扣减的确定性运行时可观测性由 self-test 证明（`[CONTACT] damage victim_id=3 segments_lost=1` + READ-MODEL）；GDMCP runtime smoke 仅观测 LIFE 基线 `segments_lost=0` 非色彩呈现正常（注入时无活体可重叠，未触发新接触）。
- **写入面:** 经 GDMCP 写/追加 4 Godot 脚本 + 本唯一实现报告；工作区临时草稿/args/日志位于 Godot 项目外并已清理；未修改任何既有文档。
- **会话末段环境说明（诚实）:** 证据采集完成后，会话末段 pwsh/read 输出出现显示空白（见 §10 诚实边界），不影响此前已采集的 GDMCP 写入证据与测试证据。

---

## 9. 证据清单（如实分类）

### 9.1 headless 确定性 gdUnit4（primary · 本地证据，exit 0，复跑一致）

命令（Godot 4.7.1 console exe + gdUnit4 6.2.x + `--ignoreHeadlessMode`）：
```
<godot> --headless --path <proj> -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd --add res://test/ --ignoreHeadlessMode --report-directory user://gdunit4-contact-run1|2
```
- **run #1 / run #2（确定性复跑）:** 均 `Overall Summary: 49 test cases | 0 errors | 0 failures | 0 flaky | 0 skipped | 0 orphans | Exit code: 0`
  - `adapter_contract_test.gd`：**23/23 PASS**（18 既有 + **5 新增 C4 contact seam**：观察过滤 / 空无重叠 / envelope 携带 contact / feedback 绑定 / 无接触反馈）
  - `rules_core_test.gd`：**26/26 PASS**（19 既有 + **7 新增 C3 CONTACT-\***）
  - run#1 与 run#2 XML testcase 身份集（49）**逐位一致**。
- XML 报告：`user://gdunit4-contact-run{1,2}/report_1/results.xml`（testsuites adapter=23 failures=0 / rules=26 failures=0）。

### 9.2 S4 运行时 self-test（primary runtime · 受限确定性回归，exit 0）

命令：`<godot> --headless --path <proj> res://scenes/main.tscn -- --self-test`（三次，输出逐位一致）
```
[SELF-TEST] restricted deterministic regression (scripted zero-move + scripted fire; NOT player-playable input evidence)
...
[SELF-TEST-CLEAR] enemies removed; live enemies=0 (clear visible)
[SELF-TEST-CONTACT] overlapping enemy placed on player (contact regression begins)
[CONTACT] damage victim_id=3 segments_lost=1
[CONTACT-INVULN] brief invulnerability entered (no repeat damage during protection)
[READ-MODEL] ... contact: damage(victim=3 segments_lost=1)
[CONTACT-SEPARATE] victim_id=3 player=(320,334) (light separation; candidate mag 26)
[CONTACT-REARM] re-armed ids=[3] (separation ended invulnerability; future contact legal)
[SELF-TEST-CONTACT-PASS] segments_lost=1 (exactly one contact damage; overlap no repeat; life deducted)
```
Exit `0` ×3，stderr 空，run#2==run#3 逐位一致。证明：重叠→接触→单次伤害→life 扣减（segments_lost=1）→无敌→轻分离→再武装→不重复，在真实引擎 headless 闭环可观测。

### 9.3 GDMCP runtime smoke（supplementary runtime · `gdmcp.runtime_smoke.v1`）

- `run_project` status=success / session_active / probe_ready。
- runtime tree：player + Line2D + **9 Labels**（新增 contact_label）。
- 运行时注入 player 到 (560,200)：**观测到 LIFE label = `LIFE [o][o][o]  segments_lost=0`**（当时占位敌已被自动攻击清除、无活体可重叠，故无新接触——该基线证明 LIFE 未扣减路径正常、`segments_lost=0` 结构/基线呈现非色彩）。**注意（诚实）：本次注入未触发新接触**（无活敌可重叠），因此 LIFE `segments_lost=1` 的**确定性扣减证据以 self-test 为准**（引擎 headless 运行时 `[CONTACT] damage victim_id=3 segments_lost=1` + READ-MODEL 呈现）。
- `stop_project` 收尾为干净态（`runtime_running:false` / `no_active_sessions`）。

### 9.4 editor 校验（supplementary · 经 GDMCP）

- `analyze_script`：rules_core（378, RefCounted, has_class_name DshRulesCore）、adapter（196, RefCounted, has_class_name DshAdapter）、main（543, Node2D, 14 函数）、rules_test（705, 26 测试）、adapter_test（292, 23 测试）全解析通过。
- `reload_project(full_scan)` status=success。

### 9.5 证据边界（诚实分类）

| 证据 | 类别 | 边界说明 |
|---|---|---|
| headless gdUnit4 49/49 ×2 exit 0（身份集逐位一致） | **primary · 本地确定性测试** | 证明 C2/C3 接触纯逻辑 + C4 contact seam + 既有 37 全通过；**≠ Independent QA Gate 2 扩展验收**（QA 独立观察） |
| self-test ×3 exit 0 逐位一致（含 contact 全链 + C5 segments_lost=1） | **primary runtime（本地有限回归）** | 证明闭环 + 接触/分离/再武装/生命扣减（segments_lost 实测到达 1）可观测；**≠ Gate 3 视觉/UX 验收**；**≠ 玩家可玩输入证据**（self-test 非键盘移动/脚本化接触） |
| GDMCP runtime smoke + LIFE baseline `segments_lost=0`（observed runtime） | **supplementary runtime** | 证明场景加载、LIFE 未扣减基线非色彩呈现可读；本次注入时无活体可重叠（敌已清除），**未触发新接触**——扣减证据以 self-test 为准；**观察非视觉 QA 验收** |
| git（4 Godot 构件改动，本实现） | **source-revision** | 变更可追溯、回滚点（git diff 逐条核对） |
| 无 | （本任务不产生） | **无** 真人玩家键盘接触演示 / 视觉 QA / E2E / 性能 / 导出 / 发布证据 |

> 明确标注：**无任何独立视觉/UX/E2E/性能/导出/QA 验收证据**；「接触→伤害→生命扣减→分离→再武装」的真实玩家路径未经独立 QA 键盘观察；本地证据不代表 Independent QA 验收。

---

## 10. 诚实边界（环境 + 证据）

- **会话末段环境显示空白声明（已恢复，不影响证据）：** 会话末段 pwsh/read 输出一度出现显示空白，随后恢复正常；该现象不影响此前已采集的 GDMCP 写入证据（`WROTE`/`APPENDED` bytes + `scripts read` 再检）、headless 49/49×2 exit 0、self-test×3 exit 0 逐位一致。staging 目录与最终 Godot 构件经恢复后确认存在并可读（glob/read 复核）。编辑过程全程经 GDMCP 写入（非 shell 直写）。
- **life 扣减运行时证据边界（诚实修正）：** GDMCP runtime smoke 注入时观测到 LIFE `segments_lost=0`（当时占位敌已被自动攻击清除、无活体可重叠，未触发新接触）——该观测证明 LIFE 未扣减基线非色彩呈现正常；**contact→`segments_lost=1` 的确定性运行时扣减证据以 self-test 为准**（引擎 headless 运行时 `[CONTACT] damage victim_id=3 segments_lost=1` + READ-MODEL 呈现），非 runtime 注入。
- **`self-test`/headless 测试成功 = 确定性证据，≠ 玩家可玩验收**：真实接触体验（真人键盘移动接近敌人→接触→生命损失→撤离→恢复）未由本实现独立验收，归 Independent QA 前段观察。
- **`CONTACT-simultaneous` N× 叠加为显式未决边界**：本实现按推荐默认（单次伤害 + 无敌吞并）实现并断言，N× 叠加不实现、不升级；如 Systems/用户决策改 N× → 走 D2 升级（AUTH-01 §7 D2-Card 2）。
- **life 数值语义未锁**：`segments_lost` 扣减为候选参数（1 per 接触）+ 封顶 3 骨架；精确一次扣多少/三格如何消耗归 Systems contact 单元（ledger），本实现不冻结。

---

## 11. 交接与下一步

- **Handoff 给 Independent QA（Gate 2 扩展 + Gate 3 前段）：** C2 contact 纯逻辑 + C3 `CONTACT-single/overlap/separate-rearm/simultaneous/boundary/removal` fixture（含同时接触/边界，空容差断言）+ C4 contact seam（`contact_observations`/envelope 透传/`contact_feedback_from_result`）+ C5 life 扣减呈现（LIFE `[x]`/`[o]` 非色彩、`segments_lost` 实测扣减）作为确定性验收输入；运行时「重叠→接触→伤害→无敌→轻分离→再武装→life 扣减」作为 Gate 3 前段可观察性输入。QA 独立复跑 + 独立观察，self-test 非玩家证据。
- **待对齐（C1 到齐后）：** `CONTACT_LEDGER_v0_1.md` 到齐后需按 ledger 接触数值语义对齐本实现候选参数。
- **待评审/后续项：** 同时接触 N× 边界；分离距离/方向精确规则；接触判定全局 vs 成对；O6 外层 fixture envelope；no_target_cue 精确表现 / hint / 失效反馈形态等 unresolved 项留后。
- **明确不在本实现范围：** 升级/B2/终结/focus/spawn/资产/动画/音频/数值定稿/视觉 v0.2/导出/发布/Replay。

---

## 12. Closure

- **closure_ready: YES**
- 结论：**C2**（规则核 contact 纯逻辑：adapter 触点输入→合法接触→单次伤害→无敌→分离 rearm→life segments_lost 扣减，加性、零 RNG、确定性，不拥有引擎实体）+ **C3**（`CONTACT-single/overlap/separate-rearm/simultaneous/boundary/removal` fixture + 加性兼容，既有 37 用例保持通过）+ **C4**（adapter `contact_observations`/envelope 透传/contact feedback seam + main.gd 引擎重叠检测/轻分离/再武装 + contact_input 每步求值）+ **C5**（life 呈现从结构位恒 0 → 实际扣减 `[x]`/`[o]` 非色彩）+ self-test contact 回归，均经 GDMCP 应用并验证。
- 本地证据：headless gdUnit4 **49/49**（rules 26 + adapter 23）exit 0 且复跑身份集逐位一致；self-test ×3 exit 0 逐位一致（含 contact 全链 + C5 `segments_lost=1` 确定性扣减证据）；GDMCP runtime smoke 观测 LIFE 基线 `segments_lost=0`（未扣减路径）正常、stop 干净;analyze_script 全通过;git 变更仅 4 Godot 构件。
- **C1 ledger 到齐并已对齐**：本实现按 packet「给定 C2 要点」实现，会话末段 `CONTACT_LEDGER_v0_1.md` 到齐后逐条对齐（§7 对齐表，7 行一致）；唯一候选注记 = 无敌模型取全局（C1 起始建议成对，全局/成对均 `unresolved`）、分离距离 26px（候选 vs C1 起始 16px）、边界不去轴（最小切片无边界，cr-009 延后）。（本实现接触数值全为候选参数，可平滑吸收 ledger 后续数值变化）
- 证据边界如实：本地测试 ≠ QA 验收；self-test ≠ 玩家可玩输入证据；无视觉/E2E/性能/导出/QA 证据。
- 边界声明完整：未做延后项、未提升候选数值、未批准/冻结契约/表现形态、QA 不豁免、未碰任何被禁止文档、未派发成员。
- 本报告完成后停止，不进入下一阶段、不派发任何成员。

---

## 13. 版本与变更记录

- **v0.1（本文件）：** Godot Gameplay Engineer 唯一实现报告产物。C2 规则核 contact 纯逻辑 + C3 CONTACT-\* fixture + C4 adapter/运行时 接触·伤害·分离·再武装 + C5 life 扣减 read-model 呈现经 GDMCP 落地并验证（本地 evidence）；headless 49/49 ×2 + self-test ×3（含 contact 全链 + C5 `segments_lost=1` 确定性扣减证据）+ GDMCP runtime smoke（LIFE baseline `segments_lost=0` 未扣减路径正常）；红队发现并修正 2 项（自测接触布点 + rearm 无敌窗口）；既有 37 用例保持通过；C1 ledger 未到齐标注；边界声明与证据边界完整。

---

## 附：返回报告（structured）

- **status:** `completed`
- **actual start evidence:** `skill({name:"godot-gameplay-engineer-expert"})` **实测成功**（`strong_direct_skill` 首选；返回完整 SKILL 指令，未报 unknown tool）；随后 `skill("gdmcp")` / `skill("gdunit-driver")` / `skill("gdtoolkit")` 全部实测成功。
- **expert skill evidence:** `godot-gameplay-engineer-expert`（`C:\Users\User\.agents\skills\godot-gameplay-engineer-expert\SKILL.md`）；能力证据等级 = `strong_direct_skill`。
- **expert preflight:** 契约（ADR-TECH-01/02/03/04/05/06 + 决策 #4 + Systems §6.1/§6.3 + S5/UX 清单 §4.1）、项目根、变更边界（经 GDMCP 4 脚本）、当前相关状态（editor_connected:true / Godot 4.7.1 / gdmcp 1.0.7）、三大技术风险、GDMCP 路线、检查、回滚计划、停止条件（报告写入即停，不派发成员）。
- **artifact path/version:** `IMPL_CONTACT_SLICE_v0_1.md`（本报告）。
- **exact sections/files changed（经 GDMCP）:** `res://rules/rules_core.gd`（C2，378 行）、`res://adapter/adapter.gd`（C4 seam，196 行）、`res://runtime/main.gd`（C4+C5，543 行）、`res://test/rules_core_test.gd`（C3，705 行）、`res://test/adapter_contract_test.gd`（C4 契约，292 行）。
- **测试结果:** headless gdUnit4 **49/49**（rules 26 + adapter 23）exit 0 ×2（身份集逐位一致）；self-test ×3 exit 0（run2==run3 逐位一致）；GDMCP runtime smoke 观测 LIFE 基线 `segments_lost=0`；life 扣减确定性证据以 self-test（`segments_lost=1`）为准。既有 37 用例保持通过。
- **user-confirmed vs proposal/unresolved:** 22 / 恰好 8 / PRECHARTER-01..11 引用保留；C2/C3/C4/C5 为 `team_proposal` 机制实施；C1 ledger（`CONTACT_LEDGER_v0_1.md`）到齐后逐条对齐（§7 对齐表 7 行一致；无敌模型取全局=候选注记）；contact 数值（无敌时长/伤害/分离距离/life 扣减）= `unresolved/candidate`（promotion=User 未锁常数）；cr-006..009、同时接触 N×、life 数值语义、全局 vs 成对无敌（本实现取全局）等均保持 open。
- **evidence inspected:** GDMCP 写入/再检/analyze；headless 49/49×2 + XML 身份集；self-test×3 逐位一致（含 C5 `segments_lost=1` 确定性扣减）；GDMCP runtime smoke（LIFE baseline `segments_lost=0` + stop 干净）；git 变更清单；**本地证据 ≠ QA 验收**（无独立视觉/E2E/性能/导出/QA 证据；life 扣减运行时证据以 self-test 为准，非注入）。
- **explicit boundary statement:** 未做延后项（升级/B2/终结/focus/spawn/资产/动画/音频/数值定稿/视觉 v0.2/导出/发布/Replay）；未提升候选数值；未批准/冻结契约/表现形态；QA 不豁免；未替用户做产品/验收裁决；未碰被禁止文档；未派发成员；`CONTACT-simultaneous` N× 为显式未决边界。
- **`closure_ready`:** `true`
