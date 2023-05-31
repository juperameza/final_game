extends Control
export (Resource) var enemy = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()
signal textbox_closed
var current_player_health
var current_enemy_health
var is_defending = false
var defense_duration = 0
onready var selector_attack = $ActionsPanel/Actions/Attack/Selector_attack
onready var selector_defend = $ActionsPanel/Actions/Defend/Selector_defend
onready var selector_run = $ActionsPanel/Actions/Run/Selector_run
onready var selector_hook = $AttackPanel/Actions/Hook/Selector_hook
onready var selector_upper = $AttackPanel/Actions/Upper/Selector_upper
onready var selector_cross = $AttackPanel/Actions/Cross/Selector_cross
var current_selection = 0 
var flag = Resources.flag_figth
var stress = Resources.stress

# Called when the node enters the scene tree for the first time.
func _ready():
	if flag:
		enemy = load("res://clock.tres")
		State.current_health = 100
		State.max_health = 100
		State.damage = 10
		$ActionsPanel/Actions/Run.text = "Calm"
	$Label2.visible = flag
	$ProgressBar2.visible = flag
	$ProgressBar2.value = stress
	set_current_selection(0)
	$anxiety.play()
	$AnimationPlayer.play("EnemyMove")
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	$EnemyContainer/TextureRect.texture = enemy.texture

	current_player_health = State.current_health
	current_enemy_health = enemy.health

	$TextBox.hide()
	$ActionsPanel.hide()
	$AttackPanel.hide()
	display_text("A wild %s appears" % enemy.name)
	yield(self, "textbox_closed")
	$ActionsPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]

func _input(event):
	if (Input.is_action_just_released("ui_accept") or Input.is_mouse_button_pressed(BUTTON_LEFT)) and $TextBox.visible == true:
		$TextBox.hide()
		emit_signal("textbox_closed")
	elif Input.is_action_just_released("ui_accept") and $TextBox.visible == false:
		handle_selection(current_selection)
		current_selection = 0
		set_current_selection(current_selection)
	if Input.is_action_just_pressed("ui_right") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	if Input.is_action_just_pressed("ui_left") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)

func display_text(text):
	$ActionsPanel.hide()
	$AttackPanel.hide()
	$TextBox.show()
	$TextBox/Label.text = text

func enemy_turn():
	var random_number = rng.randi_range(1, 100)
	if stress == 0 && flag:
		display_text("You calmed down enough to realize it wasn't real")
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.25), "timeout")
		get_tree().change_scene("res://SecondPart.tscn")
	elif current_enemy_health == 0:
		Resources.stress -= 10
		display_text("You defeated the clock")
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.25), "timeout")
		get_tree().change_scene("res://SecondPart.tscn")
	else:
		display_text("%s attacks you with its mind" % enemy.name)
		yield(self, "textbox_closed")
		
		if is_defending :
			if  random_number <= stress && flag:
					display_text("Due to the stress you couldn't defend")
					yield(self, "textbox_closed")
					enemy_atack()
			else:
				is_defending = false
				defense_duration = 1
				display_text("You successfully defended.")
				yield(self, "textbox_closed")
		else:
			enemy_atack()
			
			if current_player_health == 0 && !flag:
				display_text("YOU DIED?????")
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.25), "timeout")
				get_tree().change_scene("res://Tutorial.tscn")
			elif current_player_health == 0 && flag:
				display_text("YOU DIED. TRY AGAIN.")
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.25), "timeout")
				get_tree().change_scene("res://Main.tscn")
		
		$ActionsPanel.show()

func enemy_atack():
	var damage_multiplier = 1.0 - (defense_duration * 0.5)
	var damage = enemy.damage * damage_multiplier
	current_player_health = max(0, current_player_health - damage)
	set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
	$AnimationPlayer.play("enemy_damaged")
	$AnimationPlayer.play("EnemyMove")
	display_text("%s dealt %.0f damage." % [enemy.name, damage])
	
	if defense_duration == 1:
		defense_duration = 0
	
	yield(self, "textbox_closed")
func _on_Run_pressed():
	if flag:
		display_text("You calm yourself down a little.")
		stress -= 10
		Resources.stress = stress
		$ProgressBar2.value = stress
		defense_duration = 1
		yield(self, "textbox_closed")
	else:
		display_text("YOU CAN'T RUN.")
		yield(self, "textbox_closed")
	
	enemy_turn()

func _on_Attack_pressed():
	$ActionsPanel.hide()
	$AttackPanel.show()

func _on_Defend_pressed():
	is_defending = true
	
	display_text("You prepare to defend.")
	yield(self, "textbox_closed")
	
	yield(get_tree().create_timer(0.25), "timeout")
	
	enemy_turn()

func _on_Hook_pressed():
	display_text("You try to hit it with a hook.")
	yield(self, "textbox_closed")
	
	var damage_multiplier = 1.0 - (stress / 100)
	var damage = State.damage * damage_multiplier
	
	current_enemy_health = max(0, current_enemy_health - damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damaged")
	yield($AnimationPlayer, "animation_finished")
	
	display_text("You dealt %.0f damage." % damage)
	yield(self, "textbox_closed")
	
	$AnimationPlayer.play("EnemyMove")
	enemy_turn()

func _on_Upper_pressed():
	display_text("You try to hit it with an uppercut.")
	yield(self, "textbox_closed")
	
	var damage_multiplier = 1.0 - (stress / 100)
	var damage = State.damage * 1.5 * damage_multiplier
	
	current_enemy_health = max(0, current_enemy_health - damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damaged")
	yield($AnimationPlayer, "animation_finished")
	
	display_text("You dealt %.0f damage." % damage)
	yield(self, "textbox_closed")
	
	$AnimationPlayer.play("EnemyMove")
	enemy_turn()

func _on_Cross_pressed():
	display_text("You try to hit it with your fist.")
	yield(self, "textbox_closed")
	
	var damage_multiplier = 1.0 - (stress / 100)
	var damage = State.damage * damage_multiplier
	
	current_enemy_health = max(0, current_enemy_health - damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damaged")
	yield($AnimationPlayer, "animation_finished")
	
	display_text("You dealt %.0f damage." % damage)
	yield(self, "textbox_closed")
	
	$AnimationPlayer.play("EnemyMove")
	enemy_turn()

func set_current_selection(_current_selection):
	selector_attack.visible = false
	selector_defend.visible = false
	selector_run.visible = false
	selector_hook.visible = false
	selector_upper.visible = false 
	selector_cross.visible = false
	
	if _current_selection == 0:
		selector_attack.visible = true
		selector_hook.visible = true
	elif _current_selection == 1:
		selector_defend.visible = true 
		selector_upper.visible = true
	elif _current_selection == 2:
		selector_run.visible = true 
		selector_cross.visible = true

func handle_selection(_current_selector):
	if $ActionsPanel.visible:
		if _current_selector == 0:
			_on_Attack_pressed()
		elif _current_selector == 1:
			_on_Defend_pressed()
		elif _current_selector == 2:
			_on_Run_pressed()
	else:
		if _current_selector == 0:
			_on_Hook_pressed()
		elif _current_selector == 1:
			_on_Upper_pressed()
		elif _current_selector == 2:
			_on_Cross_pressed()
