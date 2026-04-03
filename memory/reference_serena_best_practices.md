---
name: serena-mcp-best-practices
description: Serena MCP 语义代码分析工具的安装配置和最佳实践指南
type: reference
---

## Serena MCP 是什么

语义级代码分析 MCP 服务器，通过 LSP 支持 40+ 语言，提供符号级代码理解和编辑能力。与 grep/find 的区别：按符号定位而非字符串匹配，理解代码间引用关系，精确编辑不误伤。

## 安装方式

已配置在 `~/.claude/settings.json` 的 `mcpServers.serena`，使用 `uvx` 启动。

## 何时使用

- ✅ 大型代码库（数千文件以上），追踪符号引用关系，精确重构
- ❌ 小项目 / 从零写代码 — 没必要，普通 grep/read 就够

## 核心工具

| 工具 | 用途 |
|------|------|
| `find_symbol` | 按名称找符号（函数/类/变量） |
| `find_referencing_symbols` | 找谁引用了某个符号 |
| `get_symbols_overview` | 文件级符号概览 |
| `insert_after_symbol` | 在符号后精确插入代码 |
| `read_file` | 读取项目内文件 |

## 最佳实践

1. **项目初始化**：进入项目目录后，Serena 自动创建 `.serena/project.yml` 和 `.serena/memories/`
2. **先索引再使用**：首次使用会触发索引，大项目耐心等待
3. **优先用符号操作**：`find_symbol` 优于 `grep`，`insert_after_symbol` 优于手动编辑
4. **省 token**：Serena 只读取相关代码片段，不扫描全文件
5. **记忆文件**：`.serena/memories/` 存储项目理解，可手动查看和编辑
6. **按项目配置**：每个项目需要单独 `--project "$(pwd)"`，或在项目内运行

## 实际效果（社区反馈）

- 复杂功能开发节省 60-70% 时间
- Bug 更少，架构更一致
- Token 消耗显著降低

## 相关文档

- GitHub: https://github.com/oraios/serena
- 官方文档: https://oraios.github.io/serena/
- Setup Guide: https://smartscope.blog/en/generative-ai/claude/serena-mcp-claude-code-beginners-guide/
