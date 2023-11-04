extends CharacterBody2D

enum StateMachine {idle, run, atack}

const speed := 60
const dist_follow := 250
const dist_atack := 35

var distance := 0.0
var strong := 10
var health := 3
var animation := ""
var state := StateMachine.idle
var direction := 0
var death := false

@onready var animation_player = $AnimationPlayer
@onready var player = owner.get_node("Player")

func _physics_process(_delta: float) -> void:
	distance = global_position.distance_to(player.global_position)
	
	match state:
		StateMachine.idle:
			_set_animation("idle")
			if distance <= dist_follow:
				_enter_state(StateMachine.run)
				
		StateMachine.run:
			_set_animation("run")
			_flip()
			velocity.x = direction * speed
			move_and_slide()
			
			if distance >= dist_follow:
				_enter_state(StateMachine.idle)
				
			if distance <= dist_atack:
				_enter_state(StateMachine.atack)
			
		StateMachine.atack:
			_set_animation("atack")
			await animation_player.animation_finished
			_enter_state(StateMachine.idle)


func _enter_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state

func _set_animation(anim: String) -> void:
	if animation != anim:
		animation = anim
		animation_player.play(animation)
		
func _flip() -> void:
	if global_position.x < player.global_position.x:
		$Sprite2D.flip_h = false
		direction = 1
	elif global_position.x > player.global_position.x:
		$Sprite2D.flip_h = true
		direction = -1
