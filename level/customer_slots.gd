extends Node2D

@onready
var customer_slots = [%CustomerSlot, %CustomerSlot2, %CustomerSlot3, %CustomerSlot4]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_free_slots():
	print("Entered get_free_slots() in customer_slots")
	var open_slots = []
	for slot in customer_slots:
		if slot.is_occupied:
			print("occupied")
		else:
			open_slots.append(slot)
			print("!occupied")
			
	return open_slots
