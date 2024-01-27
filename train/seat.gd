extends StaticBody2D
class_name Seat

@export var is_available : bool = false
@export var available_spaces : Array[Passenger] = [null, null]

@onready var spaces_positions : Node = $SpacesPositions

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(
		available_spaces.size() == spaces_positions.get_children().size(),
		"available_spaces and spaces_position must have the same size"
	)

	for p in available_spaces:
		if p != null:
			take_a_seat(p)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Check if has available space and return available position, otherwise it will return -1
func has_available_space(p : Passenger = null) -> int :
	for i in len(available_spaces):
		if available_spaces[i] != null && p == available_spaces[i]:
			return i

		if available_spaces[i] == null:
			return i

	return -1

func take_a_seat(p : Passenger) -> bool:
	var available_index = has_available_space(p)
	if available_index == -1:
		return false

	available_spaces[available_index] = p
	p.global_position = spaces_positions.get_children()[available_index].global_position
	p.set_sitting(true)

	return true
