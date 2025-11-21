extends Node2D

const COLLISION_MASK_CARD = 1

var card_being_dragged
var screen_size
var is_hovering_on_card

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("Left Click")
			var card = raycast_check()
			if card:
				card_being_dragged = card
		else:
			print("Left click released")
			card_being_dragged = null
		print("Click, click, I love the movie Click from Adam Sandler")
		
func raycast_check():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_viewport().get_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size()>0:
		return result[0].collider.get_parent()
	return null
	
func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	
func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)
	print("hovered on", card.scale)
	
func on_hovered_off_card(card):
	var potential_card_hovered = raycast_check()
	
	if potential_card_hovered and potential_card_hovered != card:
		
		print("other card to hover over", potential_card_hovered)
		print(potential_card_hovered.scale)
		highlight_card(card, false)
		is_hovering_on_card = false
		on_hovered_over_card(potential_card_hovered)
	else:
		print("stop hovering", card)
		highlight_card(card, false)
		is_hovering_on_card = false
		
	print("hovered off")
	
func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.global_position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
		clamp(mouse_pos.y, 0, screen_size.y))
