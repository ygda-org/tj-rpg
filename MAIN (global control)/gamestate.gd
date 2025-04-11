extends Node2D

var current_health = 100
var max_health = 100
var damage = 20
var dialogue_playing: bool = false
#Default starting moves
const BASIC_HIT = preload("res://PLAYER MOVES/Move_Resources/basic_hit.tres")
const LARGE_HIT = preload("res://PLAYER MOVES/Move_Resources/large_hit.tres")
var player_moves : Array[BasePlayerMove] = [BASIC_HIT, LARGE_HIT]

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	
	
func _on_dialogue_manager_dialogue_ended(resource: DialogueResource) -> void:
	dialogue_playing = false
