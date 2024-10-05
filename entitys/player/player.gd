extends CharacterBody2D

@export var move_speed : float = 300
@onready var animation = $AnimationPlayer



func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")		
	)
	
	if input_direction.x == 1:
		$Sprite2D.flip_h = false
		animation.play("walking")
	elif input_direction.x == -1:
		$Sprite2D.flip_h = true
		animation.play("walking")
	elif input_direction.y == 1 || input_direction.y == -1:
		animation.play("walking")
	else:
		animation.play("idle")
	
	velocity = input_direction * move_speed
	
	move_and_slide()
