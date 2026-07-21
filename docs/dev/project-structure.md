# 项目目录结构

## 设计原则

1. 先按业务 Feature 聚合，再按职责细分。
2. 顶层目录表达稳定边界，不创建 `Managers`、`Helpers`、`Utils` 等含义模糊的全局抽屉。
3. 目录只在存在真实文件时落地；本文档中的未创建子目录是推荐位置，不是强制脚手架。
4. 测试目标按被测 Feature 或层级镜像组织，但不要求一一复制空目录。

## 目标结构

```text
PauseGuard/
├── Application/
│   ├── App/                 # @main 入口、composition root
│   ├── Lifecycle/           # scenePhase 与应用生命周期协调
│   ├── Routing/             # App 级导航
│   └── State/               # 少量真正全局的状态
├── Features/
│   └── <Feature>/
│       ├── Views/
│       ├── ViewModels/
│       ├── Models/
│       ├── Components/
│       └── Routing/
├── Domain/
│   ├── Entities/
│   ├── Repositories/        # 协议
│   └── UseCases/
├── Data/
│   ├── Network/
│   ├── Persistence/
│   └── Repositories/        # Domain 协议的实现
├── Infrastructure/
│   ├── Config/
│   ├── Extensions/
│   ├── Logging/
│   └── Theme/
├── Platform/
│   ├── Permissions/
│   └── <AppleCapability>/
├── Shared/
│   ├── Components/
│   └── Utilities/
└── Resources/
    ├── Assets.xcassets
    └── <language>.lproj/
```

## 放置决策

- 只被一个 Feature 使用：留在该 Feature。
- 表达纯业务规则或跨 I/O 合约：`Domain`。
- 访问远端或本地数据：`Data`。
- 直接包装权限或 Apple 系统 API：`Platform`。
- 与业务无关且跨多个 Feature 使用的技术能力：`Infrastructure`。
- 跨多个 Feature 复用且 API 稳定的 UI：`Shared`。
- App 启动、全局路由或依赖组合：`Application`。

## 文件命名

- View：`<Name>View.swift`
- ViewModel：`<Name>ViewModel.swift`
- Domain entity：业务名词，如 `PauseSession.swift`
- Use case：动词 + 名词，如 `StartPauseSession.swift`
- Repository 协议：`<Name>Repository.swift`
- 默认实现：`Default<Name>Repository.swift`
- 系统适配器：按能力命名，避免宽泛的 `Manager`。

## Xcode 同步组

工程使用 `PBXFileSystemSynchronizedRootGroup`。移动或新增 `PauseGuard/`、`PauseGuardTests/`、`PauseGuardUITests/` 下的文件后，Xcode 会按文件系统同步；仍需构建验证 target membership 和资源处理结果。
