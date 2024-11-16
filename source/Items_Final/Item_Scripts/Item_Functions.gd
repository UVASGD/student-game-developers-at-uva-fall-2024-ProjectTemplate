#Needs to be a global script
extends Node

func fire_start(ps : Player_Test):
	ps.statusEffects.giveStatusTimed("FireTick", 0.5, StatusEffectManager.OverLapBehavior.IGNORE)
func fire_tick_end(ps : Player_Test):
	ps.change_health(-5)
	if(ps.statusEffects.hasStatus("Fire")):
		ps.statusEffects.giveStatusTimed("FireTick", 0.5, StatusEffectManager.OverLapBehavior.IGNORE)

func poison_start(ps : Player_Test):
	ps.statusEffects.giveStatusTimed("PoisonTick", 1, StatusEffectManager.OverLapBehavior.STACK)
func poison_tick_end(ps : Player_Test):
	ps.change_health(-1)
	if(ps.statusEffects.hasStatus("Poison")):
		ps.statusEffects.giveStatusTimed("PoisonTick", 1, StatusEffectManager.OverLapBehavior.STACK)

func stun_start(ps : Player_Test): #GAME DESIGN WARNING. this just gives a speed debuff using the speed bonus stat. maybe it should modify the player's base stats?
	ps.speed -= 4
func stun_end(ps : Player_Test):
	ps.speed += 4

func spook_start(ps : Player_Test):
	ps.damage -= 4
func spook_end(ps : Player_Test):
	ps.damage += 4

func yoyo_onStart(ps: Player_Test):
	ps.statusEffects.addStatusStartAndEndFunction("yoyo_speedBuff", Callable(self,"yoyo_speedBuff_start").bind(ps), Callable(self,"yoyo_speedBuff_end").bind(ps))	
func yoyo_onHit(ps: Player_Test, other :Player_Test):
	ps.statusEffects.giveStatusTimed("yoyo_speedBuff", 3, StatusEffectManager.OverLapBehavior.STACK)
func yoyo_speedBuff_start(ps: Player_Test):
	ps.speed += 2
func yoyo_speedBuff_end(ps: Player_Test):
	ps.speed -= 2

func propellerHat_onStart(ps: Player_Test):
	ps.statusEffects.addStatusStartAndEndFunction("Fire", Callable(self,"propellerHat_speedBuff_start").bind(ps), Callable(self,"propellerHat_speedBuff_end").bind(ps))
	ps.statusEffects.addStatusStartAndEndFunction("Poison", Callable(self,"propellerHat_speedBuff_start").bind(ps), Callable(self,"propellerHat_speedBuff_end").bind(ps))
	ps.statusEffects.addStatusStartAndEndFunction("Stun", Callable(self,"propellerHat_speedBuff_start").bind(ps), Callable(self,"propellerHat_speedBuff_end").bind(ps))
	ps.statusEffects.addStatusStartAndEndFunction("Spook", Callable(self,"propellerHat_speedBuff_start").bind(ps), Callable(self,"propellerHat_speedBuff_end").bind(ps))
func propellerHat_speedBuff_start(ps : Player_Test):
	if not(ps.statusEffects.hasStatus("propellerHat_speedBuff")):
		ps.speed += 2
		ps.statusEffects.giveStatus("propellerHat_speedBuff")
func propellerHat_speedBuff_end(ps : Player_Test):
	if not(ps.statusEffects.hasStatus("Fire") or ps.statusEffects.hasStatus("Poison") or ps.statusEffects.hasStatus("Stun") or ps.statusEffects.hasStatus("Spook")):
		ps.speed -= 2
		ps.statusEffects.removeStatus("propellerHat_speedBuff")

func topHat_onStart(ps: Player_Test):
	ps.statusEffects.addStatusStartAndEndFunction("topHat_speedBuff", Callable(self,"topHat_speedBuff_start").bind(ps), Callable(self,"topHat_speedBuff_end").bind(ps))
func topHat_onAttack(ps : Player_Test):
	ps.statusEffects.giveStatusTimed("topHat_speedBuff", 0.1, StatusEffectManager.OverLapBehavior.REFRESH)
func topHat_speedBuff_start(ps : Player_Test):
	ps.speed += 1
func topHat_speedBuff_end(ps : Player_Test):
	ps.speed -= 1

func winterHat_onStart(ps : Player_Test):
	ps.statusEffects.addStatusStartAndEndFunction("winterHat_damageBuff", Callable(self,"winterHat_damageBuff_start").bind(ps), Callable(self,"winterHat_damageBuff_end").bind(ps))
func winterHat_onHit(ps : Player_Test):
	if(ps.health / ps.maxHealth < .5):
		if(!ps.statusEffects.hasStatus("winterHat_damageBuff")):
			ps.statusEffects.giveStatus("winterHat_damageBuff")
	else:
		if(ps.statusEffects.hasStatus("winterHat_damageBuff")):
			ps.statusEffects.removeStatus("winterHat_damageBuff")
func winterHat_damageBuff_start(ps : Player_Test):
	ps.damage += 2
func winterHat_damageBuff_end(ps : Player_Test):
	ps.damage -= 2
	
func rubberDuck_onRoundStart(ps : Player_Test):
	ps.maxHealth += 1

func candyCane_onRoundStart(ps : Player_Test):
	ps.statusEffects.addStatusEndFunction("candyCane_buff", Callable(self,"candyCane_buff_end").bind(ps))
	ps.statusEffects.giveStatusTimed("candyCane_buff", 1, StatusEffectManager.OverLapBehavior.REFRESH)
func candyCane_buff_end(ps : Player_Test):
	ps.candy += 1
	ps.statusEffects.giveStatusTimed("candyCane_buff", 1, StatusEffectManager.OverLapBehavior.REFRESH)
	
func puzzleCube_onHit(ps : Player_Test, other : Player_Test):
	if other.isMonster:
		other.statusEffects.addStatusStartAndEndFunction("puzzleCube_speedDebuff",  Callable(self,"puzzleCube_speedDebuff_start").bind(other), Callable(self,"puzzleCube_speedDebuff_end").bind(other))
	else:
		ps.statusEffects.addStatusStartAndEndFunction("puzzleCube_speedBuff",  Callable(self,"puzzleCube_speedBuff_start").bind(ps), Callable(self,"puzzleCube_speedBuff_end").bind(ps))
func puzzleCube_speedBuff_start(ps : Player_Test):
	ps.speed += 2
func puzzleCube_speedBuff_end(ps : Player_Test):
	ps.speed -= 2
func puzzleCube_speedDebuff_start(other : Player_Test):
	other.speed -= 2
func puzzleCube_speedDebuff_end(other : Player_Test):
	other.speed += 2

func sprayPaint_onHit(ps : Player_Test):
	ps.statusEffects.addStatusStartAndEndFunction("sprayPaint_Buff", Callable(self,"sprayPaint_attackBuff_start").bind(ps), Callable(self,"sprayPaint_attackBuff_end").bind(ps))
func sprayPaint_attackBuff_start(ps : Player_Test):
	ps.speed += 2
func sprayPaint_attackBuff_end(ps : Player_Test):
	ps.speed -= 2

func deckOfCards_onStart(ps : Player_Test):
	ps.statusEffects.addStatusStartAndEndFunction("deckOfCards_damageBuff", Callable(self, "deckOfCards_damageBuff_start").bind(ps), Callable(self, "deckOfCards_damageBuff_end").bind(ps))
	ps.statusEffects.addStatusStartAndEndFunction("deckOfCards_speedBuff", Callable(self, "deckOfCards_speedBuff_start").bind(ps), Callable(self, "deckOfCards_speedBuff_end").bind(ps))
	ps.statusEffects.addStatusStartAndEndFunction("deckOfCards_healthBuff", Callable(self, "deckOfCards_healthBuff_start").bind(ps), Callable(self, "deckOfCards_healthBuff_end").bind(ps))
	ps.statusEffects.addStatusStartAndEndFunction("deckOfCards_damageBuff2", Callable(self, "deckOfCards_damageBuff2_start").bind(ps), Callable(self, "deckOfCards_damageBuff2_end").bind(ps))
func deckOfCards_onRoundStart(ps : Player_Test):
	if(ps.statusEffects.hasStatus("deckOfCards_damageBuff")):
		ps.statusEffects.removeStatus("deckOfCards_damageBuff")
	if(ps.statusEffects.hasStatus("deckOfCards_speedBuff")):
		ps.statusEffects.removeStatus("deckOfCards_speedBuff")
	if(ps.statusEffects.hasStatus("deckOfCards_healthBuff")):
		ps.statusEffects.removeStatus("deckOfCards_healthBuff")
	var rand = RandomNumberGenerator.new()
	var randomNum = rand.randi_range(0, 2)
	match(randomNum):
		0:
			ps.statusEffects.giveStatus("deckOfCards_damageBuff", StatusEffectManager.OverLapBehavior.IGNORE)
		1:
			ps.statusEffects.giveStatus("deckOfCards_speedBuff", StatusEffectManager.OverLapBehavior.IGNORE)
		2:
			ps.statusEffects.giveStatus("deckOfCards_healthBuff", StatusEffectManager.OverLapBehavior.IGNORE)
func deckOfCards_onGetHit(ps : Player_Test):
	if(ps.health / ps.maxHealth <= .1):
		if(!ps.statusEffects.hasStatus("deckOfCards_damageBuff2")):
			ps.statusEffects.giveStatus("deckOfCards_damageBuff2")
	else:
		if(ps.statusEffects.hasStatus("deckOfCards_damageBuff2")):
			ps.statusEffects.removeStatus("deckOfCards_damageBuff2")
func deckOfCards_damageBuff_start(ps : Player_Test):
	ps.damage += 10
func deckOfCards_damageBuff_end(ps : Player_Test):
	ps.damage -= 10
func deckOfCards_speedBuff_start(ps : Player_Test):
	ps.speed += 10
func deckOfCards_speedBuff_end(ps : Player_Test):
	ps.speed -= 10
func deckOfCards_healthBuff_start(ps : Player_Test):
	ps.maxHealth += 10
func deckOfCards_healthBuff_end(ps : Player_Test):
	ps.maxHealth -= 10
func deckOfCards_damageBuff2_start(ps : Player_Test):
	ps.damage += 5
func deckOfCards_damageBuff2_end(ps : Player_Test):
	ps.damage -= 5

func rainbowLolipop_onStart(ps : Player_Test):
	ps.statusEffects.addStatusStartAndEndFunction("rainbowLolipop_buff", Callable(self,"rainbowLolipop_buff_start").bind(ps),Callable(self,"rainbowLolipop_buff_end").bind(ps))
	ps.statusEffects.addStatusStartAndEndFunction("rainbowLolipop_tenasityBuff", Callable(self,"rainbowLolipop_tenasityBuff_start").bind(ps),Callable(self,"rainbowLolipop_tenasityBuff_end").bind(ps))
func rainbowLolipop_onHit(ps : Player_Test):
	ps.statusEffects.giveStatusTimed("rainbowLolipop_tenasityBuff", 3, StatusEffectManager.OverLapBehavior.STACK)
	if(ps.health / ps.maxHealth <= .4):
		if(!ps.statusEffects.hasStatus("rainbowLolipop_buff")):
			ps.statusEffects.giveStatusTimed("rainbowLolipop_buff",8, StatusEffectManager.OverLapBehavior.REFRESH)
	else:
		if(ps.statusEffects.hasStatus("rainbowLolipop_buff")):
			ps.statusEffects.removeStatus("rainbowLolipop_buff")
func rainbowLolipop_buff_start(ps : Player_Test):
	ps.damage += 2
	ps.speed += 2
func rainbowLolipop_buff_end(ps : Player_Test):
	ps.damage -= 2
	ps.speed -= 2
func rainbowLolipop_tenasityBuff_start(ps : Player_Test):
	ps.tenasity += 2
func rainbowLolipop_tenasityBuff_end(ps : Player_Test):
	ps.tenasity -= 2

func rollerSkates_onStart(ps : Player_Test):
	ps.statusEffects.addStatusStartAndEndFunction("rollerSkates_buff", Callable(self, "rollerSkates_buff_start").bind(ps), Callable(self, "rollerSkates_buff_end").bind(ps))
func rollerSkates_onHit(ps : Player_Test):
	print("try gib buf" , (int)((1 - ps.health / ps.maxHealth) * 10))
	while(ps.statusEffects.hasStatus("rollerSkates_buff")):
		ps.statusEffects.removeStatus("rollerSkates_buff")
	for i in range(0, (int)((1- ps.health / ps.maxHealth) * 10)):
		ps.statusEffects.giveStatus("rollerSkates_buff", StatusEffectManager.OverLapBehavior.STACK)
func rollerSkates_buff_start(ps : Player_Test):
	ps.speed += 1
func rollerSkates_buff_end(ps : Player_Test):
	ps.speed -= 1
