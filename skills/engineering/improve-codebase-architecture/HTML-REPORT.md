# HTML Report Format

架构评审被渲染为操作系统临时目录中的单个自包含 HTML 文件。Tailwind 和 Mermaid 都来自 CDN。Mermaid 能可靠地处理图形类图表；手写的 div 和内联 SVG 则负责更具编辑感的视觉元素（质量图、剖面图）。两者混用 —— 不要什么都依赖 Mermaid，否则它会开始显得千篇一律。

## Scaffold

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review — {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* small custom layer for things Tailwind doesn't cover cleanly:
         dashed seam lines, hand-drawn-feeling arrow heads, etc. */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## Header

repo 名称、日期，以及一个紧凑的图例：实线框 = module，虚线 = seam，红色箭头 = leakage，深色粗框 = deep module。不要引言段落 —— 直接进入各个候选。

## Candidate card

图表承担主要分量。文字要稀疏、平实，并且不加修饰地使用术语表中的词（来自 `/codebase-design` skill）。

每个候选是一个 `<article>`：

- **标题** —— 简短，点明这次深化（例如 "Collapse the Order intake pipeline"）。
- **徽章行** —— 推荐力度（`Strong` = emerald，`Worth exploring` = amber，`Speculative` = slate），外加一个依赖类别标签（`in-process`、`local-substitutable`、`ports & adapters`、`mock`）。
- **文件** —— 等宽字体列表，`font-mono text-sm`。
- **Before / After 图** —— 重头戏。两列，并排放置。见下文的模式。
- **Problem** —— 一句话。哪里痛。
- **Solution** —— 一句话。改变了什么。
- **Wins** —— 要点列表，每条不超过 6 个词。例如 "Tests hit one interface"、"Pricing logic stops leaking"、"Delete 4 shallow wrappers"。
- **ADR 标注**（如适用）—— 在一个 amber 色调的框里写一行。

不要写解释性段落。如果一张图需要一段话才能看懂，那就重画这张图。

## Diagram patterns

挑选适合该候选的模式。混用它们。不要让每张图看起来都一样 —— 多样性本身就是要点的一部分。

### Mermaid graph（依赖 / 调用流的主力）

当要点是 "X calls Y calls Z, and look at the mess." 时，使用 Mermaid 的 `flowchart` 或 `graph`。把它包在一个 Tailwind 样式的卡片里，这样它才不会显得像是空降进来的。用 classDef 把 leakage 边染成红色、把 deep module 染成深色。序列图很适合表达 "before: 6 round-trips; after: 1."。

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### 手写的方框加箭头（当 Mermaid 的布局跟你作对时）

把 module 做成带边框和标签的 `<div>`。箭头用内联 SVG 的 `<line>` 或 `<path>` 元素，绝对定位在一个 relative 容器之上。当你想让 "after" 图看起来像一个粗边框的 deep module、内部灰显时，就用这种方式 —— Mermaid 没法以恰当的分量渲染出那种效果。

### 剖面图（适合分层式的浅）

堆叠水平条带（`h-12 border-l-4`）来展示一次调用穿过的各个层。Before：6 个薄层，每一层几乎什么都不做。After：1 个厚条带，标注合并后的职责。

### 质量图（适合 "interface 和 implementation 一样宽"）

每个 module 两个矩形 —— 一个表示 interface 的表面积，一个表示 implementation。Before：interface 矩形几乎和 implementation 矩形一样高（shallow）。After：interface 矩形矮，implementation 矩形高（deep）。

### 调用图坍缩

Before：一棵函数调用树，渲染成嵌套的方框。After：同一棵树坍缩成一个方框，如今已成为内部的调用在其中以淡化方式显示。

## Style guidance

- 偏向编辑感，而不是企业仪表盘。留白要大方。标题可选用衬线体（`font-serif` 与 stone/slate 很搭）。
- 用色要克制：一个强调色（emerald 或 indigo），外加红色表示 leakage、amber 表示警告。
- 图表保持约 320px 高，这样 before/after 并排放置时不用滚动就能看全。
- 图表内部的 module 标签用 `text-xs uppercase tracking-wider` —— 它们应该读起来像示意图，而不是像 UI。
- 唯一的脚本就是 Tailwind CDN 和 Mermaid ESM 导入。报告其余部分是静态的 —— 没有应用代码，除了 Mermaid 自身的渲染之外没有交互。

## Top recommendation section

一张更大的卡片。候选名称、一句话说明理由、指向其卡片的锚点链接。就这些。

## Tone

平实的英文，简洁 —— 但架构名词和动词直接取自 `/codebase-design` skill。简洁不是术语漂移的借口。

**Use exactly:** module, interface, implementation, depth, deep, shallow, seam, adapter, leverage, locality.

**Never substitute:** component, service, unit (for module) · API, signature (for interface) · boundary (for seam) · layer, wrapper (for module, when you mean module).

**符合这种风格的措辞：**

- "Order intake module is shallow — interface nearly matches the implementation."
- "Pricing leaks across the seam."
- "Deepen: one interface, one place to test."
- "Two adapters justify the seam: HTTP in prod, in-memory in tests."

**Wins 要点**用术语表中的词来命名收益：*"locality: bugs concentrate in one module"*、*"leverage: one interface, N call sites"*、*"interface shrinks; implementation absorbs the wrappers"*。不要写 *"easier to maintain"* 或 *"cleaner code"* —— 这些词不在术语表里，也不配占一个位置。

不要含糊其辞，不要开场铺垫，不要 "it's worth noting that…"。如果一句话能变成一个要点，就把它变成要点。如果一个要点能删掉，就删掉。如果某个词不在 `/codebase-design` 术语表里，先找一个在里面的词，而不是发明一个新词。
