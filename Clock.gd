extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flag = Resources.flag_figth
var flago_clock = Resources.flag_clock

func _ready():
	if flago_clock : 
		get_node("Sprite").modulate = Color(1,1,1)
	else: 
		$AnimationPlayer.play("glow")

func interact():
	var stress = get_parent().get_node("Player/ProgressBar").value
	stress += 90
	get_parent().get_node("Player/ProgressBar").value = stress
	Resources.stress= stress
	var dialogue = get_node("Dialogue")
	if dialogue:
		dialogue.start("clock")
