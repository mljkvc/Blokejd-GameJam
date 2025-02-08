extends Node

var peer = ENetMultiplayerPeer.new()

var board = []
var current_turn = 1 # 1 is for player 1 and 2 is for player 2

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

var discovery_socket = PacketPeerUDP.new()
var discovery_port = 9999

var pieces_availible = {}

func _ready():
	_initialize_board()
	reload_pieces()
	

func reload_pieces():
	pieces_availible.clear()
	# q - queen, k - knight, r - rook, b - bishop, p - pawn
	pieces_availible = {"q" : 1, "k" : 2, "r" : 2, "b" : 2, "p": 8}

func _initialize_board():
	board = []
	for i in range(8):
		board.append([])
		for j in range(8):
			board[i].append(0)
	board[player1_pos[0]][player1_pos[1]] = -1
	board[player2_pos[0]][player2_pos[1]] = 1

## ----------------SERVER HOSTING---------------- ##
func start_server():
	var error = peer.create_server(8080, 2)
	if error != OK:
		print("Failed to start server: ", error)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_client_connected)
	print("server started on port 8080")
	
	#broadcasting :3
	discovery_socket = PacketPeerUDP.new()
	discovery_socket.set_dest_address("255.255.255.255", discovery_port)
		
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.autostart = true
	timer.timeout.connect(_broadcast_server_info)
	
func _broadcast_server_info():
	var local_ips = []
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168."):
			local_ips.append(ip)
			
	if local_ips.size() > 0:
		var server_ip = local_ips[0] 
		var message = str(server_ip) + ":8080"
		discovery_socket.set_dest_address("255.255.255.255", discovery_port)
		discovery_socket.put_packet(message.to_utf8_buffer())
		print("Broadcasting server: ", message)
	
func _on_client_connected(id):
	print("player joined with id: ", id)
	rpc_id(id, "sync_game_state", board, current_turn, player1_pos, player2_pos, player1_score, player2_score, treasure_pos, player1_lied, player2_lied, player1_prev_pos, player2_prev_pos, player1_eaten_in_last, player2_eaten_in_last)
	
##-----------------------------CLIENT-JOINING----------------------------------##
	
func start_discovery():
	var error = discovery_socket.bind(discovery_port)
	if error != OK:
		print("Failed to listen on discovery port: ", error)
		return
		
	print("Client listening for servers broadcasts on port: ", discovery_port) 
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.autostart = true
	timer.timeout.connect(_check_for_server)
	
func _check_for_server():
	if discovery_socket.get_available_packet_count() > 0:
		var packet = discovery_socket.get_packet()
		var message = packet.get_string_from_utf8()
		var ip = message.split(":")[0]
		var port = message.split(":")[1].to_int()
		
		print("Discovered server at: ", ip, ":", port)
		join_server(ip, port)

func join_server(ip_address, port):
	var error = peer.create_client(ip_address, port)
	if error != OK:
		print("Failed to connect to server", error)
		return
	multiplayer.multiplayer_peer = peer
	print("connected to the server ip: ", ip_address)
		
##---------------------------- GAME LOGIC ------------------------------##		

@rpc("authority")
func sync_game_state(new_board, turn, player1_pos, player2_pos, player1_score, player2_score, treasure_pos, player1_lied, player2_lied, player1_prev_pos, player2_prev_pos, player1_eaten_in_last, player2_eaten_in_last):
	board = new_board
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

@rpc("any_peer")
func make_move(player_id, x, y, piece_data, lied):
	if multiplayer.get_remote_sender_id() != player_id:
		return
		
	turn_count += 1
	
	var prev_pos = player1_pos if player_id == 1 else player2_pos
	var pos = Vector2(x, y)
	
	if player_id == 1:
		board[player1_pos[0]][player1_pos[1]] = 0
		player1_prev_pos = prev_pos
		player1_pos = pos
		player1_lied = lied
		# resetting flags
		player1_eaten_in_last = false
		player2_lied = false
	else:
		board[player2_pos[0]][player2_pos[1]] = 0
		player2_prev_pos = prev_pos
		player2_pos = pos
		player2_lied = lied
		# resetting flags
		player2_eaten_in_last = false
		player1_lied = false
	
	board[x][y] = piece_data
	# checking for the treasure conquest
	
	if pos == treasure_pos:
		if player_id == 1:
			player1_score += 1
		else:
			player2_score += 1
				
		treasure_pos = Vector2(randi() % 8, randi() % 8)
	
	# checking for capturing of the enemy
	
	# TODO eating on starter position 
	
	if player1_pos == player2_pos:
		if player_id == 1:
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
	var opponent_lied = player1_lied if opponent_id == 1 else player2_lied

	if opponent_lied:
		if opponent_id == 1:
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
		if player_id == 1:
			player1_score -= 1
		else:
			player2_score -= 1
	
	rpc("sync_game_state", board, current_turn, player1_pos, player2_pos, player1_score, player2_score, treasure_pos, player1_lied, player2_lied, player1_prev_pos, player2_prev_pos, player1_eaten_in_last, player2_eaten_in_last)
