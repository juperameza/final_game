extends CanvasLayer
export (String, FILE, "*.json") var d_file
var dialogue = []
var current_dialogue = 0
var d_active = false
var d_name = ""
func _ready():
	$NinePatchRect.visible = false
	
func start(name):
	if d_active: 
		return 
	d_active = true
	d_name = name
	$NinePatchRect.visible = true
	
	dialogue = load_dialogue()
	dialogue = dialogue[name]
	current_dialogue = -1
	next_script()
func load_dialogue():
	var file = File.new()
	if file.file_exists(d_file):
		file.open(d_file, file.READ)
		return parse_json(file.get_as_text())

func _input(event):
	if not d_active:
		return
		
	if event.is_action_pressed("ui_select"):
		next_script()

func next_script():
	current_dialogue +=1
	if current_dialogue >= len(dialogue):
		$Timer.start()
		$NinePatchRect.visible = false
		if(d_name == "pelea"):
			get_tree().change_scene("res://Figth.tscn")
		elif(d_name=="tutorial"):
			yield(get_tree().create_timer(0.25), "timeout")
			get_tree().quit()
		return
	$NinePatchRect/Name.text=dialogue[current_dialogue]["name"]
	$NinePatchRect/Chat.text=dialogue[current_dialogue]["text"]	
	if dialogue[current_dialogue]["text"] == "Tranquilo, respira profundamente, no te asustes, no te va a pasar nada":
		$deep.play()
	else:
		$deep.stop()


func _on_Timer_timeout():
	d_active = false
