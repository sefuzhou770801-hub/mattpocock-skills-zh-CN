# Glossary — Building Great Skills

这是关于“什么让一个 skill 变得优秀”的 domain model。一个 skill 的存在，是为了从一个随机系统中驯服出 determinism；根本的美德是 **Predictability**，而下面每一个术语都是作用于它的一个杠杆。这是 [`writing-great-skills`](SKILL.md) 所披露的 reference。

这些术语按轴线分组：**Invocation**（一个 skill 如何被触达）、**Information Hierarchy**（它的内容如何排布）、**Steering**（agent 的运行时行为如何被塑造），以及 **Pruning**（它如何保持精瘦）。每一个 **failure mode** 都放在治愈它的那个杠杆旁边，并标注为 _failure mode_。

任何定义中的**粗体术语** 本身都在本 glossary 中定义；按它们的标题查找。

## Predictability

一个 skill 让 agent 在每次运行时都以同一种_方式_行动的程度——同样的 process，而不是同样的 output（一个头脑风暴 skill 应当_可预测地_发散；它的 token 会变，它的行为不会）。这是其他所有术语都为之服务的根本美德——cost 和 maintainability 是它的症状，而不是它的对手。

_Avoid_: consistency, reliability, robustness, output-determinism

## Invocation

一个 skill 如何被触达——以及你为这个选择所付出的两种 load。

### Model-Invoked

一个保留了 **description** 字段的 skill，这样 agent 就能看到它并自主触发它——而人类仍然可以输入它的名字，所以 model-invocation 总是_包含_用户的触达。不存在 model-only 的状态：一个 description 只会_增加_ agent 的发现能力，从不会移除人类的。它为这份可发现性付出永久的 **context load**，每一轮都付。它可以被其他 skills 触达，因为让它能被 agent 发现的那个 description 同时也让它可被调用。一个内容全是 **reference** 的 model-invoked skill 也是共享 reference 的一个归宿：另一个 skill 可以调用它，所以被多个 skills 需要的 reference 就可以放在一处。只有当 agent 必须能自行触达这个 skill 时，才选择 model-invocation；如果它除了手动触发外从不触发，就去掉 description，不付任何 context load。

_Avoid_: ability, tool, capability

### User-Invoked

一个被剥除了 **description** 的 skill——对 agent 不可见，只能由人类输入它的名字来触达（user-_only_，而 **model-invoked** 是 user-_and-agent_）。它用零 **context load** 换掉了 agent 的可发现性。因为它没有 description，除了人类以外没有任何东西能触达它：其他任何 skill 都不能触发它。

_Avoid_: procedure, workflow, command

### Description

一个 skill 的机器可读触发器，也是一个 **model-invoked** skill 被迫始终加载的唯一一个 **context pointer**。它单纯的存在本身_就是_ invocation 这条轴：保留它，这个 skill 就是 model-invoked（并且可被其他 skills 触达）；删掉它，这个 skill 就是 **user-invoked**，只能由人类触达。它是一个 model-invoked skill 的 **context load** 的来源。

_Avoid_: frontmatter, summary

### Context Pointer

保存在 agent context 中的一段 reference，它点名了某份 context 之外的材料，并编码了触达它的条件。**Description** 是顶层的 context pointer（context window → skill）；指向已披露文件的 pointers 是同一个对象往下一层。是它的措辞，而不是目标，决定了 agent _何时_ 触达——以及_多可靠_。一份必备的目标藏在一个措辞薄弱的 pointer 后面，就是一个 variance bug：先修措辞，只有当磨利失败时才把材料内联。

_Avoid_: link, reference, import

### Context Load

一个 **model-invoked** skill 对 agent 的 context window 施加的成本——它的 **description** 始终加载，既花 token 又花注意力。这是 **user-invoked** skills 因为没有 description 而逃脱的东西，也是阻止你拆出更多 model-invoked skills 的刹车。

_Avoid_: token cost, context bloat

### Cognitive Load

一个 **user-invoked** skill 对人类施加的成本——他们必须装在脑子里的东西：哪些 skills 存在，以及何时该去用哪一个（人类就是索引）。这是 **model-invocation** 通过可被 agent 发现而消除的东西，也是阻止你拆出更多 user-invoked skills 的刹车。它不是一个要被最小化的成本：它是人类自主性的代价，是一些 skills 保持 user-invoked 的原因。把它花在人类判断力要紧的地方；在不那么要紧的地方移除它。

_Avoid_: human index, burden, overhead

### Router Skill

一个 **user-invoked** 的 skill，它的职责是指向你其余的 user-invoked skills——点名每一个，并说明何时该去触达它——这样人类只需要记住一个 skill，而不是许多个。它只能提示，从不能触发它们：user-invoked 的 skills 没有 **description**，所以除了人类以外没有任何东西能触达它们。它是当 user-invoked skills 增多时，对 **cognitive load** 的解药。

_Avoid_: dispatcher, menu, registry, index, router procedure

### Granularity

你切分 skills 的精细程度。更细的切分会花费两种 load 中的一种：更多 **model-invoked** 的 skills 花费 **context load**（更多 descriptions 挤占 window、争夺注意力）；更多 **user-invoked** 的 skills 花费 **cognitive load**（更多要人类记住和触达的东西）。有两种切法指引着切分。按 **invocation** 切，当你有一个独立的 **leading word** 来触发它时——一个你真的会在 prompts 里使用的触发词——就拆出一个 model-invoked 的 skill。按 **sequence** 切，当一个 step 的 **post-completion steps** 需要被隐藏时，就拆开一连串 **steps**，因为把它隔离进它自己的 context 里，就清空了它后面的东西。当心反方向：合并序列会把每个 step 的 post-completion steps 暴露给它后面的东西，招来 premature completion。

_Avoid_: chunking, modularity

## Information Hierarchy

一个 skill 的内容如何排布，以及每一块内容在这架梯子上落在多深的位置。

### Information Hierarchy

一个 skill 的内容按 agent 需要它的即时程度排序——一架单一的梯子，由两种切法产生：在文件内还是在 pointer 后面，以及是 step 还是 reference。梯级：

- **Steps** — in-file, primary
- **Reference**, in-file — secondary
- **Reference**, disclosed — behind a **context pointer**

一个没有 **steps** 的 skill 只使用底下两级——往往是一个正当的扁平同级集合（例如一次 review 的所有规则都在同一级上），这是一种好的安排，而不是坏味道。这个 hierarchy 独立于 invocation：一个 skill 无论全是 steps、全是 reference，还是两者兼有，都可以是 model- 或 user-invoked。当一个 skill 有 steps 时，本应被披露的 in-file reference 会把它们埋没，让关注它们变成抛硬币——这是一个 variance 杠杆，而不只是一个可读性杠杆。让梯子的顶层保持清晰易读；把你能推下去的都推下去。

_Avoid_: structure, organization, layout

### Steps

Agent 所执行的有序动作——当一个 skill 有它们时，它们是其内容的首要一级，也是在 SKILL.md 中赢得一席之地的部分。不是每个 skill 都有 steps：一个 skill 可以全是 steps（`tdd`）、全是 **reference**（一次 review），或者两者兼有，独立于 invocation。每一个 step 都以一个 **completion criterion** 收尾，无论清晰还是含糊。

_Avoid_: workflow, instructions, choreography

### Reference

Agent 按需查阅的材料——定义、事实、参数、示例、条件性指令。当一个 skill 有 **steps** 时，它次于它们；当一个 skill 没有 steps 时，它就是全部内容；或者它完全活在任何 skill 之外——见 **External Reference**。它通过 **context pointers** 被触达，是 **progressive disclosure** 的头号候选。

_Avoid_: supporting material, docs, background

### External Reference

活在 skill 系统之外的 **Reference**——一个普通文件，没有 **description**，没有 **steps**，不可被调用——任何 skill 都能指向它。它是那些无需自行触发的共享 reference 的归宿，也是两个 **user-invoked** skills 能共用的唯一共享归宿，因为两者都没有 description，所以谁也不能触发对方。

_Avoid_: doc, resource, knowledge base

### Progressive Disclosure

把 **reference** 沿梯子往下移——移出 SKILL.md、放到一个 **context pointer** 后面——好让顶层保持清晰易读。它主要不是一种 token 优化；它是 **information hierarchy** 得以被保护的方式。它由 **branching** 授权：披露只有部分 branch 需要的东西，内联每条路径都需要的东西，而如果一个 pointer 在一份必备材料上触发不可靠，就磨利它的措辞，只有在那也失败时才把它拉回内联。

_Avoid_: lazy loading, chunking

### Co-location

把 agent 一次性需要的材料放在一处——一个概念的定义、规则和注意事项放在同一个标题下，而不是散落在整个文件里——这样读到其中一部分时，它的邻居也就随之而来了。它是 **Information Hierarchy** 在文件内部的伴侣：hierarchy 排列一块内容_往下落多远_；co-location 决定一旦到了那里_什么与它并排_。对于一组 **reference** 的正确格式没有什么公式；检验标准是，一个 skill 读起来应当像为 agent 写的文档，而分组好的材料读起来就是那样，散落的材料则不是。它有别于 **Duplication**：后者是在两个地方重复同一个含义，而散落是把单一的含义碎裂成许多片。

_Avoid_: grouping, clustering, cohesion

### Sprawl

_Failure mode._ 一个 skill 单纯就是太长了——SKILL.md 里行数太多——无论这些行是否陈旧或重复。哪怕一个全是活内容、全独一无二的 skill 也会 sprawl。它耗费可读性（agent 要跋涉过更多东西才能行动，注意力在过量的内容上被摊薄）、可维护性（每多一行，就多一行要保持 **relevant**），以及 token。解药是 **information hierarchy**：把 **reference** 推到 **context pointers** 后面，并按 **branch** 或 sequence 拆分，让每条路径只携带它所需要的。它有别于 **sediment**（来自陈旧堆积的长度）和 **duplication**（来自重复含义的长度）——sprawl 是长度本身，无论其成因。

_Avoid_: bloat, length, size, verbosity

## Steering

那些把 agent 的运行时行为塑造向 **Predictability** 的杠杆。

### Branch

一个 skill 可以被调用的一种独特方式——这个 skill 所处理的一种情形——于是不同的运行会穿过它走不同的路径。一个有许多 steps 的 skill 可能承载许多 branches；一个线性的 skill 则没有。

_Avoid_: path, case, fork

### Leading Word

一个紧凑的概念——也被称为 _Leitwort_——已经活在模型的预训练里，agent 在运行这个 skill 时会用它来思考。它通过征召模型已经持有的先验，用最少的 token 编码一条行为原则（例如 _lesson_、_proximal zone of development_、_fog of war_、_tracer bullets_）。它作为一个 token 被重复，而不是作为一个句子，在整个 skill 中累积出一个分布式的定义，并锚定整片行为。如果你把它定义清楚，自造一个也行，但一个生造的词征召不到任何先验——你用定义所花的 token，正是一个预训练过的词免费给你的东西。先去够一个已有的词。

一个 leading word 为 **predictability** 服务两次。在正文里，它锚定 **execution**——每当这个概念出现，agent 就去够同一种行为，而在扁平 reference 内部，它把注意力聚焦到要寻找的那一类东西上，每次运行都征召正确的检查。在 **description** 里，它锚定 **invocation**——而且不只是在这个 skill 内部：当同一个词活在你的 prompts、你的 docs 和你的代码库里时，agent 会把那份共享的语言与这个 skill 关联起来，更可靠地触发它。用你真的会在想要这个 skill 时使用的那些 leading words 来措辞一段 description。

_Avoid_: keyword, term, motif

### Completion Criterion

告诉 agent 一个工作单元已经完成的那个条件——它据以判断的目标。有两个属性让它成为一个杠杆，而不仅仅是一种品质。它的 **clarity**（agent 能分辨出做完了还是没做完吗？）抵御 **premature completion**——一个含糊的边界（“达成了理解”）会让 agent 宣布完成并滑向下一个 step；这条轴需要 _steps_ 才能起作用，因为 premature completion 是一种 step 之间的失败。它的 **demand**（它要求多少）设定 **legwork**——“every modified model accounted for” 会逼出彻底的工作，而 “produce a change list” 则不会——而这条轴_不_绑定于 step：它也能约束一组扁平 reference，这正是一个没有 steps 的 skill 仍然承载一条穷尽性标准（“every rule applied”）的方式。最强的 criteria 既 可检查又穷尽。

_Avoid_: done condition, exit condition, stopping rule

### Legwork

Agent 在单个 step 内部于幕后所做的工作——读文件、探索代码库、做修改、挖出它所需要的东西，而不是把活儿甩给用户。它活在 step 结构的下方：从不被写成它自己的 step，潜伏在措辞里，由 agent 而非 skill 控制。它是 **post-completion steps** 那种跨 step 拉力在 step 内部的对应物。它被一个 **leading word**（_comprehensive_、_thorough_）或一个要求工作穷尽的 **completion criterion** 抬高——包括施加于扁平 reference 的那条 demand 轴，正是它驱动一个扁平 reference 的 skill 去覆盖它所有的梯级。它要么在那种 demand 缺失时变薄，要么在 **premature completion** 把这个 step 截短时变薄。

_Avoid_: scope, effort, diligence, coverage

### Post-Completion Steps

跟在当前 step 后面的那些 **steps**。当它们可见时，会把 agent 向前拉进 **premature completion**——它看到的越多，拉力就越强；防御手段是把这串 steps 拆成两段，从而把它们隐藏起来。

_Avoid_: horizon, fog of war, lookahead

### Premature Completion

_Failure mode._ 在当前 step 真正完成之前就结束它，因为 agent 的注意力滑向了“完成”而非工作本身。这是一种 step 之间的失败：它需要 **steps** 才会发生——一个没有 steps 却提前退出的 skill 不是 premature completion，而是在一条未被满足的 demand 之下的单薄 **legwork**。这是两股力量之间的拔河：可见的 **post-completion steps**（向前的拉力）与 **completion criterion** 的 clarity（阻力——一条锋利、可检查的标准能守住；一条含糊的则会让步）。含糊是必要条件：一条锋利的边界无论后面有多少 steps 可见都能抵御拉力，所以一个从不急躁的 step 无需防御。有两个杠杆能守住一个确实急躁的 step，但要按顺序去够它们：**先磨利边界**——它是局部的、便宜的。只有当这个 criterion 本质上就是模糊的，_并且_ 你真的观察到了那种急躁，才去**隐藏后面的 steps**——而隐藏只有跨越一个真实的 context 边界时才起作用（一次 user-invoked 的交接，或一次 subagent 的派发；一次内联的 model-invoked 调用会把后面的 steps 留在 context 里，什么也没清空）。它是单薄 legwork 的一个成因，但有别于它：即便一个 step 运行到了完全完成，legwork 也可能单薄。

_Avoid_: premature closure, the rush, rushing, shortcutting

### Negation

_Failure mode._ 用禁止来引导——告诉 agent _不要_ 做什么——这会把被禁止的行为拖进 context，让它_更_容易浮现，而不是更难。_Don't think of an elephant_，于是满脑子都是大象；_never write verbose comments_，于是冗长恰恰成了 agent 刚刚读到的那个模式。这条否定是一个弱的修饰语，会被那个被强烈激活的概念压过，于是这条禁令读起来有一半像是在指示它去做那件事。它的 **leading word** 就是那头 _elephant_：一条禁止所点进画面里的任何东西。解药：提示**正面**——描述目标行为（“write one-line comments”），让被禁止的那个行为从不被提及。一条禁止只有作为一条你无法用正面措辞表达的行为的硬性护栏时，才配得一席之地；即便如此，也要配上正面的目标，让注意力落在该做什么上。

_Avoid_: ironic rebound, don't-prompting, the pink elephant

## Pruning

让一个 skill 保持精瘦——每一味解药都配上它所治愈的那个失败。

### Single Source of Truth

那种理想状态：每一个含义都恰好活在一个权威的位置，于是对 skill 行为的一次改动就是一处的改动。**Duplication** 是对它的违反。

_Avoid_: home, canonical location

### Duplication

_Failure mode._ 同一个含义被赋予了不止一个 **single source of truth**。它耗费维护（改一处，你就必须改其他几处）、耗费 token，并抬高显眼程度——重复一个含义会让它在梯子上的权重超过它真实的等级。它是 **leading word** 的意外的反面，后者通过重复一个 token（而从不重复含义）来刻意抬高注意力。

_Avoid_: repetition, redundancy

### Relevance

一行是否仍然与这个 skill 所做的事相关——这是决定保留什么的透镜。一行会失去 relevance，要么是因为它从不与任务相关（纯粹的阐述，或一个本应被披露的 **branch**），要么是因为它变陈旧了：随着它所描述的行为或世界发生变化而过时。更短的 skills 更容易保持 relevant，因为每一行检查起来都更便宜。它有别于 **no-op**：relevance 问的是一行是否与任务相关，而不是它是否改变行为。

_Avoid_: load-bearing, staleness, freshness

### Sediment

_Failure mode._ 沉积在一个 skill 里、从不清理的旧内容层，因为添加感觉安全、删除感觉有风险——于是陈旧且无关的行不断累积，你必须一路钻透它们才能找到仍然活着的东西。这是任何一个没有 pruning 纪律的 skill 的默认命运；是 **relevance** 的缓慢侵蚀，有别于 **duplication** 的重复含义。

_Avoid_: accretion, bloat, cruft, rot

### No-Op

_Failure mode._ 一条什么也没改变的指令，因为模型默认就已经这么做了——你付了 load，却是在告诉 agent 它本来就会做的事。检验标准：一行与默认相比是否改变了行为？一行可以完全 **relevant** 却仍然是一个 no-op。让一个 **leading word** 免费的那些先验，也让一个 no-op 毫无价值。

一个 leading word 是一种_技巧_；No-Op 是对一行的_裁决_——而它们会交叉。一个弱到打不过默认的 leading word 就是一个 no-op（_be thorough_，而 agent 本来就已经大致 thorough），修法是换一个能通过裁决的更强的词（_relentless_），而不是换一种技巧。所以 No-Op 检验——它与默认相比是否改变行为？——也是你评判一个 leading word 是否配得上它那些重复的方式。这是相对于模型的，而不是相对于读者的：两个人对一行是否是 no-op 有分歧，其实是在对默认是什么有分歧，靠运行这个 skill 来解决，而不是靠辩论。

_Avoid_: redundant instruction, restating the obvious, belaboring
