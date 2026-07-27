# CONTEXT.md 格式

## 结构

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## 规则

- **要有主见。** 当同一个概念存在多个词时，选出最好的那个，并把其余的列在 `_Avoid_` 下。
- **定义要精炼。** 最多一两句话。定义它*是*什么，而不是它*做*什么。
- **只收录本项目 context 特有的术语。** 通用编程概念（超时、错误类型、工具类模式）不属于这里，即使项目大量使用它们。添加术语前先问一句：这是本 context 独有的概念，还是一个通用编程概念？只有前者才属于这里。
- **当出现自然的聚类时，把术语分组到子标题下。** 如果所有术语都属于同一个内聚领域，用平铺列表也可以。

## 单 context vs 多 context 的 repo

**单一 context（大多数 repo）：** 在 repo 根目录放一个 `CONTEXT.md`。

**多个 context：** 在 repo 根目录放一个 `CONTEXT-MAP.md`，列出各个 context、它们的位置以及彼此之间的关系：

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — receives and tracks customer orders
- [Billing](./src/billing/CONTEXT.md) — generates invoices and processes payments
- [Fulfillment](./src/fulfillment/CONTEXT.md) — manages warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`
```

这个 skill 会推断适用哪种结构：

- 如果存在 `CONTEXT-MAP.md`，读取它以找到各个 context
- 如果只有根目录的 `CONTEXT.md`，按单一 context 处理
- 如果两者都不存在，就在第一个术语被确定时延迟创建根目录的 `CONTEXT.md`

当存在多个 context 时，推断当前主题与哪一个相关。如果不确定，就问。
