# ADR 格式

ADR 存放在 `docs/adr/` 中，使用连续编号：`0001-slug.md`、`0002-slug.md`，依此类推。

`docs/adr/` 目录延迟创建 —— 只有在需要第一个 ADR 时才创建。

## 模板

```md
# {Short title of the decision}

{1-3 sentences: what's the context, what did we decide, and why.}
```

就是这样。一个 ADR 可以只是一段话。价值在于记录*做出了*某个决策以及*为什么* —— 而不在于填满各个章节。

## 可选小节

只有在它们确实增加价值时才加入。大多数 ADR 用不到它们。

- **Status** frontmatter（`proposed | accepted | deprecated | superseded by ADR-NNNN`）—— 当决策会被重新审视时有用
- **Considered Options** —— 只有当被否决的备选方案值得记住时才写
- **Consequences** —— 只有当需要点明不明显的下游影响时才写

## 编号

扫描 `docs/adr/` 中现有的最大编号，然后加一。

## 何时提供一份 ADR

以下三条必须全部成立：

1. **难以逆转** —— 之后改变主意的代价是实实在在的
2. **没有上下文就会令人意外** —— 未来的读者看着代码会纳闷 "why on earth did they do it this way?"
3. **真实权衡的结果** —— 存在真正的备选方案，而你出于具体理由选了其中一个

如果一个决策容易逆转，就跳过它 —— 到时候直接逆转就好。如果它并不令人意外，就没人会纳闷为什么。如果没有真正的备选方案，那除了 "we did the obvious thing" 之外没什么可记录的。

### 什么算数

- **架构形态。** "We're using a monorepo." "The write model is event-sourced, the read model is projected into Postgres."
- **context 之间的集成模式。** "Ordering and Billing communicate via domain events, not synchronous HTTP."
- **带有锁定效应的技术选型。** 数据库、消息总线、认证提供方、部署目标。不是每一个库都算 —— 只有那些换一个要花一个季度的才算。
- **边界与范围决策。** "Customer data is owned by the Customer context; other contexts reference it by ID only." 明确的"不做什么"与"做什么"同样有价值。
- **对显而易见路径的刻意偏离。** "We're using manual SQL instead of an ORM because X." 任何合理读者会假定相反做法的地方都算。这些能阻止下一个工程师去"修复"一个刻意为之的东西。
- **代码中看不到的约束。** "We can't use AWS because of compliance requirements." "Response times must be under 200ms because of the partner API contract."
- **当否决理由不明显时，记录被否决的备选方案。** 如果你考虑过 GraphQL 却出于微妙理由选了 REST，就记录下来 —— 否则六个月后又会有人提议 GraphQL。
