extends Node2D

@onready var animation = $AnimationPlayer

func _ready():	
	animation.speed_scale = 0.333

func set_animation_speed(speed):
	animation.speed_scale = speed
