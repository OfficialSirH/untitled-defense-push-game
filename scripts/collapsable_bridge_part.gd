extends StaticBody2D

func _physics_process(delta: float) -> void:
	for i in $Area2D.get_overlapping_bodies():
		if i is CharacterBody2D and i.velocity.x > 50:
			$AnimationPlayer.play("RESET")
