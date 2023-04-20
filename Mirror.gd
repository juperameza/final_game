extends StaticBody2D

func interact():
	var dialogue = get_node("Dialogue")
	if dialogue:
		dialogue.start()
 
