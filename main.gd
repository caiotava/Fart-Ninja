extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var passengers = get_tree().get_nodes_in_group("passengers")
	for passenger in passengers:
		passenger.connect("game_over", _on_passenger_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_passenger_game_over():
	$GameOver.visible = true
	$Carriage.visible = false
	$Carriage/Soundtrack.playing = false


func _on_retry_pressed():
	$GameOver.visible = false
	get_tree().reload_current_scene()
