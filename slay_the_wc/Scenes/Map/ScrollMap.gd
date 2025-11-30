extends ScrollContainer


var dragging = false
var last_mouse_pos = Vector2.ZERO

func _ready():
	await get_tree().process_frame
	scroll_vertical = get_v_scroll_bar().max_value

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			last_mouse_pos = event.position

	if dragging and event is InputEventMouseMotion:
		var delta = event.position - last_mouse_pos
		last_mouse_pos = event.position

		# On inverse delta.y car monter = scroll négatif
		scroll_vertical -= delta.y
