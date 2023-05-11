extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$heavy.play()
	var dialogue = get_node("Dialogue")
	if dialogue:
		dialogue.start("tutorial")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
