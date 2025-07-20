extends RigidBody2D

func _physics_process(delta: float) -> void:
	for i in get_colliding_bodies():
		if i is CharacterBody2D:
			var current_maximum_speed = i.MAX_SPEED
			i.MAX_SPEED = 800.0
			$Timer.start()
			await $Timer.timeout
			i.MAX_SPEED = current_maximum_speed
