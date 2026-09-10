class_name Enemy
extends CharacterBody2D
## 带简单 AI 状态机的敌人：
## PATROL（来回巡逻）→ CHASE（发现玩家）→ ATTACK（进入攻击范围），
## 以及 HITSTUN（受击后短暂硬直 + 击退）。
## 调参来自 EnemyData 资源（数据驱动），跨系统通信统一走 EventBus。

enum State { PATROL, CHASE, ATTACK, HITSTUN }

@export var data: EnemyData

const ATTACK_SFX := preload("res://assets/audio/sfx/attack.wav")
const HIT_SFX := preload("res://assets/audio/sfx/hit.wav")

var _health: int
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _state: State = State.PATROL
var _spawn_position: Vector2
var _patrol_direction: int = 1  # 1 = 向右，-1 = 向左
var _player: Node2D
var _hitstun_time: float = 0.0
var _attack_cooldown: float = 0.0
var _attack_active_time: float = 0.0

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _hurtbox: Hurtbox = $Hurtbox
@onready var _attack_hitbox: Hitbox = $Hitbox


func _ready() -> void:
	assert(data != null, "Enemy: 请在 Inspector 里给敌人分配 EnemyData 资源。")
	_health = data.max_health
	_spawn_position = global_position
	_player = get_tree().get_first_node_in_group("player") as Node2D
	_hurtbox.hit_received.connect(_on_hit_received)
	_attack_hitbox.damage = data.attack_damage
	_attack_hitbox.deactivate()  # 只在攻击窗口内激活


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _gravity * delta

	_hitstun_time = maxf(_hitstun_time - delta, 0.0)
	_attack_cooldown = maxf(_attack_cooldown - delta, 0.0)
	_tick_attack_hitbox(delta)

	_update_state()
	match _state:
		State.PATROL:
			_patrol()
		State.CHASE:
			_chase()
		State.ATTACK:
			_attack()
		State.HITSTUN:
			velocity.x = move_toward(velocity.x, 0.0, 800.0 * delta)

	_update_facing()
	move_and_slide()


func _update_state() -> void:
	if _hitstun_time > 0.0:
		_state = State.HITSTUN
	elif is_instance_valid(_player):
		var dist := global_position.distance_to(_player.global_position)
		if dist <= data.attack_range:
			_state = State.ATTACK
		elif dist <= data.detection_range:
			_state = State.CHASE
		else:
			_state = State.PATROL
	else:
		_state = State.PATROL


## 在出生点 ± patrol_distance 之间来回走，到边界翻转方向。
func _patrol() -> void:
	var left_edge := _spawn_position.x - data.patrol_distance
	var right_edge := _spawn_position.x + data.patrol_distance
	if _patrol_direction > 0:
		velocity.x = data.patrol_speed
		if global_position.x >= right_edge:
			_patrol_direction = -1
	else:
		velocity.x = -data.patrol_speed
		if global_position.x <= left_edge:
			_patrol_direction = 1


## 追向玩家，直到进入攻击范围。
func _chase() -> void:
	var direction := signf(_player.global_position.x - global_position.x)
	velocity.x = direction * data.chase_speed


## 主动攻击：站定，按冷却时间短暂激活攻击 Hitbox 造成伤害。
func _attack() -> void:
	velocity.x = 0.0
	if _attack_cooldown > 0.0:
		return
	_attack_cooldown = data.attack_cooldown
	_attack_active_time = 0.2
	_attack_hitbox.activate()
	AudioManager.play_sfx(ATTACK_SFX)
	var tween := create_tween()
	tween.tween_property(_sprite, "scale", Vector2(1.25, 0.85), 0.06)
	tween.tween_property(_sprite, "scale", Vector2(1.0, 1.0), 0.12)


## 攻击窗口结束后关闭攻击 Hitbox。
func _tick_attack_hitbox(delta: float) -> void:
	if _attack_active_time > 0.0:
		_attack_active_time -= delta
		if _attack_active_time <= 0.0:
			_attack_hitbox.deactivate()


## 在范围内面向玩家，否则面向巡逻方向。
func _update_facing() -> void:
	if is_instance_valid(_player) and global_position.distance_to(_player.global_position) <= data.detection_range:
		_sprite.flip_h = _player.global_position.x < global_position.x
	else:
		_sprite.flip_h = _patrol_direction < 0


func _on_hit_received(amount: int, source: Node2D) -> void:
	AudioManager.play_sfx(HIT_SFX)
	_health = maxi(_health - amount, 0)
	EventBus.enemy_health_changed.emit(self, _health, data.max_health)
	_flash_hit()
	_apply_knockback(source)
	if _health <= 0:
		_die()


## 把敌人朝远离攻击方的方向击退，并短暂硬直。
func _apply_knockback(source: Node2D) -> void:
	_hitstun_time = data.hitstun_duration
	_state = State.HITSTUN
	var direction := 1.0
	if is_instance_valid(source):
		direction = signf(global_position.x - source.global_position.x)  # 远离攻击方
	velocity.x = direction * data.knockback_force


## 受击时短暂闪白作为反馈。
func _flash_hit() -> void:
	var tween := create_tween()
	tween.tween_property(_sprite, "modulate", Color(2.0, 2.0, 2.0), 0.05)  # 高亮闪白
	tween.tween_property(_sprite, "modulate", Color.WHITE, 0.1)


func _die() -> void:
	EventBus.enemy_died.emit(self)
	queue_free()
