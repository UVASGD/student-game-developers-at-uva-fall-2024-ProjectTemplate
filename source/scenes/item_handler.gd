extends Node2D

var items : Array[Resource]

@export var base_stats : Resource				#base stats
var stats_with_items : Stats = Stats.new()		#base stats + stats from items (updated when a new item is picked up)
var player_stats : Stats = Stats.new()			#base stats + stats from items + conditional effects from items (updated every frame)


func _process(delta):
	handle_process_effects()
	pass

func handle_process_effects() :
	player_stats = stats_with_items.copy()
	for item in items :
		call(item.func_name, self)
	pass

func handle_pickup(item : Resource) :
	#add the item list of player items
	items.append(item)

	#change the player stats (eg if the item has damage +2, the player stats_with_items damage will increase by 2)
	stats_with_items.add_stats(item.get_stats())

	#here we could also add something for a special on pickup function for each item

func handle_drop(item : Resource) :
	#remove the item from the list of player items
	items.remove_at(items.find(item))

	#change the player stats (eg if the item has damage +2, the player stats_with_items damage will decrease by 2)
	stats_with_items.subtract_stats(item.get_stats())

	#here we could also add something for a special on drop function for each item

