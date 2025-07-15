extends Node

@onready var MultiplayerManager = $"/root/MultiplayerManager"

func become_host():
	print("Become host pressed")
	$"../MultiplayerHUD".hide()
	MultiplayerManager.become_host()

func join_host():
	print("Join host pressed")
	$"../MultiplayerHUD".hide()
	MultiplayerManager.join_host()
