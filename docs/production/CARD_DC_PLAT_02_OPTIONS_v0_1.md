# CARD DC-PLAT-02 — OPTIONS PACKAGE v0.1（选项制备产物，非决策）

> **状态：** `PROPOSAL / OPTION PREPARATION / NOT A USER DECISION / NOT APPROVED`
>
> **生命周期：** `development governance / kickoff readiness preparation`
>
> **制备角色（本文件唯一 owner）：** UX/UI Designer（`godot-ux-ui-expert`）
>
> **本卡是什么：** 按 `CHANGE_REQUESTS_v0_1.md §8` 固定结构，为 **DC-PLAT-02「最低分辨率红线（cr-104）+ 宽屏支持集与缩放/letterbox/crop 策略（cr-105）合并决策包」** 制备 2–4 个精准、互斥的整体选项，提交父协调器汇成选项卡片供用户选择。
>
> **本卡不是什么：** 不是用户最终决策；不替用户选择选项；不批准/冻结任何 Tech/Systems/UX 合同；不豁免 QA blocker；不替 Independent QA 下 verdict；不把任何 `team_proposal`/`assumption`/`unresolved` 升级为 `user_confirmed`。
>
> **证据类别：** `static/source` only。未访问 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布。

---

## 0. 不变量与来源边界

- 不变量保留声明（与 Charter §1、CR ledger §9 一致）：
  - **22 项**原始 `user_confirmed` 决策：保持候选约束原状；
  - **恰好 8 项** canonical `v0.1-revision-02` 输入 + **独立**的 Charter authorization record（无第九项）；
  - **PRECHARTER-01..11**：全部保留，unresolved 字段未动；
  - **四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）全程区分；
  - **全部 unresolved 保留 unresolved**：cr-104/cr-105 及缩放/安全区/阈值相关细节在用户选择前一律 open。
- 实际读取来源（仅 static/source）：Charter v0.1（§6 决策 #18/19、PRECHARTER-06、§12 开放决策行）、UX 合同 v0.1（§7、§9 UX-09/UX-12、§12）、CR ledger v0.1（§3–§8：cr-104/cr-105、§8 卡片结构）、Tech ADR v0.1（ADR-TECH-07/08，技术可行性引用）。
- 本卡内所有分辨率/比例/规格数值均为**候选提议**，凡涉及处必标注：
  > 「仅候选，须经 CR + 用户批准才成为正式门槛。」

---

## 1. 待决项（linked cr_ids + 来源原始表述 + 当前状态）

| 字段 | 记录 |
|---|---|
| Card ID | `DC-PLAT-02` |
| 待决项 | **cr-104（最低分辨率红线）** + **cr-105（宽屏支持集与缩放/letterbox/crop 策略）** 合并为一个决策包（CR ledger §7 Batch 1 行） |
| 来源原始表述 | cr-104：「minimum resolution unresolved, user-reserved (PRECHARTER-06; UX §7 'Reserved thresholds'; Charter §12 row)」；cr-105：「common widescreen candidate; scaling/letterbox/crop rules unresolved (UX §7; PRECHARTER-06; Charter §6)」 |
| 受影响的 user_confirmed 边界 | Charter 决策 **#18**（16:9 基线 + common widescreen 候选 + 最小可读红线）；**#19**（基本可访问性基线：非颜色通信、焦点可见、节制闪动）；PRECHARTER-06（持久 HUD：生命/计时/B2，最小化 XP；布局、copy、**最小分辨率与安全区 unresolved**）；revision-02 #8（platform 方向候选：PC-first、键盘、16:9、common widescreen、基本可访问性；未命名 OS/最小分辨率/导出目标/发布平台） |
| 当前状态 | cr-104 / cr-105 均为 `unresolved`（user-reserved / needs_user_decision）；Producer disposition = `needs_user_decision`（决策包 DC-PLAT-02）|
| 依赖 | **cr-101（OS 平台目标，DC-PLAT-01，Tech Lead 并行制备中）**：全屏/窗口化/HiDPI 行为与 Gate 5 导出验证身份依赖 OS 命名；cr-105 **依赖 cr-104**（缩放策略以红线数值为前提）；UX-09/UX-12 QA 矩阵行依赖本卡（CR ledger cr-104 行） |
| 下游影响 | HUD/布局契约定稿、UX-09（HUD 持久/无遮挡 + 16:9 回归）、UX-12（widescreen 可读 + 安全区）、Gate 3（视觉/UI）、Gate 5（export smoke）、可访问性阈值卡 DC-ACC-01/02 |

---

## 2. 共同前提（所有选项适用；不因选项不同而改变）

1. **16:9 基线** 是 `user_confirmed`（决策 #18），所有选项均保留，不重复投票。
2. **可读红线是方向性承诺**（决策 #18「minimum readability red line」）：文本可读、焦点可见、非颜色区分、HUD/卡牌不被裁切/重叠。除方向外，红线**数值与验证准则**在本卡内全部选项均为 `unresolved` 或候选，须用户选定后由 UX 依选定项细化（仍经 CR + 用户批准才成正式门槛）。
3. **common widescreen 是候选支持方向**（revision-02 #8；UX §7），不是已命名支持集。本卡各选项把「是否把宽屏集纳入支持承诺、纳入多宽」交给用户，并标注：**一旦支持集成为发布承诺 → 走 reauthorize_charter（Charter §2.3、CR §8）**。
4. **候选预算标注**：1080p/60 等性能预算（PRECHARTER-10、revision-02 #7、ADR-TECH-07）**仅候选**，与本卡分辨率红线无相互授信关系；红线是「最小」维度，1080p 是「目标」维度，二者各自须经 CR + 用户批准才成为正式门槛。
5. **技术可行性条目**标注「需 Tech 确认」的，均不在本卡内自行为选项背书；由 Tech Lead 在选项汇成/批准前给出可行性或实现成本输入（CR ledger §7：DC-PLAT-02 制备角色 = UX/UI + Tech Lead 可行性输入）。
6. 所有选项保持 UX/Tech/Systems 合同 `PROPOSAL / DRAFT / NOT APPROVED` 状态不变。

---

## 3. 选项（2–4 个，精准、互斥）

> 互斥性说明：四个选项在「红线数值候选 / 支持集宽度 / 缩放规则」三维上互斥，用户选择其一即为整体决策（可含其子维度说明）；未选项保持 `unresolved`/`team_proposal`。

---

### Option 1 — 「Spartan：仅 16:9 基线，720p 红线，全 letterbox」

**名称（一句话）：** 只承诺 16:9 一个比例：`1280×720`（候选）为最低可读红线，任何非 16:9 视窗一律等比缩放 + 黑边（letterbox），不承诺任何非 16:9 比例。

- **依据**
  - 决策 #18（16:9 基线 + 可读红线）为 `user_confirmed`；「common widescreen」在 revision-02 #8 / UX §7 中是**候选**——本选项选择**不**把候选兑现为支持承诺（候选不等于已确认）。
  - PRECHARTER-06：最小分辨率与安全区 `unresolved`、user-reserved；cr-104 明确 user-reserved（UX §7 Reserved thresholds；Charter §12 行）。
  - UX §7「Responsive behavior … prefer additional safe space over stretching」——letterbox（额外安全空间）优于 stretch，与本选项一致。
  - Charter §12 备选明示「Support a narrower set or defer」，本选项即「narrower set」路线。

- **影响**
  - 产品：承诺面最小；16:10/21:9 等非 16:9 玩家（笔记本、超宽屏）可见黑边但可玩，不会被裁切。
  - 创意：画面构图始终按唯一 16:9 画布设计，无跨比例构图一致性负担。
  - 技术：单画布比 + letterbox 方案；实现量最小（具体 stretch mode / 黑边呈现方式**需 Tech 确认**，见下）。对 OS/窗口行为依赖 cr-101。
  - 范围：验证面最小——UX-09 于 `1280×720` 与 `1920×1080`（均为**仅候选**验证点）＋ UX-12 仅 16:9 回归。
  - 进度：布局与 QA 成本最低；先于 HUD/布局契约定稿（§7 Batch 1 窗口）。

- **风险**：若 16:10/21:9 用户未被明确告知（发布层面误当支持），存在体验落差与口碑风险；**回滚成本**：发布承诺化之前为零成本（未选前不承诺），承诺化后回滚 = 退回更窄集需 CR + 用户（cr-101 同款回滚逻辑）；**验证成本** = 2 个分辨率点 × UX-09 + 16:9 回归（UX-12）。

- **候选预算相关**：
  > `1280×720` 红线与 `1920×1080` 验证点均为**仅候选**，须经 CR + 用户批准才成为正式门槛。

- **UI 布局/HUD/安全区/读性影响（UX-09/UX-12 覆盖）**：HUD（生命/计时/B2）与三卡布局在唯一 16:9 画布内一次定稿；安全区 = 画布边缘以内（具体边距/档位由后续 UX 布局提案给出，本卡不锁数值）；letterbox 保证任何窗口尺寸下 HUD 不被裁切、卡牌不被拉伸；UX-09 覆盖持久 HUD 与无遮挡（命名 aspect/resolution = 16:9 两点）；UX-12 覆盖 16:9 安全区/无裁切行为；可读红线（文本/焦点/非颜色区分）在 `1280×720`（候选）处验证，UX-13 子集提供可读性清单输入。

- **技术可行性 / 实现成本条目**
  - **letterbox vs stretch**：本选项 = letterbox（等比缩放 + 黑边），**禁 stretch**（stretch 违反 UX §7「prefer additional safe space over stretching」，且拉伸 HUD/卡牌即 cr-105 主要风险）。Godot 侧 stretch mode / aspect keep 的具体配置、黑边是否渲染氛围层、性能影响（`1080p/60` 仅候选）→ **需 Tech 确认**。
  - **插值缩放 vs 像素艺术策略**：本项目美术**未确认**为像素艺术（Anchor 为锈蚀工业/剪影方向，`synthetic/anchor` 静态基线，非像素化结论）；插值缩放与最近邻策略均未定 → **需 Tech 确认**渲染/缩放品质策略及其对 720p 红线可读性的影响。
  - 窗口化/全屏/HiDPI 行为 → 依赖 cr-101（DC-PLAT-01），**需 Tech 确认**（本卡列为依赖，不自行裁定）。

---

### Option 2 — 「Balanced：16:9 基线 + 常见宽屏（16:10、21:9），720p 红线，fit + UI 缩放、禁 stretch / 禁 crop」★ 专业推荐

**名称（一句话）：** 在决策 #18 的「common widescreen 候选」方向内兑现为**支持承诺候选**：`1280×720`（候选）红线，支持 `16:9 / 16:10 / 21:9` 三个常见桌面比例；画面 fit + letterbox 空隙、UI 相对缩放保护安全区，**禁止拉伸文字/卡牌、禁止裁切 HUD/卡牌**。

- **依据**
  - 决策 #18（16:9 基线 + common widescreen 候选 + 可读红线）与 revision-02 #8（PC-first、common widescreen 方向）——本选项把「候选方向」收敛为「候选支持集」，由用户在本文档确认后才成为承诺。
  - UX §7 三处逐字依据：「common widescreen is a candidate support set」；「prefer additional safe space over stretching text/cards」；「exact letterbox/crop/scale rules are unresolved」——本选项正是为这三处未决给出可执行规则。
  - Charter §12 开放决策行：「Ask UX/Tech for measured recommendation, then User selects minimum red line」——本卡即该行要求的 UX 推荐（Tech 可行性部分标为依赖）。
  - cr-104（QA 矩阵 UX-09/12 依赖）与 cr-105（验证 UX-12 + 16:9 回归）在 CR ledger 中均为 `needs_user_decision`（并入 DC-PLAT-02）。

- **影响**
  - 产品：覆盖 16:9 / 16:10 / 21:9 主要桌面比例（common widescreen 候选集），承诺面适中；不承诺超宽以外特殊比例。
  - 创意：21:9 额外横向空间转化为清屏视野纵深（对齐 pillar 1「clear-screen dominance」与 UX §8「clear / movable space」优先），构图保持中心聚焦；16:10 视作 16:9 的纵向安全余量。
  - 技术：需「画面 fit 等比 + UI 相对缩放」双层机制；Godot viewport/Control scale 组合与黑边空隙实现 → **需 Tech 确认**（见下）；实现成本中等。
  - 范围：验证集 = {16:9 回归（基线）, 16:10, 21:9} × 红线候选点；UX-09（命名 aspect/resolution）＋ UX-12（每比例安全区/裁切/重叠）+ UX-13 子集。
  - 进度：布局档位约 2–3 套安全区约定 + 中等 QA 回归面；先于 HUD/布局契约定稿即满足 §7 决策窗口。

- **风险**：21:9 下 HUD 拉伸或裁切是首要失败模式（cr-105 风险行「stretching text/cards or cropping HUD」）——本选项以「禁 stretch / 禁 crop + 安全区 clamp」正面应对，但其可执行性依赖 Tech 的 clamp/缩放上限实现；**回滚成本**：发布承诺化之前可退回 Option 1（验证成本即 3 比例回归）；支持集若写入发布文案/发布承诺 → **reauthorize_charter**（§8 记录规则触发）。

- **候选预算相关**：
  > `1280×720` 红线与 `1920×1080` 基线点均为**仅候选**（`1366×768` 若用户偏好亦可作为同包候选值替换，需另行 CR 标注）；须经 CR + 用户批准才成为正式门槛。`1080p/60` 为性能预算（PRECHARTER-10），与本卡互不授信，见 §2-4。

- **UI 布局/HUD/安全区/读性影响（UX-09/UX-12 覆盖）**：HUD（生命/计时/B2）锚定安全区（具体边距由后续 UX 提案定，本卡不锁数值），21:9 下 HUD 保持安全区内、两侧空间留给清屏视野而非铺开 HUD；卡牌三列按 16:9 基线设计，21:9 下保持卡宽不拉伸（UX §7 逐字要求）；可读红线定义 = 红线分辨率下文本可读、焦点可见、非颜色区分、无裁切/重叠（UX-13 子集提供检查清单）；UX-09 覆盖 16:9 持久 HUD 与 16:9 回归；UX-12 覆盖 16:10 / 21:9 命名帧、安全区、裁切/重叠笔录。

- **技术可行性 / 实现成本条目**
  - **letterbox vs stretch**：fit + letterbox 空隙（禁 stretch）；空隙是否渲染氛围/景深层为创意未决项 → **需 Tech 确认**实现成本（含 `1080p/60` 仅候选预算下的开销）。
  - **UI 相对缩放与安全区 clamp**：UI 随分辨率相对缩放并 clamp 于安全区，需确认 Godot `CanvasLayer`/`Control` scale 与布局重算时机、2 档红线缩放规格（720p vs 1080p）的实现成本 → **需 Tech 确认**。
  - **插值缩放 vs 像素艺术策略**：同 Option 1——美术未确认像素艺术 → **需 Tech 确认**缩放品质策略在 21:9 下的表现。
  - 全屏/窗口化/HiDPI → 依赖 cr-101（DC-PLAT-01），**需 Tech 确认**。

---

### Option 3 — 「Broad：更低红线（1024×576 候选）+ 更宽支持集（16:9/16:10/21:9 + 4:3 legacy letterbox）」

**名称（一句话）：** 最大覆盖：`1024×576`（候选）最低红线以服务低端/窗口化场景，支持 `16:9 / 16:10 / 21:9`，并对 `4:3` legacy 窗口承诺 letterbox 不裁切 HUD（不承诺全 UI 完整布局）；多档安全区与规格。

- **依据**
  - 决策 #18（可读红线方向）与 UX §7（支持集候选、缩放规则未决）——本选项是候选方向的「最大兑现量」；红线仍 user-reserved（cr-104）。
  - Charter §12 备选对偶（「Support a narrower set **or defer**」之外，扩大集由用户权衡覆盖 vs 成本——呈现面差异正是本卡让用户拍板的内容）。
  - ADR-TECH-08：导出/构建身份**未**选择最小分辨率，未排除任一支持集 → 不构成技术障碍，但实现/验证成本为增量。

- **影响**
  - 产品：覆盖面最大（低端笔记本、窗口化小窗、宽屏、legacy 4:3 显示），承诺面最大；发布文案可承诺面最广。
  - 创意：多比例构图档位化（21:9 视野纵深、4:3 收窄构图），跨比例创意一致性风险升高，需 Director 输入未读（见 §4 依赖）。
  - 技术：多档 UI 布局 + 低分辨率字体/图标规格 + 4:3 分档 letterbox；实现与资产负担最高 → **需 Tech 确认**。
  - 范围：验证集最大：UX-09（≥2 分辨率点）+ UX-12（每个命名比例帧 + 16:9 回归）+ UX-13 子集在最低红线处可读性；QA 面最大。
  - 进度：最重；HUD/布局契约定稿前需完成多档安全区与规格表。

- **风险**：「全都要」导致每档验证稀释，低分辨率下 HUD/卡牌拥挤风险为四选项最高（cr-105 风险行放大；UX-09 无遮挡红线在 1024×576 候选点最易触线）；**回滚成本**最高（多档布局推翻 = 整表返工）；红线/支持集若进发布承诺 → reauthorize_charter。

- **候选预算相关**：
  > `1024×576` 与 `1920×1080` 等均为**仅候选**，须经 CR + 用户批准才成为正式门槛。

- **UI 布局/HUD/安全区/读性影响（UX-09/UX-12 覆盖）**：需 3–4 档安全区/字号/焦点尺寸规格（低档在小分辨率验证）；4:3 只承诺 letterbox 不裁切 HUD，不承诺卡牌/全 UI 完整布局（范围明确收窄表述）；UX-12 每个命名比例帧 + 16:9 回归；UX-09 在各档分辨率点验证持久 HUD 无遮挡；可读红线在最低候选点验证（UX-13 子集）。

- **技术可行性 / 实现成本条目**
  - **letterbox vs stretch**：混合分档——4:3 用 letterbox、21:9 用 fit + 两侧空间、16:10 居中；分档判定与实现成本 → **需 Tech 确认**。
  - **UI 多档缩放 / 低分辨率文本渲染**：缩放档位表 + 低分辨率字渲染（子像素/抗锯齿）成本 → **需 Tech 确认**（`1080p/60` 仅候选预算）。
  - **插值缩放 vs 像素艺术策略**：同前，**需 Tech 确认**。

---

### Option 4 — 「Defer：本期不定标的数值，仅 16:9 基线推进，红线与宽屏集推迟至 Gate 前实测提议」

**名称（一句话）：** 不选任何具体红线数值/支持集：保留 16:9 基线与可读红线**方向**（决策 #18），HUD/布局先按 16:9 安全区推进，红线数值与宽屏集留 `unresolved`，待 Gate 3 前由 UX 依实测数据提议（仍经 CR + 用户批准）。

- **依据**
  - Charter §12 备选「Support a narrower set **or defer**」——defer 是明示合法路线；UX §7「Reserved thresholds … remain `unresolved` and user-reserved where they become product or release commitments」。
  - cr-104/cr-105 当前即 `unresolved`；本选项保持其 unresolved 状态，不把任何候选数值带入门槛（对应 HR ledger §9「不提前把候选写死」与 cr-101「未选前零成本回滚」逻辑）。
  - Gate/证据纪律：Gate 0/1 仅静态复审，Gate 2–6 `not_run`；在无实测前定死红线，与「unresolved thresholds require a named decision record with owner/authority」（Charter §10）相符。

- **影响**
  - 产品：本期零新增比例/分辨率承诺；不降低「16:9 基线 + 可读红线方向」（决策 #18）这一已确认边界。
  - 创意：构图按 16:9 安全区设计并预留宽屏空隙（不锁定、不承诺）。
  - 技术：前期零新增缩放实现；但「先 16:9 后补档」的再布局/资产返工成本需在 Gate 3 前评估 → **需 Tech 确认**。
  - 范围：UX-09 先行（16:9 命名点）；UX-12 宽屏项保持 `not_run` 直至定标；Gate 5 分辨率配置随 cr-101 待定。
  - 进度：当前最轻；但把定标成本推迟到 Gate 3/5 附近，存在后期返工与证据缺口风险。

- **风险**：推迟 ≠ 豁免——Gate 3（UX-12 判定）与 Gate 5（export 分辨率配置）依赖定标；若后续实测提议数值，仍需本卡同类路径（CR + 用户）→ 二次决策成本；**回滚成本** = 零（本期零承诺）。

- **候选预算相关**：
  > 本选项不提出任何候选数值；未来实测提议的任何数值仍须 CR + 用户批准才成为正式门槛。

- **UI 布局/HUD/安全区/读性影响（UX-09/UX-12 覆盖）**：HUD/卡牌按 16:9 安全区推进（UX-09 先命名 16:9 验证点）；16:10/21:9 安全区与可读红线留 `unresolved`（UX-12 暂 not_run，待定标后命名）；可读红线**方向**（文本/焦点/非颜色区分）在 16:9 基线上先行验证（UX-13 子集）。

- **技术可行性 / 实现成本条目**：前期零实现；「后期从 16:9 单一布局扩展到 21:9/16:10 的再布局与资产影响」→ **需 Tech 确认**（作为 Gate 3 前评估输入）；letterbox/stretch/插值策略全部推迟，无条目可背书。

---

## 4. 专业推荐（唯一）

> **推荐 Option 2（Balanced：16:9 + 16:10 + 21:9，720p 红线候选，fit + UI 缩放、禁 stretch / 禁 crop）。**

- **一句理由：** 它与已确认方向（决策 #18「common widescreen 候选 + 可读红线」、revision-02 #8）最为一致，把 UX §7 逐字约束「prefer additional safe space over stretching」落实为可执行规则（fit + UI 缩放、禁拉伸/禁裁切），并以有限命名集（3 比例 + 红线候选点）让 UX-09/UX-12 即可判读可读红线——承诺面、布局/QA/技术成本三者取得平衡，且回滚路径清晰（未承诺化前可退回 Option 1）。
- **异议 / 依赖（并列说明，不替用户消解）：**
  1. **依赖 cr-101（DC-PLAT-01，Tech Lead 并行制备）**：全屏/窗口化/HiDPI 行为、Gate 5 导出验证身份依赖 OS 命名；本卡所有选项均列该依赖。
  2. **依赖 Tech Lead 可行性确认**：Godot stretch mode / UI scale / 安全区 clamp / 插值缩放策略（选项内已标注「需 Tech 确认」条目）——在 Tech 确认前，任何选项的验收路径不得冻结。
  3. **依赖 Director 输入（若选择 Option 3 尤其需要）**：21:9 清屏视野/多比例构图一致性属创意判断；本卡未读取 Director 意见，需父协调器在汇卡前补充该输入。
  4. **客观面对的异议**：Option 2 未覆盖 4:3 legacy 与超低分辨率窗口（Option 3 覆盖但成本/风险最高）；若用户以「最大玩家基数」为第一权重，Option 3 为合理备选；若以「最小验证面/最快定稿」为第一权重，Option 1 更轻。
  5. 支持集若写入发布文案/成为发布承诺 → **reauthorize_charter**（§8 记录规则，见 §5）。

---

## 5. 决策后记录规则（按 CHANGE_REQUESTS_v0_1.md §8 引用）

- **用户选择某项 → 记为 `user_confirmed`（provenance = 用户决策）**，并更新对应合同/文档的 status 字段：UX 合同 v0.1 §7（支持集/缩放规则）与证据矩阵 UX-09/UX-12 条目状态由 UX/UI owner 更新；Tech ADR-TECH-08（分辨率/身份字段）由 Tech Lead 更新；CR ledger cr-104/cr-105 行由 Producer 补记决策引用。**任何 status 更新均在用户选择之后、由对应 owner 执行；本制备产物不更新任何文档。**
- **未选项保持 `unresolved`/`team_proposal`**：不删除、不静默推广（CR §8；Charter §2.3 沉默不为同意）。
- **若所选选项改变 promise / immutable / platform / threshold / release**（例：把支持集或红线写入发布承诺、发布文案、Gate 5 判据）→ 走 **reauthorize_charter** 路径（Charter §2.3；CR §8），由 Producer 装配回用户。
- 本卡任何选项**不视为**对 UX/Tech/Systems 合同的批准或冻结；三份合同保持 `PROPOSAL / DRAFT / NOT APPROVED`（Charter §2.2 防火墙；CR §9）。

---

## 6. 决策窗口与截止依赖（按 §7 Batch 1）

- **窗口：** 紧随 **DC-PLAT-01（cr-101 OS 命名）**；在 **HUD/布局契约定稿前**（CR ledger §7 Batch 1 行）。错过窗口的项目保持 `unresolved` 顺延至下一窗口，绝不由沉默通过（§7 总规则 1）。
- **内部顺序：** 红线（cr-104）先定 → 支持集与缩放策略（cr-105）随红线定；两者同卡一次拍板亦可。
- **并行/依赖：** 与 DC-ARCH-01 同批可并行制备；UX-09/UX-12、Gate 3、Gate 5 排期依赖本卡结论（cr-104/cr-105 依赖行）。

## 7. 批准后的新 owner 与验收标准（§8 末两字段）

- **批准后新 owner：** UX/UI Designer（布局/安全区/缩放规则细化与 UX-09/UX-12 证据计划）＋ Tech Lead（Scaling 机制可行性与实现成本；ADR-TECH-08 身份字段更新）＋ Independent QA/Release（独立观察与 pass/block）。
- **批准后验收标准：** 命名证据/门——Gate 3 视觉/UI：UX-09（命名 aspect/resolution 帧 + 16:9 回归）与 UX-12（每个支持比例的帧/裁切/重叠笔录）＋ UX-13 可读性子集，由 Independent QA/Release 独立观察并给出 pass/block；Gate 5 export smoke 以选定支持集为准（依赖 cr-101）。红线数值若成验收门槛，须先经 CR + 用户批准成为正式门槛（§2-4 标注规则）。

---

## 8. 不变量、边界与 closure

- **本任务只读**了 §0 所列 static/source 文档；**只写入**本文件（唯一新产物）。
- 未修改任何既有文档；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布；未调用 subagent/subagent_fork/workflow 或任何嵌套派发。
- 未替用户选择选项、未批准/冻结任何合同、未豁免 QA blocker、未替 Independent QA 下 verdict、未把任何 `team_proposal`/`assumption`/`unresolved` 升级为 `user_confirmed`。
- 数据不变量保留：22 / 8+1 / PRECHARTER-01..11 / 四层 provenance / unresolved 全量（§0）。
- **Closure：** `closure_ready = yes` **仅针对本静态选项制备产物**；不是 kickoff 通过、不是实施授权、不是合同批准、不是验收 verdict。Kickoff 保持 `not_ready`；implementation 保持 `NOT_AUTHORIZED`；Gate 0/1 `ready_for_next_review`（仅静态复审）；Gate 2–6 `not_run / not_ready`。