extends Node2D  # Change from CharacterBody2D to Node2D

const SPEED = 200.0  
var velocity = Vector2.ZERO  

func _process(delta):
	velocity = Vector2.ZERO  

	if Input.is_action_pressed("move_left"):
		velocity.x = -SPEED
	if Input.is_action_pressed("move_right"):
		velocity.x = SPEED
	if Input.is_action_pressed("move_up"):
		velocity.y = -SPEED
	if Input.is_action_pressed("move_down"):
		velocity.y = SPEED

	position += velocity * delta  # Move manually instead of move_and_slide()
