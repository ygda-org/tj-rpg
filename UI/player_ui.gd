extends Control

func _ready() -> void:
	$Healthbar.max_value = Gamestate.max_health
	$Healthbar.value = Gamestate.max_health

func _physics_process(delta: float) -> void:
	$Healthbar.value = Gamestate.current_health
