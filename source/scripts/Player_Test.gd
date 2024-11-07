class_name Player_Test
extends Node

#this is just a test repleca of the player
#important code that should be transfered should also be noted
@export var items: Array[Item]

@export var playerStat_Test_Textbox: RichTextLabel

var isMonster : bool = false

var maxHealth : float = 100
var damage :float = 0
var speed : float = 0
var tenasity : float = 0
var luck : float = 0

var health : float = 100
var candy : float = 0
#signal onAttack(player)#This signals will emit every attack
#signal onGetHit(player)#This signal will emit every time the player gets hit
#more signals to tell items when to trigger their effects

var onAttackFunctions : Array[Callable]
var onHitFunctions : Array[Callable]
var onGetHitFunctions : Array[Callable]#When this one is called. should also call with the object hit as a parameter
var onSwitchCharacter : Array[Callable]
var onRoundStart : Array[Callable]

@onready var statusEffects : StatusEffectManager = $StatusEffectManager

#strictly for testing damage

func _ready():
	statusEffects.setStartingStatusFunctions(self)
	call_functions(onRoundStart)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	manage_test_input()
	playerStat_Test_Textbox.text = "maxHealth: " + str(maxHealth) + "\ndamage: " + str(damage) + "\nspeed: " + str(speed) +"\ncurrentHealth: " + str(health) + "\ncandy: " + str(candy)
func manage_test_input():
	pass
	#Press enter to get item (currently only the DmgBuffItem)
	if Input.is_action_just_pressed("Left1"):
		print("Gave Item " + str(items[0].resource_path))
		get_item(items[0])
	if Input.is_action_just_pressed("Up1"):
		#statusEffects.giveStatusTimed("Fire",3, StatusEffectManager.OverLapBehavior.REFRESH)
		#statusEffects.giveStatusTimed("Poison",3, StatusEffectManager.OverLapBehavior.STACK)
		#statusEffects.giveStatusTimed("Stun",3, StatusEffectManager.OverLapBehavior.REFRESH)
		#statusEffects.giveStatusTimed("Spook",3, StatusEffectManager.OverLapBehavior.REFRESH)
		call_functions(onRoundStart)
		pass
		

	##press right mouse to check damage stat
	if Input.is_action_just_pressed("mouse0_Test"):
		hit_object(null)
		print("I hit something")
func get_item(item : Item):
	damage += item.attackDamage
	health += item.maxHealth
	
	for i in range(item.functionTypes.size()):
		match item.functionTypes[i]:
			Item.FunctionTypes.OnStart:
				Callable(ItemFunctions, item.functionNames[i]).bind(self).call()
			Item.FunctionTypes.OnAttack:
				onAttackFunctions.append(Callable(ItemFunctions, item.functionNames[i]).bind(self))
			Item.FunctionTypes.OnHit:
				onHitFunctions.append(Callable(ItemFunctions, item.functionNames[i]))
			Item.FunctionTypes.OnGetHit:
				onGetHitFunctions.append(Callable(ItemFunctions, item.functionNames[i]).bind(self))
			Item.FunctionTypes.OnSwitchCharacter:
				onSwitchCharacter.append(Callable(ItemFunctions, item.functionNames[i]).bind(self))
			Item.FunctionTypes.OnRoundStart:
				onRoundStart.append(Callable(ItemFunctions, item.functionNames[i]).bind(self))
	#if(item.onStartFunctions != ""):
		#Callable(ItemAdvancedFunctions, item.onStartFunctions).bind(self).call() #NEED TO DO ERROR HANDLING WHEN USER PASSES STRING THATS NOT A FUNCTION NAME
	#if(item.onFireFunctions != ""):
		#onAttack.connect(Callable(ItemAdvancedFunctions,item.onFireFunctions))
	#if(item.onGetHitFunctions != ""):
		#print("new on get hit function: " + item.onGetHitFunctions)
		#onGetHit.connect(Callable(ItemAdvancedFunctions,item.onGetHitFunctions))
	
func hit_object(otherPs: Player_Test):#otherPs - hit Playerscript
	for i in onHitFunctions:
		i.call(self,otherPs)
	

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
#func give_status_effect(effect : StatusEffect, duration : float):
	#statusEffects.giveStatus(effect, duration)
