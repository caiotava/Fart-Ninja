extends CharacterBody2D
class_name Passenger

enum ALERT_LEVEL {NONE, QUESTION, EXCLAMATION, ANGRY}

var default_path_length : Array[Vector2] = [Vector2(300, 230), Vector2(1800, 920)]
var default_sitting_position : Vector2 = Vector2(71.429, -171.429)

@export var animation_resource : Resource = null

@export_group("Movement")
@export var movement_speed: float = 200.0
@export var movement_target_position: Vector2 = Vector2(60.0,180.0)
@export var movement_path_length : Array[Vector2] = default_path_length
@export var is_paused : bool = false
@export var pause_time_limit : float = 1.5
@export var pause_likelihood : float = 0.1
@export var can_stand_up : bool = false
@export var stand_up_time : float = 1.5
@export var game_over_time: float = 2.0
@export var inverte_flip: bool = false

@export_group("Alert Timers")
@export var alert_question_time: float = 1.2
@export var alert_exclamation_time: float = 1.3
@export var alert_angry_time: float = 1.5
@export var alert_gameover_time: float = 2

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_walking : Timer = $TimerWalking
@onready var timer_stand_up : Timer = $TimerStandUp
@onready var timer_game_over: Timer = $TimerGameOver
@onready var timer_alert_question: Timer = $TimerAlertQuestion
@onready var timer_alert_exclamation: Timer = $TimerAlertExclamation
@onready var alert_sign : Sprite2D = $AlertSign
@onready var animation_player : AnimationPlayer = $AnimationPlayer

var is_sitting = false;
var nearest_seat : Seat = null
var alert_timestamp = null
var alert_level : ALERT_LEVEL = ALERT_LEVEL.NONE

signal game_over

func _ready():
	animation_player.active = false
	animation_sprite.modulate = Color.WHITE
	if is_sitting:
		set_sitting_animation()

	if animation_resource != null:
		animation_sprite.sprite_frames = animation_resource

	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	timer_walking.wait_time = pause_time_limit
	timer_stand_up.wait_time = stand_up_time
	timer_game_over.wait_time = game_over_time

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
		physics_process_sitting(delta)
		return

	physics_process_movement(delta)

func physics_process_sitting(delta):
	if !can_stand_up:
		return

func physics_process_movement(delta):
	if navigation_agent.is_navigation_finished():
		handle_pause()
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	animation_sprite.play("walking")

	if velocity != Vector2.ZERO:
		animation_sprite.flip_h = velocity.x < 0

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

	if nearest_seat != null:
		nearest_seat.take_a_seat(self)

	var rand_number = randf_range(0, 1)
	if rand_number < pause_likelihood:
		pause_movement()

func pause_movement():
	is_paused = true
	nearest_seat = null
	velocity = Vector2.ZERO
	animation_sprite.play("idle")

	if timer_walking.is_stopped() && pause_time_limit > 0:
		timer_walking.start()

func _on_timer_timeout():
	is_paused = false;
	set_movement_target(get_random_position())

func set_sitting(is_sitting : bool, seat : Seat = null):
	self.is_sitting = is_sitting
	set_sitting_animation()

func set_sitting_animation():
	if animation_sprite == null:
		return

	animation_sprite.flip_h = inverte_flip
	animation_sprite.play("sitting")
	animation_sprite.position = default_sitting_position

func enter_alert_mode():
	set_alert_level(ALERT_LEVEL.QUESTION)

	if is_sitting && can_stand_up:
			timer_stand_up.start()

func exit_alert_mode():
	set_alert_level(ALERT_LEVEL.NONE)

func _on_timer_stand_up_timeout():
	nearest_seat = null
	var current_seat : Seat = null
	var nearest_seat_distance : float = 0
	var seats = get_tree().get_nodes_in_group("seats")
	for s : Seat in seats:
		if s.is_passenger_on_seat(self):
			current_seat = s

		if s.has_available_space(self) == -1 || s.is_passenger_on_seat(self):
			continue

		var seat_distance = (global_position - s.get_position_to_take_a_seat()).length()
		if nearest_seat == null || seat_distance < nearest_seat_distance:
			nearest_seat = s
			nearest_seat_distance = seat_distance

	if nearest_seat != null:
		is_paused = false
		is_sitting = false
		current_seat.leave_the_seat(self)
		global_position = current_seat.get_position_to_take_a_seat()
		set_movement_target(nearest_seat.get_position_to_take_a_seat())

func _on_timer_game_over_timeout():
	print ("Game Over")
	game_over.emit()

func set_alert_level(level : ALERT_LEVEL):
	alert_level = level

	match alert_level:
		ALERT_LEVEL.NONE:
			timer_alert_question.stop()
			timer_alert_exclamation.stop()
			timer_game_over.stop()
			alert_sign.visible = false
			animation_player.stop()
			animation_sprite.modulate = Color.WHITE
			if is_sitting:
				animation_sprite.play("sitting")
		ALERT_LEVEL.QUESTION:
			timer_alert_question.start()
			alert_sign.visible = true
			alert_sign.frame = 0
			if is_sitting:
				animation_sprite.play("sitting_question")
		ALERT_LEVEL.EXCLAMATION:
			timer_alert_exclamation.start()
			alert_sign.frame = 1
			if is_sitting:
				animation_sprite.play("sitting_exclamation")
		ALERT_LEVEL.ANGRY:
			animation_player.active = true
			animation_player.play("alert-color-modulation")
			timer_game_over.start()
			alert_sign.frame = 2
			if is_sitting:
				animation_sprite.play("sitting_angry")

func _on_timer_alert_question_timeout():
	set_alert_level(ALERT_LEVEL.EXCLAMATION)

func _on_timer_alert_exclamation_timeout():
	set_alert_level(ALERT_LEVEL.ANGRY)
