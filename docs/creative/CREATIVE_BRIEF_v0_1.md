# Creative Brief v0.1

## brief version

- **Version:** `v0.1`
- **Status:** `completed / preproduction / creative-direction handoff`
- **Scope:** Lock the user-accepted visual baseline `anchor_core_v0_1.png` and define the first-slice creative intent.
- **Authority boundary:** This document is a Creative Brief. It is not a GDD, Development Charter, implementation task list, runtime result, QA verdict, or release approval.
- **Baseline rule:** `anchor_core_v0_1.png` is locked as the current preproduction visual baseline for this brief. It is not a final production asset. Replacing it requires a separate user decision.
- **Versioning rule:** The existing `docs/CREATIVE_BRIEF.md` remains the historical upstream Creative Brief record. This file is a task-specific v0.1 handoff and does not silently rewrite that record.

## source Discovery Brief and Charter

### Discovery Brief provenance

- **Primary auditable source:** `docs/DISCOVERY_HANDOFF.md`, especially §§3–4.
  - Discovery is recorded as complete.
  - The user-confirmed main axis is **Direction A｜忠实幸存者流：把“割草无双”做到极致**.
  - The product is a PC-first playable Demo / Vertical Slice, not formal development.
  - The user-confirmed core is movement/avoidance plus automatic attack, with changes to upgrade/build and out-of-run growth/collection.
- **Current recorded creative source:** `docs/CREATIVE_BRIEF.md` v0.3.
  - It records the accepted player promise, V1 end-of-world survival, the primary clear-screen-scale pleasure source, secondary kill-feedback weight, B2 keyword combinations, O2 out-of-run build collection, and the minimum-core-pleasure slice intent.
- **Secondary file with conflict:** `docs/discovery-brief-v0.2.md` exists on disk but is marked `waiting_for_user`, `needs_user_choice=true`, and was already marked source-unverified by `DISCOVERY_HANDOFF.md`. Its unresolved A/B/C options do not override the auditable handoff or the current user instruction.
- **Visual decision source:** `docs/visual/anchor/ANCHOR_DECISION.md` records the user's acceptance of v0.1 and the separate, bounded v0.2 refinement authorization.
- **Visual review source:** `docs/visual/anchor/ANCHOR_REVIEW_v0_2.md` records the independent verdict `recommend-revision`; it does not revoke v0.1.

### Development Charter status

- **Charter:** Missing.
- **Versioned authorization:** None found or authorized.
- **Consequence:** This brief remains preproduction. It does not authorize the Producer to start formal development, create a production milestone, assign implementation work, or commit scope.

## user-confirmed direction

The following items are treated as user-confirmed because they are traceable to the auditable Discovery handoff, the existing Creative Brief decision ledger, the accepted-anchor record, or the current user instruction:

1. **Product shape:** a playable PC-first Demo / Vertical Slice.
2. **Core fantasy:** extreme clear-screen pleasure, overwhelming power, impact, relief, and “割草无双”; the experience is not intended to punish or deliberately frustrate the player.
3. **Core interaction:** retain direct movement/avoidance and automatic attack.
4. **Main axis:** a familiar survivor-like loop, intentionally accepting the tradeoff that category familiarity can weaken differentiation.
5. **Theme direction:** V1 end-of-world survival.
6. **High-level visual direction:** “rusted apocalypse neon” — low-saturation rusted environment, restrained neon attack/kill feedback, strong silhouettes, layered contrast, and high readability.
7. **Pleasure priority:** clear-screen scale is the primary pleasure source; kill-feedback weight is secondary.
8. **Build direction:** B2 keyword combinations. Specific keywords and combination rules remain unresolved.
9. **Out-of-run direction:** O2 out-of-run build collection. The collection object, strength, and rules remain unresolved.
10. **First slice purpose:** validate understandable movement, a functioning automatic-attack loop, perceptible enemy-wave clearing, and at least one visibly meaningful B2 power step; do not pursue complete enemy content, bosses, full-map content, long-term content, or a complete meta system.
11. **Visual baseline:** `docs/visual/anchor/anchor_core_v0_1.png` is the current user-accepted and now locked preproduction baseline.

These confirmations do not authorize a GDD, Charter, code, scene mutation, asset production, runtime run, or QA acceptance.

## player promise

> **With simple, direct movement and automatic attacks, the player cuts through an enemy wave and experiences increasingly exaggerated, readable clear-screen victories with clear, weighty feedback—an overwhelming, repeatable, cathartic power fantasy that does not exist to punish them.**

- **Provenance:** Recorded as user-confirmed in `docs/CREATIVE_BRIEF.md` §2 and its §8.1 decision ledger.
- **Creative reading:** The player must be able to see the space change from pressure to control. “More light” or a larger number alone is not enough; the result should be legible as enemies removed, a usable path recovered, and the player becoming more capable.
- **Boundary:** The promise does not specify a weapon, enemy roster, damage model, camera implementation, numerical threshold, duration, or UI layout.

## experience pillars

The following pillars are the Director's organized creative interpretation of the confirmed direction. Their implementation details remain proposals until separately authorized.

### P1 — Clear-screen dominance

- The enemy wave changes from readable pressure into a readable, continuous, large-scale clearing result.
- The clearing result should be spatially visible, not only represented by a counter or a louder effect.
- The visual hierarchy must give the recovered space and the surviving player enough priority to read after the impact.

### P2 — Active control while moving

- Movement is not merely retreat; it is the player's visible way to choose a route, preserve a movement pocket, and steer the outcome of automatic fire.
- The player silhouette, immediate danger, and movement space must remain legible while the wave is dense.
- This pillar does not prescribe input, collision, enemy steering, or technical architecture.

### P3 — A visible power step

- A B2 combination must make “I am stronger now” readable in the play space.
- The power step should improve the relationship between attack coverage, wave clearing, and player control rather than become a decorative status effect.
- The baseline image suggests a core → transition → falloff language and an expanded clearing result; it does not establish a ring-shaped mechanic.

### P4 — Cathartic, non-punitive rhythm

- Pressure may exist, but it must resolve into relief and control often enough to serve the user's “for fun, for relief” intent.
- Difficulty, failure cost, and loss rules remain unresolved and are not defined here.
- Visual darkness and rust may supply weight without turning the experience into horror, humiliation, or unreadable punishment.

## creative non-goals

- Do not turn Direction A into a combo-detonation or “打击链” product by inference.
- Do not treat the B2 ring/light-path suggestion in the anchor as a confirmed gameplay system rule.
- Do not use effect size, glow brightness, particle count, or enemy count as the whole definition of爽感.
- Do not let effects hide the player, immediate danger, enemy-wave flow, or the cleared path.
- Do not replace the locked v0.1 baseline with v0.2 or any later image without a new user decision.
- Do not pursue complete enemy content, bosses, a complete map, long-term content, or a complete O2 meta system in the first slice.
- Do not lock character design, enemy roster, weapons, numeric balance, single-run duration, completion conditions, map structure, difficulty, UI specification, or rendering technology in this brief.
- Do not write code, mutate Godot scenes, run the game, export, or claim QA/release readiness from this document.
- Do not promote a Director proposal, an assumption, a prompt constraint, or a static concept image into a user product decision.

## tone and visual anchors

### Tone

- **High-level direction (`user_confirmed`):** rusted apocalypse neon.
- **Emotional target:** heavy, dangerous, and worn at the environmental layer; controlled, meaningful, and relieving at the signal/feedback layer.
- **Readability rule:** player, immediate danger, enemy wave, reward/power change, and recovered movement space must be distinguishable before environmental detail or spectacle.
- **Glow rule:** neon is a scarce signal for attack, kill, danger, reward, or power change; it must not become a uniform full-screen wash.

### Locked visual baseline

- **Path:** `docs/visual/anchor/anchor_core_v0_1.png`
- **Record:** `docs/visual/anchor/ANCHOR_DECISION.md` §§2–4.
- **Observed static content:** a 2048×1152, 16:9 three-stage concept board showing one rusted industrial rail/battle environment; a dark player silhouette near the lower area; a dense ordinary enemy wave; a restrained cyan automatic-attack arc on the left; a concentrated hit/kill moment in the center; and a large cyan B2-after visual on the right. No visible UI, text, logo, or watermark was observed.
- **What it anchors:** composition intent, player/enemy/environment continuity, the rust-versus-cyan contrast, attack escalation, the three-stage comparison, and the need to read a before/impact/after power change.
- **What it does not prove:** runtime movement, actual enemy death, collision, attack timing, player feel, performance, final asset quality, or QA acceptance.
- **Use rule:** downstream creative work may use v0.1 as a hierarchy and mood reference, not as a final asset specification or a license to invent unapproved mechanics.

### Historical v0.2 candidate

- **Path:** `docs/visual/anchor/anchor_core_v0_2.png`.
- **Status:** unaccepted historical refinement candidate only.
- **Existing verdict:** `recommend-revision` in `docs/visual/anchor/ANCHOR_REVIEW_v0_2.md` §10.5; the right-side effect became quieter, but the residual circular field still competed with the clearing result and stable player space.
- **Baseline consequence:** v0.2 does not replace v0.1. No further image revision is authorized by this brief.

### Supporting style source

- `docs/visual/STYLE_MANUAL.md` v0.2 remains a draft. Its proposed core → transition → falloff, silhouette, negative-space, and controlled-glow rules are useful Director proposals, not final aesthetic acceptance.

## slice intent and riskiest truth

### First-slice intent

The first slice is a **minimum core-pleasure validation**, not a content showcase. Its player-facing intent is to establish four truths:

1. A new player can understand movement/avoidance without needing complex instruction.
2. Automatic attack creates a readable, satisfying combat rhythm while movement still matters.
3. Enemy-wave clearing is seen and felt as a spatial, weighty result: enemies are removed, pressure changes, and a usable path or movement pocket becomes legible.
4. One B2 keyword combination creates a clear power step that improves clearing/control without relying on a persistent luminous field or a complex management burden.

### First-slice creative read

A future slice review should be able to compare the same player, enemy family, and battlefield relationship across an initial pressure state, an automatic-attack impact state, and a post-B2 stronger state. The exact scene, enemy count, weapon, timing, and numbers are not fixed here. The intended read is:

`pressure → readable impact → recovered space / stronger control`

The anchor's right-hand ring is a visual reference for escalation and layered light, not a locked rule that the game must implement a ring attack.

### Riskiest truth (`assumption`, Director proposal)

> **Can a familiar survivor-like loop deliver a distinctive, sustained, immediately readable feeling of overpowering control through visible clearing space and weighty kills—rather than through enemy quantity or increasingly bright effects alone?**

This is not yet retired. The static anchor can suggest the intended hierarchy, but it cannot prove the truth in motion or during play. The first slice must be designed to expose this assumption early rather than hide it behind content volume.

## Director-owned creative decisions

Within this preproduction brief, the Director owns:

- Translating the confirmed player promise into coherent experience pillars and slice truths.
- Protecting the hierarchy **player / danger / enemy wave / clearing result / environment detail**.
- Maintaining v0.1 as the active visual baseline and keeping v0.2 explicitly unaccepted.
- Arbiting whether future creative proposals preserve the promise, tone, visual anchor, and non-punitive rhythm.
- Recommending how a future slice should make B2's power step visible without mistaking a visual motif for a system rule.
- Recording creative risks, evidence gaps, and recommendations for the user and Producer.

The Director does **not** own the user's product authority, final aesthetic acceptance, formal scope, schedule, technical architecture, implementation, independent QA, or release approval.

## decisions reserved for user

The following remain product decisions for the user and cannot be inferred from silence:

- Any change to the player promise, Direction A, V1 theme, PC-first target, or the clear-screen/kill-weight priority.
- Any replacement, rejection, or final aesthetic acceptance of the v0.1 baseline, Style Manual, v0.2 candidate, or a future visual anchor.
- The detailed character identity, enemy family, weapon identity, B2 keyword vocabulary, B2 combination rules, and O2 collection object/strength.
- Single-run duration, completion condition, difficulty, failure cost, enemy/Boss/map scope, and first-slice acceptance thresholds.
- Whether the first slice should include any UI, narrative framing, boss-like event, or out-of-run interaction.
- Authorization of a GDD, a versioned Development Charter, formal development, major scope change, platform change, asset production, or release.
- Any tradeoff that changes the product promise, crosses a Charter decision, creates major architecture/scope risk, or changes a release commitment.

The Director may present proposals with evidence and consequences, but must return these decisions to the user.

## team proposals

These are actionable proposals for a later authorized phase, not current product commitments:

1. **Slice proof structure:** use one ordinary enemy family, one automatic-attack family, one B2 combination, and a deliberately controlled wave escalation so the power step is attributable and inspectable before adding content breadth.
2. **Visual proof structure:** compare before/impact/after states in motion and inspect whether the clear corridor and player silhouette become more prominent after B2; do not compensate for weak readability with more glow.
3. **B2 presentation:** make the combination recognizable through a small number of repeatable visual cues and a changed clearing relationship; keep the exact keywords and system rules for systems design plus user decision.
4. **Anchor discipline:** route future concept, 2D, VFX, UX/UI, and technical-art proposals through the locked v0.1 hierarchy. Treat the draft Style Manual as supporting guidance, not as an approved asset specification.
5. **Early retirement loop:** gather a small set of player-facing runtime observations before expanding enemy variety, meta collection, or content volume. If the first four slice truths are not visible, stop and revise the creative hypothesis rather than adding polish.

## assumptions and unresolved questions

### Assumptions

- The user-confirmed familiar survivor-like loop can still support a memorable identity if the slice proves clear-screen scale, kill weight, visible control, and B2 power change. (`assumption`; not retired.)
- The static anchor's three-stage composition is useful as a shared visual reference for future discussion. (`proposal`; not runtime evidence.)
- A restrained cyan signal can communicate power without permanently washing out the battlefield. (`proposal`; requires runtime evidence.)

### Unresolved questions

- What exact player, enemy family, weapon/attack family, and B2 keywords will carry the first slice?
- What precise rule makes a B2 combination form, and how much choice/complexity is acceptable for the user's “解压” target?
- What is the single-run duration, completion condition, failure cost, and difficulty curve?
- What counts as a clear-screen result in the eventual acceptance criteria, and what player-facing evidence will the user accept?
- How should O2 collection affect future B2 choice space without locking core爽感 behind long-term progression?
- What UI, tutorial, and feedback layers are needed for comprehension, while preserving the no-clutter visual hierarchy?
- What parts of the draft Style Manual should receive final Director review and separate user aesthetic acceptance?
- The Discovery record conflict between the waiting/unverified `docs/discovery-brief-v0.2.md` and the auditable `docs/DISCOVERY_HANDOFF.md` should be resolved in the project ledger before a future GDD/Charter gate.

## top creative risks and retirement observations

### Risk 1 — Effects replace the result

- **Observation:** The inspected v0.1 board gives the right-side B2 effect the largest cyan area and strongest brightness. The static image communicates escalation, but the effect can compete with the player and the cleared-space result. The v0.2 review found partial mitigation but still returned `recommend-revision`.
- **Retirement evidence required:** runtime frames or an observed play sequence showing the player silhouette, immediate danger, enemy-wave flow, and recovered movement space remain readable during and after the strongest feedback. No claim of retirement exists now.

### Risk 2 — Familiarity becomes indistinguishable imitation

- **Observation:** The familiar survivor loop lowers onboarding risk but the existing Discovery handoff explicitly records weaker differentiation as its accepted tradeoff. The current brief must therefore prove a specific pleasurable identity, not merely reproduce genre ingredients.
- **Retirement evidence required:** a slice observation in which players can describe or demonstrate the distinct source of control/pleasure—especially the visible B2 power step, clear-screen relationship, and kill weight—without relying on feature count. No player or runtime evidence exists now.

### Risk 3 — B2 reads as spectacle or complexity instead of power

- **Observation:** The anchor suggests a ring/layered-light escalation, but it does not establish a ring mechanic, a combination rule, or a usable build decision. B2 could become decorative, opaque, or management-heavy while still looking impressive.
- **Retirement evidence required:** a before/after runtime comparison in which the chosen B2 combination produces a visibly different clearing/control outcome, the player can understand the change, and the effect does not create a persistent field that hides the result. Exact acceptance thresholds require user/system-design decisions later.

## evidence classes required

### Already inspected for this brief

- **Document / provenance evidence:** `DISCOVERY_HANDOFF.md`, `docs/CREATIVE_BRIEF.md`, `docs/discovery-brief-v0.2.md`, `ANCHOR_DECISION.md`, `ANCHOR_REVIEW_v0_2.md`, `STYLE_MANUAL.md`.
- **Prompt/intention evidence:** `anchor_core_v0_1.prompt.txt` and `anchor_core_v0_2.edit.prompt.txt`.
- **Static visual evidence:** direct inspection of `anchor_core_v0_1.png` (2048×1152 PNG) and the recorded independent comparison of v0.2.
- **Decision evidence:** the user-accepted baseline record in `ANCHOR_DECISION.md`.

### Required later, but absent now

- **Runtime visual evidence:** observed before/impact/after gameplay frames, including the player silhouette, enemy-wave pressure, automatic-attack feedback, B2 transition, and post-clear movement space.
- **Player-facing interaction evidence:** direct observation that movement is understandable, automatic attack is readable, and B2's outcome is comprehensible; this is not inferred from the concept board.
- **Independent QA evidence:** separate readability, gameplay, regression, performance, export, and release acceptance as applicable. The implementer cannot self-certify these.
- **User decision evidence:** explicit decisions on unresolved product questions and any baseline/Charter/scope change.
- **Technical evidence:** only after an authorized technical phase; this brief makes no claims about scene structure, performance, input wiring, or engine behavior.

## handoff to Producer and domain leads

### Producer / Executive Producer

- Receive this brief as a preproduction creative baseline, not a production authorization.
- Do not start formal execution or create a milestone commitment without a user-authorized, versioned Development Charter.
- If the user later authorizes development, convert the four slice truths into a bounded scope proposal, dependency map, change-request path, and milestone package; return any promise/scope/platform/architecture/release threshold crossing to the user.
- Keep `anchor_core_v0_1.png` as the referenced baseline unless the user makes a separate replacement decision.

### Game Director / Creative Director

- Preserve the player promise, pillar ordering, visual hierarchy, and v0.2 historical status.
- Review future creative proposals for coherence; do not self-accept assets or claim runtime/QA evidence.

### Systems / Gameplay design

- Prepare proposals for the exact B2 keyword vocabulary and the smallest ruleset that can prove a visible power step without overloading the player.
- Keep duration, completion, difficulty, failure cost, and acceptance thresholds explicitly unresolved until the user authorizes their definition.

### Tech Lead / Gameplay engineering

- No implementation or architecture commitment is requested by this brief.
- Once a Charter exists, derive technical options from the approved slice scope rather than from the anchor image or unapproved visual mechanics.

### Concept art / 2D / VFX / UX/UI / Technical art

- Use v0.1 for hierarchy, mood, silhouette, controlled glow, and clear-space reference.
- Treat the draft Style Manual as proposal-level guidance and do not use v0.2 as an accepted replacement.
- Do not produce new assets, UI specifications, or effect systems from this brief alone.

### Independent QA / Release

- No acceptance is requested now. Later QA should receive explicit player-facing criteria and evidence targets from the Producer/user, and must remain independent of implementation.

## status and creative verdict

- **Deliverable status:** `completed`
- **Preproduction gate:** `passed for this bounded Creative Brief task`
- **Current baseline verdict:** `anchor_core_v0_1_locked_user_accepted`
- **v0.2 verdict:** `unaccepted_historical_refinement_candidate / recommend-revision`
- **Development status:** `not authorized; no Development Charter`
- **Runtime / QA / release status:** `not run / no claim`
- **Next escalation trigger:** any request to define unresolved product rules, replace the baseline, authorize new visual production, create a GDD/Charter, or begin implementation must return to the user for the appropriate decision gate.
