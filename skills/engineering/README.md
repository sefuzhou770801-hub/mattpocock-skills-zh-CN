# Engineering

我每天用于代码工作的 skills。

## User-invoked

只有在你显式输入名称时才能调用（Claude Code：`disable-model-invocation: true`；Codex：`agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`）。

- **[ask-matt](./ask-matt/SKILL.md)** —— 询问当前情境适合哪个 skill 或 flow。它是本仓库 user-invoked skills 之上的一个 router。
- **[grill-with-docs](./grill-with-docs/SKILL.md)** —— grilling session，同时构建项目的 domain model，打磨术语并内联更新 `CONTEXT.md` 与 ADR。
- **[triage](./triage/SKILL.md)** —— 让 issue 穿过一个由 triage role 组成的状态机。
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)** —— 扫描 codebase 中的深化机会，以可视化 HTML report 呈现，然后围绕你选中的那一个继续 grilling。
- **[setup-matt-pocock-skills](./setup-matt-pocock-skills/SKILL.md)** —— 为本仓库配置 engineering skills（issue tracker、triage label、domain 文档布局）。每个 repo 运行一次。
- **[to-spec](./to-spec/SKILL.md)** —— 把当前对话整理成一份 spec 并发布到 issue tracker。
- **[to-tickets](./to-tickets/SKILL.md)** —— 把任何 plan、spec 或对话拆成一组 tracer-bullet ticket，每个都声明自己的阻塞边 —— 在本地文件里用文本表示，或在真实 tracker 上用原生阻塞链接。
- **[implement](./implement/SKILL.md)** —— 构建某份 spec 或某组 ticket 所描述的工作，在预先约定好的 seam 上驱动 `/tdd`，并在提交前以 `/code-review` 收尾。
- **[wayfinder](./wayfinder/SKILL.md)** —— 把一大块工作 —— 多到单个 agent session 装不下 —— 规划成 issue tracker 上的一张 decision ticket 共享 map，逐个解决，直到通往目的地的路变得清晰。

## Model-invoked

模型或用户都可调用（触发措辞足够丰富，方便模型主动找到它们）。

- **[prototype](./prototype/SKILL.md)** —— 构建一个一次性 prototype 来回答一个设计问题：一个用于 state/logic 的可运行终端 app，或几个可切换的 UI 变体。

- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)** —— 面向棘手 bug 和性能回退的纪律化诊断循环：reproduce → minimise → hypothesise → instrument → fix → regression-test。
- **[research](./research/SKILL.md)** —— 对照高可信的一手来源调研一个问题，并把带引用的发现保存为 repo 中的一个 Markdown 文件，作为后台 agent 运行。
- **[tdd](./tdd/SKILL.md)** —— 采用 red-green-refactor 循环的测试驱动开发。一次一个 vertical slice 地构建功能或修复 bug。
- **[domain-modeling](./domain-modeling/SKILL.md)** —— 主动构建并打磨一个项目的 domain model —— 挑战术语、用场景做压力测试、内联更新 `CONTEXT.md` 与 ADR。
- **[codebase-design](./codebase-design/SKILL.md)** —— 设计 deep module 的共享纪律与词汇：小 interface、干净的 seam、可通过 interface 测试。
- **[code-review](./code-review/SKILL.md)** —— 对自某个固定点以来的 diff 做双轴 review：**Standards**（是否遵循 repo 的编码规范，外加一个 Fowler smell 基线？）与 **Spec**（是否忠实实现了源头的 issue/PRD？），作为并行 sub-agent 运行。
- **[resolving-merge-conflicts](./resolving-merge-conflicts/SKILL.md)** —— 逐个 hunk 地处理一个正在进行的 git merge 或 rebase 冲突，按追溯到每一侧一手来源的意图来解决，然后完成该操作 —— 绝不 `--abort`。
