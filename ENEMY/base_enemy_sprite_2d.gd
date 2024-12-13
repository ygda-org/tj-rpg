extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_node("...")
	texture = parent.texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
