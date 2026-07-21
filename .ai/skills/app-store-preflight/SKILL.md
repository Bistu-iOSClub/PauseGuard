---
name: app-store-preflight
description: Preflight PauseGuard for TestFlight or App Store delivery. Use when preparing an archive, release candidate, TestFlight upload, or App Store submission.
---

检查并报告证据：

1. Marketing Version 与 Build 号是否符合本次发布计划。
2. App icon、启动体验、签名、entitlements 和 Release 配置是否完整。
3. `PrivacyInfo.xcprivacy`、权限用途说明和实际 API 使用是否一致。
4. 是否存在废弃 API、调试开关、测试数据、明文秘密或开发环境地址。
5. 如项目实际使用 IAP、通知、后台模式或第三方 SDK，再检查对应商店配置与隐私披露。
6. 执行 Release 构建，并区分已验证、需人工确认和阻塞项。
