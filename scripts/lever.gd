extends Area2D

func _physics_process(delta: float) -> void:
	for i in get_overlapping_bodies():
		if i is CharacterBody2D:
			$AnimatedSprite2D.play("default")
			# Lever can do anything here
