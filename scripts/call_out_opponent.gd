extends Node2D

@onready var ok_button = $ok
@onready var not_ok_button = $scam

signal ok_button_pressed()
signal scam_button_pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ok_pressed() -> void:
	emit_signal("ok_button_pressed")

func _on_scam_pressed() -> void:
	emit_signal("scam_button_pressed")


func _on_ok_mouse_entered() -> void:
	ok_button.scale.x += 0.06
	ok_button.scale.y += 0.06
	ok_button.position.x -= 30

func _on_ok_mouse_exited() -> void:
	ok_button.scale.x -= 0.06
	ok_button.scale.y -= 0.06
	ok_button.position.x += 30

func _on_scam_mouse_entered() -> void:
	not_ok_button.scale.x += 0.06
	not_ok_button.scale.y += 0.06
	not_ok_button.position.x -= 30

func _on_scam_mouse_exited() -> void:
	not_ok_button.scale.x -= 0.06
	not_ok_button.scale.y -= 0.06
	not_ok_button.position.x += 30
