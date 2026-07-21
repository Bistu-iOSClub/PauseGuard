---
name: codegraph-search
description: Enforce CodeGraph-backed source discovery and navigation for PauseGuard. Use before locating source files or symbols, reading symbol context, finding references/callers/callees, tracing dependencies or data flow, searching code, or assessing change impact.
---

# CodeGraph Search

Treat CodeGraph through the Codex MCP server as the only permitted source-code search and navigation interface.

## Preflight

1. Confirm the `codegraph` executable is installed.
2. Confirm `.mcp.json` and `.ai/mcp.json` define `codegraph` as `codegraph serve --mcp`.
3. Confirm the repository has a healthy `.codegraph/` index.
4. Confirm the current Codex session exposes CodeGraph MCP tools, including `codegraph_explore`.
5. Run `codegraph sync` only when the index is missing updates or automatic synchronization is unavailable.

If any required item is absent or unhealthy, stop and report `BLOCKED — CODEGRAPH SETUP REQUIRED`. Require the user to install `@colbymchenry/codegraph`, initialize the repository with `codegraph init`, and restart Codex after MCP configuration. Never continue by substituting another search mechanism.

## Search workflow

1. State the code question: symbol, relationship, execution path, architecture boundary, or impact scope.
2. Query the CodeGraph MCP service, starting with `codegraph_explore` and narrowing by symbol or relationship.
3. Follow graph relationships for declarations, references, callers, callees, imports, dependencies, and affected tests as needed.
4. Open exact files returned by CodeGraph only after the graph identifies them.
5. Cite the symbols and paths that support the result. Distinguish direct graph evidence from inference.

## Prohibited fallbacks

- Do not use `rg`, `grep`, `find`, shell globs, IDE text search, filesystem crawling, or ad-hoc scripts to search source code.
- Do not use the CodeGraph CLI for normal search; reserve it for installation, MCP configuration, `init`, `sync`, and health checks.
- Do not treat an exact-file read, Git diff/status, build-log inspection, or user-supplied path as permission to scan neighboring source files outside CodeGraph.
- Do not claim complete reference or impact coverage when the index is stale or the MCP tool is unavailable.

Report `PASS` only when the MCP service and current index provide the required evidence.
