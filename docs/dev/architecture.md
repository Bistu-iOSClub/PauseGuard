# PauseGuard 架构

**状态：** 基础架构已建立，业务能力待迭代

## 目标

PauseGuard 采用分层、按功能组织的 SwiftUI 架构。当前重点是建立清晰依赖方向、稳定的团队协作边界和可持续维护成本。

原则：

1. 从简单实现开始，在真实边界出现后再引入协议或服务层。
2. 业务规则与 Apple UI/系统 API 解耦。
3. Feature 拥有自己的展示状态和局部组件。
4. 依赖在应用入口组合，避免隐藏的全局可变状态。
5. 文档描述当前代码，不把目标蓝图写成已完成事实。

## 层级职责

| 层级 | 职责 | 不应承担 |
|---|---|---|
| `Application` | App 入口、依赖组合、生命周期、全局路由和状态 | Feature 业务细节 |
| `Features` | SwiftUI 界面、展示状态、局部路由和交互 | 其他 Feature 的内部实现 |
| `Domain` | 实体、业务规则、Repository 协议、跨数据源用例 | SwiftUI、UIKit、网络或数据库细节 |
| `Data` | 网络、持久化、DTO、Repository 实现 | View 与 UI 状态 |
| `Infrastructure` | 配置、日志、主题和跨切面技术能力 | 某个 Feature 独占的业务流程 |
| `Platform` | 权限和 Apple framework 的薄适配 | 产品编排和全局状态 |
| `Shared` | 真正跨 Feature 的组件和工具 | 任何 Feature 反向依赖 |
| `Resources` | Asset Catalog、本地化和静态资源 | Swift 业务逻辑 |

## 依赖方向

```text
Application -> Features -> Domain
Application -> Infrastructure / Platform / Shared
Features    -> Domain / Infrastructure / Platform / Shared
Data        -> Domain / Infrastructure
Shared      -> Foundation / SwiftUI only as needed
```

关键约束：

- `Domain` 不 import `SwiftUI`、`UIKit` 或具体网络/数据库框架。
- Feature 之间不直接 import 或持有对方的具体类型；跨 Feature 导航由 `Application` 协调。
- `Data` 通过实现 `Domain` 协议向上提供能力。
- `Shared` 只能包含跨 Feature 复用且语义稳定的内容。
- `Platform` 对系统 API 做小而明确的适配，不成为万能 Service 目录。

## 状态与并发

- View 的局部瞬时状态留在 View。
- Feature 状态由 Feature 自己的 observable model 或 view model 管理。
- 会更新 UI 的 view model 使用 `@MainActor`。
- 异步任务优先结构化并发；视图生命周期任务优先 `.task`，并正确响应取消。
- 多任务共享可变状态时使用 actor 或明确隔离；`await` 后按需要重新验证前置状态。
- 用枚举表达互斥状态，避免 `isLoading`、`hasError`、`isEmpty` 等布尔组合产生非法状态。

## 依赖注入

默认通过初始化器传递依赖。协议用于以下情况：

- Domain 需要定义 I/O 边界；
- 测试需要稳定替身；
- 存在两个以上真实实现；
- 平台能力需要与业务规则隔离。

不要仅为满足目录完整度创建空 Repository、UseCase 或 Manager。

## UI 与可访问性

- SwiftUI 为首选；仅在系统能力或成熟组件需要时桥接 UIKit。
- 使用语义颜色、Dynamic Type、安全区和自适应布局。
- 所有功能明确处理权限拒绝、加载、空数据和错误恢复。
- 共用视觉值逐步收敛到 `Infrastructure/Theme`；在形成稳定设计语言前避免过早建立庞大 design system。

## 当前实现

项目当前由 Xcode SwiftUI 模板起步。应用入口已归入 `Application/App`，初始界面归入 `Features/Home/Views`，资源归入 `Resources`。其余层级为演进边界，随真实功能逐步填充。

任何新增模块应同步更新本节和 `project-structure.md`，避免文档领先于代码。
