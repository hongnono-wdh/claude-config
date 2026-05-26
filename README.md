# Claude Code Config

Claude Code 个人配置同步仓库，用于在新项目/新服务器中复用插件、技能规则、记忆和最佳实践。

## 结构

```
├── CLAUDE.md              # 全局开发指令（Karpathy 四原则 · 插件引导 · Skill 规则 · Agent Teams）
├── settings.json          # 全局设置（插件 enabledPlugins / 市场 / 权限 / MCP）
├── bashrc-exports.sh      # 环境变量 + claude alias
├── memory/                # 持久化记忆
│   ├── MEMORY.md          # 记忆索引
│   ├── user_profile.md    # 用户档案
│   └── reference_*.md     # 参考记忆（工具最佳实践等）
├── skills/                # 自定义 Skill（预留）
└── site/index.html        # 落地页
```

## 插件（Plugins）

本仓库通过 Claude Code 插件机制启用 3 个插件。把 `settings.json` 复制到 `~/.claude/` 后，其中的 `enabledPlugins` + `extraKnownMarketplaces` 会让 Claude Code 启动时自动**注册这些市场并标记为启用**。

> ⚠️ **注册 ≠ 自动下载**：这是 Claude Code 的两步机制——`settings.json` 只负责注册市场、声明启用状态；插件本体仍需运行一次下方的 `claude plugin install` 命令才会真正拉取安装。所以新机器配置时，复制 `settings.json` 后**务必再跑一遍安装命令**。

| 插件 | 市场 | 来源仓库 | 用途 |
|------|------|----------|------|
| **superpowers** | `claude-plugins-official`（官方） | obra/superpowers（Jesse Vincent） | 14 个开发方法论 skill：TDD、系统化调试、头脑风暴、计划/执行、子代理、代码审查、worktree 等 |
| **understand-anything** | `understand-anything` | Lum1104/Understand-Anything | 代码库知识图谱：架构理解、PR/diff 分析、领域建模、onboarding（8 skill + 9 agent + 2 hook） |
| **andrej-karpathy-skills** | `karpathy-skills` | forrestchang/andrej-karpathy-skills | `karpathy-guidelines`：减少 LLM 编码常见错误的四原则 |

> **来源说明：** `superpowers` 来自 Claude 官方市场 `claude-plugins-official`；`understand-anything`、`andrej-karpathy-skills` 来自各项目作者维护的官方 GitHub 仓库——均为作者 README 中推荐的安装方式，并非非官方搬运。

### 🚀 一键聚合安装（推荐）

安装本仓库的 `claude-config` 聚合插件,会**自动带装** 5 个依赖插件——上面 3 个 + `typescript-lsp` / `gopls-lsp`（TS / Go 符号级导航;Solidity 靠 Serena),外加 `claude-config-guidelines`（Karpathy 准则 + 工具选型引导）skill、Playwright/Serena MCP、reflection hook：

```bash
# 先注册被依赖的两个作者市场（superpowers 在官方市场，无需注册）
claude plugin marketplace add Lum1104/Understand-Anything
claude plugin marketplace add forrestchang/andrej-karpathy-skills
# 注册本仓库市场并安装聚合插件（5 个依赖插件自动带装，含 TS/Go LSP）
claude plugin marketplace add hongnono-wdh/claude-config
claude plugin install claude-config@claude-config
```

> 实测：装 `claude-config` 时输出会显示 `(+ N dependencies)`，5 个依赖插件（3 能力插件 + TS/Go LSP）自动到位。仅那 11 个独立 skill 因 Claude Code 不支持安装脚本，需单独装（见下方「独立 Skills」或用 AI 提示词让 Claude 代跑）。

### 单独安装各插件（备选）

```bash
claude plugin install superpowers@claude-plugins-official
claude plugin marketplace add Lum1104/Understand-Anything && claude plugin install understand-anything@understand-anything
claude plugin marketplace add forrestchang/andrej-karpathy-skills && claude plugin install andrej-karpathy-skills@karpathy-skills
```

## 环境变量配置（~/.bashrc）

```bash
export PATH="$HOME/.local/bin:$PATH"
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS="1"  # 启用 Agent Teams
export MAX_THINKING_TOKENS="10000"               # 思考 token 上限
export CLAUDE_CODE_EFFORT_LEVEL="max"            # 最大努力等级
export IS_SANDBOX=1                              # 允许 root 用户使用 dangerously mode

# 运行 claude 时自动启用全权限模式
alias claude='command claude --dangerously-skip-permissions'
```

> **注意：** `IS_SANDBOX=1` 仅解除 root 用户限制。alias 会让 `claude` 命令自动带上 `--dangerously-skip-permissions`，无需额外操作。

## settings.json（~/.claude/settings.json）

包含插件启用配置（`enabledPlugins`）、额外市场来源（`extraKnownMarketplaces`）、权限与 MCP：

```json
{
  "effortLevel": "high",
  "skipDangerousModePermissionPrompt": true,
  "enabledPlugins": {
    "superpowers@claude-plugins-official": true,
    "understand-anything@understand-anything": true,
    "andrej-karpathy-skills@karpathy-skills": true
  },
  "extraKnownMarketplaces": {
    "understand-anything": { "source": { "source": "github", "repo": "Lum1104/Understand-Anything" } },
    "karpathy-skills":     { "source": { "source": "github", "repo": "forrestchang/andrej-karpathy-skills" } }
  },
  "permissions": {
    "allow": ["Bash(*)", "Read(*)", "Write(*)", "Edit(*)", "Glob(*)", "Grep(*)", "Agent(*)", "Skill(*)", "WebFetch(*)", "WebSearch(*)", "NotebookEdit(*)", "TodoWrite(*)"],
    "deny": []
  },
  "mcpServers": {
    "playwright": { "command": "npx", "args": ["@playwright/mcp", "--headless"] },
    "serena": { "command": "uvx", "args": ["-p", "3.13", "--from", "git+https://github.com/oraios/serena", "serena", "start-mcp-server", "--context", "claude-code"] }
  }
}
```

> 官方市场 `claude-plugins-official` 由 Claude Code 内置、自动可用，无需在 `extraKnownMarketplaces` 声明（但市场里的插件仍需 `claude plugin install` 安装）。

## MCP Servers

| MCP Server | 用途 | 安装方式 |
|------------|------|----------|
| **Playwright** | 浏览器自动化（headless） | `npm install -g @playwright/mcp` + `npx playwright install --with-deps chromium` |
| **Serena** | 语义代码分析，符号级搜索编辑，40+ 语言 | `curl -LsSf https://astral.sh/uv/install.sh \| sh`，通过 uvx 启动 |

## 工具选型：Serena vs understand-anything

两者职责不同、互补，建议都装：

| | Serena（MCP） | understand-anything（插件） |
|---|--------------|---------------------------|
| 本质 | 符号级操作工具 | 知识图谱 / 文档生成器 |
| 用途 | Claude 实时找符号、查引用、精确编辑 | 建立全局理解：架构图、可视化、onboarding |
| 成本 | 低，反而省 token | 高（`understand` 单次约 17.8k tok） |
| 频率 | 高频，贯穿日常开发 | 低频，按需一次性 |
| 口诀 | **要改代码、要精确** | **要看懂全局、要文档** |

典型配合：接手陌生库 → `understand` 摸清架构 → Serena 精确改代码 → `understand-diff` 评估大 PR 影响面。

## 独立 Skills（npx skills add · 11 个）

插件之外，以下 11 个 skill 通过 `npx skills add` 单独安装：

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

安装命令：

```bash
npx skills add anthropics/skills -a claude-code -g -y --skill frontend-design --skill canvas-design --skill webapp-testing --skill skill-creator
npx skills add nextlevelbuilder/ui-ux-pro-max-skill -a claude-code -g -y --skill ui-ux-pro-max
npx skills add intellectronica/agent-skills -a claude-code -g -y --skill context7
npx skills add softaworks/agent-toolkit -a claude-code -g -y --skill database-schema-designer
npx skills add microsoft/playwright-cli -a claude-code -g -y --skill playwright-cli
npx skills add github/awesome-copilot -a claude-code -g -y --skill refactor
npx skills add wshobson/agents -a claude-code -g -y --skill solidity-security
npx skills add wuji-labs/nopua -a claude-code -g -y --skill nopua
```

> superpowers 不再通过 `npx skills add obra/superpowers` 安装——它现在是官方市场插件（见上方「插件」章节）。

## 使用方法

### 新服务器一键配置

```bash
# 1. 克隆配置仓库
git clone https://github.com/hongnono-wdh/claude-config.git

# 2. 复制全局配置（已有同名文件先备份为 .bak，避免覆盖原有配置）
mkdir -p ~/.claude
[ -f ~/.claude/CLAUDE.md ] && cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.bak
[ -f ~/.claude/settings.json ] && cp ~/.claude/settings.json ~/.claude/settings.json.bak
cp claude-config/CLAUDE.md ~/.claude/CLAUDE.md
cp claude-config/settings.json ~/.claude/settings.json
# 原有配置已存到 .bak；若需保留请手动合并，或改用 AI 提示词方式让 Claude 智能合并

# 3. 设置环境变量
cat claude-config/bashrc-exports.sh >> ~/.bashrc
source ~/.bashrc

# 4. 安装 MCP 依赖
npm install -g @playwright/mcp && npx playwright install --with-deps chromium
curl -LsSf https://astral.sh/uv/install.sh | sh

# 5. 一键安装聚合插件（自动带装 5 个依赖：3 插件 + TS/Go LSP，外加规则 skill/MCP/hook）
claude plugin marketplace add Lum1104/Understand-Anything
claude plugin marketplace add forrestchang/andrej-karpathy-skills
claude plugin marketplace add hongnono-wdh/claude-config
claude plugin install claude-config@claude-config

# 6. 安装 11 个独立 skill（见上方命令）
```

### 同步记忆到项目

```bash
cp -r claude-config/memory/* ~/.claude/projects/<project-path>/memory/
```
