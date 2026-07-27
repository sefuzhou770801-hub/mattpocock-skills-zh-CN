---
name: implement
description: "基于 spec 或一组 ticket 来实现一项工作。"
disable-model-invocation: true
---

实现用户在 spec 或 ticket 中所描述的工作。

在预先约定好的 seam 处，尽可能使用 /tdd。

定期运行 typechecking，定期运行单个 test 文件，并在最后运行一次完整的 test suite。

完成后，使用 /code-review 来审查这项工作。

把你的工作提交到当前 branch。
