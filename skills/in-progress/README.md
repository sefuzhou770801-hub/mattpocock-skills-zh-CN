# In Progress

仍在开发中的 skills。它们还没准备好发布 —— 预期会有粗糙之处、破坏性变更，以及被放弃的实验。在它们毕业进入一个稳定的 bucket 之前，它们被排除在 plugin 和顶层 README 之外。

- **[loop-me](./loop-me/SKILL.md)** — 跨多个 sessions 把自己 grill 成可实现的 workflow specs，用当前目录作为一个有状态的 workspace。User-invoked。
- **[wizard](./wizard/SKILL.md)** — 生成一个交互式 bash wizard，引导一个人走完一项手动流程（setup、一次性 migration、状态迁移）—— 打开 URL、捕获取值、写入 `.env` 和 GitHub Actions secrets。User-invoked。
- **[writing-beats](./writing-beats/SKILL.md)** — 以 choose-your-own-adventure 的风格，把一篇文章塑造成一段由 beats 构成的旅程。挑一个 starting beat，只写那一个 beat，然后转向下一个，直到文章自然收尾。
- **[writing-fragments](./writing-fragments/SKILL.md)** — 一场 grilling session，从你身上开采出 fragments —— 异质的写作小块 —— 并把它们追加到同一份文档里，作为未来一篇文章的原始素材。
- **[writing-shape](./writing-shape/SKILL.md)** — 拿一份原始素材的 markdown 文件，一段一段地把它塑造成一篇文章，并在每一步就格式选择展开争论。
- **[claude-handoff](./claude-handoff/SKILL.md)** — 把当前对话交接给一个全新的 background agent，让它立即接手工作，通过 `claude --bg` 以一份 handoff summary 作为种子。User-invoked。
- **[setup-ts-deep-modules](./setup-ts-deep-modules/SKILL.md)** — 把 dependency-cruiser 接入一个 TypeScript repo，让每个 package 都是一个 deep module —— implementation 隐藏在 subfolders 中，只能通过其 entry-point files 访问，tests 则通过这些 entry points 来检验它。User-invoked。
- **[to-questionnaire](./to-questionnaire/SKILL.md)** — 把一个你无法完整回答的 decision 变成一份 Markdown questionnaire，交给别人异步填写，或在一场会议里填写。它围绕 send（给谁、需要拿回什么）来 grill 你，而不是围绕主题本身。User-invoked。
- **[batch-grill-me](./batch-grill-me/SKILL.md)** — 一场不留情面的访谈，按 rounds 走遍这棵 design tree，而不是一次一个问题 —— 每一轮把整个 frontier（prerequisites 已经敲定的所有 decisions）一次性问完，然后根据你的回答重新计算。User-invoked。
