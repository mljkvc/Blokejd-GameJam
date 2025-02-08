class_name Choose_a_piece extends Node2D

signal piece_chosen(piece_name: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_pawn_pressed() -> void:
	pass # Replace with function body.

func _on_bishop_pressed() -> void:
	pass # Replace with function body.

func _on_knight_pressed() -> void:
	pass # Replace with function body.
	

func _on_rook_pressed() -> void:
	emit_signal("piece_chosen", "rook")


func _on_queen_pressed() -> void:
	pass # Replace with function body.
