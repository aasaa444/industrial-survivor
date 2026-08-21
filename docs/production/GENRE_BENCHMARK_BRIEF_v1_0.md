# Genre Benchmark Brief v1.0 - Industrial Survivor

> **Status:** active design reference
> **Scope:** first 90-second playable Demo only
> **Authority:** user-approved close adaptation of proven functional patterns; current project retains its own code, assets, world, copy, and expression.
> **Evidence boundary:** this brief records lawful public/player-observable behavior and design hypotheses. It is not a claim that current implementation already meets them.

## 1. Reference Set

| Role | Product | What we adapt |
|---|---|---|
| Primary | Vampire Survivors | scrolling-camera survival loop, 30/60/90 pacing, build identity, reward layer, audio hierarchy |
| Secondary | Brotato | readable pressure, immediate wave clarity, compact decision UI, enemy silhouette separation |
| Local feedback reference | 20 Minutes Till Dawn | dark-field readability, visible weapon behavior, projectile/enemy contrast |

## 2. Adaptation Boundary

### Close adaptation is authorized

- Camera follows the player through a larger scrolling arena.
- Enemies spawn outside view around the player, approach continuously, and pressure rises in waves.
- Automatic attacks remain near-silent; kill/reward/growth moments carry the audio feedback.
- Upgrade choices should form build identities with immediate visible behavior changes.
- Use public timing and density relationships as hypotheses for pacing experiments.

### Current project must remain distinct

- Reimplement mechanics in New_Game's own Godot code.
- Use Industrial Survivor's industrial-ruin world, asset expression, copy, modules, and original generated audio.
- Do not copy code, art, audio files, text, named characters, branding, or distinctive IP expression.

## 3. 30 / 60 / 90 Pacing Reference

| Time | Genre floor observation | Industrial Survivor adaptation | Runtime evidence required |
|---|---|---|---|
| 0-10s | Player understands movement, threat, and automatic attack before meaningful danger | 3-second readable scene; first walkers approach; player can reposition safely | screenshot + input path |
| 10-30s | Pressure grows but opening sells power; first upgrade establishes a build direction | first upgrade window; one clear behavior change after selection; no unavoidable death | time/life/enemy log + video |
| 30-60s | Mixed threats force movement and demonstrate build strength | walker/brute mix, first surround risk, reward feedback and one build synergy | kill/alive/life log + screenshot |
| 60-90s | Player reaches a legible climax: win, loss, or clear escalation | reachable defeat and 80-second survival victory; restart is immediate | terminal/restart logs + capture |

## 4. Reward Feedback Matrix

| Event | Reference behavior | Industrial Survivor adaptation | Current status |
|---|---|---|---|
| Automatic attack | near-silent or background click | low-level soft snap, player can mute with M | implemented / user tuning open |
| Hit | brief visual confirmation | cyan hit flash and attack line | implemented |
| Kill | short randomized/throttled pop; dense kills do not become a metronome | random pitch, 100ms throttle, 2s combo climb | implemented / user says still improvable; deferred |
| Pickup/combo | rising ticks/collection cascade | combo pitch climb currently tied to kill; future experience pickup remains missing | partial |
| Upgrade selection | bright satisfying confirmation | three/four-note arpeggios, upgrade apply sound | implemented |
| Win/loss | short ceremonial jingle | four-note rise / two-note fall | implemented |
| Music | drives continued play without masking feedback | 112 BPM dark A-minor pulse + arpeggio | implemented / user accepted |

## 5. Build / Upgrade Benchmark

The reference floor is not numeric variety. A choice changes player identity, spatial strategy, and future synergy.

| Proposed build identity | Reference pattern | Industrial Survivor adaptation | Immediate visible proof |
|---|---|---|---|
| Pierce | linear clear / lane control | rail-pierce module clears a line, stronger against aligned swarms, weaker against surrounds | one shot crosses multiple enemies |
| Fan | coverage / crowd control | scatter fan module covers a forward wedge, better near dense groups, lower lane precision | three visible arcs/projectiles |
| Pulse | close-risk escape | kinetic pulse module triggers a close-range knockback/clear window, requires dangerous proximity | radial pulse pushes/clears nearby enemies |

**Iteration 3 gate:** implement these as distinct behaviors and tradeoffs, not text or numeric variants. Each must be visible within five seconds of selection and testable in the next wave.

## 6. Benchmark Delta Acceptance

```text
Reference experience:
Current experience:
Adaptation choice: copy closely | adapt | intentionally differ
Reason:
Genre-floor requirement:
Current project evidence:
Unintentional regression:
User verdict:
```

Use this format for every future player-facing iteration. “Original” does not justify falling below the genre floor; documented, user-approved differences do.
