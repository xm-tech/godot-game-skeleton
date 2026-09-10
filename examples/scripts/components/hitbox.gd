class_name Hitbox
extends Area2D
## 对重叠的 Hurtbox 造成伤害。
##
## 两种用法：
## - 接触伤害：保持 `monitoring` 开启（默认）；Hitbox 会对碰到的 Hurtbox 造成伤害。
## - 主动攻击：在 Inspector 里保持 `monitoring` 关闭，在攻击窗口内调用
##   activate() / deactivate()（参见 player.gd）。

@export var damage: int = 1


func _ready() -> void:
	monitorable = false  # Hitbox 负责检测，自身不被检测
	area_entered.connect(_on_area_entered)


## 开始检测（用于主动攻击）。
func activate() -> void:
	monitoring = true


## 停止检测（用于主动攻击）。
func deactivate() -> void:
	monitoring = false


func _on_area_entered(area: Area2D) -> void:
	var hurtbox := area as Hurtbox
	if hurtbox:
		hurtbox.take_hit(damage, self)
