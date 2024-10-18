extends Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_attack = true
var attack_area : Area2D = Area2D.new()
var attack_area_size = 30 # should be changed depending on the size of the attack area we want
@onready var player := get_parent()


func _ready() -> void:
	super()
	create_attack_area()

func create_attack_area():
	# Add the Area2D as a child of the player
	player.add_child(attack_area)
	attack_area.position = Vector2(0, 0)  # Center the area on the player should be changed if the weapon is positiuoned 
	# Create a CollisionShape2D for the attack area
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new() #change shape as desired
	shape.radius = attack_area_size 
	collision_shape.shape = shape
	attack_area.add_child(collision_shape)

	# Connect signals for body entered/exited
	attack_area.connect("body_entered", Callable(self, "_on_attack_area_body_entered"))
	attack_area.connect("body_exited", Callable(self, "_on_attack_area_body_exited"))

func _on_attack_area_body_entered(body):
	if body is Player and body != self:
		var damage = stats.attackDamage
		body.apply_damage(damage)
		print("Hit player: " + body.name + " for " + str(damage) + " damage!")

func _on_attack_area_body_exited(body):
	print(body.name + " left attack area")

func attack():
	if can_attack:
		var attack_cooldown = stats.attackSpeed
		print("Frankenstein Smashes the Ground!")
		play_attack_animation()
		can_attack = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

func play_attack_animation():
	$AnimationPlayer.play("frankenstein_attack") #implement animations for attacks
func die():
	$AnimationPlayer.play("frankenstein_attack") #implement animations for dying
