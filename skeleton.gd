extends CharacterBody2D

@export var speed : float = 100
@export var jump_force : float = 150

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var gravity = 8

func _physics_process(_delta):
	if !is_on_floor():
		velocity.y += gravity


	move_and_slide()
