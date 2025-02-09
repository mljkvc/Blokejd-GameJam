class_name Main_menu extends Node2D

@onready var create_lobby_button = $create_lobby
@onready var join_lobby_button = $join_lobby

signal create_lobby()
signal join_lobby()
signal set_your_pieces_to_white()
signal set_your_pieces_to_black()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_create_lobby_pressed() -> void:
	MultiplayerManager.start_server(IP.get_local_addresses()[0])
	MultiplayerManager.connect("game_ready", Callable(self, "_on_join_lobby"))
	emit_signal("set_your_pieces_to_white")
	
func _on_join_lobby():
	emit_signal("join_lobby")

func _on_join_lobby_pressed() -> void:
	var error = MultiplayerManager.join_server("192.168.1.172", 8080)
	emit_signal("join_lobby")
	emit_signal("set_your_pieces_to_black")


func _on_button_mouse_entered() -> void:
	$Button.scale.x += 0.1
	$Button.scale.y += 0.1
	$Button.position.x -= 40

func _on_button_mouse_exited() -> void:
	$Button.scale.x -= 0.1
	$Button.scale.y -= 0.1
	$Button.position.x += 40

func _on_button_2_mouse_entered() -> void:
	$Button2.scale.x += 0.1
	$Button2.scale.y += 0.1
	$Button2.position.x -= 40

func _on_button_2_mouse_exited() -> void:
	$Button2.scale.x -= 0.1
	$Button2.scale.y -= 0.1
	$Button2.position.x += 40
