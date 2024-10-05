extends Node2D

var is_occupied = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_is_occupied() -> bool:
	return is_occupied

func _on_customer_slot_area_body_entered(body: Node2D) -> void:
	is_occupied = true

func _on_customer_slot_area_body_exited(body: Node2D) -> void:
	is_occupied = false
