extends Area2D

# always add this as a direct child of the area scene

@export var to_scene_path: String = "res://" # path of the level we're moving to through here
@export var save_scene: bool = false

func switch_scene() -> void: # the most wonderful few lines of code you'll ever witness
	if(save_scene):
		SceneSwitcher.save_scene_and_goto(load(to_scene_path).instantiate())
		queue_free()
	else:
		SceneSwitcher.goto_scene(to_scene_path)
	

func _on_body_entered(body):
	if (body.name == "Player"):
		switch_scene()
