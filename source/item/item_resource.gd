extends Resource

class_name Item_Res

@export var damage : float = 0
@export var dmg_mult : float = 0
@export var max_health : float = 0
@export var strength : float = 0
@export var top_speed : float = 0
@export var func_name : String = ""

#note that when adding a stat, a few lines need to be added in stats.gd and in get_stats() in this class

func get_stats() -> Stats :
	var s = Stats.new()
	s.damage = damage
	s.dmg_mult = dmg_mult
	s.max_health = max_health
	s.strength = strength
	s.top_speed = top_speed
	return s

####################################################################
######   ITEM  SPECIFIC  FUNCTIONS    ########################################

#EXAMPLE
"""
static func amulet_of_fear(player : Player) :
	if (player.is_scared) : 
		player.stats.top_speed += 10
"""

#TESTING
static func do_nothing(player : Player) :
	player.stats.top_speed += 10
	print("nothing")
	pass
