class_name Stats

var damage : float = 0
var dmg_mult : float = 0
var max_health : float = 0
var strength : float = 0
var speed : float = 0

func add_stats(s : Stats) :
	damage += s.damage
	dmg_mult += s.dmg_mult
	max_health += s.max_health
	strength += s.strength
	speed += s.speed

func subtract_stats(s : Stats) :
	damage -= s.damage
	dmg_mult -= s.dmg_mult
	max_health -= s.max_health
	strength -= s.strength
	speed -= s.speed

func copy() -> Stats :
	var s = Stats.new()
	s.damage = damage
	s.dmg_mult = dmg_mult
	s.max_health = max_health
	s.strength = strength
	s.speed = speed
	return s