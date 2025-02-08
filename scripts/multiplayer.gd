extends Node

var peer = ENetMultiplayerPeer.new()
var board = []
var current_turn = 1 # 1 is for player 1 and 2 is for player 2

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
