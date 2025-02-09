class_name White_score extends Node2D

@onready var score_sprite = $score_sprite

func set_score(score: int) -> void:
	if score < 15:
		var score_path = "res://sprites/score/white_score_" + str(score) + ".png"
		score_sprite.set_texture(score_path)
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
