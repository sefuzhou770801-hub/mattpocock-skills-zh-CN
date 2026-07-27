---
name: migrate-to-shoehorn
description: 将 test 文件中的 `as` 类型断言迁移到 @total-typescript/shoehorn。适用于用户提到 shoehorn、想替换 test 中的 `as`，或需要部分（partial）test 数据时。
---

# Migrate to Shoehorn

## Why shoehorn?

`shoehorn` 让你在 test 中传入部分（partial）数据的同时保持 TypeScript 满意。它用类型安全的替代方案取代 `as` 断言。

**仅用于 test 代码。** 切勿在生产代码中使用 shoehorn。

test 中使用 `as` 的问题：

- 我们被训练为不使用它
- 必须手动指定目标类型
- 对故意错误的数据要用双重 as（`as unknown as Type`）

## Install

```bash
npm i @total-typescript/shoehorn
```

## Migration patterns

### Large objects with few needed properties

之前：

```ts
type Request = {
  body: { id: string };
  headers: Record<string, string>;
  cookies: Record<string, string>;
  // ...20 more properties
};

it("gets user by id", () => {
  // Only care about body.id but must fake entire Request
  getUser({
    body: { id: "123" },
    headers: {},
    cookies: {},
    // ...fake all 20 properties
  });
});
```

之后：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

it("gets user by id", () => {
  getUser(
    fromPartial({
      body: { id: "123" },
    }),
  );
});
```

### `as Type` → `fromPartial()`

之前：

```ts
getUser({ body: { id: "123" } } as Request);
```

之后：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

getUser(fromPartial({ body: { id: "123" } }));
```

### `as unknown as Type` → `fromAny()`

之前：

```ts
getUser({ body: { id: 123 } } as unknown as Request); // wrong type on purpose
```

之后：

```ts
import { fromAny } from "@total-typescript/shoehorn";

getUser(fromAny({ body: { id: 123 } }));
```

## When to use each

| 函数            | 使用场景                                           |
| --------------- | -------------------------------------------------- |
| `fromPartial()` | 传入仍然能通过类型检查的部分数据           |
| `fromAny()`     | 传入故意错误的数据（保留自动补全） |
| `fromExact()`   | 强制传入完整对象（之后可换成 fromPartial）    |

## Workflow

1. **收集需求** - 询问用户：
   - 哪些 test 文件存在造成问题的 `as` 断言？
   - 是否在处理只有部分属性重要的大对象？
   - 是否需要为错误测试传入故意错误的数据？

2. **安装并迁移**：
   - [ ] 安装：`npm i @total-typescript/shoehorn`
   - [ ] 找出含 `as` 断言的 test 文件：`grep -r " as [A-Z]" --include="*.test.ts" --include="*.spec.ts"`
   - [ ] 用 `fromPartial()` 替换 `as Type`
   - [ ] 用 `fromAny()` 替换 `as unknown as Type`
   - [ ] 添加来自 `@total-typescript/shoehorn` 的 import
   - [ ] 运行类型检查以验证
