---
name: project-standards
description: Load PauseGuard's coding, architecture, test, and Git conventions before editing project code. Use for any Swift, SwiftUI, test, project-configuration, or structural change.
---

Before editing, read the task-relevant parts of:

1. `AGENTS.md`
2. `CLAUDE.md`
3. `docs/dev/architecture.md`
4. `docs/dev/project-structure.md`
5. `docs/dev/swift-coding-standards.md`
6. `docs/dev/testing-strategy.md` when behavior or tests change
7. `docs/dev/git-workflow.md` when Git operations are requested

Before any source discovery or navigation, run `$codegraph-search`. CodeGraph Codex MCP is mandatory for file/symbol lookup, references, call chains, dependencies, and impact analysis. Missing CodeGraph setup blocks code work; never use text or filesystem search as a fallback.

Resolve conflicts using current code and project settings first, then the most recently maintained project documentation. If documentation is stale, update it within task scope or report the drift.
