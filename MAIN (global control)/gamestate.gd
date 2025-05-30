extends Node2D

var dialogue_playing: bool = false

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	
	
func _on_dialogue_manager_dialogue_ended(resource: DialogueResource) -> void:
	dialogue_playing = false
