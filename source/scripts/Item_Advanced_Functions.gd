class_name Item_Advanced_Functions
extends Node#extend node to allow global script
#THIS NEEDS TO BE SET AS A GLOBAL SCRIPT
#Project > Project Settings > Globals


#Class stores and type of special item functionality

static func damage_increase(ps :Player_Test):
	if(!ps.statusEffects.hasStatus("Damage Buff")):
		ps.statusEffects.giveStatus(StatusEffect.new("Damage Buff",(func(): ps.damage += 1),(func(): ps.damage -= 1)), 3)
static func shoot_additional_projectile(ps:Player_Test):
	print("let's pretend the player shot an additional projectile")
