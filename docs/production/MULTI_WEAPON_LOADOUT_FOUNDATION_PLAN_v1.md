# Multi-Weapon Loadout Foundation 开发计划

状态：`APPROVED / IMPLEMENTATION DEFERRED`
日期：2026-08-22
授权方：用户
实施状态：未开始

---

## 1. 目标

将当前“单主武器 + 三阶强化”的实现迁移为真正的类幸存者多武器构筑基础。

玩家在同一局内能够同时装备多把武器；每把武器拥有独立等级、冷却、攻击事务、VFX/SFX 和升级路径。现有工业能量装置与未来枪炮、火箭筒、无人机共用同一套装备、攻击、升级和重置框架。

本计划只定义多武器基础能力，不直接新增 Furnace Orb、火箭筒、无人机或手动瞄准。

## 2. 产品规则

- 初始装备上限采用 4 槽位作为候选产品参数，不冻结为不可调常量。
- 首次升级仍保持默认 3 选 1。
- 后续升级卡允许混合出现：获得新武器、强化已有武器。
- 初期禁止重复装备同一 `weapon_id`；每个装备仍有稳定 `slot_id`，为未来重复装备或衍生版本预留空间。
- 每把武器独立触发，不因另一把武器攻击而延后、覆盖或清空。
- 满级内容不进入强化候选。
- 所有重置必须走 canonical reset。

## 3. 权威状态

运行时保持唯一写入者。UI、VFX 和音频只能读取投影状态。

```gdscript
{
  "schema_version": "loadout-v1",
  "max_slots": 4,
  "slots": [
    {
      "slot_id": "slot-001",
      "weapon_id": "rail_pierce",
      "rank": 1,
      "slot_order": 0,
      "next_fire_tick": 0,
      "next_attack_seq": 0
    }
  ],
  "next_slot_seq": 2,
  "next_offer_seq": 1
}
```

迁移期允许从第一个槽位派生 `active_build`、`build_rank` 和旧布尔字段，作为只读兼容镜像；它们不再拥有写入权，后续会删除。

## 4. 独立攻击事务

每个槽位以 session tick 独立调度：

1. 每个 simulation tick 收集所有到期槽位。
2. 按 `slot_order`、`slot_id` 稳定排序，保证同 tick 发射顺序可复现。
3. 每次发射创建唯一 `attack_id`，例如 `r7:s002:a04`。
4. envelope 传递 `attack_id`、`slot_id`、`weapon_id`、等级、delivery、目标数量和攻击 profile。
5. rules 为每个 `attack_id` 保存独立不可变目标快照和结算状态。
6. `refresh` 与 `resolve` 必须使用同一个 attack identity。
7. 所有命中、击杀、Arc Coil hop trace、adapter feedback、VFX 和 SFX 必须携带所属 attack/slot identity。
8. 若某敌人已被另一攻击事务击杀，后续事务必须记录 invalid/no-hit，不得制造幽灵命中。

Arc Coil 保留规则驱动的 hop trace，但需绑定所属 `attack_id`。Kinetic Pulse 必须从每帧持续行为迁为有独立冷却的槽位脉冲。

## 5. 升级卡事务

每次升级窗口创建 run-scoped `offer_id`；每张卡拥有稳定 identity：

```gdscript
{
  "offer_id": "r7:o12",
  "card_id": "r7:o12:c2",
  "kind": "add_weapon" | "upgrade_weapon",
  "weapon_id": "scatter_fan",
  "target_slot_id": "slot-002",
  "target_rank": 2
}
```

- `add_weapon`：创建 rank 1 新槽位，不替换已有装备。
- `upgrade_weapon`：只修改目标槽位，不改变其他槽位的等级、冷却或攻击序号。
- 可选卡来自未装备且有空槽的武器，以及已装备但未满级的槽位。
- 过期、重复、错 run 或错 slot 的选择必须拒绝并记录事件。
- UI 仍固定显示三张卡；不因多武器系统扩大到四选一。

## 6. HUD 与重置

HUD 改为紧凑武器槽，逐槽显示：

- 图标；
- 名称；
- R1 至 R3 等级；
- 可选冷却进度。

升级卡必须明确区分“新增武器”和“强化现有武器”。

新增唯一 `_reset_loadout()`，由 canonical `_auto_restart()` 调用，并清理：

- 槽位、等级、冷却和 attack sequence；
- pending offer 与 card state；
- pending attack transactions；
- Pulse、Arc Coil trace 和所有 transient VFX；
- 兼容镜像与 HUD 投影。

同时统一 runtime `session.reset()` 与 rules reset epoch 的跨运行事实，避免存在两套看似等价的重置语义。

## 7. 实施阶段

### MW-1：Loadout 数据与兼容投影

- catalog 增加每把武器的独立冷却资料；
- 新增 `loadout-v1` helper 和槽位状态；
- 从单武器状态迁移一个 slot；
- HUD 开始读取槽位列表；
- 不改变现有单武器战斗行为。

### MW-2：规则多攻击事务

- rules/adapter 增加 `attack_id`、`slot_id`、`weapon_id` 和独立 snapshot/result；
- 先让 Rail Pierce 与 Arc Coil 在同一 run 并行工作；
- 新增跨事务死亡后 invalid/no-hit 规则与测试。

### MW-3：多槽位 Runtime 调度与呈现归属

- 按每槽位 `next_fire_tick` 调度所有到期武器；
- VFX/SFX 按 attack identity 归属；
- 迁移 Pulse 为独立冷却脉冲。

### MW-4：混合升级 Offer 与 HUD 完整接线

- 支持新增武器与升级已有武器混合出现；
- 引入 `offer_id`、`card_id`、`kind`、`target_slot_id`；
- 阻止重复和陈旧选择；
- HUD 显示多个武器槽与等级。

### MW-5：Canonical Reset 与证据收口

- 删除单武器 writer 路径和遗留镜像依赖；
- 验证槽位、冷却、攻击事务、VFX 和 offer 不跨局泄漏；
- 更新 Integration Contract、QA receipt 与验收材料。

## 8. 验证策略

### L1

- catalog 冷却、稳定排序、等级上限、装备资格；
- 两把武器同 tick 的独立 `attack_id`、独立 snapshot、确定顺序；
- Arc Coil trace 的 attack identity；
- 跨攻击事务击杀后的 invalid/no-hit；
- `add_weapon` 不替换已有槽位；
- `upgrade_weapon` 只强化目标槽位；
- 过期/重复 offer 拒绝；
- reset 清空槽位、冷却、attack sequence、offer 和 transient trace。

### L2

在真实 Main 场景内完成以下事务：

1. 选择 Rail Pierce；
2. 后续选择新增 Arc Coil；
3. 再选择 Rail Pierce 升至 R2；
4. 放置可控敌群，验证 Rail direct 与 Arc chain 使用不同 `slot_id/attack_id` 且不会互相覆盖；
5. 执行 canonical reset，验证 loadout、HUD、冷却、offer、trace 和临时效果清空，`run_id` 增长。

每条 receipt 至少携带：candidate identity、run ID、offer ID、card ID、slot ID、attack ID、前后 loadout state 与 artifact hash。

## 9. 风险与停止条件

- 最高风险是将单份 rules snapshot/result 改为多攻击事务集合；在 MW-2 的纯规则测试通过前，不接入多槽位 runtime。
- UI 当前固定三卡与单武器 HUD；保持默认三选一，不把卡位扩展到四张。
- 多武器会增加 transient VFX；每种效果必须具有 attack identity、可见上限和 reset 清理。
- 不继续为单武器模型新增 Furnace Orb、火箭筒或无人机，直到 MW-2/MW-3 建立并验证并行攻击能力。

## 10. 输入安全

- 默认禁止真实 Windows 键盘输入。
- 只有用户明确要求时，才可使用 `--allow-real-input`。
- 游戏窗口失去前台后立即停止，记录 `environment_blocked`。
- 不继续发送 WASD、数字、ESC 或 R；不抢回前台；不关闭或杀死未知 Godot/editor 进程。
- 多武器阶段的默认验证路线是静态检查、gdUnit、headless、QA viewport 和离线安全测试。

## 11. 验收边界

本计划获得授权，但当前状态为 `APPROVED / IMPLEMENTATION DEFERRED`。

未经后续明确实施授权，不修改代码、资源、规则、测试、导出、配置或证据。即使 MW-1 至 MW-5 实施完成，仍需独立玩家评估和用户明确决定，才可将多武器系统标记为 accepted。
