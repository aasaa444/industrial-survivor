# GIT_INIT_REPORT v0.1 — 本地 git 仓库初始化

- **报告日期**：2026-08-16
- **执行成员**：Toolchain Engineer（工具链工程师）
- **仓库根**：`D:\Game\New_Game`
- **状态**：completed

---

## 1. 初始化记录

| 步骤 | 命令 | 结果 |
|------|------|------|
| 检查现有仓库 | `Test-Path D:\Game\New_Game\.git` | `False`（确认非 git 仓库） |
| 初始化 | `git init D:\Game\New_Game` | `Initialized empty Git repository in D:/Game/New_Game/.git/` |
| 首次提交 | `git commit` | root commit `0778dd6`（667 files, 65667 insertions） |

- **git 版本**：`git version 2.40.0.windows.1`
- **未配置远程、未 push**（`git remote -v` 输出为空）
- **分支**：`master`

---

## 2. `.gitignore` 规则清单与理由

创建了仓库根 `D:\Game\New_Game\.gitignore`（新文件）。项目子目录 `godot_game_dev/` 已自带 `.gitignore`（`.godot/`、`/android/`），二者互补。

### 2.1 Godot 4.x 运行时缓存
| 规则 | 理由 |
|------|------|
| `.godot/` | Godot 4.x 编辑器缓存目录（editor/imported/uid_cache 等），打开/保存时自动重建，不入库 |

### 2.2 gdmcp 工具链
| 规则 | 理由 |
|------|------|
| `godot_game_dev/.gdmcp/bin/`，`.gdmcp/bin/` | `.gdmcp/` 目录当前仅含 `bin/gdmcp.exe`（约 4.7 MB 编译型 CLI，来自 godot_mcp addon 的工具安装产物）。工具链仓库**版本化配置，而非下载的二进制**。保留 `.gdmcp/` 目录本身可跟踪（未来 project checkpoints/config 可入库），仅忽略二进制 `bin/` |

### 2.3 Godot 平台/导入产物（安全可再生成的缓存）
| 规则 | 理由 |
|------|------|
| `/android/` `/ios/` `/web/` `/export/` | 导出输出目录，按需生成 |
| `*/build/` `*/export_presets.cfg` | 构建产物 |
| `*.tmp` `*.translation.bin` | 临时与翻译缓存 |

### 2.4 临时 / 编辑器 / OS 垃圾
`*.log .tmp .bak .swp *~ .DS_Store Thumbs.db desktop.ini .fseventsd/ .idea/ .vscode/ *.code-workspace logs/ coverage/ *.cache`

### 2.5 DSH / skill harness 内部工具状态（非项目交付物）
| 规则 | 理由 |
|------|------|
| `.dsh-vision-router/` | 视觉工具裁剪/热图/diff 报告等可再生成瞬态产物 |
| `.skill-evals/` | skill 评测基准产物，与游戏项目无关 |

### 2.6 保留（明确不入忽略）
- **`docs/` 全量**：治理/设计/证据文档必须版本化
- **`godot_game_dev/` 源文件与配置**：`project.godot`、`icon.svg(+.import)`、`.editorconfig`、`.gitattributes`、`.gitignore`、`addons/`（gdUnit4、godot_mcp 源码）
- 忽略规则生效验证：`git status --ignored` 显示 `.godot/`、`.gdmcp/` 为 `!!`（已忽略）

---

## 3. 首次提交内容

**Commit**：`0778dd6e169ef0d126c87b488b43cc103ef69d41` — `New_Game: initial commit`
（信息含项目名 `New_Game`、日期 `2026-08-16`、内容范围说明；root commit，无父提交）

### 3.1 提交文件（667 个）
- **docs/**（约 50 文件）— 全部治理/创意/架构/证据/生产/UX/视觉文档
- **godot_game_dev/** 项目脚手架：
  - `project.godot`、`icon.svg`、`icon.svg.import`
  - `.editorconfig`、`.gitattributes`、`.gitignore`（子目录自身）
  - `addons/gdUnit4/`（完整源码 + LICENSE + runtest 脚本）
  - `addons/godot_mcp/`（完整源码 + LICENSE + README + translations + ui）

### 3.2 已忽略 / 未纳入提交
- `godot_game_dev/.godot/` — 编辑器缓存
- `godot_game_dev/.gdmcp/bin/gdmcp.exe` — 二进制工具产物
- `.dsh-vision-router/`、`.skill-evals/` — harness 内部工具状态

---

## 4. 跳过的待提交项（实现成员进行中文件）

提交刚完成（`0778dd6`）后，实现成员（Godot Gameplay Engineer，`b4c9cc1c`）在 `23:56:37` 经 GDMCP 新建了**游戏源文件**，出现为未跟踪项。按既定干扰规避策略，**本次首次提交不纳入**这些可能正被写入的半成品，留待后续提交（稳定后）收尾：

| 路径 | 大小 | 状态 |
|------|------|------|
| `godot_game_dev/rules/rules_core.gd` | 8884 B | 未跟踪（提交后新建） |
| `godot_game_dev/rules/session.gd` | 2529 B | 未跟踪（提交后新建） |
| `godot_game_dev/test/rules_core_test.gd` | 7169 B | 未跟踪（提交后新建） |

> 注：本次提交前检查（23:55）确认当时无任何半成品 `.gd` 文件存在；三类文件均于提交之后生成。

---

## 5. 验证输出

```
=== git log --oneline ===
0778dd6 New_Game: initial commit

=== git status (--short --ignored) ===
?? godot_game_dev/rules/
?? godot_game_dev/test/
!! .dsh-vision-router/
!! .skill-evals/
!! godot_game_dev/.gdmcp/
!! godot_game_dev/.godot/

=== git remote -v ===
（空 — 无远程）
```

- 工作区相对已提交内容**干净**（忽略项正常排除）；唯一未跟踪为上述 3 个实现中成员文件（待后续提交）。
- 数据不变量：全程**未改动**任何 docs/ 文档内容、未改动任何 Godot 构件内容；仅新增 `.gitignore` 根规则与本报告。

---

## 6. 副作用说明 / 边界声明

- **未配置远程仓库、未 push**
- **未修改**任何 docs/ 治理文档内容
- **未修改**任何 Godot 源文件/构件内容（git 只读跟踪）
- **未删除**任何文件
- **未干扰**实现成员 `b4c9cc1c` 的进行中工作（其新建文件未被捕获，留待后续提交）
- **未**访问/修改 Godot 运行时，未涉及候选数值/契约/QA verdict
