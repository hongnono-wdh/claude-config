---
name: agent-teams-best-practices
description: Claude Code Agent Teams 的使用场景、配置方法和最佳实践
type: reference
---

## Agent Teams 是什么

协调多个 Claude Code 实例并行工作的实验性功能。与 subagent（同一会话内）不同，agent teams 是独立会话，各自有完整上下文窗口。

## 已配置

- 环境变量 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` 已在 `~/.bashrc` 中设置
- 显示模式：默认 in-process（Shift+Down 切换 teammate）

## 何时使用 Agent Teams

### ✅ 适合的场景
- **并行代码审查**：安全/性能/测试覆盖各一个 teammate
- **竞争假设调试**：多个 teammate 测试不同假设，互相质疑
- **多模块重构**：每人负责不同模块，避免文件冲突
- **技术调研**：并行评估多种方案

### ❌ 不适合的场景
- 顺序依赖强的任务
- 多人需要编辑同一文件
- 简单任务（协调开销 > 收益）
- 成本敏感（3 teammate = 3-4x token 消耗）

## Agent Teams vs Subagent vs Worktree 选择

| 特性 | 单会话 | Subagent | Agent Teams |
|------|--------|----------|-------------|
| 上下文 | 共享 | 独立，结果返回主代理 | 完全独立 |
| 通信 | - | 只回报主代理 | teammate 间可直接通信 |
| Token 成本 | 1x | 1.2-1.5x | 3-4x |
| 适用 | 顺序任务 | 委派+汇报 | 并行探索+协作 |

## 最佳实践

1. **团队规模**：3-5 个 teammate，每人 5-6 个任务
2. **避免文件冲突**：每个 teammate 负责不同文件/模块
3. **完整上下文**：spawn 时提供所有必要信息（teammate 不继承对话历史）
4. **定期检查**：不要让 team 无人监管太久
5. **任务粒度**：不要太小（协调开销大）也不要太大（没有检查点）
6. **质量门控**：可用 hooks（TeammateIdle/TaskCompleted）自动验证

## 配置方式

```bash
# 环境变量（已配置）
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# 显示模式设置（~/.claude.json）
# "in-process"：所有 teammate 在同一终端，Shift+Down 切换
# "tmux"：每个 teammate 独立面板（需安装 tmux）
```

## 实用模式

### 并行代码审查
```
创建 agent team 审查 PR #142：
- Teammate 1：安全审查（JWT/CORS/注入）
- Teammate 2：性能审查（N+1查询/缓存/包大小）
- Teammate 3：测试覆盖率审查
```

### 竞争假设调试
```
App 在一条消息后退出，spawn 5 个 teammate 各测试不同假设，
让他们互相质疑，用证据辩论，最终收敛到根因。
```

### 多模块重构
```
每个 teammate 负责一个独立模块（auth/db/routes/tests），
各自完成后由 lead 集成测试。
```

## 相关 Skill 对应关系

| Skill | 与 Agent Teams 的关系 |
|-------|----------------------|
| dispatching-parallel-agents | 结构化的 team 创建和任务分配 |
| subagent-driven-development | 同一会话内的子代理，适合有依赖的任务 |
| using-git-worktrees | 手动创建隔离工作区，可配合 team 使用 |

## 限制

- 不支持 session 恢复（/resume 不恢复 teammate）
- 不支持嵌套 team（teammate 不能再 spawn team）
- 每个 session 只能管理一个 team
- split-pane 需要 tmux/iTerm2
