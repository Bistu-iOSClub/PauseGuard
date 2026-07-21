---
name: check-arch
description: Check PauseGuard source changes against its layered architecture. Use after adding modules, moving files, introducing repositories or services, or changing cross-layer dependencies.
---

读取 `docs/dev/architecture.md` 与 `docs/dev/project-structure.md`，然后检查：

1. `Domain/` 不依赖 SwiftUI、UIKit 或具体网络/存储框架。
2. Feature 之间没有直接依赖。
3. `Data/` 实现 `Domain/Repositories` 中的协议，上层不绕过协议边界。
4. `Shared/` 不依赖 Feature；`Platform/` 保持系统 API 薄封装。
5. UI 状态变更具备正确的 `@MainActor` 隔离。
6. 新文件位于职责最匹配的目录，且没有为形式完整度制造空抽象。

按文件、行号、规则、影响和最小修复建议输出；无问题时明确写 `No findings.`。
