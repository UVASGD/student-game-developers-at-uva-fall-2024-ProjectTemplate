extends CharacterBody2D

class_name Player

var player_num
var Speed := 0.0
var movement := Vector2.ZERO
var last_movement := Vector2(0,1)

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
var sprite_list: Array = [preload("res://source/items/Item_Resources/BakingSoda.tres"), preload("res://source/items/Item_Resources/BaseballBat.tres"), 
preload("res://source/items/Item_Resources/BaseballCap.tres"), preload("res://source/items/Item_Resources/BoxingGloves.tres")]

#keep doing for each type of animation
var run_animations: Array = [null, null, null, null]
var hit_animations: Array = [null, null, null, null]

#this is just a test repleca of the player
@export var items: Array[Resource]

var maxHealth : int = 12
var damage : int = 0
var topSpeed : int = 10

enum Character {
	WITCH,
	FRANKENSTEIN,
	GHOST,
	PUMPKIN
}
@export var character = Character.WITCH

#Enemy attack instances
const Projectile_Scene := preload("res://source/scenes/projectile.tscn")
const Frank_Attack_Scene := preload("res://source/scenes/frankenstein_attack.tscn")
const Pumpkin_Attack_Scene := preload("res://source/scenes/pumpkin_attack.tscn")
const Ghost_Attack_Scene := preload("res://source/scenes/ghost_attack.tscn")


var health :int = 0
#signal onAttack(player)#This signals will emit every attack
#signal onGetHit(player)#This signal will emit every time the player gets hit
#more signals to tell items when to trigger their effects

var onAttackFunctions : Array[Callable]
var onFireFunctions : Array[Callable]
var onHitFunctions : Array[Callable]
var onGetHitFunctions : Array[Callable]#When this one is called. should also call with the object hit as a parameter

var direction: Vector2 = Vector2(0, 1)
var model: String = "ghost_kid"
#@onready var statusEffects : StatusEffectManager = $StatusEffectManager
@onready var sprite : AnimatedSprite2D = $PlayerSprite/Body

func _ready() -> void:
	player_num = str(get_meta("player_num"))
	pass

func _process(delta: float) -> void:
	handle_move()
	if Input.is_action_just_pressed("Attack" + player_num): handle_attack()
	if(movement != Vector2.ZERO): 
		last_movement = movement

func handle_move() -> void:
	movement = Vector2(Input.get_axis("Left" + player_num, "Right" + player_num), Input.get_axis("Up" + player_num, "Down" + player_num)).normalized()
	
	playWalkOrIdleAnimation(velocity)
	if not velocity.is_zero_approx(): direction = velocity
	
	if movement.length() :
		Speed = move_toward(Speed, topSpeed * TOP_SPEED_FACTOR, ACCELERATION)
	
	#movement = Vector2(Input.get_axis("Left1", "Right1"), Input.get_axis("Up1", "Down1")).normalized()
	#TOP_SPEED_FACTOR = 15
	#ACCELERATION = 15
	#DECELERATION = 15
	#if not dash and Input.is_action_just_pressed("Dash"):
		#print("ENTERING DASH")
		#dashing()
	#if movement.length(): # stats.topSpeed = 10
		#Speed = move_toward(Speed, 10 * TOP_SPEED_FACTOR, ACCELERATION)
	#else:
		#Speed = move_toward(Speed, 0, DECELERATION) # Gradually decrease speed to zero
	
	if movement.x:
		velocity.x = movement.x * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION) # Gradually decrease horizontal velocity to zero
	
	if movement.y:
		velocity.y = movement.y * Speed
	else:
		velocity.y = move_toward(velocity.y, 0, DECELERATION) # Gradually decrease vertical velocity to zero
	
	move_and_slide() # Ensure velocity is passed to move_and_slide

func handle_attack(): #Right now, just enables, hitbox for 0.5 seconds
	match character:
		#THIS NEEDS TO BE UPDATED AFTER ATTACK SCENES MADE
		Character.WITCH:
			add_attack_instance_as_child(Projectile_Scene)
		Character.FRANKENSTEIN:
			add_attack_instance_as_child(Frank_Attack_Scene)
		Character.GHOST:
			add_attack_instance_as_child(Ghost_Attack_Scene)
		Character.PUMPKIN:
			add_attack_instance_as_child(Pumpkin_Attack_Scene)
		_:
			print("ERROR: Player not assigned character")
	
func handle_damage(attackingPlayer: CharacterBody2D) -> void:
	pass
	#UPDATE
	#Health -= attackingPlayer.get_damage()
	
	
func add_attack_instance_as_child(attack_scene: PackedScene) -> void:
	var attack_instance := attack_scene.instantiate()
	attack_instance.position = self.global_position
	attack_instance.direction = last_movement #wsdaglobal_position.direction_to(get_global_mouse_position())
	#UPDATE
	#attack_instance.set_damage(stats.attackDamage)
	attack_instance.set_attackingPlayer(self)
	add_child(attack_instance)

func getPlayerPosition() -> Vector2:
	return position
func get_damage() -> float:
	return 0.0
	#UPDATE
	#return stats.attackDamage


func get_item(item : Item):
	damage += item.damage
	health += item.health
	
	for i in range(item.FunctionTypes.size()):
		match item.functionTypes[i]:
			Item.FunctionTypes.OnStart:
				Callable(Item_Functions, item.functionNames[i]).bind(self).call()
			Item.FunctionTypes.OnFire:
				onFireFunctions.append(Callable(Item_Functions, item.functionNames[i]).bind(self))
			Item.FunctionTypes.OnHit:
				onHitFunctions.append(Callable(Item_Functions, item.functionNames[i]).bind(self))
			Item.FunctionTypes.OnGetHit:
				onGetHitFunctions.append(Callable(Item_Functions, item.functionNames[i]).bind(self))

func hit_object(ps: Player_Test):
	pass

func change_health(deltaHealth : float):
	print("Player took " + str(-deltaHealth) + " damage") 
	health += deltaHealth
	#onGetHit.emit(self);
	call_functions(onGetHitFunctions)
	if(health < 0):
		print("You died fool")

func call_functions(arr : Array[Callable]):
	for i in arr:
		i.call()
		
func playWalkOrIdleAnimation(velocity: Vector2):
	if velocity.is_zero_approx():
		sprite.play(model + "_idle_" + getDirectionWord(direction))
	else:
		sprite.play(model + "_walk_" + getDirectionWord(velocity))
		
func getDirectionWord(direction: Vector2):
	if direction.is_zero_approx(): return "down"
	if abs(direction.x) >= abs(direction.y - 0.1):
		if direction.x >= 0: return "right"
		elif direction.x < 0: return "left"
	else:
		if direction.y >= 0: return "down"
		elif direction.y < 0: return "up"

func changeModel(newModel: String):
	model = newModel
	

#SPLIT

#### item and stats handling (everything else is implemented in the stats_and_item_handler)
#@onready var stats_and_item_handler: Node2D = $StatsAndItemHandler
#@export var base_stats: Item_Res
#var stats: Stats = Stats.new()
#
#func pickup_item(item: Item):
	#stats_and_item_handler.handle_pickup(item)
	#pass
#
#func drop_item(item: Item, destroy: bool):
	##if destroy is false, you should be reparenting the item
	#stats_and_item_handler.handle_drop(item, destroy)
	#pass
## this code is an example, its not used
#func apply_damage(damage):
	##need to implement applying damage to other player
	#stats.health -= damage # Subtract the damage from the player's health
	#print("Player received " + str(damage) + " damage. Health: " + str(stats.health))
	#play_hit_animation()
	## Check if the player is dead
	#if stats.health <= 0:
		#die() # Call the die() function if health reaches zero or below
#
## Handle the player's death
#func die() -> void:
	#print("Player " + self.name + " has died. Needs to Be Overridden by child classes")
	#$AnimationPlayer.play("death")
	#queue_free()
#func play_hit_animation():
	##implement this method in child classes
	#print("Player was Hit.")
	#pass
	#
#func _input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#attack() # Call the attack function on left mouse click
#func attack():
	##if can_attack:
	##	var attack_cooldown = stats.attackSpeed
	##	can_attack = false
	##	await get_tree().create_timer(20).timeout
	##	can_attack = true
	##add this in child Classes
	#print("Player Attacked!")
	#pass
#func dashing():
	## dash values, please
	#dash = true
	#Speed = 750
	#await get_tree().create_timer(2).timeout
	#dash = false
	##Speed = move_toward(Speed, 0, DECELERATION)
