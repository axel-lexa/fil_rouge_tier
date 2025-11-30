extends Control
class_name CardRewardScreen

# Scène UI pour afficher 3 cartes et permettre la sélection

@onready var card_container: HBoxContainer = $VBoxContainer/CardContainer
@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var instruction_label: Label = $VBoxContainer/InstructionLabel

var reward_cards: Array[CardData] = []
var card_ui_scenes: Array[Control] = []

# Scène de carte UI (à créer ou référencer)
var card_ui_scene: PackedScene = null

func _ready():
	# S'abonner aux événements
	Events.card_reward_offered.connect(_on_card_reward_offered)
	
	# Masquer par défaut
	visible = false

# Affiche les 3 cartes de récompense
func _on_card_reward_offered(cards: Array):
	reward_cards = cards
	show_reward_screen()

func show_reward_screen():
	visible = true
	#_process_mode = Node.PROCESS_MODE_INHERIT
	
	# Nettoyer les cartes précédentes
	_clear_cards()
	
	# Créer les UI de cartes
	for i in range(reward_cards.size()):
		var card_data = reward_cards[i]
		var card_ui = _create_card_ui(card_data, i)
		if card_ui:
			card_container.add_child(card_ui)
			card_ui_scenes.append(card_ui)

func _clear_cards():
	for card_ui in card_ui_scenes:
		if is_instance_valid(card_ui):
			card_ui.queue_free()
	card_ui_scenes.clear()

# Crée une UI de carte cliquable
func _create_card_ui(card_data: CardData, index: int) -> Control:
	# Si une scène de carte UI existe, l'utiliser
	if card_ui_scene:
		var card_instance = card_ui_scene.instantiate()
		if card_instance.has_method("set_card_data"):
			card_instance.set_card_data(card_data)
		return card_instance
	
	# Sinon, créer une UI simple
	var card_panel = PanelContainer.new()
	card_panel.custom_minimum_size = Vector2(200, 300)
	
	var vbox = VBoxContainer.new()
	card_panel.add_child(vbox)
	
	# Nom de la carte
	var name_label = Label.new()
	name_label.text = card_data.card_name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(name_label)
	
	# Coût de mana
	var cost_label = Label.new()
	cost_label.text = "Coût: " + str(card_data.mana_cost)
	cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(cost_label)
	
	# Description
	var desc_label = Label.new()
	desc_label.text = card_data.description
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(desc_label)
	
	# Rareté
	var rarity_label = Label.new()
	rarity_label.text = "Rareté: " + card_data.rarity
	rarity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(rarity_label)
	
	# Bouton de sélection
	var select_button = Button.new()
	select_button.text = "Sélectionner"
	select_button.pressed.connect(func(): _on_card_selected(index))
	vbox.add_child(select_button)
	
	# Style basique
	card_panel.add_theme_stylebox_override("panel", StyleBoxFlat.new())
	
	return card_panel

# Appelé quand une carte est sélectionnée
func _on_card_selected(index: int):
	if index < 0 or index >= reward_cards.size():
		return
	
	var selected_card = reward_cards[index]
	
	# Émettre l'événement de sélection
	Events.card_selected.emit(selected_card)
	
	# Masquer l'écran
	visible = false
	_clear_cards()
