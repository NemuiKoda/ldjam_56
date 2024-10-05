extends CharacterBody2D

@export var move_speed : float = 250
@onready var animation = $AnimationPlayer
@onready var all_interactions = []
@onready var interactLabel = $"Interaction components/InteractLabel"

var carrying_slime = false
var blue_slime_inventory = 0
var red_slime_inventory = 0
var green_slime_inventory = 0

func _ready():
	update_interactions()

func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")		
	)
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	
	if input_direction.x == 1:
		$Sprite2D.flip_h = false
		animation.play("walking")
	elif input_direction.x == -1:
		$Sprite2D.flip_h = true
		animation.play("walking")
	elif input_direction.y == 1 || input_direction.y == -1:
		animation.play("walking")
	else:
		animation.play("idle")
	
	velocity = input_direction * move_speed
	
	move_and_slide()

#Interactionmethods
######################################################################

func _on_interaction_area_area_entered(area: Area2D) -> void:
	all_interactions.insert(0,area)
	update_interactions()


func _on_interaction_area_area_exited(area: Area2D) -> void:
	all_interactions.erase(area)
	update_interactions()

func update_interactions():
	if all_interactions:
		interactLabel.text = all_interactions[0].interact_label
	else: 
		interactLabel.text = ""

func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"print_text" : print(cur_interaction.interact_value)
			"blue_slime" : 
				print(str(carrying_slime) + " " + str(blue_slime_inventory))
				if carrying_slime == false:
					print(cur_interaction.interact_value)
					blue_slime_inventory += 1
					carrying_slime = true
					cur_interaction.get_parent().queue_free()
					print(str(carrying_slime) + " " + str(blue_slime_inventory))
				
				 
