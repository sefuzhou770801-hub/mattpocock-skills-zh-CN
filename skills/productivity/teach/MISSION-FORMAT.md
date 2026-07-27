# MISSION.md Format

`MISSION.md` 位于 workspace 的根目录。它记录用户学习这一主题的_原因_。每一个教学决策——下一步教什么、呈现哪些 resources、设计哪些练习——都应当追溯到这份文档。

## Template

```md
# Mission: {Topic}

## Why
{1-3 sentences. The concrete real-world goal the user is chasing. What changes in their life or work when they have this skill? Avoid abstract framings like "to understand X" — push for the underlying outcome.}

## Success looks like
- {A specific, observable thing the user will be able to do}
- {Another specific thing}
- {…}

## Constraints
- {Time, budget, prior commitments, learning preferences, anything that bounds the approach}

## Out of scope
- {Adjacent topics the user explicitly does not want to chase right now — protects the zone of proximal development}
```

## Rules

- **每个 workspace 一个 mission。** 如果用户想学两样互不相关的东西，那就是两个 workspace。
- **具体胜于抽象。** “Run a half marathon by October” 胜过 “get fitter”。“Ship a Rust CLI to my team” 胜过 “learn Rust”。
- **对含糊其辞要追问到底。** 如果用户说不清为什么，在写下任何东西之前先追问他们。一个糟糕的 mission 比没有 mission 更糟。
- **当现实发生变化时就修订。** Mission 是会变的。当用户的目标移动时，更新这份文件——不要让一个过时的 mission 继续引导未来的 session。
- **保持简短。** 如果 `MISSION.md` 超过了一屏，它就不再是指南针，而开始变成一份计划了。
