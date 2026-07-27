---
name: code-review
description: 从一个固定点（commit、branch、tag 或 merge-base）开始，沿两条轴线审查其后的变更 — Standards（代码是否遵循本仓库已记录的编码标准？）和 Spec（代码是否符合来源 issue/PRD 的要求？）。在并行的 sub-agent 中运行这两项审查，并并排报告。当用户想审查一个 branch、一个 PR、进行中的变更，或要求 “review since X” 时使用。
---

对 `HEAD` 与用户提供的固定点之间的 diff 做双轴审查：

- **Standards** — 代码是否符合本仓库已记录的编码标准？
- **Spec** — 代码是否忠实地实现了来源的 issue / PRD / spec？

两条轴线都作为**并行的 sub-agent** 运行，这样它们不会污染彼此的 context，然后由本 skill 汇总它们的发现。

issue tracker 应该已经提供给你了 — 如果 `docs/agents/issue-tracker.md` 缺失，请运行 `/setup-matt-pocock-skills`。

## 流程

### 1. 钉住固定点

无论用户说的是什么，那就是固定点 — 一个 commit SHA、branch 名、tag、`main`、`HEAD~5` 等等。如果他们没指定，就问。

把 diff 命令一次性确定下来：`git diff <fixed-point>...HEAD`（三点式，这样比较的是针对 merge-base）。同时通过 `git log <fixed-point>..HEAD --oneline` 记下 commit 列表。

在继续之前，确认固定点可以解析（`git rev-parse <fixed-point>`）且 diff 非空。一个坏的 ref 或空 diff 应该在这里就失败 — 而不是在两个并行的 sub-agent 里面。

### 2. 确定 spec 来源

按以下顺序寻找来源 spec：

1. commit message 中的 issue 引用（`#123`、`Closes #45`、GitLab `!67` 等）— 通过 `docs/agents/issue-tracker.md` 中的 workflow 获取。
2. 用户作为参数传入的路径。
3. `docs/`、`specs/` 或 `.scratch/` 下与 branch 名或 feature 匹配的 PRD/spec 文件。
4. 如果什么都没找到，就问用户 spec 在哪里。如果他们说没有，**Spec** sub-agent 就跳过，并报告 “no spec available”。

### 3. 确定标准来源

仓库中任何记录了代码应如何编写的东西，例如 `CODING_STANDARDS.md` 或 `CONTRIBUTING.md`。

在仓库所记录的内容之上，Standards 轴始终携带下面的 **smell baseline** — 一组固定的 Fowler code smells（_Refactoring_ 第 3 章），即使一个仓库什么都没记录它也适用。有两条规则约束它：

- **仓库优先。** 已记录的仓库标准总是胜出；当它认可了 baseline 会标记的东西时，抑制该 smell。
- **永远是判断题。** 每个 smell 都是一个带标签的启发式（“possible Feature Envy”），绝不是硬性违规 — 而且，和这里的任何标准一样，跳过工具已经在强制执行的任何东西。

每个 smell 的读法是 *它是什么* → *如何修复*；把它对照 diff：

- **Mysterious Name** — 一个函数、变量或类型，其名字没有揭示它做什么或持有什么。→ 重命名它；如果想不出一个诚实的名字，说明设计是浑浊的。
- **Duplicated Code** — 同一种逻辑形状在变更的多个 hunk 或文件中出现。→ 提取共享的形状，从两处调用它。
- **Feature Envy** — 一个方法伸手去够另一个对象的数据，多过它自己的。→ 把这个方法移到它所嫉妒的数据上。
- **Data Clumps** — 同样几个字段或参数总是结伴而行（一个想要诞生的类型）。→ 把它们打包成一个类型，传那个类型。
- **Primitive Obsession** — 一个 primitive 或字符串顶替了一个理应拥有自己类型的 domain 概念。→ 给这个概念它自己的小类型。
- **Repeated Switches** — 针对同一类型的同一个 `switch`/`if` 级联在整个变更中反复出现。→ 用多态替换，或用两处共享的一个 map。
- **Shotgun Surgery** — 一个逻辑变更迫使 diff 中跨多个文件的零散编辑。→ 把一起变化的东西收进一个 module。
- **Divergent Change** — 一个文件或 module 因为几个不相关的原因被编辑。→ 拆分，使每个 module 只因一个原因而变化。
- **Speculative Generality** — 为 spec 并不需要的需求而添加的抽象、参数或 hook。→ 删掉它；内联回去，直到出现真正的需求。
- **Message Chains** — 调用方不应依赖的长串 `a.b().c().d()` 导航。→ 把这串行走藏到第一个对象上的一个方法后面。
- **Middle Man** — 一个基本上只是向下委派的类或函数。→ 砍掉它，直接调用真正的目标。
- **Refused Bequest** — 一个子类或实现者忽略或覆盖了它所继承的大部分内容。→ 放弃继承，改用组合。

### 4. 并行派发两个 sub-agents

发送一条包含两个 `Agent` 工具调用的消息。两者都使用 `general-purpose` subagent。

**Standards sub-agent prompt** — 包含：

- 完整的 diff 命令和 commit 列表。
- 你在第 3 步找到的 standards-source 文件列表，**外加第 3 步的 smell baseline**，完整粘贴进去 — sub-agent 没有其他途径访问它。
- 任务简报："Report — per file/hunk where relevant — (a) every place the diff violates a documented standard: cite the standard (file + the rule); and (b) any baseline smell you spot: name it and quote the hunk. Distinguish hard violations from judgement calls — documented-standard breaches can be hard, but baseline smells are always judgement calls, and a documented repo standard overrides the baseline. Skip anything tooling enforces. Under 400 words."

**Spec sub-agent prompt** — 包含：

- diff 命令和 commit 列表。
- spec 的路径或已获取的内容。
- 任务简报："Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Under 400 words."

如果 spec 缺失，跳过 Spec sub-agent，并在最终报告中注明这一点。

### 5. 汇总

把两份报告分别呈现在 `## Standards` 和 `## Spec` 标题下，逐字保留或只做轻微清理。**不要**合并或重新排序发现 — 两条轴线是刻意分开的（见 _Why two axes_）。

以一行总结收尾：每条轴线的发现总数，以及_每条轴线内部_最严重的问题（如果有）。不要跨轴线挑出一个唯一的赢家 — 那正是这种分离所要防止的重新排序。

## 为什么是两条轴

一个变更可能通过一条轴线却在另一条上失败：

- 遵循了每一条标准、却实现了错误东西的代码 → **Standards 通过，Spec 失败。**
- 完全做到了 issue 所要求的、却破坏了项目约定的代码 → **Spec 通过，Standards 失败。**

分开报告它们，可以防止一条轴线掩盖另一条。
