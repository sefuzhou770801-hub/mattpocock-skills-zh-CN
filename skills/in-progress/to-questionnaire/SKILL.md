---
name: to-questionnaire
description: 把你无法独自完整回答的决策，变成给别人填写的问卷。
disable-model-invocation: true
---

把用户无法独自回答的事变成一份 **questionnaire**——一份 Markdown 文档，交给某个人异步填写，或在会议里一起填。接收方掌握用户缺少的知识；问卷把这些知识从对方那里拉出来。

**Grill 的是 send，不是 subject。** 只访谈用户关于 _send_ 的部分——他们总答得上：发给谁、需要拿回什么。文档里的问题再对准 **gap**：接收方知道的、用户需要的。

1. **Who is it going to?** 在一轮交流中问清接收方的角色、专长，以及与用户的关系。这决定问卷语气，以及必须携带多少上下文。Done when：你知道接收方是谁，以及对方知道什么是用户不知道的。

2. **What do you need back?** 在一轮交流中问清用户无法独自解决、需要从对方拿到的具体 decisions 或 facts。Done when：你有一份具体清单，写明用户走后必须能做什么或决定什么。

3. **Write the questionnaire.** 按下面的 Document structure，起草对准第 1–2 步 gap 的问题。写到当前目录的 `to-questionnaire-<slug>.md`（slug 来自主题），并报告路径。Done when：文件存在，且用户在第 2 步点名的每一项都有对应问题覆盖。

## Document structure

把文档框成 **discovery questionnaire**：用户缺上下文，接收方持有它。问题按最重要优先排序——异步意味着你可能只有一轮——超过少量问题时，用 `##` 标题按主题分组。按下面的模板写。

<questionnaire-template>

# <Questionnaire title>

**Purpose:** 这份问卷为何存在，以及压在它上面的决策。

**From:** <the user> — **To:** <the recipient> — **How your answers will be used:** <where they go>

## Context

一段话，让不在用户脑子里的接收方能定向。够答好即可，不要一整页。

## How to answer

截止日期与大致工作量。部分回答和 “I don't know” 都有用——不确定就标出来，不要跳过。

## <Theme heading>

每个主题一个 `##` 小节。每个小节下是该主题的问题，最重要的在前。每个问题只问一个 idea——永远不要复合——正下方放 answer stub；仅当问题可能被误读或诱出敷衍回答时，再加一行 _why this matters_。

<question-example>
### What load is the system expected to handle at launch?

_Why this matters: it decides whether we provision for burst traffic now or defer it._

>
</question-example>

## Anything else?

收尾兜底：还有什么我们没问但应该知道的？

</questionnaire-template>
