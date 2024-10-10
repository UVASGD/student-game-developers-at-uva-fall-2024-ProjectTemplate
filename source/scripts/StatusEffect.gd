class_name StatusEffect

var name : String
var onStart : Callable
var onEnd : Callable


func _init(_name : String ,start: Callable = Callable(),end : Callable = Callable()) -> void:
	name = _name
	onStart = start
	onEnd = end
