extends KinematicBody2D

var speed = 100
var animation = ""
onready var animations = $AnimatedSprite
onready var sigth = $RayCast2D
func _ready():
	$ambient.play()

func _physics_process(delta):
	var movement = Vector2()
	var flip = true
	
	if sigth.is_colliding() && Input.is_action_just_pressed("ui_accept"):
		var actual_object = sigth.get_collider()
		actual_object.interact()
	
	if Input.is_action_pressed("ui_up"):
		movement.y -= speed
		sigth.set_cast_to(Vector2(0,-50))
		animation = "up"
	elif sigth.get_cast_to() == Vector2(0,-50):
		animation ="idle_up"
	if Input.is_action_pressed("ui_down"):
		movement.y += speed
		sigth.set_cast_to(Vector2(0,50))
		animation = "down"
	elif sigth.get_cast_to() == Vector2(0,50):
		animation ="idle_down"
	if Input.is_action_pressed("ui_left"):
		movement.x -= speed
		sigth.set_cast_to(Vector2(-50,0))
		animation = "side"
		flip=false
	elif sigth.get_cast_to() == Vector2(-50,0):
		animation ="idle_side"
		flip=false
	if Input.is_action_pressed("ui_right"):
		movement.x += speed
		sigth.set_cast_to(Vector2(50,0))
		animation = "side"
		flip = true
	elif sigth.get_cast_to() == Vector2(50,0):
		animation ="idle_side"
		flip=true

	movement = movement.normalized() * speed
	move_and_slide(movement)
	animations.play(animation) 
	animations.flip_h = flip
