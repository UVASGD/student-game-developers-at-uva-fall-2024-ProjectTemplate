extends Node2D
class_name GameContainer

@onready var WorldScene : PackedScene = preload("res://source/stages/world.tscn")

func _ready():
	RenderingServer.set_default_clear_color(Color("000000"))
	pass
