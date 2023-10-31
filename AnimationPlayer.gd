extends CharacterBody2D

enum StateMachine{idle, run, atack1}

const speed := 100
const jump_force := 150
const gravity = 7.5

var strong := 30
var health := 10
var animation := ""
var state := StateMachine.idle
var direction : Vector2 = Vector2.ZERO
var death := false

@onready var animation_player = $AnimationPlayer

func _physics_process(_delta : float) -> void:
	direction = Input.get_vector("Esquerda","Direita", "Up", "s")
	
	match state:
		StateMachine.idle:
			_set_animation("idle")
			if direction.x != 0:
				_enter_state(StateMachine.run)
			
		StateMachine.run:
			_set_animation("run")
			_flip()
			velocity.x = direction.x * speed
			if direction.x == 0:
				_enter_state(StateMachine.idle)
		
			move_and_slide()
			
		StateMachine.atack1:
			pass
		
	if !is_on_floor():
		velocity.y += gravity
		
	if Input.is_action_pressed("Up") and is_on_floor():
		jump()
		
		
	
func _enter_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state
	
func _set_animation(anim: String) -> void:
	if animation != anim:
		animation = anim
		animation_player.play(animation)
		
func jump() -> void:
	velocity.y -= jump_force
	
func _flip() -> void:
	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true
