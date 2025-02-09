class_name Main_scene extends Node2D

@onready var choose_a_piece_node = $ChooseAPiece
@onready var white_pieces = $ChooseAPiece/ChooseAPieceWhite
@onready var black_pieces = $ChooseAPiece/ChooseAPieceBlack
var your_pieces = null

@onready var white_king = $White
@onready var black_king = $Black

@onready var call_out_opponent_node = $CallOutOpponent
@onready var Board = $Board

@onready var main_menu: Main_menu = $"../MainMenu"

var underlined_piece_that_was_pulled_out_of_the_box: String = "king"

var your_king = null
var enemy_king = null
@onready var diamond = $Diamond
@onready var puff = $Puff

var you_are_white: bool = false

var your_piece: String = "king"

var enemy_current_tile: String = "e_8"
var diamond_tile: String = "b_5"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_out_opponent_node.hide()
	main_menu.connect("set_your_pieces_to_white", Callable(self, "_on_started_white"))
	MultiplayerManager.connect("refresh", Callable(self, "_on_refresh"))
	MultiplayerManager.connect("opponent_made_a_move", Callable(self, "_on_opponent_made_a_move"))
	diamond.position = Board.get_node(diamond_tile).global_position
	diamond.animation.play("diamond_animation")
	
	for tile in Board.get_children():
		if tile is Tile:
			tile.connect("piece_moved", Callable(self, "_on_piece_moved"))

func _on_refresh() -> void:
	remove_all_objects_from_the_board()
	position_all_objects_on_the_board()
	$whiteScore.set_score(MultiplayerManager.player2_score)
	$BlackScore.set_score(MultiplayerManager.player1_score)

func _on_started_white()-> void:
	you_are_white = true;
		


func assign_white_pieces() -> void:
	choose_a_piece_node.remove_child(black_pieces)
	your_pieces = white_pieces
	your_king = white_king
	enemy_king = black_king
	your_king.your_tile_name = "d_1" 
	enemy_current_tile = "e_8"
	show_pieces_choice()
	enemy_king.position = Board.get_node(enemy_current_tile).global_position
	your_king.position = Board.get_node(your_king.your_tile_name).global_position
	your_pieces.show()
	var piece : String = MultiplayerManager.piece_roulette();
	your_pieces.underline_this_piece(piece)
	underlined_piece_that_was_pulled_out_of_the_box = piece

	
func assign_black_pieces() -> void:
	choose_a_piece_node.remove_child(white_pieces)
	your_pieces = black_pieces
	your_king = black_king
	enemy_king = white_king
	your_king.your_tile_name = "e_8" 
	enemy_current_tile = "d_1"
	show_pieces_choice()
	enemy_king.position = Board.get_node(enemy_current_tile).global_position
	your_king.position = Board.get_node(your_king.your_tile_name).global_position
	your_pieces.show()


func remove_all_objects_from_the_board() -> void:
	$White.position = Vector2(-100,-100)
	$Black.position = Vector2(-100,-100)
	$Diamond.position = Vector2(-100,-100)
	puff.position = Vector2(-100,-100)
		
func _on_piece_moved(new_tile_name: String) -> void:
	puff.position = Board.get_node(your_king.your_tile_name).global_position		
	puff.animation.play("puff_animation")

	your_king.your_tile_name = new_tile_name
	var new_tile = Board.get_node(new_tile_name)
	
	await get_tree().create_timer(0.6).timeout
	
	if you_are_white:
		your_king.update_piece("white")
	else:
		your_king.update_piece("black")
	await get_tree().create_timer(0.15).timeout
	
	your_king.position = new_tile.global_position
	
	if underlined_piece_that_was_pulled_out_of_the_box == your_king.this_piece:
		MultiplayerManager.make_move(multiplayer.get_unique_id(), your_king.your_tile_name, your_king.this_piece, false)
	else:
		MultiplayerManager.make_move(multiplayer.get_unique_id(), your_king.your_tile_name, your_king.this_piece, true)

	unhighlight_all_squares()
	your_pieces.remove_underline()

func position_all_objects_on_the_board() -> void:
	
	white_king.position = Board.get_node(MultiplayerManager.player1_pos).global_position
	black_king.position = Board.get_node(MultiplayerManager.player2_pos).global_position
	diamond.position = Board.get_node(MultiplayerManager.treasure_pos).global_position
	if you_are_white:
		your_king.your_tile_name = MultiplayerManager.player1_pos
		enemy_king.your_tile_name = MultiplayerManager.player2_pos

		your_king.this_piece = MultiplayerManager.player1_piece
		enemy_king.this_piece = MultiplayerManager.player2_piece
		
		your_king.update_piece("white")
		enemy_king.update_piece("black")
	else:
		your_king.your_tile_name = MultiplayerManager.player2_pos
		enemy_king.your_tile_name = MultiplayerManager.player1_pos

		your_king.this_piece = MultiplayerManager.player2_piece
		enemy_king.this_piece = MultiplayerManager.player1_piece
				
		your_king.update_piece("black")
		enemy_king.update_piece("white")
	
	print(your_king.this_piece + " ovo je beli, a crni je: " + enemy_king.this_piece)


func unhighlight_all_squares() -> void:
	for tile in Board.get_children():
		if tile is Tile:
			tile.unhighlight_this_square()
			tile.tile_is_available_for_movement = false

	
func show_pieces_choice() -> void:
	your_pieces.hide()
	your_pieces.connect("piece_chosen", Callable(self, "_on_piece_chosen"))
	call_out_opponent_node.connect("ok_button_pressed", Callable(self, "_on_ok_button_pressed"))
	call_out_opponent_node.connect("scam_button_pressed", Callable(self, "_on_scam_button_pressed"))

func _on_opponent_made_a_move() -> void:
	#animiraj protivnicku figuru -> puf, nova figura, pomeraj, jedenje(mozda) i adjust score
	puff.position = Board.get_node(enemy_king.your_tile_name).global_position
	puff.animation.play("puff_animation")
	await get_tree().create_timer(0.6).timeout
	
	if you_are_white:
		print("beo sam")
		call_out_opponent_node.show()
		enemy_king.update_piece("black")
	else:
		print("crrrrrrrrrsrrrn sam")
		call_out_opponent_node.show()
		enemy_king.update_piece("white")
		
	#await get_tree().create_timer(0.15).timeout
	_on_refresh()
	
	your_pieces.hide()
	for child in choose_a_piece_node.get_children():
		child.hide()
	call_out_opponent_node.show()
	
	
	
func _on_ok_button_pressed() -> void:
	var piece : String = MultiplayerManager.piece_roulette();
	your_pieces.underline_this_piece(piece)
	underlined_piece_that_was_pulled_out_of_the_box = piece

	call_out_opponent_node.hide()
	your_pieces.show()


func _on_scam_button_pressed() -> void:
	var piece : String = MultiplayerManager.piece_roulette();
	your_pieces.underline_this_piece(piece)
	underlined_piece_that_was_pulled_out_of_the_box = piece

	MultiplayerManager.challenge_move(multiplayer.get_unique_id())
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
		return false	#signal da se potvrdi trenutna pozicija

	return true

func highlight_available_tiles() -> void:
	var available_tiles_array: Array = []
	var coord: Vector2 = tile_name_to_matrix_representation(your_king.your_tile_name)
	if your_piece == "pawn":
		your_king.this_piece = "pawn"
		if you_are_white:
			var sign = 1
		else:
			var sign = -1
		var new_coords = []
		new_coords.append(coord + Vector2(your_king.your_color, 0))
		new_coords.append(coord + Vector2(your_king.your_color, 1))
		new_coords.append(coord + Vector2(your_king.your_color, -1))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
		
	
	if your_piece == "bishop":
		your_king.this_piece = "bishop"

		var new_coords = []
		for i in range(1,4):
			new_coords.append(coord + Vector2(i,i))
			new_coords.append(coord + Vector2(-i,i))
			new_coords.append(coord + Vector2(i,-i))
			new_coords.append(coord + Vector2(-i,-i))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
			
	if your_piece == "knight":
		your_king.this_piece = "knight"
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
		your_king.this_piece = "rook"
		var new_coords = []
		for i in range(1,4):
			new_coords.append(coord + Vector2(0,i))
			new_coords.append(coord + Vector2(0,-i))
			new_coords.append(coord + Vector2(i,0))
			new_coords.append(coord + Vector2(-i,0))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
	
	if your_piece == "queen":
		your_king.this_piece = "queen"
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
	
	return Vector2(row_number, column_index)

func matrix_representation_to_tile_name(matrix_representation: Vector2) -> String:
	var column_letter = char('a'.unicode_at(0) + int(matrix_representation.y))
	
	var row_number = matrix_representation.x + 1
	
	return column_letter + "_" + str(row_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
