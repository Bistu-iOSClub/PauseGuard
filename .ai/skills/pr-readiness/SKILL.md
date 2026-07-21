---
name: pr-readiness
description: Verify a PauseGuard change has completed local delivery checks before the mandatory PR gate. Use after implementation and before pushing or opening a pull request.
---

1. Confirm the intended diff and exclude unrelated or generated files.
2. Require SwiftLint, the relevant Debug build, and affected unit/integration tests to pass; an unavailable required check is not a pass.
3. Search the changed scope for debug code, placeholder data, secrets, stale TODOs, and unsafe configuration.
4. Confirm documentation and tests match behavior.
5. Check commit-message format, branch direction, issue linkage, human GitHub identity, merge-conflict state, and suspicious fixed layout constraints.
6. Allow XCUITest source, but do not execute UI automation as an agent. Human developers may run XCUITest; require separate human visual acceptance for UI changes.
7. Report only evidence-backed pass/fail results, then return the evidence to `$pr-gate`; do not perform remote writes from this skill.
