# 自定义 Resource（resources）

数据驱动：数值不写死在代码里，而是放进自定义 Resource（.tres）。

典型用法：
- `xxx_data.gd`：`class_name XxxData extends Resource`，用 `@export` 定义可调字段
- `xxx_data.tres`：一份配置实例（可复制多份做不同变体）

改数据不改代码，代码零改动即可调参 / 换变体。
