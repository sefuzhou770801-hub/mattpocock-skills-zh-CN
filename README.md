# Matt Pocock Agent Skills 中文版

## 为什么需要这个中文版？

- 更好适配中文大语言模型
- 方便中文母语开发者
- 方便接入中文开发流程

## 关于这个中文版

这是 [`mattpocock/skills`](https://github.com/mattpocock/skills) 的简体中文本地化版本。文档和技能说明已翻译；目录名、技能名、命令、代码块、路径和工具标识保持不变，以免破坏安装和运行行为。

中文版本不只是为了阅读方便。对中文母语用户来说，中文说明能减少概念转换成本；对以中文为主要交互语言或中文语料优化的模型来说，中文 prompt 和 skill instructions 也更容易贴合中文上下文，减少中英混杂带来的歧义。

本仓库按内容刷新方式同步上游，不同步上游 Git 历史或仓库管理状态。维护规则见 [`.skills/translate-skill/SKILL.md`](./.skills/translate-skill/SKILL.md)。

翻译策略是 **skill-guided content localization**：把上游 `mattpocock/skills` 当作英文内容来源，只翻译自然语言说明，保留目录名、skill name、frontmatter key、命令、代码块、路径、URL、package/tool/API identifiers 和行为关键 labels。用户可见的安装路径统一保持为 `vinvcn/mattpocock-skills-zh-CN`。

## 30 秒安装

```bash
npx skills@latest add vinvcn/mattpocock-skills-zh-CN
```

选择你想安装的 skills，以及要安装到哪些 coding agents。首次安装时请确保选择 [`/setup-matt-pocock-skills`](./skills/engineering/setup-matt-pocock-skills/SKILL.md)，然后在 agent 中运行它来完成 issue tracker、labels 和 docs 目录配置。

[![skills.sh](https://skills.sh/b/vinvcn/mattpocock-skills-zh-CN)](https://skills.sh/vinvcn/mattpocock-skills-zh-CN)

<p>
  <a href="https://www.aihero.dev/s/skills-newsletter">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skills-repo-dark_2x.png">
      <source media="(prefers-color-scheme: light)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png">
      <img alt="Skills" src="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png" width="369">
    </picture>
  </a>
</p>

## 原版 README 翻译

我每天用于真实工程工作的 agent skills，不是 vibe coding。

开发真实应用很难。GSD、BMAD、Spec-Kit 这类方法试图通过接管流程来帮你。但它们在接管流程的同时，也拿走了你的控制权，并让流程里的 bug 更难解决。

这些 skills 被设计得小、易改、可组合。它们适用于任何模型，背后是数十年的工程经验。尽管去 hack 它们，把它们变成你自己的东西。Enjoy。

如果你想跟进这些 skills 的更新，以及我后续创建的任何新 skill，可以加入我 newsletter 上大约 60,000 名其他开发者：

[订阅 Newsletter](https://www.aihero.dev/s/skills-newsletter)

### Quickstart（30 秒 setup）

1. 运行 skills.sh installer：

```bash
npx skills@latest add vinvcn/mattpocock-skills-zh-CN
```

2. 选择你想要的 skills，以及你想把它们安装到哪些 coding agents 上。**确保选中 `/setup-matt-pocock-skills`**。

3. 在你的 agent 中运行 `/setup-matt-pocock-skills`。它会：
   - 询问你想使用哪个 issue tracker（GitHub、Linear，或 local files）
   - 询问你在 triage tickets 时套用哪些 labels（`/triage` 使用 labels）
   - 询问你想把我们创建的 docs 保存到哪里

4. Bam——你就准备好了。

### 作为 Claude Code plugin 安装

更想要一种无需手动维护的即插即用安装？这些 skills 也以原生 [Claude Code plugin](https://code.claude.com/docs/en/plugins) 的形式发布。与把可编辑文件复制进你的 repo 不同，plugin 会把整套 skill 安装为一个受管理的 bundle，在我发布新版本时更新——你是订阅，而不是 fork。

在 Claude Code 内部：

```
/plugin marketplace add vinvcn/mattpocock-skills-zh-CN
/plugin install mattpocock-skills@mattpocock
```

或从你的 shell：

```bash
claude plugin marketplace add vinvcn/mattpocock-skills-zh-CN
claude plugin install mattpocock-skills@mattpocock
```

然后像上面的 quickstart 一样，每个 repo 运行一次 `/setup-matt-pocock-skills`。

两种安装方式，两种理念：

- **[skills.sh](https://skills.sh/vinvcn/mattpocock-skills-zh-CN)** 把 skills 复制进你的项目，这样你就可以 hack 它们、把它们变成自己的。
- **plugin** 把它们保存为一个只读、始终最新的 bundle，你不编辑它——当你只想让我这套 skills 能用、并随着它演进跟进时，这是最佳选择。

> 使用 Codex 或其他 agent？[skills.sh installer](https://skills.sh/vinvcn/mattpocock-skills-zh-CN) 目前已经能把这些 skills 安装进 Codex 以及其他兼容 Agent Skills 标准的 harnesses。原生 Codex plugin 在 roadmap 上——见 [`.agents/adr/0002-ship-as-a-claude-code-plugin.md`](./.agents/adr/0002-ship-as-a-claude-code-plugin.md)。

### 为什么这些 Skills 存在

我构建这些 skills，是为了修复我在 Claude Code、Codex 和其他 coding agents 中看到的常见失败模式。

#### #1: Agent 没有做我想要的东西

> "No-one knows exactly what they want"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**问题**。软件开发中最常见的失败模式是 misalignment。你以为开发者明白了你想要什么。然后你看到他们做出来的东西——才意识到对方根本没理解你。

在 AI 时代完全一样。你和 agent 之间存在沟通缺口。对此的修复是一次 **grilling session**——让 agent 就你正在构建的东西向你提出细致的问题。

**解决方式**是使用：

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md) - 用于非代码场景
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) - 与 [`/grill-me`](./skills/productivity/grill-me/SKILL.md) 相同，但增加了更多好东西（见下文）

这些是我最受欢迎的 skills。它们帮助你在动手前与 agent 对齐，并深入思考你正在做的变更。**每次**你想做变更时都用上它们。

#### #2: Agent 太啰嗦

> With a ubiquitous language, conversations among developers and expressions of the code are all derived from the same domain model.
>
> Eric Evans, [Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**问题**：在一个项目开始时，开发者和他们要为之构建软件的人（domain experts）通常说着不同的语言。

我在我的 agents 身上也感受到了同样的张力。Agents 通常被丢进一个项目，被要求边进行边搞清楚行话。于是它们用 20 个词去说本来 1 个词就够的东西。

**解决方式**是 shared language。它是一份帮助 agents 解码项目中所用行话的文档。

<details>
<summary>
示例
</summary>

这是一个 [`CONTEXT.md`](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md) 示例，来自我的 `course-video-manager` repo。哪一个更容易读？

- **BEFORE**: "There's a problem when a lesson inside a section of a course is made 'real' (i.e. given a spot in the file system)"
- **AFTER**: "There's a problem with the materialization cascade"

这种简洁会一次又一次 session 地持续回报。

</details>

这已经内置在 [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) 中。它是一场 grilling session，但同时帮助你与 AI 建立 shared language，并把难以解释的决策记录进 ADR。

很难说清这有多强大。它可能是这个 repo 里最酷的一项技术。试一下，你就明白了。

> [!TIP]
> shared language 除了减少啰嗦，还有许多其他好处：
>
> - **变量、函数和文件的命名更一致**，因为使用了 shared language
> - 结果是，**codebase 对 agent 来说更容易导航**
> - agent 还会 **在思考上花更少的 tokens**，因为它能使用一种更简洁的语言

#### #3: 代码跑不起来

> "Always take small, deliberate steps. The rate of feedback is your speed limit. Never take on a task that’s too big."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**问题**：假设你和 agent 已经在要构建什么上达成一致。如果 agent _仍然_ 产出一堆垃圾，会怎样？

是时候看看你的 feedback loops 了。如果没有关于它所产出的代码实际运行情况的反馈，agent 就是在盲飞。

**解决方式**：你需要那一组常规的 feedback loops：static types、browser access，以及 automated tests。

对 automated tests 来说，red-green-refactor 循环至关重要。这就是 agent 先写一个失败测试，再修复测试的过程。这有助于给 agent 一个稳定水平的反馈，从而产出好得多的代码。

我构建了一个 **[`/tdd`](./skills/engineering/tdd/SKILL.md) skill**，你可以把它塞进任何项目。它鼓励 red-green-refactor，并就什么造就了好测试和坏测试给 agent 大量指导。

对于调试，我还构建了一个 **[`/diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md)** skill，把最佳调试实践包装进一个简单的循环。

#### #4: 我们造出了一个 Ball Of Mud

> "Invest in the design of the system _every day_."
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "The best modules are deep. They allow a lot of functionality to be accessed through a simple interface."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**问题**：大多数用 agents 构建的应用都复杂且难以更改。因为 agents 能极大地加速编码，它们也会加速软件熵增。Codebase 以前所未有的速度变得越来越复杂。

**解决方式**是一种激进的 AI-powered development 新办法：在乎代码的设计。

这被内置进这些 skills 的每一层：

- [`/to-spec`](./skills/engineering/to-spec/SKILL.md) 在创建 spec 之前，会追问你将要触碰哪些 modules

而至关重要的是，[`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) 帮助你拯救一个已经变成 ball of mud 的 codebase。我建议每隔几天就在你的 codebase 上运行一次。

#### 小结

软件工程基本功比以往任何时候都更重要。这些 skills 是我把这些基本功浓缩为可重复实践的最大努力，为的是帮助你交付你职业生涯中最好的应用。Enjoy。

### 参考

这些 skills 沿着一个维度划分——谁能调用它们。**User-invoked** skills 只有在你输入它们时才可触达（例如 `/grill-me`）；它们的工作是编排。**Model-invoked** skills 可以由你调用，_也可以_在任务契合时被 agent 自动取用；它们承载可复用的纪律。一个 user-invoked skill 可以调用 model-invoked skills，但绝不能调用另一个 user-invoked skill。

#### Engineering

我每天用于代码工作的 skills。

**User-invoked**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)** — 询问哪个 skill 或 flow 适合你的情境。本仓库 user-invoked skills 之上的一个 router。
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)** — Grilling session，同时构建你项目的 domain model，打磨术语，并内联更新 `CONTEXT.md` 和 ADR。
- **[triage](./skills/engineering/triage/SKILL.md)** — 让 issues 穿过一个 triage roles 状态机。
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** — 扫描一个 codebase 寻找 deepening opportunities，把它们呈现为一份可视化 HTML report，然后就你挑选的那一个进行 grilling。
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)** — 为 engineering skills 配置这个 repo（issue tracker、triage labels、domain doc 布局）。在使用其他 engineering skills 之前，每个 repo 运行一次。
- **[to-spec](./skills/engineering/to-spec/SKILL.md)** — 把当前对话变成一份 spec 并发布到 issue tracker。没有访谈——只是综合你已经讨论过的内容。
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)** — 把任何 plan、spec 或 conversation 拆成一组 tracer-bullet tickets，每个都声明它的 blocking edges——在 local file 中写成文本，或在真实 tracker 上写成 native blocking links。
- **[implement](./skills/engineering/implement/SKILL.md)** — 构建一份 spec 或一组 tickets 所描述的工作，在预先约定的 seams 处驱动 `/tdd`，并在提交前以 `/code-review` 收尾。
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)** — 把一大块工作——多到单个 agent session 装不下——规划成 issue tracker 上一张共享的 investigation tickets map，一次解决一个，直到通往 destination 的路变得清晰。

**Model-invoked**

- **[prototype](./skills/engineering/prototype/SKILL.md)** — 构建一个 throwaway prototype 来回答一个设计问题——针对 state/logic 问题的可运行 terminal app，或几个截然不同、可从单个 route 切换的 UI 变体。
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)** — 针对棘手 bug 和性能回退的纪律化诊断循环：reproduce → minimise → hypothesise → instrument → fix → regression-test。
- **[research](./skills/engineering/research/SKILL.md)** — 对照 high-trust primary sources 调查一个问题，并把 findings 作为一份带引用的 Markdown 文件捕获进 repo，作为 background agent 运行。
- **[tdd](./skills/engineering/tdd/SKILL.md)** — 带 red-green-refactor 循环的 Test-driven development。一次一个 vertical slice 地构建功能或修复 bug。
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)** — 主动构建并打磨一个项目的 domain model——对照 glossary 挑战术语，用 edge-case scenarios 做压力测试，并内联更新 `CONTEXT.md` 和 ADR。
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)** — 设计 deep modules 的共享纪律和词汇：大量 behaviour 藏在一个小 interface 之后，放置在一个干净的 seam 上，可通过那个 interface 测试。
- **[code-review](./skills/engineering/code-review/SKILL.md)** — 对自某个 fixed point 以来的 diff 做双轴 review：**Standards**（是否遵循 repo 的编码标准，外加一个 Fowler smell baseline？）与 **Spec**（是否忠实地实现了源头的 issue/PRD？），作为并行 sub-agents 运行，使两者互不污染。
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)** — 逐个 hunk 地处理一个进行中的 git merge 或 rebase conflict，按追溯到各方 primary source 的 intent 来解决，然后完成这个操作——绝不 `--abort`。

#### Productivity

通用工作流工具，不针对代码。

**User-invoked**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)** — 就一个 plan 或 design 被无情地访谈，直到 decision tree 的每一个分支都被解决。
- **[handoff](./skills/productivity/handoff/SKILL.md)** — 把当前对话压缩成一份 handoff document，让另一个 agent 可以继续这项工作。
- **[teach](./skills/productivity/teach/SKILL.md)** — 跨越多个 sessions 教用户一项新 skill 或概念，使用当前目录作为一个 stateful teaching workspace。
- **[writing-great-skills](./skills/productivity/writing-great-skills/SKILL.md)** — 写好和编辑好 skills 的参考：让一个 skill 可预测的词汇与原则。

**Model-invoked**

- **[grilling](./skills/productivity/grilling/SKILL.md)** — 就一个 plan、decision 或 idea 无情地访谈用户，直到 decision tree 的每一个分支都被解决。`grill-me` 和 `grill-with-docs` 背后的可复用循环。

#### Misc

保留但很少使用、不推广的工具。

**Model-invoked**

- **[git-guardrails-claude-code](./skills/misc/git-guardrails-claude-code/SKILL.md)** — 设置 Claude Code hooks，在危险 git 命令（push、reset --hard、clean 等）执行前阻止它们。
- **[migrate-to-shoehorn](./skills/misc/migrate-to-shoehorn/SKILL.md)** — 将测试文件中的 `as` 类型断言迁移到 @total-typescript/shoehorn。
- **[scaffold-exercises](./skills/misc/scaffold-exercises/SKILL.md)** — 创建包含 sections、problems、solutions 和 explainers 的练习目录结构。
- **[setup-pre-commit](./skills/misc/setup-pre-commit/SKILL.md)** — 设置 Husky pre-commit hooks，集成 lint-staged、Prettier、type checking 和 tests。
