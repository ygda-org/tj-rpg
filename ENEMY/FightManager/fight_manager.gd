extends Node2D
class_name FightManager

@export var obst_package_list : Array[ObstaclePackage]
@export var player_stat_list : Dictionary

@onready var player = $Player
@onready var player_sprite = $Player/Sprite2D
@onready var player_collision = $Player/CollisionShape2D
var speed : float = 2.0
var elapsed_time : float = 0.0

signal fight_finished

func _ready() -> void:
	update_player_stats()
	position = Vector2(get_viewport().size.x/2 - 732/2, get_viewport().size.y/2 - 482/2)


func _process(delta: float) -> void:
	update_elapsed_time(delta)
	update_player()
	load_obstacles()

func update_player_stats():
	speed = player_stat_list["speed"]
	player_sprite.scale = Vector2(player_stat_list["size"], player_stat_list["size"])
	player_collision.scale = Vector2(player_stat_list["size"], player_stat_list["size"])

func update_elapsed_time(delta: float) -> void:
	elapsed_time += delta

func update_player() -> void:
	var velocity := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	player.position += velocity * speed
	# Restrict Player position within border
	player.position.x = clamp(player.position.x, 32, 700)
	player.position.y = clamp(player.position.y, 32, 450)

func load_obstacles() -> void:
	
	if len(obst_package_list) == 0 and $Obstacles.get_child_count() == 0:
		end_fight()
		return
	for package in obst_package_list:
		if package.summon_time <= elapsed_time:
			var instance = package.obstacle.instantiate()
			instance.position = package.location
			$Obstacles.add_child(instance)
			obst_package_list.erase(package)

func end_fight():
	emit_signal("fight_finished")
