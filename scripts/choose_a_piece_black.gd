class_name Choose_a_piece_black extends Node2D

signal piece_chosen(piece_name: String)

@onready var underline_1 = $underline1
@onready var underline_2 = $underline2
@onready var underline_3 = $underline3
@onready var underline_4 = $underline4
@onready var underline_5 = $underline5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#remove_underline()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_roulette_animation() -> void:
	underline_1.show()
	await get_tree().create_timer(0.1).timeout
	underline_1.hide()
	underline_2.show()
	await get_tree().create_timer(0.1).timeout
	underline_2.hide()
	underline_3.show()
	await get_tree().create_timer(0.1).timeout
	underline_3.hide()
	underline_4.show()
	await get_tree().create_timer(0.1).timeout
	underline_4.hide()
	underline_5.show()
	await get_tree().create_timer(0.1).timeout
	underline_5.hide()
	underline_1.show()
	await get_tree().create_timer(0.2).timeout
	underline_1.hide()
	underline_2.show()
	await get_tree().create_timer(0.2).timeout
	underline_2.hide()
	underline_3.show()
	await get_tree().create_timer(0.2).timeout
	underline_3.hide()
	underline_4.show()
	await get_tree().create_timer(0.2).timeout
	underline_4.hide()
	underline_5.show()
	await get_tree().create_timer(0.2).timeout
	underline_5.hide()
	
func underline_this_piece_animation(piece_name: String):
	start_roulette_animation()
	if piece_name == "pawn":
		underline_1.show()
	if piece_name == "bishop":
		underline_1.show()
		await get_tree().create_timer(0.25).timeout
		underline_1.hide()
		underline_2.show()
	if piece_name == "knight":
		underline_1.show()
		await get_tree().create_timer(0.25).timeout
		underline_1.hide()
		underline_2.show()
		await get_tree().create_timer(0.3).timeout
		underline_2.hide()
		underline_3.show()
	if piece_name == "rook":
		underline_1.show()
		await get_tree().create_timer(0.25).timeout
		underline_1.hide()
		underline_2.show()
		await get_tree().create_timer(0.3).timeout
		underline_2.hide()
		underline_3.show()
		await get_tree().create_timer(0.35).timeout
		underline_3.hide()
		underline_4.show()
	if piece_name == "queen":
		underline_1.show()
		await get_tree().create_timer(0.25).timeout
		underline_1.hide()
		underline_2.show()
		await get_tree().create_timer(0.3).timeout
		underline_2.hide()
		underline_3.show()
		await get_tree().create_timer(0.35).timeout
		underline_3.hide()
		underline_4.show()
		await get_tree().create_timer(0.4).timeout
		underline_4.hide()
		underline_5.show()
		
func underline_this_piece(piece_name: String):
	underline_this_piece_animation(piece_name)
	if piece_name == "pawn":
		underline_1.show()
	if piece_name == "bishop":
		underline_2.show()
	if piece_name == "knight":
		underline_3.show()
	if piece_name == "rook":
		underline_4.show()
	if piece_name == "queen":
		underline_5.show()

func remove_underline() -> void:
	underline_1.hide()
	underline_2.hide()
	underline_3.hide()
	underline_4.hide()
	underline_5.hide()
		
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
