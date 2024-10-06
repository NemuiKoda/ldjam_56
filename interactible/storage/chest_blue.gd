extends Node2D

@export var blue_slime_stored = 0

@onready var storagelabel = $CollisionShape2D/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	storagelabel.text = ("Blue Slime: " + str(blue_slime_stored))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	storagelabel.text = ("Blue Slime: " + str(blue_slime_stored))
