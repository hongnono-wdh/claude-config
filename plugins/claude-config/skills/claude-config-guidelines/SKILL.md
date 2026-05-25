---
name: claude-config-guidelines
description: claude-config 的工具与 skill 选型引导。在开始开发、调试、规划、重构或理解陌生代码库时参考：何时用 Serena（符号级精确编辑）还是 understand-anything（代码库全局理解），以及何时触发 systematic-debugging、test-driven-development、brainstorming、writing-plans 等 skill。
---

# claude-config 工具与 Skill 选型

本插件随附 superpowers、understand-anything、andrej-karpathy-skills 三大插件（作为依赖自动安装）。以下是高效组合它们的引导。

## 工具选型：Serena vs understand-anything
- **要精确操作代码 → Serena（MCP）**：按符号定位（`find_symbol`）、查引用（`find_referencing_symbols`）、符号级编辑与重构。日常高频、省 token。
- **要建立全局理解 → understand-anything（插件）**：陌生/复杂代码库生成知识图谱、可视化、领域图、onboarding、PR 影响面分析。低频、开销大（`understand` 单次约 17.8k tok）。
- **典型配合**：接手陌生库先用 `understand` 摸清架构 → 动手改代码用 Serena 精确定位编辑 → 大 PR 用 `understand-diff` 评估影响面。

## Skill 路由（superpowers 提供）
- 遇到 bug/报错 → `systematic-debugging`（先找根因再修）
- 实现功能/修 bug 前 → `test-driven-development`（先写测试）
- 即将声称完成/修复/通过 → `verification-before-completion`（先跑验证命令）
- 收到需求需规划 → `writing-plans`；有计划要执行 → `executing-plans`
- 创意/新功能讨论 → `brainstorming`
- 2+ 独立任务 → `dispatching-parallel-agents`；执行计划中的独立子任务 → `subagent-driven-development`
- 需要隔离开发 → `using-git-worktrees`；完成收尾 → `finishing-a-development-branch`
- 收到代码审查反馈 → `receiving-code-review`（验证合理性，不盲从）

## 编码核心准则
始终遵循 `karpathy-guidelines`（本插件依赖自带）的四原则：**编码前思考、简洁优先、精准修改、目标驱动执行**。即不替用户做假设、用最少代码、只改任务相关处、把任务转成可验证的成功标准。

## 探索与编辑分离
大型代码库改动前，可先派**只读 subagent** 摸清子系统、把发现写入文件，主 agent 再带着全局视图编辑——避免在同一会话里边探索边改。
