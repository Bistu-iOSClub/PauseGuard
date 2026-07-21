---
name: mcp-health-check
description: Check PauseGuard's required CodeGraph Codex MCP service and project MCP configuration for drift. Use before code search, when CodeGraph or Xcode MCP tools are unavailable, or when MCP behavior differs across environments.
---

1. Compare `.mcp.json` and `.ai/mcp.json`.
2. Require both files to define `codegraph` with `codegraph serve --mcp`.
3. Verify the `codegraph` executable, project `.codegraph/` index, index freshness, MCP service startup, and availability of `codegraph_explore` in the current Codex session.
4. Check configured `xcode` and `xcodebuildmcp` servers without changing user-level settings.
5. Report expected configuration, observed state, drift, impact, and safe remediation.

Missing or unhealthy CodeGraph CLI, index, service, or MCP tool is `BLOCKED — CODEGRAPH SETUP REQUIRED`. Require installation, `codegraph init` or `codegraph sync`, and a Codex restart as appropriate. Do not permit source-code search through `rg`, `grep`, `find`, IDE search, shell globs, ad-hoc scripts, or CodeGraph CLI search. This project uses 即时设计 rather than Figma.
