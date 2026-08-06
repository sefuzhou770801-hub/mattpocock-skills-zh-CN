# Productivity

通用工作流工具，不限于代码。

## User-invoked

只有在你显式输入名称时才能调用（Claude Code：`disable-model-invocation: true`；Codex：`agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`）。

- **[grill-me](./grill-me/SKILL.md)** - 围绕计划或设计进行持续追问，直到 design tree 的每个分支都被解决。
- **[handoff](./handoff/SKILL.md)** - 把当前对话压缩成 handoff document，让另一个 agent 可以继续。
- **[teach](./teach/SKILL.md)** - 使用当前目录作为 stateful teaching workspace，在多个 sessions 中教用户一个新 skill 或概念。
- **[to-questionnaire](./to-questionnaire/SKILL.md)** - 把你无法独自回答的决策，变成给能回答的人填写的 Markdown 问卷——可异步填，也可在会议里一起填。
- **[wait-what](./wait-what/SKILL.md)** - 消息没落地的瞬间就触发。Agent 用你缺的上下文、plain English，以及 `CONTEXT.md` 词汇重新 pitch。

## Model-invoked

模型或用户都可以调用（description 包含足够丰富的触发措辞，方便模型自动找到它们）。

- **[grilling](./grilling/SKILL.md)** - 围绕计划、decision 或 idea 持续访谈用户，直到 design tree 的每个分支都被解决。
- **[writing-for-agents](./writing-for-agents/SKILL.md)** - 为 agent 撰写文档：skills、AGENTS.md/CLAUDE.md，以及经 pointer 触达的任何 doc。
