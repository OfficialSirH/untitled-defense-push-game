extends Area2D

var is_finished = false

func _physics_process(delta: float) -> void:
	for i in get_overlapping_bodies():
		if i is CharacterBody2D and is_finished == false:
			i.health = i.health + 15.0
			is_finished = true
			i.HealEffect.visible = true
			$AnimationPlayer.play("RESET")
			await $AnimationPlayer.animation_finished
			i.HealEffect.visible = false
