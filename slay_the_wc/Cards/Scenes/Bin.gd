extends Node2D

const CARD_SCENE_PATH = "res://slay_the_wc/Cards/Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2

var player_bin = []

func _ready() -> void:
	$RichTextLabel.text = str(player_bin.size())
