---
name: git-guardrails-claude-code
description: 设置 Claude Code hooks，在危险的 git 命令（push、reset --hard、clean、branch -D 等）执行前将其拦截。适用于用户想要阻止破坏性 git 操作、添加 git 安全 hooks，或在 Claude Code 中拦截 git push/reset 时。
---

# Setup Git Guardrails

设置一个 PreToolUse hook，在 Claude 执行危险的 git 命令之前拦截并阻止它们。

## What Gets Blocked

- `git push`（所有变体，包括 `--force`）
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

被拦截时，Claude 会看到一条消息，告知它没有权限访问这些命令。

## Steps

### 1. Ask scope

询问用户：只为**本项目**安装（`.claude/settings.json`），还是为**所有项目**安装（`~/.claude/settings.json`）？

### 2. Copy the hook script

随附的脚本位于：[scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)

根据 scope 将其复制到目标位置：

- **Project**：`.claude/hooks/block-dangerous-git.sh`
- **Global**：`~/.claude/hooks/block-dangerous-git.sh`

用 `chmod +x` 赋予可执行权限。

### 3. Add hook to settings

添加到相应的 settings 文件：

**Project**（`.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**Global**（`~/.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

如果 settings 文件已存在，把该 hook 合并进现有的 `hooks.PreToolUse` 数组——不要覆盖其他设置。

### 4. Ask about customization

询问用户是否想在拦截列表中添加或移除任何 pattern。相应地编辑复制过去的脚本。

### 5. Verify

快速测试一下：

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
```

应当以退出码 2 退出，并向 stderr 输出一条 BLOCKED 消息。
