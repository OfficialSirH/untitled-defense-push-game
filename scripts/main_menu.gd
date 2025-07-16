extends Control

var game = preload("res://scenes/game.tscn")

func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		GameManager.host_multiplayer(game)

func _play_game() -> void:
	GameManager.play_singleplayer(game)

func _host_game() -> void:
	GameManager.host_multiplayer(game)

func _join_game() -> void:
	GameManager.join_multiplayer(game)
