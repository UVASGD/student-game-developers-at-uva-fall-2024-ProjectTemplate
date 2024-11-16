extends CharacterBody2D

class_name Player

var Speed := 0.0
var movement := Vector2.ZERO

var TOP_SPEED_FACTOR := 15.0
var ACCELERATION := 15.0
var DECELERATION := 15.0
var dash: bool
@export var base_attackDamage: float
@export var base_attackSpeed: float
@export var base_maxHealth : float
@export var base_speed : float
@export var base_cooldownReduction : float
@export var base_tenacity : float
@export var base_luck : float
var item_attackDamage: float
var item_attackSpeed: float
var item_maxHealth : float
var item_speed : float
var item_cooldownReduction : float
var item_tenacity : float
var item_luck : float
#These are placeholder sprites for each character
var sprite_list: Array = [preload("res://source/Items_Final/Item_Resources/BakingSoda.tres"), preload("res://source/Items_Final/Item_Resources/BaseballBat.tres"), 
preload("res://source/Items_Final/Item_Resources/BaseballCap.tres"), preload("res://source/Items_Final/Item_Resources/BoxingGloves.tres")]

#keep doing for each type of animation
var run_animations: Array = [null, null, null, null]
var hit_animations: Array = [null, null, null, null]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	handle_move()

func handle_move() -> void:
	#var player_num = str(get_meta("player_num"))
	movement = Vector2(Input.get_axis("Left1", "Right1"), Input.get_axis("Up1", "Down1")).normalized()
	TOP_SPEED_FACTOR = 15
	ACCELERATION = 15
	DECELERATION = 15
	if not dash and Input.is_action_just_pressed("Dash"):
		print("ENTERING DASH")
		dashing()
	if movement.length(): # stats.topSpeed = 10
		Speed = move_toward(Speed, 10 * TOP_SPEED_FACTOR, ACCELERATION)
	else:
		Speed = move_toward(Speed, 0, DECELERATION) # Gradually decrease speed to zero
	
	if movement.x:
		velocity.x = movement.x * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION) # Gradually decrease horizontal velocity to zero
	
	if movement.y:
		velocity.y = movement.y * Speed
	else:
		velocity.y = move_toward(velocity.y, 0, DECELERATION) # Gradually decrease vertical velocity to zero
	
	move_and_slide() # Ensure velocity is passed to move_and_slide

#### item and stats handling (everything else is implemented in the stats_and_item_handler)
@onready var stats_and_item_handler: Node2D = $StatsAndItemHandler
@export var base_stats: Item_Res
var stats: Stats = Stats.new()

func pickup_item(item: Item):
	stats_and_item_handler.handle_pickup(item)
	pass

func drop_item(item: Item, destroy: bool):
	#if destroy is false, you should be reparenting the item
	stats_and_item_handler.handle_drop(item, destroy)
	pass
# this code is an example, its not used
func apply_damage(damage):
	#need to implement applying damage to other player
	stats.health -= damage # Subtract the damage from the player's health
	print("Player received " + str(damage) + " damage. Health: " + str(stats.health))
	play_hit_animation()
	# Check if the player is dead
	if stats.health <= 0:
		die() # Call the die() function if health reaches zero or below

# Handle the player's death
func die() -> void:
	print("Player " + self.name + " has died. Needs to Be Overridden by child classes")
	$AnimationPlayer.play("death")
	queue_free()
func play_hit_animation():
	#implement this method in child classes
	print("Player was Hit.")
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			attack() # Call the attack function on left mouse click
func attack():
	#if can_attack:
	#	var attack_cooldown = stats.attackSpeed
	#	can_attack = false
	#	await get_tree().create_timer(20).timeout
	#	can_attack = true
	#add this in child Classes
	print("Player Attacked!")
	pass
func dashing():
	# dash values, please
	dash = true
	Speed = 750
	await get_tree().create_timer(2).timeout
	dash = false
	#Speed = move_toward(Speed, 0, DECELERATION)
