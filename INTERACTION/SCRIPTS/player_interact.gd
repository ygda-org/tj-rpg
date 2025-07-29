extends Area2D

# This node is meant to be a child node of the player
# Add whatever shape2d necessary for the players interaction range.

# The player shouldn't be able to interact if they are moving at the same time
# If the player holds any keys in this array, the interaction won't count
const bad_actions: Array = ["move_left", "move_right", "move_up", "move_down"]
@export var can_interact: bool = true
var playing_dialogue: bool = false

func _process(_delta: float) -> void:	
	if(Gamestate.dialogue_playing): #Player shouldn't interact when dialogue is already playing
		return 
	
	for action in bad_actions: #Player shouldn't interact whlie they are moving
		if(Input.is_action_pressed(action)):
			return

	if(can_interact && Input.is_action_just_released("interact")):
		var interactables = get_overlapping_areas()
		if interactables.size() == 0: 
			return
		
		assert(interactables[0].is_in_group("interactable"))
		interactables[0].interact()
