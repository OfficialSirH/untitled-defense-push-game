extends Area2D

var is_finished = false

func _physics_process(delta: float) -> void:
	for i in get_overlapping_bodies():
		if i is CharacterBody2D and is_finished == false:
			$AnimationPlayer.play("RESET")
