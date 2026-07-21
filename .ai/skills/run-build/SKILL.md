---
name: run-build
description: Build PauseGuard and summarize actionable errors and warnings. Use after Swift or project changes, or when the user asks to compile or validate the app.
---

Prefer Xcode MCP / XcodeBuildMCP. If unavailable, run:

```bash
xcodebuild -project PauseGuard.xcodeproj -scheme PauseGuard \
  -destination 'generic/platform=iOS Simulator' \
  -configuration Debug build
```

Report command or MCP action, result, first root-cause error, grouped follow-on errors, new warnings, and relevant environment details. Do not change signing or project settings merely to force a green build.
