class_name Choose_a_piece_white extends Node2D

signal piece_chosen(piece_name: String)

@onready var underline_nodes = [
	$underline1, $underline2, $underline3, $underline4, $underline5
]

func _ready() -> void:
	remove_underline()

func start_roulette_animation() -> void:
	for i in range(5):
		underline_nodes[i].show()
		await get_tree().create_timer(0.1).timeout
		underline_nodes[i].hide()
	for i in range(5):
		underline_nodes[i].show()
		await get_tree().create_timer(0.2).timeout
		underline_nodes[i].hide()

func underline_this_piece_animation(piece_name: String):
	await start_roulette_animation()
	var index = ["pawn", "bishop", "knight", "rook", "queen"].find(piece_name)
	if index != -1:
		for i in range(index + 1):
			underline_nodes[i].show()
			await get_tree().create_timer(0.25 + (i * 0.05)).timeout
			underline_nodes[i].hide()
		underline_nodes[index].show()

func underline_this_piece(piece_name: String):
	await underline_this_piece_animation(piece_name)
	var index = ["pawn", "bishop", "knight", "rook", "queen"].find(piece_name)
	if index != -1:
		underline_nodes[index].show()

func remove_underline() -> void:
	for node in underline_nodes:
		node.hide()

func _on_pawn_pressed() -> void:
	emit_signal("piece_chosen", "pawn")

func _on_bishop_pressed() -> void:
	emit_signal("piece_chosen", "bishop")

func _on_knight_pressed() -> void:
	emit_signal("piece_chosen", "knight")

func _on_rook_pressed() -> void:
	emit_signal("piece_chosen", "rook")

func _on_queen_pressed() -> void:
	emit_signal("piece_chosen", "queen")
