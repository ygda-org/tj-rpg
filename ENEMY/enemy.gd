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
	if (player.position - self.position).length() < 200:
		var battle_instance = BATTLE.instantiate()
		battle_instance.enemy = stats
		get_parent().add_child(battle_instance)
		print("LETS GO BOI | Battle Scene Adopted by Parent Node")
		queue_free()

func point_towards_player():
	self.velocity = (player.position - self.position).normalized() * speed
