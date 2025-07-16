extends Control

var level1 = preload("res://scenes/level1.tscn")

func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		GameManager.host_multiplayer(level1)

func _play_game() -> void:
	GameManager.play_singleplayer(level1)

func _host_game() -> void:
	GameManager.host_multiplayer(level1)

func _join_game() -> void:
	GameManager.join_multiplayer(level1)
