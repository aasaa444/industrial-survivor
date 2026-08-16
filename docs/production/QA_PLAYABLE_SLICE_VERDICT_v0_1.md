# QA PLAYABLE SLICE VERDICT v0.1 — Gate 2 扩展独立验收（R1/R3）+ Gate 3 前段独立观察（R1 真实输入 / R2 read-model 全字段）

> **Status:** `INDEPENDENT QA VERDICT — COMPLETED / PASS（附非阻断观察项）`
> **Role:** Independent QA / Release Lead（独立验收负责人 · `godot-qa-release-expert`）
> **Artifact owner (sole author):** Independent QA / Release Lead
> **Report ID:** `QA_PLAYABLE_SLICE_VERDICT_v0_1`
> **Date:** 2026-08-17（独立验收执行）
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **验收对象（被验收声明，仅参考 + 复跑指引，不当作证据）:** `IMPL_PLAYABLE_SLICE_v0_1.md`（R1 真实输入驱动移动 + R2 read-model 全字段落地 + R3 O4/O5 精化）
> **Lifecycle 衔接:** R13 实现授权生效；上一单元 QA pass（`QA_VERTICAL_SLICE_VERDICT_v0_1.md`，29 用例）；本单元 = 推荐方案 A（`NEXT_IMPL_UNIT_PLAN_v0_2.md`，AUTH-01 非升级 D1 自动推进）。本 verdict = **Gate 2 扩展独立复核（37 用例 = 19 rules [含 R3 O4 三变体 + O5 二用例] + 18 adapter [含 R1 三用例]）** + **Gate 3 前段独立观察（R1 真实输入驱动移动因果 + R2 read-model 全字段呈现）**。**不是** Gate 3-6 全量。本 verdict 由 Independent QA **独立出具**；实现者本地 37/37 + self-test + runtime smoke 证据仅作参考，本验收基于本会话**独立复跑/独立注入/独立观察**的输出判定，**不沿用其自评**。

---

## 0. 专家能力加载与实际工具顺序（真实记录，独立性铁律）

### 0.1 专家能力加载（DSH 实测纪律 2026-08-16：不得仅凭函数清单判断接口不存在，必须实际发起调用验证）

| Skill | 调用方式 | 结果 | 等级 |
|---|---|---|---|
| `godot-qa-release-expert` | `skill({name:"..."})` | ✅ **实测成功**（返回完整 SKILL 指令；未报 unknown tool） | `strong_member_skill`（首选） |
| `gdunit-driver` | `skill({name:"..."})` | ✅ 实测成功 | `strong_member_skill` |
| `godot-cli-validation` | `skill({name:"..."})` | ✅ 实测成功 | `strong_member_skill` |
| `godot-native-e2e` | `skill({name:"..."})` | ✅ 实测成功 | `strong_member_skill` |
| `gdmcp` | `skill({name:"..."})` | ✅ 实测成功 | `strong_member_skill` |
| `godot-native-visual-qa` | `skill({name:"..."})` | ✅ 实测成功 | `strong_member_skill` |

> `tools.skill` 包装器在本运行时不独立存在；直接 `skill(...)` 实测调用成功且返回完整指令，未发生 unknown tool / 接口不存在错误。**未伪报「接口不存在」**；能力证据等级 = `strong_member_skill`（首选）。

### 0.2 实际工具顺序（真实记录）

| # | 工具/动作 | 结果 |
|---|---|---|
| 1 | `skill("godot-qa-release-expert")` | ✅ 实测成功（`strong_member_skill`） |
| 2 | 并行 `skill("gdunit-driver")` / `skill("godot-cli-validation")` / `skill("godot-native-e2e")` / `skill("gdmcp")` | ✅ 全部实测成功 |
| 3 | `skill("godot-native-visual-qa")` | ✅ 实测成功 |
| 4 | pwsh 验证 Godot 4.7.1 console exe（`D:\Game\Godot_v4.7.1-stable_win64\...console.exe`）`--version` = `4.7.1.stable.official.a13da4feb`；项目路径存在 | ✅ exe 存在 + version 确认 |
| 5 | `gdmcp --json doctor` | ✅ `editor_connected:true` / `godot_version:4.7.1-stable (official)` / `plugin_version:1.0.7` / `runtime_running:false` / 项目路径正确 |
| 6 | read 判据/背景：`QA_ACCEPTANCE_PLAN` / `QA_VERTICAL_SLICE_VERDICT`（上一单元含 O4/O5/O6 定义）/ `NEXT_IMPL_UNIT_PLAN_v0_2`（A 方案 R1/R2/R3 + §8）/ `IMPL_PLAYABLE_SLICE`（被验收对象声明）/ `READ_MODEL_IMPLEMENTATION_LIST`（UX R2 落地清单 §4/§5 + E1–E10）/ `READ_MODEL_MINIMAL_FIELDS`（S5）/ `ENEMY_LIFETIME_LEDGER`（S1 kill）/ `SEMANTICS_INVALIDATION_FINAL`（终裁 (ii)）/ `UX_OBSERVATION_TARGETS`（U2-B/C、U3）/ `KICKOFF_UX_UI_CONTRACTS`（UX-02/09/13）/ `KICKOFF_TECH_ADR_CONTRACTS`（ADR-TECH-01/02/04/06） | ✅ 全读（静态判据核对）；grep 定位 ADR-TECH-01/02 read-model、UX-09/UX-13 |
| 7 | 读验收对象源码：`test/rules_core_test.gd`(494, 19 测试) / `test/adapter_contract_test.gd`(230, 18 测试) / `rules/rules_core.gd`(287) / `runtime/main.gd`(408) | ✅ 全读（独立静态核验零容差/语义/呈现绑定） |
| 8 | grep 两个测试文件零容差断言核对 | ✅ 无 `is_equal_approx` / `assert_float` / `epsilon` / `tolerance` / `is_greater` / `is_less` / `is_between` 实际使用（仅 fixture 名/注释含 "float-epsilon"，其断言用 `quantize_bucket` 整型相等） |
| 9 | grep 测试方法计数 + git 状态 | ✅ adapter `func test_`=18 / rules =19 / 总计 37；git HEAD = `194618d`（本单元 R1+R2+R3 commit）；工作树仅两份未跟踪 docs（Producer/UX 产物）；Godot 构件干净已提交 |
| 10 | **独立 headless gdUnit4 重跑 #1**（`--add res://test/ --ignoreHeadlessMode --report-directory user://qa-playable-run1`） | ✅ `Overall Summary: 37 test cases | 0 errors | 0 failures | 0 flaky | 0 skipped | 0 orphans | Exit code: 0`；`Statistics: 19 test cases ... PASSED`（rules）+ `18 test cases ... PASSED`（adapter） |
| 11 | **独立 headless gdUnit4 重跑 #2（确定性复现）**（`user://qa-playable-run2`） | ✅ 同 `37 test cases | 0 errors | 0 failures | Exit code: 0`（18 adapter + 19 rules） |
| 12 | XML 报告核对（run1/run2 均 `user://qa-playable-run{1,2}/report_1/results.xml`） | ✅ 两套 testsuites 均 `adapter tests=18 failures=0` / `rules tests=19 failures=0`；0 failure 子节点、0 error/description 节点；testcase 身份集合逐位一致（37）；testcase 总数一致；raw XML 字节 4951 相同 |
| 13 | **独立 headless self-test 重跑 #1/#2**（`res://scenes/main.tscn -- --self-test`） | ✅ 两次均 exit 0；输出**逐位一致**；含 `[SELF-TEST] restricted deterministic regression (scripted zero-move + scripted fire; NOT player-playable input evidence)` 首位标注 + `[LOCK-REFRESH]` / `[FB-BIND]` / `[READ-MODEL]`(resolving→resolved→no_target 四态/kill/feedback) / `[NO-TARGET-CUE]`；无 SCRIPT ERROR/ERROR/WARNING |
| 14 | GDMCP 源码核验 O5 + R1 + R2（`rules_core.gd` / `main.gd`） | ✅ 静态核验：O5 diagnostics 只读导出（`candidate_key_trace`/`kill_decision_trace`/`live_reduction_count`，additive）；R1 `_read_movement_input` 单一正式输入路径（W/A/S/D + 箭头 → adapter envelope → 位移）；R2 `_present_read_model` 全字段呈现只消费 rules trace（ADR-TECH-01），attack_state 四态/ kill_state / feedback-binding / invalidation 节 / no-target quiet / hint 未实现 |
| 15 | **GDMCP runtime smoke + R1 真实输入注入**（`run_project` → 基线 → 注入 D 键 → 观察位移 → 释放 → 注入 W 键 → 观察位移 → 释放） | ✅ 见 §3.1：D 键（keycode 68）→ 玩家 position 从 (320,360) 向右连续位移 +`[RUNTIME] player_moved dir=1,0`；W 键（keycode 87）→ 向上位移 `player_moved dir=0,-1`。**真实键盘 key 注入 → player 位移因果独立观察成功** |
| 16 | GDMCP runtime screenshot ×2 + vision OCR + vision_describe | ✅ `qa-playable-ux09-player-visible.jpg`（1152x648）OCR 读到 HUD 全字段（LIFE/TIMER/B2/attack/kill/feedback/no-target）；vision_describe 确认 player 方块位于 (320-344,360-384) 未被左上 HUD 遮挡（UX-09）、HUD 文本/shape 非色彩可读（UX-13） |
| 17 | `stop_project` → doctor → runtime info | ✅ stop success / mode:editor；doctor `runtime_running:false`；editor_connected:true（干净停止） |
| 18 | 临时观测产物（XML 报告 ×2 + 截图 ×2）保留在 `user://`（Godot app 数据，项目外）作为不可变独立证据 | ✅ 未污染项目树 |

> 本任务**未调用** `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发（独立性铁律，禁止嵌套派发）。
> **接口实测结论:** `skill` 接口实测成功、返回完整指令；`tools.skill`（本运行时无独立包装器）以直接 `skill(...)` 调用成功。能力证据等级 = `strong_member_skill`。

---

## 1. Expert preflight（独立验收前置，按 godot-qa-release-expert §Expert preflight）

- **验收范围:** ① **Gate 2 扩展独立复跑**——37 用例（19 rules 含 R3 O4 三变体 + O5 二用例；18 adapter 含 R1 三用例）按 `QA_ACCEPTANCE_PLAN_v0_1.md` §2.2 / `NEXT_IMPL_UNIT_PLAN_v0_2` §8 判据独立观察（确定性、O4 方差变体逐位一致、O5 trace 元组导出、R1 输入→移动→锁定重定位因果契约）；② **Gate 3 前段独立观察**——R1 真实输入驱动移动（input 注入 → player 位移 → next-refresh 锁定重定位因果，对齐 ADR-TECH-04 / UX-02 U2-B/C）+ R2 read-model 全字段呈现（HUD 最小面 life/timer/b2、no-target quiet、attack_state 四态、feedback-binding marker、kill_state、invalidation 节、非色彩可读 UX-13、HUD 不遮挡 UX-09、hint 排除）。
- **Changed risks（本 scope 验收需防）:** ① R1 真实输入是否真正驱动移动（是否仍为脚本化空移 → 非玩家可玩）——已由 GDMCP input 注入独立观察；② R3 O4 容器方差变体是否逐位一致 / O5 trace 元组是否只读导出（确定性）——已由 19 rules 独立复跑 + 源码核验；③ R2 read-model 呈现是否只消费 rules trace（ADR-TECH-01，不成为第二规则权威）、空射不伪造（ADR-TECH-02/UX-03 S1/S2）——已由源码 + self-test + 截图观察；④ fixture/schema 静默不兼容或 mandatory 缺失仍被判定（违反 B3）→ 见观察项 O7。
- **所需证明类型:** Gate 2 扩展判定只由 `runtime` 类证据支撑（真实 runner 输出 + XML 权威报告 + 静态语义核验）；Gate 3 前段 R1 由 `runtime` 类证据（GDMCP input 注入位移 + 日志 + 源码）+ 确定性契约测试（R1 × 3）支撑；R2 由 `runtime` 类证据（runtime frame 截图 + OCR + vision_describe + self-test 日志 + 源码）支撑。static 阅读仅作辅助推理，不构成通过证据。
- **环境/目标:** headless Godot 4.7.1-stable (a13da4feb) + gdUnit4（`--ignoreHeadlessMode`）；固定 seed 2026 / 固定 tick；纯规则 seam + adapter（RefCounted，engine-free）；运行时 scene 经 GDMCP `run_project` 观察 + `mcp__godot__*` runtime 注入。
- **独立性边界:** 独立 QA 独立观察与独立 verdict；不沿用实现者本地 37/37 与 self-test 自评；不豁免 QA blocker；不批准/冻结任何合同/ADR/fixture schema/数值/表现形态；不替实现者修复代码。
- **Top three failure hypotheses（本次是否被防住）:**
  1. R1 真实输入未驱动移动（仍是脚本化空移）→ **被防住**：GDMCP 注入 D/W 键后玩家 position 连续位移 + `[RUNTIME] player_moved dir=1,0 / dir=0,-1`（非 self-test 模式走 `_read_movement_input` + `position += dir*speed*delta`）。
  2. O4/O5 破坏确定性或非只读 → **被防住**：独立重跑 #1/#2 逐位一致（19 rules 全绿），O5 diagnostics 源码只读追加（不改 state/events），既有 14 rules + 15 adapter 测试全绿证明语义未变。
  3. R2 呈现成为第二规则权威 / 空射伪造命中 → **被防住**：`_present_read_model` 只从 rules trace 字段读取呈现（不自我推断规则）；`_apply_feedback` 消费 adapter gated 反馈（lock/hit/kill 只在其规则源非空 emit）；空候选 → `_enter_quiet_presentation` 安静形态无锁/无幻影命中。
- **停止条件:** 独立复跑（Gate2 ×2 + self-test ×2 + runtime 注入观察）+ 逐项判据核对 + 唯一 verdict 文件写入即停；不进入 Gate 3-6 全量、不派发任何成员。

---

## 2. Gate 2 扩展逐项独立验收结论（对照 QA_ACCEPTANCE_PLAN §2.2 + NEXT_IMPL_UNIT_PLAN §8）

| 判据维度 | 规则/判据 | 独立结论 | 证据（独立观察 + 静态核验） |
|---|---|---|---|
| **用例覆盖完成**（37 = 19 rules [含 R3 O4 三变体 + O5 二用例] + 18 adapter [含 R1 三用例]） | 全部套件发现并执行 | **PASS** | 独立 grep 测试方法：`rules_core_test.gd` = 19（14 既有 target/session/kill + `test_kill_single_container_order_variant` / `test_kill_multi_container_order_variant` / `test_kill_death_removal_container_order_variant` [O4 × 3] + `test_diagnostics_kill_decision_trace_exported` / `test_diagnostics_candidate_key_trace_and_no_kill_resolve` [O5 × 2]）；`adapter_contract_test.gd` = 18（15 既有 + `test_movement_intent_does_not_change_rules_semantics` / `test_movement_causality_next_refresh_relocks` [U2-B] / `test_same_geometry_same_lock_across_runs` [U2-C] [R1 × 3]）。独立重跑 #1/#2 均 `Statistics: 19 test cases ... PASSED`（rules）+ `Statistics: 18 test cases ... PASSED`（adapter）+ `Overall Summary: 37 | 0 errors | 0 failures | Exit code: 0` |
| **排序确定性 / O4 方差变体逐位一致**（同 seed/输入 → ordered_ids/target_snapshot_ids 逐位一致 · 跨 run · 跨容器插入序） | KILL-* 逐族双容器插入序变体逐位一致 | **PASS** | 独立重跑 #1/#2 均 19/19 rules 全绿（含 `test_kill_single/multi/death_removal_container_order_variant` 双插入序逐位一致）；`test_key_trace`（`_key_less` 只比较整数桶 k1/k2/stable_id 全局唯一 → 全序，与容器顺序无关），`ordered_candidates` 对不可变副本排序；XML 身份集合逐位一致 + 0 failure。排序路径无 RNG（确定性 by-construction），O4 三变体证实 KILL 族排序/击杀容器无关 |
| **O5 trace 元组导出**（kill 决策键 k1/k2/stable_id 独立只读导出，additive，不改 state/events） | diagnostics 只读导出 + 不污染语义 | **PASS** | 源码 `rules_core.gd` L132-161/214/280-283：`candidate_key_trace`（M-1 键链序 [{stable_id,k1,k2}]）、`kill_decision_trace`（被杀 [{stable_id,k1_bucket,k2_bucket,tick}]）、`live_reduction_count`（本次活体缩减），全部落在 `diagnostics` 只读，`step` 返回 fresh state（clone-on-write）不改 prior；测试 `test_diagnostics_kill_decision_trace_exported`（断言 trace size=2 / k2 决序 id2→id1 / tick=101 / live_reduction=2 / state kill_outcomes 保持）+ `test_diagnostics_candidate_key_trace_and_no_kill_resolve`（no-kill resolve → kill trace 空 + live_reduction=0）全绿；既有 14 rules + 15 adapter 全绿证明语义未变 |
| **失效语义 (ii)**（锁定后移除 → 无命中；invalidation_event 带 tick；快照 ID 集不变） | 移除即失效 → no hit；与终裁 (ii) 一致 | **PASS** | `test_target_removal_no_hit_and_invalidation_event`：锁定 [1,2] → resolve removed_ids=[2] → `invalidation_event(2,12)` 入 events + `hit_results.has(2)` false + `resolution_outcomes.get(2)="no-hit-invalid"` + snapshot `[1,2]` 不变（与 `SEMANTICS_INVALIDATION_FINAL_v0_1.md` 终裁 (ii) 逐条一致）。`test_kill_removed_target_produces_no_hit_and_no_kill`：removed_ids=[1] + hp=3 → 无 hit/无 kill/`no-hit-invalid`。独立重跑全绿。源码 L190-195 命名 drain 点 + L243-251 只读快照解析 |
| **KILL 语义**（S1 ledger: HP range[1,5]/starting_point=1、单击击杀、死亡→live 集清理缩减） | 单击击杀 / 死亡移除 / 无幽灵命中 | **PASS** | `test_kill_single_hit_kills_enemy`（hp=1 单击死 + kill_event(1,21) + livie `alive=false` + next refresh → no-target）、`test_kill_candidate_without_hp_defaults_to_one`（无显式 hp 候选默认 1）、`test_kill_multi_targets_multi_hit`（hp=2 双目标两 hit 至死）、`test_kill_death_removal_no_ghost_hit`（死目标从 live 消失、follower refresh 只锁活目标、shot2 无 ghost hit）、`test_target_order_unchanged_by_enemy_lifetime_fields`（hp 字段不影响排序）、`test_session_kill_cycle_then_reset_clean`。与 `ENEMY_LIFETIME_LEDGER` S1 §2.1/§2.2/§2.3 一致；`attack_damage`/`hp` 均为参数/默认，非规则常数（promotion=User 未提升） |
| **no-target / 空射不伪造**（空 refresh → no_target_branch=true；不伪造目标/锁指示/命中；next_eligible_fire_tick） | 空射 quiet，无 phantom hit | **PASS** | `test_target_no_target_branch`（空集 → no_target_branch=true + snapshot 空 + next_eligible_fire_tick=8 + 无伪造）；adapter `test_feedback_empty_shot_no_forgery`（no_target=true + lock/hit/kill 全空）+ `test_feedback_lock_only_when_target_locked` / `test_feedback_hit_bound_to_hit_results` / `test_feedback_no_hit_then_locked_only`（反馈类绑定命中集）。与 UX-03 S1/S2 / ADR-TECH-02 R4 一致 |
| **R1 输入→移动→锁定重定位因果契约**（intent-only / U2-B 下一 refresh 重锁 / U2-C 同几何同锁） | 移动改变 NEXT shot 锁定序、CURRENT shot 快照不可变 | **PASS** | `test_movement_intent_does_not_change_rules_semantics`（移动意图不改变规则语义/排序）；`test_movement_causality_next_refresh_relocks`（U2-B：P0 锁 [2,1] → 移动后 resolve 仍读锁 [2,1] 不可变 → NEXT refresh P1 锁序翻转为 [1,2]，首锁目标 id2→id1）；`test_same_geometry_same_lock_across_runs`（U2-C：同几何跨 run 锁逐位一致）。独立重跑全绿。对齐 ADR-TECH-04「移动 → 下一次自动攻击因果可读」+ UX-02 U2-B/C |
| **delegate/envelope 契约不泄漏**（adapter 不选目标/不判命中/不排序；envelope 携带移动意图） | adapter 纯翻译 | **PASS** | `test_adapter_candidates_feed_core_ordering`（排序归 rules core）、`test_adapters_envelope_drives_core_lock`（envelope→core→lock 端到端）、`test_make_envelope_carries_movement_and_candidates`（envelope 携带 movement + candidates + attack_damage）、`test_pick_task_*`（refresh/resolve 选择）。18/18 adapter 全绿 |
| **比较纪律（零容差默认，O2/B3）** | 无近似比较 | **PASS** | grep 两测试文件：无 `is_equal_approx` / `assert_float` / `epsilon` / `tolerance` / `is_greater` / `is_less` / `is_between` 实际使用；`TARGET-float-epsilon` 用 `quantize_bucket` 整型相等（`assert_int(quantize_bucket(a)).is_equal(quantize_bucket(b))`），非浮点近似。满足 O2/B3 默认零容差 |
| **确定性复现（同 seed 两次 → 逐位一致）** | 跨 run 一致 | **PASS** | 独立重跑 #1/#2 均 exit 0 / 37/37；XML 身份集合逐位一致、0 failure/error；raw XML 字节 4951 相同（per-test wall-clock timing 非比较面） |

**Gate 2 扩展独立结论：37/37 全绿（2 次独立重跑逐位一致），六项判据维度 + R1 移动因果契约 + R3 O4/O5 全部满足。**

---

## 3. Gate 3 前段独立观察结论

### 3.1 R1 真实输入驱动移动（重点）——真实输入观察协议与执行

**观察协议（本独立 QA 制定并执行）：** 采用 **GDMCP/mcp runtime 输入注入** 路线——在非 self-test 模式启动 `res://scenes/main.tscn`（真实 `_read_movement_input` 路径激活），经 `mcp__godot__simulate_runtime_input_event` 注入真实 **key 事件**（keycode 按下/释放），观察玩家 position 位移 + 运行时 `[RUNTIME] player_moved` 日志，验证「真实键盘键 → player 位移」因果。该路线为纯 GDMCP 只读 runtime 观察，**未修改任何 Godot 构件**；self-test 明确标注为确定性回归、非玩家可玩证据。

**独立执行结果：**
- 基线：玩家 position `(320, 360)`（start）。
- 注入 **D 键**（keycode 68，pressed=true）→ 等待数帧 → 玩家 position 由 `(320,360)` 向右连续位移至 `(987.8, 360)`（+X）；运行时日志 `[RUNTIME] player_moved dir=1,0 player=(986..990,360)`。
- 释放 D → 注入 **W 键**（keycode 87，pressed=true）→ 玩家向上位移（y 负向），日志 `[RUNTIME] player_moved dir=0,-1 player=(1874,-974..-978)`。
- 释放 W。

**观察结论（R1 真实输入 → player 位移因果）：** **验证成立**。真实键盘 key 注入（非脚本化空移）经 `_read_movement_input`（`Input.is_key_pressed`）→ `ADAPTER.movement_from_input` → `position += dir * move_speed * delta` 驱动玩家位移（D=+X, W=-Y 两独立方向），运行时独立观察确认。self-test 模式保留脚本化空移并显式标注 `NOT player-playable input evidence`（独立运行自 self-test 日志首行确认标注存在）。

**移动 → 自动攻击锁定重定位因果（ADR-TECH-04 / UX-02 U2-B）：** 该因果在 **rules/adapter 确定性层**由独立 R1 契约测试证实（`test_movement_causality_next_refresh_relocks`：下一 refresh 锁序翻转 [2,1]→[1,2]、本 shot 快照不可变）；在运行时由 `[LOCK-REFRESH] player=... lock=[1,2] (movement re-locks NEXT refresh; current shot snapshot immutable)` 日志证实。**局限（诚实声明）:** 本会话注入时占位敌人已被自动攻击清除（无 live 候选可重锁），故未在本注入会话逐帧捕获「移动后锁集物理翻转」的可见重定位；该因果由确定性 R1 测试 + `[LOCK-REFRESH]` 日志 + 源码（移动后重读候选 → 下一 refresh 重锁）三面覆盖。**「玩家完整键盘演示全程可玩性」未完全独立验收——真实输入观察为受限 key 注入，非真人键盘自由操作演示**（见 §7 诚实边界）。

### 3.2 R2 read-model 全字段呈现观察

**runtime frame 独立观察（GDMCP run_project → 截图 → vision OCR + vision_describe）：**

| S5/UX 字段 | 独立 OCR/vision 证据 | 判定 |
|---|---|---|
| `life`（三格 segments_lost=0） | 截图 OCR `LIFE [o][o][o] segments_lost=0` | 呈现非色彩（文本/形状） |
| `timer`（current_tick + run_bound opaque） | OCR `TIMER tick=9592 run_bound=8min(opaque)` | 呈现 |
| `b2_phase`（前-B2 结构位） | OCR `B2 pre-fission (structure placeholder)`（OCR 读作 pre-session，结构占位） | 结构位呈现 |
| `attack_state` 四态 | OCR `attack: no_target (quiet)`（no_target 分支态）+ self-test 日志 resolving→resolved→no_target 序列 | 四态由 rules trace 派生可读 |
| `kill_state`（none→killed） | OCR `kill: killed(2)`（kill_outcomes 非空时）+ `kill: none` 基线 | 仅 kill_outcomes 非空置位 |
| `no_target_branch` quiet | OCR `no target (quiet)` + `feedback: - (quiet)` + self-test `[NO-TARGET-CUE]` 一次性克制 cue | 无锁/无幻影命中 |
| `feedback-binding marker` | HUD `feedback: lock=2 hit=2 kill=2 (bound: target_snapshot_ids/hit_results/kill_outcomes)` + self-test `[FB-BIND]` 逐类绑定 + quiet 空态 `feedback: -` | 反馈类绑定规则源 |
| `invalidation` presentation 节 | self-test/源码：`invalidation: id=N tick=N (no hit this shot)`（presentation 可见节，无内部 drain 细节）；rules `test_target_removal...` 事件断言 | 失效呈现为「无命中」 |
| `hint`（排除项 E1） | **未出现任何 hint 字段/文案**（源码 main.gd 头注释 L35） | **排除核对通过** |

**UX-09（HUD 不遮挡）:** vision_describe 独立确认玩家方块位于画面 (320-344, 360-384)（中心 (0.29, 0.57)），**未**与左上 HUD 标签（x16-250, y18-155）重叠；中央可玩区无遮挡。**PASS（前段观察）**。

**UX-13（非色彩可读）:** vision_describe 确认 HUD 全部状态以**文字字符/形状**传达（LIFE/TIMER/B2/attack/kill/feedback 及数值），**无任何状态仅以色彩传达**；玩家以方块形状呈现（cyan 仅装饰非唯一通道）。self-test 日志亦为文本结构信号。**PASS（前段观察）**。

**no_target_cue 精确种类未冻结（E2/E3）:** `[NO-TARGET-CUE]` 为一次性克制非色彩 cue，仅绑定 no-target 分支，未冻结精确种类/文案/布局（源码 `_enter_quiet_presentation` L253-263 注释声明「exact presentation form NOT frozen (unresolved)」）。**排除核对通过**（cue 种类未升格为批准形态）。

**R2 前段观察结论：** read-model 全字段（HUD 最小面 life/timer/b2 + no-target quiet + attack_state 四态 + feedback-binding marker + kill_state + invalidation 节）在真实 runtime frame 呈现且非色彩可读、HUD 不遮挡 player；hint 未落地；no_target_cue 种类未冻结。**呈现类 PASS（前段观察）**。

---

## 4. 对照判据表（QA_ACCEPTANCE_PLAN / NEXT_IMPL_UNIT_PLAN §8 / READ_MODEL_IMPLEMENTATION_LIST / ADR / S1/S5 对齐）

| 判据来源 | 判据 | 独立结论 |
|---|---|---|
| `QA_ACCEPTANCE_PLAN` §2.2「Fixture 覆盖完成」 | 37 = 19 rules（O4 三变体 + O5 二用例）+ 18 adapter（R1 三用例）全执行 | **PASS**（独立 grep 计数 19+18=37；独立重跑 #1/#2 全绿） |
| `QA_ACCEPTANCE_PLAN` §2.2「排序确定性」（O4 逐族容器方差变体） | 同 seed/输入/插入序 → 逐位一致 | **PASS**（两个独立 run 逐位一致；O4 三变体双插入序一致；XML 0 failure） |
| `QA_ACCEPTANCE_PLAN` §2.2「失效语义 (ii)」 | 锁定后移除 → 无命中；invalidation_event 带 tick；快照 ID 集不变 | **PASS**（`test_target_removal...` 与终裁 (ii) 逐条一致） |
| `QA_ACCEPTANCE_PLAN` §2.2「no-target」 | 空 refresh → no_target_branch=true；不伪造锁/命中 | **PASS**（rules no_target + adapter no-forgery） |
| `QA_ACCEPTANCE_PLAN` §2.2「trace 字段核对」（O5 决策键元组） | kill 决策键 k1/k2/stable_id 只读导出，additive | **PASS**（`kill_decision_trace`/`candidate_key_trace`/`live_reduction_count` 源码只读 + 测试全绿；additive 不改语义） |
| `QA_ACCEPTANCE_PLAN` §2.2「比较纪律」 | 零容差默认 | **PASS**（grep 无 approx/epsilon/tolerance 实际使用） |
| `NEXT_IMPL_UNIT_PLAN` §8「R1 真实输入驱动移动」 | 真实输入 → player 位移 → 锁定重定位因果（ADR-TECH-04 / UX-02 U2-B/C） | **PASS（前段）**——GDMCP key 注入 D/W → 位移因果独立观察；move→NEXT refresh 重锁因果由 R1 测试 + `[LOCK-REFRESH]` 日志覆盖；真人键盘全演示未做（边界声明 §7） |
| `NEXT_IMPL_UNIT_PLAN` §8「R2 read-model 全字段呈现」 | HUD 最小面 + no-target quiet + attack_state 四态 + feedback-binding + kill_state + invalidation 节 | **前段观察 PASS**（runtime frame OCR + vision + self-test 全字段呈现非色彩可读） |
| `NEXT_IMPL_UNIT_PLAN` §8「self-test 保留为确定性回归」 | 标注非玩家可玩证据 | **PASS**（self-test 日志首行显式 `NOT player-playable input evidence`） |
| `READ_MODEL_IMPLEMENTATION_LIST` §4（UX 清单） | S5 字段 → 呈现绑定（life/timer/b2/no-target/attack_state/feedback-binding/kill_state/invalidation 节） | **PASS（对齐）**（实现 `_present_read_model` 与 UX 清单 §4 逐条对应：§4.1/§4.2/§4.3/§4.4/§4.5/§4.6 全落地） |
| `READ_MODEL_IMPLEMENTATION_LIST` §5（E1–E10 排除） | hint(E1)/cue 种类(E2)/文案(E3)/布局(E4)/资产(E5)/数值(E6)/性能(E7)/内部分级(E8)/B2(E9)/升 Gate(E10) | **核对通过**（hint 未实现；cue 种类未冻结；占位表现；无数值提升；内部分级 key 不进 presentation；B2 仅结构位） |
| ADR-TECH-01（presentation 只消费 read-model） | 呈现不成为第二规则权威 | **PASS**（`_present_read_model` 只从 rules trace 读取；`_apply_feedback` 消费 adapter gated 反馈） |
| ADR-TECH-02（空射不伪造 / read-model） | empty shot 不伪造 lock/hit/kill | **PASS**（adapter gate + `_enter_quiet_presentation` + `feedback: - (quiet)`） |
| ADR-TECH-04（移动→下一次自动攻击因果可读 / 目标快照不可变） | 移动改变 NEXT shot 锁、CURRENT shot 不可变 | **PASS**（R1 测试 U2-B + `[LOCK-REFRESH]` 日志 + 源码） |
| UX-02 U2-B/C | 移动改变/不改变簇构成 → 锁定变化/不变可归因 | **PASS**（`test_movement_causality_next_refresh_relocks` U2-B + `test_same_geometry_same_lock_across_runs` U2-C） |
| UX-09（HUD 不遮挡 player/danger/space） | HUD 不覆盖可玩区 | **PASS（前段）**（vision_describe：player 方块未被左上 HUD 覆盖） |
| UX-13（非色彩可读） | 状态非色彩可读 | **PASS（前段）**（vision_describe：HUD 全文本/shape，无仅色彩状态） |
| S1 ledger（HP range[1,5]/starting_point=1） | 单击击杀 / 死亡移除 | **PASS**（KILL-* 与 S1 §2.1/§2.2/§2.3 一致；数值候选未提升） |
| 范围边界（接触/升级/B2/终结/focus/hint/cue 冻结延后） | 本单元未引入 | **PASS**（源码只读；hint/cue/B2 保持结构/排除） |
| 候选数值不提升 | HP/attack_damage/move_speed 为参数，未写死 | **PASS**（`attack_damage`/`hp`/`move_speed`/`attack_interval` 均参数/占位；promotion=User 未提升） |

---

## 5. 独立 verdict（Independent QA 唯一判定）

> ### **verdict = `pass`（附非阻断观察项）**
>
> **Gate 2 扩展**：37 用例（19 rules 含 R3 O4 三变体 + O5 二用例；18 adapter 含 R1 三用例）在真实引擎独立重跑 2 次（exit 0，37/37 逐位一致）全部满足——确定性命中 + O4 方差变体逐位一致 + O5 trace 元组只读导出 + KILL 语义（S1 ledger）+ 失效语义 (ii) + no-target/空射不伪造 + R1 输入→移动→锁定重定位因果契约（intent-only / U2-B / U2-C）全部验证通过，零容差断言纪律核对通过。
>
> **Gate 3 前段**：R1 真实输入驱动移动独立观察**成立**——GDMCP key 注入 D/W 键 → 玩家 position 连续位移 + `[RUNTIME] player_moved dir=1,0 / dir=0,-1`（真实键盘键 → player 位移因果）；移动→NEXT refresh 锁定重定位因果由 R1 测试 + `[LOCK-REFRESH]` 日志覆盖；self-test 保留为受限确定性回归并显式标注非玩家可玩证据。R2 read-model 全字段呈现独立观察**成立**——runtime frame 截图 + vision OCR/describe 确认 HUD 全字段（life/timer/b2/no-target/attack_state 四态/feedback-binding marker/kill_state/invalidation 节）非色彩可读（UX-13）、HUD 不遮挡 player（UX-09）、hint 未落地（排除）、no_target_cue 种类未冻结。
>
> **未发现阻断性（P0/P1）缺陷**；未豁免任何 QA 门；未批准/冻结任何合同/ADR/fixture schema/数值/表现形态；观察项 O7 为非阻断（外层 fixture-schema envelope 未落盘，延续上一单元 O6）。**本 verdict 仅覆盖 Gate 2 扩展 + Gate 3 前段观察，不代表 Gate 3-6 全量验收。**

**verdict 依据（逐项证据，独立核计）：**
- **runtime 证据（Gate2）：** 独立 headless gdUnit4 重跑 #1/#2 均 exit 0，`37 test cases | 0 errors | 0 failures | 0 flaky | 0 skipped | 0 orphans | Exit code: 0`；XML 两套 testsuites（rules=19 / adapter=18）均 `failures=0`，testcase 身份逐位一致，0 failure/error。同 seed/tick + 同 build（4.7.1.a13da4feb）逐位一致。
- **runtime 证据（前段 R1）：** GDMCP 真实 key 注入（D→+X, W→−Y）→ 玩家 position 位移 + `[RUNTIME] player_moved` 日志；`[LOCK-REFRESH]` 证明下一次 refresh 从移动后位置重锁。
- **runtime 证据（前段 R2）：** runtime frame 截图（1152x648）+ vision OCR（HUD 全字段文本）+ vision_describe（UX-09 不遮挡 / UX-13 非色彩）+ self-test 日志（attack_state/kill_state/feedback-binding/no-target quiet/cue）。
- **static 核验：** `_read_movement_input` 单一正式输入路径；`_present_read_model` 只消费 rules trace（ADR-TECH-01）；adapter gate（lock/hit/kill 只在其规则源非空 emit）；O5 diagnostics 只读导出；hint 未实现；全部断言精确值（零容差）。

---

## 6. 观察项（非阻断 · 如实记录，供后续精化）

> 以下为独立观察到的**边界/完整性建议，均不构成 Gate 2 扩展或 Gate 3 前段观察阻断**，如实上报供后续评审与 evidence-harness 层完成时参考。

- **O7 — 外层 fixture-schema envelope 仍未落盘（延续 Gate 2 O3 / 上一单元 O6）：** `QA_ACCEPTANCE_PLAN` §4.1 mandatory 字段清单（evidence_id / fixture_schema_version / config_version / source_identity / build_identity / seed / run_id / tick_context / scenario_id / snapshot+expected+actual digest / observer / timestamp+clock_authority / verdict / unresolved_deviations / retest_of / supersedes / raw log 引用）描述外层 fixture 记录（证据 envelope 层）。本 seam 交付为该原则级确定性语义 + 测试套件（headless 37/37 + 源码语义），未独立产出该 envelope 记录文件——属 ADR-TECH-06 证据封装 + Producer index 链路的后续工程，**非本 seam 断言面缺失**，不导致 `not_run`。本验收 artifact 记录了身份/seed/run/snapshot/report 引用，但正式 evidence index/留存契约仍为后续完成项。
- **O8 — R1 真人键盘自由操作演示未执行（诚实边界）：** 本会话以**受限 key 注入**（D/W 两键方向）独立验证「真实键盘键 → player 位移」因果成立，但**未执行真人键盘自由操作 demo**（无自动演示工具、非 self-test）。R1「input→移动」因果确定且 runtime 独立观察；「移动→NEXT refresh 锁定重定位」由确定性 R1 测试 + `[LOCK-REFRESH]` 日志覆盖。**「完整玩家可玩性」未完全独立验收**——如需玩家可玩最终确认，需真人键盘演示或进一步注入覆盖多方向/连续移动（如实声明）。
- **O9 — 运行时 `[LOCK-REFRESH]` 在敌人清除后无 live 候选可重锁：** 本注入会话中占位敌人已被自动攻击清除（两者 hp=1）→ 移动后无 live 候选重新锁定，故未在本会话逐帧捕获「移动改变锁集」的可见重定位帧。该因果由确定性 R1 契约测试（U2-B 锁序翻转）+ 源码 + `[LOCK-REFRESH]` 日志（此前 self-test 有 live 候选时）覆盖。若需 runtime 逐帧重定位证据，需有敌人存活场景 + 连续输入（后续输入观察可补）。

> 以上 O7/O8/O9 均为**如实边界/建议**，不构成 Gate 2 扩展或 Gate 3 前段阻断。真实输入观察协议本身的可行性已被证实（key 注入可行），O8 仅就「真人自由演示」范围如实排除。

---

## 7. 已执行/未执行边界 + 诚实证据边界（明确声明）

**已执行（本单元 Gate 2 扩展 + Gate 3 前段独立验收）：**
- Gate2 确定性：独立 headless Godot 4.7.1 + gdUnit4 重跑 `res://test/`（adapter+rules）**两次**（exit 0，37/37 逐位一致），XML 权威报告双确认，零容差 assertion grep 核对，测试方法计数（37 = 19 + 18）。
- 前段：独立 S4 self-test `res://scenes/main.tscn -- --self-test` **两次**（exit 0，逐位一致，含 R2 呈现日志，无 error/warning）；GDMCP runtime smoke + `mcp__godot__*` runtime **真实 key 注入**（D/W → 玩家位移 + `[RUNTIME] player_moved`）+ runtime frame 截图 + vision OCR/describe（HUD 全字段 / UX-09 / UX-13）。
- 判据：逐项对照 QA_ACCEPTANCE_PLAN §2.2 + NEXT_IMPL_UNIT_PLAN §8 + READ_MODEL_IMPLEMENTATION_LIST §4/§5 + ADR-TECH-01/02/04 + S1/S5（§4）。

**未执行（非本 Gate，如实排除）：** 本验收**非** Gate 3 视觉/UX 全量验收（未做视觉基线/资产/UX 判据全量；仅前段可观察性观察与 UX-09/13 前段核对）、**非** Gate 4 性能、**非** Gate 5 导出、**非** Gate 6 发布。未做任何性能测量 / 视觉基线 / 导出 / 发布 / 产品裁决。**R1 真人键盘自由操作演示未执行**（受限 key 注入验证了 input→movement 因果，但完整玩家可玩性未全量独立验收，如实声明）。`1280×720` 红线仅候选、未测量。

**未修改任何代码/构件：** 本验收为**只读 + 只运行 + 唯一 verdict 文件写入**。未创建/编辑/删除/覆盖任何 `.gd`/`.tscn`/`.tres`/`project.godot`/addon/配置等 Godot 构件；未改动测试文件；未调用 GDMCP 写入/编辑器脚本写入；GDMCP 仅执行 `doctor`/`editor state`/`run_project`/`runtime info`/`runtime tree`/`screenshot`/`debug output`/`stop_project` 及 runtime 关键键注入（只读观察 + 输入注入，非项目写入）；临时观测产物（XML ×2 + 截图 ×2）位于 `user://`（Godot app 数据，项目外）。

**未修复缺陷：** 观察项 O7/O8/O9 均如实报告为**建议/边界**，不由本 QA 修复（独立 QA 不替实现者修复代码/不补实现）。

**未豁免任何 QA / 未批准冻结任何合同/ADR/fixture schema/数值/表现形态 / 未替用户做产品或验收裁决：** ADR-TECH-06 证据封装、S1 候选 HP 提升、fixture envelope 落地、no_target_cue 精确种类、hint 等保持各自状态；候选数值（含量化 scale、no-target 周期、性能候选、`1280×720` 红线）**全部保持仅候选，未提升**；promotion_authority=User。**本 unit 不授予任何 Gate 3+ 免除。**

**未派发/扩展任何成员：** 未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

---

## 8. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；cr-001 Option A (R09)；ADR-TECH-01..06 批准 (R11)；UX-03 S1–S3；AUTH-01 (R13 实现授权)；垂直切片 QA verdict `pass`。本 verdict 不重写、不重分类任何一项。
- **`team_proposal`（本验收实质贡献）:** Independent QA 对 Gate 2 扩展 + Gate 3 前段的 **`pass` verdict**、观察项 O7/O8/O9、逐项判据表、真实输入观察协议及结果、证据边界声明。全部为独立 QA 判断，供父协调器/用户作为本单元 Gate 2 扩展 + 前段观察输入；不代 Systems/Tech/UX/User 裁决。
- **`assumption`（本样本内已由独立观察验证）:** 确定性排序在本引擎 + 纯规则 seam + 固定 tick 下可复现（两次独立 run 实证）；R1 真实键盘 key 注入可通过 GDMCP/mcp runtime 实现并可驱动玩家位移（本会话实证）；O4/O5 未破坏既有 29 用例语义（独立重跑全绿实证）；R2 呈现只消费 rules trace 且空射不伪造（源码 + self-test + 截图实证）。
- **`unresolved`（全量保留，未关闭）:** cluster membership；metric/quantization 精确数值与单位；tie-break 可读性；stable-ID 生命周期细节；invalidation drain 实现细节；no-target cycle 精确周期与提示形态（含 nocue 精确表现种类）；life 数值语义（Systems contact 单元）；timer 精确时长与 tick 频率；B2 三弧；hint 文案/触发/effective-movement；失效反馈精确形态；布局/文案/色值/阈值；`fixture_schema_version` 具体值；raw 留存/索引冻结；O6/O7 外层 fixture envelope；**R1 真人键盘自由操作演示**——均保持 open（本验收不升级、不闭合任何 unresolved 项）。失效语义 (ii) 已由 `SEMANTICS_INVALIDATION_FINAL_v0_1.md` 终裁，本验收确认实现与终裁一致，不重新开口。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本 verdict 未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项性能候选 + `1280×720` 红线）未被动用/提升。

---

## 9. exact sections / files

- **验收对象（只读，未改）:** `res://rules/rules_core.gd`（287 行，含 R3 O5 diagnostics）、`res://runtime/main.gd`（408 行，R1 输入路径 + R2 呈现）、`res://test/rules_core_test.gd`（494 行，19 测试）、`res://test/adapter_contract_test.gd`（230 行，18 测试）。`res://adapter/adapter.gd`、`res://rules/session.gd`、`res://scenes/main.tscn` 未变。
- **唯一写入产物（本任务）:** `docs/production/QA_PLAYABLE_SLICE_VERDICT_v0_1.md`（本文件）。
- **证据源（未改，只读）:** `QA_ACCEPTANCE_PLAN_v0_1.md`（判据）、`QA_VERTICAL_SLICE_VERDICT_v0_1.md`（上一单元 pass + O4/O5/O6）、`NEXT_IMPL_UNIT_PLAN_v0_2.md`（A 方案 + §8）、`IMPL_PLAYABLE_SLICE_v0_1.md`（被验收对象，参考非证据）、`READ_MODEL_IMPLEMENTATION_LIST_v0_1.md`（UX R2 清单 §4/§5）、`READ_MODEL_MINIMAL_FIELDS_v0_1.md`（S5）、《ENEMY_LIFETIME_LEDGER_v0_1.md》（S1）、《SEMANTICS_INVALIDATION_FINAL_v0_1.md`（终裁 (ii)）、`UX_OBSERVATION_TARGETS_CR001_v0_1.md`（U2-B/C/U3）、`KICKOFF_UX_UI_CONTRACTS_v0_1.md`（UX-02/09/13）、`KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（ADR-TECH-01/02/04/06）。
- **运行产物（独立生成，位于项目外，未污染项目树）:**
  - XML `%APPDATA%\Godot\app_userdata\godot_game_dev\qa-playable-run1\report_1\results.xml`（tess=37 failures=0）
  - XML `%APPDATA%\Godot\app_userdata\godot_game_dev\qa-playable-run2\report_1\results.xml`（tess=37 failures=0）
  - GDMCP screenshot `%APPDATA%\Godot\app_userdata\godot_game_dev\qa-playable-ux09-player-visible.jpg` / `qa-playable-vslice-hud-full.jpg`（1152x648）
  - self-test 输出（stdout ×2 逐位一致，exit 0）
- **R1 真实输入观测 artifact：** GDMCP/mcp runtime key 注入（D/W）日志 + player position 查询序列（本会话 stdout，独立记录）。
- **未修改任何其它文档/构件；临时观测产物均在 `user://`（项目外）。**

---

## 10. 边界声明与 Closure

- **Gate 2 扩展独立验收已执行:** verdict = **`pass`**（37 用例 = 19 rules + 18 adapter，独立重跑 2 次 exit 0 逐位一致；O4/O5/R1 契约 + 六项判据全部满足）。**Gate 3 前段独立观察已执行:**（a）R1 真实输入 key 注入 → player 位移因果独立观察成立;（b）R2 read-model 全字段呈现（HUD + 四态 + feedback-binding + kill_state + invalidation 节 + non-color + no-occlusion）观察 PASS（前段）。self-test 保留为确定性回归、明确非玩家可玩证据。
- **本 verdict 范围边界:** 仅 Gate 2 扩展确定性验收 + Gate 3 前段（R1 真实输入 + R2 read-model 呈现）独立观察。**非** Gate 3 视觉/UX 全量验收（未做视觉基线/资产）、**非** Gate 4 性能、**非** Gate 5 导出、**非** Gate 6 发布；无相应全量证据，如实声明（§7）。
- **诚实边界（明确）：** R1 真实输入观察为**受限 key 注入**（D/W 两方向），验证「真实键盘键 → player 位移 + NEXT-refresh 重锁因果源」成立；**真人键盘自由操作全程可玩性未完全独立验收**——如需玩家可玩最终确认，需真人键盘演示或扩展输入覆盖。性能预算未涉及；`1280×720` 红线仅候选。
- **未做:** 未改任何代码/构件；未修复观察项；未豁免 QA；未批准/冻结任何合同/ADR/fixture schema/数值/表现形态；未替用户做产品/验收裁决；未派发/扩展任何成员；候选数值全部保持仅候选。
- **独立复核声明:** 本 verdict 由 Independent QA 独立出具，基于本验收独立执行的两次 Gate2 重跑 + self-test 两次 + GDMCP runtime 真实输入注入 + runtime frame 视觉观察 + 逐项判据核对，**不沿用**实现者 `IMPL_PLAYABLE_SLICE_v0_1.md` 的本地 37/37 与 self-test/runtime smoke 自评判定（其命令形态可参考，但本验收独立发起命令、独立读取输出、独立判定）。

**Closure:** `closure_ready = yes`（限本独立验收报告 artifact）。本文件的 `pass` 仅指 **Gate 2 扩展 + Gate 3 前段（R1 真实输入 + R2 read-model 呈现）独立验收通过**；不构成实现授权之外的任何放行、不是合同/ADR 批准、不是产品裁决、不豁免 Gate 3-6 全量。完成后停止，不进入下一阶段、不派发任何成员。

---

## 11. 版本与变更记录

- **v0.1（本文件）:** Independent QA / Release Lead 唯一新产物——Gate 2 扩展 + Gate 3 前段独立验收裁定书。独立重跑 `res://test/`（37 用例 = 19 rules [O4 三变体 + O5 二用例] + 18 adapter [R1 三用例]）2 次 exit 0 逐位一致 + XML 0 failure；self-test 2 次 exit 0 逐位一致（含 R2 呈现日志 + `NOT player-playable` 标注）；GDMCP runtime 真实 key 注入验证 R1 input→movement 因果 + `[LOCK-REFRESH]`；runtime frame 截图 + vision OCR/describe 验证 R2 read-model 全字段非色彩可读（UX-13）且 HUD 不遮挡 player（UX-09）+ hint 未落地 + nocue 种类未冻结；零容差断言 grep 确认。独立 verdict = **`pass`**，附非阻断观察项 O7（外层 fixture envelope 未落盘）/O8（真人键盘自由演示未执行）/O9（runtime 重定位帧在清除后无活候选可补）。未修改任何 Godot 构件/文档；未派发任何成员。
