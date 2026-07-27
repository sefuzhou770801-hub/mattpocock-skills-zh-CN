# Productivity

通用的工作流工具，与代码无关。

## User-invoked

只有在你输入它们的名字时才能触达（Claude Code：`disable-model-invocation: true`；Codex：`agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`）。

- **[grill-me](./grill-me/SKILL.md)** — 围绕一个计划或 design 接受毫不留情的追问，直到 decision tree 的每一个分支都被解决。
- **[handoff](./handoff/SKILL.md)** — 把当前对话压缩成一份 handoff document，让另一个 agent 可以继续这项工作。
- **[teach](./teach/SKILL.md)** — 跨多个 session 教用户一项新 skill 或一个新概念，把当前目录当作一个有状态的 teaching workspace。
- **[writing-great-skills](./writing-great-skills/SKILL.md)** — 编写和编辑优秀 skills 的参考：让一个 skill 变得可预测的那套词汇与原则。

## Model-invoked

模型或用户都可以触达（带有丰富的触发措辞，好让模型能触达它们）。

- **[grilling](./grilling/SKILL.md)** — 围绕一个计划、decision 或 idea，毫不留情地追问用户，直到 decision tree 的每一个分支都被解决。
