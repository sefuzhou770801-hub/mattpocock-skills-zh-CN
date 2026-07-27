---
name: codebase-design
description: 用于设计 deep module 的共享词汇。当用户想设计或改进一个 module 的 interface、寻找深化机会、决定 seam 放在哪里、让代码更可测试或更适合 AI 导航，或当另一个 skill 需要 deep-module 词汇时使用。
---

# Codebase Design

设计 **deep module**：在一个干净的 seam 后面，用一个小 interface 承载大量行为，并且可以通过那个 interface 来测试。只要在设计或重构代码，就使用这套语言和这些原则。目标是为调用方提供 leverage，为维护者提供 locality，并为所有人提供可测试性。

## Glossary

精确使用这些术语 — 不要替换成 “component”、“service”、“API” 或 “boundary”。语言一致正是重点所在。

**Module** — 任何拥有 interface 和 implementation 的东西。刻意做到与规模无关：一个函数、类、包，或跨层的切片都可以。_Avoid_：unit、component、service。

**Interface** — 调用方为了正确使用该 module 所必须知道的一切：类型签名，但也包括不变量、顺序约束、错误模式、所需配置和性能特征。_Avoid_：API、signature（太窄 — 它们只指类型层面的表面）。

**Implementation** — module 内部的东西，它的代码主体。与 **Adapter** 不同：一个东西可以是小 adapter 配大 implementation（一个 Postgres repo），也可以是大 adapter 配小 implementation（一个内存中的 fake）。当话题是 seam 时用 “adapter”；否则用 “implementation”。

**Depth** — interface 处的 leverage：调用方（或 test）每学会一个单位的 interface 就能驱动的行为量。当大量行为坐落在一个小 interface 后面时，module 是 **deep** 的；当 interface 几乎和 implementation 一样复杂时，它是 **shallow** 的。

**Seam** _（Michael Feathers）_ — 一个你可以在不编辑该处的情况下改变行为的地方；module 的 interface 所存在的*位置*。seam 放在哪里本身就是一个设计决定，与它后面放什么是分开的。_Avoid_：boundary（与 DDD 的 bounded context 过载）。

**Adapter** — 在某个 seam 处满足一个 interface 的具体东西。描述的是*角色*（它填哪个槽位），而不是实质（里面是什么）。

**Leverage** — 调用方从 depth 中获得的东西：每学会一个单位的 interface 就得到更多能力。一份 implementation 在 N 个调用点和 M 个 test 中反复回报。

**Locality** — 维护者从 depth 中获得的东西：变更、bug、知识和验证集中在一处，而不是散布在各个调用方之间。修一次，处处修好。

## Deep vs shallow

**Deep module** = 小 interface + 大量 implementation：

```
┌─────────────────────┐
│   Small Interface   │  ← Few methods, simple params
├─────────────────────┤
│                     │
│  Deep Implementation│  ← Complex logic hidden
│                     │
└─────────────────────┘
```

**Shallow module** = 大 interface + 少量 implementation（应避免）：

```
┌─────────────────────────────────┐
│       Large Interface           │  ← Many methods, complex params
├─────────────────────────────────┤
│  Thin Implementation            │  ← Just passes through
└─────────────────────────────────┘
```

设计 interface 时，问：

- 我能减少方法的数量吗？
- 我能简化参数吗？
- 我能在内部隐藏更多复杂性吗？

## Principles

- **Depth 是 interface 的属性，而不是 implementation 的属性。** 一个 deep module 在内部可以由小的、可 mock 的、可替换的部分组成 — 它们只是不属于 interface。一个 module 既可以有**内部 seam**（其 implementation 私有的，供它自己的 test 使用），也可以有 interface 处的**外部 seam**。
- **删除测试。** 想象删掉这个 module。如果复杂性消失了，它就是一个 pass-through。如果复杂性在 N 个调用方之间重新出现，它就在挣得自己的存在。
- **interface 就是测试面。** 调用方和 test 穿过同一个 seam。如果你想测试 interface *之外*的东西，那这个 module 很可能形状不对。
- **一个 adapter 意味着一个假想的 seam。两个 adapter 意味着一个真实的 seam。** 除非确实有东西在 seam 两侧变化，否则不要引入 seam。

## Designing for testability

好的 interface 让测试变得自然：

1. **接受依赖，而不是创建它们。**

   ```typescript
   // Testable
   function processOrder(order, paymentGateway) {}

   // Hard to test
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **返回结果，而不是产生副作用。**

   ```typescript
   // Testable
   function calculateDiscount(cart): Discount {}

   // Hard to test
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **小的表面积。** 更少的方法 = 需要更少的 test。更少的参数 = 更简单的 test 搭建。

## Relationships

- 一个 **Module** 恰好有一个 **Interface**（它呈现给调用方和 test 的表面）。
- **Depth** 是一个 **Module** 的属性，相对于它的 **Interface** 来衡量。
- **Seam** 是一个 **Module** 的 **Interface** 所存在的地方。
- 一个 **Adapter** 坐落在一个 **Seam** 处，并满足该 **Interface**。
- **Depth** 为调用方产生 **Leverage**，为维护者产生 **Locality**。

## Rejected framings

- **把 Depth 当作 implementation 行数与 interface 行数之比**（Ousterhout）：这会奖励把 implementation 撑大。我们改用 depth-as-leverage。
- **把 “Interface” 当作 TypeScript 的 `interface` 关键字或一个类的 public 方法**：太窄 — 这里的 interface 包括调用方必须知道的每一个事实。
- **“Boundary”**：与 DDD 的 bounded context 过载。说 **seam** 或 **interface**。

## Going deeper

- **在给定依赖的情况下深化一个集群** — 见 [DEEPENING.md](DEEPENING.md)：依赖类别、seam 纪律，以及 replace-don't-layer 的测试方式。
- **探索备选 interface** — 见 [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md)：启动并行的 sub-agent，以几种截然不同的方式设计 interface，然后在 depth、locality 和 seam 放置上加以比较。
