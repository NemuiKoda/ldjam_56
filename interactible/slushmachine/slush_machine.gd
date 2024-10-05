extends Node2D

@export var blue_slime = 0
@export var red_slime = 0
@export var green_slime = 0
@export var isProducing = false
@export var finishedProduct = false

@onready var slushLabel = $ColorRect/slushColors

func _ready():
	slushLabel.text = ("Blue: "+str(blue_slime)+" Red: "+str(red_slime)+" Green: "+str(green_slime)+" isProducing: "+str(isProducing)+" finishedProduct: "+str(finishedProduct))

func _process(delta: float):
	slushLabel.text = ("Blue: "+str(blue_slime)+" Red: "+str(red_slime)+" Green: "+str(green_slime)+" isProducing: "+str(isProducing)+" finishedProduct: "+str(finishedProduct))
