---
name: git-workflow
description: Apply PauseGuard branch, commit, and pull-request conventions. Use before creating branches, committing changes, pushing, or opening a PR in Bistu-iOSClub/PauseGuard.
---

Read `docs/dev/git-workflow.md`, inspect the actual branch and remote state, then enforce:

- Linear flow `dev/* -> develop -> staging -> main`.
- Developers and maintain members may only submit `dev/* -> develop`; each `dev/*` branch must originate from `develop` and may only pull updates from `develop`.
- Never initiate administrator-only `develop -> staging` or `staging -> main` promotions; reject all skipped levels such as `develop -> main`.
- Commit title `type(scope): 中文摘要` with a focused diff.
- Relevant Lint, build, and tests before publishing.
- Never force push, skip hooks, bypass verification, or rewrite published history.
- Use only the authenticated submitting team member's own GitHub identity; reject bot/automation attribution and any remote metadata containing `codex`.
- Require `$pr-gate` before every push, PR create/update, or merge-safety claim.
