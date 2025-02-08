class_name Main_scene extends Node2D

var choose_a_piece_node = null

var your_piece: String = "king"

var your_current_tile: String = "d_1" #format a_1 ->(7,0)

@onready var Board = $Board
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

func is_valid(position: Vector2) -> bool:
	if position.x < 0 or position.y < 0:
		return false
	if position.x > 7 or position.y > 7:
		return false
	return true

func highlight_available_tiles() -> void:
	var available_tiles_array: Array = []
	var coord: Vector2 = tile_name_to_matrix_representation(your_current_tile)
	if your_piece == "pawn":
		pass #pijuni zajebaniji nego sto deluju 
	
	if your_piece == "bishop":
		var new_coords = []
		for i in range(1,4):
			new_coords.append(coord + Vector2(i,i))
			new_coords.append(coord + Vector2(-i,i))
			new_coords.append(coord + Vector2(i,-i))
			new_coords.append(coord + Vector2(-i,-i))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
			
	if your_piece == "knight":
		var new_coords = []		
		new_coords.append(coord + Vector2(1,2))
		new_coords.append(coord + Vector2(1,-2))
		new_coords.append(coord + Vector2(-1,2))
		new_coords.append(coord + Vector2(-1,-2))
		new_coords.append(coord + Vector2(2,1))
		new_coords.append(coord + Vector2(2,-1))
		new_coords.append(coord + Vector2(-2,1))
		new_coords.append(coord + Vector2(-2,-1))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)

		
	if your_piece == "rook":
		var new_coords = []
		for i in range(1,4):
			new_coords.append(coord + Vector2(0,i))
			new_coords.append(coord + Vector2(0,-i))
			new_coords.append(coord + Vector2(i,0))
			new_coords.append(coord + Vector2(-i,0))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
	
	if your_piece == "queen":
		var new_coords = []
		for i in range(1,5):
			new_coords.append(coord + Vector2(i,i))
			new_coords.append(coord + Vector2(-i,i))
			new_coords.append(coord + Vector2(i,-i))
			new_coords.append(coord + Vector2(-i,-i))
			new_coords.append(coord + Vector2(0,i))
			new_coords.append(coord + Vector2(0,-i))
			new_coords.append(coord + Vector2(i,0))
			new_coords.append(coord + Vector2(-i,0))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
	for tile in Board.get_children():
		if tile.name in available_tiles_array:
			if tile is Tile:
				tile.highlight_available_squares()

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
	var column_letter = char('a'.unicode_at(0) + int(matrix_representation.x))
	
	var row_number = matrix_representation.y + 1
	
	return column_letter + "_" + str(row_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
