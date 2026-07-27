---
name: qa
description: 交互式 QA session：用户以对话方式报告 bug 或问题，agent 负责创建 GitHub issues。同时在后台探索 codebase 以获取上下文和领域语言。适用于用户想报告 bug、做 QA、以对话方式提 issues，或提到 “QA session” 时。
---

# QA Session

运行一个交互式 QA session。用户描述他们遇到的问题。你负责澄清、在后台探索 codebase 获取上下文，并创建持久、以用户为中心、使用项目领域语言的 GitHub issues。

## For each issue the user raises

### 1. Listen and lightly clarify

让用户用自己的话描述问题。**最多问 2-3 个简短的澄清性问题**，聚焦于：

- 他们期望什么，实际发生了什么
- 复现步骤（如果不明显）
- 是稳定复现还是偶发

不要过度盘问。如果描述已经足够清楚可以立 issue，就直接往下走。

### 2. Explore the codebase in the background

在与用户交谈的同时，在后台启动一个 Agent（subagent_type=Explore）来理解相关区域。目标不是找修复方案，而是：

- 学习该区域使用的领域语言（检查 UBIQUITOUS_LANGUAGE.md）
- 理解这个 feature 本应做什么
- 确定面向用户的行为边界

这些上下文能帮你写出更好的 issue——但 issue 本身不应引用具体文件、行号或内部实现细节。

### 3. Assess scope: single issue or breakdown?

在创建之前，判断这是一个**单一 issue**，还是需要**拆分**成多个 issues。

需要拆分的情况：

- 修复跨越多个相互独立的区域（例如 “表单校验有问题，而且成功提示缺失，而且跳转坏了”）
- 存在明显可分离、可由不同人并行处理的关注点
- 用户描述的东西有多种不同的失败模式或症状

保持单一 issue 的情况：

- 同一处有一个行为出错
- 所有症状都源于同一个根行为

### 4. File the GitHub issue(s)

用 `gh issue create` 创建 issues。不要先让用户审阅——直接创建并分享 URL。

Issues 必须**持久**——在大型 refactor 之后仍应说得通。从用户视角来写。

#### For a single issue

使用这个模板：

```
## What happened

[Describe the actual behavior the user experienced, in plain language]

## What I expected

[Describe the expected behavior]

## Steps to reproduce

1. [Concrete, numbered steps a developer can follow]
2. [Use domain terms from the codebase, not internal module names]
3. [Include relevant inputs, flags, or configuration]

## Additional context

[Any extra observations from the user or from codebase exploration that help frame the issue — e.g. "this only happens when using the Docker layer, not the filesystem layer" — use domain language but don't cite files]
```

#### For a breakdown (multiple issues)

按依赖顺序创建 issues（blocker 优先），这样就可以引用真实的 issue 编号。

每个子 issue 使用这个模板：

```
## Parent issue

#<parent-issue-number> (if you created a tracking issue) or "Reported during QA session"

## What's wrong

[Describe this specific behavior problem — just this slice, not the whole report]

## What I expected

[Expected behavior for this specific slice]

## Steps to reproduce

1. [Steps specific to THIS issue]

## Blocked by

- #<issue-number> (if this issue can't be fixed until another is resolved)

Or "None — can start immediately" if no blockers.

## Additional context

[Any extra observations relevant to this slice]
```

做拆分时：

- **宁多勿厚**——每个 issue 都应可独立修复、独立验证
- **如实标注阻塞关系**——如果 issue B 确实要等 issue A 修好才能测试，就写明。如果它们相互独立，两个都标 “None — can start immediately”
- **按依赖顺序创建 issues**，这样才能在 “Blocked by” 中引用真实的 issue 编号
- **最大化并行度**——目标是让多个人（或 agents）能同时领取不同的 issues

#### Rules for all issue bodies

- **不写文件路径或行号**——它们会过时
- **使用项目的领域语言**（如有 UBIQUITOUS_LANGUAGE.md 就检查它）
- **描述行为，而非代码**——写 “the sync service fails to apply the patch”，而不是 “applyPatch() throws on line 42”
- **复现步骤是必填项**——如果无法确定，就问用户
- **保持简洁**——开发者应能在 30 秒内读完这个 issue

创建完毕后，打印所有 issue URL（并概述阻塞关系），然后问：“Next issue, or are we done?”

### 5. Continue the session

持续进行，直到用户说完成。每个 issue 都是独立的——不要批量处理。
