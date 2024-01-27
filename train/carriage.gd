extends Node2D

@onready var navigation_region : NavigationRegion2D = $NavigationRegion2D
@onready var passengers : Node = $Passengers

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_fart_body_entered(body : Node2D):
	if !body.is_in_group("passengers"):
		return

	body.enter_alert_mode()
	pass # Replace with function body.
