extends Control

@onready var vbox = $TabContainer/Controls/MarginContainer/ScrollContainer/VBoxContainer

var deviceIDs = []

func _ready():
	for node in vbox.get_children():
		if node.has_meta("player_num"): deviceIDs.append(node.get_meta("device_id"))

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if visible: visible = false
		else: visible = true
	
	for node in vbox.get_children():
		if node.has_meta("player_num"):
			deviceIDs[node.get_meta("player_num") - 1] = node.get_meta("device_id")
	
	if deviceIDs.has(4):
		for i in range(4):
			if Input.get_connected_joypads().has(i) && !deviceIDs.has(i):
				deviceIDs[deviceIDs.find(4)] = i
				break
	
	for node in vbox.get_children():
		if node.has_meta("player_num"):
			node.set_meta("device_id", deviceIDs[node.get_meta("player_num") - 1])
