class_name Tile extends Node2D

@onready var square: ColorRect = $Square

func _ready() -> void:
	# Postavljamo početnu boju (prozirnu)
	# Možeš prilagoditi boju i alpha vrednost po želji (ovde je potpuno prozirna)
	square.color = Color(1, 1, 1, 0)

func highlight_available_squares() -> void:
	# Postavljamo boju na prozirno zelenu
	# Ovde je zelena boja sa 50% prozirnosti (alpha = 0.5)
	square.color = Color(0, 1, 0, 0.3)
	
func highlight_available_attack_squares() ->void:
	square.color = Color(1,0,0,0.3)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
