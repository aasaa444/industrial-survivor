# IMPL_TERMINAL_RESET_v0_1

- **Dispatch:** Godot Gameplay Engineer, New_Game Producer v0.4 Unit 4; retry **2/5**.
- **Status:** implementation complete / local evidence collected; independent QA acceptance remains separate.

## Scope delivered

### T2 — rules-core terminal extension
- `rules/rules_core.gd` remains engine-free, deterministic, and zero-RNG.
- Terminal input is carried as `terminal_input.timer_completed`.
- Same-tick arbitration is applied after legal contact/resolve events: life depletion (`segments_lost >= 3`) wins over completion; otherwise completion yields victory.
- Terminal state carries `terminal_outcome`, `result_locked`, and `reset_pending`.
- Locked results reject subsequent gameplay contact input and suppress re-arbitration.
- `task == "reset"` performs clean rules-state reinitialization, increments `reset_epoch`, emits `reset_event`, and clears life, candidate/snapshot, hit/kill, invalidation, contact, and terminal state. Session-owned RNG/run-id reset remains in `rules/session.gd`.

### T3 — deterministic fixtures
Added to `test/rules_core_test.gd`:
- `TERMINAL-life-depletion-first`
- `TERMINAL-victory`
- `TERMINAL-defeat-light-interruption`
- `TERMINAL-result-lock`
- `TERMINAL-stale-input-rejected`
- `RESET-auto-restart`
- `RESET-no-cross-run-loss`
- additive terminal-absent compatibility coverage

### T4 — adapter/runtime seam
- `adapter/adapter.gd` carries terminal domain input and translates only terminal/reset domain events into result/reset feedback fields.
- `runtime/main.gd` disables gameplay processing during the result phase, presents the domain-decided outcome, calls the session reset after the candidate short-result duration, respawns the new run, and verifies no cross-run life loss in restricted self-test flow.
- Session reset remains the mechanical owner of run identity, tick, seed context, and clean rules state.

### T5 — result presentation
- Result is a readable Label in the HUD region, separate from the play-space/player region.
- Text is non-color dependent and non-punitive:
  - `RESULT: victory (clear)`
  - `RESULT: defeat (light interruption)`
- Timing is parameterized by exported runtime candidate `terminal_result_duration`; no value is promoted as a rule constant.

## Contract / boundary notes
- T1 ledger was available in the permitted source set and the implementation follows its stated same-frame priority/reset seam. No T1 document was modified.
- UX packet was not treated as a dependency for new product decisions; T5 follows the packet-given requirements. No UX document was modified.
- No M1 playability gate was pre-authorized or claimed.
- No numeric candidate was promoted to a frozen rule constant. Existing three-segment life boundary is preserved.
- No upgrade/B2 focus-full/O11/spawn/asset/animation/audio/visual-v0.2/export/release/persistence/replay/O6 work was performed.

## GDMCP action-chain evidence
- `gdmcp.editor_preflight.v1`, registry run `acr-03b2e1c4f7e1`, canonical, passed; doctor/editor state recorded.
- `gdmcp.mutation_loop.v1`, registry run `acr-a36695d54d67`, observed→verified, passed; target reads, schema/domain inspection, mutation/re-read labels, and validation label recorded.
- The relevant Godot sources were read and re-read through GDMCP. No direct file mutation route was used for Godot artifacts in this attempt.

## Validation evidence
- GDMCP script validation:
  - `res://rules/rules_core.gd`: valid, 0 errors, 0 warnings.
  - `res://adapter/adapter.gd`: valid, 0 errors, 0 warnings.
  - `res://runtime/main.gd`: valid, 0 errors, 1 untyped-variable warning at line 81 (`session`).
- Explicit Godot console: `C:\Users\User\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe`, version `4.7.1.stable.official.a13da4feb`.
- gdUnit4 full suite, headless, `--add res://test/ --ignoreHeadlessMode`: **60/60 passed, 0 errors, 0 failures, 0 flaky, 0 skipped, 0 orphans**. Suites: adapter 26/26, rules core 34/34. This is the current local suite count; the prior 49 baseline is retained and the seven terminal/reset fixtures are included.
- A plain headless `--quit` was attempted and correctly reported no main scene defined; this is not a code parse failure. The gdUnit4 runner independently loaded the modified scripts and passed all tests.
- Runtime via GDMCP: `res://scenes/main.tscn` launched successfully; runtime info/tree/screenshot/logs were observed. Logs showed lock/hit/kill binding and quiet no-target presentation. This run did not naturally reach the eight-minute completion threshold, and the terminal result label was not independently captured in a runtime frame.
- Deterministic full-suite second-process rerun and explicit `--self-test` rerun were not observed in this attempt; do not treat those as passed.

## Evidence boundary
Static validation and gdUnit4 prove only the asserted rules/adapter behavior. GDMCP runtime smoke proves scene startup, runtime tree, screenshot capture, and observed log paths only. It is not an independent QA verdict, not visual acceptance, and not proof of all target/export paths.

## Changed Godot artifacts inspected through GDMCP
- `rules/rules_core.gd`
- `rules/session.gd` (session reset seam inspected)
- `adapter/adapter.gd`
- `runtime/main.gd`
- `test/rules_core_test.gd`
- `test/adapter_contract_test.gd`

## Delivery recommendation
Hand the current revision to Independent QA for terminal result-state runtime/E2E and visual checks, especially defeat via three real contacts, victory completion setup, input lock during result, auto-restart timing, and new-run life reset. Do not treat this implementation report or local test pass as QA acceptance.
