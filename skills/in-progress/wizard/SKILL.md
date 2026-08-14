---
name: wizard
description: 生成交互式 bash wizard，引导人类逐步完成只有他们能做的步骤。适用于 provision 基础设施、配置 credentials 或 CI secrets、操作不熟悉的第三方 dashboard，或执行一次性 migration / cutover。不要在 agent 自己能完成的步骤上调用本技能。
---

# Wizard

**Wizard** 是一个 bash 脚本，逐步引导人类完成一套手动流程：亲手做很烦，每次都向 AI 重新解释也很烦。它会打开每个 URL，精确说明要点哪里、复制什么，捕获这些值，写到该写的地方（`.env`、GitHub secrets），每一步都确认，并显示还剩多少。它可能配置第三方服务、跑一次性 migration，或把项目从一种状态迁到另一种状态。

愉悦的 UX 已由 [template.sh](template.sh) 解决——带剩余时间的进度、确认门、跨平台打开 URL（含 WSL）、隐藏输入 secret、幂等的 `.env` upsert、`gh secret`/`gh variable` 写入，以及收尾摘要。**你的工作只是框定流程并编写各 stage。** `STAGES` 标记以上的库在每个 wizard 里完全相同；这种一致性正是重点——永远不要手改那一段。

Wizard 默认是临时的——为一次运行而建，存到 scratch 或 `scripts/` 路径，做完就删。只有当用户希望仓库里留下可重复的 setup 路径时才提交它。

## Process

### 1. Scope the procedure

弄清人类必须做的每一步手动操作，以及沿途要捕获的每个值。先读仓库，不要冷开场就问：

- 对 setup：`.env`、`.env.example`、`.env.*`、`README`、`docker-compose*`、framework config，以及 `.github/workflows/*`（每一个 `secrets.*` / `vars.*` 引用都是 wizard 必须产出的值）。
- 对 migration 或 transition：当前状态、目标状态，以及两者之间的不可逆动作。

然后向用户展示按顺序排列的 stage 列表，以及每个 stage 产出的值，并请确认——他们可能增、删或重排。

**Done when:** 每个 stage 都按顺序命名；对每个捕获的值，你都知道 (a) 人类从哪里拿到它，(b) 写到哪里（`.env`、GitHub secret、两者都写，或哪里都不写——有些 stage 是纯动作），以及 (c) 它是 secret（隐藏输入）还是 public。

### 2. Map each stage's journey

对每个 stage，写出人类要走的精确路径：打开哪个 URL、在那里做什么、值显示在哪里、填入哪个变量——例如 “Dashboard → Developers → API keys → Reveal test key → copy”。你并不真正知道当前 UI 或确切命令时，就明说并问用户或查文档——永远不要编造可能不存在的步骤。

**Done when:** 每个 stage 都能落到陌生人也能跟着做的具体说明。

### 3. Author the wizard

把 `template.sh` 复制到目标路径。把示例 stage 换成每个步骤一个 `stage`，按依赖顺序排列。使用库提供的 helpers——`stage`、`say`/`step`、`open_url`、`ask`/`ask_secret`、`write_env`、`set_secret`/`set_var`、`pause`/`confirm`——并把 `TOTAL_STAGES` 与 `TOTAL_MINUTES` 设成诚实的估计（这驱动剩余时间显示）。

守住模板立下的标准：在索取值之前先打开 URL；对任何 secret 用 `ask_secret`；每个要持久化的值都 `write_env`；只对 CI 真正需要的值 `set_secret`；任何不可逆动作前都 `confirm`。每个 `stage` 会清屏，所以屏幕上只留当前步骤——让每个 stage 只做一件聚焦的事，避免人类需要的信息滚出视野。不要动标记以上的库。

### 4. Verify and hand off

- `bash -n <script>`；若有 `shellcheck` 就跑。
- `chmod +x <script>`。
- 不要自己端到端跑它——它会打开浏览器并阻塞等人输入。改为静态追踪：第 1 步的每个值都被捕获并落到第 1 步说定的位置，且每个 `set_secret` 名称与 CI 中的 `secrets.*` 引用精确匹配。
- 告诉用户怎么运行。若是可重复的 setup 路径，提交它并在 README 里链过去，让下一个人跑脚本，而不是再问 AI。
