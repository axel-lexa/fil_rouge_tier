extends Node
#class_name CardRewardManager

# Gère la génération de récompenses de cartes en fin de partie
# Sélectionne 3 cartes aléatoires parmi les cartes disponibles

@export var all_cards: Array[CardData] = [load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"), load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"), load("res://slay_the_wc/Cards/Data/Commun/Baston.tres")]  # Toutes les cartes du jeu
@export var unlocked_cards: Array[CardData] = []  # Cartes débloquées par le joueur

# Probabilités de rareté (doit totaliser 100)
@export var common_weight: int = 70
@export var uncommon_weight: int = 25
@export var rare_weight: int = 5

func _ready():
	# S'abonner aux événements
	Events.battle_won.connect(_on_battle_won)
	#print(unlocked_cards)
	# Initialiser avec toutes les cartes débloquées par défaut
	# (peut être modifié pour avoir un système de déblocage progressif)
	if unlocked_cards.is_empty():
		unlocked_cards = all_cards.duplicate()
		
	#print(unlocked_cards)

# Génère 3 cartes aléatoires pour la récompense
func generate_card_reward() -> Array[CardData]:
	var reward_cards: Array[CardData] = []
	
	# S'assurer qu'on a assez de cartes débloquées
	if unlocked_cards.size() < 3:
		push_error("Pas assez de cartes débloquées pour générer une récompense!")
		return reward_cards
	
	# Générer 3 cartes uniques
	var available_cards = unlocked_cards.duplicate()
	
	for i in range(3):
		if available_cards.is_empty():
			break
		
		# Sélectionner une carte selon la rareté
		var selected_card = _select_card_by_rarity(available_cards)
		if selected_card:
			reward_cards.append(selected_card)
			# Retirer la carte sélectionnée pour éviter les doublons
			var index_to_remove = available_cards.find(selected_card)
			if index_to_remove >= 0:
				available_cards.remove_at(index_to_remove)
	
	return reward_cards

# Sélectionne une carte selon les poids de rareté
func _select_card_by_rarity(available_cards: Array[CardData]) -> CardData:
	if available_cards.is_empty():
		return null
	
	# Filtrer les cartes par rareté selon les poids
	var total_weight = common_weight + uncommon_weight + rare_weight
	var roll = randi() % total_weight
	
	var target_rarity: CardData.RarityEnum
	if roll < common_weight:
		target_rarity = CardData.RarityEnum.COMMON
	elif roll < common_weight + uncommon_weight:
		target_rarity =  CardData.RarityEnum.UNCOMMON
	else:
		target_rarity =  CardData.RarityEnum.RARE
	
	# Chercher une carte de la rareté cible
	var rarity_cards = available_cards.filter(func(card): return card.rarity == target_rarity)
	
	# Si aucune carte de cette rareté, prendre une carte aléatoire
	if rarity_cards.is_empty():
		rarity_cards = available_cards
	
	return rarity_cards[randi() % rarity_cards.size()]

# Débloque une nouvelle carte
func unlock_card(card_data: CardData):
	if not unlocked_cards.has(card_data):
		unlocked_cards.append(card_data)

func _on_battle_won():
	# Générer et offrir les récompenses
	var reward_cards = generate_card_reward()
	call_deferred("_emit_reward", reward_cards)
	#if reward_cards.size() == 3:
		#Events.debug_emit()
		#Events.card_reward_offered.emit(reward_cards)

func _emit_reward(reward_cards):
	if reward_cards.size() > 0:
		Events.debug_emit()
		Events.card_reward_offered.emit(reward_cards)
	else:
		push_error("Aucune carte de récompense générée!")
