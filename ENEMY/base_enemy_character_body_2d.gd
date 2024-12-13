extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var parent = get_node("..")
	parent.moveTo()
	velocity = parent.target_velocity
	move_and_slide()
