extends CharacterBody2D

@export var move_speed : float = 250
@onready var animation = $AnimationPlayer
@onready var slushy_machine_timer = $slushy_machine_timer
@onready var all_interactions = []
@onready var interactLabel = $"Interaction components/InteractLabel"
@onready var slush_machine = $"../slushMachine"
@onready var container_left = $"../slushMachine/container_left/AnimationPlayer"
@onready var container_middle = $"../slushMachine/container_middle/AnimationPlayer"
@onready var container_right = $"../slushMachine/container_right/AnimationPlayer"
@onready var container_left_time = $"../slushMachine/container_left"
@onready var container_middle_time = $"../slushMachine/container_middle"
@onready var container_right_time = $"../slushMachine/container_right"
@onready var chest_blue = $"../ChestBlue"
@onready var chest_red = $"../ChestRed"
@onready var chest_green = $"../ChestGreen"
@onready var slushy_production_location = $"../Slushyspawn"
@onready var inside = $"../Inside"
@onready var customerSpawner = $"../Spawner"

#Inventory
var slushy_inventory = [0,0,0,0,0,0,0] #[blue,red,green,cyan,yellow,purple,white]
var money = 150
var rent = 50

var time_start = 0
var slushies_sold = 0

#Upgrades
var maxmovementupgrade = 3
var movementLevel = 0
var movementupgrade= [
	[0, 250],
	[50, 350],
	[100, 450],
	[150, 550]
]


var maxcustomeupgrader = 3
var customerLevel = 0
var customerupgrade= [
	[0, 1],
	[25, 2],
	[100, 3],
	[150, 4]
]

var maxproductionupgrades= 2
var productionLevel = 0
var productionupgrade= [
	[0, 0.33],
	[50, 0.66],
	[100, 1.00]
]

var carrying_slime = false
var slimeColor = ""
var catch_mode = false
var catching = false
var color_to_produce = "blue"

func _ready():
	update_interactions()
	time_start = Time.get_unix_time_from_system()
	print(time_start)


func _process(_delta: float):
	UiManager.set_money(money)
	UiManager.set_blue_count(slushy_inventory[0])
	UiManager.set_red_count(slushy_inventory[1])
	UiManager.set_green_count(slushy_inventory[2])
	UiManager.set_cyan_count(slushy_inventory[3])
	UiManager.set_yellow_count(slushy_inventory[4])
	UiManager.set_purple_count(slushy_inventory[5])
	UiManager.set_white_count(slushy_inventory[6])
	customerSpawner.spawn_units_max_amount = customerupgrade[customerLevel][1]
	slushy_machine_timer.wait_time = (6/productionupgrade[productionLevel][1])
	container_left_time.set_animation_speed(productionupgrade[productionLevel][1])
	container_middle_time.set_animation_speed(productionupgrade[productionLevel][1])
	container_right_time.set_animation_speed(productionupgrade[productionLevel][1])

func play_walking_animation():
	if !carrying_slime:
		if catch_mode:
			$Sprite2D.visible = true
			$SpriteWalkingSlime.visible = false
			animation.play("walking_net")
		else:
			$Sprite2D.visible = true
			$SpriteWalkingSlime.visible = false
			animation.play("walking_nothing")
	else:
		$Sprite2D.visible = false
		$SpriteWalkingSlime.visible = true
		if slimeColor == "blue":
			animation.play("walking_blue")
		elif slimeColor == "green":
			animation.play("walking_green")
		elif slimeColor == "red":
			animation.play("walking_red")

func play_idle_animation():
	if !carrying_slime:
		$Sprite2D.visible = true
		$SpriteWalkingSlime.visible = false
		if catch_mode:
			animation.play("idle_net")
		else:
			animation.play("idle_nothing")
	else:
		$Sprite2D.visible = false
		$SpriteWalkingSlime.visible = true
		if slimeColor == "blue":
			animation.play("idle_blue")
		elif slimeColor == "green":
			animation.play("idle_green")
		elif slimeColor == "red":
			animation.play("idle_red")

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")		
	)
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	if Input.is_action_just_pressed("interact2"):
		execute_interaction2()
	if Input.is_action_just_pressed("interact3"):
		execute_interaction3()
	
	# Animation
	if !catching:
		if input_direction.x == 1:
			if !carrying_slime:
				$Sprite2D.flip_h = false
			else:
				$SpriteWalkingSlime.flip_h = false
			play_walking_animation()
		elif input_direction.x == -1:
			if !carrying_slime:
				$Sprite2D.flip_h = true
			else:
				$SpriteWalkingSlime.flip_h = true
			play_walking_animation()
		elif input_direction.y == 1 || input_direction.y == -1:
			play_walking_animation()
		else:
			play_idle_animation()
	
	velocity = input_direction * move_speed
	
	move_and_slide()

func catching_end():
	catching = false

func game_over():	
	get_tree().change_scene_to_file("res://ui/game_over.tscn")

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
	if catch_mode && !carrying_slime:
		animation.play("catch")
		catching = true
	if all_interactions:
		var cur_interaction = all_interactions[0]
		var i = 0
		for interaction in all_interactions:
			if interaction.interact_type == "item":
				cur_interaction = all_interactions[i]
				break
			i += 1
		
		match cur_interaction.interact_type:
			"slime" :
					if carrying_slime == false and catch_mode:
						print("catch")
						match cur_interaction.interact_value:
							"blue" : slimeColor = "blue"
							"red" : slimeColor = "red"
							"green" : slimeColor = "green" 
						carrying_slime = true
						cur_interaction.get_parent().deleteSlime()
			"slushMachine" : 
				if carrying_slime == true && !slush_machine.isProducing:
					print("Add Slime to Machine")
					match slimeColor:
						"blue" : 
							if (slush_machine.blue_slime > 0):
								print("Machine allready full with blue slime")
								return
							else:
								slush_machine.blue_slime +=1
								container_left.play("blue_full")
						"red" : 
							if(slush_machine.red_slime > 0):
								print("Machine allready full with red slime")
								return
							else:
								slush_machine.red_slime += 1
								container_middle.play("red_full")
						"green" : 
							if(slush_machine.green_slime > 0):
								print("Machine allready full with green slime")
								return
							else:
								slush_machine.green_slime +=1
								container_right.play("green_full")
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
				if cur_interaction.get_parent().get_parent().getReceivedOrder() or !cur_interaction.get_parent().get_parent().getDialogEnded():
					return
				else:
					match cur_interaction.get_parent().get_parent().getOrder():
						"BLUE": 
							if slushy_inventory[0] > 0:
								slushy_inventory[0] = slushy_inventory[0] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
								money += cur_interaction.get_parent().get_parent().getValue()
								slushies_sold += 1
						"RED":
							if slushy_inventory[1] > 0:
								slushy_inventory[1] = slushy_inventory[1] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
								money += cur_interaction.get_parent().get_parent().getValue()
								slushies_sold += 1
						"GREEN":
							if slushy_inventory[2] > 0:
								slushy_inventory[2] = slushy_inventory[2] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
								money += cur_interaction.get_parent().get_parent().getValue()
								slushies_sold += 1
						"CYAN": 
							if slushy_inventory[3] > 0:
								slushy_inventory[3] = slushy_inventory[3] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
								money += cur_interaction.get_parent().get_parent().getValue()
								slushies_sold += 1
						"YELLOW":
							if slushy_inventory[4] > 0:
								slushy_inventory[4] = slushy_inventory[4] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
								money += cur_interaction.get_parent().get_parent().getValue()
								slushies_sold += 1
						"PURPLE":
							if slushy_inventory[5] > 0:
								slushy_inventory[5] = slushy_inventory[5] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
								money += cur_interaction.get_parent().get_parent().getValue()
								slushies_sold += 1
						"WHITE":
							if slushy_inventory[6] > 0:
								slushy_inventory[6] = slushy_inventory[6] - 1
								cur_interaction.get_parent().get_parent().setReceivedOrder(true)
								money += cur_interaction.get_parent().get_parent().getValue()
								slushies_sold += 1

func execute_interaction2():
	print("F")
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"slushMachine":
				if slush_machine.isProducing == false and (slush_machine.blue_slime != 0 or slush_machine.red_slime !=0 or slush_machine.green_slime != 0):
						startProduction()

func execute_interaction3():
	print("U")
	if all_interactions:
		var i = 0
		var cur_interaction
		for interaction in all_interactions:
			if interaction.interact_type == "upgrade":
				cur_interaction = all_interactions[i]
				break
			i += 1
		if cur_interaction == null:
			print("no upgrade found")
			return
		print("upgrade found")
		match cur_interaction.interact_type:
			"upgrade":
				match cur_interaction.interact_value:
					"customerupgrade": 
						if customerLevel < maxcustomeupgrader:
							var cost = customerupgrade[customerLevel+1]
							if money >= cost[0]:
								customerLevel += 1
								money -= cost[0]
								print(str(customerLevel))
								UiManager.set_customer_level(customerLevel)
					"productionupgrade":
						if productionLevel < maxproductionupgrades:
							var cost = productionupgrade[productionLevel+1]
							if money >= cost[0] :
								productionLevel += 1
								money -= cost[0]
								print(str(productionLevel))
								UiManager.set_machine_level(productionLevel)
					"movementupgrade":
						print("MovementUpgrade")
						if movementLevel < maxmovementupgrade:
							var cost = movementupgrade[movementLevel+1]
							if money >= cost[0]:
								movementLevel += 1
								money -= cost[0]
								print(str(movementLevel))
								move_speed = movementupgrade[movementLevel][1]
								UiManager.set_player_level(movementLevel)

func startProduction():	
	slush_machine.isProducing = true
	slushy_machine_timer.start()
	print("TIMER STARTED")
	
	if slush_machine.blue_slime == 0 and slush_machine.red_slime == 0 and slush_machine.green_slime == 1:
		color_to_produce = "green"
		container_right.play("green")
	if slush_machine.blue_slime == 0 and slush_machine.red_slime == 1 and slush_machine.green_slime == 0:
		color_to_produce = "red"
		container_middle.play("red")
	if slush_machine.blue_slime == 0 and slush_machine.red_slime == 1 and slush_machine.green_slime == 1:
		color_to_produce = "yellow"
		container_right.play("green")
		container_middle.play("red")
	if slush_machine.blue_slime == 1 and slush_machine.red_slime == 0 and slush_machine.green_slime == 0:
		color_to_produce = "blue"
		container_left.play("blue")
	if slush_machine.blue_slime == 1 and slush_machine.red_slime == 0 and slush_machine.green_slime == 1:
		color_to_produce = "cyan"
		container_right.play("green")
		container_left.play("blue")
	if slush_machine.blue_slime == 1 and slush_machine.red_slime == 1 and slush_machine.green_slime == 0:
		color_to_produce = "purple"
		container_left.play("blue")
		container_middle.play("red")
	if slush_machine.blue_slime == 1 and slush_machine.red_slime == 1 and slush_machine.green_slime == 1:
		color_to_produce = "white"
		container_right.play("green")
		container_middle.play("red")
		container_left.play("blue")
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


func _on_inside_area_entered(_area: Area2D):
	print("Area entered")
	catch_mode = false


func _on_inside_area_exited(_area: Area2D):
	print("Area left")
	catch_mode = true


func _on_slushy_machine_timer_timeout():	
	runningProduction(color_to_produce)


func _on_rent_timer_timeout():
	if money < rent:
		print("GAME OVER")
		global.slushies_sold = slushies_sold
		global.time_survived = Time.get_unix_time_from_system() - time_start
		get_tree().change_scene_to_file("res://ui/game_over.tscn")
	else:
		print("RENT PAID")
		$rent_paid.play()
		money -= rent
		rent = rent + 50
