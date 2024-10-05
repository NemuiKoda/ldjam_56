extends CharacterBody2D

const speed = 100
var dir = Vector2.RIGHT

var current_state = WALKING
enum {
	IDLE,
	WALKING
}

var is_waiting_to_order = false
var is_waiting_for_order = false
var received_order = false

var slot

var player
var player_in_chat_zone = false

@onready
var customer_slots = %CustomerSlots

func _ready():
	randomize()
	slot = get_slot()

func _process(delta: float):
	if current_state == 0:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2:
		if dir.x == -1:
			$AnimatedSprite2D.play("walk_w")
		if dir.x == 1:
			$AnimatedSprite2D.play("walk_e")
		if dir.y == -1:
			$AnimatedSprite2D.play("walk_n")
		if dir.y == 1:
			$AnimatedSprite2D.play("walk_s")

	if !is_waiting_to_order and !is_waiting_for_order:
		if slot:
			dir = global_position.direction_to(slot.global_position)
			print(dir)
			position += dir * speed * delta
			
func get_slot():
	var open_slots = customer_slots.get_free_slots()
	var selected
	if open_slots.size() > 0:
		selected = choose(open_slots)
		return selected
	else: 
		print("No open slots")

func choose(array):
	array.shuffle()
	return array.front()

func leave(delta):
	position += Vector2(-200,-200) * speed * delta
	# self.queue_free()
