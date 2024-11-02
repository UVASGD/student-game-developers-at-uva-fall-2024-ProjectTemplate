extends CharacterBody2D

class_name Player

var Speed := 0.0
var movement := Vector2.ZERO

var TOP_SPEED_FACTOR := 15.0
var ACCELERATION := 15.0
var DECELERATION := 15.0
var dash_timer := Timer.new()
var dash_cooldown := Timer.new()
var dash: bool

func _ready() -> void:
	pass

func _process(delta) -> void:
	var movement2 = Vector2.ZERO
	if Input.is_action_pressed('Left'):
		movement2.x -= 1
		print("Moving left")
	if Input.is_action_pressed('Right'):
		movement2.x += 1
		print("Moving right")
	if Input.is_action_pressed('Up'):
		movement2.y -= 1
		print("Moving up")
	if Input.is_action_pressed('Down'):
		movement2.y += 1
		print("Moving down")
	if Input.is_action_just_pressed('Dash') and dash_cooldown.time_left == 0:
		#dash time
		Speed = 500
		dash_timer.wait_time = 0.5
		dash_timer.start()
		dash_cooldown.wait_time = 1
		dash_cooldown.start()
		print("Dashing")
	movement = movement2.normalized()
	print("Movement vector:", movement2)
	# Apply movement logic here
	handle_move()

func handle_move() -> void:
	var player_num = str(get_meta("player_num"))
	movement = Vector2(Input.get_axis("Left" + player_num, "Right" + player_num), Input.get_axis("Up" + player_num, "Down" + player_num)).normalized()
	
	if movement.length():
		Speed = move_toward(Speed, stats.topSpeed * TOP_SPEED_FACTOR, ACCELERATION)
	
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
