extends Node2D

var player
var ennemy
const MAX_HAND_SIZE = 10
const MAX_ENERGY = 3

var player_turn
var player_hand_reference
var end_game
var intention: Dictionary

func _ready():
	
	$CardManager.visible = false
	$PlayerHand.visible = false
	$Bin.visible = false
	$Deck.visible = false
	$BattleField/NamePlayer.visible = false
	$BattleField/HealthPlayer.visible = false
	$BattleField/DefensePlayer.visible = false
	$BattleField/EnergyPlayer.visible = false
	$BattleField/NameEnnemy.visible = false
	$BattleField/HealthEnnemy.visible = false
	$BattleField/DefenseEnnemy.visible = false
	$BattleField/CardSlot.visible = false
	$Button.visible = false
	$PlayerImage.visible = false
	$EnnemieImage.visible = false
	$PlayerHand.connect("hand_size_changed", _on_hand_size_changed)
	
	player_hand_reference = $"../PlayerHand"
	
	player = load("res://slay_the_wc/Entities/Players/Player.tres")
	ennemy = load("res://slay_the_wc/Entities/Ennemies/Patate.tres")
	
	$BattleField/NamePlayer.text = player.name
	$BattleField/HealthPlayer.text = "Vie : " + str(player.health)
	$BattleField/DefensePlayer.text = "Defense : " + str(player.defense)
	$BattleField/EnergyPlayer.text = "Energie : " + str(player.energy)
	$BattleField/NameEnnemy.text = ennemy.name
	$BattleField/HealthEnnemy.text = "Vie : " + str(ennemy.health)
	$BattleField/DefenseEnnemy.text = "Defense : " + str(ennemy.defense)
	
	for i in range(0, 5):
		$Deck.draw_card()
		
	player_turn = true
	end_game = false
	
func _on_hand_size_changed(size):
	if size >= $PlayerHand.MAX_HAND_SIZE:
		$Deck.set_deck_enabled(false)
	else:
		$Deck.set_deck_enabled(true)
		
func battle(card: Card2, card_slot):
	print("Battle")
	if not player_turn or end_game:
		return
	#if player.energy == 0  or player.energy < card.data.cost:
		#print("Pas assez d'energie")
		#return;
		
	#if ennemy.pattern[0].type == "Attaque":
		#player.health = player.health-ennemy.pattern[0].attaque
		#$BattleField/HealthPlayer.text = "Vie : " + str(player.health)
	#
	#if player.health <= 0:
		#$ResultBattle.text = "La patate a été plus fort(e) que vous, une prochaine fois mdr"
		#$EndBattle.visible = true
		#$BattleField/HealthPlayer.text = "Vie : 0"
		#$Deck.set_deck_enabled(false)
		#end_game = true
		#return
	#player_turn = true
	#player.energy = MAX_ENERGY
	#$BattleField/EnergyPlayer.text = "Energie : " + str(player.energy)
	intention = ennemy.pattern[0]
	print(intention)
	if intention.type == "Attaque":
		
		$IntentionEnnemie.texture = load("res://slay_the_wc/Assets/Art/attack.png")
		print($IntentionEnnemie.texture)
		
		
	if card.data.type == "Defense":
		player.energy = player.energy-card.data.cost
		player.defense = player.defense+card.data.defense
		$BattleField/DefensePlayer.text = "Defense : " + str(player.defense)
		$BattleField/EnergyPlayer.text = "Energie : " + str(player.energy)
		
	elif card.data.type == "Attaque":
		player.energy = player.energy-card.data.cost
		ennemy.health = ennemy.health-card.data.attack
		
		if ennemy.health <= 0:
			$ResultBattle.text = "Vous avez gagné, GG :)"
			$EndBattle.visible = true
			$BattleField/HealthEnnemy.text = "Vie : 0"
			$Button.visible = false
			card_slot.card_in_slot = true
			$Deck.set_deck_enabled(false)
		$BattleField/HealthEnnemy.text = "Vie : " + str(ennemy.health)
		$BattleField/EnergyPlayer.text = "Energie : " + str(player.energy)
		
		
		
	move_card_to_bin(card)
	
	#$PlayerHand.remove_card_from_hand(card)
	## On deplace la carte dans la zone corbeille
	#card.position = $Bin.position
	#card.scale = Vector2(0.1, 0.1)
	#card_slot.card_in_slot = false
	
func move_card_to_bin(card: Card2):
	
	if end_game:
		return
	
	# 1️⃣ Retirer de la main
	$PlayerHand.remove_card_from_hand(card)

	# 2️⃣ Désactiver le hover pour que le CardManager ne la touche plus
	var card_manager = get_tree().root.get_node("Battle/CardManager")
	card.disconnect("hovered", card_manager.on_hovered_over_card)
	card.disconnect("hovered_off", card_manager.on_hovered_off_card)

	# 3️⃣ Tween pour position + scale
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", $Bin.position, 0.2)
	tween.parallel().tween_property(card, "scale", Vector2(1.1,1.1), 0.2)

# C'est au tour de l'ennemie
func _on_button_pressed() -> void:
	player_turn = false
	
	if ennemy.pattern[0].type == "Attaque":
		player.health = player.health-ennemy.pattern[0].attaque
		$BattleField/HealthPlayer.text = "Vie : " + str(player.health)
	
	if player.health <= 0:
		$ResultBattle.text = "La patate a été plus fort(e) que vous, une prochaine fois mdr"
		$EndBattle.visible = true
		$BattleField/HealthPlayer.text = "Vie : 0"
		$Deck.set_deck_enabled(false)
		end_game = true
		return
	player_turn = true
	player.energy = MAX_ENERGY
	$BattleField/EnergyPlayer.text = "Energie : " + str(player.energy)
	


func _on_end_battle_pressed() -> void:
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Menus/Main_menu/Main_menu.tscn")


func _on_video_stream_player_finished() -> void:
	$CardManager.visible = true
	$PlayerHand.visible = true
	$Bin.visible = true
	$Deck.visible = true
	$BattleField/NamePlayer.visible = true
	$BattleField/DefensePlayer.visible = true
	$BattleField/EnergyPlayer.visible = true
	$BattleField/NameEnnemy.visible = true
	$BattleField/HealthEnnemy.visible = true
	$BattleField/DefenseEnnemy.visible = true
	$BattleField/CardSlot.visible = true
	$Button.visible = true
	$PlayerImage.visible = true
	$EnnemieImage.visible = true
