extends Node2D

signal textbox_closed
signal pressed

#MUST be loaded by the enemy, or a lot of bad things will happen
@export var enemy: BaseEnemyResource = null
@export var previous_scene = null

var current_player_health = 0
var current_enemy_health = 0
@export var player = null

var background : Texture2D

var loaded_move_index : int = -1

var rng = RandomNumberGenerator.new()

func _ready():
	#Generate Random Numbers
	rng.randomize()
	#Set background
	if background != null:
		$Background.texture = background
	player.freeze(true)
	#Set the Player and Enemy Health bar
	set_health($PlayerPanel/PlayerHealthBar, Gamestate.current_health, Gamestate.max_health)
	set_health($Enemy/EnemyHealthBar, enemy.health, enemy.health)
	#Pull and set Enemy Texture
	#WARNING The Spire ratios are way wack. Someone should fix it.
	$Enemy.texture = enemy.texture
	#Pull and set Player and Enemy health
	current_player_health = Gamestate.current_health
	current_enemy_health = enemy.health
	#Preemptivly Hide everything
	$Textbox.hide()
	$ActionsPanel.hide()
	$ActionsPanel/PlayerOptions.hide()
	$ActionsPanel/AttackOptions.hide()
	#Load in the Player moves
	load_moves()
	#Use our cool display method to start the battle
	display_text("a wild %s approaches omg (battle test)" % enemy.name.to_upper())
	await textbox_closed
	#Show Player Options
	$ActionsPanel.show()
	$ActionsPanel/PlayerOptions.show()

func load_moves():
	for i in range(0, len(Gamestate.player_moves)):
		var moveButton = find_child("Move" + str(i))
		var move : BasePlayerMove = Gamestate.player_moves[i]
		moveButton.text = move.display_name.to_upper()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health

func enemy_turn():
	#Randomly pick a move. Currently equally waited, so dumb AI.
	var chosen_move = enemy.moves[rng.randi_range(0, len(enemy.moves) - 1)]
	#Display chosen move
	display_text(str(enemy.name.to_upper(), " uses ", chosen_move.display_name))
	await textbox_closed
	
	#Roll accuracy
	var acc_roll = rng.randf_range(0, 1)
	if acc_roll > chosen_move.accuracy:#If it misses, it misses
		display_text("It misses!")
		await textbox_closed
		return
	#Continuing assuming it hits
	#Store damage, as we might add crit
	var applied_damage = chosen_move.damage
	#Roll crit
	var crit_roll = rng.randf_range(0, 1)
	if crit_roll <= chosen_move.crit_chance:#If crit lands, apply 100% bonus
		applied_damage *= 2
		#Alert player of crit
		display_text("It's a critical hit!")
		await textbox_closed
	#Apply damage
	current_player_health = max(0, current_player_health - applied_damage)
	#Update healthbar
	set_health($PlayerPanel/PlayerHealthBar, current_player_health, Gamestate.max_health)
	#Show damage dealt
	display_text("%s dealt %d damage!" % [chosen_move.display_name.to_upper(), applied_damage])
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
	end_fight()

func _on_attack_pressed():
	$ActionsPanel/AttackOptions.show()
	await pressed
	
	var chosen_move : BasePlayerMove = Gamestate.player_moves[loaded_move_index]
	
	display_text("You used " + chosen_move.display_name)
	await textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - chosen_move.damage)
	set_health($Enemy/EnemyHealthBar, current_enemy_health, enemy.health)
	
	display_text("You dealt %d damage!" % chosen_move.damage)
	await textbox_closed
	
	if current_enemy_health == 0:
		display_text("%s was murdered in cold blood" % enemy.name.to_upper())
		await textbox_closed
		end_fight()
	else:
		enemy_turn()

func _on_heal_pressed():
	display_text("you ate dan tat!! mmmmm")
	await textbox_closed
	
	current_player_health = min(Gamestate.max_health, current_player_health + 20)
	set_health($PlayerPanel/PlayerHealthBar, current_player_health, Gamestate.max_health)
	
	display_text("yippee you healed 20 health!")
	await textbox_closed
	
	enemy_turn()

func end_fight():
	await get_tree().create_timer(.25).timeout
	player.freeze(false)
	SceneSwitcher.end_temp_scene(self)


func _on_move_pressed(move_index: int) -> void:
	loaded_move_index = move_index
	emit_signal("pressed")
