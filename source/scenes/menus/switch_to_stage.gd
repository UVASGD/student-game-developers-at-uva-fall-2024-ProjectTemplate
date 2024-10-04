extends Control

@export var button : Button
@export var stage_to_switch_to : int

func _ready() :
	button.connect("pressed", button_pressed)

func button_pressed() :
	GameContainer.GAME_CONTAINER.switch_to_stage(stage_to_switch_to)
