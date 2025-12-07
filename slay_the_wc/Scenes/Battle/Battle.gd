extends Node2D

@onready var taunt_adversaire: AudioStreamPlayer = $TauntAdversaire
@onready var debut_tour: AudioStreamPlayer = $DebutTour
@onready var tirage_carte: AudioStreamPlayer = $TirageCarte
@onready var fin_tour: AudioStreamPlayer = $FinTour
@onready var discard_carte: AudioStreamPlayer = $DiscardCarte
@onready var degats_pris: AudioStreamPlayer = $DegatsPris
@onready var soin_pris: AudioStreamPlayer = $SoinPris
@onready var buff_pris: AudioStreamPlayer = $BuffPris
@onready var armure_prise: AudioStreamPlayer = $ArmurePrise
@onready var attaque_sur_advesaire: AudioStreamPlayer = $AttaqueSurAdvesaire
@onready var debuff_sur_adversaire: AudioStreamPlayer = $DebuffSurAdversaire
@onready var ennemi_mort: AudioStreamPlayer = $EnnemiMort
@onready var victoire: AudioStreamPlayer = $Victoire
@onready var defaite: AudioStreamPlayer = $Defaite
@onready var token: AudioStreamPlayer = $Token

var player: Player
var battle_enemies: Array[Enemy]
var alive_enemies: Array[Enemy]
const MAX_HAND_SIZE = 10
const MAX_ENERGY = 3

var player_turn
var player_hand_reference
var end_game
var battle_desc: BattleDescription

var is_player_turn_start = false

var parasitism_effect = Vector2(0, 0)
var parasitism_targeted_enemy : Enemy

var card_played: Array[Card2]	
	
func _ready():
	battle_desc = GameState.current_battle_description
	
	$VideoStreamPlayer.stream = battle_desc.background
	$VideoStreamPlayer.volume_db = -80.0
	$VideoStreamPlayer.speed_scale = 2.91
	$VideoStreamPlayer.autoplay = true
	$VideoStreamPlayer.play()
	
	
	$CardManager.visible = false
	$PlayerHand.visible = false
	$Bin.visible = false
	$Deck.visible = false
	
	$BattleField/CardSlot.visible = false
	$Button.visible = false
	$PlayerHand.connect("hand_size_changed", _on_hand_size_changed)
	
	player_hand_reference = $PlayerHand
	DeckManager.player_hand_node = $PlayerHand
	
	player = load("res://slay_the_wc/Entities/Players/Player.tres")
	var player_component = Entity_components.new() 
	player_component.name_label = $BattleField/Characters/Player/NamePlayer
	player_component.health_label = $BattleField/Characters/Player/HealthPlayer
	player_component.defense_label = $BattleField/Characters/Player/DefensePlayer
	player_component.sprite = $BattleField/Characters/Player/PlayerImage
	player_component.defense_icon = $BattleField/Characters/Player/DefenseIcon
	player_component.health_bar = $BattleField/Characters/Player/HealthBarPlayer
	player_component.turn_ui_off()
	player.components = player_component
	player.update_health_ui()
	load_deck()
	

	var entity_component1 = Entity_components.new() 
	entity_component1.name_label = $BattleField/Characters/Ennemie1/NameEnnemy
	entity_component1.health_label = $BattleField/Characters/Ennemie1/HealthEnnemy
	entity_component1.defense_label = $BattleField/Characters/Ennemie1/DefenseEnnemy
	entity_component1.sprite = $BattleField/Characters/Ennemie1/EnnemieImage
	entity_component1.defense_icon = $BattleField/Characters/Ennemie1/DefenseIcon
	entity_component1.health_bar = $BattleField/Characters/Ennemie1/HealthBarEnnemie
	entity_component1.turn_ui_off()

	var entity_component2 = Entity_components.new() 
	entity_component2.name_label = $BattleField/Characters/Ennemie2/NameEnnemy
	entity_component2.health_label = $BattleField/Characters/Ennemie2/HealthEnnemy
	entity_component2.defense_label = $BattleField/Characters/Ennemie2/DefenseEnnemy
	entity_component2.sprite = $BattleField/Characters/Ennemie2/EnnemieImage
	entity_component2.defense_icon = $BattleField/Characters/Ennemie2/DefenseIcon
	entity_component2.health_bar = $BattleField/Characters/Ennemie2/HealthBarEnnemie
	entity_component2.turn_ui_off()

	var entity_component3 = Entity_components.new() 
	entity_component3.name_label = $BattleField/Characters/Ennemie3/NameEnnemy
	entity_component3.health_label = $BattleField/Characters/Ennemie3/HealthEnnemy
	entity_component3.defense_label = $BattleField/Characters/Ennemie3/DefenseEnnemy
	entity_component3.sprite = $BattleField/Characters/Ennemie3/EnnemieImage
	entity_component3.defense_icon = $BattleField/Characters/Ennemie3/DefenseIcon
	entity_component3.health_bar = $BattleField/Characters/Ennemie3/HealthBarEnnemie
	entity_component3.turn_ui_off()
	
	var index = 0
	for enemy in battle_desc.entities:
		enemy = enemy.duplicate()
		enemy.id = index
		if (index == 0):
			enemy.components = entity_component1
			enemy.set_intention_sprite($BattleField/Characters/Ennemie1/IntentionEnnemie)
		elif (index == 1):
			enemy.components = entity_component2
			enemy.set_intention_sprite($BattleField/Characters/Ennemie2/IntentionEnnemie)
		elif (index == 2):
			enemy.components = entity_component3
			enemy.set_intention_sprite($BattleField/Characters/Ennemie3/IntentionEnnemie)
		enemy.update_health_ui()
		battle_enemies.append(enemy)
		alive_enemies.append(enemy)
		index = index+1

	$BattleField/Characters/Player/EnergyPlayer.text = "Energie : "
	
	player.draw_cards(5)
	#$Deck.draw_card()
	tirage_carte.play()
		
	player_turn = true
	end_game = false

	taunt_adversaire.play()

func load_deck():
	DeckManager.add_card_to_deck(load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"))
	DeckManager.add_card_to_deck(load("res://slay_the_wc/Cards/Data/Commun/Attaque_rapide.tres"))
	DeckManager.add_card_to_deck(load("res://slay_the_wc/Cards/Data/Commun/Defense.tres"))
	DeckManager.add_card_to_deck(load("res://slay_the_wc/Cards/Data/Commun/Dopage.tres"))
	DeckManager.add_card_to_deck(load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"))
	DeckManager.add_card_to_deck(load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"))
	DeckManager.add_card_to_deck(load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"))
	DeckManager.add_card_to_deck(load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"))
	DeckManager.add_card_to_deck(load("res://slay_the_wc/Cards/Data/Commun/Defense.tres"))
	DeckManager.add_card_to_deck(load("res://slay_the_wc/Cards/Data/Commun/Defense.tres"))


func _on_hand_size_changed(size):
	if size >= $PlayerHand.MAX_HAND_SIZE:
		$Deck.set_deck_enabled(false)
	else:
		$Deck.set_deck_enabled(true)
	
func convert_scene_index_to_enemy(index: int) -> Enemy:
	if index < battle_enemies.size():
		for enemy in alive_enemies:
			if enemy.id == index:
				return enemy
	return null


# Quand le joueur attaque	
func battle(card: Card2, ennemie_index: int, player_slot: bool):

	if is_player_turn_start:
		is_player_turn_start = false
		process_next_turn_actions()

			
	print("Battle="+ str(ennemie_index))
	if not player_turn or end_game:
		return
	
	process_card(card, player_slot, ennemie_index)
	
	#if player_slot:
		#
		#if card.data.card_type == "power":
			#player.energy = player.energy-card.data.mana_cost
			#player.defense = player.defense+card.data.defense
			#$BattleField/Characters/Player/DefensePlayer.text = str(player.defense)
			#$BattleField/Characters/Player/EnergyPlayer.text = "Energie :"
			#compute_energy()
			#move_card_to_bin(card)
	#else:
		#if card.data.card_type == "attack":
			#print("ATTAQUE !!!!!!!")
			#ennemy[ennemie_number].health = 0
			#
			#update_health_ui($BattleField/Characters/Ennemie1/HealthBarEnnemie, ennemy[ennemie_number], $BattleField/Characters/Ennemie1/HealthEnnemy)
			#if ennemy[ennemie_number].health == 0:
				#print("ureitgblrgtr")
				#Events.battle_ended.emit(true)
				#Events.battle_won.emit()
				#get_tree().change_scene_to_file("res://Scenes/Menus/CardRewardScreen.tscn")
				#return
			#pass
		#elif card.data.card_type == "power":
			#$PlayerHand.add_card_to_hand(card, $PlayerHand.DEFAULT_CARD_MOVE_SPEED)
			#card.get_node("Area2D/CollisionShape2D").disabled = false
			#return
		#move_card_to_bin(card)

func process_card(card: Card2, player_slot: bool, ennemie_index: int):
	if player.energy >= card.data.mana_cost:
		if player_slot and card.data.target_type == "self":
			# Si la carte est pour le joueur
			player.energy = player.energy-card.data.mana_cost
			card_played.append(card)
			compute_energy()
			process_card_player(card)
			move_card_to_bin(card)
			return
		else:
			var target = convert_scene_index_to_enemy(ennemie_index)
			if target != null:
				player.energy = player.energy-card.data.mana_cost
				card_played.append(card)
				compute_energy()
				process_card_player_to_enemy(card, target)
				move_card_to_bin(card)
				return
	$PlayerHand.add_card_to_hand(card, $PlayerHand.DEFAULT_CARD_MOVE_SPEED)
	card.get_node("Area2D/CollisionShape2D").disabled = false
	
	
func process_card_player_to_enemy(card: Card2, target: Enemy):
	if card.data.card_team_owner == "commun":
		process_card_commun_enemy(card, target)
			
	if card.data.card_team_owner == "12Pandas":
		process_card_12pandas_enemy(card, target)
		
	if card.data.card_team_owner == "bibi":
		process_card_bibi_enemy(card, target)
		
	if card.data.card_team_owner == "5d6":
		process_card_5d6_enemy(card, target)
		
	if card.data.card_team_owner == "confrerieBeurreSale":
		process_card_confrerie_enemy(card, target)
		
	if card.data.card_team_owner == "aixAsperant":
		process_card_aix_asperant_enemy(card, target)
		
	if card.data.card_team_owner == "pentaMonstre":
		process_card_penta_monstre_enemy(card, target)
		
	if card.data.card_team_owner == "uwu":
		process_card_uwu_enemy(card, target)	


func process_card_player(card: Card2):
	if card.data.card_team_owner == "commun":
		process_card_commun_himself(card)
			
	if card.data.card_team_owner == "12Pandas":
		process_card_12pandas_himself(card)
		
	if card.data.card_team_owner == "bibi":
		process_card_bibi_himself(card)
		
	if card.data.card_team_owner == "5d6":
		process_card_5d6_himself(card)
		
	if card.data.card_team_owner == "confrerieBeurreSale":
		process_card_confrerie_himself(card)
		
	if card.data.card_team_owner == "aixAsperant":
		process_card_aix_asperant_himself(card)
		
	if card.data.card_team_owner == "pentaMonstre":
		process_card_penta_monstre_himself(card)
		
	if card.data.card_team_owner == "uwu":
		process_card_uwu_himself(card)	
	player.update_health_ui()

func process_damage_entity(enemy: Entity, damage: int):
	play_hit_flash(enemy)
	if not enemy.apply_damage_and_check_lifestatus(damage):
		ennemi_mort.play()
	else:
		attaque_sur_advesaire.play()
	
func process_heal_entity(target: Entity, amout: int):
	target.heal(amout)
	soin_pris.play()

func process_shield_entity(target: Entity, amout: int):
	target.add_defense(amout)
	armure_prise.play()

func process_shield_multiply_entity(target: Entity, amout: int):
	target.multiply_defense(amout)
	armure_prise.play()

func process_count_panda(operation: String, amount: int):
	match operation:
		"+":
			player.nb_pandas += amount 
		"-":
			player.nb_pandas -= amount
		"*":
			player.nb_pandas *= amount
	token.play()

func process_buff_strenght_entity(target: Entity, amout: int):
	target.add_strenght(amout)
	buff_pris.play()

func draw_cards(amount: int):
	DeckManager.draw_cards(amount)
	await get_tree().create_timer(0.2).timeout
	tirage_carte.play()

func process_card_commun_enemy(card: Card2, target: Enemy):
	if card.data.id == "baston":
		process_damage_entity(target, 6)
	elif card.data.id == "douleur_preparee":
		process_damage_entity(target, DeckManager.deck.size())
		pass
	elif card.data.id == "defense_offensive":
		process_damage_entity(target, player.defense)
		pass
	elif card.data.id == "attaque_rapide":
		process_damage_entity(target, 3)
		DeckManager.draw_cards(1)
		#$Deck.draw_card()
		pass
	elif card.data.id == "melee_generale":
		for enemy in alive_enemies:
			process_damage_entity(enemy, 12)

func process_card_commun_himself(card: Card2):
	if card.data.id == "defense":
		process_shield_entity(player, 5)
	elif card.data.id == "esquive_rapide":
		process_shield_entity(player, 2)
		draw_cards(1)
	elif card.data.id == "dopage":
		process_damage_entity(player, 3)
		await get_tree().create_timer(0.2).timeout
		process_buff_strenght_entity(player, 2)
	elif card.data.id == "soin_urgence":
		process_heal_entity(player, 4)
	elif card.data.id == "muraille":
		process_shield_multiply_entity(player, 2)
	elif card.data.id == "changement_bareme":
		# TODO : Mélange toutes les cartes (Pioche, défausse et main). Commence un nouveau tour
		# TODO : ajouter les sons
		pass
	
func process_card_12pandas_himself(card: Card2):
	
	if card.data.id == "corne_appel":
		process_count_panda("+", 3)
	elif card.data.id == "bamboust":
		process_count_panda("*", 2)
	pass
	
func process_card_bibi_himself(card: Card2):
	pass	
func process_card_5d6_himself(card: Card2):
	
	if card.data.id == "3d6":
		process_shield_entity(player, launch_dice(3))
	elif card.data.id == "1d6":
		process_heal_entity(player, launch_dice(1))
		
	
	pass	
func process_card_confrerie_himself(card: Card2):
	pass	
func process_card_aix_asperant_himself(card: Card2):
	pass	
func process_card_penta_monstre_himself(card: Card2):
	if card.data.id == "ponte_protegee":
		player.mites_to_add += 10
	pass	
	
func process_card_uwu_himself(card: Card2):
	pass		
	
func process_card_12pandas_enemy(card: Card2, target: Enemy):
	
	if card.data.id == "coup_bambou":
		process_damage_entity(target, 7)
		process_count_panda("+", 3)
	elif card.data.id == "revanche":
		for i in range(0, player.nb_pandas_left_battle):
			process_damage_entity(alive_enemies.get(randi_range(0, alive_enemies.size()-1)), 3)
		
	elif card.data.id == "roulade":
		player.nb_pandas_left_battle += 3
		
	elif card.data.id == "tir_barrage":
		for nb in range(0, player.nb_pandas):
			process_damage_entity(target, 1)
	
func process_card_bibi_enemy(card: Card2, target: Enemy):
	pass	
func process_card_5d6_enemy(card: Card2, target: Enemy):
	
	if card.data.id == "0d6":
		process_damage_entity(target, 9)
	elif card.data.id == "2d6":
		var de1 = randi_range(1, 6)
		var de2 = randi_range(1, 6)
		process_damage_entity(target, de1+de2)
		if de1 == de2:
			DeckManager.draw_cards(2)
		else:
			DeckManager.draw_cards(1)
	elif card.data.id == "4d6":
		var result = launch_dice(4)
		if result % 2 == 0:
			process_damage_entity(target, result)
		else:
			process_shield_entity(player, result)
	elif card.data.id == "5d6":
		process_damage_entity(target, launch_dice(5))
		
		
	
	pass	
func process_card_confrerie_enemy(card: Card2, target: Enemy):
	pass	
func process_card_aix_asperant_enemy(card: Card2, target: Enemy):
	pass	
func process_card_penta_monstre_enemy(card: Card2, target: Enemy):
	if card.data.id == "parasitisme":
		parasitism_effect.x += 5
		parasitism_effect.y += 6
		parasitism_targeted_enemy = target
		# TODO finish this
	pass	
	
func process_card_uwu_enemy(card: Card2, target: Enemy):
	pass		
	
func process_pentamonstre_next_turn_actions():
	add_mites(player.mites_to_add)
	player.mites_to_add = 0
	if parasitism_targeted_enemy != null:
		add_mites(parasitism_effect.x)
		process_damage_entity(parasitism_targeted_enemy, parasitism_effect.y)
		parasitism_effect = Vector2(0,0)
		parasitism_targeted_enemy = null
	
func add_mites(amount: int):
	player.nb_mites += amount
	clamp(player.nb_mites, 0, 20)
	
func sub_mites(amount: int):
	player.nb_mites -= amount
	clamp(player.nb_mites, 0, 20)
	
	
	
func launch_dice(count: int):
	var somme = 0
	for i in range(0, count):
		somme = randi_range(1, 6)	
	return somme
	
func process_end_of_turn_actions():
	pass
	
func process_next_turn_actions():
	process_pentamonstre_next_turn_actions()
	
func move_card_to_bin(card: Card2):
	
	if end_game:
		return
	
	# 1️⃣ Retirer de la main
	player_hand_reference.remove_card_from_hand(card)
	#Ajout CKC
	$Bin.add_to_bin(card)
	#fin ajout CKC
	# 2️⃣ Désactiver le hover pour que le CardManager ne la touche plus
	#var card_manager = get_tree().root.get_node("Battle/CardManager")
	#card.disconnect("hovered", card_manager.on_hovered_over_card)
	#card.disconnect("hovered_off", card_manager.on_hovered_off_card)

	# 3️⃣ Tween pour position + scale
	if get_tree():
		var tween = get_tree().create_tween()
		tween.tween_property(card, "position", $Bin.position, 0.2)
		tween.parallel().tween_property(card, "scale", Vector2(1.1,1.1), 0.2)

func compute_intention_ennemie(enemy: Enemy, sprite_intention) -> String:
	var intention = enemy.compute_intention()
	if intention == "ATK":
		sprite_intention.texture = load("res://slay_the_wc/Assets/Art/attack_icon.png")
	elif intention == "DEF":
		sprite_intention.texture = load("res://slay_the_wc/Assets/Art/shield_icon.png")
	elif intention == "BUFF":
		sprite_intention.texture = load("res://slay_the_wc/Assets/Art/up-arrow_icon.png")
	elif intention == "DEBUFF":
		sprite_intention.texture = load("res://slay_the_wc/Assets/Art/down-arrow_icon.png")
	return intention

# Boutton fin de tour appuyé
func _on_button_pressed() -> void:
	process_end_of_turn_actions()
	player_turn = false
	is_player_turn_start = true;
	card_played = []
	#Ajout CKC - On doit vider la main
	var tmpList = player_hand_reference.player_hand.duplicate()
	for card in tmpList:
		move_card_to_bin(card)
		# Ca ne vide pas la main entièrement je comprends pas pourquoi des cartes ne sont pas attachées à la main j'imagine
	#Fin ajout CKC
	# début du tour des ennemis
	for enemy in alive_enemies:
		enemy.perform_action(player)
		enemy.compute_next_attack()	
	if player.health == 0:
		$ResultBattle.text = "La patate a été plus fort(e) que vous, une prochaine fois mdr"
		$EndBattle.visible = true
		$BattleField/Characters/Player/HealthPlayer.text = "0/0"
		$Deck.set_deck_enabled(false)
		end_game = true
		return
	else:
		#Ajout CKC - Début tour joueur
		DeckManager.draw_cards(5)
		
		#Fin ajout CKC
		player_turn = true
		player.energy = MAX_ENERGY
		$BattleField/Characters/Player/EnergyPlayer.text = "Energie :"
		compute_energy()
		$BattleField/Characters/Player/DefensePlayer.text = "0"
		player.defense = 0


func _on_end_battle_pressed() -> void:
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Map/Map.tscn")


func _on_video_stream_player_finished() -> void:
	$CardManager.visible = true
	$PlayerHand.visible = true
	$Bin.visible = true
	$Deck.visible = true
	$Button.visible = true
	player.setup_ui()
	for enemy in battle_enemies:
		enemy.setup_ui()
		enemy.compute_next_attack()
	
func compute_energy():
	if player.energy == 3:
		$BattleField/Characters/Player/FloconMana1.visible = true
		$BattleField/Characters/Player/FloconMana2.visible = true
		$BattleField/Characters/Player/FloconMana3.visible = true
	if player.energy == 2:
		$BattleField/Characters/Player/FloconMana1.visible = true
		$BattleField/Characters/Player/FloconMana2.visible = true
		$BattleField/Characters/Player/FloconMana3.visible = false
	if player.energy == 1:
		$BattleField/Characters/Player/FloconMana1.visible = true
		$BattleField/Characters/Player/FloconMana2.visible = false
		$BattleField/Characters/Player/FloconMana3.visible = false
	if player.energy == 0:
		$BattleField/Characters/Player/FloconMana1.visible = true
		$BattleField/Characters/Player/FloconMana2.visible = true
		$BattleField/Characters/Player/FloconMana3.visible = true
		

func play_hit_flash(target: Enemy):
	var sprite = target.components.sprite
	print("sprite=", sprite)
	if sprite == null:
		return

	var original_modulate = sprite.modulate
	var original_pos = sprite.position
	var original_scale = sprite.scale

	var tween = create_tween()

	# Flash rouge
	tween.tween_property(sprite, "modulate", Color(1, 0.2, 0.2), 0.05)

	# Shake léger
	for i in range(3):
		tween.tween_property(sprite, "position", original_pos + Vector2(randf()*4-2, randf()*4-2), 0.03)

	# Pop
	tween.tween_property(sprite, "scale", sprite.scale * 1.1, 0.05)
	tween.tween_property(sprite, "scale", original_scale, 0.08)

	# Retour normal
	tween.tween_property(sprite, "modulate", original_modulate, 0.1)
	tween.tween_property(sprite, "position", original_pos, 0.05)
