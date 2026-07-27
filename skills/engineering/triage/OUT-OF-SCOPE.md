# 范围之外知识库

仓库中的 `.out-of-scope/` 目录保存被拒绝 feature request 的持久记录。它有两个用途：

1. **Institutional memory** — 记录某个 feature 为何被拒绝，避免 issue 关闭后理由随之丢失
2. **Deduplication** — 当新 issue 与既往拒绝相匹配时，skill 可以指出之前的决策，而不是重新争论一遍

## 目录结构

```
.out-of-scope/
├── dark-mode.md
├── plugin-system.md
└── graphql-api.md
```

每个**概念**一个文件，而不是每个 issue 一个文件。多个请求同一件事的 issue 归入同一个文件。

## 文件格式

文件应以轻松、可读的风格撰写——更像一份简短的 design document，而不是一条数据库记录。用段落、代码示例和例子把理由讲清楚，让第一次读到它的人也能理解并受用。

```markdown
# Dark Mode

This project does not support dark mode or user-facing theming.

## Why this is out of scope

The rendering pipeline assumes a single color palette defined in
`ThemeConfig`. Supporting multiple themes would require:

- A theme context provider wrapping the entire component tree
- Per-component theme-aware style resolution
- A persistence layer for user theme preferences

This is a significant architectural change that doesn't align with the
project's focus on content authoring. Theming is a concern for downstream
consumers who embed or redistribute the output.

```ts
// The current ThemeConfig interface is not designed for runtime switching:
interface ThemeConfig {
  colors: ColorPalette; // single palette, resolved at build time
  fonts: FontStack;
}
```

## Prior requests

- #42 — "Add dark mode support"
- #87 — "Night theme for accessibility"
- #134 — "Dark theme option"
```

### 给文件命名

为概念使用简短、具描述性的 kebab-case 名称：`dark-mode.md`、`plugin-system.md`、`graphql-api.md`。名称应足够清晰，让浏览目录的人无需打开文件就能知道被拒绝的是什么。

### 写出理由

理由应有实质内容——不是 "we don't want this"，而是说明为什么。好的理由会引用：

- 项目范围或理念（"This project focuses on X; theming is a downstream concern"）
- 技术约束（"Supporting this would require Y, which conflicts with our Z architecture"）
- 战略决策（"We chose to use A instead of B because..."）

理由应当持久。避免引用临时性情况（"we're too busy right now"）——那不是真正的拒绝，而是延期。

## 何时检查 `.out-of-scope/`

在 triage 期间（Step 1: Gather context），读取 `.out-of-scope/` 中的所有文件。评估新 issue 时：

- 检查该请求是否匹配某个现有的 out-of-scope 概念
- 匹配依据是概念相似度，而非关键词——"night theme" 匹配 `dark-mode.md`
- 如果匹配，向 maintainer 指出："This is similar to `.out-of-scope/dark-mode.md` — we rejected this before because [reason]. Do you still feel the same way?"

Maintainer 可能会：

- **Confirm** — 新 issue 被添加到现有文件的 "Prior requests" 列表中，然后关闭
- **Reconsider** — 删除或更新该 out-of-scope 文件，issue 走正常 triage 流程
- **Disagree** — 这些 issue 相关但彼此独立，继续正常 triage

## 何时写入 `.out-of-scope/`

只有当一个 **enhancement**（而非 bug）被*拒绝*为 `wontfix` 时才写入。这对 enhancement PR 与对 issue 完全适用——被拒绝的 PR 同样记录在这里，以免同样的请求以新代码的形式再次出现。

当某件事因为**已经实现**而被以 `wontfix` 关闭时，**不要**写在这里。那是一个已构建的 feature，而不是被拒绝的 feature；把它记录下来会让 dedup 检查被虚假的拒绝所污染。正确做法是，在 closing comment 中指向该 feature 已经存在的位置。

流程：

1. Maintainer 判定某个 feature request 不在范围内
2. 检查是否已存在匹配的 `.out-of-scope/` 文件
3. 如果有：把新 issue 追加到 "Prior requests" 列表
4. 如果没有：用概念名、decision、reason 和第一条 prior request 创建新文件
5. 在 issue 上发布评论，说明决策并提及该 `.out-of-scope/` 文件
6. 以 `wontfix` label 关闭 issue

## 更新或移除范围之外的文件

如果 maintainer 改变了对某个既往被拒绝概念的看法：

- 删除该 `.out-of-scope/` 文件
- Skill 无需重新打开旧 issue——它们是历史记录
- 触发重新考虑的那个新 issue 继续走正常 triage 流程
