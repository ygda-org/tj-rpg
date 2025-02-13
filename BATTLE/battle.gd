extends Node2D

signal textbox_closed

@export var enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0

func _ready():
	set_health($PlayerPanel/PlayerHealthBar, Gamestate.current_health, Gamestate.max_health)
	set_health($EnemyHealthBar, enemy.health, enemy.health)
	$Enemy.texture = enemy.texture
	
	current_player_health = Gamestate.current_health
	current_enemy_health = enemy.health
	
	$Textbox.hide()
	$ActionsPanel.hide()
	
	display_text("a wild %s approaches omg (battle test)" % enemy.enemy_name.to_upper())
	await textbox_closed
	$ActionsPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health

func enemy_turn():
	display_text("%s smacks you in the face!" % enemy.enemy_name.to_upper())
	await textbox_closed
	
	current_player_health = max(0, current_player_health - enemy.damage)
	set_health($PlayerPanel/PlayerHealthBar, current_player_health, Gamestate.max_health)
	
	display_text("%s dealt %d damage!" % [enemy.enemy_name.to_upper(), enemy.damage])
	await textbox_closed

func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$Textbox.show()
	$Textbox/Label.text = text

func _on_run_pressed():
	display_text("got away safely (coward not very sigma of you)")
	await textbox_closed
	await get_tree().create_timer(.25).timeout
	get_tree().quit() #should replace this with a signal to return to overworld

func _on_attack_pressed():
	display_text("sic em! miku miku beeeam!!!!")
	await textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - Gamestate.damage)
	set_health($EnemyHealthBar, current_enemy_health, enemy.health)
	
	display_text("you dealt %d damage!" % Gamestate.damage)
	await textbox_closed
	
	if current_enemy_health == 0:
		display_text("%s was murdered in cold blood" % enemy.enemy_name.to_upper())
		await textbox_closed
		
		await get_tree().create_timer(.25).timeout
		get_tree().quit() #should replace this with a signal to return to overworld
	
	enemy_turn()

func _on_heal_pressed():
	display_text("you ate dan tat!! mmmmm")
	await textbox_closed
	
	current_player_health = min(Gamestate.max_health, current_player_health + 20)
	set_health($PlayerPanel/PlayerHealthBar, current_player_health, Gamestate.max_health)
	
	display_text("yippee you healed 20 health!")
	await textbox_closed
	
	enemy_turn()
