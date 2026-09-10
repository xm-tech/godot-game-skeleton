class_name Hurtbox
extends Area2D
## 被动受击方。发射 `hit_received(amount, source)`；由拥有者决定怎么处理
## （扣血、击退、闪白、播放音效等）。

signal hit_received(amount: int, source: Node2D)


func _ready() -> void:
	monitoring = false   # Hurtbox 是被检测方，自身不检测
	monitorable = true


## 由重叠本 Hurtbox 的 Hitbox 调用。[param source] 是造成伤害的 Hitbox
## （用于计算击退方向）。
func take_hit(amount: int, source: Node2D = null) -> void:
	hit_received.emit(amount, source)
