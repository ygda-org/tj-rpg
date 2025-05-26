extends Area2D

# always add this as a direct child of the area scene

@export var to_scene_path: String = "res://" # path of the level we're moving to through here
@export var player_spawn: int = 0 # the id of the spawn location the player should go to, -1 if default
@export var save_scene: bool = false

func switch_scene() -> void: # the most wonderful few lines of code you'll ever witness
	if(save_scene):
		SceneSwitcher.save_scene_and_goto(load(to_scene_path).instantiate())
		queue_free()
	else:
		var scene: Node = load(to_scene_path).instantiate()
		if player_spawn >= 0:
			var location: Node = scene.get_node("SpawnLocations")	
			
			if location == null:
				print("SpawnLocations do not exist in this scene! Set the player_spawn to -1 on level_swap_zone if that is intended.")
				return
	
			location = location.get_node(str(player_spawn))
			
			if location == null:
				print("Invalid spawn location!")
				return
			
			scene.get_node("Player").position = location.position
	
		SceneSwitcher.goto_scene(scene)
	

func _on_body_entered(body):
	if (body.name == "Player"):
		switch_scene()
