extends Node2D

@onready var label = $CanvasLayer/PanelContainer/MarginContainer/Label
@onready var box = $CanvasLayer/PanelContainer

const base_text_e = "[E] to "
const base_text_f = "[F] to "
const base_text_u = "[U] to "

var active_areas = []
var can_interact = true

func _process(delta: float) -> void:
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		match active_areas[0].action_name:
			"sell" , "catch", "pick up":
				label.text = base_text_e + active_areas[0].action_name
			"slusher":
				label.text = "[E] to add slime \n [F] to start machine \n [U] to upgrade machine"
			"start":
				label.text = base_text_f + active_areas[0].action_name
			"upgrade":
				label.text = base_text_u + active_areas[0].action_name
		#box.global_position = player.global_position
		#box.global_position.y -= 64
		#box.global_position.x -= box.size.x / 2
		box.show()
	else:
		box.hide()
		
func _sort_by_distance_to_player(area1, area2):
	if area1 and area2:
		var player = get_node("/root/World/Player")
		var area1_to_player = player.global_position.distance_to(area1.global_position)
		var area2_to_player = player.global_position.distance_to(area2.global_position)
		return area1_to_player < area2_to_player

func register_area(area: InteractionArea):
	print("AREA REGISTERED ===========================")
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		print("AREA UNREGISTERED ===========================")
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			box.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
