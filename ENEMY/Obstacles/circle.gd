extends Node2D

signal start_seq_finished
signal active_seq_finished
signal exit_seq_finished

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func start_sequence():
	$AnimationPlayer.queue("start")
	print("starting")
	await $AnimationPlayer.caches_cleared
	emit_signal("start_seq_finished")

func active_sequence():
	$AnimationPlayer.queue("active")
	print("ACTIVE")
	await $AnimationPlayer.caches_cleared
	emit_signal("active_seq_finished")

func exit_sequence():
	$AnimationPlayer.queue("exit")
	print("exit")
	await $AnimationPlayer.caches_cleared
	emit_signal("exit_seq_finished")

func suicide():
	queue_free()
