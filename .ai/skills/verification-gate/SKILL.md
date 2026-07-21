---
name: verification-gate
description: Decide whether a PauseGuard task has enough evidence to be declared complete. Use immediately before final implementation handoff or release readiness claims.
---

Check evidence proportional to the change:

1. Relevant build succeeds without newly introduced warnings.
2. Affected unit and integration tests pass. XCUITest source is allowed, but agents do not execute UI automation; an absent agent-run UI-test result is not a failure.
3. The golden path and meaningful edge or failure states are verified.
4. Architecture and privacy boundaries remain valid.
5. Documentation matches changed behavior and no accidental placeholders or secrets remain.
6. UI changes have an explicit human visual-acceptance `PASS`; simulator, preview, or screenshots may support but cannot replace it.

Return `ready` or `not ready`, followed by verified evidence, skipped checks with reasons, and remaining blockers. Never treat an unrun check as passed.
