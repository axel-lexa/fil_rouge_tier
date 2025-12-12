extends Node2D

#Sons
@onready var taunt_enemy_athar: AudioStreamPlayer = $TauntEnemyAthar
@onready var taunt_enemy_choppy_orc: AudioStreamPlayer = $TauntEnemyChoppyOrc
@onready var taunt_enemy_deformice: AudioStreamPlayer = $TauntEnemyDeformice
@onready var taunt_enemy_greedy_mimic: AudioStreamPlayer = $TauntEnemyGreedyMimic
@onready var taunt_enemy_one_trick_mage: AudioStreamPlayer = $TauntEnemyOneTrickMage
@onready var taunt_enemy_patate: AudioStreamPlayer = $TauntEnemyPatate
@onready var taunt_enemy_tech_rex: AudioStreamPlayer = $TauntEnemyTechRex
@onready var taunt_enemy_8: AudioStreamPlayer = $TauntEnemy8
@onready var taunt_enemy_9: AudioStreamPlayer = $TauntEnemy9
@onready var taunt_enemy_10: AudioStreamPlayer = $TauntEnemy10
@onready var begin_phase: AudioStreamPlayer = $BeginPhase
@onready var draw_card_1: AudioStreamPlayer = $DrawCard1
@onready var draw_card_2: AudioStreamPlayer = $DrawCard2
@onready var discard_card_1: AudioStreamPlayer = $DiscardCard1
@onready var discard_card_2: AudioStreamPlayer = $DiscardCard2
@onready var token_taken: AudioStreamPlayer = $TokenTaken
@onready var token_panda: AudioStreamPlayer = $TokenPanda
@onready var hit_taken_1: AudioStreamPlayer = $HitTaken
@onready var hit_taken_2: AudioStreamPlayer = $HitTaken2
@onready var hit_taken_3: AudioStreamPlayer = $HitTaken3
@onready var hit_taken_4: AudioStreamPlayer = $HitTaken4
@onready var hit_taken_5: AudioStreamPlayer = $HitTaken5
@onready var hit_taken_rare_1: AudioStreamPlayer = $HitTakenRare1
@onready var hit_taken_rare_2: AudioStreamPlayer = $HitTakenRare2
@onready var heal_taken_1: AudioStreamPlayer = $HealTaken1
@onready var heal_taken_2: AudioStreamPlayer = $HealTaken2
@onready var buff_taken_1: AudioStreamPlayer = $BuffTaken1
@onready var buff_taken_2: AudioStreamPlayer = $BuffTaken2
@onready var enemy_death_1: AudioStreamPlayer = $EnemyDeath1
@onready var enemy_death_2: AudioStreamPlayer = $EnemyDeath2
#TODO trouver où le mettre
@onready var death_by_kitarsh: AudioStreamPlayer = $DeathByKitarsh
@onready var victory_1: AudioStreamPlayer = $Victory1
@onready var victory_2: AudioStreamPlayer = $Victory2
@onready var defeat_1: AudioStreamPlayer = $Defeat1
@onready var defeat_2: AudioStreamPlayer = $Defeat2
#Arrays de sons
@onready var hit_taken_array: Array[AudioStreamPlayer] = [hit_taken_1,hit_taken_2,hit_taken_3,hit_taken_4,hit_taken_5,hit_taken_rare_1,hit_taken_rare_2]
@onready var draw_card_array: Array[AudioStreamPlayer] = [draw_card_1,draw_card_2]
@onready var discard_card_array: Array[AudioStreamPlayer] = [discard_card_1,discard_card_2]
@onready var heal_taken_array: Array[AudioStreamPlayer] = [heal_taken_1,heal_taken_2]
@onready var buff_taken_array: Array[AudioStreamPlayer] = [buff_taken_1,buff_taken_2]
@onready var enemy_death_array: Array[AudioStreamPlayer] = [enemy_death_1,enemy_death_2]
@onready var victory_array: Array[AudioStreamPlayer] = [victory_1,victory_2]
@onready var defeat_array: Array[AudioStreamPlayer] = [defeat_1,defeat_2]

var player: Player
var battle_enemies: Array[Enemy]
var alive_enemies: Array[Enemy]
const MAX_HAND_SIZE = 10
const MAX_ENERGY = 3
var energy_bar: HBoxContainer
var energy_label: RichTextLabel

var player_turn
var player_hand_reference
var end_game
var battle_desc: BattleDescription

var is_player_turn_start = false

var parasitism_effect = Vector2(0, 0)
var parasitism_targeted_enemy : Enemy

var card_played: Array[Card2]	

var card_scene: PackedScene

var textEnnemy: String = ""
	
func _ready():
	set_process_unhandled_input(true)
	card_scene = preload("res://slay_the_wc/Cards/Scenes/Card.tscn")
		
	# Ajouter au groupe pour la sauvegarde
	add_to_group("battle")
	
	battle_desc = GameState.current_battle_description
	
	$VideoStreamPlayer.stream = battle_desc.background
	$VideoStreamPlayer.volume_db = -80.0
	$VideoStreamPlayer.speed_scale = 2.91
	$VideoStreamPlayer.autoplay = true
	$VideoStreamPlayer.play()
	
	if battle_desc.entities.size() == 1 and battle_desc.entities[0].name == "BruleSonge":
		$BossFinal.play()
	
	$CardManager.visible = false
	$PlayerHand.visible = false
	$Bin.visible = false
	$Deck.visible = false
	
	$BattleField/CardSlot.visible = false
	$Button.visible = false
	$PlayerHand.connect("hand_size_changed", _on_hand_size_changed)
	$EndBattle.visible = false
	player_hand_reference = $PlayerHand
	DeckManager.player_hand_node = $PlayerHand

	energy_bar = $BattleField/Characters/Player/HBoxContainer
	energy_bar.visible = false
	energy_label = $BattleField/Characters/Player/EnergyPlayer
	energy_label.visible = false
	
	$AtkName.visible = false
	
	player = load("res://slay_the_wc/Entities/Players/Player.tres")
	player.health = RunManager.current_hp
	var player_component = Entity_components.new() 
	player_component.name_label = $BattleField/Characters/Player/NamePlayer
	player_component.health_label = $BattleField/Characters/Player/HealthPlayer
	player_component.defense_label = $BattleField/Characters/Player/DefensePlayer
	player_component.sprite = $BattleField/Characters/Player/PlayerImage
	player_component.defense_icon = $BattleField/Characters/Player/DefenseIcon
	player_component.health_bar = $BattleField/Characters/Player/HealthBarPlayer
	player_component.extra_info = $BattleField/Characters/Player/SpecialPower
	player_component.turn_ui_off()
	player.image = DeckManager.mascotData.mascotte_img
	$BattleField/Characters/Player/PlayerImage.flip_h = DeckManager.mascotData.flip_mascotte_img
	player.components = player_component
	player.update_health_ui()
	load_deck()
	compute_energy()
	
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
			play_sound_battle(null,enemy.name)
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
	
	draw_cards(5, true)
		
	player_turn = true
	end_game = false

func _unhandled_input(event):
	if event.is_action_pressed("heal_cheat"):
		if player:
			RunManager.current_hp = player.max_health
			#player.health = player.max_health
			player.heal(player.max_health)


func load_deck():
	if DeckManager.deck.size() == 0:
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
	
	# Quand tout les ennemies sont KO :
	if alive_enemies.size() == 0:
		#RunManager.current_hp = RunManager.max_hp
		enemy_death_1.stop()
		enemy_death_2.stop()
		play_sound_battle_random(victory_array)
		RunManager.complete_floor()
		RunManager.current_hp = player.health
		SaveManager.save_game()
		$ResultBattle.text = "Vous avez gagné le combat !"
		$EndBattle.visible = true
		$Button.visible = false
		#$BattleField/Characters/Player/HealthPlayer.text = "0/0"
		$Deck.set_deck_enabled(false)
		DeckManager.reset_deck()
		end_game = true
		return
	

func process_card(card: Card2, player_slot: bool, ennemie_index: int):
	if player.energy >= card.data.mana_cost:
		if player_slot and card.data.target_type == CardData.TargetTypeEnum.SELF:
			# Si la carte est pour le joueur
			player.energy = player.energy-card.data.mana_cost
			card_played.append(card)
			compute_energy()
			process_card_player(card)
			move_card_to_bin(card)
			return
		#elif !player_slot and card.cata.target-type == CardData.TargetTypeEnum.ALL_ENEMIES:
			#pass
		elif !player_slot and card.data.target_type != CardData.TargetTypeEnum.SELF:
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
	if card.data.card_team_owner == CardData.OwnerTeamEnum.COMMON:
		process_card_commun_enemy(card, target)
			
	if card.data.card_team_owner == CardData.OwnerTeamEnum._12_PANDAS:
		process_card_12pandas_enemy(card, target)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum.BIBI:
		process_card_bibi_enemy(card, target)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum._5D6:
		process_card_5d6_enemy(card, target)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum.CONFRERIE_BEURRE_SALE:
		process_card_confrerie_enemy(card, target)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum.AIXASPERANTS:
		process_card_aix_asperant_enemy(card, target)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum.PENTAMONSTRES:
		process_card_penta_monstre_enemy(card, target)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum.UWU:
		process_card_uwu_enemy(card, target)	


func process_card_player(card: Card2):
	if card.data.card_team_owner == CardData.OwnerTeamEnum.COMMON:
		process_card_commun_himself(card)
			
	if card.data.card_team_owner == CardData.OwnerTeamEnum._12_PANDAS:
		process_card_12pandas_himself(card)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum.BIBI:
		process_card_bibi_himself(card)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum._5D6:
		process_card_5d6_himself(card)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum.CONFRERIE_BEURRE_SALE:
		process_card_confrerie_himself(card)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum.AIXASPERANTS:
		process_card_aix_asperant_himself(card)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum.PENTAMONSTRES:
		process_card_penta_monstre_himself(card)
		
	if card.data.card_team_owner == CardData.OwnerTeamEnum.UWU:
		process_card_uwu_himself(card)	
	player.update_health_ui()

func process_damage_player(enemy: Player, damage: int):
	if not enemy.apply_damage_and_check_lifestatus(damage):
		play_sound_battle_random(defeat_array)
	else:
		play_sound_battle_random(hit_taken_array)
		
func process_damage_entity(enemy: Enemy, damage: int):
	play_hit_flash(enemy)
	# En cas de mort
	if not enemy.apply_damage_and_check_lifestatus(damage):
		play_sound_battle_random(enemy_death_array)
		enemy.turn_ui_off()
		alive_enemies.erase(enemy)
	else:
		play_sound_battle_random(hit_taken_array)

func process_heal_entity(target: Entity, amout: int):
	target.heal(amout)
	play_sound_battle_random(heal_taken_array)

func process_shield_entity(target: Entity, amout: int):
	target.add_defense(amout)
	play_sound_battle_random(buff_taken_array)

func process_shield_multiply_entity(target: Entity, amout: int):
	target.multiply_defense(amout)
	play_sound_battle_random(buff_taken_array)

func process_count_panda(operation: String, amount: int):
	match operation:
		"+":
			if player.nb_pandas + amount > 12:
				var nb_pandas_attack = player.nb_pandas + amount - 12
				panda_left_battle(nb_pandas_attack)
				player.nb_pandas = 12
				player.update_extra_info()
			else:
				player.nb_pandas += amount
		"-":
			player.nb_pandas -= amount
		"*":
			if player.nb_pandas * amount > 12:
				var nb_pandas_attack = player.nb_pandas * amount - 12
				panda_left_battle(nb_pandas_attack)
				player.nb_pandas = 12
				player.update_extra_info()
			else:
				player.nb_pandas *= amount
	player.update_extra_info()
	play_sound_battle(token_panda,"")

func process_buff_strenght_entity(target: Entity, amout: int):
	target.add_strenght(amout)
	play_sound_battle_random(buff_taken_array)

func draw_cards(amount: int, is_init: bool = false):
	var drawn = DeckManager.draw_cards(amount)
	# instantiate card nodes and add them to the canvas
	for  cardData in drawn:
		if $PlayerHand.player_hand.size() < $PlayerHand.MAX_HAND_SIZE:
			var new_card: Card2 = card_scene.instantiate()
			new_card.data = cardData
			print("connect " + new_card.data.card_name)
			new_card.connect("hovered", func (c: Card2): $CardZoom.show_card(c.data))
			new_card.connect("hovered_off",  func (_c: Card2): $CardZoom.hide_card())
			$PlayerHand.add_child(new_card)
			$PlayerHand.add_card_to_hand(new_card, DeckManager.CARD_DRAW_SPEED)
	if !is_init:
		await get_tree().create_timer(0.2).timeout
		play_sound_battle_random(draw_card_array)

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
		draw_cards(1)
		#$Deck.draw_card()
		pass
	elif card.data.id == "melee_generale":
		var list_duplicate = alive_enemies.duplicate()
		for enemy in list_duplicate:
			process_damage_entity(enemy, 12)

func process_card_commun_himself(card: Card2):
	if card.data.id == "defense":
		process_shield_entity(player, 5)
	elif card.data.id == "esquive_rapide":
		process_shield_entity(player, 2)
		draw_cards(1)
	elif card.data.id == "dopage":
		process_damage_player(player, 3)
		await get_tree().create_timer(0.2).timeout
		process_buff_strenght_entity(player, 2)
	elif card.data.id == "soin_urgence":
		process_heal_entity(player, 4)
	elif card.data.id == "muraille":
		process_shield_multiply_entity(player, 2)
	elif card.data.id == "changement_bareme":
		DeckManager.shuffle_deck()
		player.energy = MAX_ENERGY
		$BattleField/Characters/Player/EnergyPlayer.text = "Energie :"
		compute_energy()
		$BattleField/Characters/Player/DefensePlayer.text = "0"
		player.defense = 0
		play_sound_battle_random([$DrawCard1, $DrawCard2])
		var tmpList = player_hand_reference.player_hand.duplicate()
		for cardTmp in tmpList:
			move_card_to_bin(cardTmp)
		draw_cards(5, true)
	
func process_card_12pandas_himself(card: Card2):
	
	if card.data.id == "corne_appel":
		process_count_panda("+", 3)
	elif card.data.id == "bamboust":
		process_count_panda("*", 2)
	pass
	
func process_card_bibi_himself(card: Card2):
	if card.data.id == "cul_sec_telo":
		process_shield_entity(player, 8)
	elif card.data.id == "jai_renverse":
		var tmpList = player_hand_reference.player_hand.duplicate()
		for c in tmpList:
			move_card_to_bin(c)
		draw_cards(tmpList.size())
	elif card.data.id == "en_avant_teno":
		process_shield_entity(player, 12)
	
func process_card_5d6_himself(card: Card2):
	if card.data.id == "3d6":
		process_shield_entity(player, launch_dice(3))
	elif card.data.id == "1d6":
		process_heal_entity(player, launch_dice(1))
		
	
	pass	
func process_card_confrerie_himself(card: Card2):
	if card.data.id == "main_glissante":
		draw_cards(3)
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
		#player.nb_pandas_left_battle += 3
		if player.nb_pandas < 3:
			$PlayerHand.add_card_to_hand(card, $PlayerHand.DEFAULT_CARD_MOVE_SPEED)
			card.get_node("Area2D/CollisionShape2D").disabled = false
			return
		else:
			player.nb_pandas -= 3
			player.nb_pandas_left_battle +=3
			player.update_extra_info()
			panda_left_battle(3)
		
	elif card.data.id == "tir_barrage":
		for nb in range(0, player.nb_pandas):
			process_damage_entity(target, 1)

func panda_left_battle(count: int):
	for i in range (0, count):
		var enemy_chosen
		if alive_enemies.size() == 1:
			enemy_chosen = alive_enemies[0]
		else:
			enemy_chosen = alive_enemies[randi_range(0, alive_enemies.size()-1)]
		process_damage_entity(enemy_chosen, 3)

func process_card_bibi_enemy(card: Card2, target: Enemy):
	if card.data.id == "cul_sec_zeno":
		process_damage_entity(target, 8)
	elif card.data.id == "cest_ma_tournee":
		process_damage_entity(target, 4)
		process_shield_entity(player, 4)
	elif card.cata.id == "en_avant_zeno":
		process_damage_entity(target, 12)
	elif card.data.id == "double_attaque":
		process_damage_entity(target, 8)
		process_shield_entity(player, 8)
func process_card_5d6_enemy(card: Card2, target: Enemy):
	
	if card.data.id == "0d6":
		process_damage_entity(target, 9)
	elif card.data.id == "2d6":
		var de1 = randi_range(1, 6)
		var de2 = randi_range(1, 6)
		process_damage_entity(target, de1+de2)
		if de1 == de2:
			draw_cards(2)
		else:
			draw_cards(1)
	elif card.data.id == "4d6":
		
		for i in range(0, 4):
			var result = launch_dice(1)
			if result % 2 == 0:
				process_damage_entity(target, result)
			else:
				process_shield_entity(player, result)
		
	elif card.data.id == "5d6":
		process_damage_entity(target, launch_dice(5))
		
		
	
	pass	
func process_card_confrerie_enemy(card: Card2, target: Enemy):
	if card.data.id == "tournee_generale":
		for i in range(0, 3):
			var target2 = alive_enemies.get(randi_range(0, alive_enemies.size()-1))
			target2.add_burn(3)
	elif card.data.id == "calories":
		target.multiply_burn(2)
	elif card.data.id == "bataille_de_beurre":
		for enemy in alive_enemies:
			process_damage_entity(enemy, 10)
		move_card_to_bin(DeckManager.hand.get(randi_range(0, DeckManager.hand.size()-1)))
	elif card.data.id == "crepe_beurre_sucre":
		process_damage_entity(target, 6)
		target.add_burn(3)
	elif card.data.id == "tartine_pain_beurre":
		process_damage_entity(target, 7)
		if target.burn != 0:
			process_damage_entity(target, 7)
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
	play_sound_battle(token_taken,"")
	
func sub_mites(amount: int):
	player.nb_mites -= amount
	clamp(player.nb_mites, 0, 20)
	
	
	
func launch_dice(count: int):
	var somme = 0
	for i in range(0, count):
		somme += randi_range(1, 6)	
	return somme
	
func process_end_of_turn_actions():
	pass
	
func process_next_turn_actions():
	process_pentamonstre_next_turn_actions()
	
func move_card_to_bin(card: Card2):
	
	if end_game:
		return
	card.get_node("Area2D/CollisionShape2D").disabled = true
	player_hand_reference.remove_card_from_hand(card)
	player.discard_card(card.data)

	if get_tree():
		var tween = get_tree().create_tween()
		tween.tween_property(card, "position", $Bin.position, 0.2)
		tween.parallel().tween_property(card, "scale", Vector2(1.1,1.1), 0.2)



# Boutton fin de tour appuyé
func _on_button_pressed() -> void:
	process_end_of_turn_actions()
	player_turn = false
	is_player_turn_start = true;
	card_played = []
	$Button.disabled = true
	var tmpList = player_hand_reference.player_hand.duplicate()
	for card in tmpList:
		move_card_to_bin(card)
		
	var enemies_to_kill = []

	for enemy in alive_enemies:
		if !enemy.compute_burn():
			enemies_to_kill.append(enemy)
			break
		enemy.perform_action(player)
		
		textEnnemy += enemy.name + " a utilisé l'attaque " + enemy.next_atk.name+"\n"
		
		
		enemy.compute_next_attack()	
	for enemy in enemies_to_kill:
		alive_enemies.erase(enemy)
	
	$AtkName.visible = true
	$AtkName.text = textEnnemy
	play_sound_battle(begin_phase,"")
	await get_tree().create_timer(1).timeout
	$AtkName.visible = false
	textEnnemy = ""
	player.compute_burn()
	if player.health == 0:
		var timeWait = play_sound_battle_random(defeat_array)
		$ResultBattle.text = "GAME OVER"
		$EndBattle.visible = true
		$BattleField/Characters/Player/HealthPlayer.text = "0/0"
		$Button.visible = false
		$Deck.set_deck_enabled(false)
		DeckManager.reset_deck()
		end_game = true
		RunManager.current_hp = RunManager.max_hp
		RunManager.current_floor = 1
		await get_tree().create_timer(timeWait).timeout
		get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Map/Map.tscn")
		return
	else:
		#Ajout CKC - Début tour joueur
		draw_cards(5)
		
		#Fin ajout CKC
		player_turn = true
		player.energy = MAX_ENERGY
		$BattleField/Characters/Player/EnergyPlayer.text = "Energie :"
		compute_energy()
		$BattleField/Characters/Player/DefensePlayer.text = "0"
		player.defense = 0
		$Button.disabled = false


func _on_end_battle_pressed() -> void:
	if battle_enemies[0].name == "BruleSonge":
		get_tree().change_scene_to_file("res://slay_the_wc/Scenes/End/End.tscn")
	else:
		get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Map/Map.tscn")


func _on_video_stream_player_finished() -> void:
	$CardManager.visible = true
	$PlayerHand.visible = true
	$Bin.visible = true
	$Deck.visible = true
	$Button.visible = true
	player.setup_ui()
	energy_bar.visible = true
	energy_label.visible = true
	for enemy in battle_enemies:
		enemy.setup_ui()
		enemy.compute_next_attack()
	
func compute_energy():
	for child in energy_bar.get_children():
		child.queue_free()

	for i in range(player.energy):
		var sprite = Sprite2D.new()
		sprite.texture = load("res://slay_the_wc/Assets/Art/logoWinterCup.png")
		sprite.visible = true
		sprite.scale = Vector2(0.1, 0.1)
		var align_box = Control.new()
		align_box.add_child(sprite)
		energy_bar.add_child(align_box)

func play_hit_flash(target: Enemy):
	if target:
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

func play_sound_battle_random(sounds: Array[AudioStreamPlayer]) -> float:
	var rng = RandomNumberGenerator.new()
	var randomIndex = rng.randi_range(0,sounds.size()-1)
	var soundPlaying = sounds.get(randomIndex)
	soundPlaying.play()
	return soundPlaying.stream.get_length()
			
func play_sound_battle(sound: AudioStreamPlayer, titleSound: String):
	if sound != null:
		sound.play()
	else:
		if titleSound == "Athar":
			taunt_enemy_athar.play()
		elif titleSound == "Choppy Orc":
			taunt_enemy_choppy_orc.play()
		elif titleSound == "Déformice":
			taunt_enemy_deformice.play()
		elif titleSound == "Greedy Mimic":
			taunt_enemy_greedy_mimic.play()
		elif titleSound == "One Trick Mage":
			taunt_enemy_one_trick_mage.play()
		elif titleSound == "La patate":
			taunt_enemy_patate.play()
		elif titleSound == "Techrex":
			taunt_enemy_tech_rex.play()
		elif titleSound == "BruleSonge":
			taunt_enemy_8.play()
		elif titleSound == "enemy_9":
			taunt_enemy_9.play()
		elif titleSound == "enemy_10":
			taunt_enemy_10.play()
