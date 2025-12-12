extends Entity
class_name Player

var team: String

var energy = 3

# Team 12 pandas
var nb_pandas: int = 0
var nb_pandas_left_battle: int = 0

# PentaMonstres
var nb_mites: int = 1
var mites_to_add: int = 0

# AixAsperant
var brulure: int = 0

# UwU
var previously_played_cards: Array[CardData] = []
var cards_played_this_turn: Array[CardData] = []
var attack_multiplicator: float = 1
# all damage taken is reduced to 1
var escape: bool = false

var battle_achieved: Dictionary[String, bool] = {}

func add_card_to_deck(card: CardData):
	DeckManager.add_card_to_deck(card)
	
# Retire une carte du deck
func remove_card_from_deck(card: CardData):
	DeckManager.remove_card_from_deck(card)

# Mélange le deck
func shuffle_deck():
	DeckManager.shuffle()

# Pioche N cartes
func draw_cards(count: int) -> Array[CardData]:
	return DeckManager.draw_cards(count)

# Défausse une carte de la main
func discard_card(card: CardData):
	DeckManager.discard_card(card)

# Épuise une carte (retire du deck définitivement)
func exhaust_card(card: CardData):
	exhaust_card(card)

func update_extra_info():
	if DeckManager.mascotData.mascotte_name == "Jeanne" and nb_pandas > 0:
		components.extra_info.visible = true
		components.extra_info.text = "Pandas : " + str(nb_pandas)
		pass
	elif DeckManager.mascotData.mascotte_name == "Mimi" and nb_mites > 0:
		components.extra_info.visible = true
		components.extra_info.text = "Mites : " + str(nb_mites)
		pass
	else:
		components.extra_info.visible = false
	
func add_card_played_this_turn(card: CardData):
	cards_played_this_turn.append(card)

func apply_damage_and_check_lifestatus(amount : int) -> bool:
	return super.apply_damage_and_check_lifestatus(1 if escape else amount)
