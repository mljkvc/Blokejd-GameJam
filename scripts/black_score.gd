class_name Black_score extends Node2D

@onready var score_sprite = $score_sprite

func set_score(score: int) -> void:
	if score <= 0:
		var score_path = "res://sprites/score/white_score_0.png"
		var score_texture = load(score_path)  # Učitaj teksturu iz fajla
		score_sprite.set_texture(score_texture)  # Postavi učitanu teksturu
	elif score < 15:
		var score_path = "res://sprites/score/score_" + str(score) + ".png"
		var score_texture = load(score_path)  # Učitaj teksturu iz fajla
		score_sprite.set_texture(score_texture)  # Postavi učitanu teksturu
	else:
		go_to_victory_screen()

func go_to_victory_screen():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
