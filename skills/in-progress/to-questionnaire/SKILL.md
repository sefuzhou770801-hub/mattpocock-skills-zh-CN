---
name: to-questionnaire
description: 把一个你无法完整回答的 decision 变成一份 questionnaire，交给别人去填写。
disable-model-invocation: true
---

把用户无法独自回答的事情变成一份 **questionnaire** —— 一份 Markdown 文档，他们可以交给某个人异步填写，或者在一场会议里一起填完。接收者掌握着用户所缺的知识；questionnaire 负责把这些知识从他们那里引出来。

**Grill the send, not the subject.** 只围绕 _send_ 访谈用户，这是他们总能回答的：交给谁，以及需要从对方那里拿回什么。文档里的那些问题，则瞄准接收者所知与用户所需之间的 **gap**。

1. **Who is it going to?** 在一轮交流里，问清接收者的角色、专长，以及与用户的关系。这决定了 questionnaire 的语气，以及它必须承载多少 context。当你知道接收者是谁、以及他们知道哪些用户不知道的东西时，这一步就完成了。

2. **What do you need back?** 在一轮交流里，问清用户无法独自敲定、需要此人提供的具体 decisions 或事实。当你拿到一份具体清单，清楚用户离开时必须能够去做或决策什么时，这一步就完成了。

3. **Write the questionnaire.** 针对第 1–2 步中的 gap 起草问题，遵循下面的 Document structure。把它写到当前目录的 `to-questionnaire-<slug>.md`（slug 取自主题），并报告路径。当文件存在、且用户在第 2 步中点名的每一项都有一个问题覆盖时，这一步就完成了。

## Document structure

把这份文档定位成一份 **discovery questionnaire**：用户缺少 context，接收者掌握着它。把问题按最重要的排在最前面来排序 —— 异步意味着你可能只有一次机会 —— 一旦问题超过寥寥几条，就按主题归到 `##` 标题下。用下面的模板来写。

<questionnaire-template>

# <Questionnaire title>

**Purpose:** 这份 questionnaire 为何存在，以及系于其上的那个 decision。

**From:** <the user> — **To:** <the recipient> — **How your answers will be used:** <它们会去往何处>

## Context

用一段话为一位并不在用户脑中的接收者定向。足以让对方好好作答即可，不要写成一整页。

## How to answer

截止日期和大致需要花的功夫。部分作答和"我不知道"都是有用的 —— 有任何不确定的地方都请标注出来，而不是跳过它。

## <Theme heading>

每个主题一个 `##` section。每个主题之下放它的问题，最重要的排在最前面。每个问题只承载一个想法 —— 绝不复合 —— 正下方直接跟一个作答留白，并且只在问题可能被误读或可能招来敷衍作答时，才加一行 _why this matters_。

<question-example>
### What load is the system expected to handle at launch?

_Why this matters: it decides whether we provision for burst traffic now or defer it._

>
</question-example>

## Anything else?

一个收尾的兜底项：有哪些我们没问、但应该知道的事情？

</questionnaire-template>
