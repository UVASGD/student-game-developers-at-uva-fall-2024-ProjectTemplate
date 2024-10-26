extends Button
class_name Item_Button

var resource: Item_Res
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setItem(resource: Item_Res):
	self.resource = resource
	set_text(resource.name)
	set_button_icon(resource.sprite)
	
func setPlayer(p: Player):
	player = p
	
func _button_pressed():
	if (resource == null):
		print("This button has no resource associated with it!")
		return
	var item: Item = Item.new()
	item.item_res = resource
	
	var baseScene = get_tree().current_scene
	if (baseScene.name == "DemoRoom"):
		if (player == null):
			print("I couldn't get the Player node!")
			return
		player.pickup_item(item)
		print("Gave " + player.name + " a " + item.item_res.name)
	else:
		print("The current scene is not DemoRoom, so I can't give you items.")
