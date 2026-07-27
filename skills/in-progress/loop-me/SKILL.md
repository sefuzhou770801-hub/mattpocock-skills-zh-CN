---
name: loop-me
description: 在这个 workspace 内，就我想要构建的 workflows 的 specs 对我进行 grilling。
disable-model-invocation: true
argument-hint: "一个要设计的 workflow，或者留空让我去找一个"
---

运行一个有状态的 `/grilling` session，它唯一的输出是 **workflow** specs。使用 grilling 的纪律 —— 不留情面、一次一个问题、每个问题都附上一个推荐答案 —— 瞄准下面的 vocabulary 和 goal。随着 grilling 把事情敲定，创建、编辑和删除 specs。

## The loop lens

一个 **loop** 是用户生活中的一种重复模式：他们的 career、他们的 week、他们的 morning，或某一项重复的活动。把生活想象成 loops 之中嵌套的 loops，就能看出它的各项活动到底有多可预测 —— 而这正是它们值得被 **delegating** 的原因。用这个 lens 去发现值得写 spec 的 loops，并提出用户自己没注意到的那些。

一个 **workflow** 就是某一个 loop 的 spec，被落到实处。你在一个 loop 上运行一个 workflow —— 这个 loop 就是它正在运行的实例。Workflows 存放在 `workflows/*.md` 中，是 source of truth。

## Vocabulary

一套共享的语言，只在某个 workflow 需要时才去取用 —— 绝不是一份 checklist。**不要强制任何结构性内容**：除非 grilling 表明确实需要，否则一个 workflow 不需要 AI、不需要 checkpoint，也不需要 schedule。

- **Trigger** —— 每一次运行由什么触发：一个 **event**（一封新 email、一个新 issue）或一个 **schedule**（每天早晨）。Event-triggering 通常更高效。
- **Checkpoint** —— 一个 human-in-the-loop 的点，在这里请用户去验证或决策。有些 workflows 一个都没有，完全自主运行；有些根本不用 AI。
- **Push right** —— 把 checkpoint 尽可能往后推。在牵涉人之前先做掉最大量的工作，这样他们只会在很晚的时候被问一次，而一切都已准备就绪。
- **Brief** —— 一个 checkpoint 所呈现的东西：一份紧凑、可直接决策的 summary —— 产出了什么、为什么，以及一个直达 asset 本身的链接 —— 绝不是原始输出。用户读的是一份 brief，而不是一份 draft。Review 的速度至关重要。

## Definition of done

当一个 implementer agent 能在不问任何一个问题的情况下把它构建出来时，一个 workflow spec 才算完成。一直 grill 到那时为止；只要还有一个问题悬着，就什么都没完成。

## The workspace

- `workflows/*.md` —— 每个 workflow 一个 spec。
- `NOTES.md` —— 关于用户世界的原始笔记：他们使用的 tools、他们处理的 channels，以及他们对这两者的自有术语。当它为空或单薄时，先就他们的世界访谈他们，再去写任何 spec。当模糊的术语浮现时，把它们打磨成规范术语，并记录在这里。
