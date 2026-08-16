# QA AUDIT — PERF MEASUREMENT PROTOCOL v0.1（Independent QA 审计输入）

> **Status:** `AUDIT INPUT / PARTIAL-AUDITABLE / NOT A GATE VERDICT / NOT APPROVED / NO MEASUREMENT EXECUTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation `NOT_AUTHORIZED`；Gate 2/4 `not_run / not_ready`。
>
> **审计输入提供者:** Independent QA / Release Lead（`godot-qa-release-expert`）。**本文件是协议可执行性的审计输入，不是 Gate 4 verdict，不豁免任何未来 QA 门，不批准/冻结协议，不提升任何候选预算。**
>
> **审计对象:** `PERF_MEASUREMENT_PROTOCOL_v0_1.md`（Tech Lead 草案，166 行）。
>
> **层面:** 只评估协议「是否可审计、字段是否可执行、有无缺口」；不替 Tech 重写协议；不替用户做测量/门槛决策。
>
> **证据类别:** `static/source` only。未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布；未执行任何实际测量；未派发/扩展成员。

---

## 0. Actual start & expert capability evidence

- **Actual start（真实工具顺序）:**
  1. 第一条工具调用尝试读取目标协议失败（`Get-Content: Path not found`——路径错误为误输入 `D:\Game\game_new\...` 而非授权路径 `D:\Game\New_Game\...`；随后用授权路径成功读取）。
  2. `skill({ name: "godot-qa-release-expert" })` → **成功**（直接 `skill` 调用，无 `tools` 包装器；返回完整 SKILL.md 内容）。能力证据等级 = **`strong_direct_skill`**（运行时无 tools 包装器，等价直接 `skill` 成功）。
  3. 依次 `read` 审计对象与三份支撑文档，全部成功。
- **接口实测:** `skill` 工具在函数清单中未列（schema 无），但**实际发起调用成功**——复核实测纪律成立：不得仅凭清单判定不存在。未发生 unknown tool / 接口不存在错误。
- **Expert skill evidence:** 名称 `godot-qa-release-expert`；路径 `C:\Users\User\.agents\skills\godot-qa-release-expert\SKILL.md`；加载等级 `strong_direct_skill`；本章应用证据见 §1–§3（独立证据契约、诚实边界、evidence boundary 声明）。

---

## 1. Expert preflight（审计前声明）

- **审计范围:** cr-107 身份字段表（proto §3.2）足以唯一标识测量环境否；cr-108 采样窗口/percentile/时钟权威声明充分否；QA 审计点（proto §3.4/§4.6）在其工具链上可核验什么；与 Evidence schema align 缺口。
- **变更风险:** 协议为 `PROPOSAL / DRAFT / NOT APPROVED`；若审计位不可执行，未来 Gate 4 性能证据不可审计。
- **我方独立性边界:** 不替 Tech 定稿协议、不执行测量、不下 Gate verdict、不豁免未来 QA 门、不提升候选预算。
- **Top 审计假设（可被证否）:** (a) 协议要求「逐字段 + missing_evidence」已在文本层面到位但执行机制未定；(b) QA 审计点多数要求「QA 在真实样本上核验」，但样本已存在与否、原始样本格式/留存契约在草案中未定——构成可执行性缺口。
- **停止条件:** 产出本唯一审计文件并通读；不进入实现、不测量、不派发。
- **会阻断「auditable」判定的点:** 若「身份真实性」与「时钟权威真实性」无任何 QA 可执行的独立核验路径，且原始样本留存契约缺失，则协议签 `partial（列缺口）`。

---

## 2. 逐项审计

### 2.1 cr-107 身份字段（proto §3.2 / §3.3 / §3.4）

**已经在位（auditable）：**
- 类别覆盖 platform / OS / hardware / display / settings / build_identity 六维，`build_identity` 含 source revision / build_mode / config_version / schema / toolchain / artifact digest / target 身份（cr-112，P1 已激活）——覆盖 Evidence schema build_identity 要求。
- 「逐字段记录 + `missing_evidence`（非默认/假设）标注」（§3.3）与「不得用 `not_applicable` 掩盖缺失，除非注明理由」（§3.2 引），对齐 schema §6 条件字段纪律。
- **HiDPI 注记在位**：§3.2 分辨率行 + 附注明确「渲染分辨率 ≠ 窗口/物理分辨率」，引用 B.4 防「高 DPI 物理渲染冒充 1080p」式错配——此项到位。
- 「同设置跑两次」可复现性（§3.4 QA 确认）——可执行。

**缺口 / 风险：**
- **G1-settings 枚举不封闭**：settings 组「VSync、帧上限/cap、垂直同步策略、抗锯齿、后处理开关」以「等」收尾，未定义哪些字段为**强制项**、哪些为可选。若某些设置非强制，则无法排除「静默未记录但影响测量」的缺失。
- **G2-「如可取得」软化词**：cpu TDP/睿频、ram 频率/通道以「如可取得」限定——可将缺失悄悄落到「不可取得」而非 `missing_evidence`（绕过逐字段纪律）。需一个判定：不可取得时也必须落 `missing_evidence`。
- **G3-身份真实性核验机制未定**：§3.4「QA 观察身份真实性；Tech 不能自证」提出了原则，但未指定 QA 在工具链上以何方式核验硬件/OS 身份真实性（OS/驱动查询路径、与记录的比对点）。QA 当前只能核验**记录形状**，不能核验**机器真实值**。

### 2.2 cr-108 采样方法、percentile、时钟权威（proto §4.1–§4.6）

**已经在位（auditable）：**
- 采样窗口（预热/时长/采样率/dropped·暂停排除）四项齐备（§4.1），「必须记录」防止静默剔除——到位。
- **percentile 精确定义要求醒目**：§4.2 强制声明 P50/P95/P99 + nearest-rank/线性插值 + min/max/均值/标准差/样本数/dropped 数，且明确「percentile 含义决定数字含义」「候选数值必须与明确 percentile 绑定才可比较」——这是 cr-108 核心，到位。
- 比较默认**零容差**（§4.2 引 O2/B3），「命名授权偏差才允许容差」——与 R06/R07 一致，无 `close enough`。
- **时钟权威纪律到位**：§4.4 单调为主/墙钟为辅 + 声明 API/源/粒度/漂移 + `timestamp` 无 `clock_authority` 即不完整——对齐 schema `clock_authority`。
- settings 行（§4.5）+ `tick_context` + `config_version` 与 build_identity 构成可复现性——到位。

**缺口 / 风险：**
- **G4-dropped「剔除」判定者未定**：§4.1「不可复现场景是否剔除」无「谁判定可复现、剔除如何标注」的执行契约。虽「必须记录」在文本上防静默，但剔除边界本身需定。
- **G5-时钟权威真实性 QA 可执行性未定**：亚毫秒/毫秒级（≤50ms 输入、≤100ms 命中反馈）时序主张依赖时钟粒度/单调性；QA 需能核验所用时钟 API/源与粒度确如声明。草案只列「QA 审计确认……是否声明且一致」，未给 QA 核验时钟真实性的方法。
- **G6-原始样本留存契约缺失**：§4.6 QA 问「原始样本是否保留（raw samples + percentile 记录）」，但草案未定义 raw samples 的**构成/格式/与 evidence_id 的链接/留存位置**（schema index 尚为提案未冻结）。QA 无法核验「保留了原始样本」这句话的满足者是谁、以何证据自证。

### 2.3 QA 审计点可执行性（proto §3.4 / §4.6）

**QA 在当前工具链上能核验什么（静态层面，无样本可核）：**
- 记录形状：字段是否齐全、`missing_evidence` 是否被静默填充（对照 §3.2 表）、settings 是否足以复现、percentile/时钟权威是否声明且一致、比较是否零容差、dropped 是否记录。
- 对齐面：`evidence_id` 不可变、`timestamp`+`clock_authority`、`settings` 组、`retest_of` 链是否与 schema 一致。

**当前不可执行 / 缺失的审计位：**
- 在**无真实样本、无原始样本契约、无样本在途或已存在证据**的前提下，QA 审计点多数只能以「记录形状」审核执行，无法以「对真实样本的独立核验/重测」执行——这是评估它们可执行性的关键限制。
- **缺失审计位 1**：无原始样本既存/格式/链接核对（见 G6），QA 无法确认「保留」成立。
- **缺失审计位 2**：无身份（硬件/OS）真实性与时钟真实性独立核验点（见 G3/G5）。
- **缺失审计位 3**：schema 层有 `run_id`（schema §6 `run_id` = run-scoped 执行上下文）但协议身份表未显式收纳 `run_id`——QA 无法逐 run 归属样本/绑定执行上下文（G7，见 §2.4）。

### 2.4 与 Evidence schema 对齐

- **对齐良好：** `clock_authority`（§4.4）、`settings` 条件组（§4.5 + cr-107 §3.2）、`timestamp` 配 clock（§3.3）、`evidence_id` 不可变 + 追加式（§3.3）、`retest_of`/不覆盖原始失败（§3.3）——均与 schema §4/§6/§8 一致。
- **G7-run_id 缺位**：schema `run_id`（执行上下文）未在同名身份表中显式收纳（仅在 §4.5 `tick_context` 提及）。无 run_id 则同一 evidence_id 下多次采样窗口的执行上下文归属不清，QA 无法判定「同设置跑两次」是否确为独立 run。
- **G8-`not_applicable` 纪律一致但无执行实例**：schema 要求条件字段 present 或 `not_applicable`+理由；协议文本对齐，但「不可取得」软化词（G2）与 `not_applicable` 的判界未给 QA 可执行准则。

---

## 3. 审计结论

### 判定：`partial`（协议文本层面的可审计性到位，执行契约层面存在缺口）

**依据分层：**
- **auditable（已具备）：** cr-107 六维身份 + build_identity（含 cr-112 target 身份）+ missing_evidence 纪律 + HiDPI 渲染分辨率注记；cr-108 采样窗口四分 + **percentile 精确定义强制声明** + 零容差（O2/B3）+ 时钟权威单调为主/墙钟为辅 + settings 行/tick_context/config_version；与 Evidence schema 在 clock_authority/settings/timestamp/evidence_id/retest_of 六处对齐。
- **partial（缺口，各自导致对该点无法完全以 QA 执行的核验）：**
  - G1 settings 枚举不封闭（须分强制/可选）；
  - G2 「如可取得」软化词可绕过 missing_evidence（须判界）；
  - G3 身份真实性 QA 独立核验路径未定；
  - G4 dropped「剔除」判定者/标注契约未定；
  - G5 时钟真实性 QA 可执行性未定（对 ≤50ms/≤100ms 亚毫秒·毫秒时序关键）；
  - G6 原始样本构成/格式/链接/留存契约缺失（schema index 未冻结）；
  - G7 `run_id` 未收纳于身份表；
  - G8 `not_applicable` 判界无 QA 可执行准则。
- **blocked（无）：** 未发现令协议「完全不可审计」的硬性失能；所有缺口是可补的执行契约，属 Tech 在授权后精化或由 Producer/QA 在批准路径中补齐的范畴。**但评估须诚实声明：在缺口未补、且「无真实样本、无测量执行」的前提下，本审计对协议的评价只能锚定在「记录形状/文本承诺」层，不能预支对真实样本的独立核验结论。**

**每项依据：** 逐条见 §2.1–§2.4。

---

## 4. 明确边界声明（Independent QA 独立审计边界）

- **本文件是协议可执行性的审计输入，不是 Gate 4 verdict**；独立 QA 未曾、也不会在本审计内通过或提升 Gate 4 —— Gate 4 `not_run / not_ready` 维持不变。
- **不豁免未来 QA 门**：本审计不授予任何未来性能/验收 pass；不豁免 QA blocker。
- **协议未获批准**：`PERF_MEASUREMENT_PROTOCOL_v0_1.md` 及其 cr-107/108 相关机制保持 `PROPOSAL / DRAFT / NOT APPROVED`；本审计不批准/冻结它。
- **候选预算未提升**：六项候选预算（1080p/60、50 FPS、≤50ms、≤100ms、<3s、<1s）与 `1280×720` 红线全部保持**仅候选**，均未被本审计提升为门槛；任何候选 → 正式门槛仍须 CR + 用户批准。
- **未执行任何实际测量**：本审计基于 static/source 文档比对；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布；未派发/扩展任何成员。
- **不替用户/ Tech 决策**：不选 percentile 值、不选采样窗口数值、不选时钟源 API、不重写协议；这些均保持 `unresolved` / 由 Tech 在授权后精化并呈交。

---

## 5. Provenance & invariants

- **user_confirmed（引用，不重投）:** 22 原始决策；恰好 8 项 canonical revision-02 inputs + 独立 Charter authorization record（无第九项）；PRECHARTER-01..11；四层 provenance；R04（候选预算保持候选、cr-107/108 以测量身份推进）；AUTH-01；Batch 1/2/3（P1/A1/Option 2/Option A/A2/B3/O2/…）。
- **team_proposal / assumption / unresolved:** 协议全部机制内容为 Tech 提案；本审计对「审计点是否可执行/有无缺口」的结论为 QA 审计输入（team_proposal，供 cr-107/108 参考）；具体 percentile 值、采样窗口数值、时钟源 API、真实样本等保持 `unresolved` 未关闭。
- **不变量保留:** 本文件不改变 22/8+1/PRECHARTER-01..11/四层 provenance/unresolved 全量；未提升任何候选预算；未触碰协议/CR ledger/evidence schema/合同/ADR（仅本审计文件为唯一新增）。

---

## 6. 本审计是否闭合

- **closure_ready = yes，仅针对本静态审计输入文件**（供 cr-107/108 协议草案在授权后的精化与 QA 审计位设计和未来 Gate 4 独立观察引用）。
- **非** kickoff 通过、非测量授权、非协议批准、非 Gate 4 verdict、非性能验收、非任何候选门槛提升。
