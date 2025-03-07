extends Area2D

# This should be a child of any interactable object 
# Sends out the interacted signal when its interacted with by a player_interact object
signal interacted
@export var one_shot: bool = false

func disable() -> void:
	self.monitorable = false
	
func enable() -> void:
	self.monitorable = true

func interact() -> void:
	emit_signal("interacted")
	if(one_shot):
		disable()
		
