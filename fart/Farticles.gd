extends CPUParticles2D

@export var min_offset = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var offset = color_ramp.get_offset(1)
	color_ramp.set_offset(1, max(offset - 0.005, min_offset))

func _on_do_fart():
	var offset = color_ramp.get_offset(1)
	color_ramp.set_offset(1, min(offset + 0.01, 1))
