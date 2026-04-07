# Claude Code 环境变量
export PATH="$HOME/.local/bin:$PATH"
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS="1"  # 启用 Agent Teams
export MAX_THINKING_TOKENS="10000"               # 思考 token 上限
export CLAUDE_CODE_EFFORT_LEVEL="max"            # 最大努力等级
export IS_SANDBOX=1                              # 允许 root 用户使用 dangerously mode
# 注意：bypass permissions 由 ~/.claude/settings.json 中的 permissions.allow 控制
# IS_SANDBOX=1 仅解除 root 用户限制，不会自动开启权限跳过

# 运行 claude 时自动启用全权限模式
alias claude='command claude --dangerously-skip-permissions'
