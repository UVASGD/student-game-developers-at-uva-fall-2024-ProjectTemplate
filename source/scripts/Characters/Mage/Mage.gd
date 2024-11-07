extends Player

class_name Mage

const SPEED = 300.0
var projectile_speed = 500.0 # Speed of the projectile
var attack_cooldown = 2.0 # Cooldown between attacks
var can_attack = true
var life_time_projectile = 3.0 # how long projectile lasts until it despawns (seconds)
var size_of_projectile = 10 # how big projectile is
var projectile_damage = 10 # Damage dealt by the projectile
#var character_sprite = preload() add this for character sprite
# Preload the MageProjectile scene
var shot_direction = Vector2.ZERO
var MageProjectileScene = preload("res://source/scenes/mage_projectile.tscn")
var move_vector = Vector2.ZERO # Add this at the class level

func _ready() -> void:
	create_character()

func update_position() -> void:
	global_position = position # Ensure global_position is updated to the current position

# Item and stats handling
func attack():
	if can_attack:
		var attack_direction = (get_global_mouse_position() - global_position).normalized()
		spawn_projectile(attack_direction)
		play_attack_animation()
		can_attack = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

func spawn_projectile(direction: Vector2):
	var projectile = MageProjectileScene.instantiate()
	projectile.initialize(direction.normalized(), projectile_speed, projectile_damage)
	self.add_sibling(projectile)
	projectile.parent = self
	projectile.position = self.global_position
	# Debugging the position
	print("Spawning projectile at: ", global_position)

func create_character():
	#add_child(character_sprite)
	
	
	pass
	
# Play an attack animation
func play_attack_animation():
	#$AnimationPlayer.play("mage_attack")  # Implement these
	pass
func play_hit_animation():
	#$AnimationPlayer.play("mage_hit")  # Implement these
	pass

func die():
	#$AnimationPlayer.play("mage_die")  # Implement these
	pass
