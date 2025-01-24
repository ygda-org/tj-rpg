extends CharacterBody2D



@export var stats : BaseEnemyResource
@onready var player = $"../Player"

var health
var damage
var speed

func _ready() -> void:
	$Sprite2D.texture = stats.texture
	health = stats.health
	damage = stats.damage
	speed = stats.speed

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	point_towards_player()
	move_and_slide()

func point_towards_player():
	self.velocity = (player.position - self.position).normalized() * speed
	pass
