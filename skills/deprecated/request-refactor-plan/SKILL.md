---
name: request-refactor-plan
description: 通过用户访谈，创建一份由极小 commits 构成的详细 refactor 计划，然后作为 GitHub issue 提交。适用于用户想规划 refactor、撰写 refactoring RFC，或把 refactor 拆成安全的增量步骤时。
---

当用户想创建一个 refactor 请求时，会调用这个 skill。你应当依次完成下面的步骤。如果你认为某些步骤没有必要，可以跳过。

1. 请用户对他们想解决的问题以及任何潜在的解决思路，做一段详尽的描述。

2. 探索 repo，核实他们的说法，并理解 codebase 的现状。

3. 询问他们是否考虑过其他方案，并向他们提出其他可选方案。

4. 就实现方式访谈用户。要极其细致、彻底。

5. 敲定实现的确切范围。明确你打算改什么、不打算改什么。

6. 在 codebase 中检查这一区域的 test 覆盖情况。如果 test 覆盖不足，询问用户的测试计划。

7. 把实现拆分成一份由极小 commits 构成的计划。记住 Martin Fowler 的建议：“make each refactoring step as small as possible, so that you can always see the program working.”

8. 用这份 refactor 计划创建一个 GitHub issue。issue 描述使用下面的模板：

<refactor-plan-template>

## Problem Statement

开发者面临的问题，从开发者的视角来写。

## Solution

问题的解决方案，从开发者的视角来写。

## Commits

一份详尽、篇幅较长的实现计划。用平实的语言书写，把实现拆分成尽可能小的 commits。每个 commit 都应让 codebase 保持在可工作状态。

## Decision Document

一份已做出的实现决策清单。可以包括：

- 将要构建/修改的 modules
- 这些 modules 中将要修改的 interfaces
- 来自开发者的技术澄清
- 架构决策
- schema 变更
- API 契约
- 具体的交互

不要包含具体的文件路径或代码片段。它们可能很快就会过时。

## Testing Decisions

一份已做出的测试决策清单。包括：

- 对什么是好 test 的描述（只测试外部行为，不测试实现细节）
- 哪些 modules 会被测试
- test 的先例（即 codebase 中同类型的 tests）

## Out of Scope

对本次 refactor 范围之外事项的描述。

## Further Notes (optional)

关于本次 refactor 的任何补充说明。

</refactor-plan-template>
