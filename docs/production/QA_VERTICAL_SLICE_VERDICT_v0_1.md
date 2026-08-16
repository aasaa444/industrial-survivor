# QA VERTICAL SLICE VERDICT v0.1 — Gate 2 扩展 + 垂直切片前段（Gate 3 前段）独立验收裁定书

> **Status:** `INDEPENDENT QA VERDICT — COMPLETED / PASS（附非阻断观察项）`
> **Role:** Independent QA / Release Lead（独立验收负责人 · `godot-qa-release-expert`）
> **Artifact owner (sole author):** Independent QA / Release Lead
> **Report ID:** `QA_VERTICAL_SLICE_VERDICT_v0_1`
> **Date:** 2026-08-17（验收执行）
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **验收对象:** `res://rules/rules_core.gd`（S2 kill 路径）· `res://adapter/adapter.gd`（S3 契约）· `res://runtime/main.gd` + `res://scenes/main.tscn`（S4 运行时）· `res://test/rules_core_test.gd`（14 用例）· `res://test/adapter_contract_test.gd`（15 用例）
> **Lifecycle 衔接:** R13 实现授权生效；Gate 2 最小核心已通过（`QA_GATE2_VERDICT_v0_1.md` pass）。本 verdict = **Gate 2 扩展独立复核（29 用例）+ 垂直切片前段（Gate 3 前段）独立观察**，**不是** Gate 3 视觉/UX 全量验收、不是 Gate 4 性能、不是 Gate 5/6 导出/发布。本 verdict 由 Independent QA **独立出具**；实现者本地测试/运行时证据仅作参考输入，本验收基于本会话独立复现的输出判定，不沿用其自评。

---

## 0. 专家能力加载与实际工具顺序（真实记录，独立性铁律）

### 0.1 专家能力加载

- **首选实测:** 本会话**实际调用 `skill({ name: "godot-qa-release-expert" })` 成功**，运行时返回完整 SKILL 指令内容。按 DSH 实测纪律（2026-08-16），不得仅凭函数清单判 `skill`/`tools.skill` 不存在；本会话 `skill` 接口**发起调用实测成功**，未发生 unknown tool / 接口不存在错误。
- **能力证据等级:** `strong_direct_skill` / `strong_member_skill`（首选等级）——`skill({ name: "godot-qa-release-expert" })` 直接调用成功，返回完整 SKILL；另并行加载 `gdunit-driver`、`godot-cli-validation`、`gdmcp`、`godot-native-e2e` 四个配套 Skill，全部实际调用返回完整指令。
- **应用证据:** 本验收按 `godot-qa-release-expert` 的专业方法执行——proof types distinct（`runtime` 独立观察 vs `static` 推理）、逐步独立重跑核计、failure-is-information、independence boundary（不沿用实现者 29/29 与 self-test 自评、不豁免 QA、不替实现者修复代码）、evidence contract（精确命令/环境/fixtures/输出；诚实边界；不虚报运行/观察结果）。

### 0.2 实际工具顺序（真实记录）

| # | 工具/动作 | 结果 |
|---|---|---|
| 1 | 首发 `pwsh` 试调 `tools.skill`（非运行时包装器） | ⚠️ PowerShell 无法访问 DSH `tools` 包装器（执行主机语言错误）。**判定：不构成 skill 接口不可用证据**（按 DSH 实测纪律，仅运行时明确报 unknown tool 才算不可用；这是错误的主机调用方式，非接口缺失） |
| 2 | `skill({ name: "godot-qa-release-expert" })` | ✅ **实测成功**（返回完整 SKILL 指令；未报 unknown tool）。`strong_direct_skill` |
| 3 | 并行 `skill("gdunit-driver")` / `skill("godot-cli-validation")` / `skill("gdmcp")` | ✅ 全部实测成功（完整返回） |
| 4 | `skill("godot-native-e2e")`（随后加载） | ✅ 实测成功 |
| 5 | 并行 pwsh 验证 Godot exe 存在 + glob 文档清单 | ✅ exe 存在；`docs/production/*.md` 清单成功 |
| 6 | read 判据/背景：`QA_ACCEPTANCE_PLAN` / `QA_GATE2_VERDICT` / `NEXT_IMPL_UNIT_PLAN` / `ENEMY_LIFETIME_LEDGER` / `READ_MODEL_MINIMAL_FIELDS` / `SEMANTICS_INVALIDATION_FINAL` / `IMPL_VERTICAL_SLICE` | ✅ 全部成功 |
| 7 | read 验收对象源码：`rules_core.gd`(236) / `adapter.gd`(139) / `runtime/main.gd`(285) / `rules_core_test.gd`(325, 14 用例) / `adapter_contract_test.gd`(148, 15 用例) | ✅ 全读（静态核对零容差/语义） |
| 8 | `pwsh` Godot `--version` + `gdmcp --json doctor` | ✅ exe=`4.7.1.stable.official.a13da4feb`；doctor `editor_connected:true` / `godot_version:4.7.1-stable (official)` / `runtime_running:false` |
| 9 | **独立重跑 #1（headless Godot + gdUnit4 全量）** | ✅ exit 0；`Overall Summary: 29 test cases | 0 errors | 0 failures | ... PASSED`（adapter 15 + rules 14） |
| 10 | **独立重跑 #2（确定性复现）** | ✅ exit 0；同 29/29 PASSED（15+14）；XML `tests=29 failures=0 skipped=0 flaky=0` |
| 11 | read 两次 XML 报告 + SHA-256 比对 + 逐 testcase | ✅ 两套 testsuites 均 `adapter tests=15 failures=0` / `rules tests=14 failures=0`，0 failure 节点、0 error/description 节点；raw digests 仅因 per-test wall-clock timing 不同（`time=0.005` vs `time=0.004`），正确 non-deterministic，不在比较面 |
| 12 | grep 两个测试文件零容差核对 | ✅ 105 处断言全部 `is_equal/is_empty/is_true/is_false`（精确值/相等），无 `is_equal_approx`/`assert_float`/epsilon/tolerance/is_greater-less |
| 13 | **独立 S4 self-test 重跑 #1** | ✅ exit 0；`[AUTO-ATTACK] locked id=1` → `[HIT]` → `[KILL]` → `[CLEAR]` → `[RUNTIME] live enemies=0` → `[SELF-TEST] kill_outcomes=[1,2]` → `[SELF-TEST-CLEAR]` 完整闭环 |
| 14 | **独立 S4 self-test 重跑 #2 + 错误扫描** | ✅ exit 0，输出逐位一致；无 SCRIPT ERROR/ERROR/WARNING |
| 15 | GDMCP runtime smoke（`gdmcp.runtime_smoke.v1` 链）：`run_project` → `runtime info`/`tree`/`screenshot`/`debug logs` | ✅ run success/probe_ready/session_active；tree 显示 player+Line2D+HUD 三 Label（enemies 已杀净）；screenshot 1152x648；logs 仅 Info |
| 16 | vision OCR + describe 读截图 | ✅ HUD `LIFE [o][o][o] TIMER pre-8min B2 pre-fission` + `no target (quiet)` + `attack: resolved`；cyan 玩家方块居中；enemies 已清除；无攻击线（quiet 后态）；非色彩可读 |
| 17 | `stop_project` → doctor → runtime info | ✅ stop success/mode:editor；doctor runtime_running=false；runtime `no_active_sessions`（预期成功态） |
| 18 | 清理临时 args 文件 | ✅ `run_args.json` / `stop_args.json` 已删除 |

> 本任务**未调用** `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发（独立性铁律，禁止嵌套派发）。
> **接口实测结论:** `skill` 接口确实可用且调用成功；`tools.skill`（PowerShell 内）非可用接口属主机命令错误，非运行时接口缺失，未伪报「接口不存在」；能力证据等级 = `strong_direct_skill`。

---

## 1. Expert preflight（独立验收前置，按 godot-qa-release-expert §Expert preflight）

- **验收范围:** ① **Gate 2 扩展独立复核**——对 29 用例（14 rules 含 KILL-* 7 新用例 + 既有 7；15 adapter 契约）按 `QA_ACCEPTANCE_PLAN_v0_1.md` §2.2/§3.4 判据独立观察；② **垂直切片前段（Gate 3 前段）可观察性观察**——S4 运行时 self-test 闭环日志 + GDMCP runtime smoke 观测 player/enemy/HUD。
- **Changed risks（验收需防）:** ① KILL-* 排序/失效时序依赖容器顺序或浮点抖动 → G1 破坏；② kill 路径误触碰已批准失效语义 (ii)（死/失效目标产生幽灵/重复命中）→ S2/G4 破坏；③ fixture/schema 静默不兼容或 mandatory 缺失仍被判定 → 假 pass（违反 B3）；④ adapter 泄漏规则语义（自选目标/判命中/排序）→ 违反 ADR-TECH-01 seam。
- **所需证明类型:** Gate 2 扩展判定只由 `runtime` 类证据支撑（真实 runner 输出 + XML 权威报告 + 静态语义核对）；S4 前段可观察性由 `runtime` 类证据（self-test 日志 + GDMCP runtime/screenshot/vision 观察）支撑。static 阅读仅作辅助推理，不构成通过证据（self-test 日志、screenshot 均真实由本会话独立运行产出）。
- **环境/目标:** headless Godot 4.7.1-stable (a13da4feb) + gdUnit4 6.2.x（`--ignoreHeadlessMode`）；固定 seed/tick；纯规则 seam + adapter（均 extends RefCounted，engine-free）；运行时 scene 经 GDMCP `run_project` 观察。`runtime_running` 初始 false → 运行自测 → self-test quit(0) → 停 runtime，editor 保持 editor mode。
- **独立性边界:** 独立 QA 独立观察与独立 verdict；不沿用实现者本地 29/29 与 self-test 自评；不豁免 QA blocker；不批准/冻结合同/ADR/fixture schema；不替实现者修复代码（发现缺陷仅报告）。
- **Top three failure hypotheses（本次是否被防住）:**
  1. 容器顺序/浮点依赖 → 由 `test_target_container_order_independent`（双插入序逐位 `[1,9,3,5]`）+ `test_target_float_epsilon_same_seed_consistency`（同 seed 双 run 一致）+ `test_target_order_unchanged_by_enemy_lifetime_fields`（hp 字段不影响排序）防住；本会话独立重跑 #1/#2 29/29 逐位一致证实。排序路径无 RNG、只比较整数桶（by-construction）。
  2. 死/失效目标幽灵命中 → 由 `test_kill_death_removal_no_ghost_hit`（死目标从后续 refresh 消失，无 ghost hit）+ `test_kill_removed_target_produces_no_hit_and_no_kill`（removed_ids drain 点 → `no-hit-invalid`，无 kill）+ `test_target_removal_no_hit_and_invalidation_event`（invalidation (ii)）防住；self-test 日志 `[KILL]→[CLEAR]→live enemies=0` 证实引擎侧移除。
  3. schema/mandatory 静默吞缺 → 见 §6 观察项 O4：本 seam 交付未产出外层 fixture-schema envelope 记录（evidence_id/digest/build_identity/Producer index），延续 Gate 2 O3，如实声明为后续 evidence-harness 层完成项，不属本 seam 断言面缺失。
- **停止条件:** 独立重跑（Gate2 ≥2 次 + self-test ≥2 次）+ 逐项判据核对 + GDMCP runtime smoke + 唯一 verdict 文件写入即停止；不进入下一阶段、不派发/扩展任何成员。

---

## 2. Gate 2 扩展逐项验收结论（对照 QA_ACCEPTANCE_PLAN §2.2）

| §2.2 判据 | 判定 | 证据（独立观察 + 静态核对） |
|---|---|---|
| **用例覆盖完成**（29 = 15 adapter + 14 rules；14 rules = 既有 7 target/session + 7 KILL-*/compat；15 adapter = input mapping/envelope/feedback/no-leakage） | **PASS** | 独立重跑 #1：`Run Test Suite res://test/adapter_contract_test.gd` → `Statistics: 15 test cases | 0 errors | 0 failures | PASSED`；`Run Test Suite res://test/rules_core_test.gd` → `Statistics: 14 test cases | 0 errors | 0 failures | PASSED`；`Overall Summary: 29 test cases | 0 errors | 0 failures | 0 flaky | 0 skipped | 0 orphans`。两文件均在 `res://test/` 被发现并执行。XML 两套 testsuites 计数一致 |
| **排序确定性**（同 seed/tick → ordered_ids/target_snapshot_ids 逐位一致·跨 run·跨容器插入序·hp 无关） | **PASS** | 独立重跑 #1/#2 均 29/29 逐位一致（XML `tests=29 failures=0 skipped=0 flaky=0`）；`test_target_container_order_independent` 断言两种插入序 ordered_ids 逐位 `[1,9,3,5]`；`test_target_float_epsilon_same_seed_consistency` 断言两个同 seed run ordered_candidates 一致；`test_target_order_unchanged_by_enemy_lifetime_fields` 断言加/不加 `hp` 字段排序一致；raw XML 差异仅 per-test wall-clock timing（非比较面）。rules_core comparator `_key_less` 只比较整数桶 k1/k2/stable_id（全局唯一 ⇒ 全序，与容器顺序无关），`ordered_candidates` 对不可变副本排序。排序路径无 RNG（确定性 by-construction，比「seed 复现」更强） |
| **失效语义 (ii)**（锁定后移除 → 无命中；invalidation_event 带 tick；快照 ID 集不变；死亡=移除=失效） | **PASS** | `test_target_removal_no_hit_and_invalidation_event`：锁定 `[1,2]` → resolve removed_ids=[2] → drain 点 `invalidation_event(2,12)`；`hit_results.has(2)` false（无伪造命中）；`resolution_outcomes.get(2)="no-hit-invalid"`；`target_snapshot_ids==[1,2]` 不变。`test_kill_removed_target_produces_no_hit_and_no_kill`：removed_ids=[1] + attack_damage=1 → 无 hit、无 kill、`no-hit-invalid`、无 kill_event。均与 `SEMANTICS_INVALIDATION_FINAL_v0_1.md` 终裁 (ii) 逐条一致 |
| **KILL-single 一击死亡**（hp=1, 单击攻击伤害→死亡, S1 §2.1/§2.2 starting_point=1） | **PASS** | `test_kill_single_hit_kills_enemy`：hp=1 候选 refresh → lock [1] → resolve attack_damage=1 → `hit_results.has(1)` true、`kill_outcomes.has(1)` true、`kill_event(1,21)` 入 events、live_candidates[0].alive=false、next refresh → `target_snapshot_ids` 空 + no_target_branch=true（死亡移除后的 quiet）。`test_kill_candidate_without_hp_defaults_to_one`：无显式 hp 字段候选默认 hp=1 → 单击仍击杀（TARGET-* 兼容）。与 S1 ledger §2.1（range[1,5]/starting_point=1、排除 0/负 HP）一致 |
| **KILL-multi 多目标**（多目标命中、多段 HP 累积扣减至死, S1 §2.1 range 候选） | **PASS** | `test_kill_multi_targets_multi_hit`：两敌人 hp=2，attack_damage=1 → shot1 双方 hp 2→1（kill_outcomes 空，`hp1==1`）→ shot2 同锁定快照 双方 hp 1→0（kill_outcomes{1,2} 均 true）。攻击伤害参数化（`attack_damage` envelope 参数，默认 1），未见硬编码规则常数；多段 HP 落在 S1 §2.1 range [1,5] 候选内，未提升为 Gate 数值（promotion=User） |
| **KILL-death-removal 无幽灵命中**（死亡→live 集移除→后续绝不命中, S1 §2.3） | **PASS** | `test_kill_death_removal_no_ghost_hit`：hp=1 + hp=5 两目标 → shot1 hp=1 死（hit+kill）/hp=5 活（hit 无 kill）；死目标 alive=false、活目标 alive=true；follower refresh（仅 live）→ lock [2]；shot2 只命中 2，`hit_results.has(1)` false、kill_outcomes{1} false。死目标从后续候选消失、绝无 ghost hit。与 S1 §2.3（移除死亡目标 + 顺序不依赖容器插入序）一致 |
| **no-target**（空集 → no_target_branch=true；不伪造目标/锁指示；next_eligible_fire_tick） | **PASS** | `test_target_no_target_branch`：空 refresh → `no_target_branch==true`、`target_snapshot_ids`/`ordered_ids` 空、`next_eligible_fire_tick==8`、`no_target_branch` event 存在、不伪造目标/锁指示。adapter `test_feedback_empty_shot_no_forgery`：no-target 空 shot feedback `no_target==true`、lock_target/hit/kill 全空。满足 §3.4 TARGET-no-target + UX-03 S1/S2 quiet 形态 |
| **trace 字段核对**（refresh_tick/lock_tick/invalidation_event/resolution_outcome/target_snapshot_ids/no_target_branch/next_eligible_fire_tick + S2 新增 kill_outcomes/kill_event） | **PASS** | 实现含全部 trace 字段；`kill_outcomes` 进入 state+diagnostics；`kill_event(id,tick)` 事件入 events；existing trace（refresh/lock/invalidation/resolution/target_snapshot/no_target/next_eligible）保持。各字段由对应测试断言（`test_target_removal...` invalidation、`test_kill_single...` kill_event、`test_target_no_target...` no_target+next_eligible）。见 §6 观察项 O5（敌我 trace 落点建议） |
| **S3 adapter 契约**（输入↔envelope 路由、step 驱动、域事件→引擎反馈绑定 hit_results、空射不伪造、不泄漏规则语义） | **PASS** | `test_input_*`（5 例：W/S/A/D/方向键/对角线/无声）映射正确确定性；`test_pick_task_*`（3 例：refresh/resolve 选择）；`test_make_envelope_carries_movement_and_candidates`；`test_feedback_lock/hit/kill_*`（lock 只在 target_snapshot_ids 非空、hit 绑定 hit_results、kill 绑定 kill_outcomes）；`test_feedback_empty_shot_no_forgery` / `test_feedback_no_hit_then_locked_only`（空射不伪造 lock/hit）；`test_adapter_candidates_feed_core_ordering`（排序由 rules core 决定、adapter 不选目标）；`test_adapters_envelope_drives_core_lock`（envelope→core→lock 端到端）。15/15 PASS |
| **比较纪律**（精确匹配·零容差默认） | **PASS** | grep 两测试文件：105 处断言全部为 `assert_* .is_equal()/.is_empty()/.is_true()/.is_false()` 精确值 API；无 `assert_float`/`is_equal_approx`/epsilon/tolerance/`is_greater`/`is_less` 容差比较。`TARGET-float-epsilon` 用 `assert_int(quantize_bucket(a)).is_equal(quantize_bucket(b))`（量化桶整型等于），非浮点近似。满足 O2/B3 默认零容差 |

---

## 3. 垂直切片前段（Gate 3 前段）独立观察结论

### 3.1 S4 运行时 self-test（独立 headless 复跑，exit 0）

命令（独立发起，不经 Engineer 脚本）：
```
<godot> --headless --path <proj> res://scenes/main.tscn -- --self-test
```

**独立 run #1 完整日志（本会话实测输出）：**
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
Exit `0`；独立 run #2 逐位一致（exit 0），无 `SCRIPT ERROR`/`ERROR`/`WARNING` 行。

**闭环核对（slice 前四动词 + quiet）:**
| 动词 | 观察行 | 判定 |
|---|---|---|
| 移动（scripted demo） | self-test 模式 `position += Vector2(0,0)`（确定性空移；非 self-test 时 `[RUNTIME] player_moved dir=...` 走 `_read_movement_input`） | 结构到位；移动本身另有 adapter input 测试覆盖（`test_input_*`） |
| 自动攻击（锁定目标） | `[AUTO-ATTACK] locked id=1`（指向被锁定近威胁敌人） | 确认 |
| 命中（绑定 hit_results） | `[HIT] target id=1` / `[HIT] target id=2` | 确认（非伪造，源=hit_results） |
| 击杀（kill_outcomes） | `[KILL] id=1 died -> remove` / `[KILL] id=2 died -> remove` | 确认 |
| 清除（queue_free → live 缩减） | `[CLEAR] enemy id=1 cleared` / `[CLEAR] enemy id=2 cleared` → `[RUNTIME] live enemies=0` | 确认 |
| quiet（无目标安静态） | `[SELF-TEST-CLEAR] enemies removed; live enemies=0` → quit(0) | 确认 |
| exit 0 | 进程退出 0 | 确认 |

**closed loop = 移动→自动攻击→命中→击杀→清除→quiet 全部可观察，exit 0。** 该日志证明 slice 完成判定（attack/kill results reducing pressure / KICKOFF §9.2-2）在真实引擎 headless 闭环。

### 3.2 GDMCP runtime smoke（`gdmcp.runtime_smoke.v1` 只读观察）

- **run_project:** `status=success` / `mode=playing` / `probe_ready=true` / `session_active=true` / `scene=res://scenes/main.tscn`。
- **runtime info:** `current_scene=/root/Main`, `node_count=9`, `process_frames=645`（推进，主循环运行）。
- **runtime tree (depth 4):** `/root/Main`（Node2D）→ ColorRect（player）、Line2D（attack line）、CanvasLayer → 三 Label（hud_label/no_target_label/state_label）。**enemies 已清除**（kill→queue_free 后仅存 player/line/HUD），与 self-test 的 clear→quiet 后态一致。
- **runtime screenshot:** 1152x648 保存 `user://gdmcp-qa-vslice-smoke.png`（`C:\Users\User\AppData\Roaming\Godot\app_userdata\godot_game_dev\gdmcp-qa-vslice-smoke.png`）。
- **vision OCR + describe:** HUD `LIFE [o][o][o] TIMER pre-8min B2 pre-fission`（S5 §4.1 life/timer/b2）、`no target (quiet)`（S5 §4.2 no_target quiet）、`attack: resolved`（S5 §4.3 attack_state）；cyan 玩家方块居中；无 enemy 矩形（已杀净）；无攻击线（quiet 后态，Attack line 指向正确隐藏）；HUD 非色彩可读（Shape/文本分区）。
- **debug logs:** 仅 Info 级工具执行记录，无 Runtime Error / Script Error / Warning。
- **stop_project:** `status=success` / `mode=editor`；doctor `runtime_running=false`；runtime `no_active_sessions`（预期成功态）。

**前段观察结论:** player 可渲染可移动、enemy node 作为 ordered_candidates 输入被自动攻击锁定并命中、击杀→引擎 enemy 物理移除（queue_free）→清除→quiet 后态在真实运行时 GDMCP 观察下成立；HUD read-model 占位字段（life/timer/b2/no-target/attack_state）在画面呈现且非色彩可读。截图仅证明捕获与画面状态，**非视觉基线/资产验收**（Gate 3 全量视觉留后续）。

---

## 4. 对照判据表（QA_ACCEPTANCE_PLAN + S1/S5 对齐）

| 判据来源 | 判据 | 独立结论 |
|---|---|---|
| QA_ACCEPTANCE_PLAN §2.2「Fixture 覆盖完成」（TARGET-*/KILL-*/container-order/float-epsilon 全执行） | 指定族全部执行 | PASS（29/29 全执行；KILL-* 7 新用例 + 既有 7 target/session 全在套件；见观察项 O1/O4） |
| QA_ACCEPTANCE_PLAN §2.2「排序确定性」（同 seed 两次 → 逐位一致） | 跨 run、跨容器插入序、hp 无关 | PASS（run1/run2 29/29；container-order/float-epsilon/enemy-lifetime 断言逐位一致） |
| QA_ACCEPTANCE_PLAN §2.2「失效语义」(ii) | 锁定后移除 → 无命中；invalidation_event 带 tick；快照 ID 集不变 | PASS（test_target_removal_no_hit... 与终裁 (ii) 逐条一致） |
| QA_ACCEPTANCE_PLAN §2.2「no-target」 | 空 refresh → no_target_branch=true；不伪造目标/锁指示 | PASS（test_target_no_target_branch + adapter no-forgery） |
| QA_ACCEPTANCE_PLAN §2.2「trace 字段核对」 | refresh/lock/invalidation/resolution/target_snapshot/no_target/next_eligible + kill 新增 | PASS（字段齐备可核对；观察项 O5） |
| QA_ACCEPTANCE_PLAN §2.2「比较纪律」（零容差默认） | 无浮点容差比较 | PASS（grep 零 approx/epsilon/tolerance；105 处精确断言） |
| S1 ledger §2.1「敌人 HP range[1,5] + starting_point=1」 | 单击击杀 | PASS（KILL-single hp=1 一击死；无破坏 KILL-* 候选语义） |
| S1 ledger §2.2「单击伤害→死亡」 | hit 扣 hp 至 ≤0 → 死亡 | PASS（KILL-single/multi 结算一致；attack_damage 参数化未锁常数） |
| S1 ledger §2.3「死亡→live 集/清理缩减」 | 死目标移除 + 绝无 ghost hit | PASS（KILL-death-removal 无幽灵命中；self-test 引擎移除 + CLEAR + live enemies=0） |
| S5 §4.1「HUD 最小面 life/timer/b2」 | life 三格 / timer / b2_phase 占位 | 前段观察 PASS（截图 OCR：`LIFE [o][o][o] TIMER pre-8min B2 pre-fission`；结构位恒在，无数值承诺） |
| S5 §4.2「no-target quiet」 | no_target_branch=true → quiet 形态不伪造 | 前段观察 PASS（`no target (quiet)` + self-test 空候选分支；adapter no_forgery） |
| S5 §4.3「attack-resolution」 | attack_state idle/resolving/resolved/no_target + feedback-binding hit_results | 前段观察 PASS（`attack: resolved` 截图；rules 驱动 attack_state 派生自 no_target/hit/snapshot） |
| UX-03 S1/S2「空射不伪造 / 反馈绑定 hit_results」 | no-target 无锁指示/无幻影命中 | PASS（adapter feedback 测试 15/15 + rules no-target） |
| 范围边界（接触/升级/B2/终结/focus 延后） | 本单元未引入这些行为 | PASS（实现与测试仅 kill 路径；无接触/B2 字段行为） |
| 候选数值不提升 | HP=1/attack_damage=1 为默认值，S1 range 候选 | PASS（实现 `hp`/`attack_damage` 均为参数/默认，未写为规则常数；promotion_authority=User 未提升） |

---

## 5. 独立 verdict（Independent QA 唯一判定）

> ### **verdict = `pass`（附非阻断观察项）**
>
> **Gate 2 扩展**：29 用例（14 rules 含 KILL-* 7 新用例 + S3 adapter 契约 15）在真实引擎独立重跑（2 次，exit 0，29/29 逐位一致）全部满足——排序确定性、失效语义 (ii)、KILL-single/kill-multi/kill-death-removal、no-target、trace 字段、S3 adapter 契约（input↔envelope/feedback-binding/no-forgery/no-leakage）、零容差断言全部验证通过；实现与 S1 敌我生命周期 ledger（HP=1 单击击杀/死亡移除）及失效语义终裁 (ii) 一致。
>
> **垂直切片前段（Gate 3 前段）**：S4 运行时 self-test 独立复跑 exit 0，`[AUTO-ATTACK] locked → [HIT] → [KILL] → [CLEAR] → [RUNTIME] live enemies=0 → [SELF-TEST-CLEAR]` 闭环完整可观察；GDMCP runtime smoke 观察 player/enemy/HUD 渲染、击杀→引擎移除→清除→quiet 后态、HUD read-model 占位字段（LIFE/TIMER/B2/no-target/attack_state）从画面呈现且非色彩可读。
>
> **未发现阻断性（P0/P1）缺陷**；未豁免任何 QA 门；未批准/冻结任何合同/ADR/fixture schema；观察项 O4/O5 为非阻断建议，延续并精化 Gate 2 的 O1/O2/O3。**本 verdict 仅覆盖 Gate 2 扩展 + 垂直切片前段观察，不代表 Gate 3-6 全量验收。**

**verdict 依据（逐项证据，独立核计）：**
- **runtime 证据（Gate2）：** 独立 headless gdUnit4 重跑 #1/#2 均 exit 0，`29 test cases | 0 errors | 0 failures | 0 flaky | 0 skipped | 0 orphans | PASSED`；XML（run1=`qa-vslice-run1`/run2=`qa-vslice-run2`）均 `tests=29 failures=0 skipped=0 flaky=0`、每 testsuite（adapter=15/rules=14）无 failure 子节点、0 error/description 节点。同 seed + 同输入 + 同 build/engine（4.7.1.a13da4feb）逐位一致（仅 test wall-clock timing 非确定，不在比较面）。
- **runtime 证据（前段）：** 独立 S4 self-test 两次 exit 0，完整闭环日志逐位一致；GDMCP run_project/tree/screenshot(1152x648)/vision OCR+describe 观察 HUD 与 clear→quiet 后态；stop 干净。
- **static 核对：** rules_core 排序只比较整数桶、对不可变副本排序、drain 点 (ii) 排空、解析只读锁定快照；adapter extends RefCounted 纯翻译（不选目标/不判命中/不排序）；feedback 严格 gate（lock/hit/kill 只在规则源非空 emit）；全部断言精确值（零容差）；S1/S5 字段对齐。

---

## 6. 观察项（非阻断 · 如实记录，供后续精化）

> 以下为独立观察到的**边界/完整性建议，均不构成 Gate 2 扩展或前段观察阻断**，如实上报供后续评审与 evidence-harness 层完成时参考。

- **O4 — 容器方差变体仍集中（延续 Gate 2 O1 的扩展面）：** Gate 2 观察项 O1 指出容器方差变体集中 `TARGET-container-order` 族。本扩展中，`TARGET-container-order` + `test_target_order_unchanged_by_enemy_lifetime_fields`（双 hp 形态）继续覆盖容器/字段顺序不变量；但新 KILL-* 7 用例未各自单独携带双容器插入序变体。由于 comparator 全序（整数桶 + 唯一 stable_id）与不可变副本排序，架构上不依赖容器顺序，该属性已由既有族证明。**判定：不阻断；建议后续 fixture 精化时补 KILL-* 逐族方差变体或修订判据表述（Systems/Tech/QA 共裁，本验收不代决）。**
- **O5 — kill 决策键 / kill 落点的独立 trace 元组（延续 Gate 2 O2 的扩展面）：** tie-break 键（k1/k2/stable_id）作为候选字段存在并被断言决序；S2 新增 `kill_event(id,tick)` 已以独立事件入 trace + `kill_outcomes` 入 state/diagnostics。但 `step` 返回的 `diagnostics` 未将每候选的键桶显式导出为独立只读元组（trace 可核对性目前依赖候选记录 + 断言 + events）。**判定：不阻断；决策键桶/live 缩减计数如需在 diagnostics 层直接可读，可作为后续 enhancement。**
- **O6 — 外层 fixture-schema envelope 仍未落盘（延续 Gate 2 O3）：** QA_ACCEPTANCE_PLAN §4.1 mandatory 字段清单（evidence_id/fixture_schema_version/config_version/source_identity/build_identity/seed/run_id/tick_context/scenario_id/snapshot+expected+actual digest/observer/timestamp+clock_authority/verdict/unresolved_deviations/retest_of/supersedes/raw log 引用）描述 Gate 2 fixture 记录（外层证据 envelope 层）。本 seam 交付为该原则级确定性语义 + 测试套件，未独立产出该 envelope 记录文件——属 ADR-TECH-06/§3.2 证据封装 + Producer index 链路的后续工程，**非本 seam 断言面缺失**，不导致 `not_run`。本验收 artifact 本身记录了身份/seed/run/snapshot（含 raw 引用），但正式 evidence index/留存契约仍为后续完成项（对齐 READ_MODEL §7 / QA_ACCEPTANCE_PLAN §7）。

---

## 7. 已执行/未执行边界 + 诚实证据边界（明确声明）

- **已执行（本波 Gate 2 扩展 + 垂直切片前段独立验收）:**
  - Gate2 确定性：独立 headless Godot 4.7.1 + gdUnit4 重跑 `res://test/`（adapter+rules）**两次**（exit 0，29/29 逐位一致），XML 权威报告双确认，零容差 assertion grep 核对。
  - 前段：独立 S4 self-test `res://scenes/main.tscn -- --self-test` **两次**（exit 0，闭环日志逐位一致，无 error/warning）；GDMCP runtime smoke（`gdmcp.runtime_smoke.v1` 链：run/info/tree/screenshot/logs/stop）观察 player/enemy/HUD + read-model 字段；vision OCR+describe 核对 HUD 与画面。
  - 判据：逐项对照 QA_ACCEPTANCE_PLAN §2.2 + S1/S5 对齐（§4）。
- **未执行（非本 Gate、如实排除）:** 本验收**非** Gate 3 视觉/UX 全量验收（未做视觉基线/资产/UX 判据全量；仅前段可观察性观察）、**非** Gate 4 性能、**非** Gate 5 导出、**非** Gate 6 发布。未做任何视觉基线/资产/性能/导出/发布/产品裁决。证据边界：截图仅证明捕获与画面状态，非视觉 QA 验收；self-test/runtime 仅在本地环境观察，不代表用户最终验收或其它导出目标。
- **未修改任何代码/构件:** 本验收为**只读 + 只运行**。未创建/编辑/删除/覆盖任何 `.gd`/`.tscn`/`.tres`/`project.godot`/addon/配置等 Godot 构件；未改动测试文件；未调用 GDMCP 写入/编辑器脚本写入/Godot CLI 写入；GDMCP 仅执行 `doctor`/`editor state`/`run_project`/`runtime info`/`tree`/`screenshot`/`debug logs`/`stop_project`（只读观察）；临时 args 文件位于项目外并已清理。唯一写入产物 = **本 verdict 文件 `QA_VERTICAL_SLICE_VERDICT_v0_1.md`**。
- **未修复缺陷:** 观察项 O4/O5/O6 均如实报告为**建议/边界**，不由本 QA 修复（独立 QA 不替实现者修复代码；修复/精化归对应 owner 后续任务）。
- **未豁免任何 QA / 未批准冻结任何合同/ADR/fixture schema / 未替用户做产品或验收裁决:** ADR-TECH-06/§3.2 证据封装、S1 候选 HP 提升、fixture envelope 落地等保持各自状态；候选数值（含量化 scale、no-target 周期、性能候选、`1280×720` 红线）**全部保持仅候选，未提升**；promotion_authority=User。
- **未派发/扩展任何成员:** 未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

---

## 8. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；cr-001 Option A (R09)；ADR-TECH-01..06 批准 (R11)；UX-03 S1–S3；AUTH-01 (R13 实现授权)。本 verdict 不重写、不重分类任何一项。
- **`team_proposal`（本验收实质贡献）:** Independent QA 对 Gate 2 扩展 + 垂直切片前段的 **`pass` verdict**、观察项 O4/O5/O6、逐项判据表、证据边界声明。全部为独立 QA 判断，供父协调器/用户作为 Gate 2 扩展 + 前段观察输入；不代 Systems/Tech/UX/User 裁决。
- **`assumption`（本样本内已由独立观察验证）:** 确定性排序在本引擎（4.7.1 stable）+ 纯规则 seam + 固定 tick 下可复现（两次独立 run 实证）；kill 语义与 S1 ledger（HP=1/单击击杀/死亡移除）一致且在已批准 ADR 内落地（fixture + self-test 实证）；adapter 纯翻译不泄漏规则语义（契约测试实证）；死亡移除→clear→quiet 后态可观察（self-test + runtime smoke 实证）。
- **`unresolved`（全量保留，未关闭）:** cluster membership；metric/quantization 精确数值与单位；tie-break 可读性；stable-ID 生命周期细节；invalidation drain 实现细节；no-target cycle 精确周期与提示形态；敌人 HP 多段精确值/是否引入（S1 range[1,5] 候选）；spawn 节奏；走廊恢复可读反馈形态（归 UX）；`fixture_schema_version` 具体值；raw 留存/索引冻结；hint 文案/触发；KILL-* 精确 fixture envelope——**均保持 unresolved**（本验收不升级、不闭合任何 unresolved 项；失效语义 (ii) 已由 `SEMANTICS_INVALIDATION_FINAL_v0_1.md` 终裁，本验收确认实现与终裁一致，不重新开口）。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 — 本 verdict 未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项性能候选 + `1280×720` 红线）未被动用/提升。

---

## 9. exact sections / files

- **独立验收对象（只读，未改）:** `res://rules/rules_core.gd`（236 行）、`res://adapter/adapter.gd`（139 行）、`res://runtime/main.gd`（285 行）、`res://scenes/main.tscn`、`res://test/rules_core_test.gd`（325 行，14 测试方法）、`res://test/adapter_contract_test.gd`（148 行，15 测试方法）。`res://rules/session.gd` 未变。
- **唯一写入产物:** `docs/production/QA_VERTICAL_SLICE_VERDICT_v0_1.md`（本文件）。
- **证据源（未改，只读）:** `QA_ACCEPTANCE_PLAN_v0_1.md`（判据）、`QA_GATE2_VERDICT_v0_1.md`（基线 pass）、`SEMANTICS_INVALIDATION_FINAL_v0_1.md`（终裁 (ii)）、`ENEMY_LIFETIME_LEDGER_v0_1.md`（S1 kill 语义）、`READ_MODEL_MINIMAL_FIELDS_v0_1.md`（S5 字段）、`NEXT_IMPL_UNIT_PLAN_v0_1.md`（A+ 排程）、`IMPL_VERTICAL_SLICE_v0_1.md`（实现说明，参考非证据）、`IMPL_MINIMAL_CORE_v0_1.md`（Gate 2 基线背景，已按任务允许读取核对 env）。
- **运行产物（独立生成，位于项目外，未污染项目树）:**
  - XML `%APPDATA%\Godot\app_userdata\godot_game_dev\qa-vslice-run1\report_1\results.xml`（tests=29 failures=0）
  - XML `%APPDATA%\Godot\app_userdata\godot_game_dev\qa-vslice-run2\report_1\results.xml`（tests=29 failures=0）
  - GDMCP screenshot `%APPDATA%\Godot\app_userdata\godot_game_dev\gdmcp-qa-vslice-smoke.png`（1152x648）
  - S4 self-test 输出（stdout，两次逐位一致，exit 0）
- **未修改任何其它文档/构件；临时 args 文件已清理。**

---

## 10. 边界声明与 Closure

- **Gate 2 扩展独立验收已执行:** verdict = **`pass`**（29 用例 = 14 rules 含 KILL-* + 15 adapter，独立重跑 2 次逐位一致；六项判据维度 + kernel S2/S3 契约全部满足）。**垂直切片前段（Gate 3 前段）独立观察已执行:** self-test exit 0 闭环 + runtime smoke 观测成立（观察类 PASS）。
- **本 verdict 范围边界:** 仅 Gate 2 扩展确定性验收 + 垂直切片前段（Gate 3 前段）可观察性观察。**非** Gate 3 视觉/UX 全量验收、**非** Gate 4 性能、**非**  Gate 5 导出、**非** Gate 6 发布；无相应全量证据，如实声明（§7）。
- **未做:** 未改代码/构件；未修复观察项；未豁免 QA；未批准/冻结合同/ADR/fixture schema；未替用户做产品/验收裁决；未派发/扩展任何成员；候选数值全部保持仅候选。
- **独立复核声明:** 本 verdict 由 Independent QA 独立出具，基于本验收独立执行的两次 Gate2 重跑 + self-test 两次 + GDMCP runtime smoke + 逐项判据核对，**不沿用**实现者 `IMPL_VERTICAL_SLICE_v0_1.md` 的本地 29/29 与 self-test 自评判定（其命令形态可参考，但本验收独立发起命令、独立读取输出、独立判定）。

**Closure:** `closure_ready = yes`（限本独立验收报告 artifact）。本文件的 `pass` 仅指 **Gate 2 扩展 + 垂直切片前段（Gate 3 前段）独立验收通过**；不构成实现授权之外的任何放行、不是合同/ADR 批准、不是产品裁决、不豁免 Gate 3-6 全量。完成后停止，不进入下一阶段、不派发任何成员。

---

## 11. 版本与变更记录

- **v0.1（本文件）:** Independent QA / Release Lead 唯一新产物——Gate 2 扩展 + 垂直切片前段独立验收裁定书。独立重跑 `res://test/`（29 用例 = 15 adapter + 14 rules）2 次（exit 0，29/29 逐位一致），六项判据 + KILL-*/adapter 契约全部满足，失效语义与终裁 (ii) 一致、kill 语义与 S1 ledger 一致；独立 S4 self-test 2 次 exit 0 闭环日志 + GDMCP runtime smoke（HUD read-model 字段非色彩可读、clear→quiet 后态）；零容差断言 grep 确认；独立 verdict = **`pass`**，附非阻断观察项 O4/O5/O6（KILL-* 逐族方差变体、kill 决策键 trace 落点、外层 fixture envelope 未落盘——延续 Gate 2 O1/O2/O3 的扩展与精化，均不阻断）。未修改任何 Godot 构件/文档；未派发任何成员。
