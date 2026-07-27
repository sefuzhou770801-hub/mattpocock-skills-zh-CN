---
name: writing-fragments
description: Writing, explore —— 开采原始 fragments，此刻还不谈结构。
disable-model-invocation: true
---

<what-to-do>

这是纯粹的 **explore**：在不承诺任何结构的前提下，拓宽"可以写什么"的空间 —— 承诺结构是 _exploit_，那是另一个 skill 的活儿。跑一场产出 fragments 的 grilling session，就用户想写的任何东西不留情面地访谈他们。在这里强加阶段、大纲或文章结构都不在范围之内。

当 fragments 从对话的双方浮现出来时，把它们追加到同一个 markdown 文件里。

如果用户没有传入路径，问一次这份文档存到哪里，然后在 session 余下的时间里记住它。

从用户说的第一件事起就开始捕获 fragments，包括最初的那条 prompt。

第一次写入时，在顶部放一个单独的 H1，写上一个工作标题（之后可以改），别的什么都不要放 —— 不要 metadata，不要 TOC，不要日期。

</what-to-do>

<supporting-info>

## What is a fragment

一个 fragment 是任何有可能存活到最终文章里的文本。它必须_对作者可读_ —— 作者能看懂它是什么意思 —— 但它不需要定义自己的术语，也不需要让陌生读者也能理解。标准是"这是不是一段好文字？"，而不是"这是不是一个自成一体的论证？"。

Fragments 刻意是异质的。可能成为一个 fragment 的例子：

- 一句犀利的句子，你想在某个地方用上它，但还不知道用在哪里。
- 一个主张，外加一句论证。
- 一个 vignette：发生过的一件事、一段代码片段、一个场景、一个类比。
- 一个半成形的想法："something about how X feels like Y, work this out later."
- 一句引言、一段对白、一句偶然听到的话。
- 一串凭感觉聚在一起的相关观察。
- 一句牢骚、一段自白、一个包袱。
- 一个 **leading word** —— 一个紧凑的隐喻或新造词，整篇文章都可以挂在它上面（一个为这个想法命名的术语，就像 _tracer bullets_ 或 _fog of war_ 为整个模式命名那样）。

在这些当中，leading word 是最值得拿下的 fragment。它是承重的：在 explore 阶段命名对的那一个，它就会塑造之后的结构、过渡和标题 —— 在整个 exploit 阶段持续分红。当对话绕着一个反复出现的想法打转时，推动为它造一个词。

小说家的日记就是范本：多年不成结构的随手记，日后被开采成原始素材。Fragments 就是那些随手记。

## File format

```markdown
# Working title

A first fragment lives here.

It can be multiple paragraphs. It can include lists, code, quotes — whatever
shape the fragment naturally takes.

---

A second fragment.

---

> A quoted line that the user wants to keep around.

A reaction to it.

---

- A cluster of related observations
- That hang together by feel
- And want to be near each other
```

Fragments 之间用一条 horizontal rule（`\n---\n`）分隔。正文里不放标题。不打 tag。除了添加的先后顺序之外，没有任何排序。

## Writing rhythm

静默地追加。不要为每一个 fragment 请求许可。可以顺嘴提一句你加了什么（"adding that"），但不要用保存对话框去打断对话。

每次写入之前：从磁盘重新读一遍文件。用户可能在两轮之间编辑、重排或删除过 fragments —— 保留他们的改动。永远不要覆盖整个文件；只追加（或者，如果用户要求，就地编辑某个特定的 fragment）。

用户随时可以说 "cut the last one"、"rewrite that one sharper"、"merge those two"。把这些当作一等指令来对待。

</supporting-info>
