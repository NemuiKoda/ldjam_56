extends Control

@onready var label = $PanelContainer/MarginContainer/VBoxContainer/Label2

var rent = 99999

func _process(delta):
	label.text = str(rent)
