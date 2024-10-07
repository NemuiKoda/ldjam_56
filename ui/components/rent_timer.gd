extends Control

@onready var label = $PanelContainer/MarginContainer/VBoxContainer/Label2
@onready var timer = $PanelContainer/MarginContainer/VBoxContainer/Timer

func _ready() -> void:
	timer.start()
	
func _process(delta):
	label.text = "%02d:%02d" % time_left_till_rent()

func time_left_till_rent():
	var time_left = timer.time_left
	var minute = floor(time_left/60)
	var second = int(time_left) % 60
	return [minute, second]
	
