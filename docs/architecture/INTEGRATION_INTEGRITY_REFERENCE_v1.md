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

## Machine Gate

`tools/verify_integration_contract.py` is the staged-only static gate. It never stages, formats, cleans, resets, stashes, or scans unstaged workspace content.

```powershell
python godot_game_dev/tools/verify_integration_contract.py `
  --project-root . `
  --contract godot_game_dev/qa/contracts/upgrade_build_v1.json `
  --dry-run
```

A production cross-surface commit must include a contract and a reviewed runtime receipt. The enabled `.githooks/pre-commit` hook rejects the staged candidate unless `INTEGRATION_GATE_RECEIPT=passed` is set after the runtime evidence has been reviewed. The hook is not a substitute for the runtime verifier; it prevents accidental commits that skip the receipt.

`tools/verify_runtime_transaction.py` validates a six-step JSONL transaction in strict order:

```text
trigger -> mutate -> read_model -> behavior -> feedback -> reset
```

It rejects missing/duplicate/out-of-order steps, contract/project/SHA mismatch, missing state/action/event/log/artifact fields, and dirty reset evidence. It exits nonzero for failed/partial evidence. A pass still does not replace visual QA or user acceptance.

## Commit Safety

The hook reads only `git diff --cached`. It never touches existing user modifications, unknown processes, or unstaged evidence. If a gate cannot be satisfied, leave the candidate uncommitted and report the blocker; do not weaken the contract or auto-stage files.



A unit test, applied log, screenshot, or visual artifact alone does not prove cross-surface consistency. The same player transaction must be observed across state, UI, behavior, VFX/audio, and reset.
