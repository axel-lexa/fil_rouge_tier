extends Node2D

var player
var ennemy
const MAX_HAND_SIZE = 10
const MAX_ENERGY = 3

var player_turn
var player_hand_reference
var end_game
var intention: Dictionary
var intention_ennemie

func display_infos_player(boolean: bool):
	$BattleField/Characters/Player/NamePlayer.visible = boolean
	$BattleField/Characters/Player/HealthPlayer.visible = boolean
	$BattleField/Characters/Player/DefensePlayer.visible = boolean
	$BattleField/Characters/Player/EnergyPlayer.visible = boolean
	$BattleField/Characters/Player/HealthBarPlayer.visible = boolean
	$BattleField/Characters/Player/PlayerImage.visible = boolean
	$BattleField/Characters/Player/DefenseIcon.visible = boolean

func display_infos_ennemie(boolean: bool):
	$BattleField/Characters/Ennemie1/NameEnnemy.visible = boolean
	$BattleField/Characters/Ennemie1/HealthEnnemy.visible = boolean
	$BattleField/Characters/Ennemie1/DefenseEnnemy.visible = boolean
	$BattleField/Characters/Ennemie1/EnnemieImage.visible = boolean
	$BattleField/Characters/Ennemie1/DefenseIcon.visible = boolean
	$BattleField/Characters/Ennemie1/DefenseIcon.visible = boolean
	$BattleField/Characters/Ennemie1/HealthBarEnnemie.visible = boolean
	$BattleField/Characters/Ennemie1/IntentionEnnemie.visible = boolean
	
	
func _ready():
	
	$CardManager.visible = false
	$PlayerHand.visible = false
	$Bin.visible = false
	$Deck.visible = false
	
	display_infos_player(false)
	display_infos_ennemie(false)
	
	$BattleField/CardSlot.visible = false
	$Button.visible = false
	$PlayerHand.connect("hand_size_changed", _on_hand_size_changed)
	
	player_hand_reference = $"../PlayerHand"
	
	player = load("res://slay_the_wc/Entities/Players/Player.tres")
	reset_health_bar($BattleField/Characters/Player/HealthBarPlayer, player, $BattleField/Characters/Player/HealthPlayer)
	
	ennemy = load("res://slay_the_wc/Entities/Ennemies/Patate.tres")
	reset_health_bar($BattleField/Characters/Ennemie1/HealthBarEnnemie, ennemy, $BattleField/Characters/Ennemie1/HealthEnnemy)
	
	init_infos_player(player)
	init_infos_ennemie(ennemy)
	$BattleField/Characters/Player/EnergyPlayer.text = "Energie : " + str(player.energy)
	
	for i in range(0, 5):
		$Deck.draw_card()
		
	player_turn = true
	end_game = false
	intention_ennemie = compute_intention_ennemie()
	
	
func init_infos_player(p: Entity):
	$BattleField/Characters/Player/NamePlayer.text = p.name
	$BattleField/Characters/Player/DefensePlayer.text = str(p.defense)
	
func init_infos_ennemie(ennemie: Entity):
	$BattleField/Characters/Ennemie1/NameEnnemy.text = ennemie.name
	$BattleField/Characters/Ennemie1/DefenseEnnemy.text = str(ennemie.defense)

func _on_hand_size_changed(size):
	if size >= $PlayerHand.MAX_HAND_SIZE:
		$Deck.set_deck_enabled(false)
	else:
		$Deck.set_deck_enabled(true)
		
func battle(card: Card2, card_slot):
	print("Battle")
	if not player_turn or end_game:
		return
		
	intention = ennemy.pattern[0]
	print(intention)
	if intention.type == "Attaque":
		
		$BattleField/Characters/Ennemie1/IntentionEnnemie.texture = load("res://slay_the_wc/Assets/Art/attack.png")
		print($BattleField/Characters/Ennemie1/IntentionEnnemie.texture)
		
		
	if card.data.type == "Defense":
		player.energy = player.energy-card.data.cost
		player.defense = player.defense+card.data.defense
		$BattleField/Characters/Player/DefensePlayer.text = "Defense : " + str(player.defense)
		$BattleField/Characters/Player/EnergyPlayer.text = "Energie : " + str(player.energy)
		
	elif card.data.type == "Attaque":
		player.energy = player.energy-card.data.cost
		ennemy.health = ennemy.health-card.data.attack
		update_health_ui($BattleField/Characters/Ennemie1/HealthBarEnnemie, ennemy, $BattleField/Characters/Ennemie1/HealthEnnemy)
		if ennemy.health <= 0:
			$ResultBattle.text = "Vous avez gagné, GG :)"
			$EndBattle.visible = true
			$BattleField/Characters/Ennemie1/HealthEnnemy.text = "Vie : 0"
			$Button.visible = false
			card_slot.card_in_slot = true
			$Deck.set_deck_enabled(false)
		$BattleField/Characters/Ennemie1/HealthEnnemy.text = "Vie : " + str(ennemy.health)
		$BattleField/Characters/Player/EnergyPlayer.text = "Energie : " + str(player.energy)
		
		
		
	move_card_to_bin(card)
	
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

func compute_intention_ennemie() -> String:
	var random = randi_range(0, 99)
	if random < 25:
		$BattleField/Characters/Ennemie1/IntentionEnnemie.texture = load("res://slay_the_wc/Assets/Art/attack_icon.png")
		return ennemy.pattern[0].type
	elif random < 50:
		$BattleField/Characters/Ennemie1/IntentionEnnemie.texture = load("res://slay_the_wc/Assets/Art/shield_icon.png")
		return ennemy.pattern[1].type
	elif random < 75:
		$BattleField/Characters/Ennemie1/IntentionEnnemie.texture = load("res://slay_the_wc/Assets/Art/up-arrow_icon.png")
		return ennemy.pattern[2].type
	else:
		$BattleField/Characters/Ennemie1/IntentionEnnemie.texture = load("res://slay_the_wc/Assets/Art/down-arrow_icon.png")
		return ennemy.pattern[3].type

# C'est au tour de l'ennemie
func _on_button_pressed() -> void:
	player_turn = false
	
	if intention_ennemie == "ATK":
		if player.defense >= ennemy.pattern[0].attaque:
			player.defense = player.defense - ennemy.pattern[0].attaque
			$BattleField/Characters/Player/DefensePlayer.text = player.defense
		else:
			var nb_degats = ennemy.pattern[0].attaque - player.defense
			player.defense = 0
			$BattleField/Characters/Player/DefensePlayer.text = player.defense
			player.health = player.health - nb_degats
			update_health_ui($BattleField/Characters/Player/HealthBarPlayer, player, $BattleField/Characters/Player/HealthPlayer)
	elif intention_ennemie == "DEF":
		$BattleField/Characters/Ennemie1/IntentionEnnemie.texture = load("res://slay_the_wc/Assets/Art/shield_icon.png")
	elif intention_ennemie == "BUFF":
		$BattleField/Characters/Ennemie1/IntentionEnnemie.texture = load("res://slay_the_wc/Assets/Art/up-arrow_icon.png")
	else:
		$BattleField/Characters/Ennemie1/IntentionEnnemie.texture = load("res://slay_the_wc/Assets/Art/down-arrow_icon.png")
		
	if player.health <= 0:
		$ResultBattle.text = "La patate a été plus fort(e) que vous, une prochaine fois mdr"
		$EndBattle.visible = true
		$BattleField/Characters/Player/HealthPlayer.text = "Vie : 0"
		$Deck.set_deck_enabled(false)
		end_game = true
		return
	player_turn = true
	player.energy = MAX_ENERGY
	# Compute the next move of ennemy
	intention_ennemie = compute_intention_ennemie()
	$BattleField/Characters/Player/EnergyPlayer.text = "Energie : " + str(player.energy)
	$BattleField/Characters/Player/DefensePlayer.text = "0"
	player.defense = 0


func _on_end_battle_pressed() -> void:
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Menus/Main_menu/Main_menu.tscn")


func _on_video_stream_player_finished() -> void:
	$CardManager.visible = true
	$PlayerHand.visible = true
	$Bin.visible = true
	$Deck.visible = true
	display_infos_player(true)
	display_infos_ennemie(true)
	$Button.visible = true

func reset_health_bar(bar: ProgressBar, entity: Entity, textLabel: RichTextLabel):
	bar.max_value = entity.health
	textLabel.text = str(bar.max_value)+"/"+str(entity.health)

func update_health_ui(hp_bar: ProgressBar, entity: Entity, textLabel: RichTextLabel):
	hp_bar.value = entity.health
	textLabel.text = str(entity.health)+"/"+str(hp_bar.max_value)
