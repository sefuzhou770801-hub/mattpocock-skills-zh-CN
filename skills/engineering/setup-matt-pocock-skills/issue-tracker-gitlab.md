# Issue tracker: GitLab

本 repo 的 issue 和 PRD 以 GitLab issue 的形式存在。所有操作都使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI。

## Conventions

- **创建 issue**：`glab issue create --title "..." --description "..."`。多行 description 使用 heredoc。传入 `--description -` 可打开编辑器。
- **读取 issue**：`glab issue view <number> --comments`。使用 `-F json` 获取机器可读的输出。
- **列出 issue**：`glab issue list -F json`，配合适当的 `--label` 过滤器。
- **评论 issue**：`glab issue note <number> --message "..."`。GitLab 把评论称为 "note"。
- **添加 / 移除 label**：`glab issue update <number> --label "..."` / `--unlabel "..."`。多个 label 可以用逗号分隔，也可以重复该 flag。
- **关闭**：`glab issue close <number>`。`glab issue close` 不接受关闭评论，所以先用 `glab issue note <number> --message "..."` 发布说明，再关闭。
- **Merge request**：GitLab 把 PR 称为 "merge request"。使用 `glab mr create`、`glab mr view`、`glab mr note` 等 —— 形态与 `gh pr ...` 相同，只是用 `mr` 代替 `pr`，用 `note`/`--message` 代替 `comment`/`--body`。

从 `git remote -v` 推断 repo —— 在 clone 内部运行时 `glab` 会自动完成这件事。

## Merge requests as a triage surface

**MR 作为请求入口：no。** _（如果本 repo 把外部 merge request 当作功能请求，则设为 `yes`；`/triage` 会读取这个标志。）_

设为 `yes` 时，MR 走与 issue 相同的 label 和状态，使用 `glab mr` 的等价命令：

- **读取 MR**：`glab mr view <number> --comments`，以及 `glab mr diff <number>` 查看 diff。
- **列出待 triage 的外部 MR**：`glab mr list -F json`，然后只保留作者不是项目成员/所有者的 MR（贡献者的 MR，而非维护者正在进行的工作）。
- **评论 / 打 label / 关闭**：`glab mr note`、`glab mr update --label`/`--unlabel`、`glab mr close`。

与 GitHub 不同，GitLab 对 issue 和 MR 分别编号，所以一旦知道维护者指的是哪个入口，`#42` 就没有歧义。

## When a skill says "publish to the issue tracker"

创建一个 GitLab issue。

## When a skill says "fetch the relevant ticket"

运行 `glab issue view <number> --comments`。

## Wayfinding operations

供 `/wayfinder` 使用。**map** 是单个 issue，以**子** issue 作为 ticket。

- **Map**：单个带 `wayfinder:map` label 的 issue，承载 Notes / Decisions-so-far / Fog 正文。`glab issue create --label wayfinder:map`。（在支持原生 epic 的 GitLab 档位上，也可以用 epic 来承载 map；带 label 的 issue 在所有地方都可用。）
- **子 ticket**：一个 issue，其 description 顶部带有 `Part of #<map>`，label 为 `wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）。一旦被认领，该 ticket 就被指派给驱动的开发者。
- **阻塞**：GitLab 的**原生阻塞链接** —— 规范的、UI 可见的表示方式。用 `/blocked_by #<n>` 快捷操作添加，以 note 的形式发布（`glab issue note <child> --message "/blocked_by #<blocker>"`）。原生阻塞链接是 Premium/Ultimate 功能；在免费档位（或不可用时）回退到 description 顶部的 `Blocked by: #<n>, #<n>` 行。当所有阻塞者都关闭时，ticket 即为解除阻塞。
- **前沿查询**：`glab issue list -F json`，限定在 map 的子项范围内，排除任何带有未关闭阻塞者的 —— 指向未关闭 issue 的原生 `blocked_by` 链接（`glab api projects/:id/issues/:iid/links`），或 `Blocked by` 行中未关闭的 issue —— 或已有负责人的；按 map 顺序第一个胜出。
- **认领**：`glab issue update <n> --assignee @me` —— 本 session 的第一次写入。
- **解决**：`glab issue note <n> --message "<answer>"`，然后 `glab issue close <n>`，再往 map 的 Decisions-so-far 追加一条上下文指针（gist + 链接）。
