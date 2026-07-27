# 仓库指南

Skills 按 bucket folder 组织在 `skills/` 下：

- `engineering/` — 日常代码工作
- `productivity/` — 日常非代码工作流工具
- `misc/` — 保留但很少使用，不推广
- `personal/` — 绑定我自己的设置，不推广
- `in-progress/` — 尚未准备发布的草稿
- `deprecated/` — 不再使用

`engineering/` 或 `productivity/`（即 **promoted** buckets）中的每个 skill，都必须在顶层 `README.md` 中有引用，并在 `.claude-plugin/plugin.json` 的 `skills` 数组中有一个条目（Claude Code plugin 恰好发布这个 promoted 集合）。`misc/`、`personal/`、`in-progress/` 和 `deprecated/` 中的 skills 不得出现在这两处任何一处。

本仓库也是它自己的单 plugin Claude Code marketplace：`.claude-plugin/marketplace.json` 列出唯一的 `mattpocock-skills` plugin。bump 发布版本时，让 `.claude-plugin/plugin.json` 的 `version` 与 `package.json` 的保持同步——Claude 用 plugin 的 `version` 来决定安装用户何时看到更新。改动任一 manifest 后，运行 `claude plugin validate . --strict`。为什么是 Claude plugin 而（暂时）不是 Codex plugin，见 [docs/adr/0002-ship-as-a-claude-code-plugin.md](./docs/adr/0002-ship-as-a-claude-code-plugin.md)。

顶层 `README.md` 中的每个 skill 条目都必须把 skill 名称链接到对应的 `SKILL.md`。

每个 bucket folder 都有一个 `README.md`，列出该 bucket 中的所有 skills，并给出一行描述，skill 名称链接到对应的 `SKILL.md`。promoted buckets 的 `README.md` 以及顶层 `README.md` 把条目分成 **User-invoked** 与 **Model-invoked** 两组；非 promoted bucket 的 `README.md`（`misc/`、`personal/`）使用扁平列表。

`engineering/` 和 `productivity/` 中的 skills 还在 `docs/<bucket>/<skill-name>.md` 有一张面向人类的 docs page（docs 树镜像了 `skills/` 下的那两个 bucket folder）。无论 bucket 是什么，发布的 URL 都是 `https://aihero.dev/skills-<skill-name>`——docs 路径只是仓库组织层面的事。当你在 `engineering/` 或 `productivity/` 中新增、重命名一个 skill，或改变其行为时，按照 [docs/writing-docs.md](./docs/writing-docs.md) 创建或重新同步它的 docs page。非 promoted buckets（`misc/`、`personal/`、`in-progress/`、`deprecated/`）中的 skills **没有** docs page。

每个 `SKILL.md` 要么是 user-invoked（`disable-model-invocation: true`，外加 `agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`，只能由人类触达），要么是 model-invoked（模型或用户可触达）。见 [docs/invocation.md](./docs/invocation.md)。

[`ask-matt`](./skills/engineering/ask-matt/SKILL.md) 是那个映射每个用户可触达 skill 及其相互关系的 router。触发重新同步 docs page 的同一条件也适用于它：每当你新增、重命名、移除一个用户可触达 skill，或改变它如何融入各 flow 时，重读 `ask-matt` 的 `SKILL.md` 并更新它，使这张 map 保持准确——一个它从未提及的新 skill，或一个它仍在路由到的过时 skill，就是一个在撒谎的 router。

要把每个 skill（重新）链接进本地 harness 的 skill 目录（`~/.claude/skills`、`~/.agents/skills`），运行 `scripts/link-skills.sh`。每个条目都是一个指向本仓库的 symlink，所以一次 `git pull` 就能让已安装的 skills 保持最新；在新增、移除或重命名一个 skill 后重新运行这个脚本。

## 翻译刷新

从 `mattpocock/skills` 刷新上游内容时，改文件前先使用 `.skills/translate-skill/SKILL.md`。本仓库采用 skill-guided content localization，不做 Git fork-sync：保留简体中文本地化身份，安装命令保持指向 `vinvcn/mattpocock-skills-zh-CN`，不要导入上游 repository-management state。
