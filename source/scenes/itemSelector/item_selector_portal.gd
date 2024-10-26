extends Area2D

var selectorScene: PackedScene = preload("res://source/scenes/itemSelector/item_selector.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if typeof(body) == typeof(Player):
		var selector = selectorScene.instantiate()
		get_tree().current_scene.add_child(selector)
