extends Area2D

func _ready() -> void:
	$"../Score/Label".text = str(GameManager.score)

func _on_body_entered(body: Node2D) -> void:
	GameManager.score += 1
	$"../Score/Label".text = str(GameManager.score)
	queue_free()
