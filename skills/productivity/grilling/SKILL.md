---
name: grilling
description: 围绕计划、decision 或 idea 持续追问用户。适用于用户想对自己的思路做压力测试，或使用任何 “grill” 触发措辞时。
---

持续访谈用户，直到达成共同理解。把它画成 **design tree**：每个 decision 分叉出挂在它下面的 decisions。

按 **rounds** 处理这棵树。**Frontier** 是所有前置条件已经落定的 decisions——你 _现在_ 就能问、不必猜尚未听到答案的问题。一轮问完整个 frontier：给每个问题编号，并附上你的推荐答案。然后等用户回答，再进入下一轮。

每个问题格式如下：

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

用户每轮回答都会重塑树——已落定的 decisions 把 frontier 往外推，并解锁依赖它们的问题。重新计算 frontier，再问下一轮。答案还依赖本轮仍开放的另一问题的，属于 _更晚_ 的 round，不属于本轮。

找 _facts_ 是你的工作，永远不是用户的。当 frontier 问题需要 environment（filesystem、tools 等）里的 fact 时，派 sub-agent 去找——不要问用户任何你自己能查到的东西。不要阻塞：正在跑的探索是未落定的前置条件，所以只有它下游的问题等 sub-agent 回报——现在就问 frontier 的其余部分。_Decisions_ 属于用户——逐个交给他们，并等待。

Frontier 为空时 session 结束：design tree 的每个分支都走过，没有默默假定的东西。在用户确认已达成共同理解之前，不要采取行动。
