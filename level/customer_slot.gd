extends Node2D

var is_occupied = false
var occupied_by = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_customer_slot_area_body_entered(body: Node2D) -> void:
	print("NOW OCCUPIED")
	if !is_occupied and occupied_by != body:
		is_occupied = true
		occupied_by = body
	else:
		("ALREADY OCCUPIED")

func _on_customer_slot_area_body_exited(body: Node2D) -> void:
	print("NOW UNOCCUPIED")
	if is_occupied and body == occupied_by:
		is_occupied = false
		occupied_by = null
	else:
		print("NOT OCCUPATOR")
