---
name: ask-matt
description: 询问当前情境适合哪个 skill 或 flow。它是本仓库所有 skills 之上的一个 router。
disable-model-invocation: true
---

# Ask Matt

你不可能记住每个 skill，所以直接问。

**flow** 是穿过这些 skills 的一条路径。大多数路径都沿着一条 **main flow** 前进，有两条 **on-ramp** 会汇入它。其余的要么是 standalone，要么是在底层运行的 vocabulary layer。

## The main flow: idea → ship

大多数工作所走的路线。你有一个想法，想把它构建出来。

1. **`/grill-with-docs`** — 通过访谈来打磨想法。当你**已有 codebase** 时从这里开始：它是 stateful 的，会把学到的东西沉淀到 `CONTEXT.md` 和 ADR 中。（没有 codebase？用 `/grill-me` — 见 Standalone。两者都运行同一个 `/grilling` primitive；`grill-with-docs` 是会留下书面痕迹的那一个。）
2. **分支 — 你能否在对话中解决所有问题？** 如果某个问题需要一个可运行的答案（state、business logic、或你必须亲眼看到的 UI），就绕道一个 prototype，并用 **`/handoff`** 在两个方向上搭桥（见 Crossing sessions）：
   - 用 **`/handoff`** 导出，然后针对那个文件开一个新 session，
   - 用 **`/prototype`** 以一次性代码回答问题，
   - 再用 **`/handoff`** 把你学到的东西带回来，并从最初的 idea thread 中引用它。
3. **分支 — 这是一次跨多个 session 的构建吗？**
   - **是** → **`/to-spec`**（把 thread 变成一份 spec），然后 **`/to-tickets`** 把它拆成 tracer-bullet tickets，每个 ticket 都声明它的 **blocking edges**。在本地 tracker 上，就是 `.scratch/<feature>/issues/` 下每个 ticket 一个文件，按 blockers-first 手工推进；在真实 tracker 上，这些 edges 会变成原生的 blocking links，于是任何 blockers 已完成的 ticket 都可以被领取 — 逐个 ticket 启动 **`/implement`**，并**在每一个之间清空 context**。
   - **否** → 就在这里、在同一个 context window 里直接 **`/implement`**。

   无论哪种情况，**`/implement`** 都会在内部驱动 **`/tdd`** 来构建每个 issue — 一次一个 red-green slice — 然后在提交前运行 **`/code-review`** 收尾，对 diff 做一次双轴（Standards + Spec）review。当你只想 test-first 地构建一个具体行为、而不需要完整 spec 时，单独使用 **`/tdd`**；当你想针对一个固定点 review 某个 branch 或 PR 时，随时单独使用 **`/code-review`**。

### Context hygiene

把步骤 1–3 保持在**一个不间断的 context window** 里 — 在 `/to-tickets` 之前不要 compact 或清空 — 这样 grilling、spec 和 tickets 都建立在同一套思考之上。之后每个 `/implement` 都全新开始，只依据 ticket 工作。

这件事的上限是 **[smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)**：即模型仍能敏锐推理的那个窗口（在最先进的模型上约 120k tokens）。如果某个 session 在 `/to-tickets` 之前就逼近它，不要在降级状态下硬撑 — 用 `/handoff`，在一个新 thread 里继续。

## On-ramps

一种会产生工作、然后汇入 main flow 的起始情境。

- **bug 和 request 不断堆积** → **`/triage`**。它让 issue 流经各个 triage 角色，产出 agent-ready 的 issue，之后由 **`/implement`** 接手。

  Triage 只用于**不是你创建的** issue — bug report、传进来的 feature request，以及任何以原始状态到达的东西。`/to-tickets` 产出的 ticket 已经是 agent-ready，所以**不要对它们做 triage**。

- **有东西坏了** → **`/diagnosing-bugs`**。专门对付那些棘手的：一眼看不出来的 bug、时好时坏的 flake、在两个已知良好状态之间悄悄溜进来的 regression。在拥有**紧凑的 feedback loop** 之前，它拒绝做任何理论化 — 也就是*这个* bug 上已经能变红的一条命令 — 然后用一个 regression test 来修复。当真正的发现是“没有一个好 seam 能把这个 bug 锁死”时，它的 post-mortem 会交接给 **`/improve-codebase-architecture`**。

- **一项庞大而迷雾重重的工程 — 一个 greenfield 项目或一次巨大的 feature 构建，大到单个 session 装不下** → **`/wayfinder`**，这里是认知负担最重的 flow。当从这里到目的地的路还看不见时，它会在 issue tracker 上绘制一张由 **decision tickets** 构成的**共享地图**，并逐个解决它们 — 产出的是 **decisions，而非 deliverables** — 直到迷雾被推开、道路变得清晰。**`/grill-with-docs`** 打磨的是你能在单个 session 里把握的想法，而 wayfinder 面向的是你把握不住的想法 — 它更慢、更密，所以把它留给恰好那种情况，绝不要用于一个范围清晰的 feature。

  当地图变得清晰时，**它做的是交接，而不是构建**：在 **`/to-spec`** 处汇入 main flow，由它把地图上相互链接的 decisions 收敛成一份可构建的计划，然后照常 `/to-tickets` 和 `/implement`。把地图直接绕进 `/implement` 会跳过那次收敛，把链接的细节丢掉 — 只有当这项工程结果确实很小时，才直接去 `/implement`。

## Codebase health

不是 feature 工作 — 而是维护。

- **`/improve-codebase-architecture`** — 只要你有一点空闲，就运行它，让 codebase 保持适合 agent 在其中运作。它会浮现出**深化机会**；选中其中一个，就会_产生一个 idea_，你可以把它带进 `/grill-with-docs` 的 main flow。它是发现候选者的勘察；而 **`/codebase-design`**（见下文）则是你在其上设计所选方案的工作台。

## Vocabulary underneath

两个由 model 调用的参考，运行在其他 skills _之下_ — 每一个都是其词汇表的唯一事实来源。当问题出在**措辞**而非流程上时，直接使用它们；或者让上面的 skills 把它们拉进来。

- **`/domain-modeling`** — 打磨项目的 *domain* 语言：质疑一个含糊的术语，解决一个过载的词（“account” 身兼三职），把一个难以逆转的决定记录成 ADR。它是 `/grill-with-docs` 所驱动的那门主动纪律，用来让 `CONTEXT.md` 保持为一部干净的术语表。
- **`/codebase-design`** — deep-module 的词汇表（module、interface、depth、seam、adapter、leverage、locality），用于设计一个 module 的_形状_：在一个干净的 seam 后面，用一个小 interface 承载大量行为。`/tdd` 和 `/improve-codebase-architecture` 都说这门语言。

## Crossing sessions

- **`/handoff`** — 当一个 thread 满了，或你需要分叉出去（例如进入一个 `/prototype` session）时，它会把对话压缩进一个 markdown 文件。你不会原地继续 — 而是**开一个新 session 并引用那个文件**，把 context 带过去。它是 context window 之间的桥梁，两个方向都行。当你想要一个**全新的 session**、但又需要**保留当前对话**时使用它。
- **`/compact`**（内置）— 留在**同一个对话**里，让较早的轮次被摘要。在**阶段之间有意的停顿处**使用它，此时你不介意丢掉逐字的历史。不要在一个阶段进行到一半时 compact — agent 会迷失方向。`/handoff` 分叉；`/compact` 继续。

## Standalone

完全脱离 main flow。

- **`/grill-me`** — 和 `/grill-with-docs` 一样不留情面的访谈，但用于你**没有 codebase** 时。它是 stateless 的：不在本地保存任何东西，也不构建 `CONTEXT.md`。用它来打磨任何不存在于 repo 中的计划或设计。
- **`/prototype`** — 一个小型的一次性程序，用来回答一个设计问题：这个 state model 感觉对不对，或者这个 UI 应该长什么样。从第一天起就是一次性的 — 留下答案，删掉代码。它是 main flow 第 2 步里的那条绕道，但只要一个设计问题难以在纸面上敲定，就随时使用它。
- **`/research`** — 把阅读的跑腿活委派给一个**后台 agent**：它会针对**一手来源**调查一个问题，然后在 repo 里留下一份带引用的 Markdown 文件。它阅读的同时你继续工作。它产出的文件是你带_进_ `/grill-with-docs` main flow 的东西 — research 喂养思考，而不是取代思考。
- **`/teach`** — 跨多个 session 学习一个概念，把当前目录当作一个 stateful 的工作区。
- **`/writing-great-skills`** — 关于如何写好和编辑好 skills 的参考。

## Precondition

**`/setup-matt-pocock-skills`** — 在你的第一个工程 flow 之前运行它，配置好其他 skills 所假定的 issue tracker、triage labels 和文档布局。自定义的 issue tracker 也可以。
