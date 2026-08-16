# PERF MEASUREMENT PROTOCOL v0.1 — 方向 2d：cr-107 / cr-108 性能测量协议草案

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`。
>
> **Owner (sole author):** Tech Lead（`godot-tech-lead-expert`）——按 CR ledger §4（cr-107/cr-108，`absorb_within_authority`：Tech 提案 + QA 审计）与 DC-PERF-01 → Option A（R04）推进 cr-107/108 为**测量身份**（protocol），而非测量本身。
>
> **本文件是什么：** 为 cr-107（命名硬件基线：OS/硬件/设置身份字段 + 记录要求）与 cr-108（采样方法：窗口、percentile 定义、时钟权威、settings 行——对齐 Evidence schema）产出**测量协议草案**；明确「测量身份 ≠ 门槛」；标注 QA 审计输入点；记录执行须待实现授权（当前 `NOT_AUTHORIZED`）。
>
> **本文件不是什么：** 不是性能测量执行/运行；不是门槛、验收、发布承诺；不把任何候选预算提升为正式门槛；不替用户决策（候选→门槛必须走 CR + 用户批准）；不豁免 QA blocker；不替 Independent QA 下 verdict。
>
> **证据类别：** `static/source` only。未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布；未派发任何成员。

---

## 1. 目标、授权与不变量

### 1.1 授权衔接（引用，不重投）

- **DC-PERF-01 → Option A**（R04，2026-08-16，`user_confirmed`）：六项候选预算**全部保持仅候选**；cr-107/108 **以测量身份推进**（Tech 提案 + QA 审计）；测量后以新 CR 重新提案（cr-109 再次呈交用户）。
- **cr-107**（`absorb_within_authority`）：命名硬件/OS/settings 基线——Tech Lead 提案协议；QA 审计；承诺化 → 升级 cr-109。
- **cr-108**（`absorb_within_authority`）：采样方法与 percentile / 时钟权威——Tech Lead 提案；QA 审计；硬门槛化 → cr-109 升级。
- **DC-PLAT-01 → P1**（R01）：`Windows x86_64` 单一导出 + artifact digest / build identity；本期不发布。
- **cr-112**（build identity，P1 后已激活 target 身份字段）：测量构建与日志需身份字段。
- **cr-113 → DC-REL-01 O2**（R07，零容差为 QA 职权内证据规则）；**cr-114 → DC-ACC-02 B3**（R06，证据收紧）——比较默认零容差，命名授权偏差才允许容差。

### 1.2 不变量保留声明

- **22 项原始 `user_confirmed`**、**恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）**、**PRECHARTER-01..11**、**四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）、**unresolved 全量保留**——本协议不把任何 unresolved 项升级为决策。
- 候选预算 = `1080p/60`、`50 FPS minimum`、input `≤50ms`、hit-feedback start `≤100ms`、cold start `<3s`、restart `<1s`。**全部仅候选，须经 CR + 用户批准才成为正式门槛**（本协议不提升任何一项；`1280×720` 红线亦仅候选）。
- 本协议不批准/冻结任何 ADR 或合同（ADR-TECH-01..08 及 Tech/Systems/UX 合同保持 `PROPOSAL / DRAFT / NOT APPROVED`）。

### 1.3 只读来源（evidence = static/source only）

1. `docs/architecture/KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（ADR-TECH-07 测量协议模板、ADR-TECH-08 build identity）。
2. `docs/production/CHANGE_REQUESTS_v0_1.md`（§4 cr-107/108/109；§8.1 R01–R03；§8.3 R04–R07；AUTH-01）。
3. `docs/production/CARDS_DC_PERF_01_OPTIONS_v0_1.md`（DC-PERF-01 Option A 决策内容；附节 B HiDPI/B.4 settings 行要求、B.2 字体 scale 风险、B.7）。
4. `docs/architecture/KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md`（采样/percentile/时钟权威相关：`clock_authority`、`settings`、`timestamp`、`performance` evidence class、exact compare 行为）。
5. `docs/production/DC_SYS_01_TECH_INPUT_v0_1.md`（确定性机制输入，仅供 ADR-TECH-03/04 衔接参考，非测量输入）。

未读取任何其它文档。**Systems 提案 `PROPOSALS_CR002_004_005_v0_1.md` 在本任务读取集内未达（文件缺失 2026-08-16）**——测量场景输入（密度/弧/输入路径/启动/重起点）归 Systems/UX 语义，本协议标记为父协调器在途、不代做。

---

## 2. 测量身份 vs 门槛（核心声明）

> **「测量身份 ≠ 门槛」：** 本协议定义的是**如何测量与如何做可审计记录**（identity + method），**不是**任何数值应当通过。六项候选预算与 `1280×720` 红线**仅候选**（Options A，R04）：本协议产出的 raw samples、percentile、时钟权威记录**只作为测量身份与证据输入**；它们不能自行把候选数字变成 Gate 4 判据、验收条件或发布承诺。任何候选 → 正式门槛的提升必须**先经 CR + 用户批准**（cr-109 在测量后以新 CR 重新呈交）。
>
> **执行前置：** 任何实际测量运行均须**实现授权**（当前 kickoff `not_ready`、implementation `NOT_AUTHORIZED`、Gate 2/4 `not_run / not_ready`）。本协议只定草案，不执行。

---

## 3. cr-107 — 命名硬件基线（named hardware/OS/settings baseline）

### 3.1 目的与边界

- **目的：** 使每次性能样本可审计——同一数字在不同硬件/OS/设置下含义不同；无身份证的样本不可比较、不可作为证据。
- **边界：** 命名硬件**属于测量身份**（Tech 提案 + QA 审计）。**若硬件规格进入发布承诺/发布文案/Gate 判据 → 升级 cr-109**（CR ledger §4 cr-107 行）。P1 本期不发布，故近期无承诺化压力。

### 3.2 身份字段（对齐 `KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT §4.1/§6`: `platform/os/hardware/settings` 条件字段）

每个性能样本记录必须携带（显式、可验、不得用 `not_applicable` 掩盖缺失，除非注明理由）：

| 类别 | 字段 | 记录要求 |
|---|---|---|
| 平台 | `platform_target` | 单一 Windows x86_64（P1）；记录是否 x64 架构 |
| OS | `os_name` | 命名 OS 及精确版本（如 Windows 10/11 build 号），**不得**只写「Windows」 |
| OS | `os_build`, `os_edition` | build 号与版本（如 22H2/23H2）当可取得；`power_mode`（平衡/高性能/游戏模式等） |
| 硬件 | `cpu` | 型号 + 核心/线程数 + TDP/睿频档（如可取得） |
| 硬件 | `gpu` | 型号 + VRAM + 驱动版本（driver version） |
| 硬件 | `ram` | 容量 + 频率/通道（如可取得） |
| 硬件 | `display` | 分辨率 + 刷新率 + 缩放（scale %）；屏显/独占/无边框窗口模式 |
| 设置 | `resolution` | **渲染分辨率 ≠ 窗口/物理分辨率**（见附注 B.4）：记录实际渲染分辨率与呈现分辨率 |
| 设置 | `renderer` / settings | renderer/后端 + 关键设置（VSync、帧上限/cap、垂直同步策略、抗锯齿、后处理开关） |
| 设置 | `window_mode` | 窗口化 / 无边框 / 独占全屏 |
| 构建身份 | `build_identity` | source revision / build_mode / config_version / schema / toolchain / artifact digest / **target 身份（cr-112，P1 已激活）**——每次测量对应一份构建 |

> **附注（HiDPI 错配，来自 `CARDS_DC_PERF_01_OPTIONS_v0_1.md` 附节 B.4）：** 命名设置必须声明渲染分辨率，避免「高 DPI 物理渲染冒充 1080p」式错配；`1080p/60` 候选测量须记录窗口/渲染分辨率。

### 3.3 记录要求

- 每样本带**唯一 `evidence_id`**（immutable，Producer 索引）+ `build_identity`。
- 硬件/OS/设置 **逐字段**记录，缺失项以 `missing_evidence`（而非默认/假设）标注。
- `timestamp` 必须配 `clock_authority`（见 §4.4），否则时间声明不完整（Evidence schema §6）。
- 记录追加式：修正产生新 `evidence_id` 与 `retest_of` 链接，不覆盖原始失败/差异。

### 3.4 QA 审计输入点（cr-107）

QA 审计确认：身份字段是否齐全、是否有 `missing_evidence` 被静默填充、`settings` 是否足以复现（同设置跑两次）。QA 观察身份真实性；Tech 不能自证。

---

## 4. cr-108 — 采样方法、percentile 定义、时钟权威

### 4.1 采样窗口（sampling window）

| 项 | 提案（team_proposal） |
|---|---|
| 预热 | 命名窗口或 tick 数（如固定时长/固定帧数）后才开始采样；记录预热做法 |
| 采样时长 | 命名秒数或帧数（如 ≥N 秒 / ≥M 帧）；记录窗口起点/终点 tick 或钟时 |
| 采样率 | 每逻辑帧采样一次 + 可选更高频（原始输入/命中起点另行记录） |
| dropped / 暂停 | 明确排除与记录：丢帧、暂停（focus 丢失/升级 pause）、不可复现场景是否剔除，必须记录，不得静默剔除 |

- 采样窗口归属 Tech 提案；具体阈值数值在 cr-108 协议定稿前为 `team_proposal`，非门槛。

### 4.2 percentile / 统计定义

- **须声明所指 percentile 的精确定义**：如 `P50`/`P95`/`P99`（nearest-rank 或线性插值方案须写明），以及 min/max、均值、标准差、样本数、dropped 数。
- **percentile 含义决定数字含义**（CR §4 cr-108：「percentile/采样定义决定数字含义」）：同一组样本用不同 percentile/方法会得到不同数字——因此候选数值（如 `50 FPS minimum`、`≤50ms`）**必须**与明确 percentile 定义绑定才能被比较。本协议不选 percentiles，仅要求每次样本声明它们。
- 比较默认**零容差**（O2/B3）：除非命名授权偏差被正式记录并链接，否则无容差、无「close enough」。

### 4.3 各被测量的「计时/观测定义」

| 被测量 | 计时/观测定义（待实现授权后精化） |
|---|---|
| 输入响应（候选 ≤50ms） | 定义「输入到可观测状态改变」的起点（输入事件 tick/钟时）与终点（命中/反馈可观测点）；记录 `input` 方法 |
| 命中反馈起点（候选 ≤100ms） | 定义「命中反馈起点的 timestamp」：伤害应用 vs 视觉/音频反馈的边界；记录 `feedback` 方法 |
| 冷启动 <3s | 定义「启动起点」（进程/第一帧/场景加载完成）与终点（首个可玩帧）；命名显示/窗口初始化是否计入 |
| 重启 <1s | 定义「重启起点」（触发点）与终点（下一局可玩状态）；同机 canonical reset |
| 帧率/输出底线对（1080p/60, 50 FPS minimum） | 帧时间（frame time）采样，声明 window + percentile + 是否存在锁帧/可变刷新 |

### 4.4 时钟权威（clock authority）

- **单调时钟为主，墙钟为辅**（对齐 Evidence schema `clock_authority` 字段）：帧时间、间隔、采样窗口一律用**单调时钟**（不受系统时间调整影响的单调源）；仅事件起始/索引用墙钟 + 时区/格式。
- **每次样本必须声明时钟权威**：所用 API/源（如 Godot 单调时钟/平台单调计数器）、粒度、是否可能漂移；`timestamp` 无 `clock_authority` 即不完整（Evidence schema §6）。
- 时钟权威选择属 Tech 提案 + QA 审计；是否足以支撑「命中反馈起点」等亚毫秒/毫秒级时序须审计确认。

### 4.5 settings 行（对齐 Evidence schema）

settings 行与 cr-107 §3.2 的「设置」组一致：分辨率/renderer/窗口模式/VSync/帧上限/后处理；同时记录 `tick_context`（如固定步频率，若影响测量）与 `config_version`。settings 行与 build identity 一起构成测量可复现性。

### 4.6 QA 审计输入点（cr-108）

QA 确认：采样窗口/percentile/时钟权威是否声明且一致；是否有静默 dropped、默认容差、`close enough` 比较；原始样本是否保留（raw samples + percentile 记录）；`settings` 行是否与构建身份唯一对应。

---

## 5. 执行前置与 Gate 边界

- 本草案**不构成测量授权**。任何实际测量须：实现已授权（kickoff readiness 满足、Gate 2 授权）、含构建身份的授权构建存在、命名硬件基线记录的测量机就绪、cr-108 方法已按授权精化、QA 审计位就绪。
- Gate 4（性能）`not_run / not_ready`；本协议任何内容不能把 `not_run` 变为 pass，不能替代 QA 独立观察。
- 六项候选预算与 `1280×720` 红线全部**仅候选，须经 CR + 用户批准才成为正式门槛**；本协议测量后由 Tech 以**新 CR** 重新提案（cr-109 再次呈交用户）。

---

## 6. Provenance 分层

- **`user_confirmed`（引用，不重投）：** 22 决策；revision-02 8 项 + 独立授权；PRECHARTER-01..11；AUTH-01；Batch1/2/3 决策（P1 / A1 / Option 2 / Option A / A2 / B3 / O2 / Option 2 / cr-001 Option A）；R04（候选预算保持候选、cr-107/108 测量身份推进）。
- **`team_proposal`：** 本协议全部机制性内容（身份字段、采样窗口、percentile 声明要求、时钟权威纪律、settings 行、QA 审计点）。
- **`assumption`：** 单调时钟可用；单一固定步边界可支撑采样；P1 单 Windows target 下命名设置足够收敛矩阵。
- **`unresolved`（未关闭）：** 具体 percentile 值/P 值选择、采样窗口数值、时钟源 API 细节、输入/反馈起点精确定义、测量机采购/配置、场景输入内容（Systems/UX 语义）、任何候选数字的门槛化 —— 全部保持 open，测量后按授权精化并呈交。

---

## 7. 不变量保留

22 / 8+1 / PRECHARTER-01..11 / 四层 provenance / unresolved 全量保留；六项候选预算 + `1280×720` 红线均未被本文件提升；ADR-TECH-01..08 与 Tech/Systems/UX 合同保持 `PROPOSAL / DRAFT / NOT APPROVED`；kickoff `not_ready`；implementation `NOT_AUTHORIZED`；Gate 2/4 `not_run / not_ready`。

---

## 8. 边界声明与 closure

- 未执行任何实际测量；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未派发/扩展成员；未修改任何既有文档（本文件为**唯一新产物**）。
- 未提升任何候选数值为门槛；未替用户做决策；未豁免 QA blocker；未替 Independent QA 下 verdict；未授权测量/实现。
- **Closure：** `closure_ready = yes` **仅针对本静态测量协议草案**（供 cr-107/108 提案引用、供 QA 审计）；不是 kickoff 通过、不是测量授权、不是合同批准、不是性能验收。
