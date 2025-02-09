class_name Main_scene extends Node2D

@onready var choose_a_piece_node = $ChooseAPiece
@onready var white_pieces = $ChooseAPiece/ChooseAPieceWhite
@onready var black_pieces = $ChooseAPiece/ChooseAPieceBlack
var your_pieces = null

@onready var white_king = $White
@onready var black_king = $Black

@onready var call_out_opponent_node = $CallOutOpponent
@onready var Board = $Board

var your_king = null
var enemy_king = null
@onready var diamond = $Diamond

var you_are_white: bool = false

var your_piece: String = "king"

var your_current_tile: String = "d_1" #format a_1 ->(7,0)
var enemy_current_tile: String = "e_8"
var diamond_tile: String = "b_5"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	diamond.position = Board.get_node(diamond_tile).global_position
	diamond.animation.play("diamond_animation")

	for tile in Board.get_children():
		if tile is Tile:
			tile.connect("piece_moved", Callable(self, "_on_piece_moved"))

func assign_white_pieces() -> void:
	choose_a_piece_node.remove_child(black_pieces)
	your_pieces = white_pieces
	your_king = white_king
	enemy_king = black_king
	your_current_tile = "d_1" 
	enemy_current_tile = "e_8"
	show_pieces_choice()
	enemy_king.position = Board.get_node(enemy_current_tile).global_position
	your_king.position = Board.get_node(your_current_tile).global_position
	
func assign_black_pieces() -> void:
	choose_a_piece_node.remove_child(white_pieces)
	your_pieces = black_pieces
	your_king = black_king
	enemy_king = white_king
	your_current_tile = "e_8" 
	enemy_current_tile = "d_1"
	show_pieces_choice()
	enemy_king.position = Board.get_node(enemy_current_tile).global_position
	your_king.position = Board.get_node(your_current_tile).global_position
	
func remove_all_objects_from_the_board() -> void:
	$White.position = Vector2(-100,-100)
	$Black.position = Vector2(-100,-100)
	$Diamond.position = Vector2(-100,-100)
		
func _on_piece_moved(new_tile_name: String) -> void:
	print("Tile moved: " + new_tile_name)
	your_current_tile = new_tile_name
	var new_tile = Board.get_node(new_tile_name)
	your_king.position = new_tile.global_position
	
		
	#func make_move(player_id, x, y, piece_data, lied):
	print("My peer ID:", multiplayer.get_unique_id())
	MultiplayerManager.make_move(multiplayer.get_unique_id(), tile_name_to_matrix_representation(your_current_tile).x,  tile_name_to_matrix_representation(your_current_tile).y, "q", false)
	remove_all_objects_from_the_board()
	position_all_objects_on_the_board()
	print(MultiplayerManager.board)
	
	unhighlight_all_squares()

func position_all_objects_on_the_board() -> void:
	
	var diamond_tile_name = null
	var white_king_tile_name = null
	var black_king_tile_name = null
	for i in range(8):
		for j in range (8):
			if MultiplayerManager.board[i][j] == 7:
				diamond_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == -1:
				black_king.this_piece = "king"
				black_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == -2:
				black_king.this_piece = "pawn"
				black_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == -3:
				black_king.this_piece = "knight"
				black_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == -4:
				black_king.this_piece = "bishop"
				black_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == -5:
				black_king.this_piece = "rook"
				black_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == -6:
				black_king.this_piece = "queen"
				black_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == 1:
				white_king.this_piece = "king"
				white_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == 2:
				white_king.this_piece = "pawn"
				white_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == 3:
				white_king.this_piece = "knight"
				white_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == 4:
				white_king.this_piece = "bishop"
				white_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == 5:
				white_king.this_piece = "rook"
				white_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
			if MultiplayerManager.board[i][j] == 6:
				white_king.this_piece = "queen"
				white_king_tile_name = matrix_representation_to_tile_name(Vector2(i,j))
	
	white_king.position = Board.get_node(white_king_tile_name).global_position
	black_king.position = Board.get_node(black_king_tile_name).global_position
				
	diamond.position = Board.get_node(diamond_tile_name).global_position


func unhighlight_all_squares() -> void:
	for tile in Board.get_children():
		if tile is Tile:
			tile.unhighlight_this_square()
			tile.tile_is_available_for_movement = false

	
func show_pieces_choice() -> void:
	your_pieces.hide()
	#choose_a_piece_node = $ChooseAPiece
	your_pieces.connect("piece_chosen", Callable(self, "_on_piece_chosen"))
	call_out_opponent_node = $CallOutOpponent
	call_out_opponent_node.connect("ok_button_pressed", Callable(self, "_on_ok_button_pressed"))
	call_out_opponent_node.connect("scam_button_pressed", Callable(self, "_on_scam_button_pressed"))

func _on_ok_button_pressed() -> void:
	print('ok')
	call_out_opponent_node.hide()
	your_pieces.show()


func _on_scam_button_pressed() -> void:
	print('scam')
	call_out_opponent_node.hide()
	your_pieces.show()
	
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
		if you_are_white:
			your_king.piece.texture = load("res://sprites/chess_pieces/beli_piun.png")
			var sign = 1
		else:
			your_king.piece.texture = load("res://sprites/chess_pieces/crni_piun.png")
			var sign = -1
		var new_coords = []
		new_coords.append(coord + Vector2(0,your_king.your_current_piece))
		new_coords.append(coord + Vector2(1,your_king.your_current_piece))
		new_coords.append(coord + Vector2(-1,your_king.your_current_piece))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
		
	
	if your_piece == "bishop":
		if you_are_white:
			your_king.piece.texture = load("res://sprites/chess_pieces/beli_lovac.png")
		else:
			your_king.piece.texture = load("res://sprites/chess_pieces/crni_lovac.png")

		var new_coords = []
		for i in range(1,4):
			new_coords.append(coord + Vector2(i,i))
			new_coords.append(coord + Vector2(-i,i))
			new_coords.append(coord + Vector2(i,-i))
			new_coords.append(coord + Vector2(-i,-i))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
			
	if your_piece == "knight":
		if you_are_white:
			your_king.piece.texture = load("res://sprites/chess_pieces/beli_konj.png")
		else:
			your_king.piece.texture = load("res://sprites/chess_pieces/crni_konj.png")
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
		if you_are_white:
			your_king.piece.texture = load("res://sprites/chess_pieces/beli_top.png")
		else:
			your_king.piece.texture = load("res://sprites/chess_pieces/crni_top.png")
		var new_coords = []
		for i in range(1,4):
			new_coords.append(coord + Vector2(0,i))
			new_coords.append(coord + Vector2(0,-i))
			new_coords.append(coord + Vector2(i,0))
			new_coords.append(coord + Vector2(-i,0))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
	
	if your_piece == "queen":
		if you_are_white:
			your_king.piece.texture = load("res://sprites/chess_pieces/bela_kraljica.png")
		else:
			your_king.piece.texture = load("res://sprites/chess_pieces/crna_kraljica.png")
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
