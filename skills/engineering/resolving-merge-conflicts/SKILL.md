---
name: resolving-merge-conflicts
description: "适用于需要解决正在进行的 git merge/rebase 冲突时。"
---

1. **查看 merge/rebase 的当前状态**。检查 git 历史，以及发生冲突的文件。

2. **为每个冲突找到一手来源**。深入理解每一处变更为何而做，以及最初的意图是什么。阅读 commit message，查看 PR，查看原始的 issue/ticket。

3. **逐个 hunk 解决。** 在可能的地方同时保留双方的意图。在二者不兼容时，选择与本次 merge 既定目标相符的那一方，并记下其中的取舍。**不要**凭空发明新的行为。始终去解决冲突；绝不 `--abort`。

4. 找出项目的**自动化检查**并运行它们——通常是先 typecheck，再 test，然后 format。修复 merge 弄坏的任何东西。

5. **完成 merge/rebase。** 把所有东西 stage 起来并 commit。如果是在 rebase，就继续 rebase 流程，直到所有 commit 都 rebase 完毕。
