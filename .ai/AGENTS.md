# AI configuration guidance

The repository-wide rules in `../AGENTS.md` apply to everything in this directory.

- Keep agent and skill instructions specific to `PauseGuard` and `Bistu-iOSClub/PauseGuard`.
- Do not copy product assumptions, API identifiers, credentials, Firebase paths, or release facts from another repository.
- Keep skill frontmatter limited to `name` and `description`.
- Treat multi-agent team files as team collaboration presets; the primary agent owns task integration and verification.
- Use 即时设计 context for UI work; do not invoke Figma skills or MCP.
- Use `$codegraph-search` and the CodeGraph Codex MCP server for every source-code search or navigation task. Never fall back to `rg`, `grep`, `find`, IDE text search, shell globs, or ad-hoc source scanning. Missing CLI, MCP, or index is a blocking setup failure.
- Use `$pr-gate` before every push or PR operation. Never weaken its branch, identity, issue, quality, manual-UI, Actions, or no-auto-merge rules.
