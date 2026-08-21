# Upgrade Integration State Owner Map - Current Baseline

> **Status:** diagnosis only; this is not an accepted implementation contract.
> **Scope:** XP -> level -> build choice/upgrade -> HUD/input/weapon/VFX/audio/reset.

## Current Fault Map

| Surface | Current state/writer | Current readers | Fault |
|---|---|---|---|
| XP/level | `player_xp`, `player_level` in `runtime/main.gd` | `_update_growth_hud`, pickup trigger | Direct fields are authoritative today, but HUD has legacy read-model overlap |
| Build | `active_build` plus `rail_pierce_active`, `scatter_fan_active`, `kinetic_pulse_active` | attack target cap, pulse, fan lines, HUD | Multiple state representations can disagree |
| Upgrade lifecycle | `_upgrade_phase`, `_card_state`, `_card_selected_idx`, `_card_input_guarded` | card UI, input, finalize | Input and transition guards are distributed across handlers/polling |
| Legacy completion | `_upgrade_first_done`, `_upgrade_second_done` | XP trigger/reset/visual paths | Historical flags still participate in progression decisions |
| HUD | `b2_label`, `xp_label`, old read-model labels | `_update_growth_hud`, `_present_read_model` | Multiple writers caused “level 1 / XP full” contradiction |
| Input | `_unhandled_input`, `Input.is_key_pressed`, mouse signals, QA args | `_select_upgrade_card` | Multiple entrances must converge on one command |
| VFX | attack/fan/confirm nodes and fixed-position remnants | finalize/feedback helpers | Card rect and effect position can diverge |
| Audio | attack player, upgrade/card/jingle players | lock/hit/kill/finalize | Must bind only to authoritative feedback event |
| Reset | `_auto_restart` | all fields/nodes | Every new state must have one reset owner |

## Target Transaction

```text
EnergyCore collected
 -> ProgressionState.xp mutation
 -> threshold check
 -> UpgradeUIState.open
 -> cards derive from BuildState/current level
 -> one choose_upgrade(index, source) command
 -> ProgressionState.build/rank mutation
 -> HUD derives from ProgressionState
 -> weapon resolver derives from ProgressionState
 -> VFX/audio consume emitted upgrade/hit events
 -> UI close + reset path remains owned by ProgressionController
```

## Target Owner

One `ProgressionController` (initially can be a bounded section in `main.gd`, later extracted) owns XP, level, build, rank, upgrade open/choice, and reset. Existing booleans become read-only compatibility projections, then are deleted in the same integration slice.

## Legacy Retirement

- Fixed tick upgrade trigger: remove; XP threshold is sole writer.
- `_upgrade_first_done` / `_upgrade_second_done`: remove as progression writers; replace with `build`/`rank` state.
- `rail_pierce_active` / `scatter_fan_active` / `kinetic_pulse_active`: remove as authoritative writers; derive behavior from `build`.
- Fixed card confirmation coordinates: remove; derive from selected `Control.get_global_rect()`.
- Independent input mutation paths: converge to `choose_upgrade(index, source)`.

## Evidence Required

A cross-surface test must observe one transaction: XP increase, upgrade UI state, selected index, build/rank state, HUD text, weapon behavior, VFX placement, audio event, and reset. Logs or a screenshot alone are insufficient.
