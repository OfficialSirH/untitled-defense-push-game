extends Node

@onready var MultiplayerManager = $"/root/MultiplayerManager"

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Become host pressed")
		MultiplayerManager.become_host()

func become_host():
	print("Become host pressed")
	$"../MultiplayerHUD".hide()
	MultiplayerManager.become_host()

func join_host():
	print("Join host pressed")
	$"../MultiplayerHUD".hide()
	MultiplayerManager.join_host()
