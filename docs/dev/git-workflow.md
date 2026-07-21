# Git 与 PR 工作流

## 1. 固定分支流向

PauseGuard 位于 `Bistu-iOSClub/PauseGuard`，采用严格单向流转：

```text
dev/* -> develop -> staging -> main
```

| 来源 | 目标 | 谁可以发起 | 规则 |
|---|---|---|---|
| `dev/*` | `develop` | 团队开发者、maintain 成员 | 唯一允许的普通开发 PR |
| `develop` | `staging` | 管理员 | 只能在 GitHub 手工发起和批准，Agent 不得执行 |
| `staging` | `main` | 管理员 | 只能在 GitHub 手工发起和批准，Agent 不得执行 |

强制约束：

- `dev/*` 必须从 `develop` 创建，只能从 `develop` 拉取更新。
- 禁止 `dev/* -> staging`、`dev/* -> main`、`develop -> main`、反向流转和任何跨级流转。
- maintain 权限不代表可发起发布晋级；普通成员仍只能执行 `dev/* -> develop`。
- `develop -> staging`、`staging -> main` 由管理员本人在 GitHub 手工操作。Agent 不创建、不拉取、不推送、不审批、不合并此类 PR。
- 任何分支流向违规立即拒绝，不执行远程写入，并说明来源、目标、违规规则和正确路径。

## 2. 分支命名

开发分支统一位于 `dev/*`：

```text
dev/feat-<topic>
dev/fix-<topic>
dev/refactor-<topic>
dev/docs-<topic>
dev/chore-<topic>
```

不得从 `main`、`staging`、其他 `dev/*` 或无关历史创建开发分支。

## 3. 人类 GitHub 身份

上传代码或创建/更新 PR 前必须验证：

1. 当前 `gh` 登录账号是本地开发者本人的 GitHub 账号。
2. `git config user.name` 与 `user.email` 属于同一账号。
3. 待上传范围内的每个 commit 都由该人类账号签署作者与提交者身份。
4. commit、PR 标题、正文、trailer、作者或提交者信息中不得出现 `codex`、`[bot]`、GitHub Actions 或其他自动化/bot 身份。
5. 禁止添加 AI、工具生成或 bot 的署名和 co-author 信息。

无法证明身份时停止流程，由用户自行登录或配置；Agent 不自动改写身份。

## 4. Commit 规范

标题格式：

```text
type(scope): 中文摘要
```

常用类型：`feat`、`fix`、`refactor`、`style`、`docs`、`test`、`chore`。

要求：

- 每个提交只表达一个完整意图。
- 摘要说明结果，不使用 `update`、`misc` 等空泛内容。
- body 使用真实换行，只展开同一主题。
- 不提交 secrets、`xcuserdata`、DerivedData 或 Agent 临时记录。

## 5. Issue 门禁

- 每个 PR 必须对应 `Bistu-iOSClub/PauseGuard` 中一个真实、相关的 issue。
- 创建 PR 前验证 issue 存在、可访问且内容与改动一致。
- PR 的“关联 Issue”章节必须写明 issue 编号、标题与本次改动所解决的内容摘要。
- PR 正文必须包含精确关闭语句：

```text
Close #<issue-number>
```

缺少 issue、引用其他仓库 issue 或正文缺少关闭语句时立即拒绝。

## 6. 本地质量门禁

创建 PR 或 push 前必须运行 `$pr-gate`，并得到以下成功证据：

1. diff 与提交范围正确，无无关或生成文件。
2. 与最新 `origin/develop` 无合并冲突。
3. `./scripts/lint-local.sh` 为 `PASS`。
4. Debug Simulator 编译为 `PASS`，无新增警告。
5. 相关 `PauseGuardTests` 单元/集成测试为 `PASS`。
6. `$code-review` 为 `PASS`，无未解决 P0/P1/P2 finding。
7. 架构、安全、文档和 `$verification-gate` 等受影响门禁为 `PASS`。
8. UI 变更获得人工视觉验收 `PASS`；无 UI 改动记录为 `PASS — 无 UI 影响`。

XCUITest target 与测试源码允许进入 PR，人工可以运行；Agent 禁止自行执行 XCUITest 或其他 UI 自动化。Agent 未运行 UI 自动化不构成缺失门禁，但人工视觉验收仍是 UI PR 的必需证据。任何其他 required check 的 `failed`、未运行、工具不可用、结果不明确、冲突未解决或 review finding 未收口都必须拒绝，不得作为 skip 继续。

建议在条件允许时使用多个独立 Agent 分别进行代码、架构、安全与测试审查；同一文件只由主 Agent 集成写入。也建议 CI 将 lint、build、unit tests、review 拆为多个独立 Action/check。

## 7. 固定宽高人工确认门禁

PR 前严格检查 SwiftUI 和 UIKit UI 改动中的固定宽高，特别是：

- 文本或动态内容上的 `.frame(width:)`、`.frame(height:)`；
- 可能破坏 Dynamic Type、本地化或不同屏幕尺寸的固定容器；
- `widthAnchor` / `heightAnchor` 的硬编码常量；
- 同时锁死宽高且缺少产品或设计依据的约束。

发现明显可疑项时：列出文件、行号、约束与风险，暂停 PR，等待人工逐项确认。只有获得明确确认或完成修复并复验后才能继续。固定图标尺寸不自动视为错误，但仍需判断其语义。

## 8. GitHub Actions 与合并

- 禁止主动 dispatch、rerun、cancel 或以其他方式触发 GitHub Actions。
- 创建 PR 后，仓库配置可能自动触发 workflow；只能观察这些自动产生的 checks。
- 对 PR 当前 head commit，所有 required compile/test checks 必须为 `success` / `pass` 才能认为合并安全。
- missing、pending、stale、cancelled、skipped、failed 均不能视为通过。
- 所有 PR 禁止自动合并；Agent 不开启 auto-merge，也不在门禁流程中执行合并。

## 9. PR 文档模板

```markdown
## 标题

<PR 标题>

## 改动背景

<为什么需要这次改动>

## 改动内容

- <具体改动>

## Code Review 结果

- PASS: <审查范围与结论>

## 验证测试结果

- PASS: Lint
- PASS: 编译
- PASS: 单元/集成测试
- PASS: 合并冲突检查
- PASS: 人工 UI 验收，或无 UI 影响
- PASS: GitHub required checks

## 关联 Issue

- #<issue-number>: <Issue 标题与关联内容摘要>

Close #<issue-number>
```

不得在远程提交或 PR 文档中加入 bot、AI 或工具署名。

## 10. 最终状态

- `PASS`：所有门禁都有成功证据，PR 继续保持人工处理。
- `PAUSED — HUMAN CONFIRMATION REQUIRED`：等待固定宽高确认或人工视觉验收，不允许远程写入。
- `REJECTED`：列出失败规则、证据和修正方式，不允许远程写入。
