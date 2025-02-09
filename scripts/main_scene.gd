class_name Main_scene extends Node2D

@onready var choose_a_piece_node = $ChooseAPiece 
@onready var call_out_opponent_node = $CallOutOpponent
@onready var Board = $Board
@onready var your_king = $You

var your_piece: String = "king"

var your_current_tile: String = "d_1" #format a_1 ->(7,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_pieces_choice()
	
	your_king.position = Board.get_node(your_current_tile).global_position
	
	for tile in Board.get_children():
		if tile is Tile:
			tile.connect("piece_moved", Callable(self, "_on_piece_moved"))


func _on_piece_moved(new_tile_name: String) -> void:
	print("Tile moved: " + new_tile_name)
	your_current_tile = new_tile_name
	var new_tile = Board.get_node(new_tile_name)
	your_king.position = new_tile.global_position
	
		
	#func make_move(player_id, x, y, piece_data, lied):
	print("My peer ID:", multiplayer.get_unique_id())

	rpc_id(multiplayer.get_remote_sender_id(), "make_move", 1, tile_name_to_matrix_representation(your_current_tile).x,  tile_name_to_matrix_representation(your_current_tile).y, 1, false)
	print(MultiplayerManager.player2_pos[0], MultiplayerManager.player2_pos[1])
	unhighlight_all_squares()

func unhighlight_all_squares() -> void:
	for tile in Board.get_children():
		if tile is Tile:
			tile.unhighlight_this_square()
			tile.tile_is_available_for_movement = false

	
func show_pieces_choice() -> void:
	choose_a_piece_node.hide()
	choose_a_piece_node = $ChooseAPiece  # Zameni putanju ako je drugačija
	choose_a_piece_node.connect("piece_chosen", Callable(self, "_on_piece_chosen"))
	call_out_opponent_node = $CallOutOpponent
	call_out_opponent_node.connect("ok_button_pressed", Callable(self, "_on_ok_button_pressed"))
	call_out_opponent_node.connect("scam_button_pressed", Callable(self, "_on_scam_button_pressed"))

func _on_ok_button_pressed() -> void:
	print('ok')
	call_out_opponent_node.hide()
	choose_a_piece_node.show()


func _on_scam_button_pressed() -> void:
	print('scam')
	call_out_opponent_node.hide()
	choose_a_piece_node.show()
	
func _on_piece_chosen(piece_name: String) -> void:
	if your_piece != "king":
		unhighlight_all_squares()

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
		your_king.piece.texture = load("res://sprites/chess_pieces/beli_piun.png")
		var new_coords = []
		new_coords.append(coord + Vector2(0,your_king.your_color))
		new_coords.append(coord + Vector2(1,your_king.your_color))
		new_coords.append(coord + Vector2(-1,your_king.your_color))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
		
	
	if your_piece == "bishop":
		your_king.piece.texture = load("res://sprites/chess_pieces/beli_lovac.png")
		var new_coords = []
		for i in range(1,4):
			new_coords.append(coord + Vector2(i,i))
			new_coords.append(coord + Vector2(-i,i))
			new_coords.append(coord + Vector2(i,-i))
			new_coords.append(coord + Vector2(-i,-i))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
			
	if your_piece == "knight":
		your_king.piece.texture = load("res://sprites/chess_pieces/beli_konj.png")
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
		your_king.piece.texture = load("res://sprites/chess_pieces/beli_top.png")
		var new_coords = []
		for i in range(1,4):
			new_coords.append(coord + Vector2(0,i))
			new_coords.append(coord + Vector2(0,-i))
			new_coords.append(coord + Vector2(i,0))
			new_coords.append(coord + Vector2(-i,0))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
	
	if your_piece == "queen":
		your_king.piece.texture = load("res://sprites/chess_pieces/bela_kraljica.png")
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
				tile.highlight_this_square_for_movement()
				tile.tile_is_available_for_movement = true
				
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
