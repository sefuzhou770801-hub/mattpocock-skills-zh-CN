---
name: setup-matt-pocock-skills
description: 为本仓库配置 engineering skills——搭建它的 issue tracker、triage label 词汇表以及 domain 文档布局。在首次使用其他 engineering skills 之前运行一次。
disable-model-invocation: true
---

# Setup Matt Pocock's Skills

搭建 engineering skills 所假定的、按仓库划分的配置：

- **Issue tracker** — issue 存放在哪里（默认是 GitHub；local markdown 也开箱即用地受支持）
- **Triage labels** — 用于五种规范 triage 角色的字符串
- **Domain docs** — `CONTEXT.md` 和 ADR 存放在哪里，以及读取它们时遵循的 consumer 规则

这是一个 prompt 驱动的 skill，不是一个确定性脚本。先探索，呈现你找到的东西，与用户确认，然后再写入。

## Process

### 1. Explore

查看当前仓库，理解它的起始状态。读取任何已经存在的东西；不要假设：

- `git remote -v` 和 `.git/config` — 这是一个 GitHub 仓库吗？是哪一个？
- 仓库根目录的 `AGENTS.md` 和 `CLAUDE.md` — 二者是否存在？其中是否已经有 `## Agent skills` 小节？
- 仓库根目录的 `CONTEXT.md` 和 `CONTEXT-MAP.md`
- `docs/adr/` 以及任何 `src/*/docs/adr/` 目录
- `docs/agents/` — 这个 skill 此前的输出是否已经存在？
- `.scratch/` — 表明已经在使用 local-markdown issue tracker 约定的迹象
- `triage` skill 是否已安装？（与本 skill 并列的一个 `triage` skill 文件夹，或你可用 skills 中有 `triage`。）这决定了 Section B 到底会不会运行。
- Monorepo 信号 — 一个 `pnpm-workspace.yaml`、`package.json` 中的一个 `workspaces` 字段，或一个已填充内容、自带 `src/` 的 `packages/*`。只有在真正庞大的多包仓库中才会出现；它们缺席就意味着 single-context，而几乎所有仓库都是如此。

### 2. Present findings and ask

总结已有什么、缺什么。然后按顺序处理各个 section——一个 section，一个回答，再到下一个。

每个 section 都以推荐的答案打头，这样用户一个词就能接受。只有当选择确实会分叉时，才给一行解释；当探索已经敲定了答案时，整个 section 直接跳过（`triage` 未安装时的 Section B，没有 monorepo 时的 Section C）。

**Section A — Issue tracker.**

> 解释："issue tracker" 是本仓库的 issue 存放之处。像 `to-tickets`、`triage`、`to-spec` 和 `qa` 这样的 skill 会读写它——它们需要知道该调用 `gh issue create`、在 `.scratch/` 下写一个 markdown 文件，还是遵循你所描述的某套其他工作流。挑选你实际用来跟踪本仓库工作的那个地方。

默认姿态：这些 skill 是为 GitHub 设计的。如果某个 `git remote` 指向 GitHub，就提议用它。如果某个 `git remote` 指向 GitLab（`gitlab.com` 或自托管主机），就提议用 GitLab。否则（或如果用户有偏好），提供：

- **GitHub** — issue 存放在仓库的 GitHub Issues（使用 `gh` CLI）
- **GitLab** — issue 存放在仓库的 GitLab Issues（使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI）
- **Local markdown** — issue 作为文件存放在本仓库的 `.scratch/<feature>/` 之下（适合个人项目或没有 remote 的仓库）
- **Other**（Jira、Linear 等）— 请用户用一段话描述这套工作流；skill 会把它记录为自由格式的散文

把选择记录到 `docs/agents/issue-tracker.md`。GitHub 和 GitLab 模板带有一个 "PRs as a request surface" 标志，默认**关闭**——保持关闭，不要提起它；想把外部 PR 纳入 triage 队列的用户，之后可以自己在文件里翻开这个标志。

**Section B — Triage label vocabulary.** 如果 `triage` skill 未安装（探索已经告诉你了），就完全跳过这个 section——一个未安装的 skill 不需要 label。

如果它已安装，就只问一个问题：

> 你想保留默认的 triage label 吗？（推荐：**yes**）

默认值是五种规范角色，每个 label 字符串都等于其名称：`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`。回答 **yes** 时，原样写入。只有当用户说 no——通常是因为他们的 tracker 已经在使用其他名称（例如用 `bug:triage` 表示 `needs-triage`）——才收集这些覆盖项，好让 `triage` 套用现有 label，而不是创建重复的。

**Section C — Domain docs.** 默认采用 **single-context**——仓库根目录下一个 `CONTEXT.md` + `docs/adr/`。这适用于几乎所有仓库；直接写入，无需询问。

只有当探索发现了 monorepo 信号时，才提供 **multi-context**——一个根目录的 `CONTEXT-MAP.md` 指向各 context 的 `CONTEXT.md` 文件。然后确认他们想要哪种布局。

### 3. Confirm and edit

给用户展示一份草稿，包含：

- 要添加到 `CLAUDE.md` / `AGENTS.md` 中正在被编辑的那个文件里的 `## Agent skills` 块（选择规则见 step 4）
- `docs/agents/issue-tracker.md`、`docs/agents/domain.md` 以及 `docs/agents/triage-labels.md` 的内容（最后一个仅在 `triage` 已安装时才有）

让他们在写入之前进行编辑。

### 4. Write

**挑选要编辑的文件：**

- 如果 `CLAUDE.md` 存在，就编辑它。
- 否则如果 `AGENTS.md` 存在，就编辑它。
- 如果二者都不存在，就问用户要创建哪一个——不要替他们做选择。

当 `CLAUDE.md` 已经存在时，绝不创建 `AGENTS.md`（反之亦然）——始终编辑已经存在的那一个。

如果所选文件中已经存在一个 `## Agent skills` 块，就原地更新它的内容，而不是追加一个重复的。不要覆盖用户对周围 section 的编辑。

这个块：

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `docs/agents/domain.md`.
```

只有当 `triage` 已安装且 Section B 确实运行了，才包含 `### Triage labels` 子块并写入 `docs/agents/triage-labels.md`。当它没有运行时，两者都省略。

然后以本 skill 文件夹中的种子模板为起点，写入这些文档文件：

- [issue-tracker-github.md](./issue-tracker-github.md) — GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md) — local-markdown issue tracker
- [triage-labels.md](./triage-labels.md) — label 映射（仅当 `triage` 已安装时）
- [domain.md](./domain.md) — domain 文档 consumer 规则 + 布局

对于 "other" 类型的 issue tracker，根据用户的描述从头撰写 `docs/agents/issue-tracker.md`。

### 5. Done

告诉用户 setup 已完成，以及哪些 engineering skills 现在会从这些文件读取。提一句他们之后可以直接编辑 `docs/agents/*.md`——只有当他们想切换 issue tracker 或从头再来时，才有必要重新运行这个 skill。
