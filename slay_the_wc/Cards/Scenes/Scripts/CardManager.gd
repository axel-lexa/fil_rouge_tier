extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT_ENNEMY_1 = 2
const COLLISION_MASK_CARD_SLOT_ENNEMY_2 = 4
const COLLISION_MASK_CARD_SLOT_ENNEMY_3 = 8
const COLLISION_MASK_CARD_SLOT_PLAYER = 16
const DEFAULT_CARD_MOVE_SPEED = 0.1

var screen_size
var card_being_dragged: Card2
var is_hovering_on_card
var player_hand_reference


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), clamp(mouse_pos.y, 0, screen_size.y))

			
func start_drag(card):
	if not (card is Card2):
		return
	card_being_dragged = card
	#card.scale = Vector2(10, 10)
	
func finish_drag():
	if not card_being_dragged:
		return
	card_being_dragged.scale = Vector2(1.05, 1.05)
	var card_slot_found_ennemie1 = raycast_check_for_card_slot1()
	var card_slot_found_ennemie2 = raycast_check_for_card_slot2()
	var card_slot_found_ennemie3 = raycast_check_for_card_slot3()
	var card_slot_found_player = raycast_check_for_card_slot4()
	var battle = $".."
	
	if battle.player_turn and (battle.player.energy > 0 and battle.player.energy >= card_being_dragged.data.mana_cost) and ((card_slot_found_ennemie1 and not card_slot_found_ennemie1.card_in_slot) or (card_slot_found_ennemie2 and not card_slot_found_ennemie2.card_in_slot) or (card_slot_found_player and not card_slot_found_player.card_in_slot)):
		player_hand_reference.remove_card_from_hand(card_being_dragged)
		var ennemy_index = -1
		var player_slot = false
		if card_slot_found_ennemie1:
			card_being_dragged.position = card_slot_found_ennemie1.position
			ennemy_index = 0
		elif card_slot_found_ennemie2:
			card_being_dragged.position = card_slot_found_ennemie2.position
			ennemy_index = 1
		elif card_slot_found_ennemie3:
			card_being_dragged.position = card_slot_found_ennemie3.position
			ennemy_index = 2
		elif card_slot_found_player:
			card_being_dragged.position = card_slot_found_player.position
			player_slot = true
			
		card_being_dragged.rotation = 0

		#card_slot_found.card_in_slot = true
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		battle.battle(card_being_dragged, ennemy_index, player_slot)
	else:
		player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)

	card_being_dragged = null


func connect_card_signals(card):
	if not card is Card2:
		return;
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

func on_left_click_released():
	if card_being_dragged:
		finish_drag()

func on_hovered_over_card(card):
	if not card is Card2:
		return;
	if !is_hovering_on_card:
		is_hovering_on_card = true
		hightlight_card(card, true)
	
func on_hovered_off_card(card):
	if not card is Card2:
		return;
	if !card_being_dragged:
		hightlight_card(card, false)
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			hightlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false
	
func hightlight_card(card, hovered):
	if not card is Card2:
		return;
	if hovered:
		card.scale = card.HOVER_SCALE
		card.z_index = 2
	else:
		card.scale = card.BASE_SCALE
		card.z_index = 1
	

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var c = get_card_with_hightest_z_index(result)
		if c is Card2:
			return c
		#return get_card_with_hightest_z_index(result)
		#return result[0].collider.get_parent()
	return null
	
func raycast_check_for_card_slot1():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT_ENNEMY_1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null


func raycast_check_for_card_slot2():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT_ENNEMY_2
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null
	
func raycast_check_for_card_slot3():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT_ENNEMY_3
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null
	
func raycast_check_for_card_slot4():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT_PLAYER
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func get_card_with_hightest_z_index(cards):
	var hightest_z_card = cards[0].collider.get_parent()
	var hightest_z_index
	if not (hightest_z_card is Card2):
		hightest_z_card = null
		hightest_z_index = -9999 
	else:
		hightest_z_index = hightest_z_card.z_index
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > hightest_z_index:
			hightest_z_card = current_card
			hightest_z_index = current_card.z_index
	return hightest_z_card
	
