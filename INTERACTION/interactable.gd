extends Area2D

# This signal is sent out when the player interacts with the interactable
# This node should be a child of any interactable object
# It's on layer 2 and it's mask is on layer 2, all interactions should be on layer 2, we can change that later though
# You should add a Shape2d to give it whatever shape necessary

signal interacted

func disable() -> void:
	self.monitoring = false
	
func enable() -> void:
	self.monitoring = true
	
func _on_area_exited(area: Area2D) -> void:
	emit_signal("interacted")
