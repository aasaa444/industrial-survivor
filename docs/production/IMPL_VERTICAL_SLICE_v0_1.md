# IMPL VERTICAL SLICE v0.1 — S2 规则核 kill 路径 + S3 Adapter seam + S4 最小运行时场景 实现说明

> **Status:** `IMPLEMENTED (local engineering evidence)` — **本地测试/运行时观察 ≠ Independent QA 验收**（Gate 2 扩展 / Gate 3 前段由 Independent QA 独立执行，本实现不豁免、不自证）。
> **Role:** Godot Gameplay Engineer（玩法工程师 · 实现 owner, R12；R13 实现授权生效）
> **Artifact owner (sole author):** Godot Gameplay Engineer
> **Report ID:** `IMPL_VERTICAL_SLICE_v0_1`
> **Version:** v0.1（首版）
> **Date:** 2026-08-17
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **排程输入:** `NEXT_IMPL_UNIT_PLAN_v0_1.md` 路径 A+（S2/S3/S4）；Systems S1 `ENEMY_LIFETIME_LEDGER_v0_1.md`（杀路径语义起点）；UX S5 `READ_MODEL_MINIMAL_FIELDS_v0_1.md`（最小 read-model 字段）。
> **源修订（git）:** commit `822c51e`（本项目 Godot 构件；git 已初始化，版本控制门满足）。

---

## 0. 授权与边界声明（总览）

- 本任务为**唯一被派遣成员**执行的实现单元 = S2（规则核 kill 路径）+ S3（Adapter seam）+ S4（最小运行时场景），按 Producer 排程 A+ 派发（R13 授权生效）。
- **所有 Godot 构件变更均经 GDMCP**（`execute_editor_script` via FileAccess / `analyze_script` / `reload_project`）；**无 shell/direct-write 绕道**（有一处本地 staging 直写 *草稿* 后立即经 GDMCP 权威覆写，属内部草稿，最终落盘均以 GDMCP 为准——见 §2 接口实测说明）。
- **S1/S5 到齐标注：** 本会话开始时 `ENEMY_LIFETIME_LEDGER_v0_1.md`（S1）与 `READ_MODEL_MINIMAL_FIELDS_v0_1.md`（S5）**尚未存在**（glob 未发现），我按任务 packet 中「给定 kill 要点」实现；随后两者在会话中**到齐**，我已**逐条对齐**：kill 语义实现与 S1 ledger（HP=1/单击击杀/死亡移除）一致；运行时 HUD/read-model 占位已按 S5 字段对齐（见 §4.6）。因此**不再存在**「S1/S5 未到齐待对齐」状态，改为「实现时按给定要点、S1/S5 到齐后已验证对齐」。
- 未实现接触/升级/B2/终结/focus/资产/动画/音频/数值定稿/视觉 v0.2/导出/发布/持久化/Replay（全部延后，见 §8 边界声明）。
- 未提升任何候选数值；候选预算（六项 + `1280×720` 红线）仅候选、本任务不涉及；未豁免 QA。

---

## 1. Expert preflight（start 证据，按 godot-gameplay-engineer-expert §Expert preflight）

| 项 | 值 |
|---|---|
| 契约 | ADR-TECH-01..06 已批准（R11）；Systems S1 ledger（kill 语义）；UX S5 read-model 字段；QA_ACCEPTANCE_PLAN Gate 2 判据；NEXT_IMPL_UNIT_PLAN A+ |
| 项目根 | `D:\Game\New_Game\godot_game_dev` |
| 变更边界 | 经 GDMCP 写入的 5 个 Godot 脚本 + 1 个运行时场景（.tscn）；1 份实现报告 |
| 当前相关状态 | editor_connected: true；runtime_running: false（观察后已停）；Godot 4.7.1；gdmcp 1.0.7；gdUnit4 6.2.x 已启用 |
| 三大技术风险 | ① 全局 class_name 缓存依赖导致 headless 场景加载解析失败 ② kill 路径不触碰已批准 ADR-TECH-04 锁定/invalidation 语义（重复/幽灵命中）③ 运行时 self-test 终止逻辑（无输入 hang） |
| GDMCP 路线 | `doctor` → `editor state` → `execute_editor_script`（base64 FileAccess 写文件）→ `scripts read`/`analyze_script` 再检 → headless gdUnit4 → `run_project`/runtime smoke 观察 → `stop_project` → `reload_project`（刷新全局类缓存） |
| 检查 | headless gdUnit4（S2 kill fixtures 14/14 + S3 adapter contract 15/15 + determinism 复跑）；运行时 self-test（exit 0 + 完整日志）；runtime smoke screenshot + tree；detect_broken_scripts |
| 回滚计划 | 变更集中在规则核 kill 纯逻辑 + adapter 纯翻译 + 运行时（引擎 free 规则核部分）。回滚 = 撤 4 脚本 + 1 场景（经 GDMCP / git）；已提交 commit `822c51e` 提供源级回退点。adapter 不入侵规则核（排序严格留在规则核单一 owner）；运行时自我包含（不触其它场景） |
| 停止条件 | 报告写入即停；不进入下一阶段、不派发任何成员 |

**服务失败处理（如实记录）:** 会话中 GDMCP 服务一次不可达（`SERVICE_UNREACHABLE`，编辑器进程随运行时自测 hang 退出）。按 gdmcp `runtime_stop`/editor 生命周期契约，重新启动编辑器（后台）并等待端口 9080 恢复后继续 GDMCP 操作；编辑器 PID 已由 `--editor` 参数管理，未用 shell 直写任何 Godot 构件。证据见 §2 步骤 13–16。

---

## 2. 实际工具顺序与能力证据（真实记录）

接口实测纪律（DSH 2026-08-16）：不凭函数清单判 `skill` 不可用，实际发起调用验证。

| # | 工具/动作 | 结果 |
|---|---|---|
| 1 | `skill({name:"godot-gameplay-engineer-expert"})` | ✅ **实测成功**（返回完整 SKILL 指令；未报 unknown tool）。能力证据等级 = `strong_direct_skill`（首选）。无需 fallback 到 `C:\Users\User\.agents\skills\godot-gameplay-engineer-expert\SKILL.md` |
| 2 | `skill("gdmcp")` / `skill("gdunit-driver")` | ✅ 实测成功（完整指令返回；gdmcp 要求先读 `references/standard-action-chains.md` + action-chain-registry） |
| 3 | read 必读文档（NEXT_IMPL_UNIT_PLAN / IMPL_MINIMAL_CORE / QA_GATE2 / QA_ACCEPTANCE_PLAN / SEMANTICS_INVALIDATION_FINAL / ADR / UX 合同） | ✅ 全部成功 |
| 4 | `gdmcp --json doctor` + `editor state`（`gdmcp.editor_preflight.v1`） | ✅ editor_connected:true；Godot 4.7.1；runtime_running:false |
| 5 | glob 确认 S1/S5 ledger 初始不存在（后续到齐） | ✅ 初始无 `ENEMY_LIFETIME_LEDGER`/`READ_MODEL_MINIMAL_FIELDS` |
| 6 | S2 规则核 kill 路径：`execute_editor_script`（base64 FileAccess）写入 `res://rules/rules_core.gd` | ✅ `WROTE bytes=11673`；`analyze_script` ok:true（237 行，has_class_name，extends RefCounted） |
| 7 | S2 测试：写入 `res://test/rules_core_test.gd`（14 用例） | ✅ 首次 14 用例中 `test_kill_death_removal_no_ghost_hit` 3 断言失败（测试语义错：两目标同 hp=1 同死致 live_only 为空）；修正为「target1 hp=1 死 / target2 hp=5 活」，复跑 14/14 PASS |
| 8 | S2 确定性：headless gdUnit4 复跑 | ✅ run 3: `14 test cases | 0 errors | 0 failures` exit 0；run 4 同 14/14 exit 0；XML `tests=14 failures=0` |
| 9 | S3 adapter：写入 `res://adapter/adapter.gd`（class_name DshAdapter，extends RefCounted） | ✅ `WROTE bytes=7149`（后续调整为 preload const 后 7186）；analyze ok:true |
| 10 | S3 测试：写入 `res://test/adapter_contract_test.gd`（15 用例） | ✅ 15/15 PASS exit 0 |
| 11 | S4 场景+运行时：写入 `res://runtime/main.gd` + `res://scenes/main.tscn` | ✅ `WROTE main.gd + main.tscn`；analyze main ok:true（extends Node2D，11 函数识别） |
| 12 | **S4 解析失败（红队发现）→ 修复** | ❌→✅ 首次 headless 运行报 `DshAdapter not declared`（全局 class_name 缓存未含新 adapter class）。**修复**：main.gd/adapter.gd 改用 `preload const`（不依赖全局类缓存），`reload_project(full_scan)` 刷新缓存；后续加载正常 |
| 13 | **GDMCP 服务不可达（SERVICE_UNREACHABLE）** | ⚠️ 运行时自测 hang 使编辑器进程退出、9080 端口不可达。**修复**：按 gdmcp 生命周期重启编辑器（后台，`--editor`）等待端口恢复；`doctor` 恢复 editor_connected:true |
| 14 | S4 运行时 self-test（headless `res://scenes/main.tscn -- --self-test`） | ❌→✅ 首次每 `_process` 空候选早退导致不触 self-test step（hang）；修复后在空候选分支也调 `_self_test_step`。最终 exit 0，日志完整（[AUTO-ATTACK]→[HIT]→[KILL]→[CLEAR]→live enemies=0→SELF-TEST-CLEAR） |
| 15 | S4 runtime smoke（`gdmcp run_project` 观察，`gdmcp.runtime_smoke.v1`） | ✅ `run_project` status:success / probe_ready:true / session_active:true；`runtime info` current_scene=/root/Main、node_count=8、process_frames；`runtime screenshot` 1152x648 成功；`stop_project` mode:editor；HUD 截图经 vision 读回：LIFE/TIMER/B2 + no target cue + attack: resolved + 青色 player 方块 |
| 16 | 全量验证：headless gdUnit4 `--add res://test/` | ✅ `Overall Summary: 29 test cases | 0 errors | 0 failures` exit 0（14 rules + 15 adapter），复跑一致（determinism） |
| 17 | `detect_broken_scripts` | ⚠️ 36 报错全部在 `res://addons/gdUnit4/`（已知 `@abstract func` 误报，预检确认插件可用）；本任务 5 脚本**零 error**；唯一 warning= `runtime/main.gd:23` 「变量缺类型」对应我有意保留的 `var session`（引擎 free，为避免全局类依赖，注释已说明） |
| 18 | git | ✅ 已 init（版本控制门）；提交 `822c51e`（13 files，1205 insertions） |
| 19 | 清理 staging + 最终 doctor | ✅ 临时 JSON/日志外置于项目外已清理；最终 doctor `editor_connected:true` / `runtime_running:false` |

> **本地 staging 直写说明（诚实）：** S2 规则核/测试与我创建的新脚本在落盘到 `godot_game_dev/...` 时，先以工作区草稿文件存在，随后**一律经 `execute_editor_script`（GDMCP）权威覆写**并 `scripts read`/`analyze_script` 再检。最终磁盘内容均与 GDMCP 写入一致（`WROTE bytes` 与 `scripts read` 再检核对）。唯一一个未再经 GDMCP 的临时 PNG（`docs/_runtime_smoke_evidence.png`）系命令误存，已删除。**未用 shell 直写任何最终 Godot 构件**。

---

## 3. 变更文件清单（经 GDMCP 的 Godot 构件）

| 路径 | 类型 | 角色/版本 | 行数 |
|---|---|---|---|
| `res://rules/rules_core.gd` | GDScript（`.gd`） | 规则核心（`class_name DshRulesCore`）+ **S2 kill 路径** | 236 |
| `res://adapter/adapter.gd` | GDScript（`.gd`） | **S3 Adapter seam**（`class_name DshAdapter`，extends RefCounted） | 139 |
| `res://runtime/main.gd` | GDScript（`.gd`） | **S4 运行时控制器**（extends Node2D；player/enemy/auto-attack/HUD/self-test） | 285 |
| `res://scenes/main.tscn` | Godot scene（`.tscn`） | **S4 最小运行时场景**（root Node2D + main.gd） | 6 |
| `res://test/rules_core_test.gd` | GDScript（`.gd`） | gdUnit4 套件（14 用例 = 原 7 + **KILL-* 7**） | 325 |
| `res://test/adapter_contract_test.gd` | GDScript（`.gd`） | gdUnit4 **S3 adapter 契约**套件（15 用例） | 148 |

> `res://rules/session.gd` 未改动（保持 DshSession，Gate 2 已验）。全部经 GDMCP 写入；创建/修改后经 `scripts read` + `analyze_script` 再检确认内容完整、解析通过。

---

## 4. 契约对照（每个约束如何满足）

### 4.1 S2 — 规则核 kill 路径（NEXT_IMPL_UNIT_PLAN S2；Systems S1 ledger）

| S1 ledger / packet 语义 | 实现落点（rules_core.gd） | 证据 |
|---|---|---|
| 敌人 HP（段，候选起始=1） | 候选记录携带 `hp`（默认 1）；未显式 hp 时按 1 处理（兼容 TARGET-* 无 hp 字段） | `test_kill_candidate_without_hp_defaults_to_one` |
| 单击自动攻击伤害→死亡 | `step` envelope 参数 `attack_damage`（默认 1）；`resolve` 对 `resolution_outcome="hit"` 的锁定 ID 扣减 hp；hp≤0 ⇒ `alive=false` + `dead=true` + `kill_event` + `kill_outcomes[id]=true` | `test_kill_single_hit_kills_enemy`、`test_kill_multi_targets_multi_hit` |
| 死亡→live 集移除/清理缩减 | `ordered_candidates` 已过滤 `alive==true`，死亡候选（alive=false）在下一 refresh 自然被踢出 → 无鬼影命中；`kill_outcomes` + `kill_event` 为清理/缩减 trace | `test_kill_death_removal_no_ghost_hit`、`test_kill_removed_target_produces_no_hit_and_no_kill` |
| 不触碰失效语义 (ii) | 死亡即在命中断言内判定；失效/移除目标（drain 点）仍产出 `no-hit-invalid` 且**无 kill、无伪造命中** | `test_kill_removed_target_produces_no_hit_and_no_kill` |
| 不锁常数 / 不提升数值 | HP 默认与 attack_damage 均为**参数/默认值**（非硬编码规则常数）；S1 promotion=User，本实现未把任何值写为规则常数/门槛 | 代码默认值 + 报告边界声明 |
| trace/确定性 | 新增 `kill_outcomes`（state+diagnostics）、`kill_event(id,tick)`；规则核零 RNG；headless 复跑逐位一致 | XML tests=14 failures=0 |

### 4.2 S3 — Adapter seam（NEXT_IMPL_UNIT_PLAN S3；ADR-TECH-01/02；UX-03 S2）

| 约束 | 实现落点（adapter.gd） | 证据 |
|---|---|---|
| 输入设备→domain input envelope | `movement_from_input({w,a,s,d,up,left,down,right})` → 整数轴方向 + moved；`make_envelope` 组装 domain envelope（task + candidates + movement + attack_damage + removed_ids） | `test_input_*`（5 例）、`test_make_envelope_carries_movement_and_candidates` |
| 规则核 step 驱动（session） | `pick_task(force_refresh, locked_this_epoch)` 选 refresh/resolve；`candidate_from_observation` 把引擎实体观察翻译为候选（stable_id + k1/k2 量化桶 + alive + hp）；经 `session.step`（DshSession）驱动 | `test_pick_task_*`、`test_adapter_candidates_feed_core_ordering` |
| 域事件→引擎反馈（绑定 hit_results） | `feedback_from_result`：lock 只在 `target_snapshot_ids` 非空时 emit；hit 只在 `hit_results` 非空时 emit；kill 只在 `kill_outcomes` 非空时 emit | `test_feedback_lock/hit/kill_*` |
| 空射不伪造（ADR-TECH-02/UX-03 S2） | no-target 空 shot：`feedback["no_target"]=true` 且 lock/hit/kill 全空；只允许可选非色彩 no-target cue，绝不产生锁指示/幻影命中 | `test_feedback_empty_shot_no_forgery`、`test_feedback_no_hit_then_locked_only` |
| 不泄漏规则语义 | adapter 不选目标/不判命中/不排序——target/hit/死亡全由 rules core 决定，adapter 只机械翻译与中继 | `test_adapter_candidates_feed_core_ordering`（顺序由 core 决定） |

### 4.3 S4 — 最小运行时场景（NEXT_IMPL_UNIT_PLAN S4）

| 要求 | 实现落点（runtime/main.gd + main.tscn） | 证据 |
|---|---|---|
| player 节点 | `player_visual` ColorRect（青色 placeholder）+ `position` 可控 | runtime screenshot（vision 读到青色 player 方块） |
| ≥1 enemy 节点（作 ordered_candidates 输入） | `_new_enemy_node` 建 Node2D+ColorRect；`_process` 把 live enemy 位置经 `candidate_from_observation` 喂给 rules core（内含 k1/k2 量化） | runtime tree / self-test 日志（[AUTO-ATTACK] locked id=1） |
| 自动攻击可见指向锁定快照目标 | `attack_line`（Line2D）在 `fb["lock_target"]` 非空时指向锁定 enemy（不重定位，对齐 ADR-TECH-04） | `[AUTO-ATTACK] locked id=1`；空候选时 line hidden + `no target (quiet)` |
| 击杀→敌人移除→清除可见 | `fb["kill"]` → `queue_free()` 杀死 enemy node；`[KILL]`/`[CLEAR]`/`[RUNTIME] live enemies=N` 日志；self-test `remaining==0` 判定 clear | `[KILL] id=1 died -> remove`、`[CLEAR]`、`[SELF-TEST-CLEAR] live enemies=0`、exit 0 |
| 占位表现（无美术承诺） | ColorRect/Line2D/Label 占位；HUD 显示 read-model 占位字段；无资产/动画/音频 | 截图 + 报告边界声明 |

### 4.4 ADR-TECH-01（seam / engine-free）
- 规则核 + adapter 均为 `extends RefCounted` 纯逻辑（engine-free）；adapter 用 `Vector2`（纯类型）翻译，不碰场景树/渲染/输入设备轮询（纯翻译函数）；输入轮询发生在 `runtime/main.gd`（引擎层），adapter 只收 bool 入参。
- `ordered_candidates` 仍唯一在规则核；adapter 只产生候选、不排序/不判 hit。

### 4.5 ADR-TECH-02（purity / lifecycle / read-model）
- `step` 纯净（不读墙钟/设备/场景树/UI/全局随机）；`kill_outcomes` 追踪同类。
- **Empty-shot non-forgery（R4/UX-03 S2）：** `feedback_from_result` 严格 gate——lock/hit/kill 三类只在各自规则源非空时 emit；`runtime/main.gd` 据此显示 no-target quiet 而非伪锁/伪命中。
- 运行时场景不成为 second rules 实现（只消费规则核输出 + adapter feedback）。

### 4.6 S5 read-model 对齐（UX 字段到齐后）
- HUD 最小面占位：`LIFE [o][o][o] TIMER pre-8min B2 pre-fission`（对应 S5 §4.1 life/timer/b2，本单元无接触/B2 → segments/阶段为结构占位，未引入行为）。
- `no_target` quiet：`no target (quiet)`（对应 S5 §4.2 `no_target_branch`/`no_target_cue_emitted` 可选一次性克制提示；无数值/惩罚）。
- `attack_state`：`idle / resolving / resolved / no_target` 占位 Label（对应 S5 §4.3 `attack_state` enum，仅结构信号）。
- **明确未落地 hint 字段**（S5 §4.4 排除项——hint 文案/触发/effective-movement 全 `unresolved`，Engineer 不得擅自落地）。

### 4.7 Gate 2 判据对齐方向（QA_ACCEPTANCE_PLAN §2.2）
| 判据 | 本实现本地证据（非 QA 验收） |
|---|---|
| Fixture 覆盖（KILL-* + 扩展 TARGET-*） | `KILL-single` / `KILL-multi` / `KILL-death-removal` + TARGET-* enemy-lifetime 兼容（`test_target_order_unchanged_by_enemy_lifetime_fields`）全在套件 |
| 排序确定性 | `ordered_candidates` 仍纯全序键链（整数桶 k1/k2/stable_id）；headless 复跑 29/29 逐位一致 |
| 失效语义 (ii) | kill 路径与移除失效一致：死亡目标不命中；移除目标无 kill |
| no-target | `test_target_no_target_branch` 维持 + 运行时 quiet 形态 |
| trace 字段 | 新增 `kill_outcomes`/`kill_event`；原 tie-break/ordered/invalidation/hit/reoluction 齐 |
| 比较纪律 | 全部精确值断言，零容差 |

> 候选预算（六项 + 1280×720 红线）本任务未涉及、未提升。

---

## 5. 证据清单（如实分类）

### 5.1 headless 确定性 gdUnit4（primary · 本地证据，exit 0）

命令（Godot 4.7.1 console exe + gdUnit4 6.2.x + `--ignoreHeadlessMode`）：
```
<godot> --headless --path <proj> -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd \
  --add res://test/ --ignoreHeadlessMode --report-directory user://gdunit4-final2
```
- **最终全量运行：** `Overall Summary: 29 test cases | 0 errors | 0 failures | 0 flaky | 0 skipped | 0 orphans | Exit code: 0`
  - `rules_core_test.gd`：14/14 PASS（原 7 target/session + 7 KILL-*/兼容）
  - `adapter_contract_test.gd`：15/15 PASS（input mapping / envelope routing / feedback binding / no leakage）
- **确定性复跑：** 多次 29/29 exit 0 逐位一致；XML（`user://gdunit4-final2` 等）均 `tests=29 failures=0 errors=0 skipped=0`。

### 5.2 S4 运行时 self-test（primary runtime · headless 场景 + exit 0）

命令：`<godot> --headless --path <proj> res://scenes/main.tscn -- --self-test`
```
[AUTO-ATTACK] locked id=1
[AUTO-ATTACK] locked id=1
[HIT] target id=1
[HIT] target id=2
[KILL] id=1 died -> remove
[CLEAR] enemy id=1 cleared from play
[KILL] id=2 died -> remove
[CLEAR] enemy id=2 cleared from play
[RUNTIME] live enemies=0
[SELF-TEST] kill_outcomes=[1, 2]
[SELF-TEST-CLEAR] enemies removed; live enemies=0 (clear visible)
```
Exit `0`（两次一致）；stderr 空。该日志证明 slice 前四动词「移动→自动攻击→命中→击杀→清除」在真实引擎内闭环。

### 5.3 GDMCP runtime smoke（supplementary runtime · `gdmcp.runtime_smoke.v1`）
- `run_project` status=success / mode=playing / probe_ready=true / session_active=true。
- `runtime info`：current_scene=`/root/Main`，node_count=8，process_frames 推进（主循环运行）。
- `runtime screenshot`：`user://gdmcp-runtime-smoke.png` 1152x648；vision 读回：HUD `LIFE [o][o][o] TIMER pre-8min B2 pre-fission`、`no target (quiet)`、`attack: resolved` + 青色 player 方块；attack line 隐藏（demo 内 enemies 均已击杀清除 → 无目标，指向正确 quiet 后态）。
- `stop_project` mode=editor；editor `editor_connected:true` / runtime_running:false。

### 5.4 editor 校验（supplementary · 经 GDMCP）
- `analyze_script`：rules_core（236 行, ok, extends RefCounted）、adapter（139 行, ok, class_name DshAdapter）、main（285 行, ok, extends Node2D, 11 函数）、rules_core_test（325 行, 14 测试）、adapter_contract_test（148 行, 15 测试）全解析通过。
- `reload_project(full_scan)` status=success（刷新全局类缓存，解决 class_name 解析）。
- `detect_broken_scripts`：36 报错全在 `res://addons/gdUnit4/`（已知误报）；本任务 5 脚本零 error；main.gd:23 唯一 warning=有意 `var session`（无类型；为免全局类依赖，注释已说明）。

### 5.5 证据边界（诚实分类）

| 证据 | 类别 | 边界说明 |
|---|---|---|
| headless gdUnit4 29/29 exit 0（复跑一致） | **primary · 本地确定性测试** | 证明 S2 kill fixtures + S3 adapter 契约在本引擎下与期望一致；**≠ Independent QA Gate 2 扩展验收**（QA 独立观察，不豁免） |
| S4 运行时 self-test exit 0 + 日志 | **primary runtime（本地）** | 证明「移动→自动攻击→命中→击杀→清除」在真实引擎 headless 闭环；**≠ Gate 3 视觉/UX 验收** |
| GDMCP runtime smoke + screenshot | **supplementary runtime** | 证明场景加载、player/enemy/HUD 渲染、停止干净；**截图仅证明捕获能力，非视觉 QA 验收** |
| git commit `822c51e` | **source-revision** | Godot 构件源修订可追溯；回滚点 |
| 无 | （本任务不产生） | **无**视觉 QA / E2E / 性能 / 导出 / 发布证据 |

> 明确标注：**无任何独立视觉/UX/E2E/性能/导出/QA 验收证据**；本地证据不代表 Independent QA 验收。

---

## 6. 红队发现与修复记录（如实）

1. **测试语义错（S2）**：`test_kill_death_removal_no_ghost_hit` 初版两目标均 hp=1 → 均死 → live_only 空 → 期望 target_snapshot_ids=[2] 失败。修正语义（target1 hp=1 死 / target2 hp=5 活），复跑 14/14。
2. **全局类缓存依赖（S4）**：headless 场景加载 `DshAdapter not declared`。修复：main.gd/adapter.gd 用 `preload const`（不依赖全局 class_name 缓存），`reload_project(full_scan)` 刷新；移除 `var session: DshSession` 类型标注（改无类型+注释）。
3. **运行时 self-test hang（S4）**：空候选早退不触 `_self_test_step`。修复：在空候选分支也调用 `_self_test_step`；终止条件改为 `remaining==0`（clear 判据）。
4. **GDMCP 服务不可达**：编辑器进程随自测 hang 退出。修复：重启编辑器（后台 `--editor`）等待端口恢复后继续；未用 shell 直写绕过。
5. **GDScript 首版 `execute_editor_script` 编译失败**（嵌套 `func execute()` 不被接受）：改为 bare top-level 语句体（与 prior impl 相同结论），成功。

---

## 7. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；revision-02 #3/#4；PRECHARTER-01..11；cr-001 Option A (R09)；ADR-TECH-01..06 批准 (R11)；R12 owner；AUTH-01 (R13 实现授权)。本报告不重写、不重分类任何一项。
- **`team_proposal`（本实现引入的机制落点）:** kill 路径纯逻辑（hp 默认 1 + attack_damage 参数化）、adapter 纯翻译 seam、最小运行时 self-test 观察形态。全部为机制落实建议，需 QA/评审确认，未升级。
- **`assumption`:** kill 语义与 S1 ledger 起始一致（HP=1/单击击杀）且在已批准 ADR 内可落地（本实现已验证为真）；adapter 纯函数可在 headless 独立引用（已验证）；死亡移除后的 quiet 后态可观察（已 runtime 观察）。三者均在本实现样本内验证。
- **`unresolved`（全量保留，未关闭）:** cluster membership；多段 HP 精确值/是否引入（S1 range [1,5] 候选）；spawn 节奏；走廊恢复可读反馈形态；no-target cycle 精确周期/提示形态；fixture_schema_version；life 数值语义；timer 精确时长/频率；B2 三弧；hint 文案/触发——均保持 open，本实现未升级、未闭合。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本实现未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未动用/提升。

---

## 8. 边界声明（明确）

- **未实现（本单元明确延后）:** 接触（cr-006..009）/ 升级（cr-010..011）/ B2 三弧（cr-016..019）/ 终结（cr-014..015）/ focus-epoch（cr-012..013）/ spawn 节奏 / 资产 / 动画 / 音频 / 数值定稿 / 视觉 v0.2 / 导出 / 发布 / 持久化 / 玩家可见 Replay。
- **未提升候选数值 / 未锁常数：** HP 默认与 attack_damage 均为参数/默认值；S1 ledger 数值（HP=1, range[1,5]）保持候选，promotion_authority=User，本实现未写为规则常数/门槛/Gate 判据。候选预算（六项 + `1280×720` 红线）未涉及。
- **未批准/冻结任何 ADR / Systems 终裁 / fixture schema：** S1/S5 为准入输入；本实现只落地，不裁决契约。失效语义 (ii) 已由 Systems 终裁，本实现与之一致，不重新开口。
- **未豁免 QA：** 本地测试（headless + runtime self-test + gdmcp smoke）为本地证据，**不代表 Independent QA Gate 2 扩展 / Gate 3 前段验收**；QA 独立观察不豁免。
- **未替用户做产品/验收裁决；未替 Systems/UX 代权；未触碰任何被禁止文档（CR 台账、合同、排程建议、S1/S5 ledger 等——未修改）。**
- **无视觉 QA / E2E / 性能 / 导出 / 发布证据**（如实）。截图 = GDMCP 捕获证明，非视觉 QA 验收。
- **写入面：** 经 GDMCP 写 5 Godot 脚本 + 1 场景 + 本唯一实现报告；删除 1 个误存临时 PNG；未修改任何既有文档；git commit 仅含本实现 Godot 构件。
- **未派发任何成员：** 本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。

---

## 9. 交接与下一步

- **Handoff 给 Independent QA（Gate 2 扩展 + Gate 3 前段）：** S2 kill fixtures（`KILL-single`/`KILL-multi`/`KILL-death-removal` + TARGET-* enemy-lifetime 兼容）与 S3 adapter 契约（input mapping / envelope / feedback-binding / no-leakage）作为确定性确定性验收输入；S4 运行时 self-test 日志 + runtime smoke screenshot 作为「移动→自动攻击→命中→击杀→清除→quiet」可观察性输入（Gate 3 前段 U2/U3 参考）。
- **待评审/后续项：** 多段 HP 与 spawn（S1 候选/后续）、走廊恢复可读反馈形态（归 UX 观察）、`KILL-*` 精确 fixture schema（cr-110）、hint（明确排除，留后续单元）。
- **明确不在本实现范围：** 接触/升级/B2/终结/focus；资产/动画/音频/数值/视觉 v0.2/导出/发布/Replay。

---

## 10. Closure

- **closure_ready: YES**
- 结论：S2（规则核 kill 路径确定性纯逻辑 + KILL-* fixture）、S3（Adapter seam 输入→envelope、step/session 驱动、域事件→引擎反馈绑定 hit_results、空射不伪造）、S4（最小运行时场景：player + enemies + 自动攻击指向锁定快照目标 + 击杀→敌人移除→清除可见 + 最小 HUD 占位）均经 GDMCP 应用并验证。
- 本地证据：headless gdUnit4 **29/29**（14 rules + 15 adapter）exit 0 且复跑逐位一致；S4 运行时 self-test exit 0 完整日志；GDMCP runtime smoke + screenshot；analyze_script 全通过；detect_broken 本任务零 error；git commit `822c51e`。
- S1/S5 到齐后已对齐（kill 语义 = S1 HP=1/单击击杀/死亡移除；HUD/read-model 占位对齐 S5 最小面，hint 明确排除）。
- 证据边界如实：本地测试 ≠ QA 验收；无视觉/E2E/性能/导出/QA 证据。
- 边界声明完整：未做延后项、未提升候选数值、未批准/冻结契约、QA 不豁免、未碰任何被禁止文档、未派发成员。
- 本报告完成后停止，不进入下一阶段、不派发任何成员。

---

## 11. 版本与变更记录

- **v0.1（本文件）：** Godot Gameplay Engineer 唯一实现报告产物。S2 规则核 kill 路径 + S3 Adapter seam + S4 最小运行时场景经 GDMCP 落地并验证（本地 evidence）；KILL-* fixture 与 adapter 契约测试、运行时 self-test/runtime smoke；S1/S5 到齐后对齐；git commit `822c51e`；边界声明与证据边界完整。
