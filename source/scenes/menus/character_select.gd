extends Node2D

enum {NONE, FRANKENSTEIN, PUMPKIN, WITCH, GHOST}

@onready var test = $test
@onready var hbox_container = $HBoxContainer
@onready var player_count : int = 2
@onready var player_classes = [NONE, NONE, NONE, NONE]

func _physics_process(delta: float) -> void:
	test.text = str("Player Count: ") + str(player_count) + str(" ") + str(player_classes)

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

func _on_add_player_button_pressed() -> void:
	if player_count < 4:
		player_count += 1
