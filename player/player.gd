extends CharacterBody2D
class_name Player

@export_group("Movement")
@export var move_speed : float = 220
@export var move_friction : float = 20
@export var move_acceleration : float = 60

@onready var animatedSprite = $AnimatedSprite2D

var animation_name = "walking"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity != Vector2.ZERO:
		animatedSprite.play(animation_name)
	else:
		animatedSprite.pause()

func _physics_process(delta):
	var input := Vector2.ZERO
	input.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	input.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	input = input.normalized()

	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * move_speed, move_acceleration * delta)
		animatedSprite.flip_h = input.x < 0
	else:
		velocity = velocity.move_toward(Vector2.ZERO, move_friction * delta)

	move_and_slide()
