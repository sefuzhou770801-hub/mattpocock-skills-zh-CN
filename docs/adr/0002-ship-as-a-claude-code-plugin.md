# Ship the skill set as a native Claude Code plugin; defer a native Codex plugin

这些 skills 一直可以通过 [skills.sh](https://skills.sh/vinvcn/mattpocock-skills-zh-CN)（`npx skills add vinvcn/mattpocock-skills-zh-CN`）安装，它会把可编辑的 skill 文件复制进用户的项目，覆盖 Claude Code、Codex 以及其他兼容 Agent Skills 标准的 harnesses。一个反复出现的需求是 **plug-and-play** 分发：把这套 skills 作为一个只读、始终最新的 bundle 来订阅，而不是一个你自己拥有的 fork。这正是原生 plugin 系统所提供的。

我们发布一个原生 **Claude Code plugin**，并暂时 **defer** 原生 **Codex plugin**。这种拆分是由各个生态的 plugin manifest 如何选择 skills 所强制决定的，对照的是本仓库分 bucket 的布局。

## The constraint: bucketed skills vs. single-path selection

Skills 存放在 `skills/` 下的 bucket folder 里——`engineering/` 和 `productivity/` 是 **promoted**（会发布）；`misc/`、`personal/`、`in-progress/` 和 `deprecated/` 则 **不是**。一个 plugin 必须只暴露 promoted 集合，而它横跨其中两个 bucket folder。

- **Claude Code** —— `.claude-plugin/plugin.json` 把 `skills` 接受为一个 **由显式 skill 目录路径组成的数组**。我们逐个列出 promoted skills，毫无歧义地排除其他一切，并加上 `.claude-plugin/marketplace.json`，使本仓库成为它自己的单 plugin marketplace。已端到端验证：`claude plugin validate . --strict` 通过，且 `marketplace add` → `install` 能解析出所有 promoted skills。

- **Codex** —— `.codex-plugin/plugin.json` 只把 `skills` 接受为一个 **单一 path 字符串**（数组会被以 `missing or invalid plugin.json` 拒绝），并且 Codex 会在其下递归发现 `SKILL.md` 文件。没有办法从单个 path 指名两个 bucket folder，或精选一个子集。测试过两条逃生通道，都被否决：
  - 指向 `./skills/` 会同时发布 `deprecated/`、`in-progress/`、`personal/` 和 `misc/`——那些我们刻意不推广的已弃用、草稿和个人 skills。
  - 一个由指向各 bucket 的 **symlinks** 组成的精选扁平目录无法在安装后存活：Codex 会把 plugin 树复制进它的缓存并 **丢弃 symlinks**，于是 skills 到达时是空的。

要给 Codex 一个单一的、仅含 promoted 的 path，唯一稳健的办法是 (a) **重构**，使 `skills/` 只包含 promoted skills（把非 promoted buckets 移出去——在 `CLAUDE.md`、`scripts/link-skills.sh`、各 bucket README，以及依赖 `in-progress/` 和 `personal/` 的本地开发工作流上都有很大的影响半径），或 (b) 把 promoted skills 的 **重复副本** 提交进一个扁平目录（同步负担，以及第二个 source of truth）。两者都是结构性决策，不该捆绑进发布 Claude plugin 这件事里。这非常可能就是当初没有更早发布 plugin 的、被记了一半的原因：manifest 格式无法干净地表达一个分 bucket 仓库的精选子集。

## Decision

- 现在就发布 **Claude Code plugin**（`.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json`），精选到 promoted 集合，作为 v1.2 的头号交付物。
- 保留 **skills.sh** 作为通用 installer——它如今已经服务于 Codex 和其他 harnesses，所以不会有 Codex 用户没有安装路径。
- **Defer** 原生 Codex plugin，直到我们在“把 `skills/` 重构为仅含 promoted”与“提交一个生成的扁平副本”之间做出决定。等 Codex 支持 `skills` 数组 / include-list，或在安装时保留 symlinks，再重新评估。

## Invariants this creates

- 每个 promoted skill 在 `.claude-plugin/plugin.json` 的 `skills` 数组里都有一个条目（这本已是一条 `CLAUDE.md` 规则；如今它同时也把关 plugin 的内容）。
- `.claude-plugin/plugin.json` 的 `version` 跟随 `package.json` 的版本——发布时两者一起 bump。Claude 用 plugin 的 `version` 来决定安装用户何时看到更新。
