extends CharacterBody2D

class_name Player

var player_num
var Speed := 0.0
var movement := Vector2.ZERO
var last_movement := Vector2(0,1)

#var TOP_SPEED_FACTOR := 15.0 replaced by total_stats.speed
var ACCELERATION := 2
var DECELERATION := 2
var dash: bool
@export var base_attackDamage: float
@export var base_attackSpeed: float
@export var base_maxHealth : float
@export var base_speed : float
@export var base_cooldownReduction : float
@export var base_tenacity : float
@export var base_luck : float

var total_stats : Stats
var base_stats : Stats
var item_stats : Stats

#keep doing for each type of animation
var run_animations: Array = [null, null, null, null]
var hit_animations: Array = [null, null, null, null]

#this is just a test repleca of the player
@export var items: Array[Resource]

#LEGACY replaced by total_stats
#var maxHealth : int = 12
#var damage : int = 0
#var topSpeed : int = 10

enum Character {
	WITCH,
	FRANKENSTEIN,
	GHOST,
	PUMPKIN
}
@export var character : Character #SHOULD BE SET WHEN INSTANTIATING
@export var isMonster : bool
#Enemy attack instances
const Projectile_Scene := preload("res://source/scenes/projectile.tscn")
const Frank_Attack_Scene := preload("res://source/scenes/frankenstein_attack.tscn")
const Pumpkin_Attack_Scene := preload("res://source/scenes/pumpkin_attack.tscn")
const Ghost_Attack_Scene := preload("res://source/scenes/ghost_attack.tscn")


var health :int = 0

var onAttackFunctions : Array[Callable]
var onHitFunctions : Array[Callable]
var onGetHitFunctions : Array[Callable]#When this one is called. should also call with the object hit as a parameter
var onSwitchCharacter : Array[Callable]
var onRoundStart : Array[Callable]

var direction: Vector2 = Vector2(0, 1)
var model: String
#@onready var statusEffects : StatusEffectManager = $StatusEffectManager
@onready var sprite : AnimatedSprite2D = $PlayerSprite/Body

func _ready() -> void:
	player_num = str(get_meta("player_num"))
	set_starting_stats()
	set_model_name()
	health = total_stats.maxHealth
	pass

func _process(delta: float) -> void:
	handle_move()
	if Input.is_action_just_pressed("Attack" + player_num): handle_attack()
	if(movement != Vector2.ZERO): 
		last_movement = movement

func round_start():
	call_functions(onRoundStart)

func handle_move() -> void:
	#movement = Vector2(Input.get_axis("Left" + player_num, "Right" + player_num), Input.get_axis("Up" + player_num, "Down" + player_num)).normalized()
	playWalkOrIdleAnimation(velocity)
	if not velocity.is_zero_approx(): direction = velocity
	
	if movement.length() :
		Speed = move_toward(Speed, total_stats.speed, ACCELERATION)
	
	#if movement.x:
		#var player_num = str(get_meta("player_num"))
	movement = Vector2(Input.get_axis("Left" + player_num, "Right" + player_num), Input.get_axis("Up" + player_num, "Down" + player_num)).normalized() #this needs to use the input map
	if not dash and Input.is_action_just_pressed("Dash"):
		print("ENTERING DASH")
		#dashing()
	if movement.length(): # stats.topSpeed = 10
		Speed = move_toward(Speed, total_stats.speed, total_stats.speed * ACCELERATION)
	else:
		Speed = move_toward(Speed, 0, total_stats.speed * DECELERATION) # Gradually decrease speed to zero
	
	if movement.x:
		velocity.x = movement.x * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, total_stats.speed * DECELERATION) # Gradually decrease horizontal velocity to zero
	
	if movement.y:
		velocity.y = movement.y * Speed
	else:
		velocity.y = move_toward(velocity.y, 0, total_stats.speed * DECELERATION) # Gradually decrease vertical velocity to zero
	
	move_and_slide() # Ensure velocity is passed to move_and_slide

func set_starting_stats():
	total_stats = Stats.new().setStats(base_attackDamage, base_attackSpeed, base_maxHealth, base_speed, base_cooldownReduction, base_tenacity, base_luck)
	base_stats = Stats.new().setStatsCopy(total_stats)
	item_stats = Stats.new().setStats(0,0,0,0,0,0,0)

func set_model_name():
	match character:
		Character.WITCH:
			model = "witch_" + ("monster" if isMonster else "kid")
		Character.FRANKENSTEIN:
			model = "frankenstein_" + ("monster" if isMonster else "kid")
		Character.GHOST:
			model = "ghost_" + ("monster" if isMonster else "kid")
		Character.PUMPKIN:
			model = "pumpkin_" + ("monster" if isMonster else "kid")
		_:
			print("ERROR: Player not assigned character")		

func handle_attack(): #Right now, just enables, hitbox for 0.5 seconds
	call_functions(onAttackFunctions)
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
	for i in onGetHitFunctions:
		i.call(self,attackingPlayer)
	attackingPlayer = attackingPlayer as Player
	attackingPlayer.call_functions(attackingPlayer.onHitFunctions)
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
	item_stats.addStats(item.attackDamage, item.attackSpeed, item.maxHealth, item.speed, item.cooldownReduction, item.tenacity, item.luck)
	
	for i in range(item.FunctionTypes.size()):
		match item.functionTypes[i]:
			Item.FunctionTypes.OnStart:
				Callable(ItemFunctions, item.functionNames[i]).bind(self).call()
			Item.FunctionTypes.OnAttack:
				onAttackFunctions.append(Callable(ItemFunctions, item.functionNames[i]).bind(self))
			Item.FunctionTypes.OnHit:
				onHitFunctions.append(Callable(ItemFunctions, item.functionNames[i]))
			Item.FunctionTypes.OnGetHit:
				onGetHitFunctions.append(Callable(ItemFunctions, item.functionNames[i]).bind(self))
			Item.FunctionTypes.OnRoundStart:
				onRoundStart.append(Callable(ItemFunctions, item.functionNames[i]).bind(self))

func update_totalStats():
	total_stats.setStats(base_stats.attackDamage + item_stats.attackDamage * .1 * base_stats.attackDamage, base_stats.attackSpeed + item_stats.attackSpeed * .1 * base_stats.attackSpeed, base_stats.maxHealth + item_stats.maxHealth * .25 * base_stats.maxHealth, base_stats.speed + item_stats.speed * .1 * base_stats.speed, base_stats.cooldownReduction + item_stats.cooldownReduction, base_stats.tenacity + item_stats.tenacity, base_stats.luck + item_stats.luck)

func change_health(deltaHealth : float):
	health += deltaHealth
	call_functions(onGetHitFunctions)
	if(health < 0):
		#handle death
		pass

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
	if abs(direction.x) >= abs(direction.y):
		if direction.x > 0: return "right"
		elif direction.x < 0: return "left"
	else:
		if direction.y > 0: return "down"
		elif direction.y < 0: return "up"

#currently unused
#func changeModel(newModel: String):
	#model = newModel
	

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
