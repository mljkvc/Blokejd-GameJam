class_name Tile extends Node2D

@onready var square: ColorRect = $Square

var mouse_is_inside_this_square = false
var tile_is_available_for_movement = false

signal piece_moved(new_tile: String)

func _ready() -> void:
	# Postavljamo početnu boju (prozirnu)
	# Možeš prilagoditi boju i alpha vrednost po želji (ovde je potpuno prozirna)
	square.color = Color(1, 1, 1, 0)

func unhighlight_this_square() -> void:
	square.color = Color(1, 1, 1, 0)

func highlight_this_square_for_movement() -> void:
	# Postavljamo boju na prozirno zelenu
	# Ovde je zelena boja sa 50% prozirnosti (alpha = 0.5)
	square.color = Color(0, 1, 0, 0.2)
	
func highlight_this_square_for_attack() ->void:
	square.color = Color(1,0,0,0.2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



	
func _input(event):
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT and event.pressed and mouse_is_inside_this_square and tile_is_available_for_movement:
		emit_signal("piece_moved", self.name)



func _on_square_mouse_entered() -> void:
	mouse_is_inside_this_square = true

func _on_square_mouse_exited() -> void:
	mouse_is_inside_this_square = false
