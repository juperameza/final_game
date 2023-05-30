extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var start_selector = $start_selector
onready var exit_selector = $exit_selector
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if (Input.is_action_just_pressed("ui_down")):
		start_selector.hide()
		exit_selector.show()
	if (Input.is_action_just_pressed("ui_up")):
		start_selector.show()
		exit_selector.hide()
	if (Input.is_action_just_pressed("ui_accept") && start_selector.visible):
		get_tree().change_scene("res://Main.tscn")
	if (Input.is_action_just_pressed("ui_accept") && exit_selector.visible):
		get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
