extends Player

class_name Ghost

var sprite #preload()
@onready var hit_animation = $HitAnimation
@onready var death_animation = $DeathAnimation
@onready var attack_animation = $AttackAnimation
@onready var run_animation = $RunAnimation
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
	elif(self.movement != Vector2.ZERO):
		runAnimation()
	elif (self.movement == Vector2.ZERO):
		idleAnimation()

func runAnimation():
	if(animator.current_animation != run_animation):
		animator.play(run_animation)
func dashAnimation():
	if(animator.current_animation != run_animation):
		animator.play(dash_animation)
	
func idleAnimation():
	if(animator.current_animation != run_animation):
		animator.play(idle_animation)
