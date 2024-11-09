extends Control

@onready var vbox = $TabContainer/Controls/MarginContainer/ScrollContainer/VBoxContainer

var deviceIDs = []
var old_joypads = []

func _ready():
	for node in vbox.get_children():
		if node.has_meta("player_num"): deviceIDs.append(node.get_meta("device_id"))
	
	for joy in Input.get_connected_joypads():
		old_joypads.append(Input.get_joy_guid(joy))

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if visible:
			visible = false
			get_tree().paused = false
			if(get_node("..").has_node("ItemSelector")):
				get_node("../ItemSelector").visible = true
		else:
			visible = true
			get_tree().paused = true
			if(get_node("..").has_node("ItemSelector")):
				get_node("../ItemSelector").visible = false
	
	for node in vbox.get_children():
		if node.has_meta("player_num"):
			deviceIDs[node.get_meta("player_num") - 1] = node.get_meta("device_id")
	
	if deviceIDs.has(4):
		for i in range(4):
			if Input.get_connected_joypads().has(i) && !deviceIDs.has(i):
				deviceIDs[deviceIDs.find(4)] = i
				break
	
	var cur_joypads = []
	for joy in Input.get_connected_joypads():
		cur_joypads.append(Input.get_joy_guid(joy))
	
	if cur_joypads != old_joypads:
		for guid in old_joypads:
			if !(guid in cur_joypads):
				for i in range(4):
					if !(deviceIDs[i] in [-1,4]) && i > old_joypads.find(guid): deviceIDs[i] -= 1
				deviceIDs[old_joypads.find(guid)] = 4
		
		old_joypads = []
		for joy in Input.get_connected_joypads():
			old_joypads.append(Input.get_joy_guid(joy))
	
	for node in vbox.get_children():
		if node.has_meta("player_num"):
			node.set_meta("device_id", deviceIDs[node.get_meta("player_num") - 1])
