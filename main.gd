extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var passengers = get_tree().get_nodes_in_group("passengers")
	for passenger in passengers:
		passenger.connect("game_over", _on_passenger_game_over)
	var bathrooms = get_tree().get_nodes_in_group("bathrooms")
	for bathroom in bathrooms:
		bathroom.connect("victory", _on_victory)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_passenger_game_over():
	$GameOver.visible = true
	#$Victory.visible = true
	#$Carriage.visible = false
	#$Carriage/Soundtrack.playing = false
	$Carriage.queue_free()

func _on_victory():
	$Victory.visible = true
	$Carriage.queue_free()


func _on_retry_pressed():
	$GameOver.visible = false
	get_tree().reload_current_scene()
