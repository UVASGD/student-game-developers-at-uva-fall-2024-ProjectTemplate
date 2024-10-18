extends CharacterBody2D

class_name Player

var Speed := 0.0
var movement := Vector2.ZERO


const TOP_SPEED_FACTOR := 15.0
const ACCELERATION := 15.0

# Stats handling
@onready var stats_and_item_handler : Node2D = $StatsAndItemHandler
@export var base_stats : Item_Res
var stats : Stats = Stats.new()  # Initialize the stats
var attack_area_player : Area2D = Area2D.new()
func _ready() -> void:
	pass

func _process(delta) -> void:
	handle_move()

func handle_move() -> void:
	movement = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down")).normalized()
	if movement.length():
		Speed = move_toward(Speed, stats.topSpeed * TOP_SPEED_FACTOR, ACCELERATION)
	
	if movement.x:
		velocity.x = movement.x * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	
	if movement.y:
		velocity.y = movement.y * Speed
	else:
		velocity.y = move_toward(velocity.y, 0, ACCELERATION)
	
	move_and_slide()
# Item and stats handling
func pickup_item(item : Item):
	stats_and_item_handler.handle_pickup(item)
	pass

func drop_item(item : Item, destroy : bool):
	stats_and_item_handler.handle_drop(item, destroy)
	pass
# this code is an example, its not used
func apply_damage(damage):
	#need to implement applying damage to other player
	stats.health -= damage  # Subtract the damage from the player's health
	print("Player received " + str(damage) + " damage. Health: " + str(stats.health))

	# Check if the player is dead
	if stats.health <= 0:
		die()  # Call the die() function if health reaches zero or below

# Handle the player's death
func die() -> void:
	print("Player " + self.name + " has died. Needs to Be Overridden by child classes")
	$AnimationPlayer.play("death")
	queue_free()
