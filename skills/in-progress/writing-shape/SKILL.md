---
name: writing-shape
description: Writing, exploit —— 把原始素材塑造成一篇文章，一段一段地推进。
disable-model-invocation: true
---

<what-to-do>

用户已经传入（或将要传入）一份原始素材的 markdown 文件。把它当作输入素材堆 —— 它可以是一份整齐的 fragments 清单，可以是一堵不成结构的散文墙，也可以是一份对话记录。格式无所谓。在做任何别的事之前，先从头到尾读一遍。

然后跑一场 shaping session，产出一份独立的文章文档。这是 **exploit**：探索已经结束，素材堆已经固定 —— 选定一个结构，然后开采这堆素材去填充它。不要编辑原始素材文件 —— 对这个 skill 而言它是只读的。

如果用户没有说文章存到哪里，问一次，并记住这个路径。

</what-to-do>

<supporting-info>

## The loop

1. **Read the pile.** 把输入文件完整地读一遍。对它里面有什么形成一个整体感觉。
2. **Establish the prerequisites.** 和用户敲定：读者进场时知道什么 —— 哪些概念从一开始就是 **grounded** 的。其余一切概念都必须先由某个 block 把它 grounding，后面的 block 才能依赖它。见 [Grounding](#grounding)。
3. **Draft 2–3 candidate openings.** 每一个 opening 都应该暗含文章的一个不同 thesis 或角度。把它们全都展示出来。逼用户挑一个，或者拼一个混合体。被选中的那个 opening 定义了文章其余部分必须做到什么。
4. **Grow paragraph by paragraph.** 在 opening 落地之后，问一句"given this opening, what does the reader need to hear next?"。从素材堆里抽取材料来作答。下一个 block 只能依赖已 grounded 的概念，并在落地时 grounding 新的概念。就下一个 block 采取什么形式展开争论 —— 一个段落、一个列表、一张表格、一个 callout、一段引用，还是一个代码块。每一次格式选择都应该是刻意的、站得住脚的。
5. **Append to the article file as you go.** 不要攒着批量写。每一个敲定的段落或 block 都立刻写进去，好让用户看着文章成形。
6. **Loop step 4 until the article is done.** 什么时候算完，由用户决定。

## Grounding

每一个 **concept** 都必须先被 **grounded**，某个 block 才能依赖它：读者要么进场时就懂，要么在更早的某个 block 里遇到过它。一个触及尚未 grounded 的概念的 block 会丢掉读者。这里的单位是 concept，而不是表达它的词 —— 哪怕眼前一个术语都没有，一个 block 也可能依赖一个读者并不具备的想法。当一个概念有名字 —— 一个 **term** —— 时，把它 grounding 意味着让这个想法和这个术语一起落地。

一个概念通过两种方式之一被 grounded：

- **Prerequisite** —— 在 opening 之前就已 grounded。读者自带它。一开始就固定。
- **Introduced** —— 由某个 block 确立，从那时起，它对文章余下的部分都是 grounded 的。

维护一份到目前为止已 grounded 内容的清单。当你问"what does the reader need to hear next?"时，下一步所需要的某个尚未 grounded 的概念本身就是答案：先把它 grounding —— 在这里，或在更早的某个 block 里 —— 否则你就走不了这一步。这是 [Pulling from the pile](#pulling-from-the-pile) 里那种点名缺口，往上抬了一层：那里是素材堆缺材料；这里是文章缺地基。

杠杆在于：你把什么设为 prerequisite，又把什么在文章内部 grounding。开头要求太多，就会把读者挡在门外；内部 grounding 太多，opening 就会淹没在定义里。在你确立 prerequisites 时和用户把这件事敲定。

## Conversational feel

这是一场倒过来的 grilling session。在构思阶段，问题是"what are you actually noticing?"；在这里，问题是"what is this article actually arguing, and in what order does the reader need to hear it?"。要顶回去。不要让软绵绵的过渡蒙混过关。如果一个段落没有挣到自己的位置，就删掉它。

要持续使用的具体招数：

- "What does this paragraph do for the reader that the previous one didn't?"
- "If I cut this, what breaks?"
- "Is this prose, or should it be a list? Why prose?"
- "This sentence is doing two jobs — split it or pick one."
- "The opening promised X. We've drifted to Y. Either re-thread it or change the opening."

## Pulling from the pile

把原始素材当作采石场，而不是剧本。抽出一个 fragment，改造它以适应周围的段落，然后安放下去。一个 fragment 可以拆分到多个段落里，可以和另一个合并，也可以被改写。素材堆的职责是被开采；文章的职责是读起来像一个声音。

如果素材堆缺了文章所需要的东西，就把这个缺口明确点出来："We need an example here and the pile doesn't have one — give me one now or we cut this section."

## Format arguments to actually have

在选择如何呈现一个 block 时，和用户大声权衡这些取舍，而不是默默决定：

- **Prose vs. list.** 散文承载论证；列表承载并列的条目。如果这些条目并不是真正并列的，散文更好。如果它们是并列的，列表扫读起来更快。
- **Inline vs. callout.** 提示、警告和题外话放进 callouts（`> [!TIP]`、`> [!NOTE]`）—— 但只有当它们放在正文里真的会让主线脱轨时才这么做。否则就让它们留在正文里。
- **Table vs. repeated structure.** 如果同一种形状带着同样的字段重复出现 3 次以上，用表格。否则用带加粗引导的散文。
- **Quote vs. paraphrase.** 当原始措辞本身就是重点时，引用。当只有想法重要时，改写。
- **Code block vs. inline code.** 多行、可运行，或用于示意 → 代码块。单个 token 或标识符 → 行内。

## Writing rhythm

每当一个 block 敲定，就把它追加到文章文件里。每次写入之前都从磁盘重新读一遍文件 —— 用户可能在两轮之间编辑过。永远不要盲目覆盖。如果用户想重写某个段落，就就地编辑那个特定的段落；其余的别动。

## Out of scope

- 开采素材堆里没有的新 fragments（按 "Pulling from the pile" 里的方式处理缺口）。
- 编辑原始素材文件。
- 发布、为某个特定平台排版，或添加用户没有要求的 frontmatter。

</supporting-info>
