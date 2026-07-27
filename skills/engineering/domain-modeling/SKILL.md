---
name: domain-modeling
description: 构建并打磨一个项目的 domain model。当用户想敲定 domain 术语或 ubiquitous language、记录一项架构决定，或当另一个 skill 需要维护 domain model 时使用。
---

# Domain Modeling

在你设计的过程中，主动构建并打磨项目的 domain model。这是一门*主动*的纪律 — 质疑术语、发明 edge-case 场景，并在它们成形的那一刻就把术语表和决定写下来。（仅仅*阅读* `CONTEXT.md` 以获取词汇并不是这门 skill — 那是任何 skill 都能做的一行习惯。这门 skill 用于你正在改变 model 的时候，而不只是消费它。）

## File structure

大多数 repo 只有一个 context：

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

如果根目录存在 `CONTEXT-MAP.md`，那么这个 repo 就有多个 context。这张 map 指出每一个所在的位置：

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

延迟创建文件 — 只在你有东西可写的时候才创建。如果还不存在 `CONTEXT.md`，就在第一个术语被敲定时创建一个。如果还不存在 `docs/adr/`，就在需要第一个 ADR 时创建它。

## During the session

### Challenge against the glossary

当用户使用的术语与 `CONTEXT.md` 中现有的语言相冲突时，立即指出来。“Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?”

### Sharpen fuzzy language

当用户使用含糊或过载的术语时，提出一个精确的规范术语。“You're saying 'account' — do you mean the Customer or the User? Those are different things.”

### Discuss concrete scenarios

当正在讨论 domain 关系时，用具体场景对它们做压力测试。发明一些探查 edge case 的场景，迫使用户对概念之间的边界做到精确。

### Cross-reference with code

当用户陈述某样东西如何运作时，检查代码是否一致。如果你发现矛盾，就把它摆到台面上：“Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?”

### Update CONTEXT.md inline

当一个术语被敲定时，就在那里更新 `CONTEXT.md`。不要把这些攒起来 — 在它们发生时就捕获。使用 [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md) 中的格式。

`CONTEXT.md` 应当完全没有实现细节。不要把 `CONTEXT.md` 当作 spec、草稿本或实现决定的存放处。它是一部术语表，别无其他。

### Offer ADRs sparingly

只有当以下三条全部为真时，才提议创建一个 ADR：

1. **难以逆转** — 日后改变主意的代价是实实在在的
2. **没有 context 就会令人费解** — 未来的读者会纳闷“他们为什么这么做？”
3. **一次真实权衡的结果** — 存在真正的备选项，而你出于具体原因选了其中一个

如果三条中缺任何一条，就跳过这个 ADR。使用 [ADR-FORMAT.md](./ADR-FORMAT.md) 中的格式。
