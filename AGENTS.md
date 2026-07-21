# AGENTS.md

## Project

PauseGuard is a team-maintained iOS project hosted at `Bistu-iOSClub/PauseGuard`.

- App target: `PauseGuard`
- Unit-test target: `PauseGuardTests`
- UI-test target: `PauseGuardUITests`; XCUITest source is allowed, but agents must not execute UI automation
- Xcode project and scheme: `PauseGuard.xcodeproj` / `PauseGuard`
- Deployment target: iOS 26+
- Primary UI framework: SwiftUI

Do not infer product behavior that is not present in code or project documentation. Keep documentation aligned with the current implementation.

## Architecture

Use these top-level source boundaries under `PauseGuard/`:

- `Application/`: app entry, composition root, lifecycle, routing, and app-wide state
- `Features/`: feature-owned views, models, view models, components, and routing
- `Domain/`: platform-independent entities, repository protocols, and use cases
- `Data/`: network, persistence, and repository implementations
- `Infrastructure/`: cross-cutting configuration, logging, theme, and extensions
- `Platform/`: wrappers around Apple platform APIs and permissions
- `Shared/`: reusable UI and utilities with no feature dependency
- `Resources/`: asset catalogs and localized resources

Dependency rules:

1. `Domain/` must not import SwiftUI, UIKit, or concrete networking/storage frameworks.
2. Features must not depend directly on one another; coordinate through routing or domain contracts.
3. `Data/` implements contracts declared by `Domain/`.
4. `Shared/` must not depend on feature modules.
5. View models that mutate UI state run on `@MainActor`; prefer Observation for new state types.
6. Add abstractions only when a real boundary or test seam needs them.

See `docs/dev/architecture.md` and `docs/dev/project-structure.md` before structural changes.

## Code search and navigation

CodeGraph through the Codex MCP server is mandatory for every source-code search and codebase-navigation task. This includes discovering source files, locating declarations, reading symbol context, finding references/callers/callees, tracing dependencies or data flow, and assessing change impact.

- Invoke `$codegraph-search` before searching project code.
- Use the CodeGraph MCP tools, including `codegraph_explore`, as the only source-code search and navigation interface.
- Do not use `rg`, `grep`, `find`, shell globs, IDE text search, or ad-hoc scripts to search source code. Git status/diff inspection, build-log inspection, and opening an exact path already supplied by the user or project documentation are not code search.
- Do not use the CodeGraph CLI as a search fallback. The CLI is limited to installation, MCP setup, index initialization/synchronization, and health checks.
- If the `codegraph` executable, Codex MCP server, project index, or required MCP tool is missing or unhealthy, stop code-search work. Require installation and setup; never silently fall back to text search.
- Keep the index current with `codegraph sync` when automatic indexing is unavailable or stale, then restart Codex if MCP configuration changed.

See `docs/dev/environment-setup.md` for mandatory setup.

## Build and test

Prefer Xcode MCP or XcodeBuildMCP for builds, tests, simulator work, and build-log inspection. If unavailable, use:

```bash
xcodebuild -project PauseGuard.xcodeproj -scheme PauseGuard \
  -destination 'generic/platform=iOS Simulator' \
  -configuration Debug build

xcodebuild test -project PauseGuard.xcodeproj -scheme PauseGuard \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:PauseGuardTests
```

When falling back to shell `xcodebuild`, state whether the reason was MCP availability, insufficient MCP output, or a shell-only requirement.

## Repository workflow

This is a team project with a fixed promotion chain.

- The only developer/maintain-member PR direction is `dev/* -> develop`.
- Every `dev/*` branch must originate from `develop` and may only pull updates from `develop`.
- `develop -> staging` and `staging -> main` are administrator-only PRs manually initiated and approved on GitHub. Agents must not create, pull, push, approve, or merge them.
- Reject skipped or reverse flows, including `dev/* -> staging`, `dev/* -> main`, and `develop -> main`.
- Commit messages use `type(scope): 中文摘要`.
- Before every remote push or PR operation, run `$pr-gate` and require all gates to pass.
- Remote commits and PRs must use the authenticated submitting team member's own GitHub identity. Never include `codex`, bot identities, AI attribution, or automation attribution.
- Every PR requires a corresponding issue and an exact `Close #<issue-number>` line.
- Never enable auto-merge or manually trigger GitHub Actions. Agents must not execute UI automation; human developers may run XCUITest.
- Never force-push or bypass verification.

See `docs/dev/git-workflow.md` for details.

## Agents

Project agent definitions live in `.ai/agents/`:

- `build-fix-agent`: close the build-error loop
- `arch-guard-agent`: enforce architecture boundaries
- `test-agent`: add and run relevant regression tests
- `doc-adr-agent`: maintain research and ADRs
- `ui-implementation-agent`: implement SwiftUI from 即时设计 context and prepare human visual acceptance
- `ci-triage-agent`: classify CI and local build failures
- `pr-response-agent`: address review feedback and tighten diffs
- `security-agent`: review privacy, storage, logging, networking, and permission risks

For this team repository, the primary agent remains responsible for task integration and final verification. Use extra agents only when their work is independent and materially useful.

## Project skills

Project skills live in `.ai/skills/` and are also exposed through the root `skills` symlink.

- Start code changes with `$project-standards`.
- Use `$codegraph-search` for every source-code search, navigation, reference lookup, and impact analysis.
- Use `$implementation-plan` for broad or risky work.
- Use `$run-build`, `$gen-tests`, and `$verification-gate` before declaring implementation complete. Agent-run tests exclude UI automation; XCUITest source remains allowed.
- Use `$git-workflow` before committing and mandatory `$pr-gate` before every push or PR operation.
- Use `$create-adr`, `$new-research`, `$dev-log`, or `$fix-history` for durable documentation.
- Use `$app-store-preflight` before TestFlight or App Store delivery.

## Documentation

- `README.md`: public project overview and quick start
- `CLAUDE.md`: repository-specific AI coding guide
- `docs/dev/`: current engineering truth and working conventions
- `docs/adr/`: durable architecture decisions
- `docs/research/`: investigations and option comparisons
- `docs/design/`: interaction and visual notes
- `docs/local/`: temporary local collaboration material; not architecture truth

Update the relevant documentation whenever code changes invalidate it.
