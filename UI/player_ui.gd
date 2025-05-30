extends Control

func _ready() -> void:
	$Healthbar.max_value = PlayerState.max_health
	$Healthbar.value = PlayerState.max_health

func _physics_process(delta: float) -> void:
	$Healthbar.value = PlayerState.current_health
