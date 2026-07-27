# learning record 格式

Learning records 存放在 `./learning-records/` 中，使用顺序编号：`0001-slug.md`、`0002-slug.md`，依此类推。目录应当懒创建——只在写入第一条 record 时才创建。

它们是教学领域中对应于 ADR 的东西：记录非显而易见的教训、关键洞见，以及已声明的先前知识，这些将引导未来的 session。它们被用来计算 zone of proximal development。

## 模板

```md
# {Short title of what was learned or established}

{1-3 sentences: what was learned (or what prior knowledge was established), and why it matters for future sessions.}
```

这就是完整的格式。一条 learning record 可以只有一个段落。它的价值在于记录_这件事现在已经被知道了_，以及_它为什么改变了下一步该教什么_——而不在于把各个 section 填满。

## 可选小节

只有当这些 section 确实增添了价值时才包含它们。大多数 record 用不到。

- **Status** frontmatter（`active | superseded by LR-NNNN`）——当早期的理解后来被证明是错的并被取代时很有用。
- **Evidence**——用户是如何展现出这种理解的（回答了一个问题、完成了一个练习、引用了过往经验）。当这一论断日后可能被重新审视时很有用。
- **Implications**——这为未来的 session 解锁了什么或排除了什么。当影响并不显而易见时值得记录。

## 编号

扫描 `./learning-records/`，找到现有的最大编号并加一。

## 何时写一份 learning record

当以下任何一条为真时，写一条：

1. **用户展现了对某个非平凡内容的真正理解**——不只是接触过，而是有证据表明他们能正确使用这个概念。这为下一步该教什么设定了新的底线。
2. **用户披露了先前知识**——“I already know X.” 把它记录下来，这样未来的 session 就不会重复教授它。同时也要记录所声称的_深度_。
3. **一个误解被纠正了**——用户此前相信某个错误的东西，如今明白了原因所在。这类记录价值很高：它们能预测相关主题未来的绊脚石。
4. **Mission 因学习而发生了转移**——用户发现自己关心的东西与原先以为的不同。交叉链接到 [[MISSION.md]] 并更新它。

### 什么_不_算数

- 仅仅是被覆盖过的材料。覆盖不等于学习。等待证据。
- 任何已经作为术语定义被简洁地记录在 [[GLOSSARY.md]] 中的内容。不要重复。
- 逐 session 的活动日志。Learning records 不是日记——它们是决策级别的洞见。

## 取代

当一条较晚的 record 与较早的一条相矛盾时（用户的理解加深了或被纠正了），把旧的 record 标记为 `Status: superseded by LR-NNNN`，而不是删除它。理解如何演化的这段历史本身就是有用的信号。
