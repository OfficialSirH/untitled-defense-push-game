extends CharacterBody2D

func SPEED(health) -> int:
	return 200.0 - 1.5 * health

const JUMP_VELOCITY = -200.0
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

func _ready():
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false
	while health > 0:
		$Timer.start()
		await $Timer.timeout
		health = health - 4.0

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
