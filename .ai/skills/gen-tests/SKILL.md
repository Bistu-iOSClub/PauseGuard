---
name: gen-tests
description: Add focused PauseGuard unit or integration tests for changed behavior and maintain XCUITest source when explicitly relevant. Use after implementing logic, state transitions, parsing, persistence, routing, UI flows, or a regression fix; never autonomously execute UI automation.
---

1. Derive behavior and failure boundaries from the diff and callers.
2. Prefer Swift Testing in `PauseGuardTests` for logic. Create or modify XCUITest only when the task requires interaction coverage, but do not execute XCUITest or other UI automation as an agent.
3. Keep tests deterministic and isolate network, clocks, storage, and external services behind test seams.
4. Name tests by subject, scenario, and expected result.
5. Run only the relevant non-UI `PauseGuardTests` scope. Leave XCUITest execution to a human and report it separately when human evidence is supplied.
6. Do not add tests that only restate implementation details or exist solely to increase coverage.
7. For UI changes, prepare a human visual-acceptance checklist and require the user's explicit result.
