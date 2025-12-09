extends Node

# Gestionnaire de sauvegarde automatique
# Sauvegarde automatiquement à la fermeture et charge au démarrage

const SAVE_FILE_PATH = "user://savegame.json"

var has_save_data: bool = false

func _ready():
	# Vérifier si une sauvegarde existe
	has_save_data = FileAccess.file_exists(SAVE_FILE_PATH)

func _notification(what):
	# Sauvegarder automatiquement quand on quitte le jeu
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit()

# Sauvegarde l'état actuel du jeu
func save_game():
	var save_data = {
		"version": 1,
		"timestamp": Time.get_unix_time_from_system(),
		"run_manager": {
			"current_hp": RunManager.current_hp,
			"max_hp": RunManager.max_hp,
			"current_floor": RunManager.current_floor,
			"run_seed": RunManager.run_seed
		},
		"game_state": {
			"current_battle_description_path": _get_resource_path(GameState.current_battle_description) if GameState.current_battle_description else ""
		},
		"current_scene": get_tree().current_scene.scene_file_path if get_tree().current_scene else "",
		"in_battle": false,
		"battle_data": {}
	}
	
	# Si on est en combat, sauvegarder l'état du combat
	var battle_scene = get_tree().get_first_node_in_group("battle")
	if battle_scene:
		save_data["in_battle"] = true
		save_data["battle_data"] = _save_battle_state(battle_scene)
	
	# Sauvegarder le deck si on est en combat
	var deck_node = get_tree().get_first_node_in_group("deck")
	if deck_node and deck_node.has("player_deck"):
		save_data["battle_data"]["player_deck"] = _save_deck(deck_node.player_deck)
	
	# Sauvegarder la main si on est en combat
	var player_hand = get_tree().get_first_node_in_group("player_hand")
	if player_hand and player_hand.has("player_hand"):
		save_data["battle_data"]["player_hand"] = _save_hand(player_hand.player_hand)
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Jeu sauvegardé avec succès")
		has_save_data = true
	else:
		print("Erreur lors de la sauvegarde")

# Charge l'état sauvegardé du jeu
func load_game():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("Aucune sauvegarde trouvée")
		has_save_data = false
		return false
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if not file:
		print("Erreur lors du chargement de la sauvegarde")
		has_save_data = false
		return false
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		print("Erreur lors du parsing de la sauvegarde")
		has_save_data = false
		return false
	
	var save_data = json.get_data()
	
	# Charger les données de RunManager
	if save_data.has("run_manager"):
		var rm_data = save_data["run_manager"]
		RunManager.current_hp = rm_data.get("current_hp", 100)
		RunManager.max_hp = rm_data.get("max_hp", 100)
		RunManager.current_floor = rm_data.get("current_floor", 1)
		RunManager.run_seed = rm_data.get("run_seed", 0)
		if RunManager.run_seed != 0:
			seed(RunManager.run_seed)
	
	# Charger GameState
	if save_data.has("game_state"):
		var gs_data = save_data["game_state"]
		var battle_desc_path = gs_data.get("current_battle_description_path", "")
		if battle_desc_path != "":
			GameState.current_battle_description = load(battle_desc_path)
	
	# Charger la scène sauvegardée seulement si on n'est pas déjà dans cette scène
	var current_scene_path = get_tree().current_scene.scene_file_path if get_tree().current_scene else ""
	var saved_scene_path = save_data.get("current_scene", "")
	
	if saved_scene_path != "" and saved_scene_path != current_scene_path:
		# Attendre que l'arbre soit prêt avant de changer de scène
		await get_tree().process_frame
		get_tree().change_scene_to_file(saved_scene_path)
		
		# Si on était en combat, charger l'état du combat après le chargement de la scène
		if save_data.get("in_battle", false) and save_data.has("battle_data"):
			# Attendre que la scène soit complètement chargée
			await get_tree().process_frame
			await get_tree().process_frame
			_load_battle_state(save_data["battle_data"])
	elif saved_scene_path == current_scene_path:
		# On est déjà dans la bonne scène, charger l'état directement
		if save_data.get("in_battle", false) and save_data.has("battle_data"):
			await get_tree().process_frame
			_load_battle_state(save_data["battle_data"])
	
	has_save_data = true
	print("Jeu chargé avec succès")
	return true

# Sauvegarde l'état du combat
func _save_battle_state(battle_scene):
	var battle_data = {}
	
	# Sauvegarder l'état du joueur
	if battle_scene.has("player") and battle_scene.player:
		var player = battle_scene.player
		battle_data["player"] = {
			"health": player.health,
			"defense": player.defense,
			"energy": player.energy,
			"resource_path": _get_resource_path(player)
		}
	
	# Sauvegarder l'état des ennemis
	if battle_scene.has("ennemy"):
		battle_data["ennemies"] = {}
		for key in battle_scene.ennemy.keys():
			var enemy = battle_scene.ennemy[key]
			battle_data["ennemies"][key] = {
				"health": enemy.health,
				"defense": enemy.defense,
				"resource_path": _get_resource_path(enemy)
			}
	
	# Sauvegarder l'état du tour
	if battle_scene.has("player_turn"):
		battle_data["player_turn"] = battle_scene.player_turn
	
	if battle_scene.has("end_game"):
		battle_data["end_game"] = battle_scene.end_game
	
	return battle_data

# Charge l'état du combat
func _load_battle_state(battle_data):
	var battle_scene = get_tree().get_first_node_in_group("battle")
	if not battle_scene:
		return
	
	# Charger l'état du joueur
	if battle_data.has("player"):
		var player_data = battle_data["player"]
		if battle_scene.has("player") and battle_scene.player:
			var player = battle_scene.player
			player.health = player_data.get("health", player.health)
			player.defense = player_data.get("defense", 0)
			player.energy = player_data.get("energy", 3)
			
			# Mettre à jour l'UI
			if battle_scene.has_method("update_health_ui"):
				var hp_bar = battle_scene.get_node_or_null("BattleField/Characters/Player/HealthBarPlayer")
				var hp_text = battle_scene.get_node_or_null("BattleField/Characters/Player/HealthPlayer")
				if hp_bar and hp_text:
					battle_scene.update_health_ui(hp_bar, player, hp_text)
			
			var defense_text = battle_scene.get_node_or_null("BattleField/Characters/Player/DefensePlayer")
			if defense_text:
				defense_text.text = str(player.defense)
			
			var energy_text = battle_scene.get_node_or_null("BattleField/Characters/Player/EnergyPlayer")
			if energy_text:
				energy_text.text = "Energie : " + str(player.energy)
	
	# Charger l'état des ennemis
	if battle_data.has("ennemies"):
		for key in battle_data["ennemies"].keys():
			var enemy_data = battle_data["ennemies"][key]
			if battle_scene.has("ennemy") and battle_scene.ennemy.has(key):
				var enemy = battle_scene.ennemy[key]
				enemy.health = enemy_data.get("health", enemy.health)
				enemy.defense = enemy_data.get("defense", 0)
				
				# Mettre à jour l'UI
				var enemy_num = key.replace("ennemie", "")
				var hp_bar = battle_scene.get_node_or_null("BattleField/Characters/Ennemie" + enemy_num + "/HealthBarEnnemie")
				var hp_text = battle_scene.get_node_or_null("BattleField/Characters/Ennemie" + enemy_num + "/HealthEnnemy")
				if hp_bar and hp_text and battle_scene.has_method("update_health_ui"):
					battle_scene.update_health_ui(hp_bar, enemy, hp_text)
				
				var defense_text = battle_scene.get_node_or_null("BattleField/Characters/Ennemie" + enemy_num + "/DefenseEnnemy")
				if defense_text:
					defense_text.text = str(enemy.defense)
	
	# Restaurer l'état du tour
	if battle_data.has("player_turn"):
		battle_scene.player_turn = battle_data.get("player_turn", true)
	
	if battle_data.has("end_game"):
		battle_scene.end_game = battle_data.get("end_game", false)
	
	# Charger le deck
	if battle_data.has("player_deck"):
		var deck_node = battle_scene.get_node_or_null("Deck")
		if deck_node:
			deck_node.player_deck = _load_deck(battle_data["player_deck"])
			var rich_text_label = deck_node.get_node_or_null("RichTextLabel")
			if rich_text_label:
				rich_text_label.text = str(deck_node.player_deck.size())
	
	# Charger la main si elle était sauvegardée
	if battle_data.has("player_hand"):
		var player_hand_node = battle_scene.get_node_or_null("PlayerHand")
		if player_hand_node:
			# Supprimer les cartes actuelles de la main
			for card in player_hand_node.player_hand.duplicate():
				if card and is_instance_valid(card):
					card.queue_free()
			player_hand_node.player_hand.clear()
			
			# Recréer les cartes de la main sauvegardée
			var hand_paths = battle_data["player_hand"]
			for card_path in hand_paths:
				var card_resource = load(card_path)
				if card_resource:
					var card_scene = preload("res://slay_the_wc/Cards/Scenes/Card.tscn")
					var new_card = card_scene.instantiate()
					new_card.data = card_resource
					# Ajouter la carte comme enfant de PlayerHand (comme dans Deck.gd)
					player_hand_node.add_child(new_card)
					new_card.name = "Card"
					player_hand_node.add_card_to_hand(new_card, 0.2)

# Sauvegarde le deck (liste de chemins de ressources)
func _save_deck(deck: Array) -> Array:
	var deck_paths = []
	for card_resource in deck:
		var path = _get_resource_path(card_resource)
		if path != "":
			deck_paths.append(path)
	return deck_paths

# Charge le deck depuis les chemins sauvegardés
func _load_deck(deck_paths: Array) -> Array:
	var deck = []
	for path in deck_paths:
		var card_resource = load(path)
		if card_resource:
			deck.append(card_resource)
	return deck

# Sauvegarde la main (liste de chemins de ressources des cartes)
func _save_hand(hand: Array) -> Array:
	var hand_paths = []
	for card in hand:
		if card.has("data") and card.data:
			var path = _get_resource_path(card.data)
			if path != "":
				hand_paths.append(path)
	return hand_paths

# Obtient le chemin d'une ressource
func _get_resource_path(resource: Resource) -> String:
	if not resource:
		return ""
	
	var path = resource.resource_path
	if path.is_empty():
		# Si la ressource n'a pas de chemin, essayer de le trouver
		# En général, les ressources .tres ont un chemin
		return ""
	return path

# Supprime la sauvegarde
func delete_save():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		DirAccess.remove_absolute(SAVE_FILE_PATH)
		has_save_data = false
		print("Sauvegarde supprimée")
