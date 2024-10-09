extends Control
class_name Input_Controls

@onready var label = $VBoxContainer/HBoxContainer/Label as Label
@onready var button = $VBoxContainer/HBoxContainer/Button as Button

@onready var player_num = get_meta("player_num")
@onready var input_type = get_meta("input_type")

func _ready() -> void:
	set_process_unhandled_key_input(false)

func _process(delta) -> void:
	input_type = get_meta("input_type")
	button.text = get_meta("input_type")

func _on_button_pressed() -> void:
	if input_type == "Keyboard":
		set_meta("input_type", "Controller")
	else:
		set_meta("input_type", "Keyboard")
