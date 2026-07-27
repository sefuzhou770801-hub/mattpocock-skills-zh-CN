# Writing docs pages

`engineering/` 和 `productivity/` 中的每个 skill 都有一张面向人类的 **docs page**，位于 `docs/<bucket>/<skill-name>.md`——docs 树镜像了 `skills/` 下的那两个 bucket folder。它发布在 `https://aihero.dev/skills-<skill-name>`；无论 bucket 是什么，URL 始终是 `skills-<skill-name>`，所以 docs 路径只是仓库组织层面的事。这个页面不是 skill 本身，也不是 `SKILL.md` 的副本。只有这两个 bucket 是 promoted；其余的（`misc/`、`personal/`、`in-progress/`、`deprecated/`）不发布 docs page。

这些 skills 大多是 **user-invoked**：agent 永远不会替你触发它们，所以*你*就是那个必须记住它们存在、记住何时取用它们的索引。这种记忆就是 **cognitive load**。docs page 的职责就是缓解它——围绕一个 skill 为一位读者定位，使他们能在脑子里装下它，知道何时取用，并看到它在系统中的位置。这些页面合起来是一个分布式 router；每一张都是一个节点。

每当一个 promoted skill 被新增、重命名，或行为发生变化，就行动：创建或重新同步它的 docs page。重命名也会移动文件（`docs/<bucket>/<old>.md` → `docs/<bucket>/<new>.md`），因为发布的 URL 跟随名字；一个在 `engineering/` 和 `productivity/` 之间移动的 skill，会把它的 docs 文件移到匹配的 folder。`misc/`、`personal/`、`in-progress/` 和 `deprecated/` 中的 skills 没有页面——这些 bucket 没有一个是 promoted。一个*从*其中某个 bucket 移*进* `engineering/` 或 `productivity/` 的 skill 会获得一个页面；反向移动的会失去它。

因为这些页面发布在 `aihero.dev` 上，**每个 link 都是绝对的**——绝不用仓库相对路径。指向另一个 skill 的 link 指向 `https://aihero.dev/skills-<name>`；指向仓库内部的 link 指向它完整的 `https://github.com/mattpocock/skills/...` URL。一个在仓库里能用的相对 link，一旦发布就会失效。

没有 H1——发布的页面从 slug 获取标题。

## Page structure

填写下面的模板。**固定框架**（Quickstart 块、source link、`## What it does`、`## When to reach for it`、`## Where it fits`）出现在每一页上。**可适配的中段**——`## Prerequisites` 和自由形式的实质章节——只承载这个特定 skill 所挣得的内容；其余删掉。

<page-template>

Quickstart:

```bash
npx skills add vinvcn/mattpocock-skills-zh-CN --skill=<name>
```

```bash
npx skills update <name>
```

[Source](https://github.com/vinvcn/mattpocock-skills-zh-CN/tree/main/skills/<bucket>/<name>)

## What it does

一两段平实的语言。以这个 skill 的一句话职责开头，然后陈述 **defining constraint**——那一个使这个 skill 的行为不同于显而易见默认值的事实（对 `to-spec` 来说：它不再访谈用户，它综合已知的内容）。把它写成一个平实的陈述句——绝不是一个带标签的旁注，比如 "The defining constraint:" 或 "The key thing:"；那种公式读起来像填充物。这一行是页面上最有价值的；绝不要省略它。

## When to reach for it

你如何以及何时取用这个 skill——两个节拍，实际上总是都在：

- **Invocation mode。** 说明是你输入它，还是 agent 触发它。一个 user-invoked skill："You invoke this by typing `/<name>` — the agent won't reach for it on its own." 一个 model-invoked skill："Type `/<name>`, or the agent reaches for it automatically when a task fits."
- **Trigger boundary。** 索引条目："reach for this when …"。当这个 skill 容易和某个兄弟 skill 混淆时，加上另一半——"for <X> instead, use [<sibling>](https://aihero.dev/skills-<sibling>)."

## Prerequisites

可选——只有当这个 skill 需要某些东西就位才能运作时才包含；否则完全省略这个标题。涵盖：一个 **它写入的 workspace**（像 `grill-with-docs` 这样的 stateful skill 写 `CONTEXT.md` 和 ADR；`teach` 构建一整个目录——说明它写什么、写到哪里），**前置 setup**（`triage`/`to-spec`/`to-tickets` 需要 `setup-matt-pocock-skills` 已经配置好一个 issue tracker），或 **仓库特定的 tooling**。一个在任何地方都能运行的无状态 skill 没有 prerequisites——删掉这一节。

## <free-form middle>

一到三个短章节，用这个 skill *自己的*词汇，让它变得清晰——选择任何适合这个 skill 的标题：它运行的循环、它产出的 artifact、它做出的 fork、它消灭的那一个 anti-pattern。没有规定好的标题；这些 skills 太异质，无法统一。

唯一不可妥协的：**浮现这个 skill 的 leading word / defining idea**——`tight` feedback loop、`deep module`、throwaway-code-answers-a-question、red-green。它会双重回报：读者学到这个 skill *是什么*，并学到他们之后用来*取用*它的那个词。

## It's working if

可选。一个简短、可勾选的清单，列出那些告诉读者这个 skill 确实在履行职责的可观察信号——它触发时他们应该看到什么，以及它没触发时因缺失而暴露什么。当一个 skill 有清晰的征兆时包含它（例如 `to-spec` 不重新访谈你就写出来；一个 leading word 在 trace 中重现）；当信号含糊时省略这个标题。几条 bullet，不要更多。

## Where it fits

始终存在。用一两句话把这个 skill 放进系统里：

- **Role。** 指名它：一个 **chain step**（`grill-with-docs → to-spec → to-tickets → implement → code-review`），一个 **run-once setup**（`setup-matt-pocock-skills`），**周期性维护**（`improve-codebase-architecture`，"every few days"），或一个 **随时取用的 standalone**（`diagnosing-bugs`、`prototype`、`handoff`）。一个 standalone 的 map 是一句诚实的话——远好过省略这一节。
- **Neighbours。** 那一两个重要的兄弟 skill，每个带一个 because 从句，绝对链接。
- **The map。** 指向 [ask-matt](https://aihero.dev/skills-ask-matt)，整套 skills 之上的 router，使这个页面保持为一个节点，永远不必重画整张图。

</page-template>

## Conventions

- 解释 **why**，而不是过程。这个页面为 skill 定位并放置它；它绝不复述 `SKILL.md` 的步骤或模板转储——一个在选择工具的人不需要 runbook。
- 使用这个 skill 的 **leading words**（_seam_、_deep module_、_tracer bullet_），使页面和 skill 说同一种语言。
- 让页面本身保持低负载。它是*关于*低认知负载 skills 的文档；家具（多余的标题、重述的 links）正是它所反对的东西。

## Done when

- 页面存在于 `docs/<bucket>/<name>.md`，并且没有过时的页面在重命名或 bucket 移动后残留。
- Quickstart 块和 source link 指名正确的 bucket 和 skill；update 行指名这个 skill。
- `## What it does` 陈述 defining constraint，作为平实散文而非带标签的旁注。
- `## When to reach for it` 陈述 invocation mode 和 trigger boundary。
- `## Where it fits` 指名 role 并链接到 `ask-matt`。
- 在存在 prerequisite（workspace、前置 setup、tooling）的地方陈述它，在不存在的地方省略这一节。
- 中段浮现 leading word。
- 每个 link 都是绝对的，并且每一个都能解析。
