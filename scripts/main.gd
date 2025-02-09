extends Node2D

@onready var main_scene = $MainScene
@onready var main_menu = $MainMenu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene.hide()
	main_menu.connect("join_lobby", Callable(self, "_on_join_lobby"))

func _on_join_lobby():
	print("desi brate2")
	main_menu.hide()
	main_scene.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
