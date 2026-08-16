# 跨对话交接文件 — 类《吸血鬼幸存者》割草游戏（Discovery 阶段）

> 生成角色：Doc Scribe（godot-doc-scribe-expert）
> 用途：把父会话已确认的进度、成果与边界固化为持久记录，供新对话直接读取续作。
> 本文件是普通 Markdown 文档，不是 Godot 项目文件，不修改任何 Godot 工程。

## 1. 文件用途与使用方式

- 本文件是 Discovery 阶段的持久交接物。此前 Discovery Brief 仅存在于对话内、未落盘（磁盘上另有一个 v0.2 文件，见 §6，来源未验证）。
- 新对话开场：先读取本文件 → 对照工作目录现状（检查 docs/ 与项目文件）→ 向用户复述状态并**询问是否授权 Game Director / Creative Director 编写 Creative Brief** → 未获明确授权不得进入正式开发。
- 本文件由 Doc Scribe 生成；后续变更请追加到 §9 台账，不要静默改写既有记录。

## 2. 状态 / 生命周期 / 授权边界

| 项 | 状态 |
|---|---|
| 生命周期 | owner-led Discovery 已完成（目标标记 complete）；**当前不在正式开发** |
| 产品权威 | 用户是唯一产品负责人与最终决策者 |
| 当前授权 | 仅"继续探索并比较方向" + 选择方向 A 为主轴；**不是 GDD、不是 Development Charter、不是开发授权** |
| 下一正式门 | ① 用户明确授权 → Game Director / Creative Director 产出 Creative Brief；② 用户明确授权版本化 Development Charter → Executive Producer 进入正式开发 |
| 禁止事项 | 未授权前：不写 GDD、不写 Charter、不派遣其他角色、不访问/修改 Godot 项目、不写代码 |

## 3. Provenance-aware Discovery Brief

标签：`user_fact`（用户事实）/ `user_confirmed`（用户明确确认）/ `team_proposal`（团队提案，未获用户背书）/ `assumption`（假设）/ `unresolved`（未决）/ `user_preference`（用户偏好）。

### 3.1 user_fact
- 用户是唯一产品负责人和最终决策者。
- 用户原始需求：想让团队开发一个类《吸血鬼幸存者》的割草游戏；想法和需求模糊。
- 生命周期：owner-led Discovery 已完成；当前不在正式开发。
- 用户最终选择方向 A 作为主轴（见 §4）；该选择不是完整 GDD，也不是 Charter。

### 3.2 user_confirmed（已确认基线，不可降级）
1. 第一阶段目标：可玩的 Demo / Vertical Slice。
2. 平台：PC 优先。
3. 核心：极致的清屏、压倒性爽感、解压、打击感、"割草无双"。
4. 保留：移动躲避 + 自动攻击。
5. 改变：升级 / 构筑。
6. 改变：局外成长 / 刷宝。
7. 本轮先继续探索并比较方向，不直接写正式 GDD。
8. 用户原话：「追求极致的爽感和打击感，不是为了刁难玩家，就是为了让玩家解压，为了爽，为了割草无双」。

### 3.3 user_preference
- 无独立于上述 user_confirmed 之外的偏好记录；不得把 team_proposal / assumption 当作用户偏好。
- 注：磁盘文件 discovery-brief-v0.2.md 将"解压而非刁难"标为 user_preference，父线程记录将其归入 user_confirmed 原话（见 §6 差异标注）。本文件以父线程记录为准，待新对话向用户核实。

### 3.4 team_proposal（团队解释/提案，未获用户背书）
- 方向 A 的团队解释：保留熟悉的幸存者类循环，以清屏节奏、敌群反馈、力量跃迁、升级构筑爽感为首个 Demo 验证重点；实现风险较低、差异化相对弱。
- 以上内容未经用户授权不得升级为产品基线。

### 3.5 assumption
- 无父线程明确记录的 assumption（不虚构）。

### 3.6 unresolved（未决，优先级见 §5）
题材、角色、视觉风格、具体打击感来源、单局时长、完成条件、武器/被动/升级/构筑结构、局外成长/刷宝差异化、敌人/Boss/地图/难度、Demo 验收标准、范围上限。

## 4. 用户确认的方向 A 及其已知取舍

- 选择：`A｜忠实幸存者流：把"割草无双"做到极致`（主轴确认）。
- 已知取舍（team_proposal）：保留熟悉循环 → 验证成本低、实现风险较低；换取差异化相对弱。
- ⚠ 注意：磁盘文件 v0.2 中的"方向 A（连击引爆/打击链）"与用户最终选择的 A（忠实幸存者流）**不是同一个概念，不得混淆**。父线程记录中的 A = 忠实幸存者流。

## 5. 未决问题（按优先级）

| 优先级 | 问题 | 说明 |
|---|---|---|
| P0 | 是否授权 Game Director / Creative Director 编写 Creative Brief | 下一正式门；需用户明确授权 |
| P1 | 题材 / 角色 / 视觉风格 | 未确认 |
| P1 | 具体打击感来源 | 爽感的第一性来源未定 |
| P1 | 升级 / 构筑结构 | 用户要"改变"，改为什么未定 |
| P1 | 局外成长 / 刷宝差异化 | 用户要"改变"，形态未定 |
| P2 | 单局时长 / 完成条件 | 未确认 |
| P2 | 敌人 / Boss / 地图 / 难度 | 未确认 |
| P2 | Demo 验收标准 / 范围上限 | 未确认 |
| ✅ 已解决 | `DESIGN_DECISIONS.md` 不再存在 | 旧文档，用户已手动处理并**有意删除**；当前不存在是预期状态，无需恢复、追查或阻塞后续工作（来源：用户明确说明，user_confirmed） |

## 6. 已完成工作、实际角色与证据边界

- 实际完成角色：仅 Product Discovery Consultant——父线程已收到结构化 Discovery Checkpoint **v0.1**；后按用户确认收敛 v0.2，但**可审计的 v0.2 未在父线程收到**（不要假定其已生效）。
- 父协调器：仅做协调、问题收集、provenance 维护与转述；无实质设计/实现/测试。
- 证据边界：本轮（本交接文件创建前）无文件创建、无 commit、无 Godot 项目访问/修改、无运行时/视觉/构建/QA 证据；Discovery Brief 此前仅存于对话内。
- 本会话磁盘观测（供新对话核实，未据此升级任何结论）：
  - `docs/discovery-brief-v0.2.md` 存在于磁盘（93 行；文件系统时间戳 2026-08-15 16:21:32）。内容已被本会话读取，但其是否即"最终可审计 v0.2"无法由父线程佐证 → 标为"磁盘存在、来源未验证"。
  - 该文件引用的 `DESIGN_DECISIONS.md`：旧文档，用户已手动处理并**有意删除**，当前不存在是预期状态；无需恢复、追查或阻塞后续工作（来源：用户明确说明，user_confirmed）。
  - 该文件将"解压基调"标 user_preference，父线程归 user_confirmed → 标签差异待用户核实（本文件以父线程为准）。
  - 工作目录 glob 未发现 Godot 工程文件（如 project.godot）。

## 7. 尚未发生的事情

- 无正式 GDD；无 Creative Brief；无 Development Charter。
- 无代码、无 Godot 项目文件变更、无 commit、无构建/运行/QA 证据。
- 无 ADR（本轮无技术/架构决策，按指示不创建）。
- 无 changelog 更新（本轮无项目变更，按指示不更新）。
- 未派遣除 Product Discovery Consultant 外的任何团队成员。

## 8. 下一对话推荐开场提示词

> 请先读取 `D:\Game\New_Game\docs\DISCOVERY_HANDOFF.md`（跨对话交接文件），并对照检查工作目录现状。然后向用户复述状态：生命周期处于 Discovery 完成、未进入正式开发；方向 A（忠实幸存者流）已确认为主轴，但**不是 GDD、不是 Charter**。接着询问用户：**是否授权 Game Director / Creative Director 编写 Creative Brief？** 在得到明确授权前，不要写 GDD、不要进入开发、不要访问/修改 Godot 项目。

## 9. 变更/决策台账

| 决策/事件 | 日期 | 来源 / owner | 状态 / 证据 |
|---|---|---|---|
| 用户提出类 VS 割草游戏原始需求（模糊） | 日期未记录 | 用户 | user_fact |
| 用户确认第一阶段 Demo/Vertical Slice、PC 优先等基线 | 日期未记录 | 用户 | user_confirmed（见 §3.2） |
| 用户原话：极致爽感 / 解压 / 割草无双 | 日期未记录 | 用户 | user_confirmed |
| 用户选择方向 A｜忠实幸存者流 | 日期未记录 | 用户 | 主轴确认（非 GDD/Charter） |
| Product Discovery Consultant 返回 Checkpoint v0.1 | 日期未记录 | 产品发现顾问 | 父线程已收到 |
| v0.2 收敛（磁盘文件） | 文件系统时间戳 2026-08-15 16:21:32；对话日期未记录 | 产品发现顾问 | 磁盘存在；父线程未收到可审计报告 → 待验证 |
| Discovery 目标标记 complete | 日期未记录 | 协调器 / 用户 | 状态记录 |
| 本交接文件创建 | 日期未记录 | Doc Scribe | docs/DISCOVERY_HANDOFF.md |
| DESIGN_DECISIONS.md 有意删除 | 日期未记录 | 用户 | user_confirmed；旧文档已手动处理，不再存在，无需恢复/追查 |

## 10. 交接验收清单

- [ ] §1–§9 字段齐全
- [ ] 来源标签正确：user_fact / user_confirmed / team_proposal / assumption / unresolved / user_preference 无混淆
- [ ] 无虚构证据：v0.2 明确标为"磁盘存在、父线程未收到"；DESIGN_DECISIONS.md 已由用户确认有意删除（不再存在，已解决）
- [ ] 未创建 ADR、未更新 changelog（按用户指示）
- [ ] §8 开场提示词包含"先读本文件 + 询问授权 Director"，且不自动开发
- [ ] 日期信息缺失处以"日期未记录"标注，未编造日期
