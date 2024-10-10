#class_name Item_Advanced_Functions
extends Node#extend node to allow global script
#THIS NEEDS TO BE SET AS A GLOBAL SCRIPT
#Project > Project Settings > Globals


#Class stores and type of special item functionality

static func damage_increase_start(ps :Player_Test):
	ps.statusEffects.addStatusStartFunction("Damage Buff", (func(x : Player_Test): x.damage += 1).bind(ps))
	ps.statusEffects.addStatusEndFunction("Damage Buff", (func(x : Player_Test): x.damage -= 1).bind(ps))

static func damage_increase(ps :Player_Test):
	if(!ps.statusEffects.hasStatus("Damage Buff")):
		ps.statusEffects.giveStatus("Damage Buff",3)

static func shoot_additional_projectile(ps:Player_Test):
	print("let's pretend the player shot an additional projectile")

static func damage_when_on_fire(ps : Player_Test):
	ps.statusEffects.addStatusStartFunction("Fire", func(): ps.damage += 10)
	ps.statusEffects.addStatusEndFunction("Fire", func(): ps.damage -= 10)
