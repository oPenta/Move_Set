extends CharacterBody2D

enum StateMachine{idle, run, atack1, atack2}

var speed := 120
var gravity = 8

var death := false
var strong := 30
var health := 10
var animation := ""
var state := StateMachine.idle
var direction := 0.0
var boost := direction * 50


@onready var animation_player = $AnimationPlayer

@export var timer : Timer = null

func _ready():
	pass
	
func _physics_process(_delta) -> void:
	direction = Input.get_axis("Esquerda","Direita")
	@warning_ignore("narrowing_conversion")
	boost = direction * 50
	
	if !is_on_floor():
		velocity.y += gravity
		move_and_slide()
		
	match state:
		StateMachine.idle:
			_set_animation("idle")
			if direction != 0:
				_enter_state(StateMachine.run)
			if Input.is_action_pressed("Atack"):
				_enter_state(StateMachine.atack1)
		
		StateMachine.run:
			_set_animation("run")
			_flip()
			velocity.x = direction * speed
			if Input.is_action_pressed("Cima"):
				velocity.x = direction * speed + boost
			if direction == 0:
				_enter_state(StateMachine.idle)
			move_and_slide()
			
		StateMachine.atack1:
			_set_animation("atack1")
			await animation_player.animation_finished
			_enter_state(StateMachine.idle)
			
		StateMachine.atack2: 
			pass
			
func _enter_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state
	
func _set_animation(anim: String) -> void:
	if animation != anim:
		animation = anim
		animation_player.play(animation)
		
func _flip() -> void:
	if direction > 0:
		$Sprite2D.flip_h = false
	elif direction < 0:
		$Sprite2D.flip_h = true
