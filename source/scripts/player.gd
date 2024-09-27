extends CharacterBody2D

var Speed := 0.0
var topSpeed := 150.0
var hDirection := 0.0
var vDirection := 0.0 

const SPEED_INC := 15.0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	handle_move(delta)



func handle_move(delta) -> void:
	hDirection = Input.get_axis("Left", "Right")
	vDirection = Input.get_axis("Up", "Down")
	if hDirection and vDirection:
		Speed = move_toward(Speed, topSpeed, SPEED_INC) #slowed velocity's to account for increased movement
		velocity.x = hDirection * Speed / 1.4
		velocity.y = vDirection * Speed / 1.4
	elif hDirection:
		Speed = move_toward(Speed, topSpeed, SPEED_INC)
		velocity.x = hDirection * Speed
		velocity.y = move_toward(velocity.y, 0, SPEED_INC)
	elif vDirection:
		Speed = move_toward(Speed, topSpeed, SPEED_INC)
		velocity.y = vDirection * Speed
		velocity.x = move_toward(velocity.x, 0, SPEED_INC)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED_INC)
		velocity.y = move_toward(velocity.y, 0, SPEED_INC)
	move_and_slide()
