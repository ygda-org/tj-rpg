extends CharacterBody2D

const SPEED = 400
const SLOW_WALK = 0.5
var direction: Vector2 = Vector2(0,0)


func _physics_process(delta):
	direction = Vector2(0, 0)
	
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_up"):
		direction.y = -1
	if Input.is_action_pressed("move_down"):
		direction.y = 1
		
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	
	if(Input.is_action_pressed("slow_walk")):
		velocity *= SLOW_WALK
	
	
	move_and_slide()
