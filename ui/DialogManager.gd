extends Node

@onready var speech_bubble_scene = preload("res://ui/speech_bubbles/speech_bubble.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var speech_bubble
var speech_bubble_pos: Vector2

var is_dialog_active = false
var can_advance_line = false

var dialog_timer: Timer

signal dialog_finished

func _ready() -> void:
	dialog_timer = Timer.new()
	dialog_timer.one_shot = true
	dialog_timer.wait_time = 1.2
	dialog_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(dialog_timer)

func start_dialog(pos: Vector2, lines: Array[String]):
	if is_dialog_active:
		return
	
	dialog_lines = lines
	speech_bubble_pos = pos
	_show_speech_bubble()
	
	is_dialog_active = true
	
func _show_speech_bubble():
	speech_bubble = speech_bubble_scene.instantiate()
	speech_bubble.finished_displaying.connect(_on_speech_bubble_finished_displaying)
	get_tree().root.add_child(speech_bubble)
	speech_bubble.global_position = speech_bubble_pos
	speech_bubble.display_text(dialog_lines[current_line_index])
	can_advance_line = false
	
func _queue_free_speech_bubble():
	if !is_dialog_active:
		speech_bubble.queue_free()
	
func _on_speech_bubble_finished_displaying():
	can_advance_line = true
	
	if (
		is_dialog_active and
		can_advance_line
	):
		current_line_index += 1
		
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			emit_signal("dialog_finished")
			return
			
		dialog_timer.start()

#func _unhandled_input(event: InputEvent) -> void:
	#if (
		#event.is_action_pressed("advance_dialog") and 
		#is_dialog_active and
		#can_advance_line
	#):
		#speech_bubble.queue_free()
		#
		#current_line_index += 1
		#if current_line_index >= dialog_lines.size():
			#is_dialog_active = false
			#current_line_index = 0
			#return
		#
		#_show_speech_bubble()
func _on_timer_timeout():
	speech_bubble.queue_free()
	_show_speech_bubble()
