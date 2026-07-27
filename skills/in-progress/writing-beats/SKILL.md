---
name: writing-beats
description: Writing, exploit —— 把原始素材组装成一段由 beats 构成的旅程，在某个 beat 依赖一个术语之前先把它 grounding。
disable-model-invocation: true
---

<what-to-do>

用户已经传入（或将要传入）一份原始素材的 markdown 文件。这是 **exploit**：探索已经结束，素材堆已经固定 —— 选定一条穿过它的路径，然后开采这堆素材去填充每一个 beat。

如果用户没有说文章存到哪里，问一次，并记住这个路径。

然后以 choose-your-own-adventure 的风格，跑一段逐个 beat 推进的旅程：

1. **Establish the prerequisites.** 在写任何 beat 之前，先和用户敲定：受众进场时已经知道什么 —— 哪些概念从一开始就是 **grounded** 的。其余一切概念都必须先由某个 beat 把它 grounding，后面的 beat 才能使用它。见 [Grounding](#grounding)。
2. 从原始素材中写出 2–3 个候选的 **starting beats**。每一个都是进入文章的一个不同入口。每一个都只能依赖已 grounded 的概念；记下每一个新 grounding 了哪些概念。在写入文章文件之前，先把这些 beats 展示给用户。用户挑一个。预告这个选择会解锁哪些 beats —— 就好像让用户沿路径往前看到一小段。
3. 一旦用户选定了一个 starting beat，就**只把那一个 beat** 写入文章文件。一个 beat 可以是一句话，也可以是好几段 —— 这个 beat 自然该多大就多大。到此为止。
4. 从磁盘重新读一遍文章文件。然后给出 2–3 个候选的 **next beats** —— 从文章此刻所在的位置出发，旅程可以转向的不同方向。每一个都必须能从当前已 grounded 的集合到达；记下每一个 grounding 了什么。
5. 循环第 3–5 步，直到文章自然收尾。

</what-to-do>

<supporting-info>

## Grounding

每一个 **concept** 都必须先被 **grounded**，某个 beat 才能依赖它：受众要么进场时就懂，要么在更早的某个 beat 里遇到过它。一个伸手去够尚未 grounded 的概念的 beat 会丢掉读者 —— 这是这段旅程唯一不能走的棋。这里的单位是 concept，而不是表达它的词：哪怕眼前一个术语都没有，一个 beat 也可能依赖一个读者并不具备的想法。当一个概念有名字 —— 一个 **term** —— 时，把它 grounding 意味着让这个想法和这个术语一起落地。

一个概念通过两种方式之一被 grounded：

- **Prerequisite** —— 在第一个 beat 之前就已 grounded。受众自带它。一开始就固定。
- **Introduced** —— 由某个 beat 确立，从那时起，它对之后每一个 beat 都是 grounded 的。

所以每个 beat 都做两件事：它**需要**已经 grounded 的概念，同时它 **grounds** 新的概念。维护一份到目前为止已 grounded 内容的清单，并在每个 beat 落地时更新它。

正是这一点塑造了这场 choose-your-own-adventure。一个候选 beat 只有在它所要求的一切都已被 grounded 时才是可达的；挑中一个 grounding 了概念 X 的 beat，就会解锁所有正在等 X 的 beats。当你给出 next beats 时，它们必须全都从当前已 grounded 的集合可达 —— 并说出每一个 grounding 了什么，好让用户看到它打开了哪些路径。

最大的杠杆在于：你把什么设为 prerequisite，又把什么在文章内部 grounding。开头要求太多，就会把不具备这些的读者挡在门外；内部 grounding 太多，前面的 beats 就会淹没在定义里。在你确立 prerequisites 时和用户把这件事敲定，并且每当某个诱人的 beat 结果要求一个尚无任何东西 grounding 过的概念时，就重新审视它 —— 修法要么是在它之前放一个 grounding beat，要么是把这个概念提升为 prerequisite。

## What is a beat

一个 beat 是旅程中的一步棋。它只做一件事 —— 布一个场景、落下一个观点、抛一个问题、插一句题外话、扭一下角度。然后停下，把读者留在一个下一个 beat 可以转向的地方。

一个 beat 的大小由它所需要的东西决定：

- 如果这一步棋就是一句话，那就一句话（"And then nothing happened for three weeks."）。
- 如果这一步需要铺垫，那就一个短段落。
- 如果这个 beat 是一个自成一体的 vignette、论证或例子，那就多个段落。

如果一个 "beat" 需要五段加三个小标题，那它就不是一个 beat —— 它是两个 beat 被粘在了一起。拆开它。

## Pulling from the pile

从原始素材堆里抽取材料来填充每一个 beat。你可以改写、拆分、重新组合，或直接引用。这堆素材是一座采石场。

## Ending the journey

文章在旅程完成时结束 —— 而不是在素材堆见底时。大多数素材堆都会剩下一些进不来的边角料。这没关系；原始素材多于所需，正是意义所在。

## Writing rhythm

- 一次追加一个 beat。永远不要抢跑。
- 每次写入之前，都从磁盘重新读一遍文章文件。绝对保留用户的编辑。
- 如果用户大幅改动了之前的某个 beat，就让它去改变接下来的走向。
- 如果用户说 "rewrite that beat" 或 "go back and try a different beat 3"，就照做 —— 就地编辑，其余的别动。

</supporting-info>
