extends Node2D
## 入口场景。通过信号总线串联高层游戏流程。

func _ready() -> void:
	EventBus.player_died.connect(_on_player_died)


func _on_player_died() -> void:
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
