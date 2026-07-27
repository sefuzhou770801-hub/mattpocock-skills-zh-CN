Quickstart:

```bash
npx skills add vinvcn/mattpocock-skills-zh-CN --skill=improve-codebase-architecture
```

```bash
npx skills update improve-codebase-architecture
```

[Source](https://github.com/vinvcn/mattpocock-skills-zh-CN/tree/main/skills/engineering/improve-codebase-architecture)

## What it does

`improve-codebase-architecture` 会扫描一个 codebase，寻找 **deepening opportunities**——也就是那些 shallow module（其 interface 几乎和它所隐藏的东西一样复杂）本可以变成 deep module 的地方——并把它们呈现为一份自包含的可视化 HTML report，然后就你选中的那一个展开 grilling。

它**不会**丢给你一份扁平的 refactor 清单。每一个候选项都必须通过 **deletion test**——移除这个 module 会把复杂性*集中*到一个更小的 interface 背后，还是仅仅把它挪个地方？只有那些“能集中”的情况才配得到一张卡片。正是这道过滤，让 report 不至于沦为泛泛的清理建议。

除非你把它指向某个特定区域，否则它还会把自己限定在开发实际落点的地方——通过读取近期的 commits，偏向那些你仍在改动的代码。Deepening 一个 module 的回报在于让它未来的修改更容易，所以它会额外看重 repo 中最近发生过变化的部分。

## When to reach for it

你通过输入 `/improve-codebase-architecture` 来调用它——agent 不会自己主动去拿它。

把它当作一次定期的健康检查来用：每隔几天，或者每当一个 codebase 开始让你觉得要理解一个概念得在太多小 module 之间来回跳。它会读取现有的架构，并提出可以在哪里加深它。如果你已经知道自己想重新设计哪个 module，只是需要一套词汇来把它想清楚，那就改用 [codebase-design](https://aihero.dev/skills-codebase-design)——这个 skill 是找出候选项的勘察，而那一个才是设计工作台。

## Deepening opportunities

整个 skill 都围绕一个概念运转：**depth**。一个 deep module 把大量功能隐藏在一个小而稳定的 interface 背后；一个 shallow module 则会透过一个几乎和底下代码一样宽的 interface，把自己的实现泄漏出去。这份 report 搜寻的就是 shallowness——仅仅为了可测试性而抽出来的 pure function，真正的 bug 却藏在它们的调用方式里（缺乏 **locality**）；跨越自身 **seams** 泄漏的 module；不打开五个文件就理解不了的概念——并提出能够修复它的 deepening。

它用共享的设计词汇（**module**、**interface**、**depth**、**seam**、**adapter**、**leverage**、**locality**）以及你项目自己来自 `CONTEXT.md` 的 domain 语言来说话，因此一个候选项读起来会是“加深 Order intake module”，而绝不会是“refactor FooBarHandler”。

## The report, then the grill

输出是一个可直接在浏览器打开的 HTML 文件，写入你操作系统的临时目录——不会有任何东西落进 repo。每个候选项都是一张卡片，包含涉及的文件、摩擦点、一段平实的解决方案、以 locality 和 leverage 衡量的收益、一张 before/after 示意图，以及一个 `Strong` / `Worth exploring` / `Speculative` 徽章。它最后会给出自己最想先处理的那一个。

然后它会停下来，问你想探索哪一个。选定一个之后，它就会针对那个设计运行 [grilling](https://aihero.dev/skills-grilling) 循环——约束条件、seam 背后放着什么、哪些 tests 能存活下来——并在 decisions 逐渐成形时就地更新 domain model。

## Where it fits

`improve-codebase-architecture` 是**定期维护**——每隔几天跑一次，而不是作为链条中的一步。它的邻居是 [codebase-design](https://aihero.dev/skills-codebase-design)（每个候选项都是用它所拥有的 depth 与 seam 词汇写成的）、[grilling](https://aihero.dev/skills-grilling)（一旦你选定了一个候选项，就由它来走这棵 decision tree），以及 [domain-modeling](https://aihero.dev/skills-domain-modeling)（在重新设计落定的过程中，由它来保持 `CONTEXT.md` 和 ADRs 的时效性）。当你不确定哪个 skill 或 flow 合适时，[ask-matt](https://aihero.dev/skills-ask-matt) 会为你引路。
