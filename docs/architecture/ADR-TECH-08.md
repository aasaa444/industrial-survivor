# ADR-TECH-08: build identity / artifact digest
**Date:** 2026-08-19
**Status:** Draft
**Deciders:** Tech Lead, Producer

## Context
Future build/export artifacts must carry source revision, named build/profile, configuration/schema version, fixture/seed where applicable, toolchain/engine identity where relevant, timestamp, artifact digest, and target identity. This supports traceability between fixtures, runtime observations, performance samples, and export smoke evidence.

## Decision
- **Identity fields:** source revision, build profile, config-schema version, fixture-seed, toolchain-engine, timestamp, artifact digest, and target identity.
- **Platform boundary:** no OS, renderer, export target, or release platform is chosen in this ADR. The current direction is PC-first with keyboard and 16:9/common-widescreen readability only.
- **Export evidence:** future `export/release` evidence, not present evidence.

## Consequences
*   **Positive:** Supports traceability and auditability across the build lifecycle.
*   **Negative:** Toolchain implementation remains subordinate to Tech Lead; no platform/release commitment.

## Status Line
- Status: `draft_in_review`
- Author: Tech Lead
- Reviewers: Producer, Toolchain Engineer
- Approval: Pending
