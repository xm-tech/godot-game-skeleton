extends CanvasLayer
## HUD 监听全局信号 —— 不持有对 Player 或 Enemy 的引用，这正是 Event Bus 模式的意义。

@onready var _health_label: Label = $MarginContainer/VBoxContainer/HealthLabel
@onready var _jump_label: Label = $MarginContainer/VBoxContainer/JumpLabel
@onready var _score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel

var _jumps: int = 0
var _score: int = 0


func _ready() -> void:
	EventBus.player_health_changed.connect(_on_health_changed)
	EventBus.player_jumped.connect(_on_player_jumped)
	EventBus.enemy_died.connect(_on_enemy_died)


func _on_health_changed(current: int, maximum: int) -> void:
	_health_label.text = "HP: %d / %d" % [current, maximum]


func _on_player_jumped() -> void:
	_jumps += 1
	_jump_label.text = "Jumps: %d" % _jumps


func _on_enemy_died(_enemy: Node) -> void:
	_score += 1
	_score_label.text = "Score: %d" % _score
	EventBus.score_changed.emit(_score)
