extends CharacterBody2D

@export var move_speed : float = 250
@onready var animation = $AnimationPlayer
@onready var all_interactions = []
@onready var interactLabel = $"Interaction components/InteractLabel"
@onready var slush_machine = $"../slushMachine"
@onready var chest_blue = $"../ChestBlue"
@onready var chest_red = $"../ChestRed"
@onready var chest_green = $"../ChestGreen"
@onready var slushy_production_location = $"../Slushyspawn"

#inventory
var slushy_inventory = [0,0,0,0,0,0,0] #[blue,red,green,cyan,yellow,purple,white]
var money = 0



var carrying_slime = false
var slimeColor = ""
var catch_mode = false
var catching = false

func _ready():
	update_interactions()

func _process(_delta):	
	if Input.is_action_pressed("catch"):
		if catch_mode:
			animation.play("catch")
			catching = true

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")		
	)
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	if Input.is_action_just_pressed("interact2"):
		execute_interaction2()
	
	# Animation
	if !catching:
		if input_direction.x == 1:
			$Sprite2D.flip_h = false
			if catch_mode:
				animation.play("walking_net")
			else:
				animation.play("walking")
				
		elif input_direction.x == -1:
			$Sprite2D.flip_h = true
			if catch_mode:
				animation.play("walking_net")
			else:
				animation.play("walking")
		elif input_direction.y == 1 || input_direction.y == -1:
			if catch_mode:
				animation.play("walking_net")
			else:
				animation.play("walking")
		else:
			if catch_mode:
				animation.play("idle_net")
			else:
				animation.play("idle")
	
	velocity = input_direction * move_speed
	
	move_and_slide()

func catching_end():
	catching = false

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
			"slime" : 
				if carrying_slime == false:
					animation.play("catch")
					print("catch")
					match cur_interaction.interact_value:
						"blue" : slimeColor = "blue"
						"red" : slimeColor = "red"
						"green" : slimeColor = "green" 
					carrying_slime = true
					cur_interaction.get_parent().deleteSlime()
			"slushMachine" : 
				if carrying_slime == true:
					print("Add Slime to Machine")
					match slimeColor:
						"blue" : 
							if (slush_machine.blue_slime > 0):
								print("Machine allready full with blue slime")
								return
							else:
								slush_machine.blue_slime +=1
						"red" : 
							if(slush_machine.red_slime > 0):
								print("Machine allready full with red slime")
								return
							else:
								slush_machine.red_slime += 1
						"green" : 
							if(slush_machine.green_slime > 0):
								print("Machine allready full with green slime")
								return
							else:
								slush_machine.green_slime +=1
					carrying_slime = false
			"storage" :
				if carrying_slime == true:
					match cur_interaction.interact_value:
						"chest_blue": 
							if slimeColor == "blue":
								var blue_slime_instance = preload("res://entitys/slime/blue_slime.tscn").instantiate()
								chest_blue.add_child(blue_slime_instance)
								chest_blue.blue_slime_stored += 1
								carrying_slime = false
						"chest_red": 
							if slimeColor == "red":
								var red_slime_instance = preload("res://entitys/slime/red_slime.tscn").instantiate()
								chest_red.add_child(red_slime_instance)
								chest_red.red_slime_stored += 1
								carrying_slime = false
						"chest_green": 
							if slimeColor == "green":
								var green_slime_instance = preload("res://entitys/slime/green_slime.tscn").instantiate()
								chest_green.add_child(green_slime_instance)
								chest_green.green_slime_stored += 1
								carrying_slime = false
					return
				else:
					match cur_interaction.interact_value:
						"chest_blue": 
							if chest_blue.blue_slime_stored >= 1:
								chest_blue.get_child(chest_blue.get_children().size()-1).queue_free()
								chest_blue.blue_slime_stored -= 1
								carrying_slime = true
								slimeColor = "blue"
						"chest_red": 
							if chest_red.red_slime_stored >= 1:
								chest_red.get_child(chest_red.get_children().size()-1).queue_free()
								chest_red.red_slime_stored -= 1
								carrying_slime = true
								slimeColor = "red"
						"chest_green":
							if chest_green.green_slime_stored >= 1:
								chest_green.get_child(chest_green.get_children().size()-1).queue_free()
								chest_green.green_slime_stored -= 1
								carrying_slime = true
								slimeColor = "green"
			"item": 
				match cur_interaction.interact_value:
					#[blue,red,green,cyan,yellow,purple,white]
					"blue_slushy": slushy_inventory[0] = slushy_inventory[0] + 1
					"red_slushy": slushy_inventory[1] = slushy_inventory[1] + 1
					"green_slushy": slushy_inventory[2] = slushy_inventory[2] + 1
					"cyan_slushy": slushy_inventory[3] = slushy_inventory[3] + 1
					"yellow_slushy": slushy_inventory[4] = slushy_inventory[4] + 1
					"purple_slushy": slushy_inventory[5] = slushy_inventory[5] + 1
					"white_slushy": slushy_inventory[6] = slushy_inventory[6] + 1
				cur_interaction.get_parent().queue_free()
			"customer":
				if cur_interaction.get_parent().get_parent().getReceivedOrder() == true:
					return
				else:
					match cur_interaction.get_parent().get_parent().getOrder():
						"BLUE": 
							if slushy_inventory[0] > 0:
								slushy_inventory[0] = slushy_inventory[0] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
						"RED":
							if slushy_inventory[1] > 0:
								slushy_inventory[1] = slushy_inventory[1] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
						"GREEN":
							if slushy_inventory[2] > 0:
								slushy_inventory[2] = slushy_inventory[2] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
						"CYAN": 
							if slushy_inventory[3] > 0:
								slushy_inventory[3] = slushy_inventory[3] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
						"YELLOW":
							if slushy_inventory[4] > 0:
								slushy_inventory[4] = slushy_inventory[4] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
						"PURPLE":
							if slushy_inventory[5] > 0:
								slushy_inventory[5] = slushy_inventory[5] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
						"WHITE":
							if slushy_inventory[6] > 0:
								slushy_inventory[6] = slushy_inventory[6] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
					money += cur_interaction.get_parent().get_parent().getValue()

func execute_interaction2():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"slushMachine":
				if carrying_slime == false and slush_machine.isProducing == false and (slush_machine.blue_slime != 0 or slush_machine.red_slime !=0 or slush_machine.green_slime != 0):
						startProduction()


func startProduction():
	slush_machine.isProducing = true
	if slush_machine.blue_slime == 0 and slush_machine.red_slime == 0 and slush_machine.green_slime == 1:
		runningProduction("green")
	if slush_machine.blue_slime == 0 and slush_machine.red_slime == 1 and slush_machine.green_slime == 0:
		runningProduction("red")
	if slush_machine.blue_slime == 0 and slush_machine.red_slime == 1 and slush_machine.green_slime == 1:
		runningProduction("yellow")
	if slush_machine.blue_slime == 1 and slush_machine.red_slime == 0 and slush_machine.green_slime == 0:
		runningProduction("blue") 
	if slush_machine.blue_slime == 1 and slush_machine.red_slime == 0 and slush_machine.green_slime == 1:
		runningProduction("cyan")
	if slush_machine.blue_slime == 1 and slush_machine.red_slime == 1 and slush_machine.green_slime == 0:
		runningProduction("purple")
	if slush_machine.blue_slime == 1 and slush_machine.red_slime == 1 and slush_machine.green_slime == 1:
		runningProduction("white")  
	slush_machine.blue_slime = 0
	slush_machine.red_slime = 0
	slush_machine.green_slime = 0
	
	
func runningProduction(color):
	print(str(color) + " slushy")
	#instances of Slushys
	match color:
		"blue":
			var slushy_blue_instance = preload("res://interactible/slushy/slushy_blue.tscn").instantiate()
			slushy_production_location.add_child(slushy_blue_instance)
		"red":
			var slushy_red_instance = preload("res://interactible/slushy/slushy_red.tscn").instantiate()
			slushy_production_location.add_child(slushy_red_instance)
		"green":
			var slushy_green_instance = preload("res://interactible/slushy/slushy_green.tscn").instantiate()
			slushy_production_location.add_child(slushy_green_instance)
		"cyan":
			var slushy_cyan_instance = preload("res://interactible/slushy/slushy_cyan.tscn").instantiate()
			slushy_production_location.add_child(slushy_cyan_instance)
		"yellow":
			var slushy_yellow_instance = preload("res://interactible/slushy/slushy_yellow.tscn").instantiate()
			slushy_production_location.add_child(slushy_yellow_instance)
		"purple":
			var slushy_purple_instance = preload("res://interactible/slushy/slushy_purple.tscn").instantiate()
			slushy_production_location.add_child(slushy_purple_instance)
		"white":
			var slushy_white_instance = preload("res://interactible/slushy/slushy_white.tscn").instantiate()
			slushy_production_location.add_child(slushy_white_instance)
	slush_machine.isProducing = false
