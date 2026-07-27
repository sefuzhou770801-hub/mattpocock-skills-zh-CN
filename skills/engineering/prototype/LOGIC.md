# Logic Prototype

一个很小的交互式 terminal app，让用户手动驱动一个 state model。当问题关乎**业务逻辑、state transitions 或 data shape** 时使用它 —— 就是那种纸面上看起来合理、但只有用真实用例推演一遍才会感觉到不对劲的东西。

## 何时这是合适的形态

- "I'm not sure if this state machine handles the edge case where X then Y."
- "Does this data model actually let me represent the case where..."
- "I want to feel out what the API should look like before writing it."
- 任何用户想**按按钮、看着 state 变化**的情况。

如果问题是 "what should this look like" —— 走错分支了。用 [UI.md](UI.md)。

## 流程

### 1. 陈述问题

在写代码之前，写下你要 prototype 的是什么 state model、要回答什么问题。一段话即可，放在 prototype 的 README 里或文件顶部的 comment 里。一个回答了错误问题的 logic prototype 纯属浪费 —— 把问题显式写出来，这样以后才能核对，无论用户此刻是否在看，还是之后 AFK 回来再看。

### 2. 选定语言

用宿主项目所用的语言。如果项目没有明显的 runtime（例如一个 docs repo），就问。

在工具方面匹配项目现有的约定 —— 不要只为这个 prototype 引入一个新的 package manager 或 runtime。

### 3. 把逻辑隔离进一个可移植的 module

把真正的逻辑 —— 也就是回答问题的那部分 —— 放在一个小而纯的 interface 后面，它以后可以被拎出来直接放进真实 codebase。外围的 TUI 是一次性的；逻辑 module 不应该是一次性的。

正确的形态取决于问题：

- **一个纯 reducer** —— `(state, action) => state`。当 action 是离散事件、state 是单个值时适用。
- **一个 state machine** —— 显式的 state 与 transitions。当 "此刻到底哪些 action 是合法的" 本身就是问题的一部分时适用。
- **一组针对某个普通 data type 的纯函数**。当没有隐含的当前 state、只有变换时适用。
- **一个 class 或带有清晰方法面的 module**，当逻辑确实拥有持续的内部 state 时。

挑最贴合所提问题的形态，而*不是*最容易接到 TUI 上的那个。保持纯净：不要 I/O，不要 terminal 代码，不要用 `console.log` 做控制流。TUI 导入它并调用它；没有任何东西反向流动。

正是这一点让 prototype 在自身生命周期之后仍然有用：当问题被回答后，经过验证的 reducer / state machine / 函数集可以单独被拎进真实的 module。

### 4. 构建暴露该 state 的最小 TUI

把它做成一个**轻量 TUI** —— 每个 tick 都清屏（`console.clear()` / `print("\033[2J\033[H")` / 等价做法）并重新渲染整帧。用户应该始终看到一个稳定的视图，而不是不断增长的滚屏。

每一帧有两部分，按此顺序：

1. **当前 state**，美观打印且便于 diff（每行一个字段，或格式化的 JSON）。字段名或分节标题用**粗体**，次要的上下文（时间戳、ID、派生值）用**暗色**。原生 ANSI 转义码就够用 —— `\x1b[1m` 粗体、`\x1b[2m` 暗色、`\x1b[0m` 重置。除非项目里已经有样式库，否则不必引入。
2. **键盘快捷键**，列在底部：`[a] add user  [d] delete user  [t] tick clock  [q] quit`。按键加粗、描述暗色，或反过来 —— 怎么读着清爽怎么来。

行为：

1. **初始化 state** —— 一个内存中的 object/struct。启动时渲染第一帧。
2. **一次读一个按键（或一行）**，分派给一个修改 state 的处理器。
3. **每个动作之后重新渲染**整帧 —— 不要追加，要替换。
4. **循环直到退出。**

整帧应该能放进一屏。

### 5. 让它一条命令就能跑

往项目现有的 task runner 里加一个脚本（`package.json` scripts、`Makefile`、`justfile`、`pyproject.toml`）。用户应该运行 `pnpm run <prototype-name>` 或等价命令 —— 永远不需要记住某个路径。

如果宿主项目没有 task runner，就把命令写在 prototype 的 README 顶部。

### 6. 交付

把运行命令交给用户。他们会自己驱动它；有意思的时刻是他们说出 "wait, that shouldn't be possible" 或 "huh, I assumed X would be different" 的时候 —— 那些就是*想法*里的 bug，而这正是全部意义所在。如果他们想加新的 action，就加。prototype 是会演化的。

### 7. 捕获答案与 prototype

一旦 prototype 回答了它的问题，先把答案记录下来，然后按 [SKILL](SKILL.md) 描述的方式把 prototype 记录下来。logic 专属的对应关系：经过验证的 reducer / state machine / 函数集被拎进真实的 module（决策，已被吸收）；TUI 外壳则随之一同进入那个一次性分支，该分支把 prototype 作为 primary source 保存。

## 反模式

- **不要加 test。** 一个需要 test 的 prototype 已经不再是 prototype 了。
- **不要把它接到真实数据库。** 用内存存储，除非问题专门关乎持久化。
- **不要泛化。** 不要 "what if we wanted to support X later"。这个 prototype 回答一个问题。
- **不要把逻辑和 TUI 搅在一起。** 如果 reducer / state machine 引用了 `console.log`、提示符或 terminal 转义码，它就不再可移植了。让 TUI 保持为纯 module 外面的一层薄壳。
- **不要把 TUI 外壳发布到生产环境。** 这个外壳是为从 terminal 手动驱动而优化的。它背后的逻辑 module 才是值得保留的部分。
