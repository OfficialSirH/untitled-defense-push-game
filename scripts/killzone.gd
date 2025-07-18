extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	Engine.time_scale = 0.5
	$"../../HUD/DeathScreen".visible = true
	GameManager.score = 0
	timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
