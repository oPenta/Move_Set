extends CharacterBody2D

@export var MAX_SPEED = 300
@export var ACCELERATION = 1500 
@export var FRICTION = 1500

@onready var axis = Vector2.ZERO

func _physics_process(delta):
	move(delta)


func get_input_axis():
	axis.x = int(Input.is_action_pressed("Direita")) - int(Input.is_action_pressed("Esquerda"))
	axis.y = int(Input.is_action_pressed("Baixo")) - int(Input.is_action_pressed("Cima"))
	return axis.normalized()
	
func move(delta):
	axis = get_input_axis()
	if axis == Vector2.ZERO:
		pass
	else:
		apply_movement(axis * ACCELERATION * delta)
		
		
	move_and_slide()
	
	
func apply_friction(acount):
	if velocity.length() > acount:
		velocity -= velocity.normalized()
	else:
		velocity = Vector2.ZERO
		
		
		
func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(MAX_SPEED)
	
