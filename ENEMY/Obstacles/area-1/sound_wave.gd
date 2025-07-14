extends Node2D

signal start_seq_finished
signal active_seq_finished
signal exit_seq_finished

@export var starting_pos = Vector2(0,0)

@onready var player = get_parent().get_parent().get_node("Player")

var tween

var projectile_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	position = starting_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_sequence():
	$AnimationPlayer.queue("start")
	print("starting")
	await $AnimationPlayer.caches_cleared
	emit_signal("start_seq_finished")

func active_sequence():
	$AnimationPlayer.queue("active")
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", player.position, projectile_speed)
	print("ACTIVE")
	await $AnimationPlayer.caches_cleared
	emit_signal("active_seq_finished")

func exit_sequence():
	$AnimationPlayer.queue("exit")
	print("exit")
	await $AnimationPlayer.caches_cleared
	tween.tween_callback(self.queue_free)
	emit_signal("exit_seq_finished")

func suicide():
	queue_free()
