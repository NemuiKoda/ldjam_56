extends Control

func _ready():
	$VBoxContainer/Start.grab_focus()
	UiManager.get_node("/root/UiManager/UiElements").visible = false

func _on_start_pressed():
	get_tree().change_scene_to_file("res://level/main.tscn")
	UiManager.get_node("/root/UiManager/UiElements").visible = true

func _on_quit_pressed():
	get_tree().quit()

var music_index = AudioServer.get_bus_index("Music")
func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_index, value)

var sfx_index = AudioServer.get_bus_index("SFX")
func _on_h_slider_2_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_index, value)
