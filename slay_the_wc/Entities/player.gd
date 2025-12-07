extends Entity
class_name Player

var team: String

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
