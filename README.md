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

## 环境变量配置（~/.bashrc）

```bash
export PATH="$HOME/.local/bin:$PATH"
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS="1"  # 启用 Agent Teams
export MAX_THINKING_TOKENS="10000"               # 思考 token 上限
export CLAUDE_CODE_EFFORT_LEVEL="max"            # 最大努力等级
export IS_SANDBOX=1                              # 允许 root 用户使用 dangerously mode

# 别名：任意目录下运行 claude1 即可启动全权限模式
alias claude1='claude --dangerously-skip-permissions'
```

> **注意：** `IS_SANDBOX=1` 仅解除 root 用户限制，实际的权限跳过（bypass permissions）由 `settings.json` 中的 `permissions.allow` 字段控制。`claude1` 别名会同时启用 `--dangerously-skip-permissions`，确保在任何项目目录下都能跳过权限确认。

## settings.json（~/.claude/settings.json）

```json
{
  "effortLevel": "high",
  "skipDangerousModePermissionPrompt": true,
  "permissions": {
    "allow": [
      "Bash(*)", "Read(*)", "Write(*)", "Edit(*)",
      "Glob(*)", "Grep(*)", "Agent(*)", "Skill(*)",
      "WebFetch(*)", "WebSearch(*)", "NotebookEdit(*)", "TodoWrite(*)"
    ],
    "deny": []
  },
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp", "--headless"]
    },
    "serena": {
      "command": "uvx",
      "args": [
        "-p", "3.13",
        "--from", "git+https://github.com/oraios/serena",
        "serena", "start-mcp-server",
        "--context", "claude-code"
      ]
    }
  }
}
```

## MCP Servers

| MCP Server | 用途 | 安装方式 |
|------------|------|----------|
| **Playwright** | 浏览器自动化（headless） | `npm install -g @playwright/mcp` + `npx playwright install --with-deps chromium` |
| **Serena** | 语义代码分析，符号级搜索编辑，40+ 语言 | `curl -LsSf https://astral.sh/uv/install.sh \| sh`，通过 uvx 启动 |

## 已安装的 Skills（24 个）

### Superpowers 系列（obra/superpowers）
| Skill | 用途 |
|-------|------|
| brainstorming | 创意工作前的结构化头脑风暴 |
| dispatching-parallel-agents | 2+ 独立任务并行调度 |
| executing-plans | 按检查点执行实现计划 |
| finishing-a-development-branch | 分支完结：合并/PR/清理 |
| receiving-code-review | 收到 review 后验证再改，不盲从 |
| requesting-code-review | 发起代码审查 |
| subagent-driven-development | 子代理驱动开发 |
| systematic-debugging | 4 步排错法，强制先找根因 |
| test-driven-development | 先写测试再写实现 |
| using-git-worktrees | Git worktree 隔离开发 |
| verification-before-completion | 声称完成前必须验证 |
| writing-plans | 需求→计划，先规划再动代码 |
| writing-skills | 创建/编辑/验证 skill |

### 设计类
| Skill | 来源 | 用途 |
|-------|------|------|
| frontend-design | anthropics | 前端设计，避免 AI 审美 |
| ui-ux-pro-max | nextlevelbuilder | 99 条 UX 规则 + 色彩/字体系统 |
| canvas-design | anthropics | 视觉设计/海报/艺术作品 |

### 开发工具类
| Skill | 来源 | 用途 |
|-------|------|------|
| context7 | intellectronica | 查询库/框架最新文档 |
| database-schema-designer | softaworks | 数据库 Schema 设计 |
| playwright-cli | microsoft | 浏览器自动化命令 |
| webapp-testing | anthropics | Web 应用测试 |
| refactor | github/awesome-copilot | 代码重构 |
| skill-creator | anthropics | 创建和迭代 skill |
| solidity-security | wshobson | 智能合约安全 |
| nopua | wuji-labs | 卡住时切换思路，不放弃 |

## 安装方式

```bash
# Superpowers 全家桶
npx skills add obra/superpowers -a claude-code -g -y --skill '*'

# 其他 skill 单独安装
npx skills add anthropics/skills -a claude-code -g -y --skill frontend-design --skill canvas-design --skill webapp-testing --skill skill-creator
npx skills add nextlevelbuilder/ui-ux-pro-max-skill -a claude-code -g -y --skill ui-ux-pro-max
npx skills add intellectronica/agent-skills -a claude-code -g -y --skill context7
npx skills add softaworks/agent-toolkit -a claude-code -g -y --skill database-schema-designer
npx skills add microsoft/playwright-cli -a claude-code -g -y --skill playwright-cli
npx skills add github/awesome-copilot -a claude-code -g -y --skill refactor
npx skills add wshobson/agents -a claude-code -g -y --skill solidity-security
npx skills add wuji-labs/nopua -a claude-code -g -y --skill nopua
```

## 使用方法

### 同步到新项目

```bash
# 复制 CLAUDE.md 到全局配置
cp CLAUDE.md ~/.claude/CLAUDE.md

# 复制记忆到项目目录
cp -r memory/* ~/.claude/projects/<project-path>/memory/
```

### 在新服务器上一键配置

```bash
# 1. 克隆配置仓库
git clone https://github.com/hongnono-wdh/claude-config.git

# 2. 复制全局配置
cp claude-config/CLAUDE.md ~/.claude/CLAUDE.md
cp claude-config/settings.json ~/.claude/settings.json

# 3. 安装 skills（见上方安装命令）

# 4. 设置环境变量
cat claude-config/bashrc-exports.sh >> ~/.bashrc
source ~/.bashrc
```
