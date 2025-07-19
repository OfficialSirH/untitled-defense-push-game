extends Area2D

var is_finished = false

func _physics_process(delta: float) -> void:
	for i in get_overlapping_bodies():
		if i is CharacterBody2D and is_finished == false:
			is_finished = true
			i.JUMP_VELOCITY -= 100.0
			i.JumpEffect.visible = true
			$AnimationPlayer.play("RESET")
			$Timer.start()
			await $Timer.timeout
			i.JUMP_VELOCITY += 100.0
			i.JumpEffect.visible = false
