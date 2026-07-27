# Issue tracker: Local Markdown

本 repo 的 issue 和 spec（你可能把 spec 称为 PRD）以 markdown 文件的形式存放在 `.scratch/` 中。

## Conventions

- 每个功能一个目录：`.scratch/<feature-slug>/`
- spec 是 `.scratch/<feature-slug>/spec.md`
- 实现类 issue 每个 ticket 一个文件，位于 `.scratch/<feature-slug>/issues/<NN>-<slug>.md`，从 `01` 开始编号 —— 绝不要做成单个合并的 ticket 文件
- triage 状态记录为每个 issue 文件顶部附近的 `Status:` 行（角色字符串见 `triage-labels.md`）
- 评论和对话历史追加到文件底部 `## Comments` 标题之下

## When a skill says "publish to the issue tracker"

在 `.scratch/<feature-slug>/` 下创建一个新文件（必要时创建目录）。

## When a skill says "fetch the relevant ticket"

读取所引用路径处的文件。用户通常会直接给出路径或 issue 编号。

## Wayfinding operations

供 `/wayfinder` 使用。**map** 是一个文件，每个 ticket 对应一个**子**文件。

- **Map**：`.scratch/<effort>/map.md` —— Notes / Decisions-so-far / Fog 正文。
- **子 ticket**：`.scratch/<effort>/issues/NN-<slug>.md`，从 `01` 开始编号，正文中是问题。`Type:` 行记录 ticket 类型（`research`/`prototype`/`grilling`/`task`）；`Status:` 行记录 `claimed`/`resolved`。
- **阻塞**：顶部附近的 `Blocked by: NN, NN` 行。当它列出的每个文件都是 `resolved` 时，ticket 即为解除阻塞。
- **前沿**：扫描 `.scratch/<effort>/issues/` 中处于开放、未阻塞、未认领状态的文件；按编号第一个胜出。
- **认领**：在任何工作开始之前设置 `Status: claimed` 并保存。
- **解决**：把答案追加到 `## Answer` 标题之下，设置 `Status: resolved`，然后往 `map.md` 中 map 的 Decisions-so-far 追加一条上下文指针（gist + 链接）。
