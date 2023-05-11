extends StaticBody2D

func _ready():
	$AnimationPlayer.play("glow")
func interact():
	var dialogue = get_node("Dialogue")
	if dialogue:
		dialogue.start("pelea")
 
