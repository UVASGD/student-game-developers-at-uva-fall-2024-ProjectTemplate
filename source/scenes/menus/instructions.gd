extends Node2D

func _on_back_button_pressed() -> void:
	get_parent().get_parent().switch_to_scene("MainMenu")
