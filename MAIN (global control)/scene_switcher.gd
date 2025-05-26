extends Node

signal scene_ended

var current_scene: Node = null

var saved_scene: Node = null
var saved_scene_result = null


func _ready():
	var root = get_tree().root
	current_scene = root.get_child(-1)

func goto_scene(path):
	_deferred_goto_scene.call_deferred(path)
	
func _deferred_goto_scene(scene: Node):
	# Free the current scene, calling queue free doesn't matter here
	current_scene.free()
	current_scene = scene
	
	# Put the new scene in the scene tree
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func save_scene_and_goto(scene: Node) -> Variant:
	if(saved_scene != null):
		print("Attemped to switch to a temp scene, when present scene was already a temp scene.")
		return null
	
	_deferred_save_scene_and_goto.call_deferred(scene)
	
	return saved_scene_result
	
	
func _deferred_save_scene_and_goto(scene: Node):
	# Save the current main scene in the saved_scene variable
	current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	current_scene.hide()
	get_tree().root.remove_child(current_scene)
	saved_scene = current_scene
	
	# Add the temporary scene as the main scene in the tree
	current_scene = scene
	get_tree().root.add_child(current_scene)
	
	# Wait till the temporary scene calls end_temp_scene()
	await scene_ended 
	
	# Free the temporary scene 
	current_scene.queue_free()
	current_scene = saved_scene
	saved_scene = null
	
	# Add back the saved main scene to the scene tree
	current_scene.process_mode = Node.PROCESS_MODE_INHERIT
	current_scene.show()
	
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func end_temp_scene(result: Variant):
	if(saved_scene):
		saved_scene_result = result
		emit_signal("scene_ended")
