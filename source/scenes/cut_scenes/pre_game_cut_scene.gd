extends Node2D

func _on_continue_button_pressed() -> void:
	get_parent().get_parent().switch_to_scene("CharacterSelect")
