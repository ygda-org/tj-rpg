extends Resource
class_name BaseEnemyResource

@export var texture: Texture2D
@export var health: float = 10.0
@export var speed: int = 10
@export var name: String = "Bob"

@export var obstacle_loadout : Array[ObstaclePackage] = []
