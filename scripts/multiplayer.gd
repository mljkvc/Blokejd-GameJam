extends Node

var peer = ENetMultiplayerPeer.new()
var board = []
var current_turn = 1 # 1 is for player 1 and 2 is for player 2

var player1_pos = Vector2(0, 5)
var player2_pos = Vector2(7, 4)

var player1_prev_pos = player1_pos
var player2_prev_pos = player2_pos

var player1_eaten_in_last = false
var player2_eaten_in_last = false

var player1_score = 0
var player2_score = 0

var player1_lied = false
var player2_lied = false

var treasure_pos = Vector2(randi() % 8, randi() % 8)

func _ready():
	_initialize_board()

func _initialize_board():
	board = []
	for i in range(8):
		board.append([])
		for j in range(8):
			board[i].append(0)


func start_server():
	peer.create_server(8080, 2)
	multiplayer.peer = peer
	multiplayer.peer_connected.connect(_on_client_connected)
	print("server started")
	
func _on_client_connected(id):
	print("player joined with id: ", id)
	rpc_id(id, "sync_game_state",board ,current_turn)
	
func join_server(ip_address):
	peer.create_client(ip_address, 8080)
	multiplayer.multiplayer_peer = peer
	print("connected to the server ip: ", ip_address)
		
@rpc("authority")
func sync_game_state(new_board, turn):
	board = new_board
	current_turn = turn

@rpc("any_peer")
func make_move(player_id, x, y, piece_data, lied):
	if multiplayer.get_remote_sender_id() != player_id:
		return
		
	var prev_pos = player1_pos if player_id == 1 else player2_pos
	var pos = Vector2(x, y)
	
	if player_id == 1:
		board[player1_pos[0]][player1_pos[1]] = 0
		player1_prev_pos = prev_pos
		player1_pos = pos
		player1_lied = lied
		if player1_eaten_in_last:
			player1_eaten_in_last = false
	else:
		board[player2_pos[0]][player2_pos[1]] = 0
		player2_prev_pos = prev_pos
		player2_pos = pos
		player2_lied = lied
		if player2_eaten_in_last:
			player2_eaten_in_last = false
	
	board[x][y] = piece_data
	# checking for the treasure conquest
	
	if pos == treasure_pos:
		if player_id == 1:
			player1_score += 1
		else:
			player2_score += 1
				
		treasure_pos = Vector2(randi() % 8, randi() % 8)
	
	# checking for capturing of the enemy
	
	if player1_pos == player2_pos:
		if player_id == 1:
			player1_score += 1
			player2_score -+ 1
			player2_pos = Vector2(7, 4)
		else:
			player2_score += 1
			player1_score -= 1
			player1_pos = Vector2(0, 5)
	
	current_turn = 3 - current_turn
	rpc("sync_game_state", board, player1_pos, player2_pos, current_turn, player1_score, player2_score, treasure_pos)
		
		
@rpc("any_peer")
func challenge_move(player_id):
	if multiplayer.get_remote_sender_id() != player_id:
		return

	var opponent_id = 3 - player_id
	var opponent_lied = player1_lied if opponent_id == 1 else player2_lied

	if opponent_lied:
		if opponent_id == 1:
			if player2_eaten_in_last:
				player2_score += 1
				player2_eaten_in_last = false
				player2_pos = player2_prev_pos
			player1_pos = player1_prev_pos
			player1_score -= 1
		else:
			if player1_eaten_in_last:
				player1_score += 1
				player1_eaten_in_last = false
				player1_pos = player1_prev_pos
			player2_pos = player2_prev_pos
			player2_score -= 1
	else:
		if player_id == 1:
			player1_score -= 1
		else:
			player2_score -= 1
	
	rpc("sync_game_state", board, player1_pos, player2_pos, current_turn, player1_score, player2_score, treasure_pos)
