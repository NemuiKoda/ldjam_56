extends CharacterBody2D

@onready var animation = $AnimationPlayer
@onready var interaction_area: InteractionArea = $InteractionArea

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

var lines: Array[String] = []

var blue_lines: Array[String] = [
	"Hey, how are you?",
	"Let me think.",
	"A BLUE Slushy is what I crave.",
	"BLUE"
]

var red_lines: Array[String] = [
	"Hey, how are you?",
	"Let me think.",
	"A RED Slushy is what I crave.",
	"RED"
]

var green_lines: Array[String] = [
	"Hey, how are you?",
	"Let me think.",
	"A GREEN Slushy is what I crave.",
	"GREEN"
]

var cyan_lines: Array[String] = [
	"Hey, how are you?",
	"Let me think.",
	"A CYAN Slushy is what I crave.",
	"CYAN"
]

var purple_lines: Array[String] = [
	"Hey, how are you?",
	"Let me think.",
	"A PURPLE Slushy is what I crave.",
	"PURPLE"
]

var yellow_lines: Array[String] = [
	"Hey, how are you?",
	"Let me think.",
	"A YELLOW Slushy is what I crave.",
	"YELLOW"
]

var white_lines: Array[String] = [
	"Hey, how are you?",
	"Let me think.",
	"A WHITE Slushy is what I crave.",
	"WHITE"
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

var dialog_ended = false

signal unit_removed

func _ready():
	randomize()
	#interaction_area.interact = Callable(self, "_on_interact")
	DialogManager.connect("dialog_finished", Callable(self, "_on_dialog_finished"))
	customer_slots = get_tree().get_root().get_node("World/CustomerSlots")
	slot = get_slot()
	order = choose(slushy_requests)
	
	match order[0]:
		"BLUE":
			lines = blue_lines
		"RED":
			lines = red_lines
		"GREEN":
			lines = green_lines
		"CYAN":
			lines = cyan_lines
		"PURPLE":
			lines = purple_lines
		"YELLOW":
			lines = yellow_lines
		"WHITE":
			lines = white_lines
		
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
	
	#if current_state == 0:
		#$AnimatedSprite2D.play("idle")
	#elif current_state == 1:
		#if dir.x == -1:
			#$AnimatedSprite2D.play("walk_w")
		#if dir.x == 1:
			#$AnimatedSprite2D.play("walk_e")
		#if dir.y == -1:
			#$AnimatedSprite2D.play("walk_n")
		#if dir.y == 1:
			#$AnimatedSprite2D.play("walk_s")
	
	if received_order:
		leave()
		animation.speed_scale = 0.5
		
	if !is_in_slot:
		if slot and !is_in_slot:
			dir = global_position.direction_to(slot.global_position)
			position += dir * speed * delta
			if global_position.distance_to(slot.global_position) < 1:
				is_in_slot = true
				DialogManager.start_dialog(global_position, lines)

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
	received_order = true
	
func getDialogEnded():
	return dialog_ended
	
func _on_dialog_finished():
	dialog_ended = true

func leave():
	position += Vector2(0,100) * speed * 0.00006
	if !leaving:
		DialogManager._queue_free_speech_bubble()
		emit_signal("unit_removed")
		leaving = true
	if global_position.y > 500:
		("I'M LEAVING")
		self.queue_free()
