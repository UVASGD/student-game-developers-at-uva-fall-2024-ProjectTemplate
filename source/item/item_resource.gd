extends Resource

@export var damage : float = 0
@export var dmg_mult : float = 0
@export var max_health : float = 0
@export var strength : float = 0
@export var speed : float = 0
@export var func_name : String = ""


func get_stats() -> Stats :
	var s = Stats.new()
	s.damage = damage
	s.dmg_mult = dmg_mult
	s.max_health = max_health
	s.strength = strength
	s.speed = speed
	return s

####################################################################
######   ITEM  FUNCTIONS    ########################################

static func do_nothing(item_handler : Node) :
	print(item_handler.player_stats.damage)
	item_handler.player_stats.damage += 2
	print(item_handler.player_stats.damage)
	print("nothing")
	pass