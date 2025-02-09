extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	self.hide()
	get_parent().main_menu.show()

func _on_button_2_pressed() -> void:
	get_tree().quit()

func _on_button_mouse_entered() -> void:
	$Button.scale.x += 0.1
	$Button.scale.y += 0.1
	$Button.position.x -= 40

func _on_button_mouse_exited() -> void:
	$Button.scale.x -= 0.1
	$Button.scale.y -= 0.1
	$Button.position.x += 40

func _on_button_2_mouse_entered() -> void:
	$Button2.scale.x += 0.1
	$Button2.scale.y += 0.1
	$Button2.position.x -= 40

func _on_button_2_mouse_exited() -> void:
	$Button2.scale.x -= 0.1
	$Button2.scale.y -= 0.1
	$Button2.position.x += 40
