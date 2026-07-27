# Refactor Candidates

TDD 循环之后，寻找：

- **重复** -> 提取函数/类
- **过长的方法** -> 拆成私有的辅助方法（test 仍然放在公共 interface 上）
- **shallow module** -> 合并或加深
- **特性依恋（Feature envy）** -> 把逻辑移到数据所在的地方
- **基本类型偏执（Primitive obsession）** -> 引入值对象
- 被新代码暴露出问题的**既有代码**
