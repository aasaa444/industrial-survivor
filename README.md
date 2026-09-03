# Industrial Survivor

A Brotato-inspired arena survival game built with **Godot 4**, developed as an end-to-end demonstration of an **AI-collaborative solo workflow**: human directs architecture, quality gates and verification — AI agents execute against written contracts.

> 一款类《土豆兄弟》竞技场生存游戏（Godot 4），也是一次"人类定架构与质量门禁、AI 按契约执行"的完整单人开发实践。

## Gameplay

- Arena survival with auto-firing weapons and wave-based enemies
- Multi-weapon loadout system (foundation + weapon content modules)
- Procedural arena background, VFX stage, character animation states

## Engineering Highlights

- **Evidence-driven QA**: versioned QA contracts + receipts (`godot_game_dev/qa/`), gdUnit test runner, SQL-free deterministic scene tests
- **Visual-first governance**: anchor screenshots and acceptance records per milestone (`docs/visual/`, `docs/production/`)
- **Architecture decision records** for every major system choice (`docs/adr/`)
- **AI-collaborative process**: requirements interrogation → contract skills → self-test → human review loop

## Repository Map

```
godot_game_dev/   Godot 4 project (scenes, rules, runtime, adapter, qa, tests)
docs/             Creative brief, development charter, ADRs, production/QA evidence
scripts/          Development automation
```

## Status

Core gameplay loop and multi-weapon system playable; art/polish pass ongoing.

## Built With

- Godot 4.x · gdUnit4 · AI pair-development (Claude Code / Codex / OpenCode / ZCode / DeepSeek Harness)

---
*All artwork is original or AI-generated for this project. Game mechanics inspired by Brotato (Blobfish) — no original assets used.*
