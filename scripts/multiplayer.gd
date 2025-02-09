extends Node

var peer = ENetMultiplayerPeer.new()
var board = []
var current_turn = 1
var player1_pos = Vector2(0, 5)
var player2_pos = Vector2(7, 4)
var turn_count = 0
var player1_prev_pos = player1_pos
var player2_prev_pos = player2_pos
var player1_eaten_in_last = false
var player2_eaten_in_last = false
var player1_score = 0
var player2_score = 0
var player1_lied = false
var player2_lied = false
var treasure_pos = Vector2(randi() % 8, randi() % 8)
var pieces_availible = {}

signal game_ready()
signal refresh()

func _ready():
	_initialize_board()
	reload_pieces()

func reload_pieces():
	pieces_availible.clear()
	pieces_availible = {"q": 1, "k": 2, "r": 2, "b": 2, "p": 8}

func _initialize_board():
	board = []
	for i in range(8):
		board.append([])
		for j in range(8):
			board[i].append(0)
	board[player1_pos[0]][player1_pos[1]] = -1
	board[player2_pos[0]][player2_pos[1]] = 1

## ----------------SERVER HOSTING---------------- ##
func start_server(host_ip: String):
	var error = peer.create_server(8080, 2)
	if error != OK:
		print("Failed to start server: ", error)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_client_connected)
	print("Server started on: ", host_ip, ":8080")

func _on_client_connected(id):
	print("Player joined with ID: ", id)
	rpc_id(id, "sync_game_state", board, current_turn, player1_pos, player2_pos, player1_score, player2_score, treasure_pos, player1_lied, player2_lied, player1_prev_pos, player2_prev_pos, player1_eaten_in_last, player2_eaten_in_last)
	emit_signal("game_ready")	

##-----------------------------CLIENT-JOINING----------------------------------##
func join_server(server_ip: String, port: int):
	var error = peer.create_client(server_ip, port)
	if error != OK:
		print("Failed to connect to server", error)
		return
	multiplayer.multiplayer_peer = peer
	print("Connected to server at: ", server_ip, ":", port)

##---------------------------- GAME LOGIC ------------------------------##
@rpc("any_peer")
func sync_game_state(new_board, turn, player1_pos, player2_pos, player1_score, player2_score, treasure_pos, player1_lied, player2_lied, player1_prev_pos, player2_prev_pos, player1_eaten_in_last, player2_eaten_in_last):
	print("Sync game state entry")
	board = new_board
	board[treasure_pos.x][treasure_pos.y] = 7
	current_turn = turn
	self.player1_pos = player1_pos
	self.player2_pos = player2_pos
	self.player1_score = player1_score
	self.player2_score = player2_score
	self.treasure_pos = treasure_pos
	self.player1_lied = player1_lied
	self.player2_lied = player2_lied
	self.player1_prev_pos = player1_prev_pos
	self.player2_prev_pos = player2_prev_pos
	self.player1_eaten_in_last = player1_eaten_in_last
	self.player2_eaten_in_last = player2_eaten_in_last
	print(board)
	refresh.emit()

@rpc("any_peer")
func make_move(player_id, x : int, y : int, piece_data : String, lied):
	turn_count += 1
	var prev_pos = player1_pos if player_id != 0 else player2_pos
	var pos = Vector2(x, y)
	
	print(str(pos[0]) + " " + str(pos[1]))

	if player_id != 0:
		board[player1_pos[0]][player1_pos[1]] = 0
		player1_prev_pos = prev_pos
		player1_pos = pos
		player1_lied = lied
		player1_eaten_in_last = false
		player2_lied = false
	else:
		board[player2_pos[0]][player2_pos[1]] = 0
		player2_prev_pos = prev_pos
		player2_pos = pos
		player2_lied = lied
		player2_eaten_in_last = false
		player1_lied = false
	
	var multiplier = 1
	# Kin  pawn  Knight  Bishop  Rook Queen
	# 1     2      3       4       5      6
	if player_id != 0:
		multiplier *= -1
	if piece_data.begins_with("q"):
		board[x][y] = 6 * multiplier
	elif piece_data.begins_with("p"):
		board[x][y] = 2 * multiplier
	elif piece_data.begins_with("kn"):
		board[x][y] = 3 * multiplier
	elif piece_data.begins_with("b"):
		board[x][y] = 4 * multiplier
	elif piece_data.begins_with("r"):
		board[x][y] = 5 * multiplier
	else:
		board[x][y] = 1 * multiplier

	if pos == treasure_pos:
		if player_id != 0:
			player1_score += 1
		else:
			player2_score += 1
		treasure_pos = Vector2(randi() % 8, randi() % 8)

	if player1_pos == player2_pos:
		if player_id != 0:
			player1_score += 1
			player2_score -= 1
			player2_pos = Vector2(7, 4)
		else:
			player2_score += 1
			player1_score -= 1
			player1_pos = Vector2(0, 5)

	current_turn = 3 - current_turn
	rpc("sync_game_state", board, current_turn, player1_pos, player2_pos, player1_score, player2_score, treasure_pos, player1_lied, player2_lied, player1_prev_pos, player2_prev_pos, player1_eaten_in_last, player2_eaten_in_last)
	
	
@rpc("any_peer")
func challenge_move(player_id):
	if multiplayer.get_remote_sender_id() != player_id:
		return

	var opponent_id = 3 - player_id
	var opponent_lied = player1_lied if opponent_id != 1 else player2_lied

	if opponent_lied:
		if opponent_id != 1:
			if player2_eaten_in_last:
				player2_score += 1
				player2_eaten_in_last = false
				player2_pos = player2_prev_pos
			player1_pos = player1_prev_pos
			player1_score -= 1
			player1_lied = false
		else:
			if player1_eaten_in_last:
				player1_score += 1
				player1_eaten_in_last = false
				player1_pos = player1_prev_pos
			player2_pos = player2_prev_pos
			player2_score -= 1
			player2_lied = false
	else:
		if player_id != 0:
			player1_score -= 1
		else:
			player2_score -= 1

	rpc("sync_game_state", board, current_turn, player1_pos, player2_pos, player1_score, player2_score, treasure_pos, player1_lied, player2_lied, player1_prev_pos, player2_prev_pos, player1_eaten_in_last, player2_eaten_in_last)
