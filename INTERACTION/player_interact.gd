extends Area2D

# This node is meant to be a child node of the player
# Add whatever shape2d necessary for the player.

# This nodes collision and mask layer is on layer 2, as are other interaction objects
# This node doesn't need to detect collisions, only an interactable object detects it



func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("interact")):
		self.monitorable = true
	else:
		self.monitorable = false
