---
name: design-an-interface
description: 使用并行 sub-agents 为某个 module 生成多个截然不同的 interface 设计。适用于用户想设计 API、探索 interface 选项、比较 module 形态，或提到 “design it twice” 时。
---

# Design an Interface

源自 “A Philosophy of Software Design” 中的 “Design It Twice”：你的第一个想法不太可能是最好的。生成多个截然不同的设计，然后再比较。

## Workflow

### 1. Gather Requirements

设计之前，先弄清楚：

- [ ] 这个 module 解决什么问题？
- [ ] 调用方是谁？（其他 modules、外部用户、tests）
- [ ] 关键操作有哪些？
- [ ] 有什么约束？（performance、compatibility、已有模式）
- [ ] 什么应该隐藏在内部，什么应该暴露出去？

询问：“这个 module 需要做什么？谁会用它？”

### 2. Generate Designs (Parallel Sub-Agents)

使用 Task tool 同时启动 3 个以上的 sub-agents。每个都必须产出一个**截然不同**的方案。

```
Prompt template for each sub-agent:

Design an interface for: [module description]

Requirements: [gathered requirements]

Constraints for this design: [assign a different constraint to each agent]
- Agent 1: "Minimize method count - aim for 1-3 methods max"
- Agent 2: "Maximize flexibility - support many use cases"
- Agent 3: "Optimize for the most common case"
- Agent 4: "Take inspiration from [specific paradigm/library]"

Output format:
1. Interface signature (types/methods)
2. Usage example (how caller uses it)
3. What this design hides internally
4. Trade-offs of this approach
```

### 3. Present Designs

每个设计都展示以下内容：

1. **Interface signature** — types、methods、params
2. **Usage examples** — 调用方在实际中如何使用它
3. **What it hides** — 保留在内部的复杂性

逐个展示设计，让用户在比较之前先消化每个方案。

### 4. Compare Designs

展示完所有设计后，从以下维度比较：

- **Interface simplicity**：更少的 methods、更简单的 params
- **General-purpose vs specialized**：灵活性 vs 专注度
- **Implementation efficiency**：这个形态是否允许高效的内部实现？
- **Depth**：小 interface 隐藏大量复杂性（好）vs 大 interface 配单薄实现（坏）
- **Ease of correct use** vs **ease of misuse**

用文字讨论 trade-offs，不要用表格。重点标出各设计分歧最大的地方。

### 5. Synthesize

最好的设计往往融合了多个方案的洞见。询问：

- “哪个设计最契合你的主要 use case？”
- “其他设计中有没有值得吸收的元素？”

## Evaluation Criteria

出自 “A Philosophy of Software Design”：

**Interface simplicity**：更少的 methods、更简单的 params = 更容易学会并正确使用。

**General-purpose**：无需改动就能应对未来的 use cases。但要警惕过度泛化。

**Implementation efficiency**：interface 的形态是否允许高效实现？还是逼出别扭的内部实现？

**Depth**：小 interface 隐藏大量复杂性 = deep module（好）。大 interface 配单薄实现 = shallow module（应避免）。

## Anti-Patterns

- 不要让 sub-agents 产出相似的设计——强制要求根本性的差异
- 不要跳过比较——价值就在于对比
- 不要动手实现——这里只关心 interface 的形态
- 不要基于实现成本来评判
