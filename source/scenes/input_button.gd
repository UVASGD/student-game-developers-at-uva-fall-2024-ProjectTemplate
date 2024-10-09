extends Control
class_name Input_Button

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@onready var player_num = get_parent().get_parent().get_meta("player_num")
@onready var input_type = get_parent().get_parent().get_meta("input_type")
@onready var waiting = false
@onready var action

var inputK
var inputJ

func _ready() -> void:
	set_process_unhandled_key_input(false)
	label.text = get_meta("input_name")
	action = label.text + "%s" % player_num
	
	for input in InputMap.action_get_events(action):
		if input is InputEventKey: inputK = input
		else: inputJ = input
	
	InputMap.action_erase_events(action)
	if input_type == "Keyboard": InputMap.action_add_event(action, inputK)
	else: InputMap.action_add_event(action, inputJ)

func _process(delta) -> void:
	var cur_input_type = get_parent().get_parent().get_meta("input_type")
	if cur_input_type != input_type:
		InputMap.action_erase_events(action)
		if cur_input_type == "Keyboard": InputMap.action_add_event(action, inputK)
		else: InputMap.action_add_event(action, inputJ)
		input_type = cur_input_type
	
	if waiting == true: button.text = "Press Any Key"
	if waiting == false:
		
		for input in InputMap.action_get_events(action):
			if input is InputEventKey: inputK = input
			else: inputJ = input
		
		if input_type == "Keyboard":
			if inputK: button.text = "%s" % OS.get_keycode_string(inputK.physical_keycode)
			else: button.text = "---"
		else: button.text = "wip"


func _on_button_pressed() -> void:
	if input_type == "Keyboard":
		waiting = true
		set_process_unhandled_key_input(true)

func _input(event):
	if waiting == true && input_type == "Keyboard" && event is InputEventKey:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		inputK = event
		waiting = false
