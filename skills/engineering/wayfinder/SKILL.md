---
name: wayfinder
description: 把一大块工作——大到单个 agent session 装不下的那种——规划成你 issue tracker 上的一张由 decision ticket 组成的共享地图，并逐个解决它们，直到通往目的地的路径变得清晰。
disable-model-invocation: true
---

一个松散的想法到来了——大到单个 agent session 装不下，而且裹在迷雾里：从这里到**目的地**的路还看不见。Wayfinding 的要义是找到那条路，而不是朝目的地猛冲。本 skill 把这条路绘制成仓库 issue tracker 上的一张**共享地图**，然后逐个处理它的 **decision ticket**——那些解决出来就是一个决策的问题，而不是要执行的构建切片——一次一个，直到路线清晰。

目的地因每次努力而异，而为它命名是绘制地图的第一个动作——它塑造每一个 ticket。它可能是一份要交接出去并反复迭代的 spec、一个要在规划开始前锁定的决策，或一项就地完成的变更（比如一次数据结构迁移）。这张地图与领域无关——工程工作、课程内容，任何符合这个形状的东西都行。

## Plan, don't do

Wayfinder 默认做的是**规划**：每个 ticket 解决一个决策，而当路径清晰——在有人动手去做那件事之前再没有什么需要决定的了——地图就算完成了。那种想干脆直接把活干了的冲动，通常正是你已经抵达地图边缘、该交接出去的信号。一次努力可以在它的 **Notes** 里覆盖这一点——把执行也带进地图本身——但若无此说明，就产出决策，而不是交付物。

## Refer by name

每张地图和每个 ticket 都是一个 issue，因此它有一个**名称**——它的标题。在人类会读到的一切内容里——叙述、地图的 Decisions-so-far——都用那个名称来指代它，绝不用光秃秃的 id、编号或 slug。一堵 `#42, #43, #44` 的墙是无法卒读的；名称一眼就能看懂。id 和 URL 并不会消失——名称包裹着它的链接——但它们骑在名称*里面*，绝不取而代之。

## The Map

地图是本仓库 issue tracker 上的单个 issue，标记为 `wayfinder:map`——它是规范产物。它的 ticket 是地图的子 issue。

地图是一个**索引**，而不是一个存储。它列出已做出的决策，并指向承载其细节的 ticket；一个决策恰好存在于一个地方——它的 ticket——所以地图绝不复述它，只做梗概并附上链接。

**地图、它的子 ticket、blocking 以及 frontier 查询在物理上落在哪里，是随 tracker 而定的。** issue tracker 应该已经提供给你了——如果没有，运行 `/setup-matt-pocock-skills`。查阅 tracker 文档的 "Wayfinding operations" 一节，了解*本*仓库如何表达它们。如果没有提供 tracker，就默认使用 local-markdown tracker。

### The map body

整张地图的低分辨率视图，每个 session 加载一次。未关闭的 ticket **不**列在其中——它们是未关闭的子 issue，通过查询找到。

```markdown
## Destination

<what reaching the end of this map looks like — the spec, decision, or change this effort is finding its way to. One or two lines; every session orients to it before choosing a ticket.>

## Notes

<domain; skills every session should consult; standing preferences for this effort>

## Decisions so far

<!-- the index — one line per closed ticket: enough to judge relevance, then zoom the link for the detail the ticket holds -->

- [<closed ticket title>](link) — <one-line gist of the answer>

## Not yet specified

<!-- see "Fog of war": in-scope fog you can't ticket yet; graduates as the frontier advances -->

## Out of scope

<!-- see "Out of scope": work ruled beyond the destination; closed, never graduates -->
```

### Tickets

每个 ticket 都是地图的一个**子 issue**；tracker 的 issue id 就是它的身份。它的正文就是那个问题，大小控制在单个 100K token 的 agent session 之内：

```markdown
## Question

<the decision or investigation this ticket resolves>
```

每个 ticket 携带一个 `wayfinder:<type>` 标签——`research`、`prototype`、`grilling`、`task` 之一（见 [Ticket Types](#ticket-types)）。

一个 session 通过把 ticket 指派给驱动这张地图的开发者来**认领**它，**首先**、在任何工作之前就这么做，这样并发的 session 就会跳过它。那个被指派人*就是*认领：一个未关闭、未被指派的 ticket 就是未被认领的。

Blocking 使用 tracker 的**原生**依赖关系——这一点至关重要，因为它在 tracker 自己的 UI 里把 frontier *可视化*地渲染出来，这样人类无需打开地图就能看到什么是可以拿走的。只有缺少原生 blocking 的 tracker 才退回到一种正文约定。当一个 ticket 的每一个 blocking 它的 ticket 都已关闭时，它就是**未被阻塞的**；**frontier** 就是那些未关闭、未被阻塞、未被认领的子项——已知世界的边缘。

答案不是正文的一部分——它在解决时被记录下来（见 [Work through the map](#work-through-the-map)）。解决一个 ticket 期间创建的资产从该 issue 链接出去，而不是粘贴进去。

## Ticket Types

每个 ticket 要么是 **HITL**——human in the loop，与一个为自己代言的人类*一起*工作——要么是 **AFK**，由 agent 独自驱动。一个 HITL ticket 只能通过那场实时交流来解决；agent 绝不替人类那一侧代言（一个自问自答的 grilling agent 就已经违背了这一点）。

- **Research**（AFK）：阅读文档、第三方 API，或像知识库这样的本地资源，以浮现某个决策正在等待的一个事实。由一个 `/research` **subagent** 解决。当需要当前工作目录之外的知识时使用。
- **Prototype**（HITL）：通过制作一个廉价、粗糙、具体的产物供人反应，来提升讨论的保真度——一个大纲、一个粗略的见解、一个 stub，或通过 /prototype skill 产出的 UI/logic 代码。把这个 prototype 作为一个资产链接起来。当 "how should it look" 或 "how should it behave" 是关键问题时使用。
- **Grilling**（HITL）：通过 /grilling 和 /domain-modeling skill 进行对话，一次一个问题。这是默认情形。
- **Task**（HITL 或 AFK）：在一个*决策*能够做出之前必须发生的手工工作——没有什么可决定、可 prototype 或可调研的，但在它完成之前讨论被卡住了。注册一个服务好让它的 API 能被评判、配置访问权限、搬动数据好让它的形状能被看见。这是唯一一个*去做*而非去决策的类型——而它之所以有立足之地，是因为它解锁了一个决策，而不是因为它交付了目的地。在能独自完成的地方由 agent 独自驱动它（AFK）；否则交给人类一份精确的清单（HITL）。工作完成时即告解决；答案记录做了什么，以及后来的 ticket 所依赖的任何由此产生的事实（凭证位置、新的 URL、行数）。

## Fog of war

地图是*刻意*不完整的：不要绘制你还看不见的东西。在活跃 ticket 之外躺着**战争迷雾**——那些你能看出正在到来、却还无法钉死的决策和调研的朦胧视野，因为它们悬置在仍然敞开的问题之上。解决一个 ticket 会清除它前方的迷雾，把此刻已可定义的东西毕业成新的 ticket——一次一个，直到通往目的地的路径清晰、再没有 ticket 剩下。

地图的 **Not yet specified** 一节就是那片朦胧视野被写下来的地方：疑似的问题、日后要重访的区域。它是*朝向*目的地的、尚未被发现的 frontier——这里的一切都在范围之内，只是还不够锐利、无法成为 ticket。按视野所允许的程度或松或满地写；它同时也是一个路标，供协作者阅读这次努力正走向何方。

**Fog or ticket?** 检验标准是此刻你能否精确地说出这个问题——而*不是*此刻你能否回答它。

- **Ticket when** 问题已经锐利——哪怕它被阻塞、你还无法对它采取行动。
- **Not yet specified when** 你还无法把它说得那么锐利。不要把迷雾预先切成 ticket 大小的碎片：它比一个 ticket 更粗，而一旦 frontier 抵达，一片迷雾可能毕业成好几个 ticket，也可能一个都没有。

**Not yet specified** 排除已经决定的东西（Decisions so far）、已经是活跃 ticket 的东西，以及超出范围的东西（下一节）。

## Out of scope

迷雾只会聚集在*朝向*目的地的方向。目的地固定了范围，因此超出它的工作就是**超出范围**——它不是迷雾，也不属于 **Not yet specified**。它在地图上有自己专属的 **Out of scope** 一节：你已有意把其排除在*本次*努力之外的工作。是范围、而非锐利度，让它落在这里。

超出范围的工作永远不会毕业——frontier 止于目的地——所以它只有在目的地被重新划定才会回来，而且那时是作为一项全新的努力，而不是一次续作。

把某样东西裁定为超出范围，是一个划定范围的动作，而不是路线上的一步。当一个已经存在的 ticket 结果落到了目的地之外——绘制地图时被错误地划了进来，或被某次解决所暴露——就**关闭它**（一个已关闭的 ticket 明确不在 frontier 上），并在 **Out of scope** 一节留下一行：梗概加上它为何超出范围，链接到那个已关闭的 ticket。它留在 **Decisions so far** 之外，后者记录的是实际走过的路线——一道范围边界不是它上面的一步。

## Invocation

两种模式。无论哪种，**每个 session 绝不解决多于一个 ticket**——research ticket 除外。

### Chart the map

用户带着一个松散的想法调用。

1. **Name the destination.** 运行一次 `/grilling` 和 `/domain-modeling` 会话，钉死这张地图正在寻路前往的东西——那份 spec、那个决策，或那项变更。目的地固定了范围，所以它最先被敲定。
2. **Map the frontier.** 再 grill 一次，这次采用**广度优先**：横扫整个空间，而不是在任何一条线索上深挖，浮现那些敞开的决策和此刻可走的第一步。**如果这没有浮现任何迷雾**——通往目的地的路径已经清晰，整段旅程小到单个 session 就能完成——你就不需要一张地图。停下来，询问用户想如何继续。
3. **Create the map**（标签 `wayfinder:map`）：填好 Destination 和 Notes，Decisions-so-far 留空，把迷雾勾勒进 **Not yet specified**。
4. **Create the tickets you can specify now**，作为地图的子 issue——然后在**第二遍**里接上 blocking edge（issue 需要先有 id 才能互相引用）。接线会把它们分拣进 frontier 和被阻塞者；凡是你还无法定义的都留在迷雾里——**Not yet specified** 一节。
5. **Fire the research subagents.** 对你刚刚创建的每一个 `research` ticket，启动一个 `/research` subagent 并行解决它，把它的发现捕获到一个一次性的 `research/<name>` 分支上，并从该 ticket 留下一个 context pointer。
6. 停下——绘制地图是一个 session 的工作；它不亲手解决任何东西。

### Work through the map

用户带着一张地图（URL 或编号）调用。一个 ticket 是**可选的**——没有它时，由你来挑选下一个决策，而不是用户。

1. 加载**地图**——低分辨率视图，而不是每个 ticket 的正文。
2. 选择 ticket。如果用户点名了一个，就用它。否则按顺序拿 frontier 上的第一个 ticket。**认领它**：在任何工作之前把它指派给你自己。
3. 解决它——**按需缩放**：按需获取任何相关或已关闭 ticket 的完整正文；调用 `## Notes` 块所点名的那些 skill。如果拿不准，就用 `/grilling` 和 `/domain-modeling`。
4. 记录这次解决：把答案作为一条**解决评论**发布，**关闭**该 issue，并向地图的 Decisions-so-far **追加一个 context pointer**。
5. 添加新浮现的 ticket（先创建再接线）；把答案已使其可定义的任何迷雾毕业掉，从 **Not yet specified** 中清除每一片已毕业的迷雾，让它只作为自己的新 ticket 存在。如果答案揭示出某个 ticket——这一个或另一个——落到了目的地之外，就把它**裁定为超出范围**，而不是在路线上解决它。如果这个决策使地图的其他部分失效，就更新或删除那些 ticket。

用户可能并行运行未被阻塞的 ticket，所以要预期其他 session 会在同时编辑这个 tracker。
