# Claude Code Config

Claude Code 个人配置同步仓库，用于在新项目中复用技能规则、记忆和最佳实践。

## 结构

```
├── CLAUDE.md              # 全局开发指令（Skill 使用规则、Agent Teams 规则）
├── memory/                # 持久化记忆
│   ├── MEMORY.md          # 记忆索引
│   ├── user_profile.md    # 用户档案
│   ├── reference_*.md     # 参考记忆（工具最佳实践等）
│   └── ...
└── skills/                # 自定义 Skill（预留）
```

## 使用方法

### 同步到新项目

```bash
# 复制 CLAUDE.md 到全局配置
cp CLAUDE.md ~/.claude/CLAUDE.md

# 复制记忆到项目目录
cp -r memory/* ~/.claude/projects/<project-path>/memory/
```

### 已安装的 Skills（全局）

通过 `npx skills list -a claude-code -g` 查看。

### 已配置的 MCP Servers

- Playwright（headless 浏览器自动化）
- Serena（语义代码分析）
