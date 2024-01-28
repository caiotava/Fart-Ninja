extends Control

var sounds = [preload("res://audio/victory/train_cheering.wav")]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_visibility_changed():
	if visible:
		var i = randi_range(0, sounds.size()-1)
		var sound = sounds[i]
		$Sound.stream = sound
		$Sound.play()
