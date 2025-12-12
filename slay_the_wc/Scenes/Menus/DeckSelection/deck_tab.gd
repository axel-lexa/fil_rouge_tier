class_name DeckTab extends Control

@export var mascot: MascotData

var card_scene = preload("res://slay_the_wc/Cards/UICard/UICard.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if mascot:
		%MascotteImg.texture = mascot.mascotte_img
		%MascotteImg.flip_h = mascot.flip_mascotte_img
		#if mascot.mascotte_img2:
		#	var mascotteImg2 = %MascotteImg.duplicate()
		#	mascotteImg2.texture = mascot.mascotte_img2
		#	%MascotImgContainer.add_child(mascotteImg2)
		%MascotteName.text = mascot.mascotte_name
		%DescriptionTitle.text = "Description du deck \"" + mascot.deck_name + "\":"
		%Description.text = mascot.description
	%DescriptionTitle.text = "[u]" + %DescriptionTitle.text + "[/u]"

	if mascot:
		
		if mascot.default_cards.is_empty() and mascot.mascotte_name == RunManager.current_team:
			mascot.default_cards = DeckManager.deck
		
		for data in mascot.default_cards:
			var card_to_add = instantiateUiCard(data)
			%DefaultCardsContainer.add_child(card_to_add)
		for data in mascot.unlockable_cards:
			var card_to_add = instantiateUiCard(data)
			%UnlockableCardsContainer.add_child(card_to_add)

func instantiateUiCard(data: CardData) -> UiCard:
	var ui_card = card_scene.instantiate()
	ui_card.data = data
	ui_card.custom_minimum_size = Vector2(150, 200)
	return ui_card

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
