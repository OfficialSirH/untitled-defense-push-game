class_name MultiplayerController
extends CharacterBody2D

@export var MAX_SPEED = 200.0

func SPEED(health) -> int:
	return MAX_SPEED - 1.5 * health

@export var JUMP_VELOCITY = -200.0
@export var movable = true
const PUSH_FORCE = 25.0

var direction = 1
var do_jump = false
var _is_on_floor = true

var coyote_frames = 6
var coyote = false
var last_floor = false
var jumping = false

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
	$CoyoteTimer.wait_time = coyote_frames / 60.0
		
	while health > 0:
		$DamageTimer.start(0.7)
		await $DamageTimer.timeout
		
		health = health - 4.0
		if _is_this_player():
			$DamageEffect.visible = true
		
			$Timer.start(0.3)
			await $DamageTimer.timeout
		
			$DamageEffect.visible = false
		
		if health <= 0.0:
			$"../../HUD/DeathScreen".visible = true
			GameManager.score = 0
			$DamageTimer.start()
			await $DamageTimer.timeout
			get_tree().reload_current_scene()

func _apply_animations(delta):
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true
	
	if _is_on_floor:
		jumping = false
		if direction == 0:
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
	
func _apply_movement_from_input(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if do_jump and (is_on_floor() or coyote):
		velocity.y = JUMP_VELOCITY
		do_jump = false
		jumping = true
		
	if !is_on_floor() and last_floor and !jumping:
		coyote = true
		$CoyoteTimer.start()

	direction = $InputSynchronizer.input_direction
	
	if direction:
		velocity.x = direction * SPEED(health)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED(health))

	if movable:
		move_and_slide()
		
	last_floor = is_on_floor()
	
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

func _on_coyote_timer_timeout():
	coyote = false
