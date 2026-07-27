# Explicit `/setup-matt-pocock-skills` pointer only for hard dependencies

Engineering skills 依赖由 `/setup-matt-pocock-skills` 播种的 per-repo 配置（issue tracker、triage label vocabulary、domain doc 布局）。有些 skill 没有这些配置就无法正常工作——它们必须发布到特定的 issue tracker，或套用特定的 label 字符串。另一些 skill 只是用它来打磨输出（vocabulary、ADR awareness），没有它也能优雅降级。

我们把这些 skill 分成 **hard-dependency** 和 **soft-dependency** 两类：

- **Hard dependency**（`to-tickets`、`to-spec`、`triage`）——包含一句明确的一行提示：_"… should have been provided to you — run `/setup-matt-pocock-skills` if not."_。没有这层映射，输出就是错的，而不只是模糊。
- **Soft dependency**（`diagnose`、`tdd`、`improve-codebase-architecture`）——只用模糊措辞提及 "the project's domain glossary" 和 "ADRs in the area you're touching"。如果文档不在，skill 仍然可用；只是输出没那么锐利。

这种划分让 soft-dependency skills 保持 token-light，也避免把 setup pointer 机械地塞进那些并不承重的地方。
