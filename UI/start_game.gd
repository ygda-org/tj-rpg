extends Node

#Later, it will pass in a save file to the SceneSwitcher and it will load the 
#current scene the player is in.
var first_scene: String = "res://MAIN (global control)/main.tscn"

func _on_pressed() -> void:
	SceneSwitcher.goto_scene(load(first_scene).instantiate())
