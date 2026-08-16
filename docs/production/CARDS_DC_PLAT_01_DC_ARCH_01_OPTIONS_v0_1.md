# BATCH 1 DECISION-CARD OPTIONS — DC-PLAT-01 & DC-ARCH-01 v0.1

> **PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED**
>
> **Owner (sole author):** Tech Lead — 选项制备（选项包）。**本文件不替用户做任何最终决策；不批准/冻结任何合同、ADR、平台或发布承诺；不升级任何 `team_proposal`/`assumption`/`unresolved`。**
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；Charter v0.1 `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY`；kickoff `not_ready`；implementation `NOT_AUTHORIZED`；Gate 0/1 = `ready_for_next_review`（仅静态复审）；Gate 2–6 = `not_run / not_ready`。
>
> **Evidence class:** `static/source` only。无 runtime / build / test / QA-execution / performance / export / release 证据。

---

## 0. 本文档声明（前置不变式与证据边界）

1. **不变量保留：** 22 项原始 `user_confirmed` 决策（Charter §6）；**恰好 8 项** canonical `v0.1-revision-02` 输入 + **独立**的当前 Charter authorization record（无第九项）；`PRECHARTER-01..11`；四层 provenance（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）；**全部 unresolved 保留 unresolved**。本文件不关闭任何一项。
2. **候选预算状态（重复记录）：** `1080p/60`、`50 FPS minimum`、input `≤50ms`、hit-feedback start `≤100ms`、cold start `<3s`、restart `<1s` 均为**候选预算**（Charter §6；PRECHARTER-10；revision-02 #7；ADR-TECH-07），非门槛、非观测结果、非发布承诺。**本卡任何涉及处需标注**：「仅候选，须经 CR + 用户批准才成为正式门槛」。性能门槛归属 DC-PERF-01（cr-109），不在本卡，仅可引用。
3. **Tech/Systems/UX 合同状态：** `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`、`KICKOFF_SYSTEMS_RULES_CONTRACTS_v0_1.md`、`KICKOFF_UX_UI_CONTRACTS_v0_1.md`、`KICKOFF_CROSS_REVIEW_MATRIX_v0_1.md` 均为 `PROPOSAL / DRAFT / NOT APPROVED`。本文件不改变该状态。
4. **证据来源（实际读取，`static/source`）：** `DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（Charter §2.1/§6/§12）；`architecture/KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（ADR-TECH-01/02/08 及决策表、unresolved registers 第 3/12/14 节）；`architecture/KICKOFF_CROSS_REVIEW_MATRIX_v0_1.md`（seam/ownership §3–§4、unresolved register §8）；`production/CHANGE_REQUESTS_v0_1.md`（cr-101/102/103、cr-201 登记与处置、§7 批次、§8 卡片结构）；`ux/KICKOFF_UX_UI_CONTRACTS_v0_1.md` §7（分辨率/宽屏对平台选项的输入）。
5. **编写边界：** 本文件为唯一新建产物；未修改任何既有文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未批准合同或 ADR；未豁免 QA blocker；未替 Independent QA 下 verdict；未替用户做最终决策。

---

# CARD 1 — DC-PLAT-01

```text
Card ID:                 DC-PLAT-01
待决项:                  cr-101（OS 平台目标）+ cr-102（导出目标）+ cr-103（发布平台/渠道与本期发布姿态）合并为一个决策包。
                         当前状态：
                         - cr-101：revision-02 #8「Retain PC-first… No named OS」（Charter 决策 #18/21）；影响工具链、QA 矩阵、
                           性能/导出验证成本、一切下游证据身份 — `unresolved` / `user_reserved`。
                         - cr-102：export target / artifact requirements unresolved；Gate 5 export smoke 判据依赖目标身份；
                           依赖 cr-101 — `unresolved`。
                         - cr-103：无命名发布平台/渠道；决定 Gate 6 与发布范围；依赖 cr-101/102；发布阈值另见 cr-113（不在本卡）— `unresolved`。
候选预算关联:            如选项涉及 1080p/60 等数值，仅作方向性引用（当前为「仅候选，须经 CR + 用户批准才成为正式门槛」），
                         正式性能门槛属 DC-PERF-01（cr-109），不在此卡决定。
输入依赖:                UX/UI 分辨率输入（cr-104/105 → DC-PLAT-02）：16:9 基线 + common widescreen 候选（决策 #18；UX §7），
                         最低分辨率与支持集为 reserved thresholds，本卡不代定。Toolchain 身份输入（cr-112）：build identity 规则
                         由 Tech + Toolchain 提案，本卡选定 OS/导出目标后激活其 target 身份字段。
选项（3 个，精准、互斥）: 每个选项 = 命名 OS 集合 × 导出目标形态 × 发布平台渠道与本期发布姿态 的完整一致姿态；
                         三选项在至少一个维度上彼此不能并存（互斥）。
```

## Option P1 — 「Windows-only 最小验证姿态」（Win 单包导出 · 本期不发布）

- **名称：** 命名 OS = Windows（x86_64）单一集合；导出 = 单个 Windows 打包产物（可执行 + 数据目录，含 artifact digest / build identity）；本期发布姿态 = **不发布**（Gate 6 按内部复审姿态执行，无商店/渠道承诺）。
- **依据：** 当前 direction 为 PC-first、键盘、16:9 基线（Charter 决策 #18/21；revision-02 #8）且「No named OS」——本选项为把未命名 OS 收敛到最少集合的最窄收窄；cr-103 待决「本期是否承诺发布」在本选项下明确为「不发布」，规避一切渠道与发布文案范围；Gate 5 导出 smoke 获得单一目标身份（依赖 cr-102 以此形态落定）。
- **影响：**
  - 产品：唯一影响为可运行平台面收窄至 Windows；对 Slice 玩法承诺无改变（PC-first 已确认）。
  - 创意：无创意影响；演示/评审范围不变。
  - 技术：工具链与 QA 矩阵最小（单 OS、单 target identity）；性能/导出验证成本最低；一切下游证据身份以 Windows 为锚。
  - 范围：不新增任何平台/渠道/发布承诺；严格保持 Slice caps。
  - 进度：Gate 5 判据最短路径可定义；后续可随时加宽（见风险回滚）。
- **风险：** 发布姿态若实际需要 Linux/macOS 或商店渠道，需在 Gate 6 前重开 cr-101/103（CR + 用户）——回滚/加宽成本低：未承诺前切换仅重跑导出 smoke 与 QA 矩阵扩展；验证成本 = 单 target export smoke + 单 OS 启动/重启证据。
- **候选预算相关：** 不涉及新数值；如后续引用 1080p/60 性能目标，须标注「仅候选，须经 CR + 用户批准才成为正式门槛」并归 DC-PERF-01。

## Option P2 — 「PC 双平台（Windows + Linux）验证姿态」（双包导出 · 本期不发布/可选免费演示渠道）

- **名称：** 命名 OS = Windows + Linux 两个集合；导出 = 双平台产物集（每 target 独立 artifact + build identity）；本期发布姿态 = **默认不发布**，保留「可选免商店免费演示渠道（如 itch.io 自托管）」为显式候选，仍待用户单独确认 cr-103 渠道选择。
- **依据：** PC-first 方向（决策 #21；revision-02 #8）未排除 Linux；common widescreen 为候选支持集（决策 #18；UX §7）说明支持面可按候选扩展；cr-102 未定型前双 target 使 Gate 5 判据覆盖更宽；免费演示渠道不引入商店审核/阈值承诺，与 cr-113（发布阈值）解耦。
- **影响：**
  - 产品：玩家面从单一 OS 扩至两类 PC OS；对玩法承诺无改变。
  - 创意：无创意影响；渠道候选（若选择）改变交付呈现姿态（可被公开试玩）。
  - 技术：工具链需双 target 导出配置与双 artifact 身份；QA 矩阵约倍增（双 OS 启动/重启/输入/窗口证据）；Linux 图形/输入差异进入风险面。
  - 范围：显式扩展平台面；渠道仍为非承诺候选（不增加商店承诺）。
  - 进度：导出与 QA 排期增加；Gate 5 判据需按双 target 定义。
- **风险：** Linux 输入/窗口/驱动差异可能导致额外调试；公开免费演示（若选）触发外部接触面（无付费，但需渠道物料）——回滚：渠道候选未启用前删除即零成本；启用后回滚 = 下架并保留内部验证姿态，验证成本 = 双 target export smoke + 双 OS 启动/重启 + 渠道上传物料的抽查。
- **候选预算相关：** 同上，凡引用候选数值须标注「仅候选，须经 CR + 用户批准才成为正式门槛」并归 DC-PERF-01。

## Option P3 — 「跨 PC 商店准备姿态」（Windows + macOS 导出 · 面向候选商店渠道的准备性发布姿态）

- **名称：** 命名 OS = Windows + macOS（可含 Linux 作为第三候选）；导出 = 多平台产物集（含签名/公证等平台要求评估）；本期发布姿态 = **发布准备姿态**：本期不承诺出货，但为候选商店渠道（如 Steam 愿望单页/itch.io 页）准备可评审的发布候选包，渠道与阈值仍依赖 cr-103/cr-113 另行决定。
- **依据：** cr-103 明确「发行渠道决定 Gate 6 与发布范围」且当前无命名渠道（ADR-TECH-08「does not choose… distribution channel」）；macOS/Windows 双平台是 PC 商店渠道的常见前置；但发布阈值（cr-113）与 QA 放行姿态独立于本卡，故本选项只做「准备」，不做「承诺」。
- **影响：**
  - 产品：面向渠道的呈现面扩大（商店页面/试玩形态）；玩法承诺不变。
  - 创意：若启用渠道，发布文案、截图/演示物料范围进入 Scope（由 Release Copy / Director 输入，非本卡决定）。
  - 技术：多 target 导出、平台签名/公证要求（如 macOS notarization）评估、多 artifact 身份；QA 矩阵显著扩大（3 OS 覆盖或按 mac+win 子集）。
  - 范围：平台面最宽；渠道仍非承诺（需 cr-103 落定渠道名）。
  - 进度：导出/签名/公证/QA/物料排期最长；Gate 5/6 判据最复杂。
- **风险：** 商店渠道的前置工程（页面/物料/阈值）可能挤占 Slice 验证资源；macOS 构建/签名工具链成本高——回滚：未承诺渠道前退回 P1/P2 仅损失已投入的工具链配置（部分可复用）；验证成本 = 多 target export smoke + 签名/公证 + 渠道物料 + 多 OS 启动/重启证据。
- **候选预算相关：** 同上，凡引用候选数值须标注「仅候选，须经 CR + 用户批准才成为正式门槛」并归 DC-PERF-01。

## 专业推荐（DC-PLAT-01）

**推荐 Option P1（Windows-only 最小验证姿态）。** 理由：本 Slice 是「PC-first Demo / Vertical Slice」（Charter §5），cr-101..103 均 `user_reserved` 且回滚成本在未承诺前为零——先取最窄 OS/导出/发布姿态即可满足 Gate 5/6 判据身份，将发布/渠道/加宽决策保留到可见证据（QA 矩阵、性能样本、导出 smoke）之后，避免过早承诺。

- **异议/依赖并列：**
  - UX 分辨率依赖（cr-104/105 → DC-PLAT-02）与此卡松耦合但顺序依赖：本卡选定 OS/导出后，DC-PLAT-02 才可在确定 target 上定最小分辨率与宽屏支持集；若用户选择 P2/P3，DC-PLAT-02 需在对应 OS 集合上复核。**DC-PLAT-02 不随本卡自动决定。**
  - Toolchain 身份输入（cr-112）：任一选项下 build identity 规则由 Tech + Toolchain 提案，本卡仅激活 target 身份字段；不授权工具链实现或平台承诺。
  - cr-103 若用户在本卡之外单独倾向「必然发布」姿态（如 Steam 承诺），则属 cr-113 发布阈值/放行条件与 reauthorize_charter 范畴，需另行 CR，不由本卡闭合。
  - 候选预算（1080p/60 等）不因本卡任何选项而成为门槛；正式门槛唯一路径 = cr-109/DC-PERF-01 + 用户批准。

## 决策后记录规则（引用 CHANGE_REQUESTS §8 与 §4.4）

- 用户选择某项 → 记为 `user_confirmed`（provenance = 用户决策）；同时更新对应文档 status：本卡 → 由 Producer 在 `CHANGE_REQUESTS_v0_1.md` 登记选定项的 cr-101/102/103 处置与状态；随后按选定的 OS/导出 target 更新 `ADR-TECH-08`（build/export identity）与 Gate 5/6 判据引用（仍为 `PROPOSAL / DRAFT / NOT APPROVED` 直至正式评审）。
- 其余选项保持 `unresolved` / `team_proposal`（不删除、不静默推广）。
- 若选项改变 promise/immutable/platform/threshold/release → 走 `reauthorize_charter` 路径（本卡 P2/P3 若被选为「非候选、即成承诺」即触发；若保持候选则仍不越过）。

## 决策窗口与截止依赖

Batch 1（`CHANGE_REQUESTS §7`）：下一次用户决策窗口（Gate 0/1 静态复审就绪后即启用；先于合同/ADR 定稿）。依赖：无上游阻塞；下游 = DC-PLAT-02、DC-ARCH-01（可并行）、ADR 定稿路径、Gate 5/6 判据、QA 矩阵。

## 批准后的新 owner

- OS/导出目标落定：Tech Lead（build identity 规则、ADR-TECH-08 更新提案）+ Toolchain（未来实现者）+ Producer（证据/里程碑编排）。
- 发布姿态（若选定渠道候选）：Producer（Gate 6 编排）+ Independent QA/Release（放行姿态）；发布阈值本身 = cr-113/DC-REL-01。

## 批准后的验收标准

- Gate 5（export smoke）：命名 target 下的干净启动/启动/重启证据 + artifact digest + build identity + 版本一致性；Independent QA/Release 观察与 verdict（`export/release` 证据类）。
- Gate 6（独立发布复审）：仅当 cr-103 选定渠道/姿态后启用；QA 独立 review + blocker 裁决；无豁免权。
- 性能相关验收不属本卡；见 DC-PERF-01（cr-109）。

---

# CARD 2 — DC-ARCH-01

```text
Card ID:                 DC-ARCH-01
待决项:                  cr-201：候选架构 seam 处置 ——「Accept proposed rules/state/session/adapter architecture boundary?」
                         候选 seam = rules core → session → adapter → presentation/read-model（revision-02 #2；Charter §6
                         candidate architecture boundary；ADR-TECH-01）。当前仅静态一致、无实现验证；ADR-TECH-01..08 定稿路径
                         依赖本项处置 — `unresolved` / `user_reserved`（architecture risk crossing）。
证据基线:                Charter §6「candidate architecture boundary (not approved)」：Tech Lead 必须 author + review ADR 后才能
                         确认架构；ADR-TECH-01 status = `ready_to_draft`；ADR-TECH-06 = `dependency-blocked`（缺契约）；ADR-TECH-08 =
                         `user_reserved`（平台）；Matrix §3.1 依赖方向与语义归属提案（未批准）。
选项（4 个，精准、互斥）: 在处置粒度上互斥：维持候选并推进 / 批准为技术边界 / 替换 seam 方案 / 推迟处置。
```

## Option A1 — 「维持候选 + 启动 ADR 定稿路径」

- **名称：** 保持 `rules core → session → adapter → presentation/read-model` 为**候选**边界；**授权启动** ADR-TECH-01..08 的定稿（draft → 跨角色评审 → 依评审结果逐条进入批准流程），定稿产物仍为 `PROPOSAL / DRAFT / NOT APPROVED` 直至正式评审通过。
- **依据：** revision-02 #2 将该边界记录为 `user_confirmed` candidate input（Charter §2.1）；Charter §6 明确「Tech Lead must author and review an ADR before confirmation」；ADR-TECH-01 为 `ready_to_draft`、ADR-TECH-02/03/05/07 亦 `ready_to_draft`，缺失的只是处置授权与评审排程；`CHANGE_REQUESTS §7` 将 cr-201 置于「先于 ADR 定稿路径启动」。
- **影响：**
  - 产品：无产品承诺变化；边界保持候选，玩家承诺不变。
  - 创意：无创意影响；呈现 read-model 语义继续由 UX 定义（观察目标），不提升为规则权威。
  - 技术：ADR-TECH-01..08 进入有序定稿（05/06 依赖 Systems/UX 契约评审——契约不冻结）；最小确定性核心 seam 计划可基于候选边界先行设计（仍不实现）。
  - 范围：不新增架构承诺；不扩大 Slice caps。
  - 进度：对 cr-201 的处置即时解锁 ADR 排程；定稿路径与 DC-PLAT-01 并行，互不阻塞。
- **风险：** 若后续评审推倒关键 seam 假设，已起草 ADR 需返工——回滚/验证成本：ADR 仅为文档提案，返工成本 = 重 draft 对应 ADR（无实现/无运行时成本）；验证 = 评审记录 + 契约依赖核对，无 runtime 证据要求。
- **候选预算相关：** 不涉及数值预算；涉及 1080p/60 等候选数值一律归 DC-PERF-01，标注「仅候选，须经 CR + 用户批准才成为正式门槛」。

## Option A2 — 「按 ADR 条件批准为技术边界提案」

- **名称：** 用户批准候选 seam 为**技术边界提案**（架构风险 crossing 由用户决定）：边界成为 Charter 内的既定技术方向，ADR-TECH-01..08 定稿路径转为「按此边界补全细节并进入评审/冻结」，最小确定性核心 seam 可直接以该边界为契约基线。
- **依据：** cr-201 本质为「是否接受候选架构边界」（Charter §12 决策行）——本选项即「接受」（注：仍须 ADR 定稿契约细节，非一次性冻结全部合同）；ADR-TECH-08 平台字段仍 `user_reserved`，与此分离。
- **影响：**
  - 产品：无玩法承诺变化；边界成为技术基线使下游契约锁定更快。
  - 创意：无创意影响；但 read-model/UX 字段若在 UX 契约评审中需改，将触发边界修订流程（成本高于 A1）。
  - 技术：边界获批 → 所有 seam 契约与 fixture 计划立即确定基线；ADR-TECH-01..08 依据已确认边界补终稿；跨评审矩阵 ownership 从「候选」转「基准」。
  - 范围：架构承诺提前锁定；若 Systems/UX 评审发现边界缺陷，需 CR + 可能 reauthorize（范围回退成本存在）。
  - 进度：最快让最小确定性核心 seam 契约落地；但锁点早于契约评审，返工窗口收窄。
- **风险：** 在 Systems/Rules 语义与 UX 契约评审完成前锁定边界，可能把「待确认前提」冻成基线——回滚/验证成本：边界修订需重走 ADR 评审 + CR（若触架构风险则 user 再决）；验证成本高于 A1（涉及后续 fixture 契约重基线）。
- **候选预算相关：** 同 A1。

## Option A3 — 「替代 seam 方案」

- **名称：** 用户否决候选方向，改选一个**替代 seam 方案**（例：两段式 `rules core + session/adapter` 合并表层，或把 presentation 并入 adapter 的浅层切分），Tech 按新方案重写 ADR-TECH-01..08 与跨评审矩阵 ownership。
- **依据：** cr-201 允许「Request a different seam or defer」（Charter §12 备选）；ADR-TECH-01 anti-proposals 已列被拒方向（monolithic / UI-owned / engine-physics-authoritative / premature ECS）——替代方案须避开这些反提案且带证据理由；本选项只在用户明确提出替代原则时启用。
- **影响：**
  - 产品：无玩法承诺变化（seam 是技术「how」）。
  - 创意：无创意影响。
  - 技术：ADR 包整体重 draft；seam 语义归属重排（如所有权并入 Session）；Matrix §3 职责矩阵需重评审。
  - 范围：架构范围显式变更（至少一次 CR 记录）；不扩大 Slice caps，但契约面重排。
  - 进度：最长路径——ADR 重写 + 跨角色再评审 + 契约重基线，ADR-TECH-06 headless seam 依赖延后。
- **风险：** 替代 seam 未经验证即替代候选（候选至少经受两轮静态评审）——回滚/验证成本：回到候选方向需用户再决 + ADR 返工；验证成本最高（重 draft + 重评审 + 契约定稿推迟）；建议任何替代方案先以 A1 式 draft 对比评审再决定。
- **候选预算相关：** 同 A1。

## Option A4 — 「推迟处置」

- **名称：** cr-201 暂不处置：seam 保持 `unresolved`（候选记录不动），ADR 定稿路径**不启动**，推迟到后续决策窗口（如 DC-PLAT-01/DC-PLAT-02 与契约评审之后）。
- **依据：** `CHANGE_REQUESTS §7` 决策窗口规则：错过窗口的项保持 `unresolved` 并顺延，绝不静默通过；ADT-TECH-06 `dependency-blocked`（缺 Systems/UX 契约）本身说明定稿存在前置依赖，推迟是可辩护的。
- **影响：**
  - 产品：无变化；承诺不受影响。
  - 创意：无影响。
  - 技术：ADR-TECH-01..08 保持 `ready_to_draft`；无定稿产物；跨评审矩阵保持提案态。
  - 范围：无新增承诺；但也无契约基线。
  - 进度：最小确定性核心 seam 契约无法启动（依赖 cr-201 处置）——批次内延迟；Gate 2 计划顺延。
- **风险：** 把架构处置持续后置会造成级联延迟（契约 → 最小 seam → runtime 证据），且推迟不等于消失——回滚/验证成本：无直接成本，但机会成本 = 每次后续决策窗口需重看 cr-201；验证 = 无新增证据要求。
- **候选预算相关：** 同 A1。

## 专业推荐（DC-ARCH-01）

**推荐 Option A1（维持候选 + 启动 ADR 定稿路径）。** 理由：既尊重 revision-02 #2 的 `user_confirmed` 候选输入与 Charter §6「先 ADR 后确认」的铁律，又不触架构风险 crossing（边界仍为候选、ADR 仍为提案），以最小承诺解锁 ADR-TECH-01..08 定稿与最小确定性核心 seam 的**设计**排程——这正是 cr-201 登记时依赖的「Tech 提案」路径。

- **异议/依赖并列：**
  - A2（批准为技术边界）可换取工程边界确定性，但风险是在 Systems/Rules 语义与 UX 契约评审完成前过早冻结；Tech Lead 建议不选 A2 直到 ADR-TECH-05/06 的契约依赖（Systems/UX）评审产出后，再由用户决定是否提升为批准。
  - A3（替代 seam）仅在用户持有明确替代原则时启用；任何替代方案应先以 draft 与候选对比评审（A1 式），避免未经验证替代已验证候选。
  - A4（推迟）合法但与 Batch 1「先于 ADR 定稿」的目标冲突，将顺序延后；仅当用户同时推迟 DC-PLAT-01 语义依赖且明确要求时才建议。
  - 依赖：ADR-TECH-02/03/05 需 Systems/Rules 语义输入、ADR-TECH-02/05/08 需 UX/UI 输入、ADR-TECH-06 需 evidence schema/QA 输入——这些为跨角色依赖，标注为**父协调器协调项**（本任务不自行派发）。
  - 候选预算同 DC-PLAT-01：任何候选数值引用须带「仅候选」标注并归 DC-PERF-01。

## 决策后记录规则（引用 CHANGE_REQUESTS §8 与 §4.4）

- 用户选择某项 → 记为 `user_confirmed`（provenance = 用户决策）；同时更新对应文档 status：`KICKOFF_TECH_ADR_CONTRACTS_v0_1.md` 的 ADR-TECH-01..08 状态（A1 → `in_review/finalization` 路径；A2 → 边界 `approved-as-technical-boundary`；A3 → 替换方向并重 draft；A4 → 保持 `ready_to_draft`）——均保持 `PROPOSAL / DRAFT / NOT APPROVED` 直至实质评审。
- 其余选项保持 `unresolved` / `team_proposal`（不删除、不静默推广）。
- 若选项改变 promise/immutable/platform/threshold/release → 走 `reauthorize_charter` 路径（本卡 A2/A3 若被选即在对应边界上记录架构承诺；A1/A4 不触发）。

## 决策窗口与截止依赖

Batch 1（`CHANGE_REQUESTS §7`）：与 DC-PLAT-01 同期；在 ADR 定稿路径启动前。下游：ADR-TECH-01..08 定稿、最小确定性核心 seam 计划（设计）、契约手递（Systems/UX/Q）。上游依赖：无；跨角色评审依赖（Systems/UX/QA 输入）由父协调器协调。

## 批准后的新 owner

- A1：Tech Lead（ADR 定稿 + seam 设计）+ Systems/Rules（语义输入）+ UX/UI（read-model/交互输入）+ Producer（评审排程）。
- A2：Tech Lead（契约基线）+ 未来 Engineer（实现契约）；边界修订 = CR + 用户。
- A3：Tech Lead（重 draft ADR）+ Producer（CR 登记替代方向）。
- A4：–（保持 unresolved；重开由 Producer 于后续窗口安排）。

## 批准后的验收标准

- ADR-TECH-01..08 各有 version、authority 记录、consequences、stop condition；评审通过记录由 Producer 编排、Independent QA/Release 对证据字段可审计性做独立预检（不代做实现验收）。
- 最小确定性核心 seam（若启动设计）：headless seam 契约（ADR-TECH-06）、fixture schema、build/config identity 与 evidence index 就绪，QA/Release 确认审计字段可寻址后，方可进入未来授权的实现（Gate 2 路径）。
- 本卡不产生 runtime/visual/performance/export 验收；相关光环全部 `not_run / not_ready`。

---

## 本文件 Closure

- **Closure-ready:** `yes` **仅作为本静态选项包产物**（两张卡片的选项制备，未选中任何选项）。
- 不是 kickoff pass、不是实现授权、不是合同/ADR 批准、不是验收 verdict。
- Kickoff 仍 `not_ready`；implementation 仍 `NOT_AUTHORIZED`；Gate 0/1 仍 `ready_for_next_review`（静态复审）；Gate 2–6 仍 `not_run / not_ready`。
- 不变量（22 / 8+1 / PRECHARTER-01..11 / 四层 provenance / unresolved 全量）均保持未动。