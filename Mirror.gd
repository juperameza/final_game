extends StaticBody2D
var flag = Resources.flag_figth
var stress = Resources.stress
func _ready():
	if flag : 
		get_node("Sprite").modulate = Color(1,1,1)
	else: 
		$AnimationPlayer.play("glow")
func interact():
	if !flag:
		var dialogue = get_node("Dialogue")
		if dialogue:
			dialogue.start("pelea")
	else: 
		var stress = get_parent().get_node("YSort/Player/ProgressBar").value
		stress += 5
		get_parent().get_node("YSort/Player/ProgressBar").value = stress
		Resources.stress= stress
		var dialogue = get_node("Dialogue")
		if dialogue:
			dialogue.start("ansiedad_pelea")
