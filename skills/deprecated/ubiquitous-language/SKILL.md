---
name: ubiquitous-language
description: 从当前对话中提取 DDD 风格的 ubiquitous language 词汇表，标记歧义并提出规范术语。保存到 UBIQUITOUS_LANGUAGE.md。适用于用户想定义领域术语、构建词汇表、固化术语、创建 ubiquitous language，或提到 “domain model” 或 “DDD” 时。
disable-model-invocation: true
---

# Ubiquitous Language

从当前对话中提取并规范化领域术语，整理成一份一致的词汇表，保存到本地文件。

## Process

1. **扫描对话**，找出与领域相关的名词、动词和概念
2. **识别问题**：
   - 同一个词被用于不同概念（歧义）
   - 不同词被用于同一个概念（同义词）
   - 含糊或一词多义的术语
3. **提出一份规范词汇表**，对术语选择给出明确主张
4. **写入工作目录下的 `UBIQUITOUS_LANGUAGE.md`**，使用下面的格式
5. **在对话中输出摘要**

## Output Format

写一个 `UBIQUITOUS_LANGUAGE.md` 文件，结构如下：

```md
# Ubiquitous Language

## Order lifecycle

| Term        | Definition                                              | Aliases to avoid      |
| ----------- | ------------------------------------------------------- | --------------------- |
| **Order**   | A customer's request to purchase one or more items      | Purchase, transaction |
| **Invoice** | A request for payment sent to a customer after delivery | Bill, payment request |

## People

| Term         | Definition                                  | Aliases to avoid       |
| ------------ | ------------------------------------------- | ---------------------- |
| **Customer** | A person or organization that places orders | Client, buyer, account |
| **User**     | An authentication identity in the system    | Login, account         |

## Relationships

- An **Invoice** belongs to exactly one **Customer**
- An **Order** produces one or more **Invoices**

## Example dialogue

> **Dev:** "When a **Customer** places an **Order**, do we create the **Invoice** immediately?"
> **Domain expert:** "No — an **Invoice** is only generated once a **Fulfillment** is confirmed. A single **Order** can produce multiple **Invoices** if items ship in separate **Shipments**."
> **Dev:** "So if a **Shipment** is cancelled before dispatch, no **Invoice** exists for it?"
> **Domain expert:** "Exactly. The **Invoice** lifecycle is tied to the **Fulfillment**, not the **Order**."

## Flagged ambiguities

- "account" was used to mean both **Customer** and **User** — these are distinct concepts: a **Customer** places orders, while a **User** is an authentication identity that may or may not represent a **Customer**.
```

## Rules

- **要有主张。** 当同一个概念存在多个词时，选出最好的一个，并把其余列为应避免的别名。
- **明确标出冲突。** 如果某个术语在对话中被含糊使用，在 “Flagged ambiguities” 一节中指出，并给出明确建议。
- **只收录对领域专家有意义的术语。** 跳过 module 或 class 的名称，除非它们在领域语言中具有含义。
- **定义要精炼。** 最多一句话。定义它“是什么”，而不是它“做什么”。
- **展示关系。** 使用加粗的术语名，并在显而易见时表达基数关系。
- **只收录领域术语。** 跳过通用编程概念（array、function、endpoint），除非它们具有领域特定的含义。
- **当出现自然的聚类时，把术语分组到多个表格中**（例如按子领域、生命周期或参与者）。每一组有自己的标题和表格。如果所有术语都属于同一个内聚的领域，用一个表格即可——不要强行分组。
- **写一段示例对话。** 一段 dev 与领域专家之间的简短对话（3-5 轮往返），自然地展示这些术语如何相互作用。对话应澄清相关概念之间的边界，并展示术语被精确使用。

<example>

## Example dialogue

> **Dev:** "How do I test the **sync service** without Docker?"

> **Domain expert:** "Provide the **filesystem layer** instead of the **Docker layer**. It implements the same **Sandbox service** interface but uses a local directory as the **sandbox**."

> **Dev:** "So **sync-in** still creates a **bundle** and unpacks it?"

> **Domain expert:** "Exactly. The **sync service** doesn't know which layer it's talking to. It calls `exec` and `copyIn` — the **filesystem layer** just runs those as local shell commands."

</example>

## Re-running

当在同一对话中再次被调用时：

1. 读取已有的 `UBIQUITOUS_LANGUAGE.md`
2. 纳入后续讨论中出现的新术语
3. 如果理解有所演进，更新定义
4. 重新标记任何新的歧义
5. 重写示例对话以纳入新术语
