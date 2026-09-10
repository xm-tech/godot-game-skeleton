class_name PlayerData
extends Resource
## 玩家的数据驱动调参（参见「自定义 Resource」最佳实践）。
##
## 每种配置建一个 .tres（例如快速 / 小巧变体、重型变体），拖到 Player 节点的
## `data` 导出槽 —— 改数据而不改代码。

@export var max_health: int = 100
@export var move_speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0
