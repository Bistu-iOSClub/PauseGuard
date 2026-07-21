---
name: fix-build-loop
description: Run a bounded build-fix-rebuild loop for PauseGuard. Use after Xcode MCP build output is insufficient or when multiple compiler errors require root-cause clustering.
---

1. Collect the complete build failure and identify the first actionable root cause.
2. Cluster compiler, linker, resource, signing, dependency, and environment errors.
3. Apply the smallest relevant fix without unrelated cleanup.
4. Rebuild after each root-cause class, for at most three rounds.
5. Stop and report when remaining work needs signing credentials, user choice, or external state.
6. Summarize error, root cause, change, and verification for each round.
