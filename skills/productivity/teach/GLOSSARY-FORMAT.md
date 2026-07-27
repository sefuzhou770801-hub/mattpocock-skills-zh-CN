# GLOSSARY.md Format

`GLOSSARY.md` 是这个 teaching workspace 的规范语言。所有的 explainers、exercises 和 learning records 都应当遵守它的术语。构建它本身就是学习的一部分：把一个概念压缩成一条紧凑的定义，正是用户理解了它的证据。

## Structure

```md
# {Topic} Glossary

{One or two sentence description of the topic this glossary covers.}

## Terms

**Hypertrophy**:
Muscle growth driven by mechanical tension and metabolic stress over repeated training sessions.
_Avoid_: Bulking, getting big

**Progressive overload**:
Systematically increasing the demand on a muscle over time — via load, volume, or intensity.
_Avoid_: Pushing harder, levelling up

**RPE (Rate of Perceived Exertion)**:
A 1–10 self-rating of how hard a set felt, where 10 is failure and 8 means two reps left in the tank.
_Avoid_: Effort score, intensity rating
```

## Rules

- **只有当用户理解了某个术语，才添加它。** Glossary 是对压缩后知识的记录，而不是供用户阅读学习的词典。如果用户刚刚接触一个概念，要等到他们能够正确使用它之后，再把它提升到这里。
- **要有主见。** 当同一个概念有多个说法时，挑出最好的那个，把其余的列为应当避免的别名。语言就是这样压缩的。
- **保持定义紧凑。** 一到两句话。定义这个术语_是_什么，而不是它做什么或怎么做。
- **在定义内部使用 glossary 自己的术语。** 一旦某个术语进入了 glossary，就在所有地方优先使用它——包括在其他定义的内部。正是这一点让复杂的术语日后更容易被理解。
- **当自然的聚类出现时，按子标题分组**（例如 `## Anatomy`、`## Programming`）。当各个术语彼此内聚时，一个扁平的列表也没问题。
- **明确标出歧义。** 如果某个术语在更大的领域里被宽泛地使用，记下本 workspace 的取舍：“In this workspace, 'set' always means a working set — warm-ups are tracked separately.”
- **随着理解的加深而修订。** 用户在第一周写下的定义，到了第六周可能就已经错了。就地更新；不要留下过时的条目。
