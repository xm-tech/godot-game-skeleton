class_name EnemyData
extends Resource
## 敌人的数据驱动调参（与 PlayerData 对齐）。
##
## 每种敌人变体建一个 .tres（快速 / 缓慢、坦克 / 脆皮），拖到 Enemy 节点的
## `data` 导出槽 —— 改数据而不改代码。

@export var max_health: int = 3
@export var patrol_speed: float = 60.0
@export var chase_speed: float = 110.0
@export var patrol_distance: float = 120.0
@export var detection_range: float = 160.0
@export var attack_range: float = 34.0
@export var attack_cooldown: float = 1.0
@export var attack_damage: int = 1
@export var knockback_force: float = 260.0
@export var hitstun_duration: float = 0.25
