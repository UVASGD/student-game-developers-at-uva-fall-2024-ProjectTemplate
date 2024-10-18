extends Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var projectile_speed = 500.0  # Speed of the projectile
var attack_cooldown = 1.0  # Cooldown between attacks
var can_attack = true
var life_time_projectile = 3.0 #how long projectile lasts until it despawns

func _ready() -> void:
	super()

func attack():
	if can_attack:
		var attack_direction = movement # Direction where the player is facing
		spawn_projectile(attack_direction)
		play_attack_animation()
		can_attack = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

# Function to spawn a projectile (Area2D)
func spawn_projectile(direction: Vector2):
	# Create the projectile as an Area2D
	var projectile = Area2D.new()

	# Set the position of the projectile at the player's position
	projectile.position = global_position

	# Create a CollisionShape2D for the projectile
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()  # Adjust shape if needed
	shape.radius = 10  # Size of the projectile
	collision_shape.shape = shape
	projectile.add_child(collision_shape)

	# Add the projectile to the scene as a child of the player
	add_child(projectile)

	# Set the direction and speed
	projectile.set_meta("direction", direction.normalized())
	projectile.set_meta("speed", projectile_speed)

	# Connect the body_entered signal to handle collisions
	projectile.connect("body_entered", Callable(self, "_on_projectile_body_entered"))

	# Start a timer to remove the projectile after a few seconds
	var timer = Timer.new()
	timer.wait_time = life_time_projectile # Time in seconds before the projectile is removed
	timer.one_shot = true
	timer.connect("timeout", Callable(projectile, "queue_free"))
	projectile.add_child(timer)  # Add timer as a child to keep it in the scene tree
	timer.start()

# Update the position of the projectile every frame
func _physics_process(delta: float) -> void:
	for child in get_children():
		if child is Area2D:  # Check if the child is a projectile
			var direction = child.get_meta("direction")
			var speed = child.get_meta("speed")
			child.position += direction * speed * delta


# Detect collisions
func _on_projectile_body_entered(body):
	if body is Player and body != self:
		# Apply damage or any other effect here
		body.apply_damage(stats.attackDamage)
		print("Hit player: " + body.name + " for " + str(stats.attackDamage) + " damage!")

	# Free the projectile after collision
	body.queue_free()

# Check if projectile goes out of bounds (optional) i removed this but might be useful
func is_out_of_bounds(proj: Area2D) -> bool:
	var screen_size = get_viewport().get_visible_rect().size
	return proj.position.x < 0 or proj.position.x > screen_size.x or proj.position.y < 0 or proj.position.y > screen_size.y

# Play an attack animation
func play_attack_animation():
	$AnimationPlayer.play("mage_attack")
