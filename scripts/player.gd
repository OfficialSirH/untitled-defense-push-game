class_name Player
extends CharacterBody2D

@export var MAX_SPEED = 200.0:
	set(speed):
		print(speed)
		MAX_SPEED = speed

func SPEED(health) -> int:
	return MAX_SPEED - 1.5 * health

@export var JUMP_VELOCITY = -200.0
@export var movable = true
const PUSH_FORCE = 25.0

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

var coyote = false

func _ready() -> void:
	camera.make_current()
	
	while health > 0:
		$DamageTimer.start(0.7)
		await $DamageTimer.timeout
		
		health = health - 4.0
		$DamageEffect.visible = true
		
		$DamageTimer.start(0.3)
		await $DamageTimer.timeout
		
		$DamageEffect.visible = false
		
		if health <= 0.0:
			$"../../HUD/DeathScreen".visible = true
			GameManager.score = 0
			$DamageTimer.start()
			await $DamageTimer.timeout
			get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not coyote:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote):
		velocity.y = JUMP_VELOCITY
		coyote = false
		$CoyoteTimer.start()

	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED(health)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED(health))
	
	var was_on_floor = is_on_floor()
	if movable:
		move_and_slide()
	if was_on_floor and not is_on_floor() and velocity.y >= 0:
		coyote = true
		$CoyoteTimer.start()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)

func _on_coyote_timer_timeout():
	coyote = false
