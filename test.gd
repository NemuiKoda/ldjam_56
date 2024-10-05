extends Node2D

var customers = []
const CUSTOMER = preload("res://entitys/customer/customer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	spawn_customer() # Replace with function body.

func spawn_customer():
	var customer2 = CUSTOMER.instantiate()
	get_parent().add_child(customer2)
	customers.append(customer2)
	


func _on_timer_2_timeout() -> void:
	var customer = choose(customers)
	customer.receive_order()
	
func choose(array):
	array.shuffle()
	return array.front()
