extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var flag = Resources.flag_figth
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interact():
	if flag:
		var stress = get_parent().get_node("YSort/Player/ProgressBar").value
		stress += -5
		get_parent().get_node("YSort/Player/ProgressBar").value = stress
		Resources.stress= stress
		var dialogue = get_node("Dialogue")
		if dialogue:
			dialogue.start("calm_book")
