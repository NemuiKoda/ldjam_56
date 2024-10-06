extends Control

var value: int

@onready var money_label = %MoneyLabel

func set_value(value: int):
	self.value = value
	money_label.text = str(value)
	
func get_value():
	return value
