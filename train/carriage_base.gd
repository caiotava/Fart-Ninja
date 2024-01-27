extends Node2D

@export var paralax_speed : float = -100

@onready var passengers : Node = $Passengers
@onready var paralax_layer : Sprite2D = $CarriageBackground/BackgroundParalax

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	paralax_layer.region_rect.position.x += paralax_speed * delta
	pass

func _on_fart_body_entered(body : Node2D):
	if body.is_in_group("passengers"):
		body.enter_alert_mode()


func _on_fart_body_exited(body):
	if body.is_in_group("passengers"):
		body.exit_alert_mode()
