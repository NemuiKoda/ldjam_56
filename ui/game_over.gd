extends Control

func _ready():
	$VBoxContainer/Restart.grab_focus()
	var time_survived = round_place(global.time_survived/60, 2)
	$VBoxContainer2/stats.text = "Time Survived: " + str(time_survived) + "m\nSlushies Sold: " + str(global.slushies_sold)
	UiManager.get_node("/root/UiManager/UiElements").visible = false


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://level/main.tscn")	
	UiManager.get_node("/root/UiManager/UiElements").visible = true


func _on_quit_pressed():
	get_tree().quit()

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://ui/Menu.tscn")	
