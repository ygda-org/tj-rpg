extends CharacterBody2D

const SPEED = 45
const SLOW_WALK = 0.5
var direction: Vector2 = Vector2(0,0)
var can_move : bool = true

func _physics_process(delta):
	if(Gamestate.dialogue_playing or not can_move):
		return
	direction = Vector2(0, 0)
	
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_up"):
		direction.y = -1
	if Input.is_action_pressed("move_down"):
		direction.y = 1
	
	direction = direction.normalized()	
	
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	
	if(Input.is_action_pressed("slow_walk")):
		velocity *= SLOW_WALK
	if Input.is_action_pressed("debug_run"): # FOR DEBUG PURPOSES, PRESS CTRL TO RUN FASTER
		velocity *= 4
	
	
	if velocity == Vector2(0,0):
		$Anim.play("idle")
	else:
		$Anim.play("Walk Forward")
	move_and_slide()
	
func freeze(input : bool):
	if(input):
		$player_interact.can_interact = false
		$Sprite.visible = false
		can_move = false
	else:
		$player_interact.can_interact = true
		$Sprite.visible = true
		can_move = true
