---
name: new-feature
description: Scaffold a new PauseGuard feature within the layered SwiftUI architecture. Use when adding a distinct user-facing capability or feature-owned flow.
---

Create only the directories needed by the feature:

```text
PauseGuard/Features/<FeatureName>/
├── Views/
├── ViewModels/
├── Models/
├── Components/
└── Routing/
```

Add `Services/` only for feature-owned orchestration. Put reusable business contracts in `Domain/`, concrete persistence/network implementations in `Data/`, and cross-feature UI in `Shared/`.

Use SwiftUI, Observation for new state types, and `@MainActor` for UI state mutation. Add tests for behavior, avoid empty boilerplate files, and update architecture docs when introducing a new boundary.
