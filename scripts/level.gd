extends Node2D

func _ready() -> void:
	MultiplayerManager.player_count = 0
	GameManager.level_loaded.emit()
