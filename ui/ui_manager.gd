extends Node

@onready var player_money_label: Label = %Money.get_node("%MoneyLabel")

@onready var blue_slushy_label: Label = %Slushies.get_node("%BlueLabel")
@onready var red_slushy_label: Label = %Slushies.get_node("%RedLabel")
@onready var green_slushy_label: Label = %Slushies.get_node("%GreenLabel")
@onready var cyan_slushy_label: Label = %Slushies.get_node("%CyanLabel")
@onready var purple_slushy_label: Label = %Slushies.get_node("%PurpleLabel")
@onready var yellow_slushy_label: Label = %Slushies.get_node("%YellowLabel")
@onready var white_slushy_label: Label = %Slushies.get_node("%WhiteLabel")

@onready var player_upgrade_label: Label = %Upgrades.get_node("%PlayerUpgradeLabel2")
@onready var machine_upgrade_label: Label = %Upgrades.get_node("%MachineUpgradeLabel2")
@onready var customer_upgrade_label: Label = %Upgrades.get_node("%CustomerUpgradeLabel2")

@onready var rent_timer = $UiElements/RentTimer
@onready var rentcost = $UiElements/RentCost

var blue_count: int
var red_count: int
var green_count: int
var cyan_count: int
var purple_count: int
var yellow_count: int
var white_count: int

var money: int

var player_level: int
var machine_level: int
var customer_level: int

func _process(delta) -> void:
	player_money_label.text = str(money)
	
	blue_slushy_label.text = str(blue_count)
	red_slushy_label.text = str(red_count)
	green_slushy_label.text = str(green_count)
	cyan_slushy_label.text = str(cyan_count)
	purple_slushy_label.text = str(purple_count)
	yellow_slushy_label.text = str(yellow_count)
	white_slushy_label.text = str(white_count)
	
	player_upgrade_label.text = str(player_level)
	machine_upgrade_label.text = str(machine_level)
	customer_upgrade_label.text = str(customer_level)


func set_timer(timer):
	rent_timer.set_player_timer(timer)
	
func rent_cost(rent):
	rentcost.rent = rent
	
	
# =========================================== Money
	
func set_money(value: int):
	money = value

# =========================================== Upgrades
	
func set_player_level(level: int):
	player_level = level

func set_machine_level(level: int):
	machine_level = level
	machine_upgrade_label.text = str(level)
	
func set_customer_level(level: int):
	customer_level = level
	customer_upgrade_label.text = str(level)
	
# =========================================== Slushies
	
func set_blue_count(blue_count: int):
	self.blue_count = blue_count
	
func set_red_count(red_count: int):
	self.red_count = red_count

func set_green_count(green_count: int):
	self.green_count = green_count

func set_cyan_count(cyan_count: int):
	self.cyan_count = cyan_count

func set_purple_count(purple_count: int):
	self.purple_count = purple_count

func set_yellow_count(yellow_count: int):
	self.yellow_count = yellow_count

func set_white_count(white_count: int):
	self.white_count = white_count

	
