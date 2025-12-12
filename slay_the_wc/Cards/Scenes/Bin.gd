extends Node2D

const CARD_SCENE_PATH = "res://slay_the_wc/Cards/Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2

var player_bin: Array[Card2] = []

func _ready() -> void:
	$RichTextLabel.text = str(player_bin.size())
	
#Ajout CKC
func add_to_bin(card:Card2) : 
	player_bin.append(card)
