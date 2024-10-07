extends CharacterBody2D

@onready var animation = $AnimationPlayer

const speed = 100
var dir = Vector2.RIGHT
var rng = RandomNumberGenerator.new()
var skin_number = rng.randi_range(1,5)

var current_state = WALKING
enum {
	IDLE,
	WALKING
}

var slushy_requests = [
	["BLUE", 10],
	["RED", 11],
	["GREEN", 12],
	["PURPLE", 20],
	["CYAN", 21],
	["YELLOW", 22],
	["WHITE", 30]
]

var is_in_slot = false
@export var received_order = false
@export var order = ""
@export var value = 0

func getReceivedOrder():
	return received_order

func setReceivedOrder(boolean):
	received_order = boolean

func getOrder():
	return order[0]
	
func getValue():
	return value

var slot

var leaving = false

var customer_slots

signal unit_removed

func _ready():
	$enter.play()
	randomize()
	customer_slots = get_tree().get_root().get_node("World/CustomerSlots")
	slot = get_slot()
	order = choose(slushy_requests)
	$InteractionComponents/InteractArea.interact_label = order[0]
	value = order[1]
	if rng.randi_range(0,1)==1:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

func _process(delta: float):
	if is_in_slot && !received_order:
		animation.play("customer"+ str(skin_number) +"_idle")
	else:
		animation.play("customer"+ str(skin_number) +"_walking")
	
	if received_order:
		leave()
		animation.speed_scale = 0.5
		
	if !is_in_slot:
		if slot and !is_in_slot:
			dir = global_position.direction_to(slot.global_position)
			position += dir * speed * delta
			if global_position.distance_to(slot.global_position) < 1:
				is_in_slot = true

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
	
func receive_order():
	received_order = true;

func leave():
	position += Vector2(0,100) * speed * 0.00006
	if !leaving:
		if rng.randi_range(0,1)==1:
			$yeah.play()
		else:
			$yippi.play()
		emit_signal("unit_removed")
		leaving = true
	if global_position.y > 500:
		("I'M LEAVING")
		self.queue_free()

func _on_timer_timeout() -> void:
	#received_order = true
	#leave
	pass
