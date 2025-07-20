class_name MultiplayerController
extends CharacterBody2D

func SPEED(health) -> int:
	return 200.0 - 1.5 * health

@export var JUMP_VELOCITY = -200.0
@export var movable = true
const PUSH_FORCE = 25.0

var direction = 1
var do_jump = false
var _is_on_floor = true

@export var player_id := 1:
	set(id):
		player_id = id
		$InputSynchronizer.set_multiplayer_authority(id)

@export var health := 100.0:
	set(new_health):
		if new_health > 100.0:
			new_health = 100.0
		$HealthBar/Health.size = Vector2(new_health/20.0, 5.0)
		health = new_health
		
		
@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var HealEffect = $HealEffect
@onready var JumpEffect = $JumpEffect
@onready var FreezeEffect = $FreezeEffect

func _ready():
	if _is_this_player():
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false
	while health > 0:
		$Timer.start(0.7)
		await $Timer.timeout
		
		health = health - 4.0
		if _is_this_player():
			$DamageEffect.visible = true
		
			$Timer.start(0.3)
			await $Timer.timeout
		
			$DamageEffect.visible = false
		
		if health <= 0.0:
			$"../../HUD/DeathScreen".visible = true
			GameManager.score = 0
			$Timer.start()
			await $Timer.timeout
			get_tree().reload_current_scene()

func _apply_animations(delta):
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true
	
	if _is_on_floor:
		if direction == 0:
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
	
func _apply_movement_from_input(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if do_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
		do_jump = false

	direction = $InputSynchronizer.input_direction
	
	if direction:
		velocity.x = direction * SPEED(health)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED(health))

	if movable:
		move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)


func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		_is_on_floor = is_on_floor()
		_apply_movement_from_input(delta)
	
	if not multiplayer.is_server() || MultiplayerManager.host_mode_enable:
		_apply_animations(delta)

func _is_this_player() -> bool:
	return multiplayer.get_unique_id() == player_id
