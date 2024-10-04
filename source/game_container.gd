extends Node2D
class_name GameContainer

#easy way to access the GameContainer from other nodes
static var GAME_CONTAINER : GameContainer

#There should only ever be one active scene (menu or stage) and it will be the only child of the ActiveSceneHolder node
@onready var ActiveSceneHolder = $ActiveSceneHolder
#Other scenes should be overlay panels (UI, eg pause menu) can be put in the OverlayPanels node
@onready var OverlayPanels = $OverlayPanels
#The player nodes are instantiated in the Players node, they can be hidden and frozen when necessary
@onready var Players = $Players

#Scenes
@onready var main_menu : PackedScene = preload("res://source/scenes/menus/main_menu.tscn")
@onready var world_scene : PackedScene = preload("res://source/stages/world.tscn")
@onready var stage_template : PackedScene = preload("res://source/stages/stage_template.tscn")

#Other vars
var current_stage : int = 0


#### Methods ####

func _ready():
	RenderingServer.set_default_clear_color(Color("000000"))
	GAME_CONTAINER = self
	pass

func _process(delta):
	if Input.is_key_pressed(KEY_Q) :
		get_tree().quit()
	pass


func switch_to_stage(stage : int) :
	match stage :
		0 : switch_active_scene(stage_template)
		_ :
			print("Stage " + str(stage) + " not recognized")
			return
	current_stage = stage

func switch_to_main_menu() :
	switch_active_scene(main_menu)


#### Resource Methods ####

func switch_active_scene(scene : PackedScene) :
	ActiveSceneHolder.get_child(0).queue_free()
	var s = scene.instantiate()
	ActiveSceneHolder.add_child(s)


