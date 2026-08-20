# Skill Improvement Changelog — 2026-08-19 v0.1

- **Status:** `accepted`
- **Owner:** Doc Scribe
- **Date:** 2026-08-19
- **Scope:** Six improvements applied to `$godot-game-team` and `$godot-game-team-orchestrator` skills on 2026-08-19.
- **Affected files:** `C:\Users\User\.agents\skills\godot-game-team\SKILL.md`, `C:\Users\User\.agents\skills\godot-game-team-orchestrator\SKILL.md`

## Improvement ledger

### #1: 全文化 close → settled，去掉 Codex 专属的 close_agent

- **What:** All references to `close_agent` removed from DSH adaptation sections. Lifecycle terminology unified to `settled` throughout.
- **Why:** `close_agent` is a Codex-only tool. DSH subagents auto-settle; the parent does not and cannot actively close members. The old mixed terminology created confusion about whether the parent needed to perform a close action.
- **Affected sections:** DSH §1 (lifecycle state machine), §4.1 (DSH member lifecycle), §4.4 (independent QA and phase closeout).
- **Before:** Lifecycle ended with `settled` but text inconsistently used "close", "closed", "close_agent" in several places.
- **After:** All terminal states consistently use `settled`. The lifecycle diagram explicitly states "no `close_agent` tool exists; members auto-settle".

### #2: 删除 Luna/max dispatch gate，替换为 DSH dispatch mechanism

- **What:** Removed Codex-specific Luna/max dispatch gate references. Replaced orchestrator dispatch section with DSH-native `subagent` tool dispatch mechanism.
- **Why:** Luna and max dispatch are Codex-internal concepts not present in DSH. The orchestrator's dispatch instructions now describe the DSH `subagent` tool with `run_in_background: true`.
- **Affected sections:** `$godot-game-team-orchestrator` SKILL.md — new "DSH dispatch mechanism" section added.
- **Before:** Orchestrator referenced Codex dispatch concepts (Luna, max, agent_type).
- **After:** Clear DSH dispatch: `subagent` tool, `run_in_background: true`, auto-settle, no model/effort parameters passed.

### #3: 新增 DSH §4.6 成员被中断处理规则

- **What:** New section §4.6 added to `$godot-game-team` SKILL.md DSH adaptation: "成员被中断在工具调用中途的处理".
- **Why:** Members waiting on GDMCP/debugger/runtime responses are frequently interrupted by DSH runtime. Without a clear protocol, the parent either over-closes members (losing session state) or endlessly retries (wasting rounds).
- **Rules defined:**
  1. Do not close and re-dispatch — member holds live Godot/GDMCP session state.
  2. Send one structured continuation message (current state, resume step, deliverable, stop condition).
  3. Wait for auto-notification after continuation; do not chain messages.
  4. If same member interrupted >= 2 times on same tool call, accept partial result and request alternative authorization from User.
  5. Record interruption chain in ledger; interruption is normal DSH behavior, not a failure.
- **Affected sections:** New §4.6 in DSH adaptation chapter.

### #4: Orchestrator 重写为 130 行配套文件

- **What:** `$godot-game-team-orchestrator` SKILL.md rewritten to ~130 lines as a focused companion file.
- **Why:** The old orchestrator duplicated roster, lifecycle, gates, retries, Godot routes, and DSH adaptation — all of which belong in the main skill. The companion file now contains only formation protocol, member packet field spec, specialist routing quick-reference, parent report format, and the DSH dispatch mechanism.
- **Before:** Orchestrator was a large file with substantial duplication of main skill content.
- **After:** 130-line companion. All shared rules (roster, lifecycle, gates, retries, Godot routes, DSH adaptation) are in the main skill. Orchestrator declares its dependency explicitly: "本文件仅包含编排器独有的内容。以下规则全部见 `$godot-game-team` 主 skill".

### #5: 引用文件（standard-action-chains.md 等）标记为可选

- **What:** `standard-action-chains.md` and `action-chain-registry.md` marked as optional reference files. A new note added after the fixed action-chain rule.
- **Why:** These files may not exist in all projects. The previous text implied they were required, causing members to search for or attempt to create them on first use. The rule now auto-disables when files are absent.
- **Affected sections:** Fixed action-chain rule in main SKILL.md.
- **Text added:** "文件存在性说明：`standard-action-chains.md` 和 `action-chain-registry.md` 是可选引用文件。如果它们不存在，固定 action-chain 规则自动失效——成员按常规 Godot route 执行，不强制要求 chain ID 和 registry 记录。不要在首次使用时花时间搜索或创建这些文件。"

### #6: 新增 Blocker classification gate

- **What:** New stop gate added to Stop gates section: "Blocker classification gate（2026-08-19 固化）".
- **Why:** Not all failing checks should block game development. See ADR-0003 for full rationale. The grace-window evidence gap was the triggering case.
- **Classification:** Game blocker (hard), toolchain blocker (soft — record, don't block), product blocker (user gate — escalate).
- **Affected sections:** Stop gates and failure reporting in main SKILL.md.

## Change log

- **v0.1 — 2026-08-19 — Doc Scribe:** Recorded six skill improvements applied to `$godot-game-team` and `$godot-game-team-orchestrator`. All improvements are implemented in the skill files; this changelog is the durable record.