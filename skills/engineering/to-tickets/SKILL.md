---
name: to-tickets
description: 把一份 plan、spec 或当前对话拆解为一组 tracer-bullet ticket，每个 ticket 都声明它的 blocking edge，并发布到已配置的 tracker——本地时以文本形式写在每个 ticket 一个文件里，真实 tracker 上则用原生的 blocking 链接。
disable-model-invocation: true
---

# 转成 tickets

把一份 plan、spec 或对话拆解为一组 **ticket**——tracer-bullet 式的 vertical slice，每个 ticket 都声明那些 **block** 它的 ticket。

issue tracker 和 triage label 词汇表应该已经提供给你了——如果没有，运行 `/setup-matt-pocock-skills`。

## 流程

### 1. 收集背景

基于对话上下文中已有的任何东西来工作。如果用户把一个引用（一个 spec 路径、一个 issue 编号或 URL）作为参数传入，就获取它并读取其完整正文和评论。

### 2. 探索 codebase（可选）

如果你还没有探索过代码库，就探索一下以理解代码的当前状态。Ticket 的标题和描述应使用项目领域词汇表的词汇，并尊重你所涉及区域中的 ADR。

寻找对代码进行 prefactor 以让实现更容易的机会。"Make the change easy, then make the easy change."

### 3. 起草垂直 slice

把工作拆解为 **tracer bullet** 式的 ticket。

<vertical-slice-rules>

- 每个 slice 都切出一条窄但完整的路径，贯穿每一层（schema、API、UI、test）——是纵向的，而不是某一层的横向切片
- 一个完成的 slice 可以独立演示或独立验证
- 每个 slice 的大小要能装进单个全新的 context window
- 任何 prefactor 都应先完成

</vertical-slice-rules>

给每个 ticket 标出它的 **blocking edge**——那些必须在它开始之前完成的其他 ticket。一个没有 blocker 的 ticket 可以立即开始。

**宽幅 refactor 是 vertical slicing 的例外。** **宽幅 refactor** 是这样一种机械式变更——重命名一个列、重新标注一个共享符号的类型——其**波及半径**扇形展开覆盖整个代码库，以至于单次编辑就会一次性弄坏成千上万个调用点，没有任何 vertical slice 能以 green 落地。不要硬把它塞进 tracer bullet；而是把它编排为 **expand–contract**。先 expand：在旧形式旁边加上新形式，让什么都不被弄坏。然后按波及半径确定批次大小（按包、按目录），分批迁移调用点，每一批都是它自己的 ticket、被 expand 所 block，由于旧形式仍然存在，批次与批次之间 CI 保持 green。最后 contract：一旦没有任何调用方残留，就删掉旧形式，放在一个被每一个 migrate 批次所 block 的 ticket 里。当连各批次都无法独自保持 green 时，保留这个序列，但让它们共享一个 integration 分支，这些批次全部 block 一个最终的 integrate-and-verify ticket——只有在那里才承诺 green。

### 4. 追问用户

把提议的拆解方案作为一个带编号的列表呈现出来。对每个 ticket，展示：

- **Title**：简短的描述性名称
- **Blocked by**：哪些其他 ticket（如果有）必须先完成
- **What it delivers**：这个 ticket 让其跑通的端到端行为

询问用户：

- 粒度感觉对吗？（太粗 / 太细）
- blocking edge 正确吗——每个 ticket 是否只依赖那些真正 gate 它的 ticket？
- 有没有哪些 ticket 应该合并或进一步拆分？

反复迭代，直到用户认可这个拆解方案。

### 5. 把 tickets 发布到配置好的 tracker

发布已获认可的 ticket。**如何**发布取决于 `/setup-matt-pocock-skills` 所配置的 tracker——无论哪种情况 ticket 都是一样的，只有 blocking edge 的形态会变化：

- **Local files** → 在 `.scratch/<feature-slug>/issues/<NN>-<slug>.md` 下为每个 ticket 写一个文件，按依赖顺序（blocker 在前）从 `01` 开始编号。每个文件的 "Blocked by" 列出它所依赖的编号/标题。使用下面的单 ticket 文件模板——一个文件一个 ticket，绝不要做成单个合并文件。
- **真实 issue tracker（GitHub、Linear 等）** → 按依赖顺序（blocker 在前）为每个 ticket 发布一个 issue，好让每个 ticket 的 blocking edge 能引用真实的标识符。在平台有原生 blocking / sub-issue 关系的地方使用它；否则把每个 ticket 的 "Blocked by" 设为那些 blocking issue。除非另有指示，应用 `ready-for-agent` triage label——这些 ticket 按其构造就是可被 agent 领取的。

处理**前沿（frontier）**：任何 blocker 都已完成的 ticket。对于一条纯线性链条，那就意味着从上到下。

不要关闭或修改任何父 issue。

<local-ticket-template>

# <NN> — <Ticket title>

**What to build:** 这个 ticket 让其跑通的端到端行为，从用户的视角描述——不是一份逐层的实现清单。

**Blocked by:** gate 这个 ticket 的那些 ticket 的编号/标题，或 "None — can start immediately"。

**Status:** ready-for-agent

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2

</local-ticket-template>

<issue-template>

## 父级

tracker 上父 issue 的一个引用（如果来源是一个已存在的 issue，否则省略本节）。

## 要构建什么

这个 ticket 让其跑通的端到端行为，从用户的视角描述——不是逐层的实现。

## 验收标准

- [ ] Criterion 1
- [ ] Criterion 2

## 被阻塞于

- 对每个 blocking ticket 的一个引用，或 "None — can start immediately"。

</issue-template>

无论哪种形式，都避免具体的文件路径或代码片段——它们很快就会过时。例外：如果某个 prototype 产出了一段比散文更能精确编码某个决策的片段（state machine、reducer、schema、type 形状），就把它内联，并简要注明它来自一个 prototype。裁剪到富含决策的部分——不是一个可运行的 demo，只是重要的那几处。
