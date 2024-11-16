extends Node
class_name Stats
var attackDamage: float
var attackSpeed: float #unused currently
var maxHealth : float
var speed : float
var cooldownReduction : float #unused currently
var tenacity : float
var luck : float
func setStats(_attackDamage: float, _attackSpeed: float, _maxHealth : float, _speed : float, _cooldownReduction : float, _tenacity : float, _luck : float) -> Stats:
	self.attackDamage = _attackDamage
	self.attackSpeed = _attackSpeed
	self.maxHealth = _maxHealth
	self.speed = _speed
	self.cooldownReduction = _cooldownReduction
	self.tenacity = _tenacity
	self.luck = _luck
	return self

func setStatsCopy(other: Stats) -> Stats:
	self.attackDamage = other.attackDamage
	self.attackSpeed = other.attackSpeed
	self.maxHealth = other.maxHealth
	self.speed = other.speed
	self.cooldownReduction = other.cooldownReduction
	self.tenacity = other.tenacity
	self.luck = other.luck
	return self
	
func addStats(_attackDamage: float, _attackSpeed: float, _maxHealth : float, _speed : float, _cooldownReduction : float, _tenacity : float, _luck : float) -> Stats:
	self.attackDamage += _attackDamage
	self.attackSpeed += _attackSpeed
	self.maxHealth += _maxHealth
	self.speed += _speed
	self.cooldownReduction += _cooldownReduction
	self.tenacity += _tenacity
	self.luck += _luck
	return self

func addStatsCopy(stats: Stats) -> Stats:
	self.attackDamage += stats.attackDamage
	self.attackSpeed += stats.attackSpeed
	self.maxHealth += stats.maxHealth
	self.speed += stats.speed
	self.cooldownReduction += stats.cooldownReduction
	self.tenacity += stats.tenacity
	self.luck += stats.luck
	return self
