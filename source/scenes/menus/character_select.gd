extends Node2D

enum {NONE, FRANKENSTEIN, PUMPKIN, WITCH, GHOST}

@onready var player_select_toggles : PackedScene = preload("res://source/gui/player_select_toggles.tscn")
@onready var test = $test
@onready var hbox_container = $HBoxContainer
@onready var player_count : int = 2
@onready var player_classes = [NONE, NONE, NONE, NONE]
@onready var player_insts = []

func _ready():
	add_player()
	add_player()

func _physics_process(delta: float) -> void:
	test.text = str("Player Count: ") + str(player_count) + str(" ") + str(player_classes)
	match(len(player_insts) - 1):
		1:
			player_classes[0] = player_insts[0].value
			player_classes[1] = player_insts[1].value
		2:
			player_classes[0] = player_insts[0].value
			player_classes[1] = player_insts[1].value
			player_classes[2] = player_insts[2].value
		3:
			player_classes[0] = player_insts[0].value
			player_classes[1] = player_insts[1].value
			player_classes[2] = player_insts[2].value
			player_classes[3] = player_insts[3].value

func _on_start_button_pressed() -> void:
	var counter = 0
	for x in player_classes:
		if x == NONE:
			counter += 1
	if counter != 4:
		get_parent().get_parent().switch_to_scene("Stage1")

func _on_left_button_1_pressed() -> void:
	player_classes[0] -= 1
func _on_right_button_1_pressed() -> void:
	player_classes[0] += 1

func _on_remove_player_button_pressed() -> void:
	if player_count > 2:
		player_count -= 1
		remove_player()

func _on_add_player_button_pressed() -> void:
	if player_count < 4:
		player_count += 1
		add_player()

func add_player():
	var player_inst = player_select_toggles.instantiate()
	player_inst.global_position = Vector2(0,0)
	hbox_container.add_child(player_inst)
	player_insts.append(player_inst)

func remove_player():
	player_insts[player_count].queue_free()
	player_insts.remove_at(player_count)
	player_classes[player_count] = 0
