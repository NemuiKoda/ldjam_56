extends Node2D

@export var green_slime_stored = 0

@onready var storagelabel = $CollisionShape2D/LabelGreen

# Called when the node enters the scene tree for the first time.
func _ready():
	storagelabel.text = ("Green Slime: " + str(green_slime_stored))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	storagelabel.text = ("Green Slime: " + str(green_slime_stored))
