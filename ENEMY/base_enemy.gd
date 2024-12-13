extends Node2D

class_name Base_Enemy

@export var enemy_name: String = "Enemy"
@export var texture: Texture = preload("res://test-image.svg") #default texture bc i can't get null values to work
@export var maxHealth: int = 30
var health: int = 30
@export var damage: int = 20
var target_velocity

const PLAYER = preload("res://player.tscn")

func applyDamage(inputDamage : int):
	health -= inputDamage;
	if(health <= 0):
		health = 0
		suicide()

func heal(inputHealth : int):
	health += inputHealth
	
func suicide():
	queue_free()

func moveTo():
	target_velocity = Vector2(PLAYER.x, PLAYER.y)

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
