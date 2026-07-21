---
name: code-review
description: Review PauseGuard Swift or SwiftUI changes using diff-first, risk-ranked, evidence-based analysis. Use for pull requests, staged changes, pre-commit review, or focused file review.
---

## Scope

Use the user-specified range first. Otherwise inspect, in order:

1. `git diff --cached`
2. `git diff`
3. `git diff origin/main...HEAD` when `origin/main` exists

Read the full changed files plus `docs/dev/swift-coding-standards.md`, `docs/dev/architecture.md`, and `CLAUDE.md`. Prefer current code facts over stale documentation and report documentation drift separately.

Run `$codegraph-search` before locating related source, symbols, references, call paths, dependencies, or affected tests. Use CodeGraph Codex MCP evidence for all codebase navigation and impact analysis. If CodeGraph is unavailable or stale, stop the review as blocked; do not fall back to text or filesystem search.

## Review passes

1. Intent and behavior correctness, including empty, error, cancellation, retry, and state-restoration paths.
2. Architecture boundaries and dependency direction.
3. SwiftUI identity, lifecycle, navigation, task cancellation, accessibility, and adaptive layout.
4. Swift concurrency isolation, `Sendable`, shared state, and state revalidation after `await`.
5. Privacy and security for permissions, storage, logs, network input, URLs, and third-party SDKs.
6. Performance risks such as repeated work, eager rendering, resource loading, and unbounded state.
7. Tests and verification that would fail when the changed behavior regresses.

Do not report generic style notes that SwiftLint can reliably find unless they reveal a behavioral risk.

## Findings

Only report a finding when it has a concrete file/line, failure scenario, impact, and actionable fix. Rank as:

- `P0 Blocker`: build break, crash, data loss, security/privacy breach, or core flow unavailable.
- `P1 Required`: likely behavior defect, race, unrecoverable state, or critical missing boundary.
- `P2 Should Fix`: edge-case defect, important verification gap, or material maintainability regression.
- `P3 Optional`: non-blocking local improvement.

Output `Findings`, `Open Questions / Assumptions`, `Verification Gaps`, and `Reviewed Scope`. If no actionable issue exists, write `No findings.`.
