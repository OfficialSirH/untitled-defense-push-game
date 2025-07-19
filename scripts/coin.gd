extends Area2D

func _ready() -> void:
	$"../../HUD/ScoreLabel".text = str(GameManager.score)

func _on_body_entered(body: Node2D) -> void:
	GameManager.score += 1
	$"../../HUD/ScoreLabel".text = str(GameManager.score)
	queue_free()
