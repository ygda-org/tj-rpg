extends CharacterBody2D

class_name Basic_Enemy

@export var stats : BaseEnemyResource
@onready var player = $"../Player"

var BATTLE = preload("res://BATTLE/battle.tscn")
var health
var speed

func _ready() -> void:
	$Sprite2D.texture = stats.texture
	health = stats.health
	speed = stats.speed

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	point_towards_player()
	fight_check()
	move_and_slide()

func fight_check():
	if (player.position - self.position).length() < 50:
		pass
	pass

func point_towards_player():
	self.velocity = (player.position - self.position).normalized() * speed
