# CLAUDE.md

This file provides repository-specific guidance to AI coding tools working on PauseGuard.

## Project overview

- Repository: `Bistu-iOSClub/PauseGuard`
- Ownership: team project; the submitting member owns their change while maintainers and administrators enforce integration and release gates
- App: native iOS app built with SwiftUI
- Xcode project / scheme: `PauseGuard.xcodeproj` / `PauseGuard`
- Deployment target: iOS 26+
- Tests: Swift Testing in `PauseGuardTests` and permitted XCUITest sources in `PauseGuardUITests`; agents must not execute UI automation, and UI acceptance is manual

The product is still at its foundation stage. Read current code and requirements before describing product behavior; do not import assumptions from another app.

## Build and test

Prefer Xcode MCP or XcodeBuildMCP for building, testing, Simulator interaction, previews, and build-log inspection.

Shell fallback:

```bash
xcodebuild -project PauseGuard.xcodeproj -scheme PauseGuard \
  -destination 'generic/platform=iOS Simulator' \
  -configuration Debug build

xcodebuild test -project PauseGuard.xcodeproj -scheme PauseGuard \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:PauseGuardTests
```

Do not change signing, bundle identifiers, deployment target, or project format just to make a local environment pass.

If SwiftLint is installed, run `./scripts/lint-local.sh` before publishing code changes.

## CodeGraph requirement

All source-code discovery, symbol lookup, reference/call-chain analysis, dependency tracing, and change-impact analysis must use the CodeGraph Codex MCP server. Start these tasks with `$codegraph-search` and use MCP tools such as `codegraph_explore`.

Do not search source code with `rg`, `grep`, `find`, shell globs, IDE text search, or custom scanning scripts. The CodeGraph CLI is for installation, configuration, indexing, synchronization, and health checks only—not as a search fallback. If CodeGraph, its MCP service, or the project index is unavailable, stop and require setup before continuing.

## Architecture

`PauseGuard/` uses these dependency boundaries:

```text
Application ──> Features ──> Domain
     │              │          ▲
     ├──────────────┼──> Shared│
     │              └──> Platform
     └─────────────────> Infrastructure
Data ───────────────────> Domain
```

- `Application`: app entry and composition root; owns app-wide navigation and lifecycle.
- `Features`: feature presentation, views, view models, and local routing.
- `Domain`: pure business concepts and contracts; no SwiftUI/UIKit or concrete I/O framework.
- `Data`: concrete I/O and repository implementations.
- `Infrastructure`: cross-cutting technical facilities.
- `Platform`: thin Apple-framework adapters and permission interfaces.
- `Shared`: reusable UI and utilities that cannot depend on a Feature.
- `Resources`: assets and localization.

See `docs/dev/architecture.md` and `docs/dev/project-structure.md`. Prefer a simple feature-local implementation until a real reuse or dependency boundary appears.

## Swift and SwiftUI conventions

- Prefer value types and explicit dependencies.
- Use Observation for new observable state; isolate UI mutations to `@MainActor`.
- Prefer structured concurrency and cancellation-aware `.task` work.
- Re-check mutable state after suspension points when another task could change it.
- Model finite states with enums instead of several loosely related booleans.
- Handle loading, empty, error, and permission-denied states intentionally.
- Use semantic system colors, Dynamic Type, accessibility labels, and adaptive layout.
- Comments explain intent or constraints, not syntax.
- Public APIs need `///` documentation when their contract is not obvious.

Full conventions: `docs/dev/swift-coding-standards.md`.

## Documentation rules

- Keep engineering truth under `docs/dev/`.
- Record durable architectural choices under `docs/adr/`.
- Put option comparisons and investigations under `docs/research/`.
- Put UI behavior and visual notes under `docs/design/`.
- Treat `docs/local/` as temporary context, never as architecture truth.

When code invalidates documentation, update both in the same task.

## Design workflow

PauseGuard uses 即时设计, not Figma. Do not invoke Figma skills or MCP for this project. Work from user-provided 即时设计 links, annotations, screenshots, or exported assets.

- Inspect UI diffs for suspicious fixed width/height constraints, especially text and dynamic content.
- Pause and request human confirmation before publishing when such a constraint may be intentional.
- XCUITest targets and source files are allowed. Do not autonomously execute XCUITest, scripted Simulator interaction, MCP-driven UI automation, or other UI automation as an agent. Human developers may run XCUITest.
- Require explicit human visual-acceptance `PASS` before a UI-changing PR can pass its gate.

## Remote and PR gate

- Developer flow is strictly `dev/* -> develop`; `dev/*` branches originate from and only pull from `develop`.
- Administrator-only release promotion is `develop -> staging -> main`, manually initiated and approved on GitHub. Never automate it or skip a level.
- Run `$pr-gate` before every push, PR create/update, or merge-safety statement.
- Require a matching issue, `Close #<issue-number>`, successful lint/build/unit tests/review/conflict checks, and human GitHub identity.
- Never use bot identities, include `codex` or AI attribution remotely, enable auto-merge, or manually trigger GitHub Actions.

## Project automation

- Project agents: `.ai/agents/`
- Project skills: `.ai/skills/` and root `skills` symlink
- Optional multi-agent presets: `.ai/teams/`
- MCP configuration: `.mcp.json` and `.ai/mcp.json`

Start implementation work with `$project-standards`; use `$codegraph-search` for all code search and navigation, `$verification-gate` before claiming completion, `$git-workflow` before committing, and `$pr-gate` before publishing Git changes.
