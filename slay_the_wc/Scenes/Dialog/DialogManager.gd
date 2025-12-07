extends Node

@onready var text_box_scene = preload("res://slay_the_wc/Scenes/Dialog/TextBox.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box
var text_box_position: Vector2

var is_dialog_active = false
var can_advance_line = false

func start_dialog(position: Vector2, lines: Array[String]):
	if is_dialog_active:
		return
	dialog_lines = lines
	text_box_position = position
	_show_text_box()
	
	is_dialog_active = true

func _show_text_box():
	await get_tree().process_frame
	text_box = text_box_scene.instantiate()
	# Connecter l'événement "cliqué dans la zone"
	#text_box.clicked_inside.connect(_on_text_box_clicked)
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	#await text_box.ready
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true
	
func skip_all_dialog():
	if text_box:
		text_box.queue_free()
	is_dialog_active = false
	current_line_index = 0
	
#func _on_text_box_clicked():
	#if is_dialog_active and can_advance_line:
		#_advance_dialog()
#
#func _advance_dialog():
	#text_box.queue_free()
	#current_line_index += 1
#
	#if current_line_index >= dialog_lines.size():
		#is_dialog_active = false
		#current_line_index = 0
		#return
	#
	#_show_text_box()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog") && is_dialog_active && can_advance_line:
		text_box.queue_free()
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			return
		_show_text_box()
