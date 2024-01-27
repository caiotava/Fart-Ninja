extends CharacterBody2D
class_name Passenger

@export var animation_resource : Resource = null

var default_path_length : Array[Vector2] = [Vector2(300, 230), Vector2(1800, 920)]

@export_group("Movement")
@export var movement_speed: float = 200.0
@export var movement_target_position: Vector2 = Vector2(60.0,180.0)
@export var movement_path_length : Array[Vector2] = default_path_length
@export var is_paused : bool = false
@export var pause_time_limit : float = 1.5
@export var pause_likelihood : float = 0.1

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer : Timer = $Timer

var is_sitting = false;

func _ready():
	if is_sitting:
		set_sitting_animation()

	if animation_resource != null:
		animation_sprite.sprite_frames = animation_resource

	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	timer.wait_time = pause_time_limit

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(get_random_position())

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if is_sitting:
		return

	physics_process_movement(delta)

func physics_process_movement(delta):
	if navigation_agent.is_navigation_finished():
		handle_pause()
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	animation_sprite.play("walking")

	# has collision
	if move_and_slide():
		pause_movement()

func get_random_position():
	var bounds = movement_path_length
	if bounds.size() < 2:
		bounds = default_path_length

	return Vector2(randf_range(bounds[0].x, bounds[1].x), randf_range(bounds[0].y, bounds[1].y))

func handle_pause():
	if is_paused:
		return

	var rand_number = randf_range(0, 1)
	if rand_number < pause_likelihood:
		pause_movement()

func pause_movement():
	is_paused = true
	velocity = Vector2.ZERO
	animation_sprite.play("idle")

	if timer.is_stopped() && pause_time_limit > 0:
		timer.start()

func _on_timer_timeout():
	is_paused = false;
	set_movement_target(get_random_position())

func set_sitting(is_sitting : bool, seat : Seat = null):
	self.is_sitting = is_sitting
	set_sitting_animation()

func set_sitting_animation():
	if animation_sprite == null:
		return

	animation_sprite.flip_h = true
	animation_sprite.play("sitting")
