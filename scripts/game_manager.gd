extends Node

enum GameType {
	SINGLEPLAYER,
	MULTIPLAYER_HOST,
	MULTIPLAYER_CLIENT,
}

@onready var MultiplayerManager = $"/root/MultiplayerManager"

var _game_type = GameType.SINGLEPLAYER


#func _enter_tree() -> void:
	#var current_scene = get_tree().get_current_scene()
	#print(current_scene.name)
	#if current_scene.name != "Game":
		#return
	#match _game_type:
		#GameType.SINGLEPLAYER:
			#var players_node = current_scene.get_node("Players")
			#var player = load("res://scenes/player.tscn").instantiate()
			#players_node.add_child(player)
		#GameType.MULTIPLAYER_HOST:
			#MultiplayerManager.become_host()
		#GameType.MULTIPLAYER_CLIENT:
			#MultiplayerManager.join_host()
		#_:
			#print("erm... what the sigma?")

func _is_game_tree(current_scene = get_tree().get_current_scene()) -> bool:
	return current_scene.name == "Game"

func _tree_ready_play_singleplayer() -> void:
	tree_entered.disconnect(_tree_ready_play_singleplayer)
	var current_scene = get_tree().get_current_scene()
	if not _is_game_tree(current_scene):
		return
	var players_node = current_scene.get_node("Players")
	var player = load("res://scenes/player.tscn").instantiate()
	players_node.add_child(player)
	

func _tree_ready_host_multiplayer() -> void:
	tree_entered.disconnect(_tree_ready_host_multiplayer)
	MultiplayerManager.become_host()
	
func _tree_ready_play_multiplayer() -> void:
	tree_entered.disconnect(_tree_ready_play_multiplayer)
	MultiplayerManager.join_host()

func play_singleplayer(game: Resource) -> void:
	get_tree().change_scene_to_packed(game)
	tree_entered.connect(_tree_ready_play_singleplayer)


func host_multiplayer(game: Resource):
	get_tree().change_scene_to_packed(game)
	tree_entered.connect(_tree_ready_host_multiplayer)


func join_multiplayer(game: Resource):
	get_tree().change_scene_to_packed(game)
	tree_entered.connect(_tree_ready_play_multiplayer)
