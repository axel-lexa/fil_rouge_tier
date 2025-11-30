extends Node
#class_name DeckManager


# Gère le deck du joueur (cartes disponibles, main, défausse, etc.)

var deck: Array[CardData] = []
var hand: Array[CardData] = []
var discard_pile: Array[CardData] = []
var exhaust_pile: Array[CardData] = []

func _ready():
	# S'abonner aux événements
	Events.card_selected.connect(_on_card_selected)

# Ajoute une carte au deck
func add_card_to_deck(card_data: CardData):
	if card_data:
		deck.append(card_data)
		Events.card_added_to_deck.emit(card_data)
		Events.deck_updated.emit()

# Retire une carte du deck
func remove_card_from_deck(card_data: CardData):
	deck.erase(card_data)
	Events.deck_updated.emit()

# Mélange le deck
func shuffle_deck():
	deck.shuffle()

# Pioche N cartes
func draw_cards(count: int) -> Array[CardData]:
	var drawn: Array[CardData] = []
	
	for i in range(count):
		if deck.is_empty():
			# Remélanger la défausse dans le deck
			if not discard_pile.is_empty():
				deck = discard_pile.duplicate()
				discard_pile.clear()
				shuffle_deck()
			else:
				break
		
		if not deck.is_empty():
			var card = deck.pop_front()
			drawn.append(card)
			hand.append(card)
	
	return drawn

# Défausse une carte de la main
func discard_card(card_data: CardData):
	if hand.has(card_data):
		hand.erase(card_data)
		discard_pile.append(card_data)

# Épuise une carte (retire du deck définitivement)
func exhaust_card(card_data: CardData):
	if hand.has(card_data):
		hand.erase(card_data)
		exhaust_pile.append(card_data)
	elif deck.has(card_data):
		deck.erase(card_data)
		exhaust_pile.append(card_data)
	elif discard_pile.has(card_data):
		discard_pile.erase(card_data)
		exhaust_pile.append(card_data)

# Appelé quand une carte est sélectionnée comme récompense
func _on_card_selected(card_data: CardData):
	add_card_to_deck(card_data)
