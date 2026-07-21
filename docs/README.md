# 文档索引

`docs/` 用于沉淀 PauseGuard 的工程事实、架构决策和技术调研。项目由团队协作维护，文档应服务于团队开发、评审、交接与 AI 协作，不制造不存在的流程或产品事实。

## 目录

```text
docs/
├── dev/        当前代码、规范、环境、测试和开发流程
│   ├── fixes/  可复用的故障修复记录
│   └── logs/   阶段性开发日志
├── adr/        Architecture Decision Records
├── research/   技术调研与方案对比
├── design/     交互、视觉和体验说明
└── local/      临时或本地资料，不作为长期真值
```

## 推荐阅读

1. `../README.md`
2. `../CLAUDE.md`
3. `dev/architecture.md`
4. `dev/project-structure.md`
5. `dev/swift-coding-standards.md`
6. `dev/testing-strategy.md`
7. `dev/git-workflow.md`
8. `dev/release-process.md`

## 放置规则

- 当前实现、约束或流程：`dev/`
- 已形成结论且需要长期追踪的架构选择：`adr/`
- 尚需比较或验证的技术方向：`research/`
- 设计稿、交互状态和视觉验收：`design/`
- 临时协作上下文：`local/`

架构发生变化时，同步更新 `dev/architecture.md`、`dev/project-structure.md` 和相关 ADR。避免把参考项目的业务模块、人员、接口或发布状态复制为 PauseGuard 的事实。
