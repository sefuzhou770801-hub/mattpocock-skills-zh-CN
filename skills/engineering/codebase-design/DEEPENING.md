# 深化

如何在一组 shallow module 的依赖关系给定的情况下，安全地把它们深化。本文假定你已掌握 [SKILL.md](SKILL.md) 中的词汇 —— **module**、**interface**、**seam**、**adapter**。

## 依赖类别

评估一个深化候选时，先给它的依赖分类。类别决定了深化后的 module 如何跨其 seam 被测试。

### 1. 进程内

纯计算、内存中的状态、无 I/O。永远可以深化 —— 直接合并这些 module，并通过新的 interface 测试。不需要 adapter。

### 2. 本地可替换

拥有本地测试替身的依赖（用 PGLite 替代 Postgres、内存文件系统等）。只要替身存在就可以深化。深化后的 module 在测试套件中运行该替身来测试。seam 是内部的；module 的外部 interface 上没有 port。

### 3. 远程但自有（Ports & Adapters）

跨越网络边界、但属于你自己的服务（微服务、内部 API）。在 seam 处定义一个 **port**（interface）。deep module 拥有逻辑；传输方式作为 **adapter** 注入。测试使用内存中的 adapter。生产环境使用 HTTP/gRPC/queue adapter。

建议的措辞形态：*"在 seam 处定义一个 port，为生产实现一个 HTTP adapter、为测试实现一个内存 adapter，这样即便逻辑部署在跨网络的多处，它仍然位于一个 deep module 中。"*

### 4. 真正的外部（mock）

你无法控制的第三方服务（Stripe、Twilio 等）。深化后的 module 把外部依赖作为一个注入的 port 接收；测试提供一个 mock adapter。

## seam 纪律

- **一个 adapter 意味着一个假想的 seam。两个 adapter 才意味着一个真实的 seam。** 除非至少有两个 adapter 是合理的（通常是生产 + 测试），否则不要引入 port。只有一个 adapter 的 seam 纯粹是多一层间接。
- **内部 seam 与外部 seam。** 一个 deep module 可以有内部 seam（其实现私有、被它自己的测试使用），也可以有位于其 interface 处的外部 seam。不要仅仅因为测试用到了内部 seam，就把它通过 interface 暴露出去。

## 测试策略：替换，而非叠加

- 一旦深化后 module 的 interface 处有了测试，针对 shallow module 的旧 unit test 就成了废物 —— 删掉它们。
- 在深化后 module 的 interface 处编写新测试。**interface 就是测试面**。
- 测试断言的是通过 interface 可观察到的结果，而不是内部状态。
- 测试应当能在内部 refactor 后存活下来 —— 它们描述的是行为，而不是实现。如果某个测试在实现变化时不得不跟着改，那它就是在越过 interface 做测试。
