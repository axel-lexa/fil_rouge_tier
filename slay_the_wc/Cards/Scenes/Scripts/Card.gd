extends Node2D
class_name Card2

const BASE_SCALE = Vector2(1.2, 1.2)
const HOVER_SCALE = Vector2(1.3, 1.3)

signal hovered
signal hovered_off

var starting_position

@export var highlight_on_hover: bool = true
@export var data: CardData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UiCard.loadCardData(data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_mouse_entered():
	if (highlight_on_hover):
		hightlight_card(true)
	$HoverTimer.start()


func _on_mouse_exited():
	if (highlight_on_hover):
		hightlight_card(false)
	$HoverTimer.stop()
	emit_signal("hovered_off", self)

func _on_hover_timeout():
	emit_signal("hovered", self)

func hightlight_card(activate: bool):
	if activate:
		scale = HOVER_SCALE
		z_index = 2
	else:
		scale = BASE_SCALE
		z_index = 1
