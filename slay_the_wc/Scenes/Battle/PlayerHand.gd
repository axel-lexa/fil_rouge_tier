extends Node2D

#const CARD_WIDTH = 120
const HAND_Y_POSITION = 740
const DEFAULT_CARD_MOVE_SPEED = 0.1
const RADIUS = 350.0
const MAX_ANGLE = 25.0
const MAX_HAND_SIZE = 5
signal hand_size_changed(size)


var player_hand = []
var center_screen_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x/2
	

func add_card_to_hand(card, speed):
	if player_hand.size() >= MAX_HAND_SIZE:
		return
	if card not in player_hand:
		player_hand.append(card)
		update_hand_position(speed)
		emit_signal("hand_size_changed", player_hand.size())
	else:
		animate_card_to_position(card, card.starting_position, speed, null)
	
func update_hand_position(speed):
	var count = player_hand.size()
	if count == 0:
		return

	# Calcul de l’angle entre chaque carte
	var angle_step = 0.0
	if count > 1:
		angle_step = deg_to_rad(MAX_ANGLE * 2) / float(count - 1)
	var start_angle = -deg_to_rad(MAX_ANGLE)
	for i in range(count):
		var angle = start_angle + i*angle_step
		var pos = Vector2(center_screen_x + RADIUS * sin(angle),HAND_Y_POSITION + RADIUS * (1 - cos(angle)))
		var rot = angle * 0.3
		var card = player_hand[i]
		card.starting_position = pos
		animate_card_to_position(card, pos, speed, rot)
		
func animate_card_to_position(card, new_position, speed, rotation):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

	if rotation != null:
		tween.parallel().tween_property(card, "rotation", rotation, speed)
		
func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_position(DEFAULT_CARD_MOVE_SPEED)
		emit_signal("hand_size_changed", player_hand.size())
