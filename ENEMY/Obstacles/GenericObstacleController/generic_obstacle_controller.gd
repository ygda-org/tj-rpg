class_name GenericObstacleController

extends Node2D

## Damage dealt to the player
@export var damage : int = 10
## Whether to summon with random or pre defined positions.
@export var random_position : bool = false
## If random_positon is true, what is the range we should generate between for x dimension.
## Border is not considered automatically.
## It's a vector2i just for the purpose of storing 2 numbers in one variable.
## The x is the min, and the y is the max (both inclusive)
@export var random_range_x : Vector2i = Vector2i(16,700)
## If random_positon is true, what is the range we should generate between for y dimension.
## Border is not considered automatically.
## It's a vector2i just for the purpose of storing 2 numbers in one variable.
## The x is the min, and the y is the max (both inclusive)
@export var random_range_y : Vector2i = Vector2i(16,450)
## If true, the controller will immediatly disable after player is hit.
## If false, it will tick damage multiple times until player exits.
@export var oneshot_damage : bool = true


# The Controller needs to load in the parent. It must contain an area_2d
var parent : Node2D
var area_2d : Area2D

# Determines Obstacle behavior
# Either "start" (warning sequence), "active" (dealing dmg), "exit" (exit sequence)
var state = "start"

func _ready() -> void:
	parent = get_parent()
	parent.start_seq_finished.connect(_seq_finished.bind("start"))
	parent.active_seq_finished.connect(_seq_finished.bind("active"))
	parent.exit_seq_finished.connect(_seq_finished.bind("exit"))
	area_2d = parent.find_child("Area2D")
	assert(area_2d != null, "Controller couldn't find Area2D Sibling Node. Check the Name!")
	area_2d.monitoring = false
	area_2d.monitorable = false
	if(random_position):
		var rng = RandomNumberGenerator.new()
		parent.position.x = rng.randi_range(random_range_x.x, random_range_x.y)
		parent.position.y = rng.randi_range(random_range_y.x, random_range_y.y)

func _seq_finished(just_finished_seq : String):
	if just_finished_seq == "start":
		state = "active"
	if just_finished_seq == "active":
		state = "exit"
	if just_finished_seq == "exit":
		parent.suicide()

func _process(delta: float) -> void:
	if state == "start":
		state = "idle"
		parent.start_sequence()
	elif state == "active":
		area_2d.area_entered.connect(_on_area_entered)
		area_2d.monitoring = true
		state = "idle"
		parent.active_sequence()
	elif state == "exit":
		state = "idle"
		parent.exit_sequence()

func _on_area_entered(area: Area2D):
	Gamestate.current_health -= damage
	print(Gamestate.current_health)
	get_node("/root/Battle").update_player_health()
	area_2d.monitoring = false
	if oneshot_damage:
		return
