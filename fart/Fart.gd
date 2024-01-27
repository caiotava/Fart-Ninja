extends Area2D

@export var total_radius = 30
@export var circle_color = Color(1, 0, 0)
@export var circle_width = 1.0
var radius: float
var collider: CollisionShape2D
#var colliders = []
#var num_frame = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is CollisionShape2D:
			collider = child

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var offset = get_parent().color_ramp.get_offset(1)
	var sphere_radius = get_parent().emission_sphere_radius
	radius = sphere_radius + (total_radius - sphere_radius) * offset
	collider.shape.radius = radius
	queue_redraw()
	
	#print (global_position)

	#if num_frame % 30 == 0:
		##var new_collider = CollisionShape2D(shape=CircleShape2D())
		#var shape = CircleShape2D.new()
		#shape.set_radius(2 + len(colliders)*3)
		#var collision = CollisionShape2D.new()
		#collision.set_shape(shape)
		#
		#colliders.append(collision)
		#add_child(collision)
	#num_frame += 1


func _draw():
	pass
	#draw_arc(Vector2(), radius, 0, 360, 100, circle_color, circle_width)

#
#func _on_area_entered(area):
	#print ("Collision ", area)
#
#
#func _on_body_entered(body):
	#print ("Collision ", body)
