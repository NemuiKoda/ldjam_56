extends Node2D

@onready var player = get_node("/root/World/Player")
@onready var slush_noice = $slush_noice
@onready var generator_noice = $generator_noice
@onready var slushy_finished_noice = $slushy_finished_noice

@export var blue_slime = 0
@export var red_slime = 0
@export var green_slime = 0
@export var isProducing = false
@export var finishedProduct = false

@onready var slushLabel = $slushColors

func _ready():
	slushLabel.text = ("Blue: "+str(blue_slime)+" Red: "+str(red_slime)+" Green: "+str(green_slime)+" isProducing: "+str(isProducing)+" finishedProduct: "+str(finishedProduct))

func _process(_delta: float):
	slushLabel.text = ("Blue: "+str(blue_slime)+" Red: "+str(red_slime)+" Green: "+str(green_slime)+" isProducing: "+str(isProducing)+" finishedProduct: "+str(finishedProduct))
	
	
	#Audio
	if isProducing:
		if !slush_noice.playing:
			slush_noice.play()
		if !generator_noice.playing:
			generator_noice.play()
	else:
		if slush_noice.playing:
			slush_noice.stop()
			slushy_finished_noice.play()
		
		if generator_noice.playing:
			generator_noice.stop()
