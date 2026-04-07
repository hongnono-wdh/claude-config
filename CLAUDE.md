# Global Development Guidelines

## Skill 使用规则

遇到以下场景时，优先使用对应 skill（通过 Skill 工具调用）：

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
