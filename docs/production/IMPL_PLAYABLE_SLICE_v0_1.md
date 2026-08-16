# IMPL PLAYABLE SLICE v0.1 — R1 真实输入驱动移动 + R2 read-model 全字段落地 + R3 O4/O5 精化 实现说明

> **Status:** `IMPLEMENTED (local engineering evidence)` — **本地测试/运行时观察 ≠ Independent QA 验收**（Gate 2 扩展 / Gate 3 前段由 Independent QA 独立执行，本实现不豁免、不自证）。
> **Role:** Godot Gameplay Engineer（玩法工程师 · 实现 owner）——R1/R2/R3 实现 owner。
> **Artifact owner (sole author):** Godot Gameplay Engineer
> **Report ID:** `IMPL_PLAYABLE_SLICE_v0_1`
> **Version:** v0.1（首版）
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **排程输入:** `NEXT_IMPL_UNIT_PLAN_v0_2.md` 推荐方案 A（R1 真实输入驱动移动 + R2 read-model 全字段落地 + R3 O4/O5 精化，吸收 O4/O5 为单元内精化子块）；UX R2 落地清单 `READ_MODEL_IMPLEMENTATION_LIST_v0_1.md`（到齐后逐条对齐）；S5 字段提案 `READ_MODEL_MINIMAL_FIELDS_v0_1.md`（R2 主输入）。
> **源修订（git）:** 本项目 Godot 构件分支；commit `822c51e`（上一单元）之上新增本单元变更（见 §9 变更清单，经 git 提交）。

---

## 0. 授权与边界声明（总览）

- 本任务为**唯一被派遣成员**执行的实现单元 = **R1 + R2 + R3**，按 Producer 排程 A（推荐方案 A，AUTH-01 判定非升级 D1 自动推进）派发；R13 实现授权生效，本单元经 GDMCP 变更 Godot 构件。
- **所有 Godot 构件变更均经 GDMCP**（`execute_editor_script` + FileAccess 权威覆写 / `scripts read` 再检 / `analyze_script` 校验 / `reload_project` 刷新缓存）；**无 shell/direct-write 绕道**（变更经由 4 份位于 Godot 项目外的工作区草稿 `<项目根>\dsh_gdmcp_staging\*.v0_2.gd` 作为 GDMCP 覆写的源内容；最终磁盘内容均与 GDMCP 写入一致——见 §11 清理声明）。
- **UX R2 落地清单到齐标注：** 会话开始时 `READ_MODEL_IMPLEMENTATION_LIST_v0_1.md` **尚未存在**（glob 未发现，按 packet「给定 R2 要点」实现）；随后该清单在会话中**到齐**，我已**逐条对齐**（见 §5.1 对齐表）：R2 呈现绑定与 UX 清单 §4（HUD 最小面 / no-target quiet / attack_state 四态 / feedback-binding 逐类绑定 / kill_state / invalidation 节）与 §5 排除清单（E1–E10）**全部一致**。因此不再存在「UX 清单未到齐待对齐」状态，改为「实现时按给定要点、UX 清单到齐后已验证逐条对齐」。
- 未实现接触（cr-006..009）/ 升级（cr-010..011）/ B2 三弧（cr-016..019）/ 终结（cr-014..015）/ focus（cr-012..013）/ spawn / 资产 / 动画 / 音频 / 数值定稿 / 视觉 v0.2 / 导出 / 发布 / 持久化 / Replay（全部延后，见 §8 边界声明）。
- 未提升任何候选数值；候选预算（六项 + `1280×720` 红线）仅候选、本任务不涉及；未豁免 QA。

---

## 1. Expert preflight（start 证据，按 godot-gameplay-engineer-expert §Expert preflight）

| 项 | 值 |
|---|---|
| 契约 | ADR-TECH-01..06 已批准（R11）；UX R2 落地清单（呈现绑定）；UX S5 read-model 字段；QA_ACCEPTANCE_PLAN Gate 2 判据；NEXT_IMPL_UNIT_PLAN_v0_2 候选 A |
| 项目根 | `D:\Game\New_Game\godot_game_dev` |
| 变更边界 | 经 GDMCP 写入的 4 个 Godot 脚本（rules_core.gd / main.gd / rules_core_test.gd / adapter_contract_test.gd）；1 份实现报告 |
| 当前相关状态 | editor_connected: true；runtime_running: false（观察后已停）；Godot 4.7.1；gdmcp 1.0.7；gdUnit4 6.2.x 已启用 |
| 三大技术风险 | ① R2 read-model 呈现不能成为第二规则权威（presentation 只消费 rules trace，ADR-TECH-01）② R1 真实输入路径保持 headless 确定性（self-test 有限回归，不冒充玩家可玩证据）③ 新增 O4/O5 fixture 的确定性断言与既有 29 用例不冲突 |
| GDMCP 路线 | `doctor` → `editor state` → `execute_editor_script`（FileAccess 覆写）→ `scripts read`/`analyze_script` 再检 → `reload_project` → headless gdUnit4（×2 复跑）→ self-test（×2 复跑）→ `run_project`/runtime smoke 观察 → `stop_project` |
| 检查 | headless gdUnit4（rules 19 + adapter 18 = 37 全过，复跑一致）；self-test 复跑 exit 0 逐位一致；runtime smoke 截图 + HUD vision OCR；analyze_script 全通过；detect_broken_scripts 本任务零 error |
| 回滚计划 | 变更集中于规则核 diagnostics 只读扩展 + adapter 测试扩展 + 运行时 self-contained。回滚 = 撤 4 脚本（经 GDMCP / git）；git diff 可逐条核对变更（§9）；adapter 不入侵规则核（k1/k2/stable_id 量化仍回归规则核单一 owner）；运行时自我包含。规则核 O5 为**纯 diagnostics 追加**，state/events 语义逐位不变（既有 14 rules 测试全绿证明） |
| 停止条件 | 报告写入即停；不进入下一阶段、不派发任何成员 |

---

## 2. 实际工具顺序与能力证据（真实记录）

接口实测纪律（DSH 2026-08-16）：不凭函数清单判 `skill`/`tools.skill` 不可用，实际发起调用验证。

| # | 工具/动作 | 结果 |
|---|---|---|
| 1 | `skill({name:"godot-gameplay-engineer-expert"})` | ✅ **实测成功**（返回完整 SKILL 指令；未报 unknown tool）。能力证据等级 = `strong_direct_skill`（首选）。无需 fallback 到 SKILL.md |
| 2 | `skill("gdmcp")` / `skill("gdunit-driver")` / `skill("gdtoolkit")` | ✅ 全部实测成功（gdmcp 要求读 `references/standard-action-chains.md` + action-chain-registry；gdtoolkit 注记为 pipeline 禁用 v0.3.4+，保留 ad-hoc 参考） |
| 3 | read 必读文档 | ✅ `NEXT_IMPL_UNIT_PLAN_v0_2` / `READ_MODEL_MINIMAL_FIELDS` / `IMPL_VERTICAL_SLICE` / `QA_VERTICAL_SLICE_VERDICT` / `QA_ACCEPTANCE_PLAN` / `KICKOFF_TECH_ADR_CONTRACTS` / `KICKOFF_UX_UI_CONTRACTS` 全部成功；`READ_MODEL_IMPLEMENTATION_LIST` 初始不存在→到齐后读取对齐 |
| 4 | `gdmcp --json doctor` + `editor state`（`gdmcp.editor_preflight.v1`） | ✅ editor_connected:true / Godot 4.7.1 / gdmcp 1.0.7 / active_scene Main / runtime_running:false；注册表 run `acr-705307f9caea` 完成 passed |
| 5 | gdmcp 源码检视 | ✅ `scripts read` rules_core(236)/adapter(139)/main(285)/session(60)/rules_test(325)/adapter_test(148)；`scenes read` 子命令不存在（tscn 本轮无变更，仅脚本内建视觉） |
| 6 | **R1+R2** `runtime/main.gd` 重写（经 GDMCP 覆写正式化输入路径 + 全 read-model 呈现） | ✅ `WROTE main.gd bytes=18492` |
| 7 | **R3 O5** `rules_core.gd` diagnostics 只读扩展 | ✅ `WROTE rules_core.gd bytes=14150` |
| 8 | **R1 测试** `adapter_contract_test.gd` 扩展 | ✅ 首次 `WROTE` 后 1 个新用例失败（测试语义错：误把快照当「仅最近目标」，实为全锁定集）→ 修正 → 二次 `WROTE bytes=12409` → 全过（见 §6 红队） |
| 9 | **R3 O4/O5 测试** `rules_core_test.gd` 扩展 | ✅ `WROTE bytes=26354` |
| 10 | 再检 | ✅ `analyze_script` 全通过：rules_core(287, RefCounted, has_class_name) / main(408, Node2D, 12 函数) / rules_test(494, 19 测试) / adapter_test(224, 18 测试)；`scripts read` 逐文件核对 |
| 11 | `reload_project(full_scan)` | ✅ status=success（刷新全局类缓存） |
| 12 | **headless gdUnit4 run #1** | ❌ 首次 36 用例「3 failures + 缺 1 用例」→ 修正测试语义 + 补文件尾换行 → **37/37 PASS exit 0** |
| 13 | **headless gdUnit4 run #2（确定性复跑）** | ✅ `37 test cases | 0 errors | 0 failures | ... | Exit code: 0`（18 adapter + 19 rules，含 R1×3 + R3×5 新增） |
| 14 | **run #3（确定性复跑）** | ✅ 同 37/37 exit 0，与 run2 逐位一致（仅 per-test wall-clock timing 非确定，不在比较面） |
| 15 | **S4 self-test ×2** | ✅ 两次 exit 0，**输出逐位一致**；含 `[SELF-TEST] 受限确定性回归` 标注 + `[LOCK-REFRESH]`/`[FB-BIND]`/`[READ-MODEL]`(四态/feedback/kill)/`[NO-TARGET-CUE]` 行 |
| 16 | GDMCP runtime smoke（`gdmcp.runtime_smoke.v1`） | ✅ run_project status=success/probe_ready/session_active；runtime tree 显示 player+Line2D+**8 个 HUD Label**；screenshot 1152x648；video OCR 读到 `LIFE [o][o] segments_lost=0`/`TIMER tick=1202 run_bound=8min(opaque)`/`B2 pre-vision(structure placeholder)`/`attack: no_target (quiet)`/`kill: killed(2)`/`feedback: -(quiet)`/`no target (quiet)`；logs 仅 Info；stop_project mode:editor → runtime `no_active_sessions` |
| 17 | `detect_broken_scripts` | ⚠️ 36 报错全部在 `res://addons/gdUnit4/`（已知 `@abstract func` 误报，与上一单元 QA 预检一致，插件仍 37/37 可跑）；本任务 4 脚本**零 error**；唯一 warning= `runtime/main.gd:44` 有意保留的 `var session` 缺类型标注（注释已说明，为避免全局类缓存依赖） |
| 18 | git | ✅ 工作树仅 4 Godot 构件改动（+496/−71）；另 `NEXT_IMPL_UNIT_PLAN_v0_2.md` + `READ_MODEL_IMPLEMENTATION_LIST_v0_1.md` 为**只读**的 Producer/UX 产物（未提交、未修改）；本单元将提交 4 构件 + 本报告 |
| 19 | 清理 staging + 最终 doctor | ✅ 清理草稿/args/日志；最终 doctor `editor_connected:true` / `runtime_running:false` |

> **本地 staging 直写说明（诚实）：** 变更写入 `godot_game_dev\...` **一律经 `execute_editor_script`（GDMCP）权威覆写**，源内容为 `D:\Game\New_Game\dsh_gdmcp_staging\*.v0_2.gd` 草稿（位于 Godot 项目外）。最终磁盘内容均与 GDMCP 写入一致（`WROTE bytes` 与 `scripts read` 再检核对）。**未用 shell 直写任何最终 Godot 构件。**

---

## 3. 变更文件清单（经 GDMCP 的 Godot 构件）

| 路径 | 类型 | 角色/版本 | 行数（变更前后） |
|---|---|---|---|
| `res://rules/rules_core.gd` | GDScript（`.gd`） | 规则核（DshRulesCore）+ **R3 O5 diagnostics 只读扩展** | 236 → 287 |
| `res://runtime/main.gd` | GDScript（`.gd`） | 运行时控制器（Node2D）+ **R1 真实输入驱动移动 + R2 read-model 全字段呈现** | 285 → 408 |
| `res://test/rules_core_test.gd` | GDScript（`.gd`） | gdUnit4 套件（14 既有 + **R3 O4 三变体 + O5 二用例** = 19） | 325 → 494 |
| `res://test/adapter_contract_test.gd` | GDScript（`.gd`） | gdUnit4 **R1 input→movement→lock 因果契约**套件（15 既有 + 3 新增 = 18） | 148 → 224 |

> `res://adapter/adapter.gd`、`res://rules/session.gd`、`res://scenes/main.tscn` 未改动。全部经 GDMCP 写入；创建/修改后经 `scripts read` + `analyze_script` 再检确认内容完整、解析通过。

---

## 4. 契约对照（R1/R2/R3 每个约束如何满足）

### 4.1 R1 — 真实输入驱动移动（正式化）

| 要求 | 实现落点（runtime/main.gd） | 证据 |
|---|---|---|
| WASD/方向键 → adapter `movement_from_input` | `_read_movement_input()` 为**单一正式输入路径**：`Input.is_key_pressed(KEY_W/UP/S/DOWN/A/LEFT/D/RIGHT)` 统一 WASD+箭头 → `ADAPTER.movement_from_input({up,down,left,right})`；v0.1 死代码 `_unhandled_input`/`_set_move_axis` 移除 | `[RUNTIME] player_moved dir=%s,%s player=(x,y)` 运行时日志；`adapter_contract_test` 既有 5 例 input 契约保留 |
| → adapter envelope（intent-only，携带移动） | `make_envelope(task, live_candidates, movement, 1)` 把 `movement` 作为意图载入 domain envelope；规则核**不读取移动值**（移动仅引擎位移层） | `test_movement_intent_does_not_change_rules_semantics` |
| → player 位移 | 非 self-test 模式 `position += dir * move_speed * delta`（引擎层应用位移）；self-test 保持脚本化零位移 | 运行时 `[RUNTIME] player_moved`；self-test 场景位置不变 |
| → 移动因果 → 自动攻击锁定重定位 | 敌位候选在**移动后被重读**（live_candidates 从移动后的 player position 重构建）→ 下一 pre-fire refresh 从新位置重锁快照（ADR-TECH-04 snapshot-lock ≠ live-retarget）；`[LOCK-REFRESH] player=(x,y) lock=[...]` 日志标明「current shot 快照不可变」 | `test_movement_causality_next_refresh_relocks`（移动后下一 shot 锁序翻转 [2,1]→[1,2]，本 shot 锁定集不变）+ runtime `[LOCK-REFRESH]` |
| self-test 保留为**受限确定性回归**（明确标注非玩家可玩） | `_ready` 打印 `[SELF-TEST] restricted deterministic regression (scripted zero-move + scripted fire; NOT player-playable input evidence)`；运动保持脚本化零 | self-test 日志首行标注；报告 §5.2 证据边界 |
| 输入→移动 fixture/契约测试扩展 | 沿 adapter 既有 5 例 input 测试扩展 3 例 R1 契约测试（intent-only 语义 / U2-B 下一 refresh 重锁因果 / U2-C 同几何同锁跨 run 控制） | `adapter_contract_test.gd` R1 区块（+3）全 PASS |

### 4.2 R2 — read-model 全字段落地（对齐 UX 清单 §4 + S5 字段）

| S5/UX 字段 | 实现落点（runtime/main.gd `_present_read_model`） | 证据（self-test 日志 / runtime OCR） |
|---|---|---|
| `life`（三格 segments_lost=0 + life_state） | `LIFE [o][o][o]  segments_lost=0`：三格结构位恒在，segments_lost 本单元恒 0、结构呈现；形状/文本分区非色彩可读 | runtime OCR `LIFE [o][o] segments_lost=0` |
| `timer`（current_tick + run_duration_bound opaque） | `TIMER tick=<session.tick>  run_bound=8min(opaque)`：由 `session.advance_tick()` 每帧推进确定性 tick + opaque 边界占位（定时值延后 Systems） | runtime OCR `TIMER tick=1202 run_bound=8min(opaque)` |
| `b2_phase`（枚举，唯一前-B2 值） | `B2 pre-fission (structure placeholder)`：结构位恒在、无 B2 行为 | runtime OCR `B2 pre-fission` |
| `no_target_branch` quiet（S1/S2） | 空候选 → `_enter_quiet_presentation()`：攻击线隐藏、`no target (quiet)`、无锁/无命中；引擎观察零候选即安静 | self-test `[NO-TARGET-CUE]` + `[READ-MODEL] attack: no_target (quiet) ... feedback: - (quiet)` + 攻击线 hidden |
| `no_target_cue_emitted`（可选一次性克制） | `_enter_quiet_presentation` 一次性打印 `[NO-TARGET-CUE] quiet episode begins (one-shot restrained non-color cue; bound no_target_branch)`；仅绑定 no-target 分支、非色彩、**不冻结精确表现** | self-test 日志一次 `[NO-TARGET-CUE]` |
| `attack_state` 四态（idle/resolving/resolved/no_target） | `_present_read_model` 由 rules trace 派生：`engine_quiet|(no_target&snap_empty)→no_target`；`snap_empty→idle`；`hit_empty→resolving`；else→resolved | self-test `[READ-MODEL] attack: resolving` → `resolved` → `no_target (quiet)` |
| `kill_state`（none→killed） | `kill: killed(N)` 仅当 `kill_outcomes` 非空（settlement trace），否则 `kill: none` | self-test `[READ-MODEL] ... kill: killed(2)`；runtime OCR `kill: killed(2)` |
| `hit_results_feedback` marker（逐反馈类绑定） | `_apply_feedback` 对每类 emit 打印 `[FB-BIND] lock←target_snapshot_ids / hit←hit_results / kill←kill_outcomes`；HUD `feedback: lock=N hit=N kill=N (bound: ...)`；空射→quiet | self-test `[FB-BIND] lock=[1,2]`/`hit=[1,2]`/`kill=[1,2]`；`feedback: - (quiet)` 空态 |
| `invalidation_event` presentation 节 | `_present_read_model` 扫描 result.events 中 `invalidation_event` → `invalidation: id=N tick=N (no hit this shot)`；仅「本 shot 无命中」信号，无内部 drain 细节 | 代码路径存在 + rules `test_target_removal_no_hit...` 事件断言（runtime 本单元无 picked-up 移除，适配 kill 为主路径） |
| hint 字段 | **明确未实现**（S5 §4.4 / UX 清单 E1 排除项） | 报告边界声明 + main.gd 头注释 |

**presentation 只消费 read-model（ADR-TECH-01）：** `_present_read_model` 从 `session.rules_state`/result 的 rules trace 字段读取并呈现，不从视觉状态重算目标/命中/死亡；`_apply_feedback` 消费 `ADAPTER.feedback_from_result` 的 gated 反馈。**空射不伪造（ADR-TECH-02 R4 / UX-03 S1/S2）：** 通过 adapter 既有 gate + `_enter_quiet_presentation` 的安静形态保证。

### 4.3 R3 — O4/O5 精化

| 观察项 | 实现 | 证据 |
|---|---|---|
| **O4 — KILL-\* 逐族容器方差变体 fixture** | `rules_core_test.gd` 新增 3 变体，每个 KILL-* 族在**双容器插入序**下断言 ordered_ids/snapshot/击杀行为逐位一致：`test_kill_single_container_order_variant` / `test_kill_multi_container_order_variant` / `test_kill_death_removal_container_order_variant` | headless gdUnit4 19/19 rules PASS（含 3 变体） |
| **O5 — kill 决策键 trace 元组导出** | `rules_core.step` diagnostics 只读新增：`candidate_key_trace`（M-1 链序 [{stable_id,k1,k2}]）、`kill_decision_trace`（被杀目标 [{stable_id,k1_bucket,k2_bucket,tick}]）、`live_reduction_count`（本次活体缩减数）；**additive only，不改 state/events 语义** | `test_diagnostics_kill_decision_trace_exported` / `test_diagnostics_candidate_key_trace_and_no_kill_resolve` + 既有 14 rules 测试全绿（state 语义未变） |
| 不改变既有确定性语义 | O5 全部为 diagnostics 追加；rules_core 行为（排序/锁定/失效/击杀）与上一单元逐位一致（既有 14 rules + 15 adapter 测试全过证明） | 37/37 全过 |

---

## 5. 与 UX R2 落地清单对齐（到齐后逐条核对）

### 5.1 对齐表（UX 清单 §4 呈现绑定 → 实现）

| UX 清单字段/要求（§4） | 实现 | 对齐 |
|---|---|---|
| §4.1 life（三格 segments_lost=0 + life_state） | `LIFE [o][o][o] segments_lost=0`，形状/文本非色彩分区 | ✅ |
| §4.1 timer（session drive tick + opaque bound） | `TIMER tick=<session.tick> run_bound=8min(opaque)`，每帧 session tick 推进 | ✅ |
| §4.1 b2_phase（唯一前-B2 结构位，无 B2 行为） | `B2 pre-fission (structure placeholder)` | ✅ |
| §4.2 no_target_branch quiet（无锁/无幻影命中/quiet 形态） | 空候选→安静：攻击线隐藏 / `no target (quiet)` / 无 lock/hit/kill | ✅ |
| §4.2 no_target_cue_emitted（可选一次性克制，不冻结种类） | `[NO-TARGET-CUE]` 一次性日志 + quiet label（占位，非色彩） | ✅ |
| §4.3 attack_state 四态（idle/resolving/resolved/no_target） | rules trace 派生四态，与 `resolved` 分支可区分 | ✅ |
| §4.4 feedback-binding marker（lock/hit/kill/no_hit_invalid 逐类绑定 + 禁止 emit 闸门） | adapter gate + `[FB-BIND]`（lock←target_snapshot_ids / hit←hit_results / kill←kill_outcomes）+ HUD binding line；空射 quiet | ✅ |
| §4.5 kill_state（none→killed） | `kill: killed(N)` 仅当 kill_outcomes 非空 | ✅ |
| §4.6 invalidation_event presentation 节（仅「无命中」信号） | `invalidation: id=N tick=N (no hit this shot)` | ✅ |
| §5 排除 E1–E10（hint/文案/布局/资产/数值/性能/内部分级/B2/呈现升 Gate） | **全部未落地**（hint 排除；占位表现；无冻结；无数值提升；内部分级 key 不进 presentation；B2 仅结构位） | ✅ |

> 对齐依据：UX 清单为 `PROPOSAL/DESIGN ONLY` 呈现绑定提案；本实现落地其字段→绑定映射。**未把任何 UX 提案升级为 Gate 判据/发布承诺**（UX 清单 E10 红线遵守）。R2 字段呈现与既有 QA 已观察的 HUD 占位（`LIFE [o][o][o]`/`TIMER pre-8min`/`no target (quiet)`/`attack: resolved`）在形态上延续、在字段上补全为全字段（timer tick、kill_state、feedback binding、invalidation 节）。

---

## 6. 红队发现与修复记录（如实）

1. **R1 causality 测试语义错（适配器契约首版）**：`test_movement_causality_next_refresh_relocks` 初版误把 `target_snapshot_ids` 当「仅最近目标单个」断言为 `[2]`/`[1]`、并断言移动后当前 shot 不命中远目标。**实测发现**：快照为**全部合法锁定的 M-1 序列表** `[2,1]`/`[1,2]`，resolve 命中全部锁定 ID；移动因果为**锁序翻转 + 首锁目标翻转**而非集合变化。**修正**：改断言完整序 + 锁集不可变（本 shot resolve 后 snapshot 不变）+ 首锁目标跨 shot 从 id2→id1 翻转。二次 `WROTE` 后 37/37。
2. **gdUnit4 未发现最后一个测试用例**：`adapter_contract_test.gd` 初版末尾缺少换行，导致 `test_same_geometry_same_lock_across_runs` 未被解析（run#1 仅 17/18 adapter）。**修复**：文件尾补换行，二次写入后 18/18。
3. **R1 self-test 保留为非玩家证据**：正式化时确认 self-test 运动仍为 `position += Vector2(0,0)` 脚本化零位；新增显式 `[SELF-TEST] NOT player-playable input evidence` 标注行，防止被误读为键盘移动验收。

---

## 7. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；cr-001 Option A (R09)；ADR-TECH-01..06 批准 (R11)；UX-03 S1–S3；R12 owner；AUTH-01 (R13 实现授权)；垂直切片 QA verdict `pass`（验收记录）。本报告不重写、不重分类任何一项。
- **`team_proposal`（本实现引入的机制落点）:** R1 输入路径正式化（`_read_movement_input` 单一路径 + 移动意图进 envelope + 下一 refresh 重锁因果）、R2 呈现绑定实施（对齐 UX 清单 §4 + S5）、R3 O4 变体 fixture 与 O5 kill 决策键 trace 元组导出（diagnostics 只读）。全部为机制实施，需 QA 复核，未升级。
- **`assumption`:** ① 真实键盘移动可经已批准 adapter seam 实现且可被独立 QA 观察（引擎侧，headless 不注入按键 → self-test 仅有限回归；QA 以其输入协议独立观察）② R2 呈现绑定不触任何升级判定（对齐 AUTH-01 §6，字段未升级为 Gate 判据）③ O4 双容器插入序变体足以独立验证「KILL 族排序/击杀容器无关性」（与既有 TARGET-container-order 族同法）。均需 QA 观察验证。
- **`unresolved`（全量保留，未关闭）:** cluster membership / metric / quantization / tie-break / stable-ID 生命周期 / no-target cycle 精确周期与提示形态（含 nocue 精确表现）/ life 数值语义（Systems contact）/ timer 精确时长与 tick 频率 / B2 三弧 / hint 文案·触发·effective-movement / 失效反馈精确形态 / 布局·文案·色值·阈值 / `fixture_schema_version` / raw 留存 / O6 外层 fixture envelope（evidence-harness 后续）/ 真实输入 QA 观察协议（QA 制定）——均保持 open，本实现未升级、未闭合。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本实现未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未动用/提升。

---

## 8. 边界声明（明确）

- **未实现（本单元明确延后）:** 接触（cr-006..009）/ 升级（cr-010..011）/ B2 三弧（cr-016..019）/ 终结（cr-014..015）/ focus（cr-012..013）/ spawn 节奏 / 资产 / 动画 / 音频 / 数值定稿（含 HP 多段、life 数值语义）/ 视觉 v0.2 / 导出 / 发布 / 持久化 / 玩家可见 Replay。
- **未提升候选数值 / 未锁常数:** `hp`/`attack_damage`/`move_speed`/`attack_interval` 均为参数/占位默认值；S1 ledger 数值（HP=1, range[1,5]）、timer 时长、life segment 数等保持候选（promotion_authority=User，未写为规则常数/Gate 判据）。候选预算（六项 + `1280×720` 红线）未涉及。
- **未批准/冻结任何 ADR / Systems 终裁 / fixture schema / 表现形态:** UX S5 字段与 R2 落地清单为准入输入；本实现只落地，不裁决；no_target cue 种类/hint/失效反馈/文案/布局/色值均不冻结。
- **未豁免 QA:** 本地测试（headless 37/37×2 + self-test×2 + runtime smoke）为本地证据，**不代表 Independent QA Gate 2 扩展 / Gate 3 前段验收**；QA 独立观察不豁免，尤其「真实输入驱动移动」的玩家可玩证据须由 QA 按其输入观察协议独立判定。
- **未替用户做产品/验收裁决；未替 Systems/UX/Tech/QA 代权；未触碰任何被禁止文档（CR 台账、合同、排程建议、S5 提案、UX 落地清单、既有 QA/ADR 等——未读写修改）。**
- **self-test ≠ 玩家可玩输入证据:** self-test 为受脚本化零移动 + 脚本化射击的确定性回归，已显式标注非玩家可玩；真实键盘输入由独立 QA 观察。
- **无视觉 QA / E2E / 性能 / 导出 / 发布证据**（如实）。截图 = GDMCP 捕获 + vision OCR 观察（HUD 字段呈现证据），非视觉 QA 验收。
- **写入面:** 经 GDMCP 写 4 Godot 脚本 + 本唯一实现报告；工作区临时草稿/args/日志位于 Godot 项目外并已清理；未修改任何既有文档；git 仅提交本实现 Godot 构件 + 本报告。
- **未派发任何成员:** 本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。

---

## 9. 证据清单（如实分类）

### 9.1 headless 确定性 gdUnit4（primary · 本地证据，exit 0，复跑一致）

命令（Godot 4.7.1 console exe `D:\Game\Godot_v4.7.1-stable_win64\Godot_v4.7.1-stable_win64_console.exe` + gdUnit4 6.2.x + `--ignoreHeadlessMode`）：
```
<godot> --headless --path <proj> -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd --add res://test/ --ignoreHeadlessMode --report-directory user://gdunit4-playable-run<2|3>
```
- **run #2 / #3（确定性复跑）：** 均 `Overall Summary: 37 test cases | 0 errors | 0 failures | 0 flaky | 0 skipped | 0 orphans | Exit code: 0`
  - `adapter_contract_test.gd`：**18/18 PASS**（15 既有 input/envelope/feedback/no-leakage + **3 新增 R1 移动因果**：intent-only / U2-B 下一 refresh 重锁 / U2-C 同几何同锁）
  - `rules_core_test.gd`：**19/19 PASS**（14 既有 target/session/kill + **3 新增 O4 KILL 容器序变体 + 2 新增 O5 trace 元组**）
  - run#2 与 run#3 逐位一致（仅 per-test wall-clock timing 非确定，不在比较面）。
- 保存输出：`<项目根>\dsh_gdmcp_staging\run2_output.txt` / `run3_output.txt`（清理见 §11，运行产物在 `user://gdunit4-playable-run2/3/report_1/results.xml`）。

### 9.2 S4 运行时 self-test（primary runtime · 受限确定性回归，exit 0）

命令：`<godot> --headless --path <proj> res://scenes/main.tscn -- --self-test`（两次，输出逐位一致）
```
[SELF-TEST] restricted deterministic regression (scripted zero-move + scripted fire; NOT player-playable input evidence)
[AUTO-ATTACK] locked id=1
[LOCK-REFRESH] player=(320,360) lock=[1, 2] (movement re-locks NEXT refresh; current shot snapshot immutable)
[FB-BIND] lock=[1, 2] (emitted only while target_snapshot_ids non-empty)
[READ-MODEL] attack: resolving | kill: none | feedback: lock=2 hit=0 kill=0 (bound: target_snapshot_ids/hit_results/kill_outcomes)
[AUTO-ATTACK] locked id=1
[FB-BIND] hit=[1, 2] (emitted only while hit_results non-empty)
[HIT] target id=1 / [HIT] target id=2
[FB-BIND] kill=[1, 2] (emitted only while kill_outcomes non-empty)
[KILL] id=1 died -> remove / [CLEAR] enemy id=1 cleared from play / [KILL] id=2 died -> remove / [CLEAR] enemy id=2 cleared from play
[RUNTIME] live enemies=0
[READ-MODEL] attack: resolved | kill: killed(2) | feedback: lock=2 hit=2 kill=2 (bound: ...)
[SELF-TEST] kill_outcomes=[1, 2]
[NO-TARGET-CUE] quiet episode begins (one-shot restrained non-color cue; bound no_target_branch)
[READ-MODEL] attack: no_target (quiet) | kill: killed(2) | feedback: - (quiet)
[SELF-TEST-CLEAR] enemies removed; live enemies=0 (clear visible)
```
Exit `0` 两次，stderr 空，逐位一致。证明：移动→自动攻击→命中→击杀→清除→quiet 在真实引擎 headless 闭环 + **R2 全字段呈现**（attack_state 四态 / kill_state / feedback-binding / no_target quiet / one-shot cue）可观测。

### 9.3 GDMCP runtime smoke（supplementary runtime · `gdmcp.runtime_smoke.v1` 链完passed，注册表 run `acr-fb4668e7e578`）

- `run_project` status=success / mode=playing / probe_ready / session_active=true。
- `runtime info`：current_scene=`/root/Main`，node_count=14，fps≈62，process_frames=122 推进。
- `runtime tree`：Main(2D)→ ColorRect(player) + Line2D(attack) + CanvasLayer→**8 Labels**（life/timer/b2/state/kill/feedback/invalidation/no_target 全字段 HUD）。
- `runtime screenshot`：`user://gdmcp-playable-smoke.png` 1152x648；**vision OCR** 读到：`LIFE [o][o] segments_lost=0` / `TIMER tick=1202 run_bound=8min(opaque)` / `B2 pre-vision(structure placeholder)` / `attack: no_target (quiet)` / `kill: killed(2)` / `feedback: -(quiet)` / `no target (quiet)` → R2 全字段在画面呈现且非色彩可读。
- `debug logs`：仅 Info，无 Runtime/Script Error/Warning。
- `stop_project` mode=editor；doctor `runtime_running=false`；runtime `no_active_sessions`（预期成功态）。

### 9.4 editor 校验（supplementary · 经 GDMCP）

- `analyze_script`：rules_core（287, RefCounted, has_class_name DshRulesCore）、main（408, Node2D, 12 函数）、rules_test（494, 19 测试）、adapter_test（224, 18 测试）全解析通过。
- `reload_project(full_scan)` status=success（刷新全局类缓存）。
- `detect_broken_scripts`：36 errors 全部在 `res://addons/gdUnit4/`（已知 `@abstract func` 误报，与上一单元 QA 预检一致；插件 37/37 实测可跑）；本任务 4 脚本零 error；唯一 warning = main.gd:44 有意缺类型标注的 `var session`。

### 9.5 证据边界（诚实分类）

| 证据 | 类别 | 边界说明 |
|---|---|---|
| headless gdUnit4 37/37 ×2 exit 0（复跑一致） | **primary · 本地确定性测试** | 证明 R1/R3 新增 fixture + 既有 29 全通过；**≠ Independent QA Gate 2 扩展验收**（QA 独立观察） |
| self-test exit 0 ×2 逐位一致（含 R2 呈现日志） | **primary runtime（本地有限回归）** | 证明闭环 + R2 字段可观测；**≠ Gate 3 视觉/UX 验收**；**≠ 玩家可玩输入证据**（self-test 非键盘移动） |
| GDMCP runtime smoke + 截图 + vision OCR | **supplementary runtime** | 证明场景加载、player/HUD 全字段渲染、停止干净；**截图仅证明捕获/画面状态，非视觉 QA 验收** |
| git（4 Godot 构件改动 +496/−71，仅本实现） | **source-revision** | 变更可追溯、回滚点（git diff 逐条核对） |
| 无 | （本任务不产生） | **无** 真实玩家键盘输入观察（QA 协议未执行）/ 视觉 QA / E2E / 性能 / 导出 / 发布证据 |

> 明确标注：**无任何独立视觉/UX/E2E/性能/导出/QA 验收证据**；「真实输入驱动移动」玩家可玩性未经独立 QA 键盘观察（QA 制定 input 注入/有界演示协议后独立验收）；本地证据不代表 Independent QA 验收。

---

## 10. 交接与下一步

- **Handoff 给 Independent QA（Gate 2 扩展 + Gate 3 前段）：** R1 移动因果契约（intent-only / U2-B 下一 refresh 重锁 / U2-C 同几何同锁）+ R3 O4 KILL 容器序变异 / O5 kill 决策键 trace 元组（`kill_decision_trace`/`candidate_key_trace`/`live_reduction_count`）作为确定性验收输入；R2 呈现（HUD 全字段 + attack_state 四态 + kill_state + feedback-binding + no-target quiet）作为 Gate 3 前段可观察性输入（U2/U3 + UX-09/13）。**QA 制定真实输入观察协议**后独立做玩家键盘移动验收（self-test 非玩家证据）。
- **待评审/后续项：** 真实输入 QA 观察协议；O6 外层 fixture envelope（evidence-harness 后续，不阻塞）；no_target cue 精确表现 / hint / 失效反馈形态等 unresolved 项留后。
- **明确不在本实现范围：** 接触/升级/B2/终结/focus；资产/动画/音频/数值/视觉 v0.2/导出/发布/Replay。

---

## 11. Closure

- **closure_ready: YES**
- 结论：**R1**（真实输入驱动移动正式化：WASD/箭头→adapter envelope→player 位移→移动因果→下一 refresh 锁定重定位；移除死代码；self-test 保留为受限确定性回归并标注非玩家证据）+ **R2**（S5/UX 清单全字段呈现：HUD 最小面 life/timer/b2、no-target quiet（S1/S2）、attack_state 四态、feedback-binding 逐类绑定 marker、kill_state none→killed、invalidation presentation 节；hint 明确排除）+ **R3**（O4 KILL-* 逐族容器序变异体 fixture / O5 kill 决策键+候选键+活体缩减 trace 元组只读导出）均经 GDMCP 应用并验证。
- 本地证据：headless gdUnit4 **37/37**（rules 19 + adapter 18）exit 0 且复跑逐位一致；self-test exit 0 ×2 逐位一致（含 R2 呈现日志）；GDMCP runtime smoke + 截图 + vision OCR（HUD 全字段呈现非色彩可读）；analyze_script 全通过；detect_broken 本任务零 error；git 变更仅 4 构件 +496/−71。
- **UX R2 落地清单到齐后已逐条对齐**（§5.1）：R2 呈现绑定与 UX 清单 §4/§5 全部一致，不再存在待对齐状态。
- 证据边界如实：本地测试 ≠ QA 验收；self-test ≠ 玩家可玩输入证据；无视觉/E2E/性能/导出/QA 证据。
- 边界声明完整：未做延后项、未提升候选数值、未批准/冻结契约/表现形态、QA 不豁免、未碰任何被禁止文档、未派发成员。
- 本报告完成后停止，不进入下一阶段、不派发任何成员。

---

## 12. 版本与变更记录

- **v0.1（本文件）：** Godot Gameplay Engineer 唯一实现报告产物。R1（真实输入驱动移动正式化）+ R2（read-model 全字段呈现，对齐 UX 清单 §4/§5）+ R3（O4 KILL 容器序变体 / O5 kill 决策键 trace 元组）经 GDMCP 落地并验证（本地 evidence）；headless 37/37 ×2 + self-test ×2 + runtime smoke + vision OCR；UX R2 落地清单到齐后逐条对齐；git 变更仅 4 Godot 构件；边界声明与证据边界完整。
