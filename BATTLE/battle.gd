extends Node2D

signal textbox_closed
signal move_chosen
signal animation_finished

#MUST be loaded by the enemy, or a lot of bad things will happen
@export var enemy: BaseEnemyResource = null
@export var previous_scene = null
const FIGHT_MANAGER = preload("res://ENEMY/FightManager/fight_manager.tscn")

var current_player_health = 0
var current_enemy_health = 0
var player_stats = {"speed": 2.0, "defense": 1.0, "size": 1.0}
@export var player = null

var background : Texture2D

var loaded_move_index : int = -1

var rng = RandomNumberGenerator.new()

func _ready():
	# Generate Random Numbers
	rng.randomize()
	# Set background
	if background != null:
		$Background.texture = background
	if(player != null):
		player.freeze(true)
	# Set the Player and Enemy Health bar
	set_health($PlayerPanel/PlayerHealthBar, Gamestate.current_health, Gamestate.max_health)
	set_health($Enemy/EnemyHealthBar, enemy.health, enemy.health)
	# Pull and set Enemy Texture
	# WARNING The Spire ratios are way wack. Someone should fix it.
	$Enemy.texture = enemy.texture
	# Pull and set Player and Enemy health
	current_player_health = Gamestate.current_health
	current_enemy_health = enemy.health
	# Preemptivly Hide everything
	$Textbox.hide()
	$ActionsPanel.hide()
	$ActionsPanel/PlayerOptions.hide()
	$ActionsPanel/AttackOptions.hide()
	# Load in the Player moves
	load_moves()
	# Connect the buttons. Idk why they keep disconnecting mysteriously, so I'm coding it.
	$ActionsPanel/AttackOptions/Move0.pressed.connect(_on_move_pressed.bind(0))
	$ActionsPanel/AttackOptions/Move1.pressed.connect(_on_move_pressed.bind(1))
	$ActionsPanel/AttackOptions/Move2.pressed.connect(_on_move_pressed.bind(2))
	$ActionsPanel/AttackOptions/Move3.pressed.connect(_on_move_pressed.bind(3))
	#Use our cool display method to start the battle
	display_text("a wild %s approaches omg (battle test)" % enemy.name.to_upper())
	await textbox_closed
	#Show Player Options
	$ActionsPanel.show()
	$ActionsPanel/PlayerOptions.show()
	slideActionPanel("up")
'''
start_sequence
transition
player_turn
enemy_turn
end_sequence
'''
var state := 'start_sequence'

func load_moves():
	for i in range(0, len(Gamestate.player_moves)):
		var moveButton = find_child("Move" + str(i))
		var move : BasePlayerMove = Gamestate.player_moves[i]
		moveButton.text = move.display_name.to_upper()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health

func enemy_turn():
	#Move Enemy icon Off
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("slide_enemy_icon")
	await $AnimationPlayer.animation_finished
	
	var fight_instance = FIGHT_MANAGER.instantiate() 
	fight_instance.obst_package_list = enemy.obstacle_loadout.duplicate()
	fight_instance.player_stat_list = player_stats
	add_child(fight_instance)
	fight_instance.visible = true
	await fight_instance.fight_finished
	remove_child(fight_instance)
	
	#Move enemy back in focus
	$AnimationPlayer.play_backwards("slide_enemy_icon")
	await $AnimationPlayer.animation_finished
	#Bring Player Options Up
	slideActionPanel("up")

##direction is a string either called "up" or "down"
func slideActionPanel(direction):
	if(direction == "up"):
		$AnimationPlayer.play("slide_action_panel")
	else:
		$AnimationPlayer.play_backwards("slide_action_panel")

func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$Textbox.show()
	$Textbox/Label.text = text

func update_player_health():
	current_player_health = Gamestate.current_health
	set_health($PlayerPanel/PlayerHealthBar, current_player_health, Gamestate.max_health)

func update_enemy_health():
	set_health($Enemy/EnemyHealthBar, current_enemy_health, enemy.health)

func _on_run_pressed():
	display_text("got away safely (coward not very sigma of you)")
	await textbox_closed
	end_fight()

func _on_attack_pressed():
	$ActionsPanel/AttackOptions.show()
	await move_chosen
	
	var chosen_move : BasePlayerMove = Gamestate.player_moves[loaded_move_index]
	
	display_text("You used " + chosen_move.display_name)
	await textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - chosen_move.damage)
	set_health($Enemy/EnemyHealthBar, current_enemy_health, enemy.health)
	if (chosen_move.damage != 0):
		display_text("You dealt %d damage!" % chosen_move.damage)
		await textbox_closed
	if (chosen_move.damage == 0): # not this specifically but change later for special effect moves
		display_text("Some other special effect ig lol")
		await textbox_closed
	
	if current_enemy_health == 0:
		display_text("%s was murdered in cold blood" % enemy.name.to_upper())
		await textbox_closed
		end_fight()
	else:
		# handling stat changing moves for the player
		if (chosen_move.player_speed != 2.0): # ngl there's gotta be a better way to store it but my brain no workie
			player_stats["speed"] = chosen_move.player_speed
		if (chosen_move.player_defense != 1.0):
			player_stats["defense"] = chosen_move.player_defense
		if (chosen_move.player_size_scale != 1.0):
			player_stats["size"] = chosen_move.player_size_scale
		# 
		$AnimationPlayer.play_backwards("slide_action_panel")
		$ActionsPanel/AttackOptions.hide()
		enemy_turn()

func _on_heal_pressed():
	display_text("you ate dan tat!! mmmmm")
	await textbox_closed
	
	current_player_health = min(Gamestate.max_health, current_player_health + 20)
	set_health($PlayerPanel/PlayerHealthBar, current_player_health, Gamestate.max_health)
	
	display_text("yippee you healed 20 health!")
	await textbox_closed
	$AnimationPlayer.play_backwards("slide_action_panel")
	$ActionsPanel/AttackOptions.hide()
	enemy_turn()

func end_fight():
	await get_tree().create_timer(.25).timeout
	player.freeze(false)
	SceneSwitcher.end_temp_scene(self)


func _on_move_pressed(move_index: int) -> void:
	loaded_move_index = move_index
	emit_signal("move_chosen")

func _on_animation_player_caches_cleared() -> void:
	emit_signal("animation_finished")
