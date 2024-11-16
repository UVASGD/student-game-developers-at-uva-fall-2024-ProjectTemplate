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
#@onready var world : PackedScene = preload("res://source/stages/world.tscn")
@onready var credits : PackedScene = preload("res://source/scenes/menus/credits.tscn")
@onready var instructions : PackedScene = preload("res://source/scenes/menus/instructions.tscn")
@onready var character_select : PackedScene = preload("res://source/scenes/menus/character_select.tscn")
@onready var pre_game_cut_scene : PackedScene = preload("res://source/scenes/cut_scenes/pre_game_cut_scene.tscn")
@onready var shop : PackedScene = preload("res://source/scenes/stages/shop.tscn")
@onready var game_over : PackedScene = preload("res://source/scenes/menus/game_over.tscn")
#@onready var stage1 : PackedScene = preload("res://source/stages/stage_template.tscn")

@onready var scene_dict = {
	"MainMenu" : main_menu,
	#"World" : world,
	"Credits" : credits,
	"Instructions" : instructions,
	"CharacterSelect" : character_select,
	"PreGameCutScene" : pre_game_cut_scene,
	"Shop" : shop,
	"GameOver" : game_over
	#"Stage1" : stage1
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

func switch_to_scene(scene_name : String):
	switch_active_scene(scene_dict[scene_name])
	#below: debug code, above: actual code
	#if scene == shop:
		#award_point_to_player(1)
		#print("POINTS AWARDED FOR DEBUG PURPOSES")
		#if player_scores[0] == winning_score :
			#switch_active_scene(game_over)
			#player_scores = [0,0,0,0]
		#else :
			#switch_active_scene(shop)
	#else :
		#switch_active_scene(scene)

func switch_active_scene(scene : PackedScene) :
	if ActiveSceneHolder.get_child_count() > 0:
		ActiveSceneHolder.get_child(0).queue_free()
	var s = scene.instantiate()
	ActiveSceneHolder.add_child(s)

#func get_random_stage() -> PackedScene:
	#var r = int(randf() * 4)
	#if r == 0 : return stage1
	#if r == 1 : return stage2
	#if r == 2 : return stage3
	#else : return stage4

func award_point_to_player(player : int) :
	player_scores[player-1] += 1

func award_points_to_player(player : int, points : int) :
	player_scores[player-1] += points

func award_points_to_players(points : Array[int]) :
	for i in player_scores.size() :
		player_scores[i] += points[i]
