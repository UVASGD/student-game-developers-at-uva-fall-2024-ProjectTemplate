extends Control

func _process(delta):
	if Input.is_action_just_pressed("esc") :
		if(visible): visible = false
		else: visible = true
