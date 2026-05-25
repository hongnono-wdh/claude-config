# Global Development Guidelines

## 编码核心准则（Karpathy 四原则 · 始终遵循）

> 由 `andrej-karpathy-skills` 插件的 `karpathy-guidelines` skill 强化。即使未显式触发，也应默认遵循——它们直接对治 LLM 编码的常见毛病：乱做假设、过度复杂、乱改无关代码。

1. **编码前思考**：不替用户做假设；有歧义就问，别默默选一种解释；呈现多种方案与权衡；发现更简单的做法就直说；困惑时停下来求澄清。
2. **简洁优先**：用最少代码解决问题；不加要求之外的功能 / 抽象 / "灵活性"；能 50 行别写 200 行；资深工程师会嫌复杂，就简化。
3. **精准修改**：只改与任务直接相关的代码；不顺手"改进"相邻代码、注释、格式；不重构没坏的东西；匹配现有风格；无关死代码只提示、不擅自删除。
4. **目标驱动执行**：把指令式任务转成可验证的成功标准（"加校验" → "为非法输入写测试并让它通过"）；多步任务先列计划 + 每步验证；循环验证直到达标。

> 例外：琐碎任务（拼写修正、显而易见的一行改动）自行判断，不必每次都走完整严谨流程。目标是减少非琐碎工作中代价高昂的错误，而非拖慢简单任务。

## 已安装插件（Plugins）

通过官方市场 + 第三方市场安装；启用状态与市场来源见 `settings.json` 的 `enabledPlugins` / `extraKnownMarketplaces`。

| 插件 | 市场 | 用途 |
|------|------|------|
| **superpowers** | `claude-plugins-official`（Claude 官方） | 14 个开发方法论 skill：TDD、系统化调试、头脑风暴、计划/执行、子代理、代码审查、worktree 等。下方「Skill 使用规则」中的同名 skill 即由它提供 |
| **understand-anything** | `Lum1104/Understand-Anything` | 把代码库转成可交互知识图谱：架构理解、PR/diff 分析、领域建模、新人 onboarding（含 8 skill + 9 agent + 2 hook） |
| **andrej-karpathy-skills** | `forrestchang/andrej-karpathy-skills` | `karpathy-guidelines`：上方编码四原则 |

### understand-anything 触发场景
- **接手陌生代码库 / 理清架构** → `understand`（生成知识图谱）、`understand-dashboard`（可视化仪表盘）
- **就代码库提问** → `understand-chat`
- **深入解释某文件 / 函数 / 模块** → `understand-explain`
- **分析 git diff / PR 的改动与风险** → `understand-diff`
- **提取业务领域知识** → `understand-domain`
- **给新成员生成上手指南** → `understand-onboard`

### Serena（MCP）vs understand-anything（插件）选型
两者互补，不是二选一：
- **要精确操作代码 → Serena**：按符号定位（`find_symbol`）、查引用（`find_referencing_symbols`）、符号级编辑与重构。日常高频、省 token。
- **要建立全局理解 → understand-anything**：陌生/复杂代码库生成知识图谱、可视化、领域图、onboarding 文档、PR 影响面分析。低频、开销大（`understand` 单次约 17.8k tok）。
- **典型配合**：接手陌生库先用 `understand` 摸清架构 → 动手改代码用 Serena 精确定位编辑 → 大 PR 用 `understand-diff` 评估影响面。

## Skill 使用规则

遇到以下场景时，优先使用对应 skill（通过 Skill 工具调用）。其中 superpowers 系列由插件提供，名称不变：

### 自动触发（无需用户指定）
- **遇到 bug/报错** → systematic-debugging（先找根因，再修复）
- **卡住/失败 2 次以上** → nopua（切换思路，不放弃）
- **数据库设计/建表** → database-schema-designer
- **写 Solidity 合约** → solidity-security
- **重构代码** → refactor
- **浏览器自动化操作** → playwright-cli
- **Web 应用测试/调试 UI** → webapp-testing
- **查询库/框架文档** → context7
- **即将声称任务完成/修复/通过** → verification-before-completion（先跑验证命令，再说"搞定了"）
- **实现功能/修 bug 前** → test-driven-development（先写测试，再写实现）

### 开发流程触发（按阶段自动选择）
- **收到需求/规格，需要规划** → writing-plans（先写计划，再动代码）
- **有计划要执行** → executing-plans（按检查点执行）
- **面对 2+ 个独立任务** → dispatching-parallel-agents（并行子代理）
- **执行计划中有独立子任务** → subagent-driven-development（子代理驱动）
- **需要功能隔离开发** → using-git-worktrees（创建独立 worktree）
- **实现完成，测试通过** → finishing-a-development-branch（合并/PR/清理）
- **收到代码审查反馈** → receiving-code-review（验证反馈合理性，不盲从）

### 用户请求时触发
- **"review" / 代码审查** → requesting-code-review
- **"设计 UI" / 前端** → frontend-design 或 ui-ux-pro-max
- **"创建 skill"** → skill-creator 或 writing-skills
- **"设计海报/视觉"** → canvas-design
- **"头脑风暴" / 创意讨论** → brainstorming
- **"理解代码库" / 看不懂架构** → understand-anything 插件（见上方触发场景）

## Agent Teams 使用规则

Agent Teams 已启用（CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1）。

### 何时使用 Agent Teams（而非单会话/Subagent）
- **并行代码审查**：多 teammate 分别从安全/性能/测试角度审查
- **竞争假设调试**：多 teammate 各测试不同假设，互相质疑收敛根因
- **多模块重构**：每 teammate 负责独立模块，避免文件冲突
- **技术调研/方案对比**：并行评估多种技术方案

### 何时不要用 Agent Teams
- 任务间顺序依赖强 → 用 subagent-driven-development
- 多人需编辑同一文件 → 会产生覆盖冲突
- 简单任务 → 协调开销 > 收益
- 成本敏感 → 3 teammate = 3-4x token 消耗

### 使用原则
- 团队规模 3-5 人，每人 5-6 个任务
- spawn 时提供完整上下文（teammate 不继承对话历史）
- 每个 teammate 负责不同文件/模块，避免冲突
- 定期检查进度，不要无人监管太久

## 通用规范
- 优先使用中文与用户交流
- 请根据实际环境修改下方配置
- 服务器环境为 Ubuntu
- Git 用户：请替换为你的 GitHub 用户名和邮箱
