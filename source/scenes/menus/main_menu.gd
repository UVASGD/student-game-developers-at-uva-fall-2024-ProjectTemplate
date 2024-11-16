extends Node2D

func _on_play_button_pressed() -> void:
	get_parent().get_parent().switch_to_scene("PreGameCutScene")

func _on_instructions_button_pressed() -> void:
	get_parent().get_parent().switch_to_scene("Instructions")

func _on_credits_button_pressed() -> void:
	get_parent().get_parent().switch_to_scene("Credits")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
