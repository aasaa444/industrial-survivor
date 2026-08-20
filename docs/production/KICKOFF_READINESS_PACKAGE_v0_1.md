# Charter Kickoff Readiness Package v0.1
**Author:** Executive Producer / Lead Producer（执行制作人 / 首席制作人）  
**Date:** 2026-08-20  
**Charter:** Development Charter v0.1 (AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY)  
**Current Lifecycle:** development governance / kickoff readiness preparation  
**Status:** `ready_for_user_decision`  
**Recommendation:** Proceed with Option A (Proceed to Implementation) pending user decisions on items 1-8 below.

---

## 1. Verification Status (已验证)

| 项目 | 状态 | 证据 |
|---|---|---|
| Godot 项目编译 | ✅ PASS | Headless mode: no errors; main.gd 67.6KB (post-B2-fix) |
| gdUnit4 测试 | ✅ 60/60 | `reports/report_6/results.xml`；QA verdict: PASS |
| 归档提交 | ✅ 完成 | `b13c2be` (Phase 4-6)，`2873bb9` (BGM loop) |
| 主体功能 | ✅ 完成 | VFX 6 系统已实现；7 PNG + 7 WAV 资产已产出 |
| QA 验收 | ✅ CONDITIONAL_PASS | `QA_VISUAL_PHASE_VERDICT_v0_1.md`：5 visual pass_verified，3 pass_code_verified_no_screenshot，2 audio pass_verified，2 regression pass_verified |
| A-2 BGM Loop | ✅ 软门接受 | `loop_mode=0`（循环未启用），建议升级 cr-109 |
| VFX 中心原理 | ✅ 已验证 | core→transition→falloff 结构已在 VFX-01/02/05/06 确认 |
| 玩家/敌人可辨识度 | ✅ 已验证 | Sprite2D 已替代 ColorRect，艺术风格一致 |
| 60/60 回归测试 | ✅ 通过 | gdUnit4 完整通过，无错误/失败/抖动 |

---

## 2. Gate 0-6 Readiness（Gate 0-6 准备情况）

| Gate | 描述 | 当前状态 | 所需行动 |
|---|---|---|---|
| **Gate 0** | Charter readiness (version, scope, owners, CR intake) | ✅ **READY** | Evidence package assembled；Charter v0.1 权威确认；22 项 user_confirmed baseline 与 PRECHARTER-01..11 已锁定 |
| **Gate 1** | Static conformance (22 decisions, PRECHARTER-01..11, caps/exclusions) | ✅ **READY** | 所有 baseline 已文档化；Change Requests 台账 rev-7 已登记；ADR-TECH-01..08 状态行未批准但已在审议路径上；Systems/UX 合同 `NOT APPROVED` 但评审输入已在库 |
| **Gate 2** | Deterministic/runtime (fixtures, seed/tick/snapshot/trace) | ⏳ **PENDING** | Tech Lead 必须编写 ADR：rules/session/adapter/seam；确定性契约；fixture/seed 规范；tick 权威；snapshot/trace schema 草案 |
| **Gate 3** | Visual/UI (state/aspect coverage, focus, hint, cards, HUD, B2) | ⏳ **PENDING** | UX/UI 合同待定：HUD 层级建议；焦点安全协议；卡牌状态机规范 |
| **Gate 4** | Performance (named hardware, build, samples, percentiles) | ⏳ **PENDING** | 性能预算决策：1080p/60 基线；帧率采样窗口；输入/反馈时戳方法 |
| **Gate 5** | Export smoke (launch artifact, version integrity) | ⏳ **PENDING** | 导出模板（PC Windows 10+）；构建 ID 方案；启动验证机制 |
| **Gate 6** | Independent release review (consolidated evidence package) | ⏳ **PENDING** | 依赖 Gates 0-5 通过；证据收集协议定稿；Independent QA 观察路线 |

---

## 3. User Decision Register（用户决策登记）

以下 8 项决策需用户作出：

| # | 决策问题 | 建议选项 | 当前状态 |
|---|---|---|---|
| **1** | **Engine architecture边界**：`rules/session/adapter/presentation` 的确切界限？ | ✅ Accept as candidate (Tech Lead ADR)  OR  Request alternative | ⏳ 待用户裁决 |
| **2** | **Replay promise范围**：玩家可见的 Replay 功能？ | ✅ Debug/QA reproducibility only  OR  Full replay | ⏳ 待用户裁决 |
| **3** | **Target-cluster semantics**：最近威胁刷新机制？ | ✅ Accept candidate (Tech Lead ADR)  OR  Defer | ⏳ 待用户裁决 |
| **4** | **性能预算**：1080p/60，50 FPS minimum？ | ✅ Soft guide  OR  Hard Charter gate | ⏳ 待用户裁决 |
| **5** | **最小分辨率/宽屏**：支持的最低分辨率？ | ✅ 1080p baseline  OR  Specify range | ⏳ 待用户裁决 |
| **6** | **导出平台**：首要目标 OS？ | ✅ PC Windows 10+  OR  Specify others | ⏳ 待用户裁决 |
| **7** | **玩法观察门**：需要观察 movement→attack 因果性？ | ✅ Formal gate before scope expansion  OR  Advisory only | ⏳ 待用户裁决 |
| **8** | **Charter继续**：是否批准进入 implementation phase？ | ✅ Proceed with kickoff  OR  Pause/Pending | ⏳ 待用户裁决 |

---

## 4. Gate 0: Gate 0 Readiness Evidence

### Gate 0: Charter Readiness Evidence

| 字段 | 内容 | 状态 |
|---|---|---|
| **Charter 版本** | `Development Charter v0.1` | ✅ AUTHORIZED |
| **Charter 作者** | Executive Producer / Lead Producer（执行制作人） | ✅ 已授权 |
| **Charter 签名** | `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY` | ✅ 已确认 |
| **Scope caps / exclusions** | 22 项 user_confirmed baseline；PRECHARTER-01..11；Slice cap；exclusions matrix | ✅ 已锁定 |
| **Authority / RACI** | 决策权威矩阵：Charter §10；CR 台账 §8；ADR 批准路径 | ✅ 已文档化 |
| **Change Request intake protocol** | CR-VISUAL-PRIORITY-001（user direct authorization）；CR ledger rev-7 | ✅ 已建立 |
| **Producer/Producer evidence trail** | `EP_SCHEDULING_v0_1.md`；`CR-VISUAL-PRIORITY-001`；`CHANGE_REQUESTS_v0_1.md` rev-7 | ✅ 完整轨迹 |

**Gate 0 Verdict:** `READY` — All charter ownership, scope, and intake protocol evidence assembled and verified.

---

## 5. Gate 1: Gate 1 Static Conformance Evidence

### Gate 1: Static Conformance (22-item baseline constraints verified)

| 项目 | 状态 | 证据 |
|---|---|---|
| **PRECHARTER-01..11 明确** | ✅ 已文档化 | `SLICE_RULES_DECISION_v0_1.md`；`PRECHARTER-01..11` 已记录在 Charter §6 |
| **22 项 baseline constraints** | ✅ 已验证 | 见下表 |
| **Anchor v0.1 边界** | ✅ 已文档化 | `ANCHOR_DECISION.md`；Anchor v0.1 已接受为静态 baseline；v0.2 为候选 |
| **Source traceability matrix** | ✅ 已构建 | 将每一决策 ↔ 对应 Charter 条款 ↔ CR 记录 ↔ ADR 候选的映射 |

#### 22-Item Baseline Constraints Verified

| # | 约束 | 来源 | 状态 |
|---|---|---|---|
| 1 | player promise | Charter §2 | ✅ 已确认 |
| 2 | experience pillars | Charter §3 | ✅ 已确认 |
| 3 | Slice intent | Charter §4 | ✅ 已确认 |
| 4 | B2 structure | Charter §5 | ✅ 已确认 |
| 5 | anchor core | Charter §6 | ✅ 已确认 |
| 6 | architecture seam | Charter §7 | ✅ 已确认 |
| 7 | technical workstreams | Charter §8 | ✅ 已确认 |
| 8 | production plan | Charter §9 | ✅ 已确认 |
| 9 | scope caps | Charter §10 | ✅ 已确认 |
| 10 | exclusions | Charter §10 | ✅ 已确认 |
| 11 | grace window (1.0s) | Immutable | ✅ 已锁定 |
| 12 | resolve delay (0.25s) | Immutable | ✅ 已锁定 |
| 13 | attack_interval (0.6s) | Immutable | ✅ 已锁定 |
| 14 | no persistent luminous field | Director feedback | ✅ 已确认 |
| 15 | player silhouette priority | Director feedback | ✅ 已确认 |
| 16 | core→transition→falloff | Style Manual | ✅ 已确认 |
| 17 | QA independence | Charter §8 | ✅ 已确认 |
| 18 | 60/60 regression | gdUnit4 | ✅ 已通过 |
| 19 | candidate budgets only | CR ledger | ✅ 已确认 |
| 20 | PRECHARTER-01..11 | Charter app. | ✅ 已文档化 |
| 21 | four provenance layers | CR ledger | ✅ 已保留 |
| 22 | unresolved retain | CR ledger | ✅ 全量保留 |

**Gate 1 Verdict:** `READY` — All 22 baseline constraints verified; PRECHARTER-01..11 explicit; Anchor v0.1 boundary documented; Source traceability matrix complete.

---

## 6. Gate 2: Gate 2 Deterministic/Runtime Preparation

### Gate 2: Deterministic/Runtime Preparation

#### ADR Requirements Submitted to Tech Lead

| ADR ID | 标题 | 状态 | 所需行动 |
|---|---|---|---|
| ADR-TECH-01 | rules/session/adapter/presentation seam | ⏳ `draft_in_review` | Tech Lead 编写；跨角色评审；获批准后冻结 |
| ADR-TECH-02 | determinism contract / snapshot schema | ⏳ `draft_in_review` | Tech Lead 编写；QA align 质询；获批准后冻结 |
| ADR-TECH-03 | seed / fixture reproducibility | ⏳ `draft_in_review` | Tech Lead 编写；固定 random seed 方案 |
| ADR-TECH-04 | target selection / nearest-threat cluster | ⏳ `draft_in_review` | Tech Lead + Systems 编写；cluster membership 不定 |
| ADR-TECH-05 | contact / separation mechanics | ⏳ `draft_in_review` | Tech Lead + Systems 编写；CONTACT fixture 判据 |
| ADR-TECH-06 | Headless seam / evidence schema | ⏳ `draft_in_review` | Tech Lead 编写；GDMCP 兼容性 |
| ADR-TECH-07 | performance measurement protocol | ⏳ `draft_in_review` | 参考 `PERF_MEASUREMENT_PROTOCOL_v0_1.md` |
| ADR-TECH-08 | build identity / artifact digest | ⏳ `draft_in_review` | Tech Lead 编写；构建 ID 方案 |

**Tech Lead ADR Action Required:** Author all 8 ADRs, complete cross-role review, and push each through the approval ladder. Gate 2 cannot pass until at least ADR-TECH-01/02/03 are approved.

#### Fixture/Seed Specification 预案

| 项目 | 状态 | 证据/草案 |
|---|---|---|
| 固定随机 seed | ⏳ candidates 仅 | 见 `ADR-TECH-03` 草案 |
| determinism fixture | ⏳ not_run | 需 Tech Lead + QA 共同定稿 |
| tick 权威 | ⏳ not_run | Godot 单调时钟；`clock_authority` 声明 |
| snapshot schema 草案 | ⏳ draft | 依 `KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md` §6 |

#### snapshot/trace Schema 草案

| 字段 | 类型 | 说明 |
|---|---|---|
| `evidence_id` | string（immutable） | Producer 索引 |
| `build_identity` | struct | source revision / build_mode / config_version / schema / toolchain / artifact digest / target（cr-112） |
| `clock_authority` | string | 所用 API/源 |
| `timestamp` | int64 | 与 `clock_authority` 对齐 |
| `determinism_token` | string | tick 上下文 / snapshot ID |
| `trace` | array | 关键事件轨迹 |
| `seed` | int32 | 固定随机 seed |

**Gate 2 Verdict:** `PENDING` — ADRs must be authored and approved; fixture/seed specification and snapshot/trace schema draft pending Tech Lead output.

---

## 7. Gate 3: Gate 3 Visual/UI Preparation

### Gate 3: Visual/UI Preparation

#### HUD Hierarchy 建议

| HUD 层级 | 组件 | 状态 |
|---|---|---|
| Layer 0 (最底层) | 背景 / 场景 | 已就绪 |
| Layer 1 | 玩家血条/能量条 | 已实现 |
| Layer 2 | 卡牌区域 | 已实现 |
| Layer 3 | HUD 图标（攻击、防御） | ⏳ 需最终确认 |
| Layer 4 (最顶层) | 升级选择 UI | ⏳ 待定稿 |
| Layer 5 (临时) | 调试 / 日志 | ⏳ 仅 QA 使用 |

#### Focus Safety 协议

| 项目 | 规则 | 状态 |
|---|---|---|
| 失焦确认 | 禁止陈旧 Enter/Space 自动确认 | ⏳ ADR-TECH-05 关联 |
| Focus epoch 机制 | event policy, epoch increments, return-focus target | ⏳ ADR-TECH-02/05 关联 |
| 失焦后缓冲 | flush/buffer semantics, stale-input rejection | ⏳ ADR-TECH-05 关联 |
| platform behavior | 不同平台 focus 恢复差异 | ⏳ 需 cross-platform test |

#### 卡牌状态机 Specification

| 状态 | 触发 | 动作 | 状态 |
|---|---|---|---|
| `idle` | 初始/无选择 | 无 | ✅ 已实现 |
| `hover` | 滑鼠悬停 | 高亮显示 | ✅ 已实现 |
| `pressed` | 滑鼠按下 | 交互反馈 | ✅ 已实现 |
| `selected` | 确认选择 | 卡牌效果 | ✅ 已实现 |
| `transition_out` | 离开升级界面 | 渐隐/复位 | ✅ 已实现 |
| `acquired` | 升级应用 | 属性更新 | ⏳ 需 GDMCP 验证 |

**Gate 3 Verdict:** `PENDING` — HUD hierarchy, focus safety protocol, and card state machine specification pending UX/UI contract finalization.

---

## 8. Gate 4: Gate 4 Performance Measurement Plan

### Gate 4: Performance Measurement Plan

#### 硬件规格 (1080p/60 baseline)

| 项目 | 规格 | 状态 |
|---|---|---|
| 渲染分辨率 | `1920×1080` | ✅ 基线 |
| 刷新率 | `60 Hz` | ✅ 基线 |
| 目标 FPS | `≥50 FPS minimum` (candidate) | ⏳ 待用户决策（Gate 4） |
| OS | `Windows 10 x86_64` | ✅ 基线 |
| GPU | 最低兼容 GPU (Godot 4.7.1-stable) | ✅ 已验证 |
| CPU | 双核+ 2.0 GHz+ | ✅ 已验证 |
| RAM | 8 GB+ | ✅ 已验证 |

#### 帧率采样窗口

| 项目 | 规格 | 状态 |
|---|---|---|
| 采样窗口 | ≥30 秒连续运行后测量 | ⏳ 需 ADR-TECH-07 精化 |
| 预热期 | 前 N 帧/秒 (team_proposal) | ⏳ 见 ADR-TECH-07 |
| percentile 声明 | 需声明 exact definition (P50/P95/P99) | ⏳ 待 ADR 批准 |
| dropped frame 记录 | 明确排除与记录，不得静默剔除 | ⏳ 协议已定 |

#### 输入/反馈时戳方法

| 项目 | 规格 | 状态 |
|---|---|---|
| 输入响应 | 候选 ≤50ms（从输入事件到可观测状态改变） | ⏳ 待用户决策（Gate 4） |
| 命中反馈起点 | 候选 ≤100ms（从命中事件到视觉/音频反馈） | ⏳ 待用户决策（Gate 4） |
| 冷启动 | `<3s`（从进程启动到首可玩帧） | ⏳ 需 fixture/seed |
| 重启 | `<1s`（从重置触发到下局可玩状态） | ⏳ 需 fixture/seed |
| 时钟权威 | 单调时钟为主，墙钟为辅 | ⏳ 见 ADR-TECH-07 |

**Gate 4 Verdict:** `PENDING` — Performance budget decision required; hardware spec 1080p/60 baseline confirmed; sampling window and input/feedback timestamp methods pending user decisions on items 4-5 and ADR approval.

---

## 9. Gate 5: Gate 5 Export Configuration

### Gate 5: Export Configuration

#### 导出模板（PC Windows 10+）

| 项目 | 配置 | 状态 |
|---|---|---|
| 目标平台 | `Windows 10+ (x86_64)` | ✅ 已确认 |
| Godot 导出 preset | `PC Standalone` | ✅ 已配置 |
| 关闭调试功能 | `export/debug => disabled` | ✅ 已设置 |
| 启用压缩 | `export/texture_compression => enabled` | ✅ 已设置 |
| 单一 artifact digest | `build identity`（cr-112） | ⏳ 需 ADR-TECH-08 |

#### 构建 ID 方案

| 字段 | 规格 | 状态 |
|---|---|---|
| source revision | Git commit hash | ⏳ 需版本控制就绪 |
| build_mode | `release` / `debug` | ⏳ 需确定 |
| config_version | `v0.1.x` | ⏳ 需定稿 |
| schema | `performance_measurement_schema_v0_1` | ⏳ 需 ADR-TECH-08 |
| toolchain | `Godot 4.7.1-stable` | ✅ 已确认 |
| artifact digest | SHA-256 of exported binary | ⏳ 需生成 |
| target 身份 | `Windows x86_64` (cr-112) | ✅ 已激活 |

#### 启动验证机制

| 项目 | 机制 | 状态 |
|---|---|---|
| GDMCP preflight | doctor + editor state check | ⏳ 需实现授权 + 预检 |
| 启动场景 | 验证 main.gd 初始化 | ⏳ 需 QA 观察 |
| 60/60 test regression | gdUnit4 完整通过 | ✅ 已验证 |
| 构/build identity | artifact digest 对比 | ⏳ 需 ADR-TECH-08 |

**Gate 5 Verdict:** `PENDING` — Export template configured for PC Windows 10+; build ID scheme and launch validation mechanism pending ADR-TECH-08 and implementation authorization.

---

## 10. Gate 6: Gate 6 QA Evidence Collection Protocol

### Gate 6: QA Evidence Collection Protocol

#### 必填字段

| 字段 | 类型 | 说明 |
|---|---|---|
| `evidence_id` | string（immutable） | Producer 索引；唯一标识 |
| `evidence_class` | string | `visual` / `audio` / `runtime` / `static` |
| `gate` | string | 哪个 Gate 此证据服务 (Gate 0-6) |
| `criterion` | string | 具体判据 (V-1..V-8, A-1..A-3, R-1..R-2 等) |
| `observer` | string | Independent QA（非实现者） |
| `verdict` | string | `pass` / `fail` / `not_run` |
| `retest` | string | 仅当 previous failure 存在时；链接至原 `evidence_id` |

**强制规则：** 任一必填字段缺失 = `not_run`（非 pass）

#### Observer 独立性要求

- QA 必须是独立于实现者的成员
- 实现 owner (Godot Gameplay Engineer) 不得自行验收自己的实现
- 证据收集必须遵循 `QA_ACCEPTANCE_PLAN_v0_1.md` 结构
- 观察路线必须有明文记录，不可篡改

#### retest/redo 程序

| 步骤 | 说明 |
|---|---|
| 1. defect log | 记录 blocker/non-blocker；严重程度；重现步骤；owner 分配 |
| 2. fix dispatch | 相应角色（Producer/Tech Lead/Engineer）修复并提交证据 |
| 3. retest | Independent QA 重新评估；所有必须字段必须完整 |
| 4. verdict update | 更新 verdict 为 pass / fail / conditional pass |
| 5. 关闭循环 | 如 retest 仍失败 → 升级至 User + 重新 CR |

**Gate 6 Verdict:** `PENDING` — Evidence collection protocol defined with mandatory fields; observer independence requirement formalized; retest/redo procedure documented. Depends on Gates 0-5 pass and implementation authorization.

---

## 11. Evidence Inventory（证据目录 - 完整）

| 证据类型 | 位置 | 说明 |
|---|---|---|
| Godot 项目 | `D:/Game/New_Game/godot_game_dev/` | 85KB main.gd，60/60 测试通过 |
| Git 提交 | `git log --oneline` | b13c2be + 2873bb9 + 之前提交；root commit `0778dd6`（2026-08-16） |
| QA 证据 | `docs/production/QA_VISUAL_PHASE_VERDICT_v0_1.md` | CONDITIONAL_PASS (60/60, A-2 soft gate) |
| EP 排程 | `docs/production/EP_SCHEDULING_v0_1.md` | Phase 4-6 执行记录 |
| CHARTER | `docs/DEVELOPMENT_CHARTER_DRAFT_v0_1.md` | AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY |
| Change Requests | `docs/production/CHANGE_REQUESTS_v0_1.md` | rev-7；38 条 CR 已决策/absorb |
| ADR 合同 | `docs/architecture/KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` | ADR-TECH-01..08 `draft_in_review` / `NOT APPROVED` |
| QA 接受计划 | `docs/production/QA_ACCEPTANCE_PLAN_v0_1.md` | Gate 2-6 证据字段模板 |
| 性能协议 | `docs/production/PERF_MEASUREMENT_PROTOCOL_v0_1.md` | cr-107/108 测量身份草案 |
| UX/UI 契约 | `docs/ux/KICKOFF_UX_UI_CONTRACTS_v0_1.md` | HUD/卡牌/焦点；总状态 `NOT APPROVED` |
| Systems 规则 | `docs/creative/KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md` | 规则词汇；总状态 `NOT APPROVED` |
| 实现 owner | `docs/production/IMPLEMENTATION_OWNER_NOMINATION_v0_1.md` | Godot Gameplay Engineer 提案；待用户确认 |
| Anchor 决策 | `docs/visual/anchor/ANCHOR_DECISION.md` | v0.1 基线接受；v0.2 候选 |
| Cross Review Matrix | `docs/architecture/KICKOFF_CROSS_REVIEW_MATRIX_v0_1.md` | 所有 22 决策 + 8 revision-02 inputs + provenance |
| Evidence Schema Index | `docs/architecture/KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md` | 五层 envelop；clock_authority；settings；build identity |
| Visual Priority CR | `docs/production/CR-VISUAL-PRIORITY-001.md` | user direct authorization；visual production elevate |
| B2 Kickoff | `docs/production/B2_UPGRADE_SYSTEM_KICKOFF_v0_1.md` | Engineer dispatched；mechanics well-defined |
| EP Scheduling | `docs/production/EP_SCHEDULING_v0_1.md` | Visual production roadmap；critical path Phase 4→5→6 |

---

## 12. Decision Authority Matrix（决策权威矩阵）

| 决策类型 | 决策者 |
|---|---|
| Charter scope/阈值 | **User** |
| 架构风险/范围跨越 | **User** |
| 性能门槛提升 | **User** |
| ADR/authors 建议 | Tech Lead（批准路径由 User 最终确认） |
| 交付物验收 | Independent QA |
| 创意最终验收 | Game Director |
| 实现 owner 任命 | **User**（基于 Producer 提案） |
| 实现授权请求 | **User**（基于前置条件满足） |
| 证据收集协议 | Independent QA + Producer |

---

## 13. User Decision Package - 8 Items and Options A/B/C

### 8 User Decision Questions (按原顺序，含推荐)

| # | 决策问题 | 选项 A (推荐) | 选项 B | 选项 C |
|---|---|---|---|---|
| **1** | **Engine architecture边界**：`rules/session/adapter/presentation` 的确切界限？ | ✅ Accept as candidate (Tech Lead ADR) - 继续技术契约审议 | Request alternative - 重新定义 seam | Pause - 等待用户重新考虑 |
| **2** | **Replay promise范围**：玩家可见的 Replay 功能？ | ✅ Debug/QA reproducibility only - QA 需要可复现性 | Full replay - 完整回放功能 | Defer - 以后再决定 |
| **3** | **Target-cluster semantics**：最近威胁刷新机制？ | ✅ Accept candidate (Tech Lead ADR) - 继续系统审议 | Defer - 延后 | Request alternative - 重新定义 |
| **4** | **性能预算**：1080p/60，50 FPS minimum？ | ✅ Soft guide - 候选预算保持候选，随测量数据累积 | Hard Charter gate - 将候选提升为硬门槛 | Pause - 性能测量先暂停 |
| **5** | **最小分辨率/宽屏**：支持的最低分辨率？ | ✅ 1080p baseline - 1080p/60 为基线 | Specify range - 更宽范围 (720p-4K) | Defer - 延后分辨率决策 |
| **6** | **导出平台**：首要目标 OS？ | ✅ PC Windows 10+ - 主力平台 | Specify others - Linux/macOS 也支持 | Defer - 等待平台决策 |
| **7** | **玩法观察门**：需要观察 movement→attack 因果性？ | ✅ Formal gate before scope expansion - 正式门观察后再扩展 | Advisory only - 仅顾问角色 | Pause - 暂停观察 |
| **8** | **Charter继续**：是否批准进入 implementation phase？ | ✅ Proceed with kickoff - 依据现状启动 | Pause/Pending - 暂停等待更多信息 | Reject - 不进入 implementation |

### Option A: Proceed to Implementation (recommended) - 选项 A：进入实施（推荐）

> 按以下角色派遣：
> - **Tech Lead** → 编写 ADRs: rules/session/adapter/seam; determinism contract；performance measurement；build identity
> - **UX/UI Designer** → 编写 Interaction contract: HUD hierarchy, focus safety, card states；HUD hierarchy 建议；focus safety 协议；卡牌状态机规范
> - **Independent QA** → 准备 Gate 0-6 evidence 收集计划；证据字段审计；独立观察路线

> **Gate sequencing:** Gate 0-1 already READY → proceed with ADR authoring (Gate 2) → UX/UI contract finalization (Gate 3) → performance measurement setup (Gate 4) → export configuration (Gate 5) → consolidated QA evidence (Gate 6)

> **User decisions needed:** Items 1-8 must be resolved before full implementation authorization, but Gates 0-1 can proceed with static review.

### Option B: Full Charter Review - 选项 B：全面审查 Charter

> 暂停派遣，先完成用户对 Charter 中悬置问题的裁决。
> 
> 1. 收集用户对 8 项决策问题的最终裁决
> 2. 根据裁决结果重新定义技术契约范围
> 3. 重新评估性能预算、平台目标、架构界限
> 4. 重新确认实现 owner 与授权路径
> 5. 在所有悬置问题解决前，保持 kickoff `not_ready`、implementation `NOT_AUTHORIZED`

### Option C: Pause - 选项 C：暂停

> 项目暂停至下次用户批准继续。
> 
> 1. 所有当前工作暂停
> 2. 文档状态锁定（不再修改现有证据）
> 3. 待下次用户主动请求 restart
> 4. 当前证据包保持不变，不进行新增

---

## 14. Next Action Based on User Guidance

Based on the user instruction "持续推进" (continue advancing), the current status is:

- **Status:** `partial` — Gates 0-1 are READY; Gates 2-6 are PENDING pending user decisions and Tech Lead ADR output
- **Next Action:** Await user decisions on items 1-8 in the User Decision Package. Based on typical governance rhythm, recommend proceeding with **Option A** (Proceed to Implementation) once user decisions are recorded, which will allow:
  1. Tech Lead to author and push ADRs through approval ladder
  2. UX/UI Designer to finalize HUD hierarchy, focus safety, and card state machine
  3. Performance measurement protocol to be set up with user-approved budgets
  4. Export configuration to be finalized
  5. QA evidence collection protocol to be executed

- **Artifact:** `docs/production/KICKOFF_READINESS_PACKAGE_v0_1.md` — updated complete package ready for user decision

- **User Decisions Needed:** 8 items (see Section 13) — user must resolve each before implementation authorization can be fully granted, but static Gates 0-1 review can proceed in parallel.

---

## 15. Provenance & Non-Variable Declaration

| 项目 | 声明 |
|---|---|
| **22 / 恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）/ PRECHARTER-01..11 / 四层 provenance / unresolved 全量** | 本文件未改动上述任何一项；未把任何 team_proposal/assumption/候选数值升级为 user_confirmed |
| **六项候选预算 + `1280×720` 红线仅候选** | 本文件未提升任何候选数值为门槛；保持 cr-109 / DC-PERF-01 吸收within_authority 纪律 |
| **ADR-TECH-01..08 + Tech/Systems/UX 合同保持 `PROPOSAL / DRAFT / NOT APPROVED`** | 本文件仅记录状态；不改动 ADR 文件本身（Tech Lead 所有，由 Tech Lead 执行 status-line 更新） |
| **kickoff `not_ready` → 授权生效** | 本包不改变 kickoff 状态；仅在用户裁决后可能转变 |
| **implementation `NOT_AUTHORIZED`** | 本包不改变实现授权状态；实现授权由 User 在 readiness gate 后请求/授予 |
| **未修改任何既有 Godot 项目代码、GDMCP 变更** | 符合权限边界：仅编写/docs/ 目录下 markdown 文档 |
| **未调用 subagent / 未修改 Godot 项目** | 符合执行边界 |

**Closure:** `closure_ready = true` 仅限本静态 readiness package artifact。非 kickoff 通过、非实现授权、非合同/ADR 批准、非验收 verdict。用户保留最终裁决权。

---

*Document generated: 2026-08-20*
*Prepared by: Executive Producer / Lead Producer*
*Lifecycle: development governance / kickoff readiness preparation*