# 设计两次

当用户想为某个选定的深化候选探索替代 interface 时，使用这个并行 sub-agent 模式。它基于 "Design It Twice"（Ousterhout）—— 你的第一个想法不太可能是最好的。

使用 [SKILL.md](SKILL.md) 中的词汇 —— **module**、**interface**、**seam**、**adapter**、**leverage**。

## 流程

### 1. 框定问题空间

在启动 sub-agent 之前，先为选定的候选写一份面向用户的问题空间说明：

- 任何新 interface 都需要满足的约束
- 它会依赖哪些依赖项，以及这些依赖属于哪一类（见 [DEEPENING.md](DEEPENING.md)）
- 一个粗略的示意性代码草图，用来让约束落地 —— 不是提案，只是把约束具体化的一种方式

把它展示给用户，然后立即进入 Step 2。用户在 sub-agent 并行工作的同时阅读和思考。

### 2. 派发 sub-agents

使用 Agent 工具并行启动 3 个以上的 sub-agent。每个都必须为深化后的 module 产出一个**截然不同**的 interface。

给每个 sub-agent 一份独立的技术 brief（文件路径、耦合细节、来自 [DEEPENING.md](DEEPENING.md) 的依赖类别、seam 背后是什么）。这份 brief 独立于 Step 1 中面向用户的问题空间说明。给每个 agent 一个不同的设计约束：

- Agent 1: "Minimize the interface — aim for 1–3 entry points max. Maximise leverage per entry point."
- Agent 2: "Maximise flexibility — support many use cases and extension."
- Agent 3: "Optimise for the most common caller — make the default case trivial."
- Agent 4（如适用）: "Design around ports & adapters for cross-seam dependencies."

在 brief 中同时包含 [SKILL.md](SKILL.md) 的词汇和 CONTEXT.md 的词汇，让每个 sub-agent 的命名既与架构语言一致，也与项目的领域语言一致。

每个 sub-agent 输出：

1. Interface（类型、方法、参数 —— 外加不变量、顺序、错误模式）
2. 展示调用方如何使用的用法示例
3. 实现在 seam 背后隐藏了什么
4. 依赖策略与 adapter（见 [DEEPENING.md](DEEPENING.md)）
5. 权衡 —— leverage 在哪里高，在哪里薄

### 3. 呈现并比较

依次展示各个设计，让用户能逐个消化，然后用文字进行比较。按 **depth**（interface 处的 leverage）、**locality**（变化集中在哪里）和 **seam placement** 来对比。

比较之后，给出你自己的推荐：你认为哪个设计最强，以及为什么。如果不同设计中的元素可以很好地组合，就提出一个混合方案。要有主见 —— 用户想要的是一个强有力的判断，而不是一份菜单。
