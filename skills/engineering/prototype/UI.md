# UI Prototype

在单个路由上生成**几个截然不同的 UI 变体**，通过一个浮动底栏切换。用户在浏览器里来回切换各个变体，挑一个（或者从每个里各取一部分），然后把其余的丢掉。

如果问题关乎逻辑/状态，而不是某个东西该长什么样 —— 走错分支了。用 [LOGIC.md](LOGIC.md)。

## When this is the right shape

- "What should this page look like?"
- "I want to see a few options for this dashboard before committing."
- "Try a different layout for the settings screen."
- 任何用户本来要花一整天在脑子里三个模糊的 mockup 之间做选择的情况。

## Two sub-shapes — strongly prefer sub-shape A

当一个 UI prototype **紧挨着应用的其余部分**时，它要好评判得多 —— 真实的 header、真实的 sidebar、真实的数据、真实的密度。一个孤立的一次性路由是真空环境：每个变体单独看都还行。只要有合理的现有页面可以承载这些变体，就默认选 sub-shape A。只有当 prototype 确实找不到附近的落脚点时，才用 sub-shape B。

### Sub-shape A — adjustment to an existing page (preferred)

路由已经存在。各个变体渲染在**同一个路由**上，由 `?variant=` URL 搜索参数控制。现有的数据获取、参数和鉴权全部保留 —— 只替换渲染部分。这是默认选项；除非有具体理由不这么做，否则就选它。

如果 prototype 针对的东西还没有页面，但*天然应该存在于某个页面内部*（dashboard 的一个新分区、设置页的一张新卡片、现有流程中的一个新步骤）—— 那仍然是 sub-shape A。把各个变体挂载到宿主页面内部。

### Sub-shape B — a new page (last resort)

只有当被 prototype 的东西确实没有现有页面可以容纳时才用 —— 例如一个全新的顶层界面，或者一个无法合理嵌入任何地方的流程。

按照项目已有的路由约定创建一个**一次性路由** —— 不要发明一套新的顶层结构。给它起个一看就是 prototype 的名字（例如在路径或文件名里包含 `prototype` 一词）。同样使用 `?variant=` 模式。

在确定用 sub-shape B 之前，做个合理性检查：真的没有现有页面可以把它嵌进去吗？一个空路由会掩盖那些有内容的路由才能暴露的设计问题。

在两种 sub-shape 中，浮动底栏都是一样的。

## Process

### 1. State the question and pick N

默认做 **3 个变体**。超过 5 个就不再是截然不同，而是噪音了 —— 上限就是 5 个。

用一行话把计划写下来，放在 prototype 所在位置或文件顶部的注释里：

> "Three variants of the settings page, switchable via `?variant=`, on the existing `/settings` route."

无论用户此刻是否在场提出反对意见，这都管用。

### 2. Generate radically different variants

起草每个变体。对每一个都要求做到：

- 符合页面的目的和它能访问的数据。
- 符合项目的组件库 / 样式体系（TailwindCSS、shadcn、MUI、纯 CSS，随便什么）。
- 有一个清晰的导出组件名，例如 `VariantA`、`VariantB`、`VariantC`。

各个变体必须在**结构上不同** —— 不同的布局、不同的信息层级、不同的主要操作入口，而不只是颜色不同。三个略微调整过的卡片网格不是 UI prototype，那是壁纸。如果两个草稿出来太像，就带着明确的 "do not use a card grid" 指令重做其中一个。

### 3. Wire them together

在路由上创建一个切换器组件：

```tsx
// pseudo-code — adapt to the project's framework
const variant = searchParams.get('variant') ?? 'A';
return (
  <>
    {variant === 'A' && <VariantA {...data} />}
    {variant === 'B' && <VariantB {...data} />}
    {variant === 'C' && <VariantC {...data} />}
    <PrototypeSwitcher variants={['A','B','C']} current={variant} />
  </>
);
```

对于 sub-shape A（现有页面）：把所有现有的数据获取保留在切换器之上；只有被渲染的子树随变体而变。

对于 sub-shape B（新页面）：`/prototype/<name>` 下的一次性路由挂载同一个切换器。

### 4. Build the floating switcher

在屏幕底部居中放一个小的固定定位栏，包含三个部分：

- **左箭头** —— 循环切换到上一个变体（到头后绕回）。
- **变体标签** —— 显示当前变体的键，如果该变体导出了名称，也一并显示。例如 `B — Sidebar layout`。
- **右箭头** —— 向后循环切换（到头后绕回）。

行为：

- 点击箭头会更新 URL 搜索参数（用框架的路由器 —— Next 上用 `router.replace`，React Router 上用 `navigate`，等等），这样变体就是可分享的、刷新后也稳定。
- 键盘：`←` 和 `→` 方向键也能循环切换。当焦点在 `<input>`、`<textarea>` 或 `[contenteditable]` 上时，不要拦截方向键。
- 视觉上与页面区分开（例如高对比度的胶囊、淡淡的阴影），让人一眼看出它不属于正在被评估的设计。
- 在生产构建中隐藏 —— 用 `process.env.NODE_ENV !== 'production'` 或等价检查来控制，这样一次误合并的 prototype 就不会把这个栏推送给用户。

把切换器放进一个共享组件里，让两种 sub-shape 都能复用它。把它放在项目中共享 UI 所在的地方。

### 5. Hand it over

把 URL（以及 `?variant=` 的各个键）告诉用户。他们会在方便的时候自己切换。有意思的反馈通常是 **"I want the header from B with the sidebar from C"** —— 那才是他们真正想要的设计。

### 6. Capture the answer and clean up

一旦某个变体胜出，就把答案记录下来 —— 哪个变体、为什么 —— 然后按 [SKILL](SKILL.md) 描述的方式把 prototype 记录下来。把胜出者并入真实代码，把其余的移到一次性分支上，而不是 main：

- **Sub-shape A** —— 把胜出者并入现有页面；从 main 中删掉落选的变体和切换器。
- **Sub-shape B** —— 把胜出的变体提升为真实路由；从 main 中删掉一次性路由和切换器。

完整的变体集合是 primary source，所以它落在一次性分支上，而不是垃圾桶里 —— 留在 main 分支上的变体组件和切换器会很快腐烂，并让下一个读者困惑。

## Anti-patterns

- **只在颜色或文案上不同的变体。** 那是微调，不是 prototype。真正的变体在结构上就互相分歧。
- **变体之间共享太多代码。** 共享一个 `<Header>` 没问题；共享一个 `<Layout>` 就违背了初衷。每个变体都应该可以自由地抛弃布局。
- **把变体接到真实的写操作上。** 只读的 prototype 没问题。如果某个变体需要写操作，就把它指向一个桩 —— 问题是 "what should this look like"，而不是 "does the backend work"。
- **把 prototype 直接提升到生产环境。** 变体代码是在 prototype 的约束下写的（没有 test、错误处理极少）。并入时请正经重写。
