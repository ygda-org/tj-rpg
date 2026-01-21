extends Node2D

# to use BaseItem, just fill in the stuff and add an interactable node for pickup

@export var field_sprite: Texture2D

@export var item_resource: BaseItemResource = null

@onready var interactable = get_node("Interactable")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = field_sprite
	await interactable.interacted
	if interactable.one_shot == false:
		interactable.one_shot = true
	call_deferred("queue_free")
	PlayerState.item_inventory.append(item_resource)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
