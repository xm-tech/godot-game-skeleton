class_name Player
extends CharacterBody2D
## 演示状态机模式的玩家控制器。
## 调参来自 PlayerData 资源（数据驱动），视觉反馈来自 AnimationPlayer
## （状态 → 动画），战斗使用可复用的 Hitbox / Hurtbox 组件。

enum State { IDLE, RUN, JUMP, FALL }

@export var data: PlayerData
@export var attack_damage: int = 1
@export var knockback_force: float = 260.0
@export var hitstun_duration: float = 0.2

const JUMP_SFX := preload("res://assets/audio/sfx/jump.wav")
const ATTACK_SFX := preload("res://assets/audio/sfx/attack.wav")
const HIT_SFX := preload("res://assets/audio/sfx/hit.wav")

var _state: State = State.IDLE
var _health: int
var _attacking: bool = false
var _hitstun_time: float = 0.0
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _animation: AnimationPlayer = $AnimationPlayer
@onready var _hurtbox: Hurtbox = $Hurtbox
@onready var _attack_hitbox: Hitbox = $AttackHitbox


func _ready() -> void:
	assert(data != null, "Player: 请在 Inspector 里给玩家分配 PlayerData 资源。")
	add_to_group("player")
	_health = data.max_health
	EventBus.player_health_changed.emit(_health, data.max_health)
	_hurtbox.hit_received.connect(_on_hit_received)


func _physics_process(delta: float) -> void:
	_hitstun_time = maxf(_hitstun_time - delta, 0.0)
	if not is_on_floor():
		velocity.y += _gravity * delta

	if _hitstun_time > 0.0:
		# 硬直中：不响应输入，让击退速度自然衰减。
		velocity.x = move_toward(velocity.x, 0.0, 800.0 * delta)
		move_and_slide()
		_update_state(0.0)
		_update_animation()
		return

	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * data.move_speed, data.acceleration * delta)
		_sprite.flip_h = direction < 0.0  # 面向移动方向
	else:
		velocity.x = move_toward(velocity.x, 0.0, data.friction * delta)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = data.jump_velocity
		EventBus.player_jumped.emit()
		AudioManager.play_sfx(JUMP_SFX)

	if Input.is_action_just_pressed("attack"):
		_do_attack()

	move_and_slide()
	_update_state(direction)
	_update_animation()


func take_damage(amount: int, source: Node2D = null) -> void:
	AudioManager.play_sfx(HIT_SFX)
	_health = maxi(_health - amount, 0)
	EventBus.player_health_changed.emit(_health, data.max_health)
	_apply_knockback(source)
	if _health == 0:
		EventBus.player_died.emit()


## 把玩家朝远离攻击方的方向击退，并短暂硬直。
func _apply_knockback(source: Node2D) -> void:
	_hitstun_time = hitstun_duration
	var direction := 1.0
	if is_instance_valid(source):
		direction = signf(global_position.x - source.global_position.x)  # 远离攻击方
	velocity.x = direction * knockback_force


## Hurtbox 回调：敌人的接触伤害。
func _on_hit_received(amount: int, source: Node2D) -> void:
	take_damage(amount, source)


## 近战攻击：短暂激活攻击 Hitbox 并播放攻击动画。
func _do_attack() -> void:
	if _attacking:
		return
	_attacking = true
	AudioManager.play_sfx(ATTACK_SFX)
	_animation.play("attack")
	_attack_hitbox.activate()
	await get_tree().create_timer(0.15).timeout
	_attack_hitbox.deactivate()
	_attacking = false


func _update_state(direction: float) -> void:
	if not is_on_floor():
		_state = State.JUMP if velocity.y < 0.0 else State.FALL
	elif direction != 0.0:
		_state = State.RUN
	else:
		_state = State.IDLE


## 根据当前状态驱动 AnimationPlayer。只在动画真正变化时才调用 play()，
## 避免每帧重启正在播放的动画。一次性动作（攻击）优先，会临时绕过这里。
func _update_animation() -> void:
	if _attacking:
		return
	var animation_name := _state_name()
	if _animation.current_animation != animation_name:
		_animation.play(animation_name)


## 状态 → 动画名。这些名字要和 player.tscn 里的 AnimationPlayer 库保持一致。
func _state_name() -> String:
	match _state:
		State.IDLE:
			return "idle"
		State.RUN:
			return "run"
		State.JUMP:
			return "jump"
		State.FALL:
			return "fall"
	return "idle"
