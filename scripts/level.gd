extends Node2D

func _ready() -> void:
	GameManager.level_load.emit()
