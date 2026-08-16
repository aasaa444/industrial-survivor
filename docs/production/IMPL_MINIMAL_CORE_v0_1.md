# IMPL MINIMAL CORE v0.1 — 最小确定性核心 seam 实现说明

> **Status:** `IMPLEMENTED (local evidence)` · Gate 2 仍由 Independent QA 独立验收（本地测试 ≠ QA 验收）
> **Role:** Godot Gameplay Engineer（玩法工程师 · 实现 owner, R12；R13 授权生效）
> **Artifact owner (sole author):** Godot Gameplay Engineer
> **Report ID:** `IMPL_MINIMAL_CORE_v0_1`
> **Version note:** **v0.1.1（2026-08-16 终裁对齐修订）**：按 `SEMANTICS_INVALIDATION_FINAL_v0_1.md` §6 动作 2（Systems 终裁采用 (ii)，纯文档注记），将 §4.4/§6 的「失效语义待 Systems/QA 定裁」悬置重标注为「**已对齐 Systems 终裁语义 (ii)**」；`rules_core.gd`/`session.gd`/test **零代码变更**。上述边界声明「本地测试 ≠ QA 验收」保持不变。
> **Date:** 2026-08-16
> **Project root:** `D:\Game\New_Game\godot_game_dev`

---

## 0. 授权与边界声明（总览）

- 本任务为**唯一被派遣成员**执行的第一个实现任务：最小确定性核心 seam（规则核心 + session 最小上下文 + gdUnit4 单测骨架）。
- 用户已正式授权实现（R13，2026-08-16）并授权本任务。
- GDMCP 预检报告（`GDMCP_PREFLIGHT_REPORT_v0_1.md`）已通过：doctor/editor state `ok:true`、Godot 4.7.1、gdmcp 1.0.8、gdUnit4 6.2.1 已启用。
- **所有 Godot 构件变更均经 GDMCP**（无任何 shell/direct-write 绕道）。
- 未实现 adapter/presentation、未触碰 TECH-07/08、未提升任何候选数值、未豁免 QA。

---

## 1. Expert preflight（start 证据，按 godot-gameplay-engineer-expert §Expert preflight）

| 项 | 值 |
|---|---|
| 契约 | ADR-TECH-01..06（已批准）；DC-SYS-01 TECH-INPUT；PROPOSALS_CR002_004_005；QA_ACCEPTANCE_PLAN Gate 2 判据 |
| 项目根 | `D:\Game\New_Game\godot_game_dev` |
| 变更边界 | 仅经 GDMCP 写入的 3 个 Godot 脚本 + 1 份实现报告 |
| 当前相关状态 | editor_connected: true，无打开场景，runtime 未运行（预期） |
| 三大技术风险 | ① 浮点/容器顺序非确定 ② 失效语义歧义 ③ 脚本写入经 GDMCP 的路径可行性 |
| GDMCP 路线 | `doctor` + `editor state` 预检 → 探测 `scripts create` → `execute_editor_script` 写文件 → `scripts read` 再检 → `analyze_script` 解析校验 → headless gdUnit4 测试 |
| 检查 | headless gdUnit4 运行（exit 0）+ editor 解析校验 + 功能自检 |
| 回滚计划 | 本任务变更仅在规则核心/session/测试（引擎 free 纯逻辑）；回滚 = 撤 3 个脚本（经 GDMCP）。当前无 adapter/presentation 涟漪（排序逻辑严格留在规则核单一 owner） |
| 停止条件 | 报告写入即停；不进入下一阶段、不派发任何成员 |

---

## 2. 实际工具顺序与能力证据（真实记录）

| # | 工具/动作 | 结果 |
|---|---|---|
| 1 | `skill("godot-gameplay-engineer-expert")` | ✅ **实测成功**（返回完整 SKILL 指令；未报 unknown tool）。能力证据等级 = `strong_direct_skill`（首选等级）。无需 fallback 到 `C:\Users\User\.agents\skills\godot-gameplay-engineer-expert\SKILL.md` |
| 2 | `skill("gdmcp")` / `gdunit-driver` / `gdtoolkit` / `godot-cli-validation` | ✅ 全部实测成功（工具接口真实返回指令内容） |
| 3 | read 五份必读文档（GDMCP 预检、TC-INPUT、PROPOSALS、ADR 合同、QA 计划） | ✅ 全部成功 |
| 4 | read gdmcp `references/standard-action-chains.md` | ✅ 规范链读取（gdmcp.skill 要求） |
| 5 | `gdmcp doctor` + `editor state` | ✅ exit 0；editor_connected:true；Godot 4.7.1 |
| 6 | `gdmcp scripts create --help` / `scripts read --help` / `scripts list` | ✅ 确认 `create_script` 工具面支持 content 直接写入 |
| 7 | `gdmcp tools schema create_script` / `execute_editor_script` | ✅ 确认 `create_script` risk=write / `execute_editor_script` risk=destructive + `--apply`/`--allow-open-world` |
| 8 | **`execute_editor_script`（经 GDMCP）写入 3 个脚本到 res://** | ✅ 首次失败（嵌套 func 语法）；改为 tab 缩进直列逻辑后成功：`WROTE res://rules/rules_core.gd bytes=8882`、`WROTE res://rules/session.gd bytes=2527`、`WROTE res://test/rules_core_test.gd bytes=7168` |
| 9 | `gdmcp scripts read` 逐文件再检 | ✅ rules_core(190行)/session(60行)/test(152行) 内容完整、无截断 |
| 10 | `gdmcp analyze_script` 三脚本解析校验 | ✅ 均 `ok:true`；rules_core `has_class_name:true`/RefCounted；session 6 函数识别；test 7 测试方法识别，`extends GdUnitTestSuite` |
| 11 | `gdmcp detect_broken_scripts` | ⚠️ 36 个报错**全部在 `res://addons/gdUnit4/`**（`@abstract func` 接口声明被轻量扫描器误报；非本任务脚本；gdUnit4 6.2.1 预检确认可用）。**本任务 3 个脚本无一在报错列表** |
| 12 | Godot 路径探测 | ⚠️ `C:\Users\User\Downloads\` 下的 Godot exe 被 OS 拒绝执行（"Access is denied"/"not recognized"，AppLocker/执行策略类）；`D:\Game\Godot_v4.7.1-stable_win64\Godot_v4.7.1-stable_win64_console.exe` **可执行**且版本 `4.7.1.stable.official.a13da4feb`（与 gdmcp doctor 一致） |
| 13 | **headless gdUnit4 首次运行** | ✅ exit 0；`Statistics: 7 test cases | 0 errors | 0 failures | 0 flaky | 0 skipped | 0 orphans | PASSED`；XML 报告写入 |
| 14 | **headless gdUnit4 复跑（确定性）** | ✅ 再次 exit 0；7/7 全通过 |
| 15 | `execute_editor_script` 功能自检（真实引擎执行规则核/session 逻辑） | ✅ 7/7 全 PASS（`SUMMARY total=7 fail=0`）；作为补充运行时证据 |
| 16 | 清理 staging 临时文件 + 最终 doctor/editor state | ✅ staging 清空；final doctor/editor state 均 `ok:true` |

> **接口实测说明（DSH 实操纪律, 2026-08-16）：** 不得仅凭函数清单判 `skill` 不可用——本会话实际发起 `skill(...)` 调用并全部成功。唯 `tools.skill` 包装器在本运行时不独立存在（直接以 `skill` 调用），其余均实测返回指令内容。

---

## 3. 变更文件清单（经 GDMCP 的 Godot 构件）

| 路径 | 类型 | 角色 | 版本/形态 |
|---|---|---|---|
| `res://rules/rules_core.gd` | GDScript (`.gd`) | 规则核心（`class_name DshRulesCore`，`extends RefCounted`，engine-free 纯逻辑） | 190 行 |
| `res://rules/session.gd` | GDScript (`.gd`) | session 最小上下文（`class_name DshSession`） | 60 行 |
| `res://test/rules_core_test.gd` | GDScript (`.gd`) | gdUnit4 单测套件（`extends GdUnitTestSuite`） | 152 行，7 测试用例 |

> 写入方式：全部经 GDMCP 的 `execute_editor_script`（编辑器上下文 FileAccess 写文件，目录用 `DirAccess.make_dir_recursive_absolute` 创建），**未使用 shell/编辑器 API 直接写 Godot 构件**。创建后经 `scripts read` 逐文件再检以确认内容完整无截断。

---

## 4. 契约对照（每个约束如何满足）

### 4.1 ADR-TECH-01（边界：规则核 engine-free）
- 规则核心为 `extends RefCounted` 纯逻辑类：不与 Node/场景树/渲染/输入/UI 交互；排序与快照逻辑完全留在 `rules_core.gd`，adapter/presentation 不入侵。
- `ordered_candidates(state, params) -> ordered_ids` 纯函数位于规则核，不属 adapter。

### 4.2 ADR-TECH-02（purity / 生命周期）
- `step(domain_input_envelope, prior_state, tick)` 纯净：不读墙钟、不读设备、不触场景树、不读 UI 控制、不取全局随机。`prior_state` 永不原地变异（clone-on-write，`_clone_input` 深克隆）。
- session 拥有唯一 run 生命周期 owner（run_id / tick / seed / reset），adapter 不能创建第二权威 run。

### 4.3 ADR-TECH-03（确定性 / 复现 / trace / stable-ID）
- **全序键链**：comparator `_key_less` 只比较离散整数桶 `k1_bucket` → `k2_bucket` → `stable_id`（k3 唯一 ⇒ 全序，结果唯一、与容器顺序无关）。**禁浮点相等**：comparator 内无数值相等比较，距离先量化为整数桶。
- **量化**：`quantize_bucket(dist, scale)` 纯函数；`scale` 由调用方/fixture 显式传入（ledger 规则参数，非硬编码常数，未提升候选数值）。
- **不可变副本**：`ordered_candidates` 在过滤 alive 后构建的副本上 `sort_custom`，返回 ID 数组；`step` 在深克隆 state 上操作；不排序引擎/live 容器、不依赖容器插入序。
- **seed 上下文**：session 持有单一 `RandomNumberGenerator`（`_rng.seed` 于 reset 固定）；提供命名/定序/有界的 `draw_stream(stream_name)`（本任务不执行任何 draw，规则核纯无随机；诚实标注该 API 为未来生成调度的上下文载体，未声明已使用随机纪律）。规则核自身无任何 RNG。
- **复现证明**：headless 测试套件用固定 seed（1337）与固定 tick，两次运行 exit 0 且结果一致（7/7）。

### 4.4 ADR-TECH-04（target snapshot）
- **pre-fire refresh → M-1 stable-sort → lock 不可变快照**：`step` 的 `refresh_fire` 任务读取适配器规范化候选 → `ordered_candidates` 推导 ordered_ids → `target_snapshot_ids` 锁定（不可变副本）→ `lock_tick` 记录。
- **no-target 分支显式**：空合法集 ⇒ `no_target_branch=true`、`target_snapshot_ids=[]`、`next_eligible_fire_tick=tick+1`、无伪造目标/锁定指示（quiet-cycle 规则侧字段，不实现表现层）。
- **失效 drain 点**：`removed_ids` 在命名 drain 点（本步起点）排空为 `invalidation_event(id, tick)`，写入 `invalidation_log`。
- **Trace 字段齐备**：`refresh_tick`、`lock_tick`、`invalidation_event(id,tick)`、`resolution_outcome`（每 ID `hit` / `no-hit-invalid`）、`target_snapshot_ids`（不可变）、`no_target_branch`、`next_eligible_fire_tick`、`ordered_ids`、tie-break 键 `(k1_bucket, k2_bucket, stable_id)`。

> **红队审查发现的契约张力（如实上报，非静默处理）：**
> cr-004 提供二选一：**(i) 快照完全权威**（锁定后移除的本 shot 仍命中，失效下一 shot 生效）vs **(ii) 确定性合法性谓词**（移除即失效 ⇒ 无命中）。`PROPOSALS_CR002_004_005 §3.4` 字面推荐 (i)，但 `QA_ACCEPTANCE_PLAN §3.4` 的 `TARGET-removal` 期望事实与任务契约 #4 均要求 **"锁定后移除 → X 无命中 + invalidation_event + 快照 ID 集不变"**（即 (ii) 方向）。本实现采取满足 QA 判据与任务契约的方向：**快照 ID 集不可变 + 解析只读快照 + 失效目标经 drain 点被排除于命中结算**。
>
> **✅ 状态（终裁后重标注，2026-08-16，纯文档注记）：** 上述语义选择已 **对齐 Systems 终裁语义 (ii)**——见 `SEMANTICS_INVALIDATION_FINAL_v0_1.md`（2026-08-16，Rules Semantic Adjudication / SYSTEMS FINAL RULING）。终裁即「移除即失效 ⇒ 无命中，落点在命名 drain 点；锁定 = 固定 ID 集 + 不重定位；锁定 ≠ 保证命中」，与 §4.4 记录及 `rules_core.gd` 落地方向逐条一致，**无需改代码**。原「待 Systems/QA 评审确认点」状态消除、不再悬置（QA 门不豁免、不作为冻结规则、不改动 §4.4 红队记录事实本身）。

### 4.5 ADR-TECH-06（headless seam）
- `step(domain_input_envelope, prior_state, tick) -> {state, events, diagnostics}` 形态落地；fixture 可无可渲染场景调用（单测不创建场景/节点）。
- 纯函数 `ordered_candidates(state, params) -> ordered_ids` 由 fixture 直接调用。

### 4.6 Gate 2 判据（QA_ACCEPTANCE_PLAN §2.2，方向对齐）
| 判据维度 | 本实现证据（本地测试，非 QA 验收） |
|---|---|
| Fixture 覆盖（TARGET-* 族 + 容器方差变体） | `TARGET-tie` / `container-order`(两种插入序) / `removal` / `no-target` / `float-epsilon` 全在测试套件；container-order 断言两种插入序 `ordered_ids` 逐位相同 |
| 排序确定性 | 同 seed + 固定输入 + 同键桶 → `ordered_ids`/`target_snapshot_ids` 逐位一致；headless 复跑一致 |
| 失效语义 | `TARGET-removal`：X 无命中、`invalidation_event` 入 trace、快照 ID 集不变、no-target 联动 |
| trace 字段核对 | `refresh_tick`/`lock_tick`/`invalidation_event`/`resolution_outcome`/`target_snapshot_ids`/`no_target_branch`/`next_eligible_fire_tick`/`(k1_bucket,k2_bucket,stable_id)` 全实现 |
| 比较纪律 | 测试断言用精确值（gdr 头 less 禁浮点相等）；默认零容差（O2/B3 纪律由 QA 验收时执行，本任务仅对齐） |

---

## 5. 证据清单（如实分类）

### 5.1 headless 确定性测试（primary · 本地证据，exit 0）

Godot 引擎：`D:\Game\Godot_v4.7.1-stable_win64\Godot_v4.7.1-stable_win64_console.exe`（`4.7.1.stable.official.a13da4feb`）
命令：
```
<godot> --headless --path <proj> -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd \
  --add res://test/rules_core_test.gd --ignoreHeadlessMode \
  --report-directory user://gdunit4-minimal-core
```
**首次运行结果（exit 0）：**
```
Statistics: 7 test cases | 0 errors | 0 failures | 0 flaky | 0 skipped | 0 orphans | PASSED 57ms
Executed test suites: (1/1)
Executed test cases : (7/7)
```
**逐条（首次）：** 7/7 PASSED（4–5ms 每例）：
- `test_target_tie_stable_id_decides` PASSED
- `test_target_tie_k1_dominates_k2` PASSED
- `test_target_container_order_independent` PASSED
- `test_target_no_target_branch` PASSED
- `test_target_removal_no_hit_and_invalidation_event` PASSED
- `test_target_float_epsilon_same_seed_consistency` PASSED
- `test_session_reset_is_clean_and_deterministic` PASSED

**复跑（确定性证据，exit 0）：** `Statistics: 7 test cases | 0 errors | 0 failures | ... | PASSED 54ms`

**XML 报告（权威）：** `C:\Users\User\AppData\Roaming\Godot\app_userdata\godot_game_dev\gdunit4-minimal-core\report_1\results.xml`
`<testsuites tests="7" failures="0" skipped="0" flaky="0">` — 每 testcase 均无 failure 子节点。
（报告写至 `user://`，`%APPDATA%\Godot\app_userdata\godot_game_dev\`，位于项目外，未污染项目树。）

### 5.2 editor 解析/功能校验（supplementary · 经 GDMCP）

- **`gdmcp analyze_script`（连接中的 Godot 4.7 编辑器实解析）：**
  - `rules_core.gd`: `ok:true`，`has_class_name:true`，`extends_from:RefCounted`，191 line
  - `session.gd`: `ok:true`，`has_class_name:true`，functions: `_init/reset/advance_tick/current_tick/draw_stream/step`
  - `rules_core_test.gd`: `ok:true`，`extends_from:GdUnitTestSuite`，7 个测试方法全部识别
- **`execute_editor_script` 功能自检（真实引擎执行规则核 + session 逻辑）：** `SUMMARY total=7 fail=0`（tie/container/no-target/removal/epsilon/session-reset/session-determinism 全 PASS）。
- **`detect_broken_scripts`：** 36 个报错全部集中在 `res://addons/gdUnit4/`（其 `@abstract func`/接口声明被轻量扫描器误报，预检已确认为可用的 6.2.1 插件）；**本任务 3 个脚本无任何报错**。

### 5.3 证据边界（诚实分类）

| 证据 | 类别 | 边界说明 |
|---|---|---|
| headless gdUnit4 运行（exit 0, 7/7） | **primary · 本地确定性测试** | 证明规则核/session 在本项目引擎下的确定性行为与 fixture 期望一致；**≠ QA Gate 2 验收**（独立 QA 另行观察，不豁免）|
| XML 报告 | primary durable | 7 tests / 0 failures，权威落盘 |
| headless 复跑（exit 0） | primary · 复现 | 同 seed 两次一致（确定性证据）|
| editor analyze_script | supplementary | 连接编辑器实解析，ok:true |
| execute_editor_script 功能自检 | supplementary runtime per 规范 (非 CLI runner) | 真实引擎执行规则逻辑，7/7 PASS |
| detect_broken_scripts | diagnostic | 本任务脚本零报错；addon 误报非本任务 |

> 明确标注：**无任何视觉/帧/E2E/性能/导出/QA 验收证据**；本任务不产生、也不声称此类证据。

---

## 6. 语义选择记录（红队审查产物）

1. **失效语义取 (ii)-方向**（快照 ID 集不可变 + 解析只读 + 失效目标不命中）：满足 QA §3.4 `TARGET-removal` 期望事实与本任务契约 #4。与 `PROPOSALS §3.4` 字面推荐的 (i) 原存在文本张力，现 **已对齐 Systems 终裁语义 (ii)**（`SEMANTICS_INVALIDATION_FINAL_v0_1.md`，2026-08-16）：移除即失效 ⇒ 无命中、落点命名 drain 点、锁定 = 固定 ID 集 + 不重定位、锁定 ≠ 保证命中。终裁与本实现落地方向逐条一致，**无需改代码**；原「Systems/QA 协调确认点（非冻结、非豁免）」悬置已消除。
2. **量化尺度为 ledger 参数**：`quantize_bucket(dist, scale)` 的 `scale` 由 fixture 传值（如 1000.0），非硬编码规则常数，未提升候选数值（候选预算六项 + `1280×720` 红线均保持仅候选，本任务未涉及）。
3. **seed/RNG**：session 持有单一 seed 上下文（`_rng`），规则核无随机；`draw_stream` 命名/定序/有界 API 置入但本任务不执行 draw（诚实声明，未虚报随机纪律已被应用）。

---

## 7. Provenance 分层与不变量保留

- **`user_confirmed`（仅引用，不新增）:** 22 项原始 user_confirmed；revision-02 #3/#4；PRECHARTER-01/-02/-04/-11；cr-001 Option A (R09)；ADR-TECH-01..06 批准 (R11)；AUTH-01 (R13 实现授权)。本报告不重写、不重分类任何一项。
- **`team_proposal`（本实现引入的机制落点建议）:** 失效语义 (ii)-方向、量化 scale 作为 ledger 参数传递、session 命名随机流 API。全部为机制落实建议，需评审 + 证据确认，未升级。
- **`assumption`:** 确定性排序在 seed+固定输入+固定 tick 下可复现（本任务已用 headless 复跑验证为真）；失效 drain 点可 headless 实现（已验证）。
- **`unresolved`（全量保留，未关闭）:** cluster membership；metric/quantization 精确数值与单位（scale 值仍为测试传参，未定）；tie-break 可读性语义；stable-ID 生命周期细节；no-target cycle 精确周期与提示形态；B2 多弧中间态；tick 频率；fixture_schema_version。**失效语义 (i)/(ii) 已由 Systems 终裁收敛为 (ii)（见 `SEMANTICS_INVALIDATION_FINAL_v0_1.md`，2026-08-16），自本 unresolved 项移除并标记为「已对齐 Systems 终裁语义 (ii)」，不再悬置；其余各 unresolved 项本报告仍未升级、未关闭。**

**不变量保留声明:** 22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / 其余 unresolved 全量 — 本实现未改动上述任何一项；未把任何 `team_proposal`/`assumption`/候选数值升级为 `user_confirmed`；候选预算（六项 + `1280×720` 红线）未动用/提升。**唯一例外 = 失效语义 (i)/(ii) 的唯一化**（自 unresolved 移出）由 Systems 终裁书收敛（`SEMANTICS_INVALIDATION_FINAL_v0_1.md`，2026-08-16），本报告仅做对齐注记，未代 Systems 裁。

---

## 8. 边界声明（明确）

- **未实现 adapter/presentation**：本任务只做规则核心（target 语义）+ session 最小上下文 + gdUnit4 测试骨架；adapter/presentation 内容为后续任务。
- **未触碰 TECH-07/08**：性能测量协议与导出/build identity 边界均未进入。
- **未提升候选数值**：量化 scale、no-target 周期、任何阈值均保持仅候选/测试参数，未提升为规则常数、门槛或 Gate 判据。
- **未豁免 QA**：本地测试（headless + editor 自检）为本地证据，**不代表 Independent QA Gate 2 验收**；QA 独立性保留，独立验收不豁免。
- **未批准/冻结任何 ADR / 规则语义 / fixture schema**：cr-002/004/005 仍 `unresolved`；**失效语义 (i)/(ii) 已由 Systems 终裁为 (ii)（`SEMANTICS_INVALIDATION_FINAL_v0_1.md`，2026-08-16），本实现对齐该终裁、无需改代码；本报告不批准/冻结该终裁书、不豁免 QA**。
- **未派发任何成员**：本会话**未调用** `subagent` / `subagent_fork` / `workflow` / `ralph` / 任何嵌套派发。
- **写入面**：仅新增 3 个经 GDMCP 的 Godot 脚本 + 本报告；未修改任何既有文档。
- **工具失败如实记录**：`execute_editor_script` 首次因嵌套 func 语法失败并自纠（改 tab 缩进直列逻辑）；`C:\Users\User\Downloads\` 下 Godot exe 被 OS 执行策略拒绝（改用 `D:\Game\Godot_v4.7.1-stable_win64\` 的可执行安装成功）。

---

## 9. 交接与下一步

- **Handoff 给 QA/评审：** 本最小核心 seam 的确定性 fixture（TARGET-tie / container-order / removal / no-target / float-epsilon）+ seed 复现 trace + trace 字段，可作为 Gate 2 独立观察的工程输入；QA 需在真实样本上独立核计（本报告不含 QA 验收 verdict）。
- **待 Systems/评审确认:** 失效语义 (i)/(ii) **已由 Systems 终裁为 (ii)**（`SEMANTICS_INVALIDATION_FINAL_v0_1.md`，2026-08-16），本实现对齐该终裁，不再悬置；量化 scale 的 ledger 起步值、tie-break 语义仍待后续评审。
- **后续任务边界:** adapter/presentation（未做）、TECH-07/08（未进入）、候选预算（未提升）。

---

## 10. Closure

- **closure_ready: YES**
- 结论：最小确定性核心 seam 已实现并经 GDMCP 应用；3 个脚本全部经连接编辑器实解析通过；headless gdUnit4 测试 7/7 通过（两次运行 exit 0，复现一致）；证据边界如实分类（本地测试 ≠ QA 验收）；边界声明完整（未做 adapter/presentation、未碰 TECH-07/08、未提升候选数值、QA 不豁免）。
- 本报告完成后停止，不进入下一阶段、不派发任何成员。

---

## 11. 版本与变更记录

- **v0.1（初版）:** Godot Gameplay Engineer 唯一实现报告产物。新增经 GDMCP 的 Godot 脚本：`rules/rules_core.gd`、`rules/session.gd`、`test/rules_core_test.gd`；headless gdUnit4 测试 7/7 通过；未修改任何其它文档。
- **v0.1.1（2026-08-16，本次修订）:** **纯文档注记（零代码变更）**——按 `SEMANTICS_INVALIDATION_FINAL_v0_1.md` §6 动作 2，将 §4.4 红队记录与 §6 的「失效语义待 Systems/QA 定裁」悬置重标注为「**已对齐 Systems 终裁语义 (ii)**」（引用终裁书）；同步 §7 unresolved（失效语义 (i)/(ii) 由 Systems 终裁收敛为 (ii)、移出 unresolved）、§8/§9 边界与交接的该语义状态表述；文件级版本注记更新。`rules_core.gd`/`session.gd`/test **未改动**；「本地测试 ≠ QA 验收」边界声明未变；未修改任何其它文档。
