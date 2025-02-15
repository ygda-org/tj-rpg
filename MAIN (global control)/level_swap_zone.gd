extends Area2D

# always add this as a direct child of the area scene

@export var to_scene_path: String = "res://" # path of the level we're moving to through here
var to_scene

func switch_scene() -> void: # the most wonderful few lines of code you'll ever witness
	to_scene = load(to_scene_path).instantiate()
	var main = get_parent().get_parent()
	main.add_child(to_scene)
	get_parent().free()

func _on_body_entered(body):
	if (body.name == "Player"):
		switch_scene()
