# QA CONTACT SLICE VERDICT v0.1 — Gate 2 扩展独立验收（C2 contact + C3 CONTACT-\* fixture + C4 contact seam）+ Gate 3 前段独立观察（C4 接触→伤害→无敌→分离→再武装 + C5 life 扣减呈现）

> **Status:** `INDEPENDENT QA VERDICT — COMPLETED / PASS（附非阻断观察项 O10–O12）`
> **Role:** Independent QA / Release Lead（独立验收负责人 · `godot-qa-release-expert`）
> **Artifact owner (sole author):** Independent QA / Release Lead
> **Report ID:** `QA_CONTACT_SLICE_VERDICT_v0_1`
> **Date:** 2026-08-17（独立验收执行；本会话全新独立运行，上一 QA 成员卡住被终止、未留下任何 verdict 文件——一切以本会话独立运行为准）
> **Project root:** `D:\Game\New_Game\godot_game_dev`
> **验收对象（被验收声明，仅参考 + 复跑指引，不当作证据）:** `IMPL_CONTACT_SLICE_v0_1.md`（C2 规则核 contact / C3 CONTACT-\* fixture / C4 adapter·运行时接触·伤害·分离·再武装 / C5 life 扣减 read-model 呈现；Engineer 本地声明的 49/49 + self-test ×3 + runtime smoke 仅作参考）
> **Lifecycle 衔接:** R13 实现授权生效；单元 1/2 已验收 pass（`QA_VERTICAL_SLICE_VERDICT_v0_1.md` 29 用例 / `QA_PLAYABLE_SLICE_VERDICT_v0_1.md` 37 用例）；本单元 = Producer `NEXT_IMPL_UNIT_PLAN_v0_3.md` 单元 B（候选 B：接触语义 + 玩家伤害），AUTH-01 本单元无前置强制 D2、推荐默认全程 D1。本 verdict = **Gate 2 扩展（49 用例 = 26 rules [含 C3 CONTACT-\* 6 新用例 + CONTACT-absent 兼容] + 23 adapter [含 C4 contact seam 5 新用例]）+ Gate 3 前段独立观察（C4 接触闭环 + C5 life 扣减呈现）**。**不是** Gate 3-6 全量。本 verdict 由 Independent QA **独立出具**；上一 QA 成员未留下任何 verdict —— 本判定基于本会话**独立复跑/独立观察**的输出，**不沿用** Engineer 自评，亦无既往 QA 报告可沿用。

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

> `tools.skill` 包装器在本运行时不独立存在；直接 `skill(...)` 实测调用成功且返回完整指令，未发生 unknown tool / 接口不存在错误。**未伪报「接口不存在」**；能力证据等级 = `strong_member_skill`（首选）。

### 0.2 实际工具顺序（真实记录）

| # | 工具/动作 | 结果 |
|---|---|---|
| 1 | `skill("godot-qa-release-expert")` | ✅ 实测成功（`strong_member_skill`） |
| 2 | 并行 `skill("gdunit-driver")` / `skill("godot-cli-validation")` / `skill("gdmcp")` / `skill("godot-native-e2e")` | ✅ 全部实测成功 |
| 3 | pwsh 验证 Godot 4.7.1 console exe（`D:\Game\Godot_v4.7.1-stable_win64\...console.exe`）`--version` = `4.7.1.stable.official.a13da4feb`；项目路径存在 | ✅ exe 存在 + version 确认 |
| 4 | `gdmcp --json doctor` | ✅ `editor_connected:true` / `godot_version:4.7.1-stable (official)` / `plugin_version:1.0.7` / `runtime_running:false` / 项目路径正确 |
| 5 | read 判据/背景：`QA_ACCEPTANCE_PLAN_v0_1.md`（Gate 2 判据）/ `QA_PLAYABLE_SLICE_VERDICT_v0_1.md`（上一单元 pass + O7/O8/O9 编号基线）/ `NEXT_IMPL_UNIT_PLAN_v0_3.md`（单元 B 定义 + §5 验收路径 + §6 AUTH-01）/ `CONTACT_LEDGER_v0_1.md`（C1 语义基准）/ `CONTACT_UX_OBSERVATION_v0_1.md`（UX C5+C6）/ `IMPL_CONTACT_SLICE_v0_1.md`（被验收对象）/ `SEMANTICS_INVALIDATION_FINAL_v0_1.md`（失效语义终裁 (ii)）/ `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（ADR-TECH-01/02/04/05）/ `UX_OBSERVATION_TARGETS_CR001_v0_1.md`（UX-02/03）/ `KICKOFF_UX_UI_CONTRACTS_v0_1.md`（UX-09/13） | ✅ 全读（静态判据核对） |
| 6 | git 状态 + 独立 grep 测试方法计数 | ✅ git HEAD = `29c874e`（`db5616f`+`29c874e`）；工作树 Godot 构件干净（仅 4 份 docs 未跟踪：Producer/Systems/UX；非 Godot 变更）。`rules_core_test.gd` = **26** 测试（19 既有 + 7 C3 CONTACT-\*）；`adapter_contract_test.gd` = **23** 测试（18 既有 + 5 C4 contact seam）→ 总计 **49 = 26 + 23** |
| 7 | grep 两测试文件零容差断言核对 | ✅ 无 `is_equal_approx` / `assert_float` / `epsilon` / `tolerance` / `is_greater` / `is_less` / `is_between` **实际使用**（仅注释/`TARGET-float-epsilon` fixture 名；CONTACT 全部 `assert_int().is_equal()` / `assert_bool().is_true()/is_false()` / `assert_array().is_equal()` 精确相等） |
| 8 | 读 C3 CONTACT-\* fixture 源码（rules_core_test.gd L505-705）+ rules_core.gd `_apply_contact` + adapter contact seam + main.gd 分离/C5 | ✅ 全读（独立静态核验具体语义 + 候选注记非锁常数） |
| 9 | **独立 headless gdUnit4 全量重跑 #1**（`--add res://test/ --ignoreHeadlessMode --report-directory user://qa-contact-fresh-run1`） | ✅ `Statistics: 23 ... PASSED`（adapter）+ `Statistics: 26 ... PASSED`（rules）+ `Overall Summary: 49 test cases | 0 errors | 0 failures | Exit code: 0` |
| 10 | **独立 headless gdUnit4 全量重跑 #2（确定性复现）**（`user://qa-contact-fresh-run2`） | ✅ 同 49/49 exit 0；XML testcase 身份集（49，有序）与 run1 **逐位一致**；两套 testsuites 均 `tests=23|26 failures=0 errors=0`；`<failure>` 节点 0 |
| 11 | **独立 self-test 重跑 #1**（`res://scenes/main.tscn -- --self-test`） | ✅ 完整 contact 闭环可见：`[CONTACT] damage victim_id=3 segments_lost=1` / `[CONTACT-INVULN]` / `[CONTACT-SEPARATE] victim_id=3 player=(320,334) (candidate mag 26)` / `[CONTACT-REARM] re-armed ids=[3]` / `[SELF-TEST-CONTACT-PASS] segments_lost=1`；READ-MODEL `contact: damage(victim=3 segments_lost=1)` / `contact: rearm([3])` |
| 12 | **独立 self-test 重跑 #2（确定性 + 显式 exit code）** | ✅ `EXIT CODE: 0` + `[SELF-TEST-CONTACT-PASS] segments_lost=1`（与 run1 定位一致，确定性） |
| 13 | **GDMCP runtime smoke（Gate 3 前段呈现观察）** | ✅ `run_project` status=success / probe_ready / `/root/Main` 场景 / 9 HUD Labels；截图（1152x648）OCR 读到 `LIFE [o][o][o] segments_lost=0` + TIMER + B2 + attack no_target + kill killed(2) + feedback quiet + `no target (quiet)` + `contact: none`；`@Label@5` LIFE 文本 (16,12) 左上、无 font_color override（非色彩）；`@Label@6` TIMER (16,30)；player position (320,360) 中央未被 HUD 遮挡（UX-09） |
| 14 | `stop_project` → doctor | ✅ stop success / mode:editor / `runtime_running:false` / `editor_connected:true`（干净停止） |
| 15 | 临时观测产物（XML ×2 + 截图 ×1）保留在 `user://`（Godot app 数据，项目外） | ✅ 未污染项目树 |

> 本任务**未调用** `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发（独立性铁律，禁止嵌套派发）。
> **接口实测结论:** `skill` 接口实测成功、返回完整指令；`tools.skill`（本运行时无独立包装器）以直接 `skill(...)` 调用成功。能力证据等级 = `strong_member_skill`。

---

## 1. Expert preflight（独立验收前置，按 godot-qa-release-expert §Expert preflight）

- **验收范围:** ① **Gate 2 扩展独立复跑**——49 用例（26 rules 含 C3 CONTACT-\* 7 [6 语义 + 1 加性兼容]；23 adapter 含 C4 contact seam 5）按 `QA_ACCEPTANCE_PLAN_v0_1.md` §2.2 / `NEXT_IMPL_UNIT_PLAN_v0_3.md` §5 判据独立观察（CONTACT-single 恰一次伤害 / overlap 无敌内无重复 / separate-rearm 分离后新合法接触 / simultaneous 单次伤害+无敌吞并·N× 边界未决 / boundary / removal）+ 2 次复跑确定性逐位一致 + 零容差断言纪律 O2/B3 + C1 ledger 对齐（单次伤害 1 格扣减、无敌窗口候选、分离、life segments_lost 0→3）；② **Gate 3 前段独立观察**——C4 运行时 接触→伤害→无敌→分离→再武装 闭环（self-test 独立复跑退出 0、输出逐位一致）+ C6 玩家伤害体验观察（C5 life 扣减呈现：`segments_lost` 从 0 实测扣减、非色彩 UX-13、HUD 不遮挡 UX-09、玩家伤害可归因非惩罚）；③ **候选注记核对**——无敌模型全局窗口（C1 起始建议成对，均 unresolved）、分离 26px（C1 起始 16px 候选 range 内）、边界不去轴（cr-009 延后）——核对这些确为 ledger 候选范围内调整、未锁常数、未写死规则/Gate/发布（AUTH-01 D2 护栏核对）。
- **Changed risks（本 scope 验收需防）:** ① 接触伤害/无敌/分离/life 扣减是否被写为规则常数/Gate 判据/发布承诺（D2-Card 1）；② 同时接触是否被设计为 N× 多次伤害（改决策 #4 → D2-Card 2）；③ 玩家伤害体验是否触碰 player promise 非惩罚（D2-Card 3）；④ 规则核是否越 seam 拥有引擎实体（ADR-TECH-01）；⑤ 确定性坚持（contact 零 RNG、断言零容差）；⑥ C5 life 扣减呈现是否非色彩可读（UX-13）且 HUD 不遮挡（UX-09）+ 是否只消费 rules trace（ADR-TECH-01/02 不伪造）。
- **所需证明类型:** Gate 2 扩展判定只由 `runtime` 类证据支撑（真实 runner 输出 + XML 权威报告 + 静态语义核验）；Gate 3 前段 contact 闭环由 `runtime`（self-test 确定性回归 + 日志）支撑，C5 呈现由 `runtime`（runtime frame 截图 + OCR + 标签 runtime 检查）+ self-test 确定性扣减证据支撑；life 扣减发生的确定证据以 self-test（`segments_lost=1`）为准（如实声明：normal-mode 无活体重叠可注入触发新扣减）。static 阅读仅作辅助推理，不构成通过证据。
- **环境/目标:** headless Godot 4.7.1-stable (a13da4feb) + gdUnit4（`--ignoreHeadlessMode`）；固定 seed 2026 / 固定 tick；规则核+adapter 纯 RefCounted seam；运行时 scene 经 GDMCP/mcp runtime 观察。
- **独立性边界:** 独立 QA 独立观察与独立 verdict；不沿用 Engineer 本地 49/49 与 self-test 自评；不豁免 QA blocker；不批准/冻结任何合同/ADR/fixture schema/数值/表现形态；不替实现者修复代码。
- **Top three failure hypotheses（本次是否被防住）:**
  1. 接触伤害被写为规则常数 / Gate 判据（D2-Card 1）→ **被防住**：`rules_core.gd` `_apply_contact` 用 `envelope.get("contact_invulnerability_ticks",30)` / `envelope.get("contact_damage",1)`（L188/191，注释明确「envelope parameter, NOT frozen」）；`main.gd` `@export var contact_separate_dist: float = 26.0`（L62，注释「candidate separation magnitude (NOT a frozen rule constant)」）——全部候选参数、未锁常数、promotion=User。
  2. 同时接触被设计为 N× 多次伤害（改 #4 → D2-Card 2）→ **被防住**：`CONTACT-simultaneous` 断言恰 1 damage + segments_lost=1 + 双 victim 吞并 rearm=false；fixture 注释显式「Nx stacking is an explicit unresolved boundary, reported not implemented」。
  3. C5 呈现成为第二规则权威 / 伪造扣减 → **被防住**：`_present_read_model` 只从 rules trace `segments_lost` 读取（L356-364），`contact:` read-model 行只绑定 contact_feedback_from_result（规则事件）；`_apply_feedback` 消费 contact feedback 只在真实 contact 事件非空 emit。
- **停止条件:** 独立复跑（Gate2 ×2 + self-test ×2 + runtime 呈现观察）+ 逐项判据核对 + 唯一 verdict 文件写入即停；不进入 Gate 3-6 全量、不派发任何成员。

---

## 2. Gate 2 扩展逐项独立验收结论（对照 QA_ACCEPTANCE_PLAN §2.2 + NEXT_IMPL_UNIT_PLAN §5 / §7 D2 卡片）

| 判据维度 | 规则/判据 | 独立结论 | 证据（独立观察 + 静态核验） |
|---|---|---|---|
| **用例覆盖完成**（49 = 26 rules [含 C3 CONTACT-\* 6 + 1 加性] + 23 adapter [含 C4 5]） | 全部套件发现并执行 | **PASS** | 独立 grep：`rules_core_test.gd` = 26（19 既有 + `test_contact_single_...` / `overlap_...` / `separate_rearm_...` / `simultaneous_...` / `boundary_...` / `removal_...` / `absent_preserves_existing_semantics`）；`adapter_contract_test.gd` = 23（18 既有 + `contact_observations_filters_overlaps` / `empty_when_no_overlap` / `make_envelope_carries_contact_input_and_params` / `contact_feedback_bound_to_events` / `contact_feedback_empty_when_no_contact_event`）。独立重跑 #1/#2 均 `Overall Summary: 49 | 0 errors | 0 failures | Exit code: 0` |
| **排序/语义确定性复现**（同 seed/输入 → 跨 run 逐位一致） | 2 次复跑逐位一致 | **PASS** | 独立重跑 #1/#2 均 exit 0 / 49/49；XML testcase 身份集（49，有序）**逐位一致**；`<failure>` 节点 0；两套 testsuites 均 `tests=23|26 failures=0 errors=0 flaky=0 skipped=0` |
| **CONTACT-single（恰一次合法伤害）** | 一次合法重叠 → 恰好一次伤害事件；segments_lost=1；无敌进入；rearm=false | **PASS** | `test_contact_single_exactly_one_damage_and_invuln`（L511）：`dmg==1`、`invuln==1`、`segments_lost=1`、`contact_invulnerable_until_tick=230 (=200+30)`、`contact_rearm[3]=false`、`diagnostics.contact_damaged=[3]`。与 C1 ledger §2.1/§2.2 一致（单 tick 重叠 → 单次伤害 → 扣 1 格） |
| **CONTACT-overlap（无敌内无重复伤害）** | 持续重叠不产生第二次伤害；无敌内 re-arm=false | **PASS** | `test_contact_overlap_no_repeat_damage_rearm_false`（L543）：无敌内 step（tick 211）`segments_lost` 不变 1、`dmg==0`；无敌到期后（tick 241）持久重叠仍无法 repeat（`dmg==0`）、`contact_rearm[4]=false`。验证「连续重叠 ≠ 重复伤害」（决策 #4 + ADR-TECH-05） |
| **CONTACT-separate-rearm（分离后新合法接触）** | 分离 → re-arm=true + 无敌结束；新重叠 → 恰一次新合法接触 | **PASS** | `test_contact_separate_rearm_exactly_one_new_legal_event`（L574）：分离（空 contact_input）→ `contact_rearm[5]=true` + `rearmed==1`；新重叠 → `segments_lost=2` + `dmg==1`。验证「再接触仅在分离后合法」（ADR-TECH-05） |
| **CONTACT-simultaneous（堆叠/同时）** | **断言「单次伤害事件 + 无敌吞并」为推荐默认**（决策 #4）；N× 叠加为显式未决边界不实现 | **PASS** | `test_contact_simultaneous_single_damage_event_merged`（L605）：两敌 [7,8] 同时 → `dmg==1`、`segments_lost=1`、双 victim 均 rearm=false；fixture 注释显式「unresolved boundary: Nx stacking is NOT implemented」。**边界作明确未决上报**（对齐 C1 ledger §2.5 推荐默认；未改决策 #4 → D2-Card 2 未触发） |
| **CONTACT-boundary（边界分离与可恢复）** | 边界处接触 → 分离可恢复、不越界、无 sticky lock | **PASS** | `test_contact_boundary_separation_and_recoverable`（L630）：边界 contact → `segments_lost=1` → 分离 → `contact_rearm[9]=true` → 新重叠 → `segments_lost=2` + `dmg==1`（恢复可再接触、非粘滞）。规则 seam 断言可恢复间距（对齐 C1 ledger §2.6）；运行时去轴注记见观察项 O11 |
| **CONTACT-removal（保护期移除）** | 保护期内目标移除 → contact/rearm 状态清理（无 phantom rearm）；未来 re-arm 正确 | **PASS** | `test_contact_removal_during_protection_cleans_state`（L655）：保护期移除 id=11 → `contact_rearm.has(11)=false`（擦除）+ `phantom_rearm==0`；保护期后新重叠 id=12 → `segments_lost=2` + `dmg==1`（新合法接触）。与失效语义 (ii)（移除即失效、复用 drain 语义、不伪造命中）+ C1 ledger §2.6/§3.2 一致 |
| **CONTACT-absent（加性兼容）** | 无 contact_input 的既有 fixture 语义逐位不变（contact 状态不污染） | **PASS** | `test_contact_absent_preserves_existing_semantics`（L695）：无 contact_input → `segments_lost=0`、`contact_invulnerable_until_tick=-1`、`contact_rearm` 空、`dmg==0`。既有 37 用例全绿证明加性（Contact 扩展不回归 TARGET-*/KILL-*） |
| **C4 contact seam（adapter）** | adapter `contact_observations(overlaps)→[{id}]` 纯翻译；envelope 携带 contact_input+参数；contact feedback 绑定事件、空则无反馈 | **PASS** | adapter_contract_test 5 项：`contact_observations_filters_overlaps` / `empty_when_no_overlap` / `make_envelope_carries_contact_input_and_params` / `contact_feedback_bound_to_events` / `contact_feedback_empty_when_no_contact_event`；源码 adapter.gd `contact_observations`（L87）/`make_envelope`（L118-134）/`contact_feedback_from_result`（L182-187）只翻译、只绑定规则事件、无无接触伪造。2 次复跑全绿 |
| **C1 ledger 对齐（单次伤害 1 格扣减 / 无敌窗口 / 分离 / life segments_lost 0→3）** | 合法接触 → 扣 1 格 life（决策 #4 / C1 §2.2/§2.7）；3 格 0..3 | **PASS** | CONTACT-single/simultaneous 均 `segments_lost=1`（一次接触 +1）；separate-rearm 分离后再接触 → `segments_lost=2`（+1/合法接触）；C5 呈现 `segments_lost` 从 0 实测扣减（`[x]`/`[o]` 形状），source 只读 rules trace 且 clamp 0..3（main.gd L356-364）。life 3 格结构位在读 model 呈现（runtime OCR `LIFE [o][o][o]`） |
| **失效语义 (ii) 对齐（contact 复用 drain）** | 接触后失效目标不重复命中 | **PASS** | `CONTACT-removal` 断言擦除 + 0 phantom rearm + 新接触（对齐 `SEMANTICS_INVALIDATION_FINAL_v0_1.md` 终裁 (ii)「移除即失效、命名 drain 点、不伪造命中」）；adapter contact feedback 只绑定真实 contact 事件、空则无反馈 |
| **比较纪律（零容差默认，O2/B3）** | 无近似比较 | **PASS** | grep 两测试文件：无 `is_equal_approx`/`assert_float`/`epsilon`/`tolerance`/`is_greater`/`is_less`/`is_between` 实际使用（仅注释 / `TARGET-float-epsilon` fixture 名）；CONTACT 全部 `assert_int().is_equal()` / `assert_bool().is_true()/is_false()` / `assert_array().is_equal([...])` 精确相等。满足 O2/B3 默认零容差 |
| **确定性复现（同 seed/输入 → 逐位一致）** | 跨 run 一致 | **PASS** | 独立重跑 #1/#2 均 exit 0 / 49/49；XML 身份集逐位一致 + 0 failure/error（per-test wall-clock timing 非比较面） |

**Gate 2 扩展独立结论：49/49 全绿（2 次独立重跑逐位一致），CONTACT-single/overlap/separate-rearm/simultaneous（边界未决上报）/boundary/removal + C1 ledger 对齐（单次伤害 1 格、无敌窗口、分离、life 0→3）+ 零容差纪律全部满足。**

---

## 3. Gate 3 前段独立观察结论

### 3.1 C4 运行时 接触→伤害→无敌→分离→再武装 闭环（独立 self-test 复跑）

**独立执行结果（self-test run #1 / #2，均独立命令）：**
```
[SELF-TEST] restricted deterministic regression (scripted zero-move + scripted fire; NOT player-playable input evidence)
...
[SELF-TEST-CONTACT] overlapping enemy placed on player (contact regression begins)
[CONTACT] damage victim_id=3 segments_lost=1
[CONTACT-INVULN] brief invulnerability entered (no repeat damage during protection)
[READ-MODEL] ... | contact: damage(victim=3 segments_lost=1)
[CONTACT-SEPARATE] victim_id=3 player=(320,334) (light separation; candidate mag 26)
[CONTACT-REARM] re-armed ids=[3] (separation ended invulnerability; future contact legal)
[READ-MODEL] ... | contact: rearm([3])
[SELF-TEST-CONTACT-PASS] segments_lost=1 (exactly one contact damage; overlap no repeat; life deducted)
```
- run #1 exit 0、run #2 **EXIT CODE: 0**，均含 `[SELF-TEST-CONTACT-PASS] segments_lost=1`；无 SCRIPT ERROR/ERROR/WARNING；输出定位一致（确定性）。
- **闭环独立观察成立:** 重叠敌置于玩家上 → `[CONTACT] damage victim_id=3 segments_lost=1`（生命从 0 扣至 1）→ `[CONTACT-INVULN]`（无敌进入，无重复伤害）→ `[CONTACT-SEPARATE]`（player (320,334)，沿法向轻分离，candidate mag 26）→ `[CONTACT-REARM]`（分离结束无敌、未来接触合法）→ `[SELF-TEST-CONTACT-PASS]`。READ-MODEL `contact:` 行从 `none → damage(segments_lost=1) → rearm([3])`，呈现绑定接触事件（ADR-TECH-01/02）。
- **诚实边界（如实声明）:** self-test 为脚本化零移动+脚本化接触的确定性回归，**非玩家可玩输入证据**（标头显式标注）。完整「真人键盘移动→接触→撤离/恢复」玩家路径未本单元全量独立验收（延续 O8 约束，见观察项 O12）。

### 3.2 C5 life 扣减呈现 + C6 玩家伤害体验观察（runtime frame + OCR）

**GDMCP runtime smoke（独立执行）：**
- `run_project` status=success / probe_ready / scene `/root/Main` / 9 HUD Labels（新增 contact_label 在列）。
- 截图（1152x648）OCR 读到完整 HUD：`LIFE [o][o][o] segments_lost=0` / `TIMER tick=19840 run_bound=8min(opaque)` / `B2 pre-stission (structure placeholder)` / `attack: no_target (quiet)` / `kill: killed(2)` / `feedback: - (quiet)` / `no target (quiet)` / `contact: none`。
- runtime 标签检查：`@Label@5`（LIFE）文本 = `LIFE [o][o][o]  segments_lost=0`，global_position (16,12) 左上，**无 `theme_override_colors/font_color` override**（颜色非唯一通道 → 非色彩/形状呈现 UX-13）；player (Main) position (320,360) 中央，**未被左上 HUD 遮挡（UX-09）**。

| C5/C6 观察目标 | 独立证据 | 判定 |
|---|---|---|
| `segments_lost` 从 0 实际扣减呈现（C5） | self-test 确定性运行时证据：`[CONTACT] damage victim_id=3 segments_lost=1` + READ-MODEL `contact: damage(segments_lost=1)`；C5 呈现代码（main.gd L356-364）从 rules trace 读 `segments_lost` clamp 0..3 构建 `[x]`/`[o]`；runtime frame OCR 基线 `LIFE [o][o][o]`（未扣减路径正常） | **PASS（呈现绑定）**；诚实：normal-mode 无活体重叠触发新扣减，扣减发生的确定证据以 self-test `segments_lost=1` 为准（观察项 O10） |
| 非色彩、非仅色彩（UX-13 / 决策 #19） | LIFE 以文本/形状 `[o]`/`[x]` 分区呈现、无 font_color 唯一通道；`contact:` read-model 行为文本；无任何状态仅以色彩传达 | **PASS（前段观察）** |
| HUD 不遮挡 player/danger/space（UX-09） | HUD 标签位于左上（LIFE (16,12)、TIMER (16,30)、contact_label (16,156)）；player (320,360) 中央可玩区无重叠 | **PASS（前段观察）** |
| 玩家伤害可归因非惩罚（C6 D1/D4 + Pillar 4 / 决策 #4/#12） | 一次合法接触 → 单次伤害 → `segments_lost` 从 0→1 实测扣减 → 无敌（无重复扣血）→ 轻分离（可恢复间距）→ re-arm（未来可再合法接触）；无粘滞/无重复惩罚/无惩罚性击退（分离为轻推） | **PASS（前段观察）** |
| 「接触合法 vs 连续重叠」可辨（C6 D2 / 决策 #4） | CONTACT-overlap 断言持续重叠不重复扣血（无敌 + re-arm=false）；self-test 热度重叠恰 1 次扣血（`segments_lost=1`） | **PASS** |
| 反馈类 ↔ 规则源因果一致（C6 D5 / ADR-TECH-02） | `contact:` read-model 行 + `[CONTACT]`/`[CONTACT-INVULN]`/`[CONTACT-SEPARATE]`/`[CONTACT-REARM]` 全部绑定 `contact_feedback_from_result`（规则事件），无无接触伪造 | **PASS** |

**Gate 3 前段独立观察结论：** C4 contact 闭环（接触→伤害→生命扣减→无敌→分离→再武装→不重复）在真实引擎 headless 确定性闭环可观测（self-test ×2 exit 0 逐位一致）；C5 life 扣减呈现非色彩可读（UX-13）、HUD 不遮挡（UX-09）、contact read-model 绑定接触事件不伪造；玩家伤害体验可归因非惩罚（决策 #4/#12 + Pillar 4）。**前段观察 PASS**（诚实边界：正常模式无活体重叠可注入触发新扣减，扣减确定证据以 self-test `segments_lost=1` 为准；真人键盘自由操作未全量验收，见观察项 O12）。

---

## 4. 对照判据表（QA_ACCEPTANCE_PLAN / NEXT_IMPL_UNIT_PLAN §5 / CONTACT_LEDGER / CONTACT_UX / UX / ADR-TECH-05 / 失效 (ii) 对齐）

| 判据来源 | 判据 | 独立结论 |
|---|---|---|
| `QA_ACCEPTANCE_PLAN` §2.2「Fixture 覆盖完成」 | 49 = 26 rules（含 C3 CONTACT-\* 6 + 加性）+ 23 adapter（含 C4 5）全执行 | **PASS**（独立 grep 计数 26+23=49；独立重跑 #1/#2 全绿） |
| `QA_ACCEPTANCE_PLAN` §2.2「排序确定性」 | 同 seed/输入 → 逐位一致 | **PASS**（两个独立 run 逐位一致；XML 身份集逐位一致 + 0 failure） |
| `QA_ACCEPTANCE_PLAN` §2.2「失效语义 (ii)」 | 移除即失效 → 无命中；contact 复用 drain | **PASS**（CONTACT-removal 擦除 + 0 phantom rearm + 新接触；与失效 (ii) 一致） |
| `QA_ACCEPTANCE_PLAN` §2.2「比较纪律」 | 零容差默认 | **PASS**（grep 无 approx/epsilon/tolerance 实际使用） |
| `NEXT_IMPL_UNIT_PLAN` §5「CONTACT-\* fixture 确定性含同时接触/边界」 | single/overlap/separate-rearm/simultaneous/boundary/removal 精确语义 | **PASS**（逐 fixture 断言核对，见 §2 表） |
| `NEXT_IMPL_UNIT_PLAN` §5「C4 adapter/运行时接触·伤害·分离·再武装」 | contact 闭环可观测；adapter 接触检测在 seam | **PASS（前段）**（self-test ×2 exit 0 逐位一致 + `[CONTACT]`/`[CONTACT-INVULN]`/`[CONTACT-SEPARATE]`/`[CONTACT-REARM]`/`[SELF-TEST-CONTACT-PASS]`） |
| `NEXT_IMPL_UNIT_PLAN` §5「C5 life 扣减呈现」 | `segments_lost` 从 0 实测扣减、非色彩 UX-13、HUD 不遮挡 UX-09、hint/布局不冻结 | **PASS（前段）**（self-test `segments_lost=1` 确定扣减 + runtime OCR LIFE + runtime label 非色彩检查；hint/文案/布局/资产未冻结） |
| `NEXT_IMPL_UNIT_PLAN` §5「C6 玩家伤害观察」 | 接触→伤害→生命损失→撤离/恢复可归因非色彩非惩罚；「合法 vs 连续重叠」可辨 | **PASS（前段观察）**（生命扣减可读、无敌吞并不重复、分离可恢复、可归因；CONTACT-overlap 可辨） |
| `NEXT_IMPL_UNIT_PLAN` §5「Gate 判据更新」 | 本单元不把 contact 数值/字段升级为 Gate 判据/发布承诺 | **PASS**（候选参数 + promotion=User；无 D2 升级触发，见 §5） |
| `CONTACT_LEDGER` §2.2（单次伤害 1 格 life） | 一次合法接触 = 一次伤害 = 扣 1 格 | **PASS**（CONTACT-single/simultaneous `segments_lost=1`；separate-rearm 再接触 `=2`） |
| `CONTACT_LEDGER` §2.3（无敌：全局 vs 成对 unresolved） | 无敌内无重复伤害；模型未决 | **PASS**（CONTACT-overlap 无重复；全局窗口为候选注记，见 §5） |
| `CONTACT_LEDGER` §2.4（分离距离/方向候选） | 分离可恢复间距、未锁常数 | **PASS**（`_apply_light_separation` 沿法向轻推、距离为 candidate `@export 26.0` range [8,32] 内；见 §5） |
| `CONTACT_LEDGER` §2.5（堆叠：单次伤害+无敌吞并推荐默认） | 同时接触 = 一次事件；N× 显式未决 | **PASS**（CONTACT-simultaneous 恰 1 damage + 吞并；N× 未决上报） |
| `CONTACT_LEDGER` §2.6（边界：法向/切向、不越界） | 边界分离可恢复不越界 | **PASS**（CONTACT-boundary 可恢复；运行时去轴见观察项 O11） |
| `CONTACT_LEDGER` §2.7（life 3 格、1 接触=1 格、0..3） | 三格结构、每接触扣 1、segments_lost 0→3 | **PASS**（C5 呈现 + CONTACT 断言精确 +1；封顶 3 骨架） |
| `CONTACT_UX_OBSERVATION` §4/§6（C5 呈现绑定 + C6 观察目标） | 呈现只消费 rules trace、非色彩、不伪造、可归因非惩罚 | **PASS**（`_present_read_model` 只读 rules trace；contact read-model 绑定接触事件；无伪造扣减） |
| UX-13（非色彩可读） | life/伤害状态非色彩可读 | **PASS（前段观察）**（runtime label 无 font_color 唯一通道 + self-test 文本信号） |
| UX-09（HUD 不遮挡） | HUD 不覆盖 player/danger/space | **PASS（前段观察）**（HUD 左上、player 中央无重叠） |
| ADR-TECH-05（一次合法接触=单次伤害 + 短无敌 + 轻分离 + 分离后 re-arm + 同帧生命优先） | contact 闭环符合机制边界 | **PASS**（CONTACT-single/overlap/separate-rearm/simultaneous/boundary/removal 全部落在该边界内） |
| ADR-TECH-01/02（seam / read-model 不伪造） | 规则核收 adapter 触点输入；呈现只消费 read-model | **PASS**（contact_input seam + `_present_read_model` 只读 + `contact_feedback_from_result` 绑定） |
| 失效语义 (ii) 对齐 | 接触后失效目标不重复命中 | **PASS**（CONTACT-removal 复用 drain；不伪造命中） |
| AUTH-01 D2 卡片 | D2-Card 1/2/3 均未触发；推荐默认全程 D1 | **PASS**（see §5） |

---

## 5. 候选注记核对结论（AUTH-01 D2 护栏核对）

> Engineer 在 `IMPL_CONTACT_SLICE_v0_1.md` 注明三项候选调整，本 QA **独立逐项核对其确为 ledger 候选范围内调整、未锁常数、未写死规则/Gate/发布**（若写死即触发 D2-Card 1 暂停+升级，非 pass）。

| 候选注记 | 核对 | 结论 |
|---|---|---|
| **无敌模型取全局窗口**（C1 起始建议成对——均 unresolved） | `rules_core.gd` `_apply_contact` 用**单一** `state.contact_invulnerable_until_tick` 标量（L71）全局窗口（tick < until 阻断任何新接触）；窗口由 envelope `contact_invulnerability_ticks`（默认 30）参数化、注释「NOT frozen」。C1 ledger §2.3 明确「全局 vs 成对均 unresolved」+ 起始建议成对、两类均满足 ADR-TECH-05「无敌内无重复伤害」，fixture 断言模型无关。全局窗口在 unresolved 候选空间内、未锁常数 | **在 ledger 候选范围内、未锁、未写死；AUTH-01 D1 保留（不触发 D2-Card 1/2）** |
| **分离距离 26px**（C1 起始 16px 候选 range） | `main.gd` `@export var contact_separate_dist: float = 26.0`（L62，注释「candidate separation magnitude (NOT a frozen rule constant)」）；C1 ledger §2.4 `range [8px, 32px]` + starting 16px。26px 落在 [8,32] 候选 range 内、为参数非常数 | **在 ledger 候选范围内、未锁、未写死；AUTH-01 D1 保留** |
| **边界不去轴**（最小切片无竞技场边界，cr-009 延后） | `_apply_light_separation` 直接 `position += away * contact_separate_dist` 沿法向推离，**无竞技场边界钳制**；最小切片无竞技场边界故分离不去轴；cr-009（边界/分离失败）明确延后（unresolved）。CONTACT-boundary fixture 在规则 seam 只断言「可恢复间距 + 无 sticky lock」非引擎边界钳制 | **cr-009 延后即 unresolved、未锁规则；AUTH-01 D1 保留**（观察项 O11） |

**AUTH-01 D2 卡片核对:**
- **D2-Card 1（数值写死）:** 接触伤害/无敌时长/分离距离/life 扣减链接**未被写为规则常数/Gate 判据/发布承诺** → **未触发**。`contact_invulnerability_ticks` / `contact_damage` = envelope 参数；`contact_separate_dist` = @export 候选；life 数值语义归 Systems（promotion=User 未写死）。
- **D2-Card 2（堆叠改 #4）:** `CONTACT-simultaneous` **按推荐默认「单次伤害事件 + 无敌吞并」实现并断言**、N× 叠加显式未决不实现 → **未触发**（保持决策 #4）。
- **D2-Card 3（触碰 promise）:** 玩家伤害体验以 UX 观察目标固化、**未作冻结形态/发布文案**；非惩罚 / Pillar 4 未触碰 → **未触发**。

> **核对结论:** Engineer 三项候选注记均保持在 C1 ledger 候选范围 / unresolved 空间内、未锁常数、未写死规则/Gate/发布；同时接触保持单次伤害（决策 #4）；玩家伤害呈现仅观察不冻结。**AUTH-01 推荐默认（单次伤害 + 无敌吞并 + 全部数值走 ledger 候选 promotion=User）全程 D1 成立，无 D2 升级触发。**

---

## 6. 独立 verdict（Independent QA 唯一判定）

> ### **verdict = `pass`（附非阻断观察项 O10–O12）**
>
> **Gate 2 扩展**：49 用例（26 rules 含 C3 CONTACT-\* 6 语义 + CONTACT-absent 加性；23 adapter 含 C4 contact seam 5）在真实引擎独立重跑 2 次（exit 0，49/49，XML 身份集逐位一致）全部满足——CONTACT-single 恰一次伤害 / overlap 无敌内无重复伤害 / separate-rearm 分离后新合法接触 / simultaneous 单次伤害+无敌吞并（N× 边界未决上报）/ boundary 可恢复 / removal 保护期清理+未来 re-arm / 加性兼容（既有 37 用例全绿）+ C1 ledger 对齐（单次伤害 1 格扣减、无敌窗口候选、分离、life segments_lost 0→3）+ 零容差断言纪律全部验证通过。
>
> **Gate 3 前段**：C4 运行时 接触→伤害→生命扣减→无敌→分离→再武装→不重复 闭环独立观察**成立**——self-test 独立复跑 ×2 exit 0 逐位一致（`[CONTACT] damage segments_lost=1` + `[CONTACT-INVULN]` + `[CONTACT-SEPARATE]` + `[CONTACT-REARM]` + `[SELF-TEST-CONTACT-PASS]`）；C5 life 扣减呈现独立观察**成立**——runtime frame + OCR 确认 `LIFE [o][o][o]` 三格非色彩可读（UX-13）、HUD 不遮挡 player（UX-09）、`contact:` read-model 行绑定接触事件（ADR-TECH-01/02 不伪造）、玩家伤害体验可归因非惩罚（C6）。
>
> **未发现阻断性（P0/P1）缺陷**；未豁免任何 QA 门；未批准/冻结任何合同/ADR/fixture schema/数值/表现形态；候选注记核对确认全部在 ledger 候选范围内未锁常数；AUTH-01 D2 卡片均未触发、推荐默认全程 D1。观察项 O10–O12 为非阻断（诚实边界）。**本 verdict 仅覆盖 Gate 2 扩展 + Gate 3 前段观察，不代表 Gate 3-6 全量验收。**

**verdict 依据（逐项证据，独立核计）：**
- **runtime 证据（Gate2）：** 独立 headless gdUnit4 重跑 #1/#2 均 exit 0，`49 test cases | 0 errors | 0 failures | 0 flaky | 0 skipped | 0 orphans | Exit code: 0`；XML 两套 testsuites（rules=26 / adapter=23）均 `failures=0 errors=0`，testcase 身份集逐位一致，0 `<failure>` 节点。同 seed/tick + 同 build（4.7.1.a13da4feb）逐位一致。
- **runtime 证据（前段闭环）：** 独立 self-test ×2 exit 0 逐位一致，含 `[CONTACT] damage victim_id=3 segments_lost=1` / `[CONTACT-INVULN]` / `[CONTACT-SEPARATE] victim_id=3 player=(320,334)` / `[CONTACT-REARM] re-armed ids=[3]` / `[SELF-TEST-CONTACT-PASS]`；READ-MODEL contact 行从 none→damage(segments_lost=1)→rearm。
- **runtime 证据（前段呈现）：** runtime frame 截图（1152x648）+ OCR（`LIFE [o][o][o]` / TIMER / B2 / attack / kill / feedback / contact）+ runtime label 检查（LIFE (16,12) 左上、无 font_color 唯一通道、player (320,360) 中央不被遮挡）。
- **static 核验：** `_apply_contact`（contact_input→合法→单次伤害→无敌→分离 rearm→life 扣减，envelope 参数不锁）；adapter contact seam（纯翻译 + 绑定事件）；`_present_read_model` 只消费 rules trace（ADR-TECH-01）；`_apply_light_separation` 沿法向轻推（候选 26px 无边界钳制）；全部断言精确值（零容差）。

---

## 7. 观察项（非阻断 · 如实记录，供后续精化）

> 以下为独立观察到的**边界/完整性建议，均不构成 Gate 2 扩展或 Gate 3 前段阻断**，如实上报供后续评审与 evidence-harness 层完成时参考。接续前两单元 O1..O9，本单元从 **O10** 起编号。

- **O10 — 正常模式运行时未捕获「生命扣减发生帧」（`segments_lost=1` 画面）:** 本验收 GDMCP runtime smoke 中 normal-mode 无活体敌重叠可注入触发新接触（占位敌已被自动攻击清除、且正常模式初始敌置于非重叠区），故 runtime frame OCR 观测到的是 LIFE 基线 `segments_lost=0`（未扣减路径正常呈现）。**生命扣减确定性运行时可观测性以 self-test 为准**（引擎 headless 确定性回归：`[CONTACT] damage victim_id=3 segments_lost=1` + READ-MODEL `contact: damage(segments_lost=1)` + `[SELF-TEST-CONTACT-PASS]`），非 GDMCP 注入触发。若要 runtime 帧级「`[x][o][o]` 扣减画面」，需有活敌重叠场景 + runtime 注入观察（后续输入观察可补）。**非阻断**：self-test 提供确定性的 contact→damage→life-deducted 证据。
- **O11 — 运行时边界分离「不去轴」（无竞技场边界钳制）:** `_apply_light_separation`（main.gd L249-264）直接沿分离法向推离、**无竞技场边界钳制**——因最小切片无竞技场边界、cr-009（玩家/敌人边界与分离失败精确规则）明确延后（unresolved）。这与 C1 ledger §2.6 边界行为冲突消除方式（法向可行→场内转向、不越界、非粘滞）在**规则 seam 层**一致（`CONTACT-boundary` 断言可恢复间距、无 sticky lock）；引擎层「靠近未来竞技场边界时如何转向/钳制」属 cr-009 后续实现。**如实上报为 unresolved 边界，非阻断**（cr-009 未锁、未写死）。
- **O12 — 真人键盘自由操作演示未执行（延续 O8 诚实边界）:** 本验收 C4 contact 闭环以**受限确定性 self-test**（脚本化零移动 + 脚本化接触）独立观察，未执行真人键盘自由操作接近敌人→接触→撤离→恢复的完整玩家演示（延续单元 2 `QA_PLAYABLE_SLICE` O8 约束）。「接触→伤害→生命损失→可恢复」的**确定性机制**与 presentation 已独立观察成立；**「真人键盘完整接触体验可玩性」未本单元全量独立验收**（如实声明）。接触放松释放轻分离、分离后玩家可移动撤离（realistic），但需真人键盘演示或扩展注入覆盖多方向/连续移动才可完全确认玩家可玩性。

> 以上 O10/O11/O12 均为**如实边界/建议**，不构成 Gate 2 扩展或 Gate 3 前段阻断。true input/contact 体验观察协议本身（self-test 确定性回归 + runtime 呈现观察）可行性已被证实。

---

## 8. 已执行/未执行边界 + 诚实证据边界（明确声明）

**已执行（本单元 Gate 2 扩展 + Gate 3 前段独立验收）：**
- Gate2 确定性：独立 headless Godot 4.7.1 + gdUnit4 重跑 `res://test/`（adapter+rules）**两次**（exit 0，49/49，XML 身份集逐位一致），零容差 assertion grep 核对，测试方法计数（49 = 26 + 23）。
- 前段：独立 self-test `res://scenes/main.tscn -- --self-test` **两次**（exit 0 逐位一致，含 contact 全链 `segments_lost=1` 确定性扣减 + 无 error/warning）；GDMCP runtime smoke（run_project + runtime frame 截图 + OCR + runtime label 检查：LIFE 非色彩 / UX-09 不遮挡 / contact read-model）+ stop 干净。
- 判据：逐项对照 QA_ACCEPTANCE_PLAN §2.2 + NEXT_IMPL_UNIT_PLAN §5 + CONTACT_LEDGER（C1 语义基准）+ CONTACT_UX_OBSERVATION §4/§6 + ADR-TECH-05 + ADR-TECH-01/02 + 失效 (ii) + UX-09/13（§4）。

**未执行（非本 Gate，如实排除）：** 本验收**非** Gate 3 视觉/UX 全量验收（未做视觉基线/资产/UX 判据全量；仅前段可观察性观察与 UX-09/13 前段核对）、**非** Gate 4 性能、**非** Gate 5 导出、**非** Gate 6 发布。未做任何性能测量 / 视觉基线 / 导出 / 发布 / 产品裁决。**life 扣减运行时画面（`segments_lost=1` 帧）未经 runtime 注入捕获**（normal-mode 无活敌重叠，以 self-test 确定性证据为准，观察项 O10）；**真人键盘自由操作演示未执行**（受限确定性观察，延续 O8/O12）。`1280×720` 红线仅候选、未测量。

**未修改任何代码/构件：** 本验收为**只读 + 只运行 + 唯一 verdict 文件写入**。未创建/编辑/删除/覆盖任何 `.gd`/`.tscn`/`.tres`/`project.godot`/addon/配置等 Godot 构件；未改动测试文件；未调用任何 GDMCP 写入 / mcp 运行时写入（仅 `run_project`/`get_runtime_info`/`get_runtime_scene_tree`/`get_runtime_screenshot`/`inspect_runtime_node`/`evaluate_runtime_expression` 只读观察 + `stop_project`）；临时观测产物（XML ×2 + 截图 ×1）位于 `user://`（Godot app 数据，项目外）。

**未修复缺陷：** 观察项 O10/O11/O12 均如实报告为**边界/建议**，不由本 QA 修复（独立 QA 不替实现者修复代码/不补实现）。

**未豁免任何 QA / 未批准冻结任何合同/ADR/fixture schema/数值/表现形态 / 未替用户做产品或验收裁决：** 候选注记（全局窗口 / 26px / 不去轴）确认在 ledger 候选范围 / unresolved 空间内未锁常数；AUTH-01 D2 卡片均未触发；life 数值语义、接触数值、同时接触 N×、spawn 节奏等均保持 unresolved；候选预算（six + `1280×720` 红线）**全部保持仅候选，未提升**；promotion_authority=User。**本 unit 不授予任何 Gate 3+ 免除。**

**未派发/扩展任何成员：** 未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

---

## 9. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；cr-001 Option A (R09)；ADR-TECH-01..06 批准 (R11)（含 TECH-05 机制边界）；决策 #4（contact 单次伤害事件）/ #5（life 三格&同帧生命优先）/ #12（defeat=light interruption）/ #19（非色彩可读）；UX-03 S1–S3；AUTH-01 (R13 实现授权)；单元 1/2 QA verdict `pass`；失效语义 (ii)（Systems 终裁）。本 verdict 不重写、不重分类任何一项。
- **`team_proposal`（本验收实质贡献）:** Independent QA 对 Gate 2 扩展 + Gate 3 前段的 **`pass` verdict**、观察项 O10–O12、逐项判据表、候选注记核对结论、真实运行时/self-test 观察协议及结果、证据边界声明。全部为独立 QA 判断，供父协调器/用户作为本单元 Gate 2 扩展 + 前段观察输入；不代 Systems/Tech/UX/User 裁决。
- **`assumption`（本样本内已由独立观察验证）:** 确定性接触语义在真实引擎 + 纯规则 seam + 固定 tick 下可复现（两次独立 run 实证）；contact→life 扣减（segments_lost 0→1）+ 无敌 + 分离 + 再武装 闭环在 headless 确定性回归可观测（self-test ×2 实证）；C5 呈现只消费 rules trace 且非色彩不遮挡（源码 + runtime frame + self-test 实证）；候选注记（全局窗口/26px/不去轴）确为 ledger 候选范围内未锁常数（源码 + fixture 实证）。
- **`unresolved`（全量保留，未关闭）:** cr-006..009 精确值（接触判定/无敌时长/分离距离方向/堆叠 N×/边界/分离失败）；`life segments_lost` 精确数值语义（归 Systems contact 单元）；同时接触 N× 叠加（推荐默认单次+吞并，显式未决）；无敌全局 vs 成对模型；分离失败/边界精确规则（cr-009）；spawn 节奏；敌人多段 HP；伤害/无敌/分离/re-arm 反馈精确表现种类；生命耗尽终局（cr-014..015）；hint；no_target_cue 种类；O6 外层 fixture envelope；`fixture_schema_version`；O8/O12 真人键盘自由操作未全量验收；O10 normal-mode 运行时扣减帧未捕获；O11 runtime 边界不去轴——均保持 open（本验收不升级、不闭合任何 unresolved 项）。

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量 —— 本 verdict 未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未被动用/提升；候选注记未写死为规则常数/Gate 判据/发布承诺。

---

## 10. exact sections / files

- **验收对象（只读，未改）:** `res://rules/rules_core.gd`（378 行，C2 `_apply_contact`）、`res://adapter/adapter.gd`（196 行，C4 contact seam）、`res://runtime/main.gd`（543 行，C4 分离 + C5 呈现）、`res://test/rules_core_test.gd`（705 行，26 测试）、`res://test/adapter_contract_test.gd`（292 行，23 测试）。`res://rules/session.gd`、`res://scenes/main.tscn` 未变（Engineering 声明；本验收只读未改）。
- **唯一写入产物（本任务）:** `docs/production/QA_CONTACT_SLICE_VERDICT_v0_1.md`（本文件）。
- **证据源（未改，只读）:** `QA_ACCEPTANCE_PLAN_v0_1.md`（判据）、`QA_PLAYABLE_SLICE_VERDICT_v0_1.md`（上一单元 pass + O7/O8/O9 基线）、`NEXT_IMPL_UNIT_PLAN_v0_3.md`（单元 B + §5 + §6/§7）、`CONTACT_LEDGER_v0_1.md`（C1 语义基准）、`CONTACT_UX_OBSERVATION_v0_1.md`（C5+C6）、`IMPL_CONTACT_SLICE_v0_1.md`（被验收对象，参考非证据）、`SEMANTICS_INVALIDATION_FINAL_v0_1.md`（终裁 (ii)）、`KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（ADR-TECH-01/02/04/05）、`UX_OBSERVATION_TARGETS_CR001_v0_1.md`（UX-02/03）、`KICKOFF_UX_UI_CONTRACTS_v0_1.md`（UX-09/13）。
- **运行产物（独立生成，位于项目外，未污染项目树）:**
  - XML `%APPDATA%\Godot\app_userdata\godot_game_dev\qa-contact-fresh-run1\report_1\results.xml`（49 tests failures=0）
  - XML `%APPDATA%\Godot\app_userdata\godot_game_dev\qa-contact-fresh-run2\report_1\results.xml`（49 tests failures=0；身份集与 run1 逐位一致）
  - GDMCP runtime screenshot `%APPDATA%\Godot\app_userdata\godot_game_dev\qa-contact-runtime-life.jpg`（1152x648；OCR 读到 LIFE/TIMER/B2/attack/kill/feedback/contact）
  - self-test 输出（stdout ×2 exit 0，contact 全链定位一致）

---

## 11. 边界声明与 Closure

- **Gate 2 扩展独立验收已执行:** verdict = **`pass`**（49 用例 = 26 rules + 23 adapter，独立重跑 2 次 exit 0 逐位一致；CONTACT-single/overlap/separate-rearm/simultaneous/boundary/removal + C1 ledger 对齐 + 零容差全部满足；N× 边界显式未决上报）。**Gate 3 前段独立观察已执行:** C4 contact 闭环自我-test 确定性回归（×2 exit 0 逐位一致，`segments_lost=1`）+ C5 life 扣减呈现（LIFE 非色彩 UX-13 + HUD 不遮挡 UX-09 + contact read-model 绑定不伪造 + 玩家伤害可归因非惩罚）观察成立。
- **本 verdict 范围边界:** 仅 Gate 2 扩展确定性验收 + Gate 3 前段（C4 contact 闭环 + C5 life 扣减呈现）独立观察。**非** Gate 3 视觉/UX 全量验收（未做视觉基线/资产）、**非** Gate 4 性能、**非** Gate 5 导出、**非** Gate 6 发布；无相应全量证据，如实声明（§8）。
- **诚实边界（明确）：** life 扣减确定性证据以 self-test `segments_lost=1` 为准（normal-mode 无活体重叠可注入触发新扣减，观察项 O10）；运行时边界分离不去轴（无竞技场边界钳制，cr-009 延后，观察项 O11）；真人键盘自由操作完整接触体验未全量独立验收（受限确定性观察，延续 O8，观察项 O12）。性能预算未涉及；`1280×720` 红线仅候选。
- **未做:** 未改任何代码/构件；未修复观察项；未豁免 QA；未批准/冻结任何合同/ADR/fixture schema/数值/表现形态；未替用户做产品/验收裁决；未派发/扩展任何成员；候选数值全部保持仅候选；候选注记（全局窗口/26px/不去轴）未写死、AUTH-01 D2 均未触发。
- **独立复核声明:** 本 verdict 由 Independent QA **独立出具**，基于本验收独立复跑（Gate2 ×2 + self-test ×2）+ 独立 runtime 呈现观察 + 逐项判据核对。**上一 QA 成员卡住被终止、未留下任何 verdict 文件**——本判定全程以本会话独立运行为准；不沿用 Engineer `IMPL_CONTACT_SLICE_v0_1.md` 本地 49/49 与 self-test/runtime smoke 自评（其命令形态可参考，但本验收独立发起命令、独立读取输出、独立判定）。

**Closure:** `closure_ready = yes`（限本独立验收报告 artifact）。本文件的 `pass` 仅指 **Gate 2 扩展 + Gate 3 前段（C4 contact 闭环 + C5 life 扣减呈现）独立验收通过**；不构成实现授权之外的任何放行、不是合同/ADR 批准、不是产品裁决、不豁免 Gate 3-6 全量。完成后停止，不进入下一阶段、不派发任何成员。

---

## 12. 版本与变更记录

- **v0.1（本文件）:** Independent QA / Release Lead 唯一新产物——Gate 2 扩展 + Gate 3 前段独立验收裁定书。独立复跑 `res://test/`（49 用例 = 26 rules [C3 CONTACT-\* 6 + 加性] + 23 adapter [C4 5]）2 次 exit 0 逐位一致 + XML 0 failure；self-test 2 次 exit 0 逐位一致（contact→damage→segments_lost=1→无敌→分离→再武装 全链 + `[SELF-TEST-CONTACT-PASS]`）；GDMCP runtime 呈现观察（LIFE 非色彩 UX-13 + HUD 不遮挡 UX-09 + contact read-model 绑定）；零容差断言 grep 确认；候选注记（全局窗口/26px/不去轴）核对为 ledger 候选范围内未锁常数、AUTH-01 D2 均未触发。独立 verdict = **`pass`**，附非阻断观察项 O10（normal-mode 运行时扣减帧未捕获）/O11（runtime 边界不去轴 cr-009）/O12（真人键盘自由操作未全量验收，延续 O8）。未修改任何 Godot 构件/文档；未派发任何成员。

---

## 附录 · 返回报告（structured）

- **status:** `completed`
- **actual start evidence:** `skill({name:"godot-qa-release-expert"})` **实测成功**（`strong_member_skill` 首选；返回完整 SKILL 指令，未报 unknown tool）；随后并行 `skill("gdunit-driver")` / `skill("godot-cli-validation")` / `skill("gdmcp")` / `skill("godot-native-e2e")` 全部实测成功。
- **expert skill evidence:** `godot-qa-release-expert`（`C:\Users\User\.agents\skills\godot-qa-release-expert\SKILL.md`）；能力证据等级 = `strong_member_skill`（首选）；specialist Skills `gdunit-driver` / `godot-cli-validation` / `gdmcp` / `godot-native-e2e` 均已加载。
- **expert preflight:** 验收范围（Gate 2 扩展 49 用例 + Gate 3 前段 C4 闭环 + C5 呈现）、changed risks（数值写死 / N× 改 #4 / 触碰 promise / 越 seam / 确定性 / 非色彩 / 不伪造）、所需证明类型（runtime 为主）、环境（headless 4.7.1 + gdUnit4 + GDMCP/mcp）、独立性边界（不沿用自评、不豁免、不冻结）、top failure hypotheses、停止条件（verdict 文件写入即停、不派发）。
- **artifact path/version:** `QA_CONTACT_SLICE_VERDICT_v0_1.md`（本文件，唯一新产物）。
- **verdict:** `pass`（附非阻断观察项 O10–O12）。Gate 2 扩展 49/49 全绿（2 次独立复跑逐位一致）；Gate 3 前段 contact 闭环 + life 扣减呈现观察 PASS。
- **exact tests run（独立命令 + 输出摘要）:** 见 §0.2 #9-#14 与 §2/§3。（①独立 headless gdUnit4 全量 ×2：`<godot> --headless -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd --add res://test/ --ignoreHeadlessMode --report-directory user://qa-contact-fresh-run1|2` → 均 exit 0 / 49/49 / XML 身份集逐位一致；②独立 self-test ×2：`<godot> --headless res://scenes/main.tscn -- --self-test` → 均 exit 0（run2 显式 EXIT CODE:0）、contact 全链 `segments_lost=1`；③GDMCP runtime smoke：run_project + screenshot + OCR + runtime label 检查 + stop_project。）
- **候选注记核对结论:** 全局窗口（envelope 参数、C1 全局/成对均 unresolved 候选空间内）/ 26px（@export 候选、range [8,32] 内）/ 不去轴（最小切片无边界、cr-009 延后 unresolved）——全部未锁常数、未写死规则/Gate/发布；AUTH-01 D2-Card 1/2/3 均未触发、推荐默认全程 D1。
- **user-confirmed vs proposal/unresolved（分层 + 不变量保留）:** `user_confirmed`（22 / 恰好 8+1 / PRECHARTER-01..11 / cr-001 / ADR-TECH-01..06 / 决策 #4/#5/#12/#19 / UX-03 / AUTH-01 / 失效 (ii)）仅引用未重分类；`team_proposal`（本验收 verdict + 观察项 + 判据表）独立判断；`unresolved`（cr-006..009 精确值 / life 数值语义 / N× / 全局 vs 成对 / 边界 cr-009 / 呈现形态 / O10/O11/O12 边界）全量保留未闭合。不变量（22 / 8+1 / PRECHARTER / 四层 / unresolved / 候选预算）未改动。
- **evidence inspected:** 独立 headless 49/49×2 + XML 身份集逐位一致；独立 self-test ×2 exit 0（contact 全链 + `segments_lost=1` 确定性扣减）；GDMCP runtime frame OCR + runtime label 检查（LIFE 非色彩 / UX-09 / contact read-model）；零容差 assertion grep；候选注记源码核对；git 状态 + 测试计数。**独立输出为主**；Engineer 本地声明仅作参考不沿用；上一 QA 无 verdict 文件可沿用。
- **explicit boundary statement:** 未做延后项（升级/B2/终结/focus/spawn/资产/动画/音频/数值定稿/视觉 v0.2/导出/发布/Replay）；未提升候选数值；未批准/冻结契约/表现形态；QA 不豁免；未替用户做产品/验收裁决；未碰被禁止文档/CR 台账；未派发成员；life 扣减确定证据以 self-test 为准（O10）；runtime 边界不去轴 cr-009（O11）；真人键盘自由操作未全量验收（O12）。
- **`closure_ready`:** `true`
