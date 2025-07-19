extends RigidBody2D

@export var replicated_position: Vector2
@export var replicated_linear_velocity: Vector2

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if is_multiplayer_authority():
		replicated_position = position
		replicated_linear_velocity = linear_velocity
	else:
		position = replicated_position
		linear_velocity = replicated_linear_velocity
