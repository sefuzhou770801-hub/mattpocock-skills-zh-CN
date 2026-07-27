---
name: wizard
description: 生成一个交互式 bash wizard，引导一个人走完一项手动流程 —— 第三方 setup、一次性 migration、A→B 的状态迁移 —— 打开 URL、捕获取值、逐步确认，并写入 .env 文件和 GitHub Actions secrets。
disable-model-invocation: true
---

# Wizard

一个 **wizard** 是一段 bash 脚本，它一步一步引导一个人走完一项手动流程 —— 这类流程手动做很烦，每次重新向 AI 解释一遍也很烦。它会打开每一个 URL，准确说出该点哪里、该复制什么，捕获那些取值，把它们写到该去的地方（`.env`、GitHub secrets），在每个环节确认，并显示还剩多少。它可能用来配置第三方服务、跑一次一次性 migration，或把项目从一种状态搬到另一种状态。

那种令人愉悦的 UX 已经由 [template.sh](template.sh) 解决了 —— 带剩余时间的进度、确认关卡、跨平台的 URL 打开（含 WSL）、隐藏的 secret 输入、幂等的 `.env` upsert、`gh secret`/`gh variable` 写入，以及一份收尾 summary。**你的工作只是界定流程的范围并编写它的各个 stage。** `STAGES` 标记之上的那段 library 在每个 wizard 里都一模一样；这种一致性正是重点 —— 永远不要手动去改它。

一个 wizard 默认是一次性的 —— 为一次运行而生，存到 scratch 或 `scripts/` 路径下，活儿干完就删掉。只有当用户想要一条应当留在 repo 里的可重复 setup 路径时，才提交它。

## Process

### 1. Scope the procedure

理清这个人必须走的每一个手动步骤，以及沿途会被捕获的每一个取值。先读 repo —— 不要凭空发问：

- 对于 setup：`.env`、`.env.example`、`.env.*`、`README`、`docker-compose*`、框架 config，以及 `.github/workflows/*`（每一处 `secrets.*` / `vars.*` 引用都是 wizard 必须产出的一个取值）。
- 对于 migration 或 transition：当前状态、目标状态，以及两者之间那些不可逆的操作。

然后把有序的 stages 列表以及每个 stage 产出的取值展示给用户，并确认 —— 他们可能会增删或重新排序。

**Done when:** 每个 stage 都已按顺序命名，并且对于每一个被捕获的取值，你都知道 (a) 这个人从哪里拿到它，(b) 它写到哪里（`.env`、一个 GitHub secret、两者都写，或都不写 —— 有些 stage 是纯操作），以及 (c) 它是 secret（隐藏输入）还是公开的。

### 2. Map each stage's journey

对于每一个 stage，写出这个人所遵循的精确路径：打开哪个 URL、在那里做什么、取值显示在哪里、它填进哪个变量 —— 例如 "Dashboard → Developers → API keys → Reveal test key → copy"。在你确实不知道当前 UI 或确切命令的地方，如实说明，并去问用户或查文档 —— 永远不要编造可能并不存在的步骤。

**Done when:** 每个 stage 都能落到一个陌生人也能照着走的具体指令上。

### 3. Author the wizard

把 `template.sh` 复制到目标路径。用每个步骤一个 `stage` 替换掉示例 stage，按依赖顺序排列。使用那些 library helpers —— `stage`、`say`/`step`、`open_url`、`ask`/`ask_secret`、`write_env`、`set_secret`/`set_var`、`pause`/`confirm` —— 并把 `TOTAL_STAGES` 和 `TOTAL_MINUTES` 设为诚实的估计值（这驱动剩余时间的显示）。

守住 template 立下的标准：在索要某个 URL 的取值之前先打开它，对任何 secret 都用 `ask_secret`，对每一个要持久化的取值都用 `write_env`，只对 CI 确实需要的取值用 `set_secret`，并在任何不可逆操作之前 `confirm`。每个 `stage` 都会清屏，所以只有当前这一步是可见的 —— 让一个 stage 只聚焦一项任务，这样这个人需要的东西就不会被滚出视野。不要碰标记之上的那段 library。

### 4. Verify and hand off

- `bash -n <script>`；如果有 `shellcheck` 就跑一下。
- `chmod +x <script>`。
- 不要自己端到端地运行它 —— 它会打开浏览器并阻塞在人的输入上。改为静态地走查：第 1 步中的每一个取值都被捕获、并落到了第 1 步所说的地方，并且每一个 `set_secret` 的名字都与 CI 里的某处 `secrets.*` 引用精确匹配。
- 告诉用户如何运行它。如果这是一条可重复的 setup 路径，就提交它并从 README 链接过去，这样下一个人就会去跑这个脚本，而不是来问 AI。
