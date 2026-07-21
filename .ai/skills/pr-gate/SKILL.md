---
name: pr-gate
description: Enforce the mandatory Bistu-iOSClub/PauseGuard pull-request and remote-upload gate. Use whenever pushing local commits, creating or updating a PR, checking PR merge safety, or preparing any remote GitHub submission.
---

# PR Gate

Treat this as a blocking gate. Never push or create/update a PR until every applicable preflight item is `PASS`. Never weaken a failed check, silently skip an unavailable check, or claim success without evidence.

Read `docs/dev/git-workflow.md`, then inspect the actual local branch, remote refs, authenticated GitHub account, issue, diff, and checks.

## 1. Enforce branch direction

Apply this repository flow:

```text
dev/* -> develop -> staging -> main
```

- Permit a team developer or `maintain` member to submit only `dev/* -> develop`.
- Require every `dev/*` branch to originate from `develop`. Reject branches created from `main`, `staging`, another `dev/*`, or an unrelated history. A developer may update the branch only from `develop`; never pull another base branch into it.
- Reject `dev/* -> staging`, `dev/* -> main`, `develop -> main`, reverse-flow, and cross-level PRs immediately.
- Never initiate, pull, push, or approve release-promotion PRs. `develop -> staging` and `staging -> main` are administrator-only operations manually initiated and approved on GitHub.
- Treat any request to bypass a level as rejected, even if the requester has maintain access. Administrator actions remain outside this skill's execution scope.

On violation, stop before any remote write and report source branch, target branch, violated rule, and allowed correction.

## 2. Verify human GitHub identity

Before committing, pushing, or creating/updating a PR:

1. Verify the active `gh` account belongs to the submitting human team member.
2. Verify `git config user.name` and `user.email` belong to that same person's GitHub account.
3. Inspect every commit being uploaded. Require a human author/committer identity associated with that account.
4. Reject any author, committer, PR author, title, body, trailer, or remote metadata containing `codex`, `[bot]`, `github-actions`, an automation account, or a bot attribution.
5. Never add AI-generated, bot-generated, co-author, or tool attribution to commits or PR text.
6. Do not rewrite identity automatically. If identity cannot be proven, stop and ask the user to authenticate or configure their own account.

Use the currently authenticated human account for the GitHub operation. Never substitute another stored account.

## 3. Require an issue

- Require one existing issue in `Bistu-iOSClub/PauseGuard` that directly corresponds to the PR.
- Verify the issue number and content through GitHub before remote submission.
- Reject the PR when the issue is missing, inaccessible, belongs to another repository, or does not describe the change.
- Summarize the linked issue title and relevant requirement in the PR body's issue section.
- Require the PR body to contain the exact closing line `Close #<issue-number>`.

## 4. Run local quality gates

Run every relevant project gate and require an explicit successful result:

1. `$project-standards`
2. `$mcp-health-check`, requiring CodeGraph CLI, current index, Codex MCP service, and `codegraph_explore` to pass
3. `$codegraph-search` for all code discovery, reference lookup, dependency tracing, and impact analysis
4. working-tree and intended-diff review
5. merge-conflict analysis against current `origin/develop`
6. SwiftLint through `./scripts/lint-local.sh`
7. Debug simulator build through `$run-build`
8. relevant unit/integration tests in `PauseGuardTests` through `$gen-tests`
9. `$code-review`
10. `$check-arch` when source structure or dependencies change
11. security/privacy review when high-risk paths change
12. `$verification-gate`
13. `$pr-readiness`

Reject on any `failed`, unresolved conflict, unavailable required tool, unrun required check, new compiler warning, unresolved P0/P1/P2 review finding, or ambiguous result. Only `success` / `pass` evidence may satisfy the gate.

Reject when CodeGraph was unavailable, its index was stale, the Codex MCP tool was not used for required code analysis, or any source-code search used `rg`, `grep`, `find`, IDE text search, shell globs, ad-hoc scanning, or a CodeGraph CLI search fallback.

Allow XCUITest targets and source files in the PR, but never execute XCUITest, scripted Simulator interaction, MCP-driven UI automation, or other UI automation as an agent. Human developers may run XCUITest. An absent agent-run UI-test result is not a failed gate. For a UI-changing PR, still require the human developer to perform visual acceptance and explicitly confirm `PASS`; XCUITest cannot replace it. For a non-UI diff, record `PASS — no UI impact`.

## 5. Inspect fixed layout constraints

Review UI changes for suspicious strict width or height constraints, especially fixed frames on text or dynamic content, hard-coded UIKit constraint constants, and layouts that can break with Dynamic Type or localization.

If any clearly suspicious constraint exists:

1. List each file, line, constraint, affected content, and risk.
2. Pause before push or PR creation.
3. Ask the human whether each constraint is intentional.
4. Continue only after explicit confirmation or a verified fix.

Do not treat fixed icon or control dimensions as automatically wrong; pause when the strict constraint is materially suspicious.

## 6. Handle GitHub Actions safely

- Never manually dispatch, rerun, cancel, or otherwise trigger GitHub Actions.
- PR creation may allow repository-configured workflows to run automatically; do not invoke them yourself.
- Inspect existing or automatically produced compile/test checks for the exact PR head commit. Require all required checks to report `success` / `pass` before declaring the PR safe.
- If required Action evidence is missing, pending, stale, cancelled, skipped, or failed, do not call the PR merge-safe.
- Recommend multiple independent checks or jobs for lint, build, unit tests, and review where repository configuration supports them.

## 7. Create the PR without merging

- Never enable auto-merge.
- Never merge the PR as part of this skill.
- Create or update the PR only after all pre-creation gates pass.
- After creation, inspect automatically produced checks and keep the result blocked until they pass.

Use this PR body structure:

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

Do not include bot or AI attribution.

## 8. Report the decision

Output one of:

- `PASS`: every gate has successful evidence; PR may remain open for human/admin handling.
- `PAUSED — HUMAN CONFIRMATION REQUIRED`: suspicious fixed layout or required manual visual acceptance awaits an answer; no remote write is allowed.
- `REJECTED`: state every failed rule, evidence, and required correction; no remote write is allowed.
