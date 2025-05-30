extends Node

# The save file will be located at: 
# Windows: %APPDATA%/Godot/app_userdata/TJ-RPJ/save_data.ini
# GNU/Linux: .local/share.godot/app_userdata/TJ-RPJ/save_data.ini (at least for me)
const save_path = "user://save_data.ini"

#Default starting moves
const BASIC_HIT = preload("res://PLAYER MOVES/Move_Resources/basic_hit.tres")
const LARGE_HIT = preload("res://PLAYER MOVES/Move_Resources/large_hit.tres")

### PLAYER DATA ###
var current_health: int = 100
var max_health: int = 100
var damage: int = 20
var active_moves : Array = [BASIC_HIT, LARGE_HIT]
var inventory : Array = [BASIC_HIT, LARGE_HIT]
#######

func save_game() -> void:
	var save_file = ConfigFile.new()
	
	save_file.set_value("Player", "current_health", current_health)
	save_file.set_value("Player", "max_health", max_health)
	save_file.set_value("Player", "damage", damage)
	save_file.set_value("Player", "active_moves", active_moves)
	save_file.set_value("Player", "inventory", inventory)
	
	var error = save_file.save(save_path)
	if error:
		print("Error occured while saving player data: ", error)
	

func load_save() -> void:
	if not FileAccess.file_exists(save_path):
		print("Tried loading without any saved data!")
		return
	
	var save_file = ConfigFile.new()
	var error = save_file.load(save_path)
	
	if error:
		print("Error occured while loading save data: ", error)
		return
	
	current_health = save_file.get_value("Player", "current_health", 100)
	max_health = save_file.get_value("Player", "max_health", 100)
	damage = save_file.get_value("Player", "damage", 20)
	active_moves = save_file.get_value("Player", "active_moves", [])
	inventory = save_file.get_value("Player", "inventory", [])
	
