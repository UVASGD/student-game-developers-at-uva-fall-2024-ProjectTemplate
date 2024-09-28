extends Node2D

@onready var player := get_parent()
@onready var unconditional_stats : Stats = player.base_stats.get_stats().copy()		#player base stats + unconditional stats from items (updated when a new item is picked up)


func _ready():
	#temp code allowing items to be added before runtime
	for item in get_children() :
		handle_pickup(item)

func _process(delta):
	handle_process_effects()
	pass

func handle_process_effects() :
	#reset the stats to the non-conditional values
	player.stats = unconditional_stats.copy()
	#add any conditional values
	for item in get_children() :
		if item.item_res.func_name == "" : continue
		item.item_res.call(item.item_res.func_name, player) #calls the item specific function, passes the player
	pass

func handle_pickup(item : Item) :
	#add the item node as a child of this node, the children of this node is the list of items the player has
	item.reparent(self)
	#change the unconditional stats (eg if the item has damage +2, the player unconditional_stats damage will increase by 2)
	unconditional_stats.add_stats(item.get_stats())
	#here we could also add something for a special on_pickup() for each item if need be
	pass

func handle_drop(item : Item, destroy : bool) :
	#if destroy is false, the item should be reparented
	#change the unconditional stats (eg if the item has damage +2, the player unconditional_stats damage will decrease by 2)
	unconditional_stats.subtract_stats(item.get_stats())
	#here we could also add something for a special on_drop() for each item if need be
	#remove the item from the list of player items
	#(queue_free() is temporary, will change later when we know whats actually going to happen with the item)
	if destroy : item.queue_free()
	pass

