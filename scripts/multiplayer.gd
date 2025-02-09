extends Node

var peer = ENetMultiplayerPeer.new()
var current_turn = 1

var player1_eaten_in_last = false
var player2_eaten_in_last = false
var player1_score = 0
var player2_score = 0
var player1_lied = false
var player2_lied = false
var pieces_availible = {}

var chess_positions = [
	"a_1", "a_2", "a_3", "a_4", "a_5", "a_6", "a_7", "a_8",
	"b_1", "b_2", "b_3", "b_4", "b_5", "b_6", "b_7", "b_8",
	"c_1", "c_2", "c_3", "c_4", "c_5", "c_6", "c_7", "c_8",
	"d_1", "d_2", "d_3", "d_4", "d_5", "d_6", "d_7", "d_8",
	"e_1", "e_2", "e_3", "e_4", "e_5", "e_6", "e_7", "e_8",
	"f_1", "f_2", "f_3", "f_4", "f_5", "f_6", "f_7", "f_8",
	"g_1", "g_2", "g_3", "g_4", "g_5", "g_6", "g_7", "g_8",
	"h_1", "h_2", "h_3", "h_4", "h_5", "h_6", "h_7", "h_8"
]

var white_pos = "d_1"
var black_pos = "e_8"

var player1_pos = "d_1"
var player2_pos = "e_8"
var treasure_pos = "b_5"

var turn_count = 0
var player1_prev_pos = player1_pos
var player2_prev_pos = player2_pos

signal game_ready()
signal refresh()

func _ready():
	reload_pieces()

func reload_pieces():
	pieces_availible.clear()
	pieces_availible = {"q": 1, "k": 2, "r": 2, "b": 2, "p": 8}


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
	rpc_id(0, "sync_game_state", current_turn, player1_pos, player2_pos, player1_score, player2_score, treasure_pos, player1_lied, player2_lied, player1_prev_pos, player2_prev_pos, player1_eaten_in_last, player2_eaten_in_last)
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
func sync_game_state(turn, player1_pos, player2_pos, player1_score, player2_score, treasure_pos, player1_lied, player2_lied, player1_prev_pos, player2_prev_pos, player1_eaten_in_last, player2_eaten_in_last):
	print("Sync game state entry")
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
	refresh.emit()

@rpc("any_peer")
func make_move(player_id, pos, piece_data : String, lied):
	turn_count += 1
	var prev_pos = player1_pos if player_id != 1 else player2_pos
	
	print(str(pos[0]) + " " + str(pos[1]))

	if player_id != 1:
		player1_prev_pos = prev_pos
		player1_pos = pos
		player1_lied = lied
		player1_eaten_in_last = false
		player2_lied = false
	else:
		player2_prev_pos = prev_pos
		player2_pos = pos
		player2_lied = lied
		player2_eaten_in_last = false
		player1_lied = false
	
	var multiplier = 1
	# Kin  pawn  Knight  Bishop  Rook Queen
	# 1     2      3       4       5      6

	if pos == treasure_pos:
		if player_id != 1:
			player1_score += 1
		else:
			player2_score += 1
		treasure_pos = chess_positions[randi() % 64]

	if player1_pos == player2_pos:
		if player_id != 1:
			player1_score += 1
			player2_score -= 1
			player2_pos = "e_8"
		else:
			player2_score += 1
			player1_score -= 1
			player1_pos = "d_1"

	current_turn = 3 - current_turn
	rpc("sync_game_state", current_turn, player1_pos, player2_pos, player1_score, player2_score, treasure_pos, player1_lied, player2_lied, player1_prev_pos, player2_prev_pos, player1_eaten_in_last, player2_eaten_in_last)
	
	
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
		if player_id != 1:
			player1_score -= 1
		else:
			player2_score -= 1

	rpc("sync_game_state", current_turn, player1_pos, player2_pos, player1_score, player2_score, treasure_pos, player1_lied, player2_lied, player1_prev_pos, player2_prev_pos, player1_eaten_in_last, player2_eaten_in_last)
