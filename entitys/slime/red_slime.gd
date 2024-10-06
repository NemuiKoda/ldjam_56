extends CharacterBody2D

@onready var player = get_node("/root/World/Player")
@onready var animation = $AnimationPlayer
 
var speed = 400
signal unit_removed

var in_jump = false
var rng = RandomNumberGenerator.new()

func _physics_process(_delta):
	# moving logic
	if !in_jump:
		var distance = global_position.distance_to(player.global_position)
		# Alert, player is close
		if distance < 200:
			var direction = global_position.direction_to(player.global_position)
			animation.play("jump")
			
			if rng.randf()<0.7:
				velocity = -direction * speed
			else:
				velocity = direction * (speed + 150)
		# Idle jumping
		else:
			animation.play("jump")
			velocity = Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1)) * randf_range(20,200)

	if in_jump:
		move_and_slide()

func jump():
	set_collision_layer_value(1, !get_collision_layer_value(1))
	in_jump = !in_jump
	
func deleteSlime():
	emit_signal("unit_removed")
	self.queue_free()
