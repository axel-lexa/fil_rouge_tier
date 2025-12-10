extends Node
#class_name DeckManager


# Gère le deck du joueur (cartes disponibles, main, défausse, etc.)

var deck: Array[CardData] = []
var hand: Array[CardData] = []
var discard_pile: Array[CardData] = []
var exhaust_pile: Array[CardData] = []

const CARD_SCENE_PATH = "res://slay_the_wc/Cards/Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2

var card_scene: PackedScene

var deck_label: RichTextLabel = null
var player_hand_node: Node = null


func _ready():
	card_scene = preload(CARD_SCENE_PATH)
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
	print("Taille du deck=" + str(deck.size()) + " / Taille du bin="+str(discard_pile.size()))
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
			var card: CardData = deck.pop_front()
			drawn.append(card)
			hand.append(card)
			_update_deck_label()
			
		
	return drawn

func reset_deck():
	for card in hand:
		if card.target_type != CardData.TargetTypeEnum.NONE:
			add_card_to_deck(card)
	for card in discard_pile:
		if card.target_type != CardData.TargetTypeEnum.NONE:
			add_card_to_deck(card)
	hand.clear()
	discard_pile.clear()

# Défausse une carte de la main
func discard_card(card: CardData):
	if hand.has(card):
		hand.erase(card)
		if card.target_type != CardData.TargetTypeEnum.NONE:
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
