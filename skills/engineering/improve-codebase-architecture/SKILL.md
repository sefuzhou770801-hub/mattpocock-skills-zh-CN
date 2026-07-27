---
name: improve-codebase-architecture
description: 扫描代码库中的 deepening 机会，将其呈现为可视化 HTML 报告，然后对你挑选的任意一项进行 grilling。
disable-model-invocation: true
---

# 改进 codebase 架构

暴露架构上的摩擦，并提出 **deepening opportunities**——把 shallow module 变成 deep module 的 refactor。目标是可测试性与 AI 可导航性。

本命令以项目的 domain model 为_依据_，并构建在一套共享的设计词汇之上：

- 运行 `/codebase-design` skill 以获取架构词汇（**module**、**interface**、**depth**、**seam**、**adapter**、**leverage**、**locality**）及其原则（deletion test、"the interface is the test surface"、"one adapter = hypothetical seam, two = real"）。在每一条建议中都精确使用这些术语——不要漂移到 "component"、"service"、"API" 或 "boundary"。
- `CONTEXT.md` 中的领域语言为好的 seam 命名；`docs/adr/` 中的 ADR 记录了本命令不应重新争论的决策。

## 流程

### 1. 探索

**先划定范围再扫描——YAGNI。** Deepening 一个 module 的回报在于让它未来的修改更容易，所以要给代码库中最近发生变化的部分更多权重。在查看之前先决定*去哪里*看：

- 如果用户指明了方向——某个 module、某个子系统、某个痛点——就采纳它，跳过下面的推断。
- 否则，回溯相当一段 commit 历史（`git log --oneline`），找出代码库的热点——那些反复出现的文件和区域——并让这些路径首先吸引你的注意力。如果变更分散、没有明确的热点，就扩大搜索范围。

先阅读项目的领域词汇表（`CONTEXT.md`）以及你所涉及区域中的任何 ADR。

然后使用 Agent 工具并指定 `subagent_type=Explore` 来走查代码库。不要遵循僵化的启发式——自然地探索，并记下你在哪里感受到摩擦：

- 在哪里理解一个概念需要在许多小 module 之间来回跳转？
- 哪里的 module 是 **shallow** 的——interface 几乎和实现一样复杂？
- 哪里为了可测试性而抽取了纯函数，但真正的 bug 却藏在它们的调用方式里（缺乏 **locality**）？
- 哪里紧耦合的 module 会跨越它们的 seam 泄漏？
- 代码库的哪些部分没有 test，或者难以通过其当前 interface 进行 test？

对你怀疑是 shallow 的任何东西应用 **deletion test**：删掉它会让复杂度集中，还是仅仅把它挪走？"yes, concentrates" 才是你想要的信号。

### 2. 把候选呈现为一份 HTML report

把一个自包含的 HTML 文件写到操作系统的临时目录，这样就不会有任何东西落进仓库。从 `$TMPDIR` 解析临时目录，回退到 `/tmp`（Windows 上为 `%TEMP%`），并写入 `<tmpdir>/architecture-review-<timestamp>.html`，让每次运行都得到一个全新文件。为用户打开它——Linux 上用 `xdg-open <path>`，macOS 上用 `open <path>`，Windows 上用 `start <path>`——并告诉他们绝对路径。

该报告使用 **Tailwind via CDN** 做布局与样式，并在图/流程/时序能可靠传达结构的地方使用 **Mermaid via CDN** 画图。把 Mermaid 与手工制作的 CSS/SVG 视觉元素混合使用——当关系是图状的（调用图、依赖、时序）时用 Mermaid，当你想要更具编辑感的东西（体量图、剖面图、折叠动画）时用手工构建的 div/SVG。每个候选项都配一张 **before/after 可视化**。要可视化。

对每个候选项，渲染一张卡片，包含：

- **Files** — 涉及哪些文件/module
- **Problem** — 当前架构为何造成摩擦
- **Solution** — 用平实的语言描述会发生什么变化
- **Benefits** — 用 locality 和 leverage 来解释，以及 test 会如何改善
- **Before / After diagram** — 并排、自定义绘制，展示 shallowness 与 deepening
- **Recommendation strength** — `Strong`、`Worth exploring`、`Speculative` 之一，渲染为徽章

报告以一个 **Top recommendation** 小节收尾：你会先处理哪个候选项，以及为什么。

**领域使用 CONTEXT.md 的词汇，架构使用 `/codebase-design` 的词汇。** 如果 `CONTEXT.md` 定义了 "Order"，就谈 "the Order intake module"——而不是 "the FooBarHandler"，也不是 "the Order service"。

**ADR conflicts**：如果某个候选项与现有 ADR 相矛盾，只有当摩擦真实到足以值得重新审视该 ADR 时才把它摆出来。在卡片中明确标注（例如一个警告 callout：_"contradicts ADR-0007 — but worth reopening because…"_）。不要罗列 ADR 所禁止的每一种理论上的 refactor。

完整的 HTML 脚手架、图示模式与样式指引见 [HTML-REPORT.md](HTML-REPORT.md)。

现在不要提出 interface。文件写完后，询问用户："Which of these would you like to explore?"

### 3. grilling 循环

一旦用户选定一个候选项，就运行 `/grilling` skill，与他们一起走查决策树——约束、依赖、deepened module 的形态、seam 背后放着什么、哪些 test 能存活下来。

随着决策逐渐清晰，副作用会内联发生——运行 `/domain-modeling` skill，在推进过程中让 domain model 保持最新：

- **要用一个不在 `CONTEXT.md` 中的概念为 deepened module 命名？** 把该术语加入 `CONTEXT.md`。如果文件不存在就惰性创建它。
- **在对话中打磨一个模糊的术语？** 当场更新 `CONTEXT.md`。
- **用户以一个承重性的理由拒绝了该候选项？** 提议写一份 ADR，措辞为：_"Want me to record this as an ADR so future architecture reviews don't re-suggest it?"_ 只有当这个理由确实是未来的探索者避免重新建议同一件事所需要的时才提议——跳过短暂性的理由（"not worth it right now"）和不证自明的理由。
- **想为 deepened module 探索替代的 interface？** 运行 `/codebase-design` skill，并使用它的 design-it-twice 并行 sub-agent 模式。
