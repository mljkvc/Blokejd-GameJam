class_name Black extends Node2D
#crni kralj = +1 beli krelj = -1
var your_tile_name = "d_1"
var your_position: Vector2 = Vector2(7,4)
var your_color: int = -1 #-1 za crne 1 za bele (crnci < belci jer rasizam)[SALA MALA]
var this_piece = "king"

@onready var piece: Sprite2D = $piece

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_piece(color: String) -> void:
	if color == "white":
		if this_piece == "king":
			self.piece.texture = load("res://sprites/chess_pieces/beli_kralj.png")
		if this_piece == "pawn":
			self.piece.texture = load("res://sprites/chess_pieces/beli_piun.png")
		if this_piece == "bishop":
			self.piece.texture = load("res://sprites/chess_pieces/beli_lovac.png")
		if this_piece == "knight":
			self.piece.texture = load("res://sprites/chess_pieces/beli_konj.png")
		if this_piece == "rook":
			self.piece.texture = load("res://sprites/chess_pieces/beli_top.png")
		if this_piece == "queen":
			self.piece.texture = load("res://sprites/chess_pieces/bela_kraljica.png")
	else:
		if this_piece == "king":
			self.piece.texture = load("res://sprites/chess_pieces/crni_kralj.png")
		if this_piece == "pawn":
			self.piece.texture = load("res://sprites/chess_pieces/crni_piun.png")
		if this_piece == "bishop":
			self.piece.texture = load("res://sprites/chess_pieces/crni_lovac.png")
		if this_piece == "knight":
			self.piece.texture = load("res://sprites/chess_pieces/crni_konj.png")
		if this_piece == "rook":
			self.piece.texture = load("res://sprites/chess_pieces/crni_top.png")
		if this_piece == "queen":
			self.piece.texture = load("res://sprites/chess_pieces/crna_kraljica.png")
