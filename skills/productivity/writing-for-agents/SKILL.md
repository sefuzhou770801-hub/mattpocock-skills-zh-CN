---
name: writing-for-agents
description: 为 agent 撰写文档。在创建或编辑 skills，或修改 AGENTS.md / CLAUDE.md 时使用。
---

撰写任何 agent 会消费的文档的参考——skill、`AGENTS.md` / `CLAUDE.md`、经 pointer 触达的 doc。包装不同，写法相同：同一组杠杆让每一次都可预测——agent 每次走相同的 _process_，而不是产出相同的 output。

当你写的文档是 skill 时，读 [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md)，看 frontmatter、invocation 选择与 router skills。

## Context pointers

**Context pointer** 是 agent context 中持有的引用：它命名某段 context 外材料，并编码何时去取它。Skill 的 description 是一种；`AGENTS.md` 里点名某 doc 的一行是同一种对象。决定 agent 何时、以及多可靠地触达材料的，是 pointer 的 _措辞_，不是它的目标。必须拿到的目标若藏在措辞软弱的 pointer 后面，是 variance bug：先 sharpen 措辞；sharpen 失败再把材料内联。

Pointer 做两件事——说明材料是什么，并列出应触发触达的 **branches**（branch 是文档处理的不同情形，所以不同 runs 会走不同路径）。始终加载的 pointer 上每个词每轮都有成本，所以它比正文更该被修剪：

- **Front-load the leading word** — pointer 是它做触发工作的地方。
- **One trigger per branch.** 只是重命名同一 branch 的同义词，等于同一 branch 写了两次；合并它们，只保留真正不同的 branches。
- **Cut identity the body already carries.**

## The two loads

你加的每一份文档和 pointer 都花掉两种预算之一：

- **Context load** — 始终加载材料对 agent window 的成本：一行 `AGENTS.md`、skill description、任何每轮都坐在 context 里的东西，无论是否触发都在花 tokens 和注意力。
- **Cognitive load** — 对人类的成本：有哪些文档、何时取用。人类是 index。这不是要最小化的成本——它是 human agency 的代价；花在人类判断真的重要的地方，不需要的地方就去掉。

只经 pointer 触达的材料逃脱 context load，代价是 pointer 自己那一行；完全没有 pointer 的材料则全部骑在 cognitive load 上。

## Information hierarchy

文档由两类内容构成——**steps**（agent 按序执行的动作）与 **reference**（按需查阅的定义、规则、事实）——它们自由混合：全是 steps（菜谱）、全是 reference（review 的规则、本 skill），或两者都有。核心决策是每块内容落在 **information hierarchy** 的哪一层——按 agent 需要材料的即时程度排序的 ladder：

1. **In-file step** — 主层：agent 按顺序做什么。
2. **In-file reference** — 按需查阅。常常是合法的 flat peer-set（一个 review 的每条规则在同一 rung）——合理安排，不是坏味道。
3. **Disclosed reference** — 推到独立文件，经 context pointer 触达，只在 pointer 触发时加载。覆盖从同文件夹 sibling 文件，到任何位置、任何文档都能指向的 fully external reference。

下放太少，顶层膨胀；下放太多，藏起 agent 实际需要的材料。这种张力就是整个决策。

**Progressive disclosure** 是沿 ladder 下移——移出主文件、藏到 pointer 后面——让顶层保持可读。它首先不是 token 优化：它是保护 hierarchy 的方式。Branching 是最干净的 disclosure 测试：内联每个 branch 都需要的，把只有部分 branches 触达的推到 pointer 后。当文档有 steps 时，本应 disclosed 的 in-file reference 会把 steps 埋住，是否留意变成抛硬币——这是 variance 杠杆，不只是可读性杠杆。

**Co-location** 是文件内的配套：ladder 决定一块内容 _下移多远_，co-location 决定到了那里 _什么在它旁边_。把一个概念的定义、规则和 caveats 放在同一 heading 下，而不是散落，这样读一部分时邻居随之而来。测试：文档应读起来像为 agent 写的 documentation——成组的材料如此，散落的材料则否。（与 duplication 不同：那是同一含义出现在两处；scattering 是同一含义碎成多处。）

**Sprawl** 是这里的失败模式：文档单纯太长，即使每一行都 live 且 unique。注意力在过量中变薄，多出的每一行都是又一件要保持相关的事。疗法是 ladder：把 reference disclose 到 pointers 后，按 branch 或 sequence 拆分，让每条路径只带它需要的。

## Steps and completion criteria

每个 step 以 **completion criterion** 结束——告诉 agent 工作完成的条件。两个属性让它成为杠杆：

- **Clarity** — agent 能分辨 done 与 not-done 吗？模糊边界（“understanding reached”）会诱发 **premature completion**：step 尚未真正完成就结束，注意力滑向 _being done_。仍可见的后续 steps——**post-completion steps**——提供拉力；criterion 的清晰度是阻力。防御顺序：先 **sharpen the bound**（局部且便宜）；只有当它不可约地模糊 _且_ 你观察到 rush 时，才通过拆分 sequence 隐藏后续 steps——而隐藏只在真实 context boundary 上有效（hand-off 或 subagent dispatch；inline 调用把后续 steps 留在 context 里，什么也清不掉）。
- **Demand** — 它要求多少。“Every modified model accounted for” 逼出彻底工作，而 “produce a change list” 不会。Demand 驱动 **legwork**——agent 在工作中做的挖掘，潜伏在措辞里，而不是写成独立 step——且它不绑定 step：“every rule applied” 约束一整片 flat reference，正如 “every step done” 约束 sequence，于是全是 reference 的文档仍可带着 exhaustiveness 门槛。

最强的 criteria 既可检查，又 exhaustive。

## When to split

把一份文档拆成两份会花掉两种 load 之一，所以只有切分有收益时才切：

- **By sequence** — 拆开一串 steps，其中 post-completion steps 会诱使 agent 急着做完当前这一步。把它们挡在视野外，会驱动当前任务上更多 legwork。警惕反向：合并 sequences 会把每一步的后续 steps 暴露给后面的内容，诱发 premature completion。
- **By invocation** — skill 专属：见 [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md)。

## Leading words

**Leading word** 是模型预训练里已有的紧凑概念，agent 在跑文档时用它思考（_lesson_、_fog of war_、_tracer bullets_）。作为 token 反复出现，从不作为句子展开，它累积 distributed definition，并通过招募模型已持有的 priors，用最少 tokens 锚定一整片 behavior。自造词在定义清晰时也行，但编造词招募不到 priors——你在 definition tokens 上付的，正是 pretrained 词免费给的；先找已有词。

它锚定两次。在正文里，_execution_：词每次出现，agent 都触达同类行为；在 flat reference 里，它把注意力聚焦到要寻找的一类东西。在 pointer 里，_invocation_：同一词出现在你的 prompts、docs 和 codebase 中时，agent 把那份 shared language 连到材料，更可靠地触达它。

寻找用 leading words 重构的机会。三处展开的 triad、花一句话指向一个 idea 的 pointer——每一段都在恳求收成单个 token：

- "fast, deterministic, low-overhead" → _tight_（一个 _tight_ loop）。
- "a loop you believe in" → _red_——模糊 gate 变成二元可观察状态（loop 在 bug 上变 _red_，或者不变）。

你赢两次：更少 tokens，以及更尖锐的 hook 让 agent 挂起思考。假设每份文档都带着 leading words 可以退役的重复陈述——去找它们。

**Negation** 是这根杠杆旁边的失败模式：用禁止来引导，会把被禁止的行为拖进 context，让它 _更_ 可得，而不是更少。_Don't think of an elephant_，elephant 就占满一切；否定是弱修饰，被强激活的概念压过，所以禁令半读成“去做那件事”的指令。Prompt **positive**——陈述目标行为（“write one-line comments”），让被禁的从不被说出。只有无法正向表述的 hard guardrail 才配 prohibition；即便如此，也要配上正向目标，让注意力落在该做什么上。

## Pruning

- 让每个 meaning 都有 **single source of truth**：一个权威位置，改变 behavior 就是一处编辑。**Duplication**——同一 meaning 出现在多处——抬高维护与 tokens，并把该 meaning 在 ladder 上的 prominence 抬到超过真实等级。（这是 leading word 的意外反面：leading word 故意重复 token，从不重复 meaning。）
- **Environment** 也是 source of truth——`package.json` scripts、config files、directory layout、`--help` 输出——复述它的文档是 **cache**：lookup 的副本，只有 lookup 昂贵时才值得付 load。Cache agent 靠看找不到的东西：未写明的 convention、选择背后的原因、config 不会坦白的 gotcha。把单文件、单命令的 lookup 留给 environment，那里不会过期。
- 逐行检查 **relevance**：它是否仍支撑文档在做什么？一行失去 relevance，要么是从未压在任务上（纯 exposition，或本应 disclosed 的 branch），要么是它描述的 behavior 或世界变了而它变 stale。更短的文档更容易保持 relevant。没有 pruning discipline 时，默认命运是 **sediment**：因为添加看起来安全、删除看起来有风险而沉积的 stale layers，直到你必须向下挖才能找到仍 live 的东西。
- 逐句猎 **no-ops**：模型默认就会服从的指令，付 load 却什么也没说。测试——它是否相对默认改变了 behavior？——是 model-relative，不是 reader-relative：两人对 no-op 有分歧，分歧的是默认，要用跑文档来解决，不是靠辩论。句子失败时删整句，不要只修剪词。测试也给 leading words 打分：弱到打不过默认的词（agent 已经大致 thorough 时的 _be thorough_）是 no-op，修法是更强的词（_relentless_），不是换 technique。
