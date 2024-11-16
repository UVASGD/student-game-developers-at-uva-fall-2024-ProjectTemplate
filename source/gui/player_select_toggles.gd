extends Control
class_name PlayerSelectToggles

@onready var sprite : Object = $Sprite2D
@onready var value : int = 1
@onready var pumpkin_texture = null
@onready var frankenstein_texture = null
@onready var witch_texture = null
@onready var ghost_texture = null
@onready var sprite_textures = [pumpkin_texture, frankenstein_texture, witch_texture, ghost_texture]

func _physics_process(delta: float) -> void:
	#sprite.texture = sprite_textures[value]
	pass

func _on_left_button_pressed() -> void:
	value -= 1
	if value < 1:
		value = 4

func _on_right_button_pressed() -> void:
	value += 1
	if value > 4:
		value = 1
