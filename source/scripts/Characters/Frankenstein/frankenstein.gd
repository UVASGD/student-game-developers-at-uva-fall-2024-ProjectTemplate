extends Player

class_name Frankenstein

var sprite #preload()
@onready var hit_animation = $HitAnimation
@onready var death_animation = $DeathAnimation
@onready var attack_animation = $AttackAnimation
@onready var walk_left_animation = $WalkLeftAnimation
@onready var walk_right_animation = $WalkRightAnimation
@onready var walk_up_animation  = $WalkUpAnimation
@onready var walk_down_animation = $WalkDownAnimation
@onready var idle_animation = $IdleAnimation
@onready var dash_animation = $DashAnimation
@onready var animator = $AnimationPlayer


func _ready():
	pass
func _process(delta: float) -> void:
	check_moving()
	#check these as well to determine if animation for hit or attack needs to be played.
	# check_attack()
	# check_hit()
		

func hitAnimation():
	animator.play(hit_animation)

func attackAnimation():
	animator.play(attack_animation)

func check_moving():
	if(dash):
		dashAnimation()
	elif (self.movement.x > 0):
		walkRightAnimation()
	elif (self.movement.x < 0):
		walkLeftAnimation()
	elif (self.movement.y > 0 and self.movement.x == 0):
		walkUpAnimation()
	elif (self.movement.y < 0 and self.movement.x == 0):
		walkDownAnimation()
	elif (self.movement == Vector2.ZERO):
		idleAnimation()

func walkLeftAnimation():
	if(animator.current_animation != walk_left_animation and !animator.is_playing()):
		animator.play(walk_left_animation)

func walkRightAnimation():
	if(animator.current_animation != walk_right_animation and !animator.is_playing()):
		animator.play(walk_right_animation)

func walkUpAnimation():
	if(animator.current_animation != walk_up_animation and !animator.is_playing()):
		animator.play(walk_up_animation)

func walkDownAnimation():
	if(animator.current_animation != walk_down_animation and !animator.is_playing()):
		animator.play(walk_down_animation)

func dashAnimation():
	if(animator.current_animation != dash_animation and !animator.is_playing()):
		animator.play(dash_animation)
	
func idleAnimation():
	if(animator.current_animation != idle_animation and !animator.is_playing()):
		animator.play(idle_animation)
