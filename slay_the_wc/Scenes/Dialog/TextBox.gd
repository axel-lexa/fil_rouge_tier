extends MarginContainer

@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $LetterDisplayTimer

signal clicked_inside

const MAX_WIDTH = 1400

var text = ""
var letter_index = 0

var letter_time = 0.01
var space_time = 0.006
var punctuation_time = 0.02
var is_skipping = false

signal finished_displaying()

signal skip_dialog

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if letter_index < text.length():
			# Le texte n'est pas encore fini → on skip
			is_skipping = true
			_show_full_text()
		# On émet un signal pour dire "clic dans la boîte"
		else:
			emit_signal("clicked_inside")


func _ready():
	print("gjfdgkdfmhttrfhtf")

func display_text(text_to_display: String):
	print_tree_pretty()
	print(label)
	print(timer)
	text = text_to_display
	label.text = text_to_display
	
	await resized
	custom_minimum_size.x = MAX_WIDTH #min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	label.text = ""
	_display_letter()
	
func _display_letter():
	label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
	
func _on_letter_display_timer_timeout() -> void:
	_display_letter()
	
func _show_full_text():
	timer.stop()
	label.text = text
	letter_index = text.length()
	finished_displaying.emit()
