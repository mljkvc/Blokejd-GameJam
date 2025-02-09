class_name Main_menu extends Node2D

signal create_lobby()
signal join_lobby()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_create_lobby_pressed() -> void:
	MultiplayerManager.start_server(IP.get_local_addresses()[0])
	MultiplayerManager.connect("game_ready", Callable(self, "_on_join_lobby"))

func _on_join_lobby():
	emit_signal("join_lobby")

func _on_join_lobby_pressed() -> void:
	var error = MultiplayerManager.join_server("192.168.1.172", 8080)
	emit_signal("join_lobby")
