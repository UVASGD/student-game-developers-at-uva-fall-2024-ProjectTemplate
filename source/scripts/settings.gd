extends Control

@onready var vbox = $TabContainer/Controls/MarginContainer/ScrollContainer/VBoxContainer

var deviceIDs = []
var old_connected_joypads

func _ready():
	for node in vbox.get_children():
		if node.has_meta("player_num"): deviceIDs.append(node.get_meta("device_id"))
		old_connected_joypads = Input.get_connected_joypads()

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
	
	#if Input.get_connected_joypads() != old_connected_joypads:
		#for i in range(4):
			#if !(i in deviceIDs) && (i+1) in deviceIDs:
				#deviceIDs[deviceIDs.find(i+1)] = i
		#old_connected_joypads = Input.get_connected_joypads()
	
	for node in vbox.get_children():
		if node.has_meta("player_num"):
			node.set_meta("device_id", deviceIDs[node.get_meta("player_num") - 1])
