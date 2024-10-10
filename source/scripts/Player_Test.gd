class_name Player_Test
extends Node

#this is just a test repleca of the player
@export var items: Array[Resource]


var damage :int = 0
var health :int = 0
signal onAttack(player)
#more signals to tell items when to trigger their effects


var statusEffects : StatusEffectManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	manage_test_input()
		
func manage_test_input():
	#Press enter to get item (currently only the DmgBuffItem)
	if Input.is_action_just_pressed("1"):
		print("Gave Item " + str(items[0].resource_path))
		get_item(items[0])
	if Input.is_action_just_pressed("2"):
		print("Gave Item " + str(items[1].resource_path))
		get_item(items[1])
	#press left mouse to "fire"
	if Input.is_action_just_pressed("mouse_0"):
		print("Just Fired")
		onAttack.emit(self)
	#press right mouse to check damage stat
	if Input.is_action_just_pressed("mouse_1"):
		print("damage is " + str(damage))

func get_item(item : Resource):
	damage += item.damage
	health += item.health
	onAttack.connect(Callable(ItemAdvancedFunctions.Item_Advanced_Functions,item.onFireFunctions))
	
func hit_object(ps: Player_Test):
	pass
func add_status_effect(effect : StatusEffect):
	pass
