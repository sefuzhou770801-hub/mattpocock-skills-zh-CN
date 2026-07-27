---
name: teach
description: 在这个 workspace 中教用户一项新 skill 或一个新概念。
disable-model-invocation: true
argument-hint: "你想学什么？"
---

用户要求你教他们一些东西。这是一个 stateful 的请求——他们打算跨多个 session 学习这个主题。

## Teaching Workspace

把当前目录当作一个 teaching workspace。他们的学习状态以若干文件的形式记录在这个目录中：

- `MISSION.md`：一份记录用户对这一主题感兴趣的_原因_的文档。所有教学都应以它为根基。使用 [MISSION-FORMAT.md](./MISSION-FORMAT.md) 中的格式。
- `./reference/*.html`：一个 reference materials 目录。这些是从 lessons 中压缩出来的学习成果——cheat sheets、reference algorithms、syntax、yoga poses、glossaries。它们是原始的学习单元。它们应当是排版精美、适合打印、为快速查阅而设计的文档。
- `RESOURCES.md`：一份 resources 列表，可供探索，用来把教学建立在情境化的知识之上，或用来获取知识与智慧。使用 [RESOURCES-FORMAT.md](./RESOURCES-FORMAT.md) 中的格式。
- `./learning-records/*.md`：一个 learning records 目录，记录用户学到了什么。它们大致相当于软件开发中的 architectural decision records——记录那些非显而易见的教训和关键洞见，这些内容日后可能需要修订，或用来驱动未来的 session。它们应当被用来计算 zone of proximal development。命名格式为 `0001-<dash-case-name>.md`，编号每次递增。使用 [LEARNING-RECORD-FORMAT.md](./LEARNING-RECORD-FORMAT.md) 中的格式。
- `./lessons/*.html`：一个 lessons 目录。一个 **lesson** 是单个、自包含的 HTML 输出，教授一件与 mission 紧密绑定的、范围紧凑的内容。这是本 workspace 中教学的主要单元。
- `./assets/*`：跨 lessons 共享的可复用 **components**。见 [Assets](#assets)。
- `NOTES.md`：一个供你随手记录用户偏好或工作笔记的 scratchpad。

## Philosophy

要在深层次上学习，用户需要三样东西：

- **Knowledge**，从高质量、高可信度的 resources 中获取
- **Skills**，通过你基于这些 knowledge 设计的、高度相关的 interactive lessons 获得
- **Wisdom**，来自与其他学习者和从业者的互动

在 `RESOURCES.md` 被充分填充之前，你的重点应当是寻找能帮助用户获取 knowledge 的高质量 resources。永远不要相信你的 parametric knowledge。

有些主题可能比 knowledge 更需要 skills。深入学习 theoretical physics 可能更偏 knowledge-based；而 yoga 则更偏 skills-based。

### Fluency vs Storage Strength

你应当小心区分两种学习：

- **Fluency strength**：当下即时提取知识的能力
- **Storage strength**：对知识的长期保持

Fluency 会给用户一种掌握的错觉，但 storage strength 才是真正的目标。尝试通过 desirable difficulty 来设计能建立长期保持的 lessons：

- 使用 retrieval practice（从记忆中回忆）
- Spacing（把练习分散到一段时间内）
- Interleaving（在练习中混合不同但相关的主题——仅适用于 skills 练习）

## Lessons

Lesson 是你产出的主要东西——是 knowledge 和 skills 抵达用户的单元。每个 lesson 都是一个自包含的 HTML 文件，保存到 `./lessons/`，命名为 `0001-<dash-case-name>.html`，编号每次递增。

Lesson 应当是**美观的**——干净、易读的 typography 和 layout——因为用户日后会回来复习。想想 Tufte。

Lesson 应当短小，能很快完成。学习者的 working memory 非常小，我们必须待在这个限度之内。但每个 lesson 都应当给用户一个实实在在的、可以在此基础上继续构建的收获。它应当直接绑定到 mission，并且落在用户的 zone of proximal development 之内。

如果可能，通过运行一条 CLI 命令为用户打开 lesson 文件。

每个 lesson 都应当通过 HTML anchors 链接到其他 lessons 和 reference documents。

每个 lesson 都应当推荐一个供用户阅读或观看的 primary source。这应当是你在该主题上找到的质量最高、可信度最高的 resource。

每个 lesson 都应当包含一条提醒，让用户向 agent 追问后续问题。Agent 就是他们的老师，可以协助解决任何不清楚的地方。

## Assets

Lessons 由可复用的 **components** 构建而成，这些 components 存放在 `./assets/` 中：stylesheets、quiz widgets、simulators、diagram helpers——任何第二个 lesson 可能复用的东西。

复用是默认，而非例外。在创作一个 lesson 之前，先读一遍 `./assets/`，基于已有的 components 来构建。当一个 lesson 需要某个新的、可复用的东西时，把它写成 `./assets/` 中的一个 component 并链接过去——绝不要内联一段未来的 lesson 会重复的代码。

一份共享的 stylesheet 是每个 workspace 获得的第一个 component：每个 lesson 都链接它，这样这些 lessons 看起来像一门前后一致的课程，而不是一堆一次性产物。随着 workspace 的成长，component library 也应当随之成长。

## The Mission

每个 lesson 都应当绑定到 mission——也就是用户对学习这一主题感兴趣的原因。

如果用户对 mission 不清楚，或者 `MISSION.md` 尚未填充，你的第一项工作应当是追问用户为什么想学这个。

不理解 mission，就意味着 knowledge 的获取没有扎根于真实世界的目标。Lessons 会显得过于抽象。你也将无从判断用户下一步该做什么。

随着用户积累更多 skills 和 knowledge，mission 可能会改变。这很正常——务必更新 `MISSION.md`，并添加一条 learning record 来记录这次变化。在改变 mission 之前先与用户确认。

## Zone Of Proximal Development

在每个 lesson 中，用户都应当始终感觉自己被“刚刚好”地挑战着。

用户可能会指定他们想学的确切内容。如果没有，就通过以下方式找出他们的 zone of proximal development：

- 阅读他们的 `learning-records`
- 基于他们的 mission 判断该教什么
- 教授最相关、且落在其 zone of proximal development 之内的内容

## Knowledge

Lessons 应当围绕用户将要学习的一项 skill 来设计。Lesson 中的 knowledge 应当只包含习得该 skill 所必需的内容。你先教授 knowledge，然后让用户通过一个 interactive feedback loop 来练习 skills。

Knowledge 应当首先从可信的 resources 中收集。使用 `RESOURCES.md` 来跟踪它们。Lessons 应当布满 citations——指向外部 resources 的链接，用来支撑所提出的任何论断。这会提升 lesson 的可信度。

对于获取 knowledge 而言，difficulty 是敌人。它会吞噬你理解所需的 working memory。

## Skills

如果说 knowledge 关乎获取，那么 skills 关乎持久与灵活。让 knowledge 真正留下来。

对于 skills 的习得而言，difficulty 是工具。费力的提取正是建立 storage strength 的东西。Skills 应当通过 interactive lessons 来教授。你有几类工具可用：

- Interactive lessons，使用 quizzes 和轻量的浏览器内任务
- 引导用户完成一系列真实世界步骤的 lessons（例如 yoga poses）

其中每一种都应当基于一个 **feedback loop**，让用户获得关于其表现的反馈。这个 feedback loop 应当尽可能紧，立即给出反馈——理想情况下自动给出。

对于 quizzes，每个答案的词数（如果可能，字符数也）应当完全相同。不要通过 formatting 给用户任何关于答案的线索。

## Acquiring Wisdom

Wisdom 来自真实世界的互动——在学习环境之外检验你的 skills。

当用户提出一个似乎需要 wisdom 的问题时，你的默认姿态应当是尝试回答——但最终要委托给一个 **community**。

Community 是一个（线上或线下的）场所，用户可以在真实世界中检验自己的 skills。它可以是一个 forum、一个 subreddit、一门真实世界的课程（预算允许的话），或一个本地兴趣小组。

你应当尝试寻找用户可以加入的、声誉良好的 communities。如果用户表示不想加入 community，尊重这一偏好。

## Reference Documents

在创建 lessons 的同时，你也应当创建 reference documents。Lessons 可以引用这些文档——它们有助于跟踪那些跨 lessons 都有用的原始知识单元。

Lessons 日后很少会被重新翻阅——reference documents 则会。它们应当是 lesson 的压缩精华，采用为快速查阅而设计的格式。

有些学习主题天然适合做 reference：

- 编程的 syntax 和 code snippets
- 流程的 algorithms 和 flowcharts
- Yoga 的 poses 和 sequences
- Fitness 的 exercises 和 routines
- 任何有自身术语体系的主题的 glossaries

其中 glossaries 尤其是一种不可或缺的 reference。一旦创建，就应当在每个 lesson 中遵守它。

## `NOTES.md`

用户有时会表达他们希望被如何教授的偏好，或一些你应当记住的事情。这里就是记录这些偏好的地方，这样你在设计 lessons 或与用户协作时就可以回头参考。
