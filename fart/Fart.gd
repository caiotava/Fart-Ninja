extends Node2D

@export var total_radius = 30
@export var circle_color = Color(1, 0, 0)
@export var circle_width = 1.0
var radius: float
var collider: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is CollisionShape2D:
			collider = child

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var offset = get_parent().color_ramp.get_offset(1)
	radius = total_radius * offset
	collider.shape.radius = radius
	queue_redraw()

func _draw():
	draw_arc(Vector2(), radius, 0, 360, 100, circle_color, circle_width)
