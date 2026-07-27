# Domain Docs

engineering skills 在探索 codebase 时，应当如何消费本 repo 的 domain 文档。

## Before exploring, read these

- repo 根目录的 **`CONTEXT.md`**，或者
- repo 根目录的 **`CONTEXT-MAP.md`**（如果存在）—— 它会指向每个 context 的一个 `CONTEXT.md`。读取与当前主题相关的每一个。
- **`docs/adr/`** —— 读取涉及你即将工作区域的 ADR。在多 context 的 repo 中，还要检查 `src/<context>/docs/adr/` 里 context 范围内的决策。

如果这些文件有任何一个不存在，**静默继续**。不要标注它们缺失；不要主动建议创建。`/domain-modeling` skill（经由 `/grill-with-docs` 和 `/improve-codebase-architecture` 触达）会在术语或决策真正被确定时延迟创建它们。

## File structure

单 context 的 repo（大多数 repo）：

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

多 context 的 repo（根目录存在 `CONTEXT-MAP.md`）：

```
/
├── CONTEXT-MAP.md
├── docs/adr/                          ← system-wide decisions
└── src/
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← context-specific decisions
    └── billing/
        ├── CONTEXT.md
        └── docs/adr/
```

## Use the glossary's vocabulary

当你的输出提到某个 domain 概念时（在 issue 标题里、refactor 提案里、假设里、test 名称里），使用 `CONTEXT.md` 中定义的术语。不要漂移到术语表明确避免的同义词。

如果你需要的概念还不在术语表里，这是一个信号 —— 要么你正在发明项目并不使用的语言（重新考虑），要么确实存在一个空白（为 `/domain-modeling` 记下来）。

## Flag ADR conflicts

如果你的输出与某个现有 ADR 相矛盾，就明确点出来，而不是悄悄推翻它：

> _Contradicts ADR-0007 (event-sourced orders) — but worth reopening because…_
