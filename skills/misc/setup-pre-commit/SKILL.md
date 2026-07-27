---
name: setup-pre-commit
description: 在当前仓库中设置 Husky pre-commit hooks，包含 lint-staged（Prettier）、类型检查和 test。适用于用户想要添加 pre-commit hooks、设置 Husky、配置 lint-staged，或添加提交时的格式化/类型检查/测试时。
---

# 设置 Pre-Commit Hooks

## 这会设置什么

- **Husky** pre-commit hook
- **lint-staged** 对所有暂存文件运行 Prettier
- **Prettier** 配置（如缺失）
- pre-commit hook 中的 **typecheck** 与 **test** 脚本

## 步骤

### 1. 检测 package manager

检查 `package-lock.json`（npm）、`pnpm-lock.yaml`（pnpm）、`yarn.lock`（yarn）、`bun.lockb`（bun）。使用存在的那个。无法确定时默认使用 npm。

### 2. 安装依赖

作为 devDependencies 安装：

```
husky lint-staged prettier
```

### 3. 初始化 Husky

```bash
npx husky init
```

这会创建 `.husky/` 目录，并在 package.json 中添加 `prepare: "husky"`。

### 4. 创建 `.husky/pre-commit`

写入此文件（Husky v9+ 不需要 shebang）：

```
npx lint-staged
npm run typecheck
npm run test
```

**适配**：把 `npm` 替换为检测到的包管理器。如果仓库的 package.json 中没有 `typecheck` 或 `test` 脚本，省略相应行并告知用户。

### 5. 创建 `.lintstagedrc`

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

### 6. 创建 `.prettierrc`（如缺失）

仅在不存在 Prettier 配置时创建。使用以下默认值：

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

### 7. 验证

- [ ] `.husky/pre-commit` 存在且可执行
- [ ] `.lintstagedrc` 存在
- [ ] package.json 中的 `prepare` 脚本为 `"husky"`
- [ ] `prettier` 配置存在
- [ ] 运行 `npx lint-staged` 验证其可用

### 8. 提交

暂存所有变更/新建的文件，并以如下消息提交：`Add pre-commit hooks (husky + lint-staged + prettier)`

这会跑一遍新的 pre-commit hooks——是一次很好的冒烟测试，可验证一切正常。

## 备注

- Husky v9+ 的 hook 文件不需要 shebang
- `prettier --ignore-unknown` 会跳过 Prettier 无法解析的文件（图片等）
- pre-commit 先运行 lint-staged（快速、仅针对暂存文件），再运行完整的 typecheck 和 test
