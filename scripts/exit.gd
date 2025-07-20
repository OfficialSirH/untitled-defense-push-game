extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var players_at_exit := {}
@export var exit_active := false:
	set(value):
		if exit_active == value:
			return
		exit_active = value
		if exit_active:
			animation_player.play("active")
		else:
			animation_player.play("RESET")


func _on_body_entered(body: Node2D) -> void:
	if !is_multiplayer_authority():
		return
	if body is MultiplayerController or body is Player:
		players_at_exit[body.name] = true
		handle_exit(body.name)


func _on_body_exited(body: Node2D) -> void:
	if !is_multiplayer_authority():
		return
	if body is MultiplayerController or body is Player:
		players_at_exit.erase(body.name)
		handle_exit(body.name)


func handle_exit(name: String) -> void:
	if players_at_exit.size() == MultiplayerManager.player_count:
		victory.rpc()
	exit_active = players_at_exit.size() > 0
	if GameManager.is_singleplayer() and exit_active:
		GameManager.play_next_level(true)

@rpc("any_peer")
func victory() -> void:
	GameManager.play_next_level()
