extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_passenger_game_over():
	$GameOver.visible = true
	$Carriage.visible = false


func _on_retry_pressed():
	$GameOver.visible = false
	get_tree().reload_current_scene()
