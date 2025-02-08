class_name Main_menu extends Node2D

signal create_lobby_pressed()
signal join_lobby_pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_create_lobby_pressed() -> void:
	MultiplayerManager.start_server()

func _on_join_lobby_pressed() -> void:
	MultiplayerManager.start_discovery()
