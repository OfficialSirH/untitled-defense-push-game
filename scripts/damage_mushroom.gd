extends Area2D

var debounce = false

func _physics_process(delta: float) -> void:
	for i in get_overlapping_bodies():
		if i is CharacterBody2D and not debounce:
			i.health -= 4.0
			debounce = true
			$Timer.start()
			await $Timer.timeout
			debounce = false
