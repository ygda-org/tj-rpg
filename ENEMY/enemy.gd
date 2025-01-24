extends CharacterBody2D



@export var stats : BaseEnemyResource

var health := stats.health
var damage := stats.damage
var speed := stats.speed

func _ready() -> void:
	$Sprite2D.texture = stats.texture

func _physics_process(delta: float) -> void:
	
	move_and_slide()
