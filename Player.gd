extends CharacterBody2D


@export var speed : float = 100
@export var jump_force : float = 150

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animated_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var in_air : bool = false

func _physics_process(_delta):
	if !is_on_floor():
		velocity.y += gravity
		in_air = true
	
	if in_air:
		pousar()
		
	in_air = false
		
	if Input.is_action_pressed("Up"):
		if is_on_floor():
			jump()
		
	direction = Input.get_vector("Esquerda","Direita","Up", "s")
	if direction.x != 0:
		velocity.x = direction.x * speed
	elif (animated_sprite.animation == "jump_fall"):
		velocity.x = 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	new_animation()
	direction_see()
	
func new_animation():
	if !animated_locked:
		if !is_on_floor():
			animated_sprite.play("jump_fall")
		else:
			if direction.x != 0:
					animated_sprite.play("run")
			else:
					animated_sprite.play("idle")

func direction_see():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
		
func jump():
	velocity.y -= jump_force
	animated_sprite.play("jump")
	animated_locked = true
	
func pousar():
	animated_sprite.play("jump_fall")
	animated_locked = true
	

func _on_animated_sprite_2d_animation_finished():
	if(animated_sprite.animation == "jump_fall"):
		animated_locked = false

