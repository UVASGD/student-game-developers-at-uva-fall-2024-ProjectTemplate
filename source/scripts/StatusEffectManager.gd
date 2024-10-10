class_name StatusEffectManager
extends Node

var statuses : Array[String]


func giveStatus(status: StatusEffect,duration : float) -> void:
	statuses.append(status)
	create_timer(status,duration)
func hasStatus(status: String) -> bool:
	return statuses.has(status)
func create_timer(status : StatusEffect, duration :float):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.start()
	timer.connect("timeout",status.onEnd)
