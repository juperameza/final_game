extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flag = Resources.flag_figth 

# Called when the node enters the scene tree for the first time.
func _ready():
	if flag || get_parent().name == "SecondPart": 
		get_node("CollisionShape2D").disabled = false
	if get_parent().name == "SecondPart":
		$Sprite.set_region_rect(Rect2(60,0,50,90))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Stairs_body_entered(body):
	if body.name == "Player" && get_parent().name == "Main":
		get_tree().change_scene("res://SecondPart.tscn")
	else: 
		get_tree().change_scene("res://Main.tscn")
