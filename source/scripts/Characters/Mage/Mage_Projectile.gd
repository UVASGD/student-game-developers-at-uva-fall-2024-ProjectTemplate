extends Area2D # Change from Node2D to Area2D
var direction := Vector2.ZERO
var speed: float
var life_time: float = 3.0 # Default projectile lifetime (in seconds)
var damage: int = 10 # Projectile damage
var parent: Player
var size
#var sprite_texture = preload("add path to sprite here") preload sprite texture
# Set up projectile with direction and speed
func initialize(_direction: Vector2, _speed: float, _damage: int):
	direction.x = _direction.x
	direction.y = _direction.y
	speed = _speed
	damage = _damage
	# Set up collision shape
	handle_move()

func handle_move() -> void:
	# Set a timer to queue_free the projectile after its lifetime
	var timer = Timer.new()
	timer.wait_time = life_time
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "queue_free"))
	add_child(timer)
	timer.start()

	# Set up a sprite or visual for the projectile
	var sprite = Sprite2D.new()
	add_child(sprite)

	# Connect signals to handle collisions
	connect("area_entered", Callable(self, "_on_area_entered"))

func _physics_process(delta: float) -> void:
	# Move the projectile each frame
	position += direction * speed * delta

# Handle collision detection
func body_shape_entered(body):
	print("HIT DETECTED")
	print(body.instance_id())
	print(get_parent().instance_id())
	if body is Player and body.instance_id() != get_parent().instance_id(): # Ensure it doesn't hit the mage who shot it
		body.apply_damage(damage)
		queue_free() # Destroy projectile on hit

func _on_area_entered(area):
	print("HIT DETECTED")
	if area is Player and area.get_instance_id() != get_parent().get_instance_id(): # Ensure it doesn't hit the mage who shot it
		area.apply_damage(damage)
		queue_free() # Destroy projectile on hit
