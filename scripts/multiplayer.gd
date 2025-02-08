extends Node

var peer = ENetMultiplayerPeer.new()
var board = []
var current_turn = 1 # 1 is for player 1 and 2 is for player 2

var player1_pos = Vector2(0, 5)
var player2_pos = Vector2(7, 4)

var player1_prev_pos = player1_pos
var player2_prev_pos = player2_pos

var player1_score = 0
var player2_score = 0

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
	
@rpc("any_peer")
func make_move(player_id, x, y, piece_data):
	if multiplayer.get_remote_sender_id() != player_id:
		return
	board[x][y] = piece_data
	current_turn = 3 - current_turn
	
	rpc("sync_game_state", board, current_turn)
		
@rpc("authority")
func sync_game_state(new_board, turn):
	board = new_board
	current_turn = turn

@rpc("any_peer")
func make_move(player_id, x, y, piece_data, is_honest):
	if multiplayer.get_remote_sender_id() != player_id:
		return
		
	var prev_pos = player1_pos if player_id == 1 else player2_pos
	var pos = Vector2(x, y)
	
	if player_id == 1:
		player1_prev_pos = prev_pos
		player1_pos = pos
	else:
		player2_prev_pos = prev_pos
		player2_pos = pos
	
	# checking for the treasure conquest
	
	if pos == treasure_pos:
		if is_honest:
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
		
