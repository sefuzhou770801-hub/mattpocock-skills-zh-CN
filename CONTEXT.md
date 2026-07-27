# Matt Pocock Skills

由 Claude Code 加载的一组 agent skills（slash commands 和 behaviors）。Skills 按 bucket 组织，并由 `/setup-matt-pocock-skills` 产出的 per-repo 配置消费。

## Language

**Issue tracker**：
托管某个 repo issues 的工具——GitHub Issues、Linear、本地 `.scratch/` markdown 约定，或类似的东西。像 `to-tickets`、`to-spec`、`triage` 和 `qa` 这样的 skills 会从中读取并写入。
_Avoid_: backlog manager, backlog backend, issue host

**Issue**：
一个 **Issue tracker** 内部被跟踪的单个工作单元——一个 bug、task、spec，或由 `to-tickets` 产出的 slice。
_Avoid_: ticket（仅在引用那些把它们叫作 ticket 的外部系统时，或指一个 **Decision ticket**——见下文——时使用）

**Decision ticket**：
一个 `wayfinder` 单元——`wayfinder:map` 的一个 child **Issue**，承载一个*问题*，其解决是一个 decision，而不是一个要执行的 build slice。正是 **decision** 这个限定词使它区别于一个 implementation ticket；`wayfinder` 引入这个术语，然后使用 "ticket"。

**Triage role**：
在 triage 期间应用到一个 **Issue** 上的规范 state-machine label（例如 `needs-triage`、`ready-for-agent`）。每个 role 都通过 `skills/engineering/setup-matt-pocock-skills/triage-labels.md` 映射到 **Issue tracker** 中一个真实的 label 字符串。

## Relationships

- 一个 **Issue tracker** 持有多个 **Issues**
- 一个 **Issue** 同一时间携带一个 **Triage role**
- 一个 **Decision ticket** 是一个 **Issue**（一个 `wayfinder:map` 的 child）

## Flagged ambiguities

- "backlog" 过去同时用来指托管 issues 的*工具*以及其中的*工作集合*——已解决：工具是 **Issue tracker**；"backlog" 不再作为一个 domain term 使用。
- "backlog backend" / "backlog manager"——已解决：收敛进 **Issue tracker**。
