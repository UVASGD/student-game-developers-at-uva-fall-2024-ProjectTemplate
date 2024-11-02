extends Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_attack = true
var attack_area: Area2D = Area2D.new()
var attack_area_size = 30 # Adjust as necessary
var attack_offset = Vector2(30, 0) # Base offset for the attack area
var last_facing_direction: Vector2 = Vector2(1, 0) # Default facing direction
#sprites of both character and weapon
var sprite_of_character: Sprite2D = Sprite2D.new()
var sprite_of_weapon: Sprite2D = Sprite2D.new()
@onready var player := get_parent()

func _ready() -> void:
	super()
	#adds character sprite to frankenstein node
	add_character_sprite()
	create_attack_area()
	#adds weapon sprite to collision shape
	add_weapon_sprite()

func create_attack_area():
	# Add the Area2D as a child of the player
	add_child(attack_area)
	#create weapon sprite
	attack_area.position = attack_offset # Set initial position with offset
	# Create a CollisionShape2D for the attack area
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new() # Change shape as desired
	shape.radius = attack_area_size
	collision_shape.shape = shape
	attack_area.add_child(collision_shape)

	# Connect signals for body entered/exited (this is unnecessary just for detecting collisisons)
	attack_area.connect("body_entered", Callable(self, "_on_attack_area_body_entered"))
	attack_area.connect("body_exited", Callable(self, "_on_attack_area_body_exited"))

func _process(delta: float) -> void:
	update_attack_area_position()

#change collisioon shape location relative to player depending on the direction the player is facing
func update_attack_area_position():
	# Update the position of the attack area based on player's facing direction
	var facing_direction = player.movement.normalized() # Get the normalized movement vector
	if facing_direction.length() > 0: # Check if the player is moving
		last_facing_direction = facing_direction # Update last facing direction
		attack_area.position = player.position + (last_facing_direction * attack_offset)
	else:
		# Use last facing direction when not moving
		attack_area.position = player.position + (last_facing_direction * attack_offset)

func _on_attack_area_body_entered(body):
	if body is Player and body != self and can_attack:
		var damage = stats.attackDamage
		attack() # prints out attack and sets timer for attack_speed
		body.apply_damage(damage)
		print("Hit player: " + body.name + " for " + str(damage) + " damage!")

func _on_attack_area_body_exited(body):
	print(body.name + " left attack area")

func attack():
	var attack_cooldown = stats.attackSpeed
	print("Frankenstein Smashes the Ground!")
	play_attack_animation()
	can_attack = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func add_weapon_sprite():
	#TODO: add edit features for weapon sprite
	
	
	attack_area.add_child(sprite_of_weapon)
	pass
func add_character_sprite():
	#TODO: add edit features for weapon sprite
	
	
	add_child(sprite_of_character)
	pass

func play_attack_animation():
	$AnimationPlayer.play("frankenstein_attack") # TODO: Implement animations for attacks
func play_hit_animation():
	$AnimationPlayer.play("frankenstein_hit") # TODO: Implement these animations
func die():
	$AnimationPlayer.play("frankenstein_attack") # TODO: Implement these animations
