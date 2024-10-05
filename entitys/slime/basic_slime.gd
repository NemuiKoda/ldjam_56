extends CharacterBody2D

@onready var player = get_node("/root/World/Player")
@onready var animation = $AnimationPlayer

var speed = 200
var jumping = false

func _physics_process(_delta):
	var distance = global_position.distance_to(player.global_position)
	if !jumping:
		var direction = global_position.direction_to(player.global_position)
		if distance < 200:
			animation.play("jump")
			velocity = -direction * speed
		else:
			animation.play("idle")
			velocity = Vector2(0, 0)
	
	if jumping:
		move_and_slide()


func jump():
	jumping = !jumping
