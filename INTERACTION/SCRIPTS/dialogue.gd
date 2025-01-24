extends Node2D

@export var dialogue_resource: DialogueResource
@export var dialoge_start: String = "start"

# This node is meant to be attatched to a interactable object
# It displays the dialogue when the "interacted" signal is emited from the parent interactable object

func _ready() -> void:
	var parent_interactable = get_parent()
	assert(parent_interactable.is_in_group("interactable")) # This should be a child of an interactable
	parent_interactable.interacted.connect(_show_dialogue)	


func _show_dialogue() -> void:
	Gamestate.dialogue_playing = true
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialoge_start)
