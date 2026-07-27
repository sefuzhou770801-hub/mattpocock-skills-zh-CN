Quickstart:

```bash
npx skills add vinvcn/mattpocock-skills-zh-CN --skill=ask-matt
```

```bash
npx skills update ask-matt
```

[Source](https://github.com/vinvcn/mattpocock-skills-zh-CN/tree/main/skills/engineering/ask-matt)

## What it does

`ask-matt` 是本仓库所有 skills 之上的 router。你描述自己身处的情境，它告诉你哪个 skill 或 flow 合适，以及按什么顺序运行。

它**本身不做任何工作**。它不 grilling、不写 spec、也不修任何东西——它只负责定位方向。它首先是为那些 **user-invoked** skills 而存在的：没有任何东西会替你触发它们，所以*你*必须自己记得它们存在，而 `ask-matt` 就是你把这份记忆卸载出去的地方。它也会指向那些你会按名字去用的 model-invoked skills——`/tdd`、`/diagnosing-bugs`、`/prototype`、`/code-review`，以及两个词汇参考，`/domain-modeling` 和 `/codebase-design`。它回答「用哪一个、什么时候用」，然后把你交接给真正干活的那个 skill。

## When to reach for it

你通过输入 `/ask-matt` 来调用它——agent 不会自己去拿它。

每当你不确定某个情境该用哪个 skill 或 flow 时，就用它：你有一个 idea 却不知道从哪开始；你有一堆 bug report 却不知道它们是不是该交给 `/triage`；或者有两个看起来可以互换的 skill 而你分不清它们。如果你已经知道想要哪个 skill，就跳过 router，直接调用它。

## Flows, not just skills

`ask-matt` 给你用来思考的那个概念是 **flow**——一条*穿过*各个 skills 的路径，而不是单个 skill。大多数工作都沿着一条 **main flow** 行进（idea → ship：grill → spec → tickets → implement → review），有两条 **on-ramp** 汇入它（一条处理进来的 bug 和请求的 triage 通道；一条生成 idea 的 codebase-health 通道），其余一切都是各自独立取用的 **standalone**。提一个问题，你就会被放到正确的 flow 上、正确的步骤处——而不只是被递到一个工具。

## Where it fits

`ask-matt` 是那个 **router**——悬于整套 skills 之上的独立地图。它是其他每一个 docs 页面都回链到的节点，即 [ask-matt](https://aihero.dev/skills-ask-matt)，所以它从不*处在*某条链*之中*；它指向*每一条*链的入口。从这里你最常落到 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)——main flow 的起点，或者 [triage](https://aihero.dev/skills-triage)——那些不是你发起的工作的 on-ramp。当连 router 自己的图景都过时了，它的 [Source](https://github.com/vinvcn/mattpocock-skills-zh-CN/tree/main/skills/engineering/ask-matt) 就是那份权威的地图。
