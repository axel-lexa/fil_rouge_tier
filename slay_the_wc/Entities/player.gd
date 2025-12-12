extends Entity
class_name Player

var team: String
var tokens_root_text = ""
var tokens = 0
var max_tokens = 0
var tokens_visibility : bool
var tokens_label : RichTextLabel

var energy = 3

# Team 12 pandas
var nb_pandas: int = 0
var nb_pandas_left_battle: int = 0

# PentaMonstres
var nb_mites: int = 1
var mites_to_add: int = 0

# AixAsperant
var brulure: int = 0

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
	
func add_tokens(amount: int) -> int:
	var overflow = (tokens + amount) - max_tokens
	if overflow < 0:
		overflow = 0
	tokens = clamp(tokens+amount, 0, amount)
	return overflow

func compute_tokens_visibility():
	var mname = DeckManager.mascotData.mascotte_name
	if mname == "Jeanne":
		tokens_visibility = true
		tokens_root_text = "Pandas: "
		return
	if mname == "Mimi":
		tokens_visibility = true
		tokens_root_text = "Mites: "
		return
	tokens_visibility = false

func update_tokens_ui():
	tokens_label.text = tokens_root_text + str(tokens)

func set_tokens_label(label: RichTextLabel):
	tokens_label = label

func turn_ui_on():
	tokens_label.visible = tokens_visibility
	super.turn_ui_on()

func turn_ui_off():
	tokens_label.visible = false
	super.turn_ui_off()

func setup_ui():
	update_ui()
	super.setup_ui()
	turn_ui_on()

func update_ui():
	update_tokens_ui()
	super.update_ui()
