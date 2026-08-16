# Anchor Decision Record — v0.1 accepted baseline / v0.2 refinement authorized

- **Document status:** active decision record; static documentation only
- **Owner:** Doc Scribe (documentation and decision recording)
- **Decision date:** 2026-08-15
- **Decision source:** user’s current message in this session
- **Lifecycle at Anchor capture:** historical pre-authorization / preproduction visual decision record
- **Current canonical reference:** `Development Charter v0.1` — `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY`; lifecycle `development governance / kickoff readiness preparation`
- **Current authorization boundary:** governance/readiness preparation only; this does not authorize implementation, Godot/GDMCP, code, scenes, resources, runtime, build, test, QA execution or acceptance, performance, export, release, or kickoff execution
- **Evidence boundary:** this record uses the user decision, the existing Anchor PNG and prompt record, `STYLE_MANUAL.md`, and `CREATIVE_BRIEF.md`. The PNG was inspected as visual evidence through ModLens. No runtime frame, Godot project state, build, test, QA, asset-production, or release evidence exists.

## 1. Expert preflight

- **Required expert capability:** `godot-doc-scribe-expert` loaded successfully before substantive work.
- **Documentation convention check:** the loaded Doc Scribe contract requires durable, findable decision records with owner/date, provenance, consequences, verification/evidence links, and explicit open items. No existing Anchor decision record was present in the Anchor directory.
- **Current ledger state:** `STYLE_MANUAL.md` still described the Anchor as unresolved/not created; this record supersedes that statement for the newly captured user decision without rewriting the Style Manual’s visual recipe or approval claim.
- **Decisions to capture:** (1) user acceptance of `anchor_core_v0_1.png` as the current Anchor baseline; (2) one authorized reference-image refinement toward `anchor_core_v0_2.png` with the Game Director’s single recommendation.
- **Drift check scope:** existing Anchor directory files, `STYLE_MANUAL.md`, and `CREATIVE_BRIEF.md`; no code or Godot inspection.
- **Stop condition:** no image generation/editing, mask creation, Godot access, development, build, runtime inspection, testing, QA, asset production, GDD, Charter, or release work.

## 2. User decisions captured

### 2.1 Current Anchor baseline — accepted by the user

The user accepts the existing file below as the current Anchor baseline:

- **Path:** `docs/visual/anchor/anchor_core_v0_1.png`
- **Version:** Anchor core v0.1
- **Record label:** `user-accepted Anchor baseline`
- **Scope of acceptance:** the existing image is the current visual reference baseline for this preproduction decision record. Acceptance is a user product decision about the current reference image, not a claim that every visual recipe in Style Manual v0.2 is final.
- **Not represented by this acceptance:** Game Director approval, final approval of Style Manual v0.2, final production asset approval, an in-game screenshot, runtime validation, player validation, QA acceptance, GDD approval, Development Charter authorization, development authorization, or release readiness.
- **Versioning rule:** v0.1 remains the baseline. A later v0.2 candidate must not silently replace it.

### 2.2 One authorized refinement pass

The user authorizes the corresponding professional member to perform exactly one subsequent reference-image refinement, following the Game Director’s sole recommendation:

- Reduce the **area and brightness** of the right-side B2 after-attack ring, particles, and afterglow.
- Preserve the readable **core → transition → falloff** structure.
- Shift emphasis toward **enemy-wave removal in a broad sheet, an opened clearing corridor, and a stable player silhouette**.
- Do not expand the effect into a persistent luminous field.
- This is a single refinement authorization, not an open-ended visual exploration or production brief.

The expected output is a new candidate:

- **Expected path:** `docs/visual/anchor/anchor_core_v0_2.png`
- **Status:** `refinement candidate` only
- **Replacement rule:** v0.2 does not automatically replace `anchor_core_v0_1.png`; v0.1 remains the user-accepted baseline until a later user decision.
- **Review gate:** after v0.2 exists, it requires independent Game Director / Creative Director review and then a separate user decision. Generation or editing of v0.2 is not acceptance of v0.2.

## 3. Game Director review evidence and unresolved visual refinement

The Game Director’s review remains:

- **Review conclusion:** `recommend_revision_before_acceptance`
- **Authority status:** recommendation only; it is not converted into user acceptance or Director approval by this record.
- **Single unresolved refinement:** the right-side B2 after-attack ring, particle field, and afterglow occupy too much area and carry too much brightness. The refinement must retain core–transition–falloff while making the cleared path, sheet-like enemy removal, and stable player outline easier to read.

The user’s acceptance of v0.1 and authorization of v0.2 therefore coexist without contradiction:

1. v0.1 is the **current user-accepted baseline**.
2. The Director still recommends revision before accepting the visual result as Director-approved.
3. v0.2 is an authorized **candidate refinement**, not an approved replacement; it remains an unaccepted candidate.

The v0.1 static/synthetic Anchor acceptance cannot substitute for runtime evidence, independent visual QA, or final creative acceptance. The current Charter's governance-only authorization does not change that boundary.

## 4. Evidence inspected

| Evidence | Path | What it supports | Boundary |
|---|---|---|---|
| Current Anchor PNG | `docs/visual/anchor/anchor_core_v0_1.png` | Existing three-stage visual reference; right-side ring/particles/afterglow and player/enemy composition are inspectable | Static image evidence only; does not prove runtime behavior or definite enemy removal |
| Prompt record | `docs/visual/anchor/anchor_core_v0_1.prompt.txt` | Intended continuity, player priority, enemy-wave scale, B2 corridor, disciplined glow, and no UI/meta screen | Prompt intent is not proof that the image satisfies every criterion |
| Style Manual | `docs/visual/STYLE_MANUAL.md` | v0.2 draft status, proposed core–transition–falloff rule, layer priorities, clearing-path principle, and Anchor gates | Remains draft; not final approval |
| Creative Brief | `docs/CREATIVE_BRIEF.md` | User-confirmed high-level visual direction and the relationship to clear-screen scale, kill weight, readability, and B2 | Does not authorize development or final asset production |

### Static image evidence summary

The inspected PNG visibly presents a wide three-stage industrial combat comparison. The right stage has the brightest and broadest cyan ring, particle spray, and afterglow; the player remains a dark silhouette near the lower area, while many enemies remain visible around/within the effect. The inspection cannot establish from the still image alone whether enemies are destroyed, stunned, or displaced. This uncertainty is retained rather than inferred away.

## 5. Style Manual and production gates

- **Style Manual v0.2:** remains `draft`, awaiting independent Game Director review and final user aesthetic acceptance. It is not marked final or approved by this record.
- **Final asset status:** locked; no final asset is authorized by this record.
- **Production status:** locked; this record does not authorize asset production beyond the separately captured single refinement candidate.
- **GDD status:** locked / not authorized.
- **Development Charter status at Anchor capture:** historical `locked / no versioned Charter authorized` (pre-authorization); this preserves the state recorded when this Anchor was captured and does not describe the current canonical status.
- **Current canonical Development Charter reference:** `Development Charter v0.1` — `AUTHORIZED / EFFECTIVE FOR DEVELOPMENT GOVERNANCE ONLY`; lifecycle `development governance / kickoff readiness preparation`.
- **Current authorization boundary:** governance/readiness preparation only; it is not implementation, Godot/GDMCP, code, scenes, resources, runtime, build, test, QA execution or acceptance, performance, export, release, or kickoff execution authorization.
- **Development status:** implementation remains locked; no formal development or kickoff execution begins from this Anchor record.
- **Godot status:** not accessed.
- **QA/release status:** no QA or release conclusion exists; independent acceptance remains a later gate.

## 6. Evidence links / paths

- Anchor PNG: [`anchor_core_v0_1.png`](./anchor_core_v0_1.png)
- Prompt record: [`anchor_core_v0_1.prompt.txt`](./anchor_core_v0_1.prompt.txt)
- Style Manual: [`../STYLE_MANUAL.md`](../STYLE_MANUAL.md)
- Creative Brief: [`../../CREATIVE_BRIEF.md`](../../CREATIVE_BRIEF.md)
- Expected future candidate (not created by this recording task): [`anchor_core_v0_2.png`](./anchor_core_v0_2.png)

## 7. Closure and open items

**Closure-ready for the Doc Scribe assignment:** yes. The two user decisions are recorded with provenance, scope, authority boundaries, evidence limits, and the independent review gate.

Open items intentionally left for the responsible future members and the user:

1. The authorized v0.2 refinement candidate may be produced by the designated visual-production member; this record does not produce or edit it.
2. Game Director / Creative Director must independently review v0.2 and retain or change the review conclusion.
3. The user must decide whether v0.2 should become a new accepted baseline; no automatic replacement occurs.
4. Style Manual v0.2 still requires its own Director review and final user aesthetic acceptance.

**Boundary statement:** No image was generated or edited, no mask was created, no development or Godot work was performed, and no runtime, build, test, QA, asset-production, or release claim is made by this record.
