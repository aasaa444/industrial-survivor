# Integration Integrity Reference v1

Use this template for any player-facing feature spanning two or more surfaces.

## State Owner Map

```text
Feature:
Authoritative state owner:
Production writers:
Readers:
Input entry points -> one command:
UI/read-model source:
Gameplay behavior source:
VFX/audio event source:
Reset/reload owner:
```

## Feature Transaction Graph

```text
trigger
 -> single state mutation
 -> UI/read-model update
 -> gameplay behavior update
 -> VFX/audio feedback
 -> close/reset/recovery
```

For each arrow record the observable event, owner, and evidence path.

## Legacy Path Retirement

```text
New path:
Removed legacy path:
Temporary read adapter:
Expiry condition:
Proof legacy path no longer writes:
```

Compatibility writers cannot survive the current integration slice.

## Cross-surface Consistency Matrix

| Feature | Trigger | State | UI | Behavior | VFX | Audio | Reset | Evidence | Verdict |
|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | |

## Integration Fault

Trigger when the same player-facing issue survives two local patches. Stop adding conditionals. Map all writers/readers/input routes, identify legacy paths, rebuild the transaction, and route implementation back to the owning hat.

## Evidence boundary

A unit test, applied log, screenshot, or visual artifact alone does not prove cross-surface consistency. The same player transaction must be observed across state, UI, behavior, VFX/audio, and reset.
