extends Control
export (Resource) var enemy = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal textbox_closed
var current_player_health
var current_enemy_health
var is_defending = false
# Called when the node enters the scene tree for the first time.
func _ready():

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
	display_text("A wild %s appaers" % enemy.name)
	yield(self, "textbox_closed")
	$ActionsPanel.show()

func  set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health,max_health]

func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(BUTTON_LEFT) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textbox_closed")
		
func display_text(text):
	$ActionsPanel.hide()
	$AttackPanel.hide()
	$TextBox.show()
	$TextBox/Label.text = text
	

func enemy_turn():
	display_text("%s attacks you with his mind" % enemy.name)
	yield(self, "textbox_closed")
	
	if is_defending:
		is_defending = false
		display_text("You defended succesfully")
		yield(self, "textbox_closed")
	else:
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
		
		$AnimationPlayer.play("enemy_damaged")
		$AnimationPlayer.play("EnemyMove")
		display_text("%s dealt %d damage" % [enemy.name, enemy.damage])
		yield(self, "textbox_closed")
		if current_player_health == 0:
			display_text("YOU DIED?????")
			yield(self, "textbox_closed")
			yield(get_tree().create_timer(0.25), "timeout")
			get_tree().change_scene("res://Tutorial.tscn")
	$ActionsPanel.show()


func _on_Run_pressed():
	display_text("YOU CAN'T RUN")
	yield(self, "textbox_closed")
	enemy_turn()
	#yield(get_tree().create_timer(0.25), "timeout")
	#get_tree().quit()


func _on_Attack_pressed():
	$ActionsPanel.hide()
	$AttackPanel.show()



func _on_Defend_pressed():
	is_defending = true
	
	display_text("You prepare for an attack")
	yield(self, "textbox_closed")
	
	yield(get_tree().create_timer(0.25), "timeout")
	enemy_turn()


func _on_Hook_pressed():
	display_text("You try to hit it with a hook")
	yield(self, "textbox_closed")
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damaged")
	yield($AnimationPlayer, "animation_finished")
	
	display_text("You dealt %d damage" % State.damage)
	yield(self, "textbox_closed")
	
	
	$AnimationPlayer.play("EnemyMove")
	enemy_turn()


func _on_Upper_pressed():
	display_text("You try to hit it with an upper cut")
	yield(self, "textbox_closed")
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damaged")
	yield($AnimationPlayer, "animation_finished")
	
	display_text("You dealt %d damage" % State.damage)
	yield(self, "textbox_closed")
	
	
	$AnimationPlayer.play("EnemyMove")
	enemy_turn()


func _on_Cross_pressed():
	display_text("You try to hit it with your fist")
	yield(self, "textbox_closed")
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damaged")
	yield($AnimationPlayer, "animation_finished")
	
	display_text("You dealt %d damage" % State.damage)
	yield(self, "textbox_closed")
	
	
	$AnimationPlayer.play("EnemyMove")
	enemy_turn()
