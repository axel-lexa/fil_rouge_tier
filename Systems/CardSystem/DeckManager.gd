extends Node
#class_name DeckManager


# Gère le deck du joueur (cartes disponibles, main, défausse, etc.)

var deck: Array[CardData] = []
var hand: Array[CardData] = []
var discard_pile: Array[CardData] = []
var exhaust_pile: Array[CardData] = []

const CARD_SCENE_PATH = "res://slay_the_wc/Cards/Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2

var deck_label: RichTextLabel = null
var player_hand_node: Node = null


func _ready():
	print_tree_pretty()
	# S'abonner aux événements
	Events.card_selected.connect(_on_card_selected)

# Permet à la scène Deck d'enregistrer son RichTextLabel
func register_deck_label(label: RichTextLabel):
	print(">>> register_deck_label called with: ", label)
	deck_label = label
	_update_deck_label()


func _update_deck_label():
	if deck_label:
		deck_label.text = str(deck.size())


# Ajoute une carte au deck
func add_card_to_deck(card: CardData):
	if card:
		deck.append(card)
		Events.card_added_to_deck.emit(card)
		Events.deck_updated.emit()

# Retire une carte du deck
func remove_card_from_deck(card: CardData):
	deck.erase(card)
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
			_update_deck_label()
			var card_scene = preload(CARD_SCENE_PATH)
			var new_card = card_scene.instantiate()
			new_card.data = card
			player_hand_node.add_child(new_card)
			if player_hand_node.player_hand.size() < player_hand_node.MAX_HAND_SIZE:
				player_hand_node.add_card_to_hand(new_card, CARD_DRAW_SPEED)
		
	return drawn

# Défausse une carte de la main
func discard_card(card: CardData):
	if hand.has(card):
		hand.erase(card)
		discard_pile.append(card)
		player_hand_node.remove_card_from_hand(card)

# Épuise une carte (retire du deck définitivement)
func exhaust_card(card: CardData):
	if hand.has(card):
		hand.erase(card)
		exhaust_pile.append(card)
	elif deck.has(card):
		deck.erase(card)
		exhaust_pile.append(card)
	elif discard_pile.has(card):
		discard_pile.erase(card)
		exhaust_pile.append(card)

# Appelé quand une carte est sélectionnée comme récompense
func _on_card_selected(card: CardData):
	add_card_to_deck(card)
