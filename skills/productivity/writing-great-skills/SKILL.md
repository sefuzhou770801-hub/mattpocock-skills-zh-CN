---
name: writing-great-skills
description: 编写和编辑优秀 skills 的参考——让一个 skill 变得可预测的那套词汇与原则。
disable-model-invocation: true
---

一个 skill 的存在，是为了从一个随机系统中驯服出 determinism。**Predictability**——agent 每次运行都走同一条 _process_，而不是产出相同的 output——是根本的美德；下面每一个杠杆都服务于它。

**粗体术语** 在 [`GLOSSARY.md`](GLOSSARY.md) 中定义；需要完整含义时到那里查阅。

## Invocation

两种选择，各自付出不同的代价：

- 一个 **model-invoked** 的 skill 保留 **description**，这样 agent 就能自主触发它，_并且_ 其他 skills 也能触达它（你仍然可以手动输入它的名字）。它会带来 **context load**——description 每一轮都待在 context window 里。机制：省略 `disable-model-invocation`，并写一段面向模型的 description，配上丰富的触发措辞（“Use when the user wants…, mentions…”）。
- 一个 **user-invoked** 的 skill 把 description 从 agent 的触达范围中剥除：只有你，通过输入它的名字，才能调用它——而且任何其他 skill 都不能。零 context load，但它要花费 **cognitive load**：_你_ 就是那个必须记得它存在的索引。机制：设置 `disable-model-invocation: true`；`description` 变成面向人类的一行摘要，触发列表被剥除。

只有当 agent 必须能自行触达这个 skill，或者另一个 skill 必须触达它时，才选择 model-invocation。如果它永远只会被手动触发，就把它做成 user-invoked，不付任何 context load。

当 user-invoked 的 skills 多到你记不住时，这份堆积起来的 cognitive load 可以由一个 **router skill** 来治愈：一个 user-invoked 的 skill，点名其余的那些，并说明何时该去用哪一个。

## Writing the description

一段 model-invoked 的 **description** 要做两件事——说明这个 skill 是什么，并列出应当触发它的各个 **branch**。每一个词都会增加 **context load**，所以 description 比正文更需要狠狠地修剪：

- **把 skill 的 leading word 前置**——description 是它完成 invocation 工作的地方。
- **每个 branch 一个触发。** 只是给同一个 branch 换个名字的同义词就是 **duplication**——“build features using TDD … asks for test-first development” 就是把同一个 branch 写了两次。把它们合并；只保留真正不同的 branch。
- **删掉正文里已经有的身份信息。** 让 description 只留下触发，外加任何 “when another skill needs…” 之类的触达子句。

## Information hierarchy

一个 skill 由两类内容构成——**steps** 和 **reference**——它们可以自由混合：一个 skill 可以全是 steps、全是 reference，或者两者兼有。核心的决策是用哪一类，以及每一块内容落在 **information hierarchy** 的哪一级——这是一架梯子，按 agent 需要这份材料的即时程度来排序：

1. **In-skill step**——`SKILL.md` 中的一个有序动作，是首要的一级：agent 按顺序做什么。每一个 step 都以一个 **completion criterion** 收尾，即告诉 agent 工作已经完成的那个条件。让它_可检查_（agent 能分辨出做完了还是没做完吗？），并且在要紧的地方让它_穷尽_（“every modified model accounted for”，而不是 “produce a change list”）——一个含糊的 criterion 会招来 **premature completion**。
2. **In-skill reference**——`SKILL.md` 中的一个定义、规则或事实，按需查阅。它往往是一个正当的扁平同级集合（一次 review 的所有规则都在同一级上）——这是一种好的安排，而不是坏味道。_本 skill 就全是 reference。_
3. **External reference**——被推出 `SKILL.md`、放进一个独立文件的 reference，通过一个 **context pointer** 触达，只有当 pointer 触发时才加载。（它横跨_已披露的_ reference——像 `GLOSSARY.md` 这样的同级文件，仍然是这个 skill 的一部分——一直到完全位于 skill 系统之外、任何 skill 都能指向的完全 **external reference**。）

一个要求严格的 completion criterion 会驱动彻底的 **legwork**——agent 在工作内部所做的挖掘——无论这个 skill 有没有 steps，因为 “every rule applied” 对扁平 reference 的约束，正如 “every step done” 对一个序列的约束。

往下推得太少，顶层就会臃肿；推得太多，又会把 agent 实际需要的材料藏起来。这种张力就是整个决策所在。

**Progressive disclosure** 就是沿着梯子往下走的动作——移出 `SKILL.md`、进入一个被链接的文件——好让顶层保持清晰易读。机制：skill 文件夹里一个被链接的 `.md` 文件，按它所承载的内容命名（本 skill 就把它的完整定义披露到 `GLOSSARY.md`）。有些 skill 会以不止一种方式被使用，而每一种不同的方式都是一个 **branch**——不同的运行会穿过这个 skill 走不同的路径。Branching 是最干净的披露检验标准：把每个 branch 都需要的东西内联，把只有部分 branch 才会触达的东西推到 pointer 后面。一个 **context pointer** 的_措辞_，而不是它的目标，决定了 agent 何时、以及多可靠地触达那份材料。

如果说梯子决定一块内容_往下放多远_，那么 **co-location** 决定一旦到了那里_什么与它并排_：把一个概念的定义、规则和注意事项放在同一个标题下，而不是散落各处，这样读到其中一部分时，它的邻居也就随之而来了。

## When to split

**Granularity** 是你切分 skills 的精细程度，而每一次切分都会花费两种 load 中的一种，所以只有当这一刀值得时才切。有两种切法：

- **按 invocation 切**——当你有一个独立的 **leading word** 应当自行触发它，或者另一个 skill 必须触达它时，就拆出一个 **model-invoked** 的 skill。你要为那个新的、始终加载的 **description** 付出 **context load**，所以那份独立的触达能力必须值得。
- **按 sequence 切**——当前方仍有的 steps（一个 step 的 **post-completion steps**）会诱使 agent 急着草草了结它前面那一步（**premature completion**）时，就把一连串 **steps** 拆开。把它们藏到视线之外，会鼓励 agent 在当前任务上做更多 **legwork**。

## Pruning

让每一个含义都有一个 **single source of truth**：一个权威的位置，这样改变行为就只是一处的编辑。

逐行检查 **relevance**：它是否仍然与这个 skill 所做的事相关？

然后逐句搜寻 **no-ops**，而不只是逐行：对每一个句子单独跑 no-op 检验，当某一句不合格时，删掉整句，而不是从里面修剪几个词。要狠——大多数不合格的散文应当被删除，而不是被改写。

## Leading words

一个 **leading word** 是一个已经活在模型预训练里的紧凑概念，agent 在运行这个 skill 时会用它来思考（例如 _lesson_、_fog of war_、_tracer bullets_）。它在整篇文本中反复出现（但也不一定——一个强的 leading word 可能只需要出现一次），累积出一个分布式的定义，并通过征召模型已经持有的先验，用最少的 token 锚定整片行为。

它为 predictability 服务两次。在正文里，它锚定_执行_：每当这个词出现，agent 就去够同一种行为。在 description 里，它锚定_调用_：当同一个词活在你的 prompts、docs 和代码里时，agent 会把那份共享的语言与这个 skill 关联起来，更可靠地触发它。

寻找机会把 skills 重构为使用 leading words。一个在三个地方被拼写出来的三元组（**duplication**），一段花一句话去比划一个想法的 description——每一处都是一段恳求着**坍缩**成单个 token 的文字。例子包括：

- “fast, deterministic, low-overhead” -> _tight_——同一个品质在一个阶段里被反复陈述——收进一个预训练过的词（一个 _tight_ loop）。
- “a loop you believe in” -> _red_——把一个模糊的门槛转换成一个二元的、可观察的状态（这个 loop 在那个 bug 上变 _red_，或者不变）。

你一举两得：更少的 token，_以及_ 一个更锋利的钩子，让 agent 把它的思考挂上去。假定每一个 skill 都背负着可以被 leading words 退役的反复陈述——去把它们找出来。

## Failure modes

用这些来诊断用户在使用这个 skill 时可能遇到的问题。

- **Premature completion**——在一个 step 真正完成之前就结束它，注意力滑向了_完成这件事_。防御手段，按顺序来：先磨利 completion criterion（便宜、局部）；只有当它本质上就是模糊的，_并且_ 你观察到了那种急躁，才通过拆分来隐藏 post-completion steps（sequence 切法）。
- **Duplication**——同一个含义出现在不止一个地方。它耗费维护和 token，并把一个含义在梯子上的显眼程度抬升到超过它真实的等级。
- **Sediment**——因为添加感觉安全、删除感觉有风险而沉积下来的陈旧层。这是任何一个没有 pruning 纪律的 skill 的默认命运。
- **Sprawl**——一个 skill 单纯就是太长了，哪怕每一行都是活的且独一无二。它损害可读性和可维护性，并浪费 token。解药是梯子：把 **reference** 披露到 pointers 后面，并按 **branch** 或 sequence 拆分，让每条路径只携带它所需要的。
- **No-op**——一行模型默认就已经遵守的指令，于是你付了 load 却什么也没说。检验标准：与默认相比，它是否改变了行为？一个弱的 leading word（_be thorough_，而 agent 本来就已经大致 thorough）就是一个 no-op；修法是换一个更强的词（_relentless_），而不是换一种技巧。
- **Negation**——用禁止来引导会适得其反：_don't think of an elephant_ 点名了大象，让它更容易浮现，而不是更难。去提示**正面**——把目标行为说出来，让被禁止的那个行为从不被提及；只有当你无法用正面措辞表达时，才保留一条禁止作为硬性护栏，即便如此也要配上该怎么做。
