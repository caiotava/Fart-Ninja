extends Control

var sounds = []

# Called when the node enters the scene tree for the first time.
func _ready():
	sounds.append(preload("res://audio/game_over/crowdpanic_hazmat.wav"))
	sounds.append(preload("res://audio/game_over/emission_impossible.wav"))
	sounds.append(preload("res://audio/game_over/fartepiano.wav"))
	sounds.append(preload("res://audio/game_over/fart_ninja_fail.wav"))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_visibility_changed():
	if visible:
		var i = randi_range(0, sounds.size()-1)
		var sound = sounds[i]
		$Sound.stream = sound
		$Sound.play()
