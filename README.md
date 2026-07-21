# PauseGuard

PauseGuard 是由团队协作维护的原生 iOS 项目，代码仓库位于 [`Bistu-iOSClub/PauseGuard`](https://github.com/Bistu-iOSClub/PauseGuard)。项目目前处于基础建设阶段，使用 SwiftUI 开发，最低支持 iOS 26。

## 快速开始

环境要求：Xcode 26+，以及 iOS 26 模拟器或设备。

```bash
open PauseGuard.xcodeproj
```

Xcode MCP 不可用时，可通过命令行构建：

```bash
xcodebuild -project PauseGuard.xcodeproj -scheme PauseGuard \
  -destination 'generic/platform=iOS Simulator' \
  -configuration Debug build
```

运行单元与集成测试：

```bash
xcodebuild test -project PauseGuard.xcodeproj -scheme PauseGuard \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:PauseGuardTests
```

项目允许保留、编写和由人工运行 XCUITest，但 Agent 禁止自行执行 XCUITest、脚本化模拟器交互或其他 UI 自动化。涉及 UI 的改动仍必须由团队成员完成人工视觉验收，自动化结果不能代替视觉验收。

## CodeGraph 代码检索

本项目强制使用 CodeGraph 的 Codex MCP 服务进行源码检索、符号定位、引用/调用链查询、依赖追踪和改动影响分析，禁止使用 `rg`、`grep`、`find`、IDE 文本搜索或自定义脚本替代。CodeGraph CLI 仅用于安装、配置和维护索引。

首次参与项目必须完成：

```bash
npm install -g @colbymchenry/codegraph
codegraph init
```

项目 MCP 配置已经通过 `.mcp.json` 和 `.ai/mcp.json` 声明 `codegraph serve --mcp`。安装并初始化后请重启 Codex；若 MCP 工具或项目索引不可用，代码搜索与后续开发流程必须暂停，不能降级到普通文本搜索。详细说明见[开发环境](docs/dev/environment-setup.md)。

## 项目结构

```text
PauseGuard/
├── Application/       App 入口、依赖组装、生命周期、全局路由与状态
├── Features/          功能模块的 SwiftUI 界面与展示逻辑
├── Domain/            平台无关的实体、协议与用例
├── Data/              网络、持久化与 Repository 实现
├── Infrastructure/    配置、日志、主题与跨模块基础设施
├── Platform/          Apple 平台 API 的薄封装
├── Shared/            跨 Feature 复用的 UI 与工具
└── Resources/         Asset Catalog 与本地化资源

PauseGuardTests/       单元测试与集成测试
PauseGuardUITests/     XCUITest 目标与测试源码；仅由人工决定并执行
.ai/                   项目 Agent、skills、协作团队与 MCP 配置
docs/                  开发文档、ADR、技术调研与设计说明
```

这些目录用于表达架构边界，不要求为保持形式完整而创建空实现。只有出现真实职责时才新增目录或抽象。

## 项目文档

- [文档索引](docs/README.md)
- [架构说明](docs/dev/architecture.md)
- [目录结构](docs/dev/project-structure.md)
- [Swift 编码规范](docs/dev/swift-coding-standards.md)
- [测试策略](docs/dev/testing-strategy.md)
- [Git 与 PR 工作流](docs/dev/git-workflow.md)
- [发布流程](docs/dev/release-process.md)
- [AI 开发指南](CLAUDE.md)

## 团队协作流程

项目采用严格的单向分支流转：

```text
dev/* -> develop -> staging -> main
```

- 团队开发者与 maintain 成员只能提交 `dev/* -> develop` PR。
- `dev/*` 必须从 `develop` 创建，也只能从 `develop` 拉取更新。
- `develop -> staging` 与 `staging -> main` 只能由管理员在 GitHub 手工发起和批准。
- 禁止跨级、逆向流转以及 `develop -> main`。
- 每次 push、创建或更新 PR 前必须通过 `$pr-gate`。
- 每个 PR 必须关联对应 Issue，并在正文包含 `Close #<issue-number>`。
- 远程提交必须使用当前团队成员本人的 GitHub 身份，禁止 bot 或自动化身份署名。
- 所有 PR 均由人工处理，禁止自动合并和主动触发 GitHub Actions。

提交信息格式：

```text
type(scope): 中文摘要
```
