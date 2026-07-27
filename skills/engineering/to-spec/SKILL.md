---
name: to-spec
description: 把当前对话转化为一份 spec 并发布到项目 issue tracker——不做访谈，只是对你们已经讨论过的内容进行综合。
disable-model-invocation: true
---

本 skill 取用当前的对话上下文和对代码库的理解，产出一份 spec（你可能把这种文档称作 PRD）。不要访谈用户——只是综合你已经知道的东西。

issue tracker 和 triage label 词汇表应该已经提供给你了——如果没有，运行 `/setup-matt-pocock-skills`。

## 流程

1. 探索仓库以理解代码库的当前状态（如果你还没有这么做的话）。在整份 spec 中始终使用项目领域词汇表的词汇，并尊重你所涉及区域中的任何 ADR。

2. 勾画出你打算在哪些 seam 上测试这个功能。应优先使用现有的 seam，而不是新建的。使用尽可能高的 seam。如果确实需要新的 seam，就在你能达到的最高点提出它们。整个代码库中的 seam 越少越好——理想数量是一个。

与用户确认这些 seam 是否符合他们的预期。

3. 使用下面的模板撰写 spec，然后把它发布到项目 issue tracker。应用 `ready-for-agent` triage label——无需额外的 triage。

<spec-template>

## 问题陈述

用户正在面对的问题，从用户的视角描述。

## 方案

问题的解决方案，从用户的视角描述。

## 用户故事

一份很长的、带编号的 user story 列表。每条 user story 应采用如下格式：

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

这份 user story 列表应当极其详尽，覆盖该功能的方方面面。

## 实现决策

一份已做出的实现决策列表。可以包括：

- 将要构建/修改的 module
- 那些 module 中将要修改的 interface
- 来自开发者的技术澄清
- 架构决策
- schema 变更
- API 契约
- 具体的交互

不要包含具体的文件路径或代码片段。它们可能很快就会过时。

例外：如果某个 prototype 产出了一段比散文更能精确编码某个决策的片段（state machine、reducer、schema、type 形状），就把它内联到相关决策之中，并简要注明它来自一个 prototype。裁剪到富含决策的部分——不是一个可运行的 demo，只是重要的那几处。

## 测试决策

一份已做出的测试决策列表。包括：

- 对什么是好 test 的描述（只测试外部行为，不测试实现细节）
- 哪些 module 会被测试
- 这些 test 的 prior art（即代码库中类似类型的 test）

## 范围之外

对不在本 spec 范围之内的事项的描述。

## 补充说明

关于该功能的任何进一步说明。

</spec-template>
