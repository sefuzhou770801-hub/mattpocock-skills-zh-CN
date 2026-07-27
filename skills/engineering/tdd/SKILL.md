---
name: tdd
description: 测试驱动开发。适用于用户想以 test-first 的方式构建功能或修复 bug、提到 "red-green-refactor"，或想要 integration test 时。
---

# Test-Driven Development

TDD 就是 red → green 循环。本 skill 是让这个循环产出值得保留的 test 的那份参考：什么是好 test、test 放在哪里、anti-pattern，以及这个循环的规则。每一节在每个循环中都适用——在循环之前和循环期间查阅它们，而不是事后。

探索代码库时，阅读 `CONTEXT.md`（如果存在），让 test 名称和 interface 词汇与项目的领域语言保持一致，并尊重你所涉及区域中的 ADR。

## 什么是好的 test

Test 通过 public interface 来验证行为，而不是实现细节。代码可以彻底改变；test 不应该随之改变。一个好 test 读起来像一份 specification——"user can checkout with valid cart" 精确地告诉你存在什么能力——并且它能在 refactor 中存活下来，因为它不关心内部结构。

示例见 [tests.md](tests.md)，mocking 指引见 [mocking.md](mocking.md)。

## seams —— test 放在哪

**seam** 是你进行测试的那个 public 边界：那个你观察行为、却不必探入内部的 interface。Test 活在 seam 上，绝不针对内部。

**只在预先约定好的 seam 上测试。** 在写任何 test 之前，写下被测的 seam 并与用户确认。不在未经确认的 seam 上写 test。你不可能测试所有东西——预先约定好 seam，正是让测试精力落在关键路径和复杂逻辑上、而不是落在每个 edge case 上的方式。

询问："What's the public interface, and which seams should we test?"

## 反模式

- **Implementation-coupled** — mock 了内部的协作者、测试了私有方法，或通过一条旁路来验证（查询数据库而不是使用 interface）。其特征是：你一 refactor test 就挂了，但行为并没有变。
- **Tautological** — 断言按照代码的方式重新计算出期望值（`expect(add(a, b)).toBe(a + b)`、以同样的方式手工推导出的 snapshot、把一个常量断言为等于它自己），因此它天生就会通过，永远不可能与代码相左。期望值必须来自一个独立的真相来源——一个已知正确的字面量、一个推演过的例子、那份 spec。
- **Horizontal slicing** — 先写完所有 test，再写所有实现。成批的 test 验证的是_想象中的_行为：你测试的是东西的_形状_，而不是面向用户的行为，test 对真实变化变得迟钝，而且你在理解实现之前就已经锁定了 test 结构。改用 **vertical slice**——一个 test → 一个实现 → 重复，每个 test 都是一颗**tracer bullet**，对上一个循环教给你的东西做出回应。

## 循环的规则

- **Red before green.** 先写那个会失败的 test，然后只写刚好能让它通过的代码。不要预判未来的 test，也不要添加投机性的功能。
- **One slice at a time.** 每个循环一个 seam、一个 test、一个最小实现。
- **Refactoring is not part of the loop.** 它属于 review 阶段（见 `code-review` skill），而不属于 red → green 的实现循环。
