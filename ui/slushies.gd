extends Control

var blue_count: int
var red_count: int
var green_count: int
var cyan_count: int
var purple_count: int
var yellow_count: int
var white_count: int

@onready var blue_label = %BlueLabel
@onready var red_label = %RedLabel
@onready var green_label = %GreenLabel
@onready var cyan_label = %CyanLabel
@onready var purple_label = %PurpleLabel
@onready var yellow_label = %YellowLabel
@onready var white_label = %WhiteLabel

func set_blue_count(blue_count: int):
	self.blue_count = blue_count
	blue_label.text = str(blue_count)

func get_blue_count():
	return blue_count
	
func set_red_count(red_count: int):
	self.red_count = red_count
	red_label.text = str(red_count)

func get_red_count():
	return red_count

func set_green_count(green_count: int):
	self.green_count = green_count
	green_label.text = str(green_count)

func get_green_count():
	return green_count

func set_cyan_count(cyan_count: int):
	self.cyan_count = cyan_count
	cyan_label.text = str(cyan_count)

func get_cyan_count():
	return cyan_count

func set_purple_count(purple_count: int):
	self.purple_count = purple_count
	purple_label.text = str(purple_count)

func get_purple_count():
	return purple_count

func set_yellow_count(blue_count: int):
	self.yellow_count = yellow_count
	yellow_label.text = str(yellow_count)

func get_yellow_count():
	return yellow_count

func set_white_count(white_count: int):
	self.white_count = white_count
	white_label.text = str(white_count)

func get_white_count():
	return white_count
