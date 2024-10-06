extends Control

var player_level: int
var machine_level: int
var customer_level: int

@onready var player_upgrade_label = %PlayerUpgradeLabel2
@onready var machine_upgrade_label = %MachineUpgradeLabel2
@onready var customer_upgrade_label = %CustomerUpgradeLabel2

func set_player_level(level: int):
	player_level = level
	player_upgrade_label.text = str(level)
	
func get_player_level():
	return player_level

func set_machine_level(level: int):
	machine_level = level
	machine_upgrade_label.text = str(level)
	
func get_machine_level():
	return machine_level

func set_customer_level(level: int):
	customer_level = level
	customer_upgrade_label.text = str(level)
	
func get_customer_level():
	return customer_level
