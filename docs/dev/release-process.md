# 发布流程

PauseGuard 当前处于基础开发阶段，尚未在本文档中声明已配置 TestFlight 或 App Store Connect。首次发布前应按真实账号和商店配置补充版本策略、签名和发布责任信息。

## 发布候选

1. 确认开发改动已按 `dev/* -> develop` 合入，由管理员在 GitHub 手工发起 `develop -> staging` 发布晋级 PR。
2. 确认 `MARKETING_VERSION` 与 `CURRENT_PROJECT_VERSION` 按计划递增。
3. 运行 SwiftLint、完整测试、Debug build 和 Release archive。
4. 在支持的最小系统版本与代表性设备尺寸验证关键路径。
5. 检查权限用途说明、Privacy Manifest、entitlements、图标和商店隐私披露。
6. 确认无测试数据、开发服务器地址、调试开关或秘密进入 archive。

## TestFlight

- 上传前使用 `$app-store-preflight` 记录已验证和待人工确认项。
- 上传后完成安装、首次启动、升级、权限拒绝和核心流程 smoke test。
- 记录 build 号、测试结论和已知限制。

## App Store

- 确认 App Store Connect 元数据与当前功能一致。
- 对权限、数据收集、账号能力、后台模式和第三方 SDK 做最终隐私审查。
- 只有在 release candidate 证据完整后，由管理员手工发起 `staging -> main` PR 并提交审核。
- 发布后为 tag 和 release notes 建立可追溯记录。

## 回滚

iOS 已发布二进制无法直接回滚。高风险变更应在发布前准备功能降级或远端开关方案（项目真实需要时再引入）。紧急修复仍从 `develop` 创建 `dev/fix-<topic>`，按同一单向链逐级晋级；不得从 `main` 创建绕过流程的分支。
