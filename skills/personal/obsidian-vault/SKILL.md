---
name: obsidian-vault
description: 在 Obsidian vault 中搜索、创建和管理 note，使用 wikilink 和 index note。当用户想要在 Obsidian 中查找、创建或整理 note 时使用。
---

# Obsidian Vault

## vault 位置

`/mnt/d/Obsidian Vault/AI Research/`

根层级基本是扁平的。

## 命名约定

- **Index note**：聚合相关主题（例如 `Ralph Wiggum Index.md`、`Skills Index.md`、`RAG Index.md`）
- 所有 note 名称使用 **Title case**
- 不使用文件夹来组织 —— 改用链接和 index note

## 链接

- 使用 Obsidian 的 `[[wikilinks]]` 语法：`[[Note Title]]`
- note 在底部链接到其依赖/相关的 note
- index note 就是 `[[wikilinks]]` 列表

## 工作流

### 搜索笔记

```bash
# Search by filename
find "/mnt/d/Obsidian Vault/AI Research/" -name "*.md" | grep -i "keyword"

# Search by content
grep -rl "keyword" "/mnt/d/Obsidian Vault/AI Research/" --include="*.md"
```

或者直接对 vault 路径使用 Grep/Glob 工具。

### 新建一条笔记

1. 文件名使用 **Title Case**
2. 将内容写成一个学习单元（遵循 vault 规则）
3. 在底部添加到相关 note 的 `[[wikilink]]`
4. 如果属于带编号序列的一部分，使用分层编号方案

### 查找相关笔记

在整个 vault 中搜索 `[[Note Title]]` 以查找 backlink：

```bash
grep -rl "\\[\\[Note Title\\]\\]" "/mnt/d/Obsidian Vault/AI Research/"
```

### 查找索引笔记

```bash
find "/mnt/d/Obsidian Vault/AI Research/" -name "*Index*"
```
