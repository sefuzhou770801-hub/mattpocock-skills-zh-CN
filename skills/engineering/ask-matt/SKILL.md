---
name: ask-matt
description: 询问当前情境适合哪个技能或流程；它是本仓库所有 skills 的路由器。
disable-model-invocation: true
---

# Ask Matt

你不需要记住每个 skill，所以直接问。

**Flow** 是穿过 skills 的一条路径。大多数路径沿着一条 **main flow** 前进，两个 **on-ramps** 会并入它。其他内容要么是 standalone，要么是在下层运行的 vocabulary layer。

## The main flow: idea → ship

这是大多数工作的路线：你有一个想法，并希望把它构建出来。

1. **`/grill-with-docs`** - 通过访谈打磨想法。只要你在 **working directory 里工作**，就从这里开始：它是 stateful 的，会把学到的内容保存在 `CONTEXT.md` 和 ADRs 中。（没有 working directory？用 `/grill-me`，见 Standalone。两者都运行同一个 `/grilling` primitive；`grill-with-docs` 会留下文档痕迹，所以只要有 repo 可写痕迹，它就是两者中更好的那个。）
2. **分支 - 能否在对话中解决所有问题？** 如果某个问题需要可运行的答案（state、business logic，或必须亲眼看到的 UI），就通过 prototype 绕行，并用 **`/handoff`** 在两个方向桥接（prototype 活在自己的 directory 里，这正是 `/handoff` 的用途——见 Phase boundaries）：
   - **`/handoff`** 导出，然后基于该文件打开 fresh session；
   - **`/prototype`** 用 throwaway code 回答问题；
   - **`/handoff`** 把学到的内容带回来，并在原始 idea thread 中引用它。
3. **分支 - 这是 multi-session build 吗？**
   - **是** -> **`/to-spec`**（把 thread 变成 spec），再用 **`/to-tickets`** 拆成 tracer-bullet tickets，每个 ticket 声明 **blocking edges**。Local tracker 在 `.scratch/<feature>/issues/` 下每 ticket 一个文件，手动按 blockers-first 处理；真实 tracker 用 native blocking links，因此 blockers 已完成的 ticket 都可领取——每 ticket 启动一次 **`/implement`**，并在 tickets 之间 **`/clear` context**。每个 ticket 自包含，所以上一个的 context 可以丢掉。
   - **否** -> 在当前 context window 里直接运行 **`/implement`**。

   无论哪种方式，**`/implement`** 都会在内部驱动 **`/tdd`** 构建每个 issue：一次一个 red-green slice；然后用 **`/code-review`** 收尾，对 diff 做 Standards + Spec 双轴 review，再提交。只想在没有完整 spec 的情况下 test-first 构建一个具体 behavior 时，单独用 **`/tdd`**；想按固定点 review branch 或 PR 时，单独用 **`/code-review`**。

### Context hygiene

步骤 1 到 `/to-tickets` 要留在 **同一个未中断的 context window** 中；不要 compact 或 clear，这样 grilling、spec 和 tickets 才能建立在同一组思考之上。之后每个 `/implement` 都从 fresh session 开始，只基于对应 ticket 工作。

限制来自 **[smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)**：在该窗口（最新模型大约 150k tokens）内，模型还能保持敏锐推理。如果 session 在 `/to-tickets` 前接近这个区间，不要硬撑降级状态；在最近的 phase boundary 上 `/compact`，然后继续（见 Phase boundaries）。

## On-ramps

起点会生成工作，然后并入 main flow。

- **Bugs 和 requests 堆积** -> **`/triage`**。它通过 triage roles 推进 issues，并产出 agent-ready issues，之后由 **`/implement`** 领取。

  Triage 只用于 **不是你创建的** issues：bug reports、incoming feature requests，以及任何原始进入的内容。`/to-tickets` 产出的 tickets 已经是 agent-ready，不要再 triage。

- **Something's broken** -> **`/diagnosing-bugs`**。用于难处理的问题：第一眼看不出的 bug、间歇性 flake、夹在两个 known-good states 之间的 regression。它在拥有 **tight feedback loop** 前拒绝空想，也就是一个已经能在 _这个_ bug 上变红的命令；然后用 regression test 修复。如果复盘发现真正问题是没有好 seam 能锁住 bug，它会把后续交给 **`/improve-codebase-architecture`**。

- **巨大而模糊的 effort——greenfield project 或巨大 feature build，一个 session 装不下** -> **`/wayfinder`**，这是这里认知负担最重的 flow。当从当前位置到 destination 的路还看不见时，它在 issue tracker 上绘制 **decision tickets** 的 **shared map**，逐个解决，产出 **decisions, not deliverables**，直到 fog 被推开、路径清晰。`/grill-with-docs` 用于一个 session 能装下的想法，wayfinder 用于装不下的想法；它更慢、更密集，所以只应留给确实如此的 effort，绝不要用于范围明确的 feature。

  Map 清晰后，**它会 hand off，而不是 build**：先进入 **`/to-spec`**，把 map 中相互链接的 decisions 收束成可构建计划，然后照常使用 `/to-tickets` 和 `/implement`。让 map 直接循环进入 `/implement` 会跳过这次收束并丢掉相互链接的细节；只有当 effort 后来发现确实很小时，才直接进入 `/implement`。

## Codebase health

这不是 feature work，而是维护。

- **`/improve-codebase-architecture`** - 有空时运行，保持 codebase 适合 agents 操作。它会暴露 **deepening opportunities**；选择其中一个会生成一个 idea，可以带入 main flow 的 `/grill-with-docs`。它负责找候选项；**`/codebase-design`**（见下文）是你设计已选候选项时使用的工作台。

## Vocabulary underneath

两个 model-invoked references 在其他 skills 下层运行，分别是自己词汇的 single source of truth。问题在于**词语**而不是流程时直接用它们；也可以让上面的 skills 自动拉起它们。

- **`/domain-modeling`** - 打磨项目的 _domain_ language：挑战模糊术语、解决 overloaded word（例如一个 "account" 承担三件事）、把难以逆转的决策记录为 ADR。它是 `/grill-with-docs` 用来保持 `CONTEXT.md` glossary 干净的主动纪律。
- **`/codebase-design`** - deep-module vocabulary（module、interface、depth、seam、adapter、leverage、locality），用于设计 module 的 _shape_：把大量 behavior 放在 clean seam 上的小 interface 后面。`/tdd` 和 `/improve-codebase-architecture` 都使用这套语言。

## Phase boundaries

**Phase** 是 session 内的一块工作——grilling、implementation、QA。在两个 phase 之间的 **boundary** 上，你有五个选项，在它们之间做选择是整张 map 里最模糊的决策：

- **Continue** — 留在原地。零成本、零损失。
- **`/clear`** — 清空 window，当这里的一切与接下来无关时。
- **`/handoff`** — 写出可移植的 markdown 文件。用途很窄：只用于 **新 harness**、**新 directory**、**同事**，或在 **phase 中途** 分叉旁支任务。它买到的是 portability。
- **Subagent** — 把收紧过的任务送到自己的 window，拿回报告。
- **`/compact`** — 压缩当前 context，用它播种新 session。这是 **默认**，在树的底部，而不是第一选择。

读 [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) 看有序决策树——五个问题、每条分支背后的理由，以及为什么 primary-source 成本让 **Continue** 成为要先排除的那个。在 boundary **上** 做决定；phase 中途则继续，或把剩下的拆给 subagents。

## Standalone

完全在 main flow 之外。

- **`/grill-me`** - 与 `/grill-with-docs` 一样的持续访谈，但 **stateless**：不在本地保存内容，也不构建 `CONTEXT.md`。在你 **不在 working directory 里工作** 时用它——打磨计划、设计、写作，或任何下面没有 repo 的事。若你在 working directory 里，改用 `/grill-with-docs`：同样的访谈，还会留下文档痕迹，因此严格更好。
- **`/grilling`** - 访谈 primitive 本身：rounds、frontier、facts 是 agent 的工作、decisions 是你的。`/grill-me` 与 `/grill-with-docs` 是两条命名入口；`/triage`、`/wayfinder` 与 `/improve-codebase-architecture` 都会在内部跑它。只有当你想要没有包装的访谈时，才直接用它。
- **`/resolving-merge-conflicts`** - 逐 hunk 处理正在进行的 merge 或 rebase conflict，按追溯到各方 primary source 的 **intent** 解决，而不是挑行，然后完成操作。它从不跑 `--abort`。Standalone，不在任何 flow 上：已经 mid-conflict 时用它。
- **`/prototype`** - 一个小型 throwaway program，用来回答一个设计问题：这个 state model 感觉对吗，或者这个 UI 应该是什么样。Throwaway 是对代码写法的约束，不是销毁的承诺：答案折进真实 code，prototype 本身作为 **primary source** 保存在 main 之外的 `prototype/<name>` branch，并从 implementation issue 指向它。它是 main flow 第 2 步的绕行，但任何难以纸面解决的 design question 都可以直接用它。
- **`/research`** - 把阅读工作委托给 **background agent**：它对照 **primary sources** 调研问题，然后在 repo 中留下带引用的 Markdown 文件。你可以在它阅读时继续工作。产物应带入 `/grill-with-docs` 的 main flow；research 提供思考材料，但不取代思考。
- **`/to-questionnaire`** - 当挡住你的东西不在你脑子里、也不在 codebase 里，而在 **别人** 那里时，给对方写一份 questionnaire 去填。它是 `/grill-me` 的反面：不是就 subject 访谈你，而是就 **send** 访谈你——发给谁、需要拿回什么——并把问题对准 gap。收回来的材料给 `/grill-with-docs` 或 `/to-spec` 用。
- **`/wizard`** - 用于只有 **人类** 能走的步骤：provision 基础设施、配置 credentials 或 CI secrets、点进不熟悉的第三方 dashboard、跑一次性 migration 或 cutover。它生成交互式 bash 脚本，打开每个 URL、捕获每个值，并写入 `.env` 与 GitHub secrets——于是这套流程不再需要你每次向 agent 重新解释。Model-invoked，所以 agent 撞上只有你能过的墙时会主动拉起它。如果 agent 自己就能做，它就该自己做；这里只给人类真正 in the loop 的地方。
- **`/wait-what`** - 消息没落地时的纠正。在对话中途、任何其他 skill 内部使用；agent 会用你缺的上下文，用 plain English，并使用 `CONTEXT.md` 词汇，重新 pitch 它刚说的话。它事后生效；`/grill-with-docs` 是事前药方，因为早期谈妥的 shared language 才能阻止 jargon 出现。
- **`/teach`** - 使用当前目录作为 stateful workspace，跨多个 sessions 学习一个概念。
- **`/writing-for-agents`** - 撰写 agent 消费的文档的 reference：skills、AGENTS.md、经 pointer 触达的 docs。

## Precondition

**`/setup-matt-pocock-skills`** - 第一次运行 engineering flow 前先执行，用来配置其他 skills 所依赖的 issue tracker、triage labels 和 docs layout。自定义 issue trackers 也可以。
