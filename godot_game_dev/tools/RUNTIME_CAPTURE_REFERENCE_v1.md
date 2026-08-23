# Runtime Capture Tool Reference v1

工具：`res://tools/runtime_capture.py`
QA 场景：`res://qa/qa_runtime_viewport_capture.tscn`
版本：`runtime-capture-v1`
状态：`ACTIVE`

## 目的

为跨表面功能提供一个不依赖桌面像素裁剪的内部状态/渲染证据层。当前 canonical 场景是 Arc Coil：同一工件链路绑定 `arc_coil_chain_active`、Arc Coil 构筑、hop 0/1 trace、VFX 节点、tick、viewport PNG 和完整候选身份。历史 Pulse 工件属于 `legacy_identity_partial`，不得用当前 Arc Coil validator 重新确认或推进严格 Slice gate。

## 不替代的证据层

| 层 | 工具是否提供 | 结论 |
|---|---:|---|
| 权威状态 | 是 | L2：指定状态在指定 tick 发生 |
| Godot viewport 渲染帧 | 是 | 内部渲染确实产生 PNG |
| 原生窗口标题/PID/矩形 | 否 | 必须使用 `capture_game_window.py` |
| 桌面实际可见像素 | 否 | 必须使用 foreground-protected 原生窗口 route |
| 玩家体验/视觉质量 | 否 | 由 QA/用户检查相关帧 |

不能把 `viewport.png` 单独称为玩家可见窗口证据，也不能把 native window PNG 单独称为精确业务状态证据。

## 命令

```bash
# 查看不会改项目的执行计划
python godot_game_dev/tools/runtime_capture.py \
  --project-root godot_game_dev \
  --output-dir godot_game_dev/qa/evidence/<id> \
  --transaction-id <id> --candidate-sha <sha> --dry-run

# 生成内部状态 + viewport 工件
python godot_game_dev/tools/runtime_capture.py \
  --project-root godot_game_dev \
  --output-dir godot_game_dev/qa/evidence/<id> \
  --transaction-id <id> --candidate-sha <sha>
```

工具创建并拥有窗口化 QA Godot 进程。QA scene 正常退出；工具不会杀编辑器、未知 Godot 或按进程名批量结束。

## 工件

```text
<output-dir>/viewport.png   内部 viewport 帧
<output-dir>/state.json     authoritative state summary
<output-dir>/runtime.log    QA scene stdout/stderr
<output-dir>/manifest.json  checksum、身份和证据边界
```

`state.json` 必须包含：capture/transaction ID、完整 candidate identity、scenario/state/action、progression/build/upgrade UI、alive enemies、camera、recent input、Arc Coil trace/VFX、证明边界。

## Paired Capture 合同

需要同时证明状态和玩家窗口时：

```text
同一 transaction_id
-> runtime_capture viewport/state artifact
-> tool-owned native runtime session
-> capture_game_window.py native artifact
-> manifest 关联 SHA、状态、PID/title/rect
```

原生捕获拒绝非前台、编辑器、错误 PID、错误标题、窗口不唯一、窗口过小、平坦图像。该拒绝是安全边界，禁止用裸 `ImageGrab` 绕过。

## 自测

| 类型 | 命令/场景 | 预期 |
|---|---|---|
| Dry-run | `--dry-run` | exit 0，无项目修改 |
| Positive | Arc Coil paired QA capture | exit 0，state + viewport + manifest，Arc Coil/hop/VFX/tick 绑定 |
| Negative: SHA | `--negative-fixture wrong-sha` | exit 2，candidate identity mismatch，no pass manifest |
| Negative: missing | `--negative-fixture missing-artifact` | exit 2，无 artifact |
| Render backend guard | headless Dummy renderer | QA scene显式失败 `viewport texture unavailable`，不得写 passed |

## 失败矩阵

| 失败 | 分类 | 安全动作 |
|---|---|---|
| viewport texture 缺失 | Tooling Fault | 拒绝；改用工具拥有的窗口化 QA session |
| state/json/png 缺失 | Tooling Fault | exit 2；不得生成 pass manifest |
| candidate SHA 不匹配 | Evidence identity failure | exit 2；重新生成，不复用工件 |
| native window 不在前台 | Native capture safety guard | 原生 route 拒绝；不调用低级桌面裁剪作为证据 |
| 外部窗口/错误应用像素 | Evidence contamination | 作废工件；重新走 paired route |
| Arc Coil state active 但视觉不明显 | Visual QA gap | 保留 L2；标记 partial，不能通过视觉验收 |

## 重新验证触发器

- Godot 版本、渲染器、OS 截图后端变化；
- QA capture scene、启动层、Arc Coil VFX、viewport size 改动；
- 窗口会话/所有权机制改动；
- 发现错误应用画面或 metadata 不匹配。
