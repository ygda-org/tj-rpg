class_name ObstaclePackage

extends Resource

##The Obstacle to Summon. The Scene must be a Node2D containing a working GenericObstacleController
@export var obstacle : PackedScene
##The Location the manager will summon the obstacle at. The Area is 732px x 482px (width x height). NOT ANYMORE
##The border is 16px on each side, so 700px x 450px playing area. 16px not added automatically, nor clamped.
@export var location : Vector2
##Time until the node is added to the scene (sec)
@export var summon_time : int
