# 开发环境

## 要求

- macOS with Xcode 26+
- iOS 26 simulator runtime or device
- Git
- CodeGraph CLI 与 Codex MCP 服务（必需）
- 可选：SwiftLint、Xcode MCP / XcodeBuildMCP

## 初始化

```bash
git clone https://github.com/Bistu-iOSClub/PauseGuard.git
cd PauseGuard
open PauseGuard.xcodeproj
```

## CodeGraph（必需）

源码检索和代码库导航必须通过 CodeGraph Codex MCP 完成。首次使用先安装官方 CLI：

```bash
npm install -g @colbymchenry/codegraph
```

在仓库根目录初始化索引：

```bash
codegraph init
```

项目的 `.mcp.json` 与 `.ai/mcp.json` 已配置以下 Codex MCP 服务：

```json
{
  "codegraph": {
    "command": "codegraph",
    "args": ["serve", "--mcp"]
  }
}
```

完成安装和初始化后重启 Codex，使 MCP 配置生效。索引陈旧时运行 `codegraph sync`，再通过 `$mcp-health-check` 确认 CLI、MCP 服务、`.codegraph/` 索引与 `codegraph_explore` 均可用。

缺少任一项时必须暂停源码检索并先修复环境。禁止回退到 `rg`、`grep`、`find`、IDE 文本搜索、shell glob 或自定义扫描脚本；CodeGraph CLI 也不得作为日常源码搜索替代品。

当前仓库没有根级 Swift Package manifest，也未声明第三方依赖。若 Xcode 工程后续加入 Swift Package，请提交工程中的依赖声明和 `Package.resolved`，并更新本文档。

## 本地配置

- 不提交团队成员本地签名设置、`xcuserdata`、`.env` 或 credentials。
- 需要秘密时提交 `.env.example` 或配置键说明，不提交真实值。
- Bundle identifier 与 signing 变更属于项目决策，不作为解决本机构建问题的默认手段。

## Agent 工具

项目 MCP 配置位于 `.mcp.json` 和 `.ai/mcp.json`，默认包含：

- `codegraph`: `codegraph serve --mcp`（源码检索必需）
- `xcode`: `xcrun mcpbridge`
- `xcodebuildmcp`: `npx -y xcodebuildmcp@latest mcp`

Xcode MCP 缺少时可以使用 shell `xcodebuild`，并记录回退原因；CodeGraph MCP 不允许回退。
