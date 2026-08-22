# CR-TOOLING-001 — Screenshot Evidence Chain and Systemic Fault Gates

状态：`implemented / tool route verified / M3 visual acceptance remains partial`
日期：2026-08-22
触发：Pulse VFX 视觉捕获重复失败，错误桌面窗口被裸 `ImageGrab` 采样，证据对象身份断裂。

## 原始请求

用户要求：不急于推进游戏开发，先修复制度和证据工具，确保持续从全局边界思考而不是局部重试。

## 影响的不可变规则

- `godot-game-team` 的 Tool Factory、Evidence Ladder、Integration Integrity Gate；
- 视觉验收不能把错误窗口或无状态绑定图片当作 L3；
- 生产游戏内容在工具整改期间冻结。

## 实施

1. 团队制度新增 `Systemic Fault Gate`：首次修复前必须写 System Boundary Map；第一次局部修复失败后自动升级 Integration/Tooling/Product Reality fault；禁止绕过受保护工具；阻塞 UI 必须验证模拟/输入/恢复事务；Closure Review 强制根因、证据身份和负例。
2. Tooling 专家新增 `Evidence Identity Contract`：内部 viewport 与原生窗口 capture 职责分离，必须使用 transaction/SHA 关联。
3. 新增 QA-only `qa_runtime_viewport_capture.tscn` 和 `tools/runtime_capture.py`：驱动真实 Main 的 Pulse+近身敌人状态、写 viewport/state/log/manifest，拒绝 SHA/工件错误。
4. 新增 Tool Reference 和 Tools Inventory。

## 验证

| 用例 | 证据 | 结果 |
|---|---|---|
| dry-run | `runtime_capture.py --dry-run` | passed，无项目修改 |
| 正向 Pulse | `CAPTURE-PULSE-002` | passed，pulse/rank/enemy/tick/viewport SHA 绑定 |
| 错误 SHA | `CAPTURE-NEG-SHA2` | rejected，exit 2 |
| 缺失工件 | `CAPTURE-NEG` | rejected，exit 2 |
| 冷启动重复 | `CAPTURE-PULSE-002` 与 `003` | passed，不同 transaction 和 PNG SHA |
| headless render backend | runtime.log | 正确暴露 viewport texture 不可用，未生成 pass artifact |

## 剩余边界

- 新工具目前证明 L2 authoritative state + 内部 viewport render。
- 原生玩家窗口层必须继续使用 `capture_game_window.py` 的 foreground identity guard。
- 当前尚未实现自动 `paired` native orchestration，因为需要一个工具拥有的可见窗口 session lease；不能为方便而抢焦点或使用裸桌面裁剪。
- Pulse 在 state/render route 已捕获，但是否足够醒目仍是 M3 的视觉 QA/用户判断，当前 M3 保持 `partial`。

## 处置

`CR disposition: absorb_within_authority`。工具整改完成后才允许恢复 M3；恢复时必须以同一 transaction_id 完成内部 state/viewport 与受保护 native window capture 的关联。
