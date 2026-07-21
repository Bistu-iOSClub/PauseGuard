---
name: ios-systematic-debugging
description: Diagnose PauseGuard iOS bugs from reproduction to verified root cause. Use for crashes, incorrect UI state, lifecycle bugs, concurrency issues, performance regressions, or environment-sensitive failures.
---

1. Establish exact reproduction conditions: build, device or simulator, OS, permissions, app state, and inputs.
2. Collect relevant logs, crash reports, screenshots, traces, or network evidence without exposing sensitive data.
3. Reduce the failing path and distinguish app code, platform behavior, configuration, and external service causes.
4. Form a falsifiable root-cause hypothesis and verify it before editing.
5. Apply the smallest fix, then repeat the reproduction and add regression coverage where valuable.
6. Report evidence, root cause, change, result, and remaining uncertainty. Do not use guess-and-check edits as the primary method.
