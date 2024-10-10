class_name StatusEffectManager
extends Node

var statuses : Array[String]
var statusFunctionsStart : Dictionary#[String,Array[Callable]]
var statusFunctionsEnd : Dictionary#[String,Array[Callable]]

var timers : Dictionary#[String,Timer]

enum OverLapBehavior{
	IGNORE,
	REFRESH
}

func setStartingStatusFunctions(ps : Player_Test):
	#Temperary. StatusEffect behavior should be stored elsewhere
	addStatusStartFunction("Fire", Callable(self,"fire_start").bind(ps))
	addStatusEndFunction("FireTick", Callable(self,"fire_tick_end").bind(ps))

func giveStatus(status: String,duration : float) -> void:
	statuses.append(status)
	if(statusFunctionsStart.has(status)):
		#print(statusFunctionsStart[status])
		for c in statusFunctionsStart[status]:
			#print(c)
			c.call()
	create_timer(status,duration)

func hasStatus(status: String) -> bool:
	return statuses.has(status)

func create_timer(status : String, duration :float):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", Callable(self,"removeStatus").bind(status))

func removeStatus(status: String):
	#print("removing", status)
	if(statusFunctionsEnd.has(status)):
		#print(statusFunctionsEnd[status])
		for c in statusFunctionsEnd[status]:
			c.call()
	statuses.erase(status)
func addStatusStartFunction(statusName : String, function : Callable):
	if(!statusFunctionsStart.has(statusName)):
		var newFunctions : Array[Callable]
		statusFunctionsStart[statusName] = newFunctions
	statusFunctionsStart[statusName].append(function)
func addStatusEndFunction(statusName : String, function : Callable):
	if(!statusFunctionsEnd.has(statusName)):
		var newFunctions : Array[Callable]
		statusFunctionsEnd[statusName] = newFunctions
	statusFunctionsEnd[statusName].append(function)
	
	
func fire_start(ps : Player_Test):
	giveStatus("FireTick",0.5)	
func fire_tick_end(ps : Player_Test):
	ps.change_health(-2)
	if(hasStatus("Fire")):
		giveStatus("FireTick", 0.5)
