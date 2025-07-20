extends Node

enum GameType {
	SINGLEPLAYER,
	MULTIPLAYER_HOST,
	MULTIPLAYER_CLIENT,
}

# Signal that will be emitted by level scenes when they are loaded
signal level_loaded()

@onready var MultiplayerManager = $"/root/MultiplayerManager"
@export var score := 0:
	set(new_score):
		score = new_score

#var is_singleplayer := false

var _game_type = GameType.SINGLEPLAYER

# Register our handler for scenes
func _ready() -> void:
	level_loaded.connect(_handle_level_load)


func _handle_level_load():
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
	#is_singleplayer = true
	get_tree().change_scene_to_packed(game)
	_game_type = GameType.SINGLEPLAYER


func host_multiplayer(game: Resource):
	get_tree().change_scene_to_packed(game)
	_game_type = GameType.MULTIPLAYER_HOST


func join_multiplayer(game: Resource):
	get_tree().change_scene_to_packed(game)
	_game_type = GameType.MULTIPLAYER_CLIENT


#func is_singleplayer_update() -> bool:
	#is_singleplayer = (get_tree().get_current_scene().get_node("Players")
			#.get_child(0).name == "Player")
	#return is_singleplayer

func is_singleplayer() -> bool:
	return _game_type == GameType.SINGLEPLAYER


func play_next_level(is_singleplayer := false):
	# get the current level number from the substring excluding "level"
	# in the name of the scene
	var current_level := int(get_tree().root.name.substr(5))
	var next_level_name = "level" + str(current_level + 1)
	var next_level = load("res://scenes/" + next_level_name + ".tscn")
	if next_level == null:
		print("""
				This seems to be the end of the game or the next level loader
				 couldn't find another level
				""")
		return
	get_tree().change_scene_to_packed(next_level)
	# Maybe the below code is unnecessary?
	#if is_singleplayer:
		#play_singleplayer(next_level)
		#return
	#
	#if is_multiplayer_authority():
		#host_multiplayer(next_level)
	#else:
		#join_multiplayer(next_level)
