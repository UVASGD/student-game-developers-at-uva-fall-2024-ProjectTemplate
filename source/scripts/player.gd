extends CharacterBody2D

class_name Player

var player_num
var Speed := 0.0
var movement := Vector2.ZERO

const TOP_SPEED_FACTOR := 15.0
const ACCELERATION := 15.0

#this is just a test repleca of the player
@export var items: Array[Resource]

var maxHealth : int = 12
var damage : int = 0
var topSpeed : int = 10


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

func _process(delta) -> void:
	handle_move()

func handle_move() -> void:
	movement = Vector2(Input.get_axis("Left" + player_num, "Right" + player_num), Input.get_axis("Up" + player_num, "Down" + player_num)).normalized()
	
	playWalkOrIdleAnimation(velocity)
	if not velocity.is_zero_approx(): direction = velocity
	
	if movement.length() :
		Speed = move_toward(Speed, topSpeed * TOP_SPEED_FACTOR, ACCELERATION)
	
	if movement.x :
		velocity.x = movement.x * Speed
	else :
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	
	if movement.y :
		velocity.y = movement.y * Speed
	else :
		velocity.y = move_toward(velocity.y, 0, ACCELERATION)
	
	move_and_slide()

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
	if abs(direction.x) >= abs(direction.y):
		if direction.x > 0: return "right"
		elif direction.x < 0: return "left"
	else:
		if direction.y > 0: return "down"
		elif direction.y < 0: return "up"

func changeModel(newModel: String):
	model = newModel
	
