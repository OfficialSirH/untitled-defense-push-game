extends Node

enum GameType {
	SINGLEPLAYER,
	MULTIPLAYER_HOST,
	MULTIPLAYER_CLIENT,
}

@onready var MultiplayerManager = $"/root/MultiplayerManager"
@export var score := 0:
	set(new_score):
		score = new_score

var _game_type = GameType.SINGLEPLAYER

# Signal that will be emitted by level scenes when they are loaded
signal level_load()

# Register our handler for scenes
func _ready() -> void:
	level_load.connect(handle_level_load)
	
func handle_level_load():
	var current_scene = get_tree().get_current_scene()

	match _game_type:
		GameType.SINGLEPLAYER:
			var players_node = current_scene.get_node("Players")
			var player = load("res://scenes/player.tscn").instantiate()
			players_node.add_child(player)
		GameType.MULTIPLAYER_HOST:
			MultiplayerManager.become_host()
		GameType.MULTIPLAYER_CLIENT:
			MultiplayerManager.join_host()

func play_singleplayer(game: Resource) -> void:
	get_tree().change_scene_to_packed(game)
	_game_type = GameType.SINGLEPLAYER

func host_multiplayer(game: Resource):
	get_tree().change_scene_to_packed(game)
	_game_type = GameType.MULTIPLAYER_HOST

func join_multiplayer(game: Resource):
	get_tree().change_scene_to_packed(game)
	_game_type = GameType.MULTIPLAYER_CLIENT
