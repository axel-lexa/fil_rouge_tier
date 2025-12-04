extends Node2D
class_name Card2

const BASE_SCALE = Vector2(1.2, 1.2)
const HOVER_SCALE = Vector2(1.3, 1.3)


signal hovered
signal hovered_off

var starting_position
var is_zoomed = false
var is_hovering = false


@export var data: CardData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().root.get_node("Battle/CardManager").connect_card_signals(self)
	$NameLabel.text = data.card_name
	$CostLabel.text = str(data.mana_cost)
	$TextLabel.text = data.description
	$CardImage.texture = data.background
	$TextureRect.texture = data.background
	$Area2D.mouse_entered.connect(_on_mouse_entered)
	$Area2D.mouse_exited.connect(_on_mouse_exited)
	$HoverTimer.timeout.connect(_on_hover_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

func _on_mouse_entered():
	is_hovering = true
	$HoverTimer.start()


func _on_mouse_exited():
	is_hovering = false
	$HoverTimer.stop()
	hide_hd_card()


func _on_hover_timeout():
	if is_hovering:
		show_hd_card()


# Affiche la carte HD
func show_hd_card():
	var zoom = get_tree().root.get_node("Battle/CardZoom")
	zoom.show_card(data)  # ici data contient l'image complète HD

# Cache la carte HD
func hide_hd_card():
	var zoom = get_tree().root.get_node("Battle/CardZoom")
	zoom.hide_card()
