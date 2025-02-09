extends Node2D
#crni kralj = +1 beli krelj = -1
var your_tile_name = "d_1"
var your_position: Vector2 = Vector2(7,4)
var your_current_piece: int = 1 #-1 za crne 1 za bele (crnci < belci jer rasizam)[SALA MALA]
@onready var piece: Sprite2D = $piece

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
