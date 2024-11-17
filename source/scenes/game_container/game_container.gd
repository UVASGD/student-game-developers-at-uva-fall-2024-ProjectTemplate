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
@onready var credits : PackedScene = preload("res://source/scenes/menus/credits.tscn")
@onready var instructions : PackedScene = preload("res://source/scenes/menus/instructions.tscn")
@onready var character_select : PackedScene = preload("res://source/scenes/menus/character_select.tscn")
@onready var pre_game_cut_scene : PackedScene = preload("res://source/scenes/cut_scenes/pre_game_cut_scene.tscn")
@onready var shop : PackedScene = preload("res://source/scenes/stages/shop.tscn")
@onready var game_over : PackedScene = preload("res://source/scenes/menus/game_over.tscn")
@onready var stage : PackedScene = preload("res://source/scenes/stages/stage_template.tscn")

@onready var scene_dict = {
	"MainMenu" : main_menu,
	"Credits" : credits,
	"Instructions" : instructions,
	"CharacterSelect" : character_select,
	"PreGameCutScene" : pre_game_cut_scene,
	"Shop" : shop,
	"GameOver" : game_over,
	"Stage" : stage
}

#Scoring
var player_scores : Array[int] = [0,0,0,0]
var winning_score : int = 5

#### METHODS ####

func _ready():
	GAME_CONTAINER = self
	switch_to_scene("MainMenu")

func _process(_elta):
	#quit if Q pressed - DEBUG
	if Input.is_key_pressed(KEY_Q) :
		get_tree().quit()

func switch_to_scene(scene : String) :
	if ActiveSceneHolder.get_child_count() > 0:
		ActiveSceneHolder.get_child(0).queue_free()
	var s = scene_dict[scene].instantiate()
	ActiveSceneHolder.add_child(s)

func award_point_to_player(player : int) :
	player_scores[player-1] += 1
	if player_scores[player-1] > 2:
		switch_to_scene("GameOver")
