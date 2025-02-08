extends Node2D

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
