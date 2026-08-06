# Phase boundaries

**Phase** 是 session 内的一块工作——grilling、implementation、QA。定义故意模糊：当你觉得 *「好，这块做完了」* 时，一个 phase 就结束了。

**Phase boundary** 是两个 phase 之间的空隙，也是这个决策唯一该出现的地方。Phase 中途没有决策可做——继续，或把剩下的工作拆给 subagents。在 phase 中途 compact 会让 agent 丢线。

## The five options

| Option       | What it does                                                    |
| ------------ | --------------------------------------------------------------- |
| **Continue** | 留在本 session。完全不切换 context。                              |
| **`/clear`** | 清空 context window，从零开始。                                   |
| **`/handoff`** | 写出可移植的 markdown 文件，用它在任何地方播种新 session。      |
| **Subagent** | 把任务送到自己的 context window，拿回报告。                       |
| **`/compact`** | 压缩当前 context，用摘要播种新 session。                        |

## The tree

在 boundary 上从上往下问。第一个 **yes** 胜出。

**1. 能在这个 session 里继续吗？** 两件事会让答案变成 yes：下一个 phase 需要把这个 phase 当作 **primary source**，或者你还剩足够的 [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)（约 150k tokens）装得下下一个 phase。Grilling → implementation 是标准 yes：implementation 要的是逐字 reasoning，不是摘要。Continue 零成本、零损失，所以先排除它再说别的。

**2. 对接下来的事来说，当前 context 是否无关？** 这个 session 里的一切——探索、决策、死胡同——是否都可以丢掉？若是，**`/clear`**。它是棋盘上最便宜的一步：不花时间，整窗交还。`/clear` 也不是终点——旧 session 仍可 resume。

搞错代价是单向的。清空 *仍相关* 的 context，你会丢掉构建背后的 **why**，再怎么回头读 diff 也找不回来。

**3. 需要 hand off 吗？** `/handoff` 很窄。只有这些情况才需要：

- 换到 **新 harness**（Claude → Codex），
- 换到 **新 directory** 或 repo，
- 把工作交给 **同事**，
- 或在 **phase 中途** 分叉一个旁支任务，又不想打乱当前事。

这份列表就是全部条款。`/handoff` 买到的是 **portability**——一份能带走的文件。没有东西要带走，就不需要它。

**4. 任务能 AFK 完成吗？** 是否收得足够紧，可以在你离开键盘、无需转向的情况下跑？那就送给 **subagent**，本 session 不动。Automated review 是标准情形：agent 读 diff 并报告，期间不需要你。

**5. 否则，`/compact`。** Context 仍相关、同一 harness、同一 directory，且你需要留在环里——树常落在这里，也确实常落在这里。给它一条指令（`/compact we're going to QA this area`），让摘要保留下一个 phase 需要的东西。

`/compact` 是 **默认，不是第一选择**。它坐在底部，因为上面四个问题都更便宜或更精确。人们从这里起手时的失败模式是：新 session 对摘要压扁过的 decision 自信地讲错。

## Primary and secondary sources

除 **Continue** 外，每一步都把 **primary source** 变成 **secondary source**——当时发生的 session，被它的摘要替换。这笔交易形状总是一样：

| Source                            | Information | Noise | Room to move |
| --------------------------------- | ----------- | ----- | ------------ |
| Primary (Continue)                | Full        | Lots  | Little       |
| Secondary (`/compact`, `/handoff`) | Lossy       | Less  | Lots         |

所以问题 1 排第一。只有当留下的代价大于收益时，你才支付这种 lossiness。

## These are judgement calls

这些问题不是客观的——每条都带品味，同一边界两天可能走两条路。价值在于 **按顺序** 问它们，在 boundary 上问，而不是在工作中途问。
