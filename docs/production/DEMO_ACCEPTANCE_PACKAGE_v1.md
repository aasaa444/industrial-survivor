# Demo 验收包 v1 — Industrial Survivor Demo（P7）

日期：2026-08-22 ｜ 候选：`d9057b6`（导出树 `55ba8e1`，事务代码 SHA `c61937f`）

**验收裁决（用户填写）：** `通过 / 拒绝 / 暂缓`：________ 　日期：________

**裁决问题（唯一）：把 `godot_game_dev/export/build/NewGameDemo.exe` 发给朋友双击运行，是否达到"愿意给朋友试玩"的标准？**

---

## 一、试玩路径（2 分钟自查）

1. 双击 `NewGameDemo.exe`（单文件，118.7MB，无需安装；sha256 前缀 `aabce0ea`）。
2. 3 秒内：玩家（工业小人）居中、竞技场、目标行"存活到 06:00 · WASD/方向键移动，自动攻击"。
3. ~3 秒后敌人从视野边缘涌入并追击；自动攻击亮青色轨迹，击杀掉落青色能量核心，靠近自动吸取（有拾取音，连收升调）。
4. **~31 秒**弹出三张构筑卡（1 轨道穿透 / 2 散射扇面 / 3 动能冲击）——按 1/2/3、←→+回车或鼠标点击。
5. **~58 秒 / ~100 秒**各一次单卡强化（rank 2/3，攻击轨迹变宽变亮、扇面扩大、冲击增强）。
6. ESC 暂停 / R 重开；胜利=存活 6:00，失败=被围殴扣 3 格生命；结果页显示时间/等级/击杀/构筑，R 立即重开且无残留。
7. M 键可静音 SFX（玩家自留逃生门，非掩盖问题）。

## 二、证据索引（全部当前候选链生成）

| 项 | 路径 | 级别 |
|---|---|---|
| 六步升级事务（双分支 ×2 轮，SHA 绑定） | `qa/evidence/upgrade_tx/tx-{choice,upgrade}-1787347969/72.jsonl` + receipt `qa/contracts/receipts/upgrade_build_v1-c61937f.json` | L2 |
| 60–90 秒玩家切片（9 截图 + 真实键盘交互记录） | `qa/evidence/P3-SLICE-34ee88e/`（interaction_record.json + manifest.jsonl） | L3 |
| 6 分钟完整回路（节奏 31.4/58.2/101s，xp==kills 1:1，胜利+重开清洁） | `qa/evidence/p4_six_minute_fixed.log` | L2 |
| 失败路径（真实坏走位输入，自然死亡，结果页一致，R 重开清洁） | `qa/evidence/P4-DEFEAT-4e749e8/`（defeat_result.png 等） | L3 |
| 导出包内 6 分钟回路（节奏 31.4/58.3/100.3s，胜利，fps 124–146） | `qa/evidence/p6_export_six_minute.log` | L2 |
| 导出包真实输入切片（两轮：初版+终版，移动/选卡/暂停/重开） | `qa/evidence/P6-RELEASE-CHECK/`、`qa/evidence/P6-RELEASE-FINAL/` | L3 |
| 单一 writer 迁移 + 集成合同 | `qa/contracts/upgrade_build_v1.json`、`qa/contracts/candidate_binding.json` | L1 |

## 三、本轮修复的关键缺陷（均经证据验证）

1. 升级系统多重 writer → 统一为 `choose_upgrade(index, source)` 唯一命令 + 三个权威状态字典（P1，writer 扫描零残留）。
2. **重开残留 bug**：fan/pulse 构筑镜像未被重置，跨局残留 → 权威 reset 修复（重开 HUD 截图证明清洁）。
3. **每帧 XP 收集 bug**：飞行中的能量核心每帧 +1 XP（约 40 倍膨胀，三升级挤进前 20 秒）→ 移入收集判定；阈值校准 5/25/60→10/45/120，节奏命中 31/58/101s，xp==kills 严格 1:1。
4. 自回归夹具过期（静态敌人超出攻击范围）+ 结果期暂停死锁 → 修复，回归全链路 exit 0。
5. 三重暂停层泄漏（构造循环内 3 次创建）→ 修复。
6. XP 拾取无声（品类基准缺口）→ 新增拾取音（连击升调+限流，音量层级在击杀之上、升级之下）。

## 四、已知风险与延后范围

- **体感终裁待用户**：拾取音/击杀音/胜负 jingle 的耳朵验收、移动手感、构筑差异手感——客观基线已对齐品类（VS/Brotato/20MTD），标记 `partial` 直至用户确认。
- 鼠标点击选卡在当前候选链上未重跑真实鼠标输入（键盘/全局鼠标路径经 P1/P2 统一验证；此前轮次已验证点击路径）。
- 调试 HUD 字段默认隐藏（DEBUG_HUD=false），但 `attack_state` 等内部行未删除，仅不可见。
- 每帧 XP bug 的发现依赖 xp/kills 比率复核——建议后续把该比率纳入六分钟观察器的自动断言（本轮为人工发现）。
- Windows 10+ x86_64 单目标；未做中低端硬件真机基线（headless min fps 70、真实渲染器 124+，未见卡顿信号）。

## 五、最终状态（按计划规则）

`L2 + L3 + L4/L5 导出包齐全，等待用户验收` → 用户通过后记为 `demo-ready / accepted`；当前为 `playable exported demo / unaccepted`。
