---
name: prototype
description: 构建一个一次性 prototype 来回答一个设计问题。适用于用户想检验某个 state model 或 logic 是否感觉对，或想探索 UI 应该长什么样时。
---

# Prototype

Prototype 是**用来回答一个问题的 throwaway code**。问题决定了它的形态。

## 选一个分支

识别正在回答的是哪个问题——从用户的 prompt、周围的代码中判断，或者在用户在线时直接询问：

- **"Does this logic / state model feel right?"** → [LOGIC.md](LOGIC.md)。构建一个很小的交互式终端应用，推动 state machine 跑过那些在纸面上难以推理的 case。
- **"What should this look like?"** → [UI.md](UI.md)。在单个路由上生成几种截然不同的 UI 变体，通过一个 URL search param 和一个浮动底栏来切换。

这两个分支会产出非常不同的 artifact——选错会浪费整个 prototype。如果问题确实含糊且用户联系不上，就默认选择与周围代码更匹配的那个分支（backend module → logic；page 或 component → UI），并在 prototype 顶部说明这一假设。

## 对两者都适用的规则

1. **从第一天起就是 throwaway，并且明确如此标记。** 把 prototype 代码放在它实际会被使用的地方附近（紧挨着它所 prototype 的 module 或 page），这样上下文一目了然——但命名要让随手一读的读者能看出它是 prototype，而不是 production。对于 throwaway 的 UI 路由，遵守项目已经在用的路由约定；不要发明一套新的顶层结构。
2. **一条命令即可运行。** 用项目现有 task runner 所支持的任何方式——`pnpm <name>`、`python <path>`、`bun <path>` 等等。用户必须能不假思索地启动它。
3. **默认不做持久化。** State 保存在内存里。持久化恰恰是 prototype 要_检验_的东西，而不是它应该依赖的东西。如果问题明确涉及数据库，就打到一个 scratch DB，或一个名字清楚标着 "PROTOTYPE — wipe me" 的本地文件。
4. **跳过打磨。** 不写 test，不做超出能让 prototype _跑起来_所需的 error handling，不做 abstraction。重点是快速学到东西。
5. **把 state 暴露出来。** 每次 action（logic）之后或每次变体切换（UI）之后，打印或渲染完整的相关 state，让用户看到发生了什么变化。
6. **完成后把它 capture 下来。** 把任何经过验证的决策折进真实代码，然后把 prototype 本身作为**一手来源**capture 下来：把它 commit 到一个 throwaway 分支上，放在 main 之外，并在实现 issue 上留一个指向该分支的 context pointer。也把答案 capture 下来——结论以及它所解决的问题——写进 issue 或 commit。main 分支只保留经过验证的决策。
