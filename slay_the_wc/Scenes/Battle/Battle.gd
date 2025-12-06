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

var player: Entity
var ennemy: Dictionary[String, Enemy] = {}
const MAX_HAND_SIZE = 10
const MAX_ENERGY = 3

var player_turn
var player_hand_reference
var end_game
var intention_ennemie: Dictionary[String, String] = {}
var health_bar_enemy: Dictionary[String, ProgressBar] = {}
var label_health_enemy: Dictionary[String, RichTextLabel] = {}
var texture_intention: Dictionary[String, Sprite2D] = {}
var battle_desc: BattleDescription
var increase_damage = 0
var is_player_turn_start = false

# 12 pandas
var nb_pandas = 0
var nb_pandas_left_battle = 0

# PentaMonstres
var nb_mites = 1
var mites_to_add = 0
var parasitism_effect = Vector2(0, 0)
var parasitism_targeted_enemy_nb = null

var card_played: Array[Card2]

func display_infos_player(boolean: bool):
	$BattleField/Characters/Player/NamePlayer.visible = boolean
	$BattleField/Characters/Player/HealthPlayer.visible = boolean
	$BattleField/Characters/Player/DefensePlayer.visible = boolean
	$BattleField/Characters/Player/EnergyPlayer.visible = boolean
	$BattleField/Characters/Player/HealthBarPlayer.visible = boolean
	$BattleField/Characters/Player/PlayerImage.visible = boolean
	$BattleField/Characters/Player/DefenseIcon.visible = boolean
	$BattleField/Characters/Player/FloconMana1.visible = boolean
	$BattleField/Characters/Player/FloconMana2.visible = boolean
	$BattleField/Characters/Player/FloconMana3.visible = boolean

func display_infos_ennemie1(boolean: bool):
	$BattleField/Characters/Ennemie1/NameEnnemy.visible = boolean
	$BattleField/Characters/Ennemie1/HealthEnnemy.visible = boolean
	$BattleField/Characters/Ennemie1/DefenseEnnemy.visible = boolean
	$BattleField/Characters/Ennemie1/EnnemieImage.visible = boolean
	$BattleField/Characters/Ennemie1/DefenseIcon.visible = boolean
	$BattleField/Characters/Ennemie1/DefenseIcon.visible = boolean
	$BattleField/Characters/Ennemie1/HealthBarEnnemie.visible = boolean
	$BattleField/Characters/Ennemie1/IntentionEnnemie.visible = boolean
	$BattleField/CardSlot.visible = boolean

func display_infos_ennemie2(boolean: bool):
	$BattleField/Characters/Ennemie2/NameEnnemy.visible = boolean
	$BattleField/Characters/Ennemie2/HealthEnnemy.visible = boolean
	$BattleField/Characters/Ennemie2/DefenseEnnemy.visible = boolean
	$BattleField/Characters/Ennemie2/EnnemieImage.visible = boolean
	$BattleField/Characters/Ennemie2/DefenseIcon.visible = boolean
	$BattleField/Characters/Ennemie2/DefenseIcon.visible = boolean
	$BattleField/Characters/Ennemie2/HealthBarEnnemie.visible = boolean
	$BattleField/Characters/Ennemie2/IntentionEnnemie.visible = boolean
	
	
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
	
	display_infos_player(false)
	display_infos_ennemie1(false)
	display_infos_ennemie2(false)
	
	$BattleField/CardSlot.visible = false
	$Button.visible = false
	$PlayerHand.connect("hand_size_changed", _on_hand_size_changed)
	
	player_hand_reference = $PlayerHand
	
	player = load("res://slay_the_wc/Entities/Players/Player.tres")
	reset_health_bar($BattleField/Characters/Player/HealthBarPlayer, player, $BattleField/Characters/Player/HealthPlayer)
	
	var index = 1
	for ennemy_data in battle_desc.entities:
		var nameTmp = "ennemie"+str(index)
		ennemy[nameTmp] = ennemy_data
		index = index+1
	init_infos_player(player)
	if ennemy.has("ennemie1"):
		reset_health_bar($BattleField/Characters/Ennemie1/HealthBarEnnemie, ennemy["ennemie1"], $BattleField/Characters/Ennemie1/HealthEnnemy)
		init_infos_ennemie1(ennemy["ennemie1"])
	if ennemy.has("ennemie2"):
		reset_health_bar($BattleField/Characters/Ennemie2/HealthBarEnnemie, ennemy["ennemie2"], $BattleField/Characters/Ennemie2/HealthEnnemy)
		init_infos_ennemie2(ennemy["ennemie2"])
		
	$BattleField/Characters/Player/EnergyPlayer.text = "Energie : "
	
	for i in range(0, 5):
		$Deck.draw_card()
		tirage_carte.play()
		
	player_turn = true
	end_game = false
	if ennemy.has("ennemie1"):
		texture_intention["ennemie1"] = $BattleField/Characters/Ennemie1/IntentionEnnemie
		intention_ennemie["ennemie1"] = compute_intention_ennemie(ennemy["ennemie1"], texture_intention["ennemie1"])
		health_bar_enemy["ennemie1"] = $BattleField/Characters/Ennemie1/HealthBarEnnemie
		label_health_enemy["ennemie1"] = $BattleField/Characters/Ennemie1/HealthEnnemy
	if ennemy.has("ennemie2"):
		texture_intention["ennemie2"] = $BattleField/Characters/Ennemie2/IntentionEnnemie
		intention_ennemie["ennemie2"] = compute_intention_ennemie(ennemy["ennemie2"], texture_intention["ennemie2"])
		health_bar_enemy["ennemie2"] = $BattleField/Characters/Ennemie2/HealthBarEnnemie
		label_health_enemy["ennemie2"] = $BattleField/Characters/Ennemie2/HealthEnnemy

	taunt_adversaire.play()
	
func init_infos_player(p: Entity):
	$BattleField/Characters/Player/NamePlayer.text = p.name
	$BattleField/Characters/Player/DefensePlayer.text = str(p.defense)
	$BattleField/Characters/Player/PlayerImage.texture = p.image
	
func init_infos_ennemie1(ennemie: Entity):
	$BattleField/Characters/Ennemie1/NameEnnemy.text = ennemie.name
	$BattleField/Characters/Ennemie1/DefenseEnnemy.text = str(ennemie.defense)
	$BattleField/Characters/Ennemie1/EnnemieImage.texture = ennemie.image
	
func init_infos_ennemie2(ennemie: Entity):
	$BattleField/Characters/Ennemie2/NameEnnemy.text = ennemie.name
	$BattleField/Characters/Ennemie2/DefenseEnnemy.text = str(ennemie.defense)
	$BattleField/Characters/Ennemie2/EnnemieImage.texture = ennemie.image

func _on_hand_size_changed(size):
	if size >= $PlayerHand.MAX_HAND_SIZE:
		$Deck.set_deck_enabled(false)
	else:
		$Deck.set_deck_enabled(true)
	
# Quand le joueur attaque	
func battle(card: Card2, ennemie_number: String, player_slot: bool):
	#Début du tour joueur ?

	if is_player_turn_start:
		is_player_turn_start = false
		process_next_turn_actions()

			
	print("Battle="+ennemie_number)
	if not player_turn or end_game:
		return
		
	process_card(card, player_slot, ennemie_number)
	
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

func process_card(card: Card2, player_slot: bool, ennemie_number: String):
	
	if player.energy < card.data.mana_cost:
		$PlayerHand.add_card_to_hand(card, $PlayerHand.DEFAULT_CARD_MOVE_SPEED)
		card.get_node("Area2D/CollisionShape2D").disabled = false
		return
	player.energy = player.energy-card.data.mana_cost
	card_played.append(card)
	compute_energy()
	if player_slot and card.data.target_type == "self":
		# Si la carte est pour le joueur
		process_card_player(card)
		move_card_to_bin(card)
		return;
		
	elif player_slot and card.data.target_type != "self":
		# Si le joueur met une carte autre que "self" dans son slot = Retour à la main
		$PlayerHand.add_card_to_hand(card, $PlayerHand.DEFAULT_CARD_MOVE_SPEED)
		card.get_node("Area2D/CollisionShape2D").disabled = false
		return
		
	#Cas des cartes d'attaque/skill	
	process_card_player_to_enemy(card, ennemie_number)
	move_card_to_bin(card)
	
	
func process_card_player_to_enemy(card: Card2, ennemie_number: String):
	if card.data.card_team_owner == "commun":
		process_card_commun_enemy(card, ennemie_number)
			
	if card.data.card_team_owner == "12Pandas":
		process_card_12pandas_enemy(card, ennemie_number)
		
	if card.data.card_team_owner == "bibi":
		process_card_bibi_enemy(card)
		
	if card.data.card_team_owner == "5d6":
		process_card_5d6_enemy(card)
		
	if card.data.card_team_owner == "confrerieBeurreSale":
		process_card_confrerie_enemy(card)
		
	if card.data.card_team_owner == "aixAsperant":
		process_card_aix_asperant_enemy(card)
		
	if card.data.card_team_owner == "pentaMonstre":
		process_card_penta_monstre_enemy(card)
		
	if card.data.card_team_owner == "uwu":
		process_card_uwu_enemy(card)	


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

func process_damage_entity(ennemie_number: String, damage: int):
	if ennemy[ennemie_number].health <= damage:
		ennemi_mort.play()
		# Entité KO
		ennemy[ennemie_number].health = 0
		update_health_ui(health_bar_enemy[ennemie_number], ennemy[ennemie_number], label_health_enemy[ennemie_number])
		Events.battle_ended.emit(true)
		Events.battle_won.emit()
		get_tree().change_scene_to_file("res://Scenes/Menus/CardRewardScreen.tscn")
		return
	else:
		attaque_sur_advesaire.play()
		ennemy[ennemie_number].health = ennemy[ennemie_number].health - damage
		var health_bar
		var health_value
		if ennemie_number == "ennemie1":
			health_bar = $BattleField/Characters/Ennemie1/HealthBarEnnemie
			health_value = $BattleField/Characters/Ennemie1/HealthEnnemy
		else:
			health_bar = $BattleField/Characters/Ennemie2/HealthBarEnnemie
			health_value = $BattleField/Characters/Ennemie2/HealthEnnemy
		update_health_ui(health_bar, ennemy[ennemie_number], health_value)
	

func process_card_commun_enemy(card: Card2, ennemie_number: String):
	if card.data.id == "baston":
		process_damage_entity(ennemie_number, 6)
	elif card.data.id == "douleur_preparee":
		process_damage_entity(ennemie_number, $Deck.player_deck.size())
		pass
	elif card.data.id == "defense_offensive":
		process_damage_entity(ennemie_number, player.defense)
		pass
	elif card.data.id == "attaque_rapide":
		process_damage_entity(ennemie_number, 3)
		$Deck.draw_card()
		pass
	elif card.data.id == "melee_generale":
		var ennemy_number_index = 1
		for en in ennemy:
			process_damage_entity("ennemie" + ennemy_number_index, 12)
		
	play_hit_flash()

func process_card_commun_himself(card: Card2):
	if card.data.id == "defense":
		player.defense = player.defense + 5
		$BattleField/Characters/Player/DefensePlayer.text = str(player.defense)
		armure_prise.play()
	elif card.data.id == "esquive_rapide":
		player.defense = player.defense + 2
		$BattleField/Characters/Player/DefensePlayer.text = str(player.defense)
		$Deck.draw_card()
		armure_prise.play()
		await get_tree().create_timer(0.2).timeout
		tirage_carte.play()
	elif card.data.id == "dopage":
		player.health = player.health - 3
		update_health_ui($BattleField/Characters/Player/HealthBarPlayer, player, $BattleField/Characters/Player/HealthPlayer)
		increase_damage = increase_damage + 1
		degats_pris.play()
		await get_tree().create_timer(0.2).timeout
		buff_pris.play()
	elif card.data.id == "soin_urgence":
		player.health = player.health + 4
		update_health_ui($BattleField/Characters/Player/HealthBarPlayer, player, $BattleField/Characters/Player/HealthPlayer)
		soin_pris.play()
	elif card.data.id == "muraille":
		player.defense = player.defense * 2
		$BattleField/Characters/Player/DefensePlayer.text = str(player.defense)
		armure_prise.play()
	elif card.data.id == "changement_bareme":
		# TODO : Mélange toutes les cartes (Pioche, défausse et main). Commence un nouveau tour
		# TODO : ajouter les sons
		pass
	
func process_card_12pandas_himself(card: Card2):
	
	if card.data.id == "corne_appel":
		nb_pandas = nb_pandas + 3
		token.play()
		pass
	elif card.data.id == "bamboust":
		nb_pandas = nb_pandas * 2
		token.play()
		pass
	pass
	
func process_card_bibi_himself(card: Card2):
	pass	
func process_card_5d6_himself(card: Card2):
	pass	
func process_card_confrerie_himself(card: Card2):
	pass	
func process_card_aix_asperant_himself(card: Card2):
	pass	
func process_card_penta_monstre_himself(card: Card2):
	if card.data.id == "ponte_protegee":
		mites_to_add += 10
	elif card.data.id == "parasitisme":
		parasitism_effect.x += 5
		parasitism_effect.y += 6
	pass	
	
func process_card_uwu_himself(card: Card2):
	pass		
	
func process_card_12pandas_enemy(card: Card2, ennemy_number: String):
	
	if card.data.id == "coup_bambou":
		process_damage_entity(ennemy_number, 7)
		nb_pandas = nb_pandas + 3
		token.play()
	elif card.data.id == "revanche":
		for i in range(0, nb_pandas_left_battle):
			var nb_random = randi()%100 + 1
			if nb_random < 50:
				process_damage_entity("ennemie1", 3)
			else:
				process_damage_entity("ennemie2", 3)
		
	elif card.data.id == "roulade":
		nb_pandas_left_battle = nb_pandas_left_battle + 3
		
	elif card.data.id == "tir_barrage":
		for nb in range(0, nb_pandas):
			process_damage_entity(ennemy_number, 1)
	
func process_card_bibi_enemy(card: Card2):
	pass	
func process_card_5d6_enemy(card: Card2):
	pass	
func process_card_confrerie_enemy(card: Card2):
	pass	
func process_card_aix_asperant_enemy(card: Card2):
	pass	
func process_card_penta_monstre_enemy(card: Card2):
	pass	
	
func process_card_uwu_enemy(card: Card2):
	pass		
	
func process_pentamonstre_next_turn_actions():
	add_mites(mites_to_add)
	mites_to_add = 0
	if parasitism_targeted_enemy_nb != null:
		add_mites(parasitism_effect.x)
		var target : Entity = ennemy.get(parasitism_targeted_enemy_nb)
		if (target == null && ennemy.size() > 0):
			for en in ennemy.values():
				target = en
				break
			process_damage_entity(target.name, parasitism_effect.y)
		parasitism_effect = Vector2(0,0)
		parasitism_targeted_enemy_nb = null
	
func add_mites(amount: int):
	nb_mites += amount
	clamp(nb_mites, 0, 20)
	
func sub_mites(amount: int):
	nb_mites -= amount
	clamp(nb_mites, 0, 20)
	
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
	for en in ennemy:
		if intention_ennemie[en] == "ATK":
			if player.defense >= ennemy[en].pattern[0].attaque:
				player.defense = player.defense - ennemy[en].pattern[0].attaque
				$BattleField/Characters/Player/DefensePlayer.text = str(player.defense)
			else:
				var nb_degats = ennemy[en].pattern[0].attaque - player.defense
				player.defense = 0
				$BattleField/Characters/Player/DefensePlayer.text = str(player.defense)
				player.health = player.health - nb_degats
				update_health_ui($BattleField/Characters/Player/HealthBarPlayer, player, $BattleField/Characters/Player/HealthPlayer)
	
		elif intention_ennemie[en] == "DEF":
			pass
		elif intention_ennemie[en] == "BUFF":
			pass
		else:
			pass	
			
	
		if player.health == 0:
			$ResultBattle.text = "La patate a été plus fort(e) que vous, une prochaine fois mdr"
			$EndBattle.visible = true
			$BattleField/Characters/Player/HealthPlayer.text = "0/0"
			$Deck.set_deck_enabled(false)
			end_game = true
			return
		else:
			intention_ennemie[en] = compute_intention_ennemie(ennemy[en], texture_intention[en])
			#Ajout CKC - Début tour joueur
			for i in range(0,5):
				$Deck.draw_card()
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
	display_infos_player(true)
	
	if ennemy.has("ennemie1"):
		display_infos_ennemie1(true)
	if ennemy.has("ennemie2"):
		display_infos_ennemie2(true)
	$Button.visible = true

func reset_health_bar(bar: ProgressBar, entity: Entity, textLabel: RichTextLabel):
	bar.max_value = entity.health
	textLabel.text = str(bar.max_value)+"/"+str(entity.health)

func update_health_ui(hp_bar: ProgressBar, entity: Entity, textLabel: RichTextLabel):
	hp_bar.value = entity.health
	textLabel.text = str(entity.health)+"/"+str(hp_bar.max_value)
	
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
		

func play_hit_flash():
	var sprite = $BattleField/Characters/Ennemie1/EnnemieImage  # ou le node qui affiche ton ennemi
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
