---
name: setup-ts-deep-modules
description: 把 dependency-cruiser 接入一个 TypeScript repo，让每个 package 都是一个 deep module —— implementation 隐藏在 subfolders 中，只能通过其 entry-point files 访问。User-invoked。
disable-model-invocation: true
---

# Setup TS Deep Modules

让这个 repo 中的每一个 package 都成为一个 **deep module**：大量的 behaviour 藏在一个小 interface 后面。一个 package 的公开表面是它的 **entry points** —— package 根部的那些文件 —— 而其 subfolders 中的一切都是隐藏的。这个 skill 会安装 [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) 以及让 entry points 成为唯一入口的规则，然后证明这些规则确实会咬人。

关于 vocabulary（deep module、interface、seam、depth），运行 `/codebase-design` skill —— 全程使用它的语言。

## The shape this enforces

```
src/packages/
  <name>/
    index.ts        ← an entry point (public). Import this from outside.
    client.ts       ← another entry point. Packages may expose SEVERAL.
    lib/            ← implementation: hidden from outside, free to import each other.
    tests/          ← co-located tests + fixtures (a subfolder, so private).
```

公开表面是这个 package 的 **root files** —— 而不是某一个指定的 `index.ts`。按惯例，implementation 放在 `lib/`，tests 放在 `tests/`，让每个 package 都拥有同样的 two-folder 形状。不过这条规则本身是通用的：*任何* subfolder 里的*任何*东西都是 private，所以你永远不需要为了新增一个 folder 而去扩展 config。

四条规则，全部为 `error`：

1. **Entry-point boundary** —— package 外部的代码（app 代码或另一个 package）只能 import 该 package 的 entry points（它的 root files），绝不能 import 它 subfolders 里的任何东西。
2. **Intra-package freedom** —— 一个 package 自己的文件之间可以自由互相 import。
3. **Tests through the entry points** —— `<pkg>/tests/` 下的文件可以 import 任何 package 的 entry points 以及它们自己 `tests/` 里的 fixtures，但绝不能 import 任何 package 的 subfolder 内部实现（连自己的也不行）。跨 package 的 integration tests 没问题；deep imports 不行。
4. **No cycles** —— 不允许依赖环。

**Entry points, not a barrel.** 因为公开表面是*每一个* root file，一个 package 可以暴露多个小的 entry points（`index.ts`、`client.ts`、`server.ts`），而不必把一切都塞进一个巨大的 `index.ts`。那种 re-export 整棵子树的 barrel files 是不鼓励的 —— 让 entry points 保持小巧，把 implementation 藏在 subfolders 里。

分层（哪些 package 可以依赖哪些）是一个*不同的*关注点，在这个 repo 的 config 里以一段注释掉的 stub 形式留白，供填写。

## Steps

### 1. Detect the environment

- **Package manager** —— `pnpm-lock.yaml` → pnpm，`yarn.lock` → yarn，`bun.lockb` → bun，否则 npm。下面的每一条命令都用它（`pnpm`/`yarn`/`npm run`/`bunx`）。
- **Packages root** —— 如果存在 `src/` 就用 `src/packages`，否则用 `packages`。如果 repo 已经有另一个明显的惯例，跟用户确认这个选择。
- **Existing config** —— 检查是否已有 `.dependency-cruiser.*` 文件。如果存在，**不要**覆盖它：把这四条规则和 options 合并进去，并告诉用户你添加了什么。

**Done when:** package manager、packages root 以及 existing-config 的状态都已明确。

### 2. Install dependency-cruiser

用检测到的 package manager，把 `dependency-cruiser` 作为 devDependency 安装。

**Done when:** `dependency-cruiser` 出现在 `devDependencies` 中。

### 3. Write the config

把 [`dependency-cruiser.config.cjs`](./dependency-cruiser.config.cjs) 复制到 repo 根部，命名为 `.dependency-cruiser.cjs`。把 `PACKAGES_ROOT` 设为第 1 步检测到的 root。这些规则基于路径深度、与扩展名无关，所以没有其它需要适配的地方。

**Done when:** `.dependency-cruiser.cjs` 存在，`PACKAGES_ROOT` 正确，且四条 forbidden 规则都在。

### 4. Wire it into the checks

- 添加一个 `lint:boundaries` script：`depcruise <packages-root>`（或 `depcruise src`）。
- 把它并入 repo 的总检查命令 —— 那个已经在跑 typecheck 的命令（例如 `check` / `ci` / `validate` script）。**不要**去动 `tsconfig` 或添加 path aliases。
- 如果没有总 script，就添加 `lint:boundaries`，并告诉用户把它纳入 CI。

**Done when:** `lint:boundaries` 存在，并且作为与 typecheck 相同的命令的一部分运行。

### 5. Scaffold the example package

创建一个已提交的 `<packages-root>/example/` 作为可供复制的模板：

- `index.ts` —— 一个 entry point。导出一个函数，它委托给一个内部文件（这样这个 package 就明显是 *deep* 的，而不是一个 pass-through）。
- `lib/impl.ts` —— 一个位于 **subfolder** 中的内部文件，由 `index.ts` import，外部无法访问。
- `tests/example.test.ts` —— **只** import `../index`（一个 entry point），并对公开函数做断言。

告诉用户这是一个起步模板，可以复制也可以删除。

**Done when:** example package 存在，通过一个根部 entry point 暴露其 behaviour，并把 `impl` 藏在一个 subfolder 里。

### 6. Prove the rules bite

这是整个 skill 的完成标准 —— 一个在违规时不会失败的 config 毫无价值。

1. 运行 `lint:boundaries`。在干净的 example 上它必须 **pass**。
2. 临时往 `tests/example.test.ts` 里加一个 deep import（例如 `import { thing } from "../lib/impl"`）。再次运行 `lint:boundaries` —— 它必须以 `tests-through-entrypoints` **fail**。
3. 撤销这个 deep import。再运行一次 —— 它必须 **pass**。

**Done when:** 你观察到一次 pass，接着在 deep import 上一次 fail，然后再次 pass。如果第 2 步没有 fail，说明规则没有正确接线 —— 先修好再收尾。

### 7. Document the convention

在 **packages 文件夹里**写一个 `README.md`（`<packages-root>/README.md`）—— 紧挨着它所管辖的那些 packages —— 内容涵盖：`src/packages/<name>/` 布局（根部是 entry points，`lib/` 放 implementation，`tests/` 放 tests）、"只通过一个 package 的 entry points（它的 root files）import"，以及如何运行 `lint:boundaries`。**明确不鼓励 barrel files** —— 暴露多个小的 entry points，而不是通过一个 index 去 re-export 整棵子树。把它控制在可供复制的代码片段加上四条规则各一段的篇幅内。

然后从 repo 的 agent-instructions 文件添加一个指向它的 **context pointer** —— 如果有 `CLAUDE.md` 就用它，否则用 `AGENTS.md`（两者都不存在就创建 `AGENTS.md`）。一行就够了，例如 `Packages are deep modules — see [src/packages/README.md](./src/packages/README.md) before adding or importing one.` 正是这一点让一个 agent 能够发现这条边界规则，而不是撞上去。

**Done when:** `<packages-root>/README.md` 存在且不鼓励 barrels，并且 repo 的 `CLAUDE.md`/`AGENTS.md` 链接到了它。

## Notes

- config 里的 `$1` 反向引用（dependency-cruiser 的分组匹配）正是一个 package 能够触及自己内部、而外部不能的原因 —— 不要把它们摊平成一条条按 package 分开的规则。
- 公开还是私有由 **depth** 决定：一个 package 的 root files 是 entry points；任何 subfolder 里的东西都是 private。惯例上的 subfolders 是 `lib/`（implementation）和 `tests/`，但这条规则并不把它们写死 —— 任何 subfolder 都是 private，所以新增一个 folder 永远不需要改 config。新增一个 entry point 只是新增一个 root file —— 不需要 barrel。
- Packages 是 **flat** 的：根部之下只有一层直接子项。一个 package 的内部想嵌套多深都可以；但一个 package 不能包含另一个 package。
- 使用 `.cjs`（而不是 `.js`），这样即便在 `"type": "module"` 的 repo 里，config 的 `module.exports` 也能工作。
