extends Control

var sounds = [
	preload("res://audio/game_over/crowdpanic_hazmat.ogg"),
	preload("res://audio/game_over/emission_impossible.ogg"),
	preload("res://audio/game_over/fartepiano.ogg"),
	preload("res://audio/game_over/fart_ninja_fail.ogg")
]

var subtitles = [
	"Someone call the hazmat team, \n we've got a situation here!",
	"Emission Impossible: Mission Failed!",
	"Wow! That was a full-scale fartepiano concert!",
	"The Stealth Fart Ninja has Failed the Mission!"
]

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
		var subtitle = subtitles[i]
		$Sound.stream = sound
		$Subtitle.text = "[center]%s[/center]" % subtitle
		$Sound.play()
