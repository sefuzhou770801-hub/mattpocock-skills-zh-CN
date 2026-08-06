# Logic Prototype

单个自包含 HTML 文件——一份 **shareable demo**——让任何人通过点按钮驱动 state model。用于问题围绕 **business logic、state transitions 或 data shape** 的场景，也就是纸面上看起来合理，但只有跑过真实 cases 才会感觉哪里不对的东西。

因为它是单文件、无需安装，你可以交给非开发者——designer、PM、domain expert——让他们自己感受这个 model。所以它说的是他们的语言，不是代码的语言。

## When this is the right shape

- "I'm not sure if this state machine handles the edge case where X then Y."
- "Does this data model actually let me represent the case where..."
- "I want to feel out what the API should look like before writing it."
- 任何有人想**按按钮并观察 state 变化**的情况。

如果问题是 “what should this look like”，这是错误分支。使用 [UI.md](UI.md)。

## Process

### 1. State the question

写代码前，先写下你正在 prototype 哪个 state model、回答什么问题。一段即可，放在 demo 顶部（可见的 intro，不只是 comment）。回答错问题的 logic prototype 纯属浪费；把问题显式写出来，这样无论用户现在旁观，还是之后 AFK 回来看，都能检查。

### 2. Isolate the logic in a portable module

把真正的 logic，也就是回答问题的那部分，放在单个 `<script>` 块里，写成小而纯粹的 module，之后可以拿出来放进真实 codebase。包在外面的页面是 throwaway；这个 module 不是。

合适形状取决于问题：

- **A pure reducer** — `(state, action) => state`。适合 actions 是离散 events、state 是单个值的场景。
- **A state machine** — 显式 states 和 transitions。适合 “现在到底哪些 actions 合法” 本身就是问题的一部分。
- **一组作用于 plain data type 的 pure functions**。适合没有隐式 current state，只有 transformations 的场景。
- **Class 或带清晰 method surface 的 module**，当 logic 确实拥有持续的 internal state。

选择最适合问题的形状，而不是最容易接到页面上的形状。保持 pure：不要 DOM，不要 `document`，不要让 button handlers 伸进内部。页面调用它；不要反向依赖。这让 prototype 在自身生命周期之后仍有价值：问题被回答后，验证过的 reducer / machine / function set 可以独立搬进真实 module。

### 3. Build the shareable HTML file

一个文件，纯 HTML/CSS/JS——不要 framework、不要 bundler、不要 server，全部内联，这样双击即可打开，转发邮件也还活着。任何人打开就能跑。

为非开发者写。每个 label 用 **domain language**，不是 code——按钮和 state 读起来像业务，不像 reducer。用白话解释正在发生什么。

从上到下用清晰层次布局：

1. **Title and one-line explanation**——这份 demo 让你探索什么（第 1 步的问题）。
2. **Current state**——完整相关 state，渲染成可读面板（带标签的 fields，不是原始 JSON dump），每次点击后重绘，让变化可见。对非开发者有帮助时，标出刚刚变了什么。
3. **Free-play buttons**——每个 action 一个按钮，始终可用，任何人可以任意顺序戳这个 model。每次点击 dispatch 对应 action 并重绘 state。
4. **Guided walkthroughs**——一组 **scenarios**，每个一个 tab。每个 tab 用简短白话说明场景——它建立什么处境、该盯什么——下面是该场景的有序 **buttons to press**。每一步是真实按钮：点它就执行该 action 并前进到下一步。开始 walkthrough 时重置到已知 initial state，保证场景每次跑法相同。

选择能展示别扭 cases 的 scenarios——happy path、棘手 edge case、试图做不该允许的事——那些纸面上难以推理的。

保持漂亮但克制：干净排版、充裕间距、一种 accent colour。不要 animations，不要 gimmicks——任何与 state 和按钮抢注意力的东西都不要。

### 4. Hand it over

把文件发给他们，或为他们打开。他们会在方便时点完 walkthroughs 和 free-play；真正有趣的时刻是他们说 “wait, that shouldn't be possible” 或 “huh, I assumed X would be different”——那些是*想法*里的 bug，也正是 prototype 的目的。如果他们想要新 actions 或新 scenario，就添加。Prototypes 会演进。

### 5. Capture the answer and the prototype

Prototype 回答问题后，capture answer，再按 [SKILL](SKILL.md) 描述的方式 capture prototype。Logic-specific mapping：验证过的 reducer / machine / function set 搬进真实 module（吸收 decision）；HTML shell 跟随 prototype 留在作为 primary source 的 throwaway branch——而且作为自包含单文件，在那里仍能轻易重新运行。

## Anti-patterns

- **不要加 tests。** 需要 tests 的 prototype 已经不再是 prototype。
- **不要接真实 database。** 除非问题专门关于 persistence，否则使用 in-memory state。
- **不要 generalise。** 不要做 “what if we wanted to support X later”。Prototype 回答一个问题。
- **不要把 logic 和页面混在一起。** 如果 pure module 引用了 DOM、`document` 或 button handlers，它就不再 liftable。让页面作为 pure module 外面的薄 shell。
- **不要碰 framework、bundler 或 server。** 接收方双击一个文件；React app 或 dev server 会毁掉 “shareable”。
- **不要把 HTML shell 发到 production。** 页面是为手动点选优化的。它背后的 logic module 才是值得保留的部分。
