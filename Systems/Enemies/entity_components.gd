extends Node

class_name Entity_components

var name_label : RichTextLabel
var health_label : RichTextLabel
var defense_label : RichTextLabel
var sprite : TextureRect
var defense_icon : Sprite2D
var health_bar : ProgressBar

func turn_ui_off():
	change_ui_state(false)

func turn_ui_on():
	change_ui_state(true)

func change_ui_state(visibility: bool):
	name_label.visible = visibility
	health_label.visible = visibility
	defense_label.visible = visibility
	sprite.visible = visibility
	defense_icon.visible = visibility
	health_bar.visible = visibility
