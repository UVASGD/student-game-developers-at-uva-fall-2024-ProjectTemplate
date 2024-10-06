extends CharacterBody2D

class_name Player

var Speed := 0.0
var movement := Vector2.ZERO

const TOP_SPEED_FACTOR := 15.0
const ACCELERATION := 15.0

enum PlayerType { FRANKENSTEIN, PUMPKIN, WITCH, GHOST, MPUMPKIN, MFRANKENSTEIN, MWITCH, MGHOST}
@export var type: PlayerType

@onready var sprite = $Sprite2D

const sprite_settings = [{"texture": "res://source/assets/character/frankenstein/frankenstein_idle/Frankenstein.png",
						"color": Color8(255, 254, 176, 255), "size": 1},
						{"texture": "res://objects/lights/candelabra.png", 
						"color": Color8(255, 100, 100, 255), "size": 1.5},
						{"texture": "res://objects/lights/lantern.png", 
						"color": Color8(100, 255, 100, 255), "size": 2}]

func _ready() -> void:
	sprite.texture = load(sprite_settings[type]["texture"])


func _process(delta) -> void:
	handle_move()


func handle_move() -> void:
	movement = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down")).normalized()
	if movement.length() :
		Speed = move_toward(Speed, stats.topSpeed * TOP_SPEED_FACTOR, ACCELERATION)
	
	if movement.x :
		velocity.x = movement.x * Speed
	else :
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	
	if movement.y :
		velocity.y = movement.y * Speed
	else :
		velocity.y = move_toward(velocity.y, 0, ACCELERATION)
	
	move_and_slide()

#### item and stats handling (everything else is implemented in the stats_and_item_handler)
@onready var stats_and_item_handler : Node2D = $StatsAndItemHandler
@export var base_stats : Item_Res
var stats : Stats = Stats.new()

func pickup_item(item : Item) :
	stats_and_item_handler.handle_pickup(item)
	pass

func drop_item(item : Item, destroy : bool) :
	#if destroy is false, you should be reparenting the item
	stats_and_item_handler.handle_drop(item, destroy)
	pass
