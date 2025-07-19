extends Area2D

func _physics_process(delta: float) -> void:
	for i in get_overlapping_bodies():
		if i is CharacterBody2D:
			i.velocity.y = i.JUMP_VELOCITY*2
			i.move_and_slide()
