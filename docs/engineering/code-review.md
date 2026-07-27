Quickstart:

```bash
npx skills add vinvcn/mattpocock-skills-zh-CN --skill=code-review
```

```bash
npx skills update code-review
```

[Source](https://github.com/vinvcn/mattpocock-skills-zh-CN/tree/main/skills/engineering/code-review)

## What it does

`code-review` 审查 `HEAD` 与你提供的某个 fixed point（一个 commit、branch、tag 或 merge-base）之间的 diff，沿两条独立的轴线进行：**Standards**（代码是否遵循本仓库有文档记录的约定？）和 **Spec**（它是否实现了来源 issue 或 spec 所要求的东西？）。它把每条轴线作为各自独立的并行 sub-agent 来运行，并将它们并排报告。它从不把两组 findings 合并或重新排序——让它们保持分离正是全部意义所在，因为一个变更可能通过一条轴线却在另一条上失败，而一个混合的单一裁决会让其中一条掩盖另一条。

## When to reach for it

输入 `/code-review`，或者当你要求审查一个 branch、一个 PR、进行中的改动，或任何「since X」的内容时，agent 会自动取用它。

当你有一个 diff 需要对照一个 known-good point 来评判，并且想让两个问题——*构建得对吗？* 和 *是正确的东西吗？*——被独立回答时，就用它。它在 build loop 的末端运行；要真正以 test-first 的方式写代码，用 [tdd](https://aihero.dev/skills-tdd)，要把一整份 spec 构建成代码，用 [implement](https://aihero.dev/skills-implement)，它会在提交之前运行自己的一轮 `/code-review`。

## Prerequisites

**Spec** 轴线需要有地方找到来源 spec——commit messages 中的一个 issue reference、你传入的一个路径，或者 `docs/`/`specs/` 下的一份 spec。那条 issue-tracker 接线来自 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills)；没有 spec 时，Spec 轴线会直接跳过并说明这一点。**Standards** 轴线不需要任何配置——即便在一个没有记录任何约定的仓库里，它也始终自带一套内置的 Fowler smell baseline。

## 两条轴，永不合并

决定性的理念是**两条轴线**。**Standards** 问的是 diff 是否符合本仓库写代码的方式——它的 `CODING_STANDARDS.md` 或 `CONTRIBUTING.md`，外加一个固定的、约 12 个 Fowler code smells 的 baseline（Mysterious Name、Duplicated Code、Feature Envy、Data Clumps 等）。有两条规则让 baseline 保持安全：有文档记录的 repo standard 始终覆盖它，并且每一个 smell 都是一个需要判断的权衡，而绝不是一条硬性违规。**Spec** 问的是正交的问题——代码是否做了 issue 或 spec 真正要求的事，没有遗漏需求，也没有夹带 scope creep？

它们作为并行的 sub-agents 运行，这样谁也不会污染对方的上下文，最终报告把它们分别呈现在独立的 `## Standards` 和 `## Spec` 标题下，并各自带一个按轴线划分的总结。刻意不存在跨轴线的单一赢家。

## It's working if

- 它先固定并确认 fixed point（`git rev-parse`），在坏的 ref 或空 diff 上快速失败，而不是在 sub-agents 内部才发现。
- Standards 和 Spec 的 findings 分两个清晰的区块到达，各自引用其来源——一边是 repo standard 或 baseline smell，另一边是引用的 spec 行。
- 当找不到 spec 时，Spec 轴线报告 "no spec available"，而不是编造需求。

## Where it fits

`code-review` 是 main build chain 尾部的 review 步骤：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review
```

它最接近的邻居是 [implement](https://aihero.dev/skills-implement)，后者驱动构建并在提交前把它作为自己的一轮 review 来调用；往上游，它所核对的 spec 由 [to-spec](https://aihero.dev/skills-to-spec) 和 [to-tickets](https://aihero.dev/skills-to-tickets) 产出。当你不确定哪个 skill 或 flow 契合时，[ask-matt](https://aihero.dev/skills-ask-matt) 会为你路由。
