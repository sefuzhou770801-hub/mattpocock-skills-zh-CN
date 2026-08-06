# Skill mechanics

[`writing-for-agents`](SKILL.md) 的 skill 专属分支：当文档是 skill 时，什么会变——frontmatter、invocation 选择，以及 router skills。其余写法见 `SKILL.md` 中的通用参考。

## Invocation

两种选择，交换两种 load：

- **Model-invoked** skill 保留 `description`，所以 agent 可以自主触发它——其他 skills 也能触达它。你仍可输入它的名称：model-invocation 始终 _包含_ user reach；description 只增加 agent discovery，从不拿走人类的触达。Description 是 skill 的顶层 context pointer，被迫始终加载——用永久 context load 换 discoverability。内容全是 reference 的 model-invoked skill，也是共享 reference 的一个家：另一个 skill 可以 invoke 它，所以多个 skills 需要的 reference 放在一处。机制：省略 `disable-model-invocation`，写带 trigger branches 的 model-facing description（`SKILL.md` 的 pointer 写作规则全部适用）。
- **User-invoked** skill 把 description 从 agent 触达范围拿掉：只有人类输入名称才能 invoke，其他 skill 也不能。零 context load，但花 cognitive load——你是必须记得它存在的 index。机制：设置 `disable-model-invocation: true`；`description` 变成 human-facing——一行摘要，去掉 trigger lists。

只有当 agent 必须自行找到该 skill，或另一个 skill 必须触达它时，才选 model-invocation。如果它永远只靠手触发，就做成 user-invoked，不付 context load。

两个 user-invoked skills 都需要的共享 reference，可以两边都不放——没有 descriptions，谁也触发不了谁。把它推到 skill system 外的普通文件：任何 skill 都能指向的 external reference。

## Splitting by invocation

Splitting 的 invocation 切法（sequence 切法在 `SKILL.md`）：当你有一个独立 leading word 应自主触发它——你在 prompts 里真的会用的 trigger word——或另一个 skill 必须触达它时，拆出 model-invoked skill。你要为新的始终加载 description 支付 context load，所以独立触达必须值得。

## Router skills

当 user-invoked skills 多到记不住时，堆积的 cognitive load 由 **router skill** 治疗：一个 user-invoked skill，命名其他 skills 以及何时取用每一个，让人类只记一个 skill 而不是许多。它只能 hint，永远不能 fire 它们：user-invoked skills 没有 description，所以除了人类谁也触达不了。
