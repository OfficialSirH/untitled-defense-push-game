extends Area2D

var is_finished = false

func _physics_process(delta: float) -> void:
	for i in get_overlapping_bodies():
		if i is CharacterBody2D and is_finished == false:
			is_finished = true
			i.movable = false
			$AnimationPlayer.play("RESET")
			$Timer.start()
			await $Timer.timeout
			i.movable = true
