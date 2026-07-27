Quickstart:

```bash
npx skills add vinvcn/mattpocock-skills-zh-CN --skill=implement
```

```bash
npx skills update implement
```

[Source](https://github.com/vinvcn/mattpocock-skills-zh-CN/tree/main/skills/engineering/implement)

## What it does

`implement` 把一份 spec 或一组 tickets 所描述的工作构建成代码——通过 test-driven development、typechecking 和完整测试套件来推进它，然后交接给 review 并提交到当前 branch。

它**不**决定要构建什么。spec 已经敲定，seams 也已经达成一致；`implement` 执行那个计划，而不是重新打开它。它是双手，不是大脑——思考在上游就已经发生了。

## When to reach for it

你通过输入 `/implement` 来调用它——agent 不会自行取用它。

当工作已经写成一份 spec 或拆成 tickets、并且你准备把它变成代码时，就使用它。如果 spec 还不存在，先写出来——为此用 [to-spec](https://aihero.dev/skills-to-spec)，或用 [to-tickets](https://aihero.dev/skills-to-tickets) 把一份 spec 拆成 tickets。如果你只想在没有完整 spec 的情况下以 test-first 的方式构建某个东西，直接落到 [tdd](https://aihero.dev/skills-tdd)。

## Pre-agreed seams

`implement` 赖以运行的那个概念是 **seam**——一个 feature 被测试其上的稳定 interface，在写任何代码之前就选定。它不在构建中途发明 seams；它使用已经选定的那些（在 [to-spec](https://aihero.dev/skills-to-spec) 期间选定的），并通过 [tdd](https://aihero.dev/skills-tdd) 针对它们写 tests。在预先达成一致的 seams 上工作，正是让实现保持诚实的原因：tests 瞄准的是持久的东西，因此底下的代码可以移动，而 tests 不必跟着移动。

围绕那个核心，它让 loop 保持紧凑——频繁 typecheck、边进行边运行单个 test 文件、最后把整套套件跑一遍——然后以一轮 review 和一次对当前 branch 的提交收尾。

## Where it fits

`implement` 是 main chain 末段、紧接在 review 之前的 build 步骤：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review
```

在工作已经写好 spec 并排好序之后使用它，而不是之前。它的关键邻居是 [to-tickets](https://aihero.dev/skills-to-tickets)——产出它所逐个处理的 tickets（每个 ticket 都声明自己的 blocking edges），以及 [tdd](https://aihero.dev/skills-tdd)——它在内部驱动 tdd 在每个 seam 上先写好 tests，然后再运行自己的一轮 [code-review](https://aihero.dev/skills-code-review) 并提交。当你不确定哪个 skill 或 flow 契合时，[ask-matt](https://aihero.dev/skills-ask-matt) 会为你路由。
