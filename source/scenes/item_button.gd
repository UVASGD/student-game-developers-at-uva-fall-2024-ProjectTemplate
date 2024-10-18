extends Button
class_name Item_Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setItem(resource: Item_Res):
	set_text(resource.name)
	set_button_icon(resource.sprite)
	
func _button_pressed():
	print("Hello world!")
	
