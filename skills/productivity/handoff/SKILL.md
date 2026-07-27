---
name: handoff
description: 把当前对话压缩成一份 handoff document，供另一个 agent 接手。
argument-hint: "下一个 session 将用于什么？"
disable-model-invocation: true
---

编写一份 handoff document，总结当前对话，让一个全新的 agent 能继续这项工作。保存到用户操作系统的临时目录——不要保存到当前 workspace。

在文档中包含一个 “suggested skills” section，建议 agent 应当调用哪些 skills。

不要重复已被其他 artifacts 捕获的内容（specs、plans、ADRs、issues、commits、diffs）。改用 path 或 URL 引用它们。

删去任何敏感信息，例如 API keys、passwords 或 personally identifiable information。

如果用户传入了 arguments，把它们视为对下一个 session 重点的描述，并据此调整文档。
