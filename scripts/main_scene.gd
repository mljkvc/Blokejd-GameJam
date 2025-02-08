class_name Main_scene extends Node2D

var choose_a_piece_node = null

var your_piece: String = "king"

var your_current_tile: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_pieces_choice()

func show_pieces_choice() -> void:
	choose_a_piece_node = $ChooseAPiece  # Zameni putanju ako je drugačija
	choose_a_piece_node.connect("piece_chosen", Callable(self, "_on_piece_chosen"))
	

	
func _on_piece_chosen(piece_name: String) -> void:
	print("Your piece is: ", piece_name)
	your_piece = piece_name
	highlight_available_tiles()


func highlight_available_tiles() -> void:
	var available_tiles_array: Array = []
	if your_piece == "pawn":
		pass
	
	if your_piece == "bishop":
		pass
	
	if your_piece == "knight":
		pass
		
	if your_piece == "rook":
		pass
	
	if your_piece == "queen":
		pass
		

func tile_name_to_matrix_representation(tile_name: String) -> Vector2:
	var parts = tile_name.split("_")
	if parts.size() != 2:
		push_error("Invalid tile name format")
		return Vector2(-1, -1)
	
	var column_letter = parts[0]
	var row_number = parts[1].to_int() - 1
	
	var column_index = column_letter.unicode_at(0) - 'a'.unicode_at(0)
	
	return Vector2(column_index, row_number)

func matrix_representation_to_tile_name(matrix_representation: Vector2) -> String:
	var column_letter = char('a'.unicode_at(0) + matrix_representation.x)
	var row_number = matrix_representation.y + 1
	
	return column_letter + "_" + str(row_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
