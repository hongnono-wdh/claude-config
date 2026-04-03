---
name: mcp-servers-config
description: 已配置的 MCP 服务器列表和使用说明
type: reference
---

## 已配置的 MCP Servers（~/.claude/settings.json）

| MCP Server | 用途 | 启动方式 |
|------------|------|----------|
| **playwright** | 浏览器自动化，headless 模式 | `npx @playwright/mcp --headless` |
| **serena** | 语义代码分析，符号级搜索和编辑 | `uvx serena start-mcp-server --context claude-code` |

## Playwright 使用要点

- 已安装 Chromium headless shell
- 不会弹出浏览器窗口
- 用于自动化测试和网页交互

## Serena 使用要点

- 大项目才有价值，小项目用普通工具
- 详见 serena-mcp-best-practices 记忆
