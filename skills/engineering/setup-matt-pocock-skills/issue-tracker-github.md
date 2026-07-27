# Issue tracker: GitHub

本 repo 的 issue 和 PRD 以 GitHub issue 的形式存在。所有操作都使用 `gh` CLI。

## Conventions

- **创建 issue**：`gh issue create --title "..." --body "..."`。多行 body 使用 heredoc。
- **读取 issue**：`gh issue view <number> --comments`，用 `jq` 过滤评论，同时获取 label。
- **列出 issue**：`gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`，配合适当的 `--label` 和 `--state` 过滤器。
- **评论 issue**：`gh issue comment <number> --body "..."`
- **添加 / 移除 label**：`gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **关闭**：`gh issue close <number> --comment "..."`

从 `git remote -v` 推断 repo —— 在 clone 内部运行时 `gh` 会自动完成这件事。

## Pull requests as a triage surface

**PR 作为请求入口：no。** _（如果本 repo 把外部 PR 当作功能请求，则设为 `yes`；`/triage` 会读取这个标志。）_

设为 `yes` 时，PR 走与 issue 相同的 label 和状态，使用 `gh pr` 的等价命令：

- **读取 PR**：`gh pr view <number> --comments`，以及 `gh pr diff <number>` 查看 diff。
- **列出待 triage 的外部 PR**：`gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`，然后只保留 `authorAssociation` 为 `CONTRIBUTOR`、`FIRST_TIME_CONTRIBUTOR` 或 `NONE` 的（排除 `OWNER`/`MEMBER`/`COLLABORATOR`）。
- **评论 / 打 label / 关闭**：`gh pr comment`、`gh pr edit --add-label`/`--remove-label`、`gh pr close`。

GitHub 的 issue 和 PR 共用一个编号空间，所以光秃秃的 `#42` 可能是其中任何一种 —— 先用 `gh pr view 42` 解析，失败则回退到 `gh issue view 42`。

## When a skill says "publish to the issue tracker"

创建一个 GitHub issue。

## When a skill says "fetch the relevant ticket"

运行 `gh issue view <number> --comments`。

## Wayfinding operations

供 `/wayfinder` 使用。**map** 是单个 issue，以**子** issue 作为 ticket。

- **Map**：单个带 `wayfinder:map` label 的 issue，承载 Notes / Decisions-so-far / Fog 正文。`gh issue create --label wayfinder:map`。
- **子 ticket**：作为 GitHub sub-issue 链接到 map 的 issue（通过 sub-issues 端点使用 `gh api`）。在未启用 sub-issue 的地方，把子项加入 map 正文中的任务列表，并在子项正文顶部写上 `Part of #<map>`。Label：`wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）。一旦被认领，该 ticket 就被指派给驱动的开发者。
- **阻塞**：GitHub 的**原生 issue 依赖** —— 规范的、UI 可见的表示方式。用 `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>` 添加一条边，其中 `<blocker-db-id>` 是阻塞者的数字**数据库 id**（`gh api repos/<owner>/<repo>/issues/<n> --jq .id`，_不是_ `#number` 也不是 `node_id`）。GitHub 会报告 `issue_dependencies_summary.blocked_by`（仅未关闭的阻塞者 —— 即实时门槛）。在依赖不可用的地方，回退到子项正文顶部的 `Blocked by: #<n>, #<n>` 行。当所有阻塞者都关闭时，ticket 即为解除阻塞。
- **前沿查询**：列出 map 的未关闭子项（`gh issue list --state open`，限定在 map 的 sub-issue / 任务列表范围内），排除任何带有未关闭阻塞者的（`issue_dependencies_summary.blocked_by > 0`，或 `Blocked by` 行中有未关闭的 issue）或已有负责人的；按 map 顺序第一个胜出。
- **认领**：`gh issue edit <n> --add-assignee @me` —— 本 session 的第一次写入。
- **解决**：`gh issue comment <n> --body "<answer>"`，然后 `gh issue close <n>`，再往 map 的 Decisions-so-far 追加一条上下文指针（gist + 链接）。
