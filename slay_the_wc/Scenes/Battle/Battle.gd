extends Node2D

var player
var ennemy: Dictionary[String, Entity] = {}
const MAX_HAND_SIZE = 10
const MAX_ENERGY = 3

var player_turn
var player_hand_reference
var end_game
var intention_ennemie: Dictionary[String, String] = {}
var texture_intention: Dictionary[String, Sprite2D] = {}
var battle_desc: BattleDescription

func display_infos_player(boolean: bool):
	$BattleField/Characters/Player/NamePlayer.visible = boolean
	$BattleField/Characters/Player/HealthPlayer.visible = boolean
	$BattleField/Characters/Player/DefensePlayer.visible = boolean
	$BattleField/Characters/Player/EnergyPlayer.visible = boolean
	$BattleField/Characters/Player/HealthBarPlayer.visible = boolean
	$BattleField/Characters/Player/PlayerImage.visible = boolean
	$BattleField/Characters/Player/DefenseIcon.visible = boolean

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
		
	$BattleField/Characters/Player/EnergyPlayer.text = "Energie : " + str(player.energy)
	
	for i in range(0, 5):
		$Deck.draw_card()
		
	player_turn = true
	end_game = false
	if ennemy.has("ennemie1"):
		texture_intention["ennemie1"] = $BattleField/Characters/Ennemie1/IntentionEnnemie
		intention_ennemie["ennemie1"] = compute_intention_ennemie(ennemy["ennemie1"], texture_intention["ennemie1"])
	if ennemy.has("ennemie2"):
		texture_intention["ennemie2"] = $BattleField/Characters/Ennemie2/IntentionEnnemie
		intention_ennemie["ennemie2"] = compute_intention_ennemie(ennemy["ennemie2"], texture_intention["ennemie2"])
		
	
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

			
	print("Battle="+ennemie_number)
	if not player_turn or end_game:
		return
	print(player_slot)
	if player_slot:
		if card.data.type == "Defense":
			player.energy = player.energy-card.data.cost
			player.defense = player.defense+card.data.defense
			$BattleField/Characters/Player/DefensePlayer.text = str(player.defense)
			$BattleField/Characters/Player/EnergyPlayer.text = "Energie : " + str(player.energy)
			move_card_to_bin(card)
	else:
		if card.data.card_type == "attack":
			print("ATTAQUE !!!!!!!")
			ennemy[ennemie_number].health = 0
			
			update_health_ui($BattleField/Characters/Ennemie1/HealthBarEnnemie, ennemy[ennemie_number], $BattleField/Characters/Ennemie1/HealthEnnemy)
			if ennemy[ennemie_number].health == 0:
				print("ureitgblrgtr")
				Events.battle_ended.emit(true)
				Events.battle_won.emit()
				get_tree().change_scene_to_file("res://Scenes/Menus/CardRewardScreen.tscn")
				return
			pass
		elif card.data.card_type == "Defense":
			$PlayerHand.add_card_to_hand(card, $PlayerHand.DEFAULT_CARD_MOVE_SPEED)
			card.get_node("Area2D/CollisionShape2D").disabled = false
		move_card_to_bin(card)
	
	
	
func move_card_to_bin(card: Card2):
	
	if end_game:
		return
	
	# 1️⃣ Retirer de la main
	$PlayerHand.remove_card_from_hand(card)
	#Ajout CKC
	$Bin.add_to_bin(card)
	#fin ajout CKC
	# 2️⃣ Désactiver le hover pour que le CardManager ne la touche plus
	var card_manager = get_tree().root.get_node("Battle/CardManager")
	card.disconnect("hovered", card_manager.on_hovered_over_card)
	card.disconnect("hovered_off", card_manager.on_hovered_off_card)

	# 3️⃣ Tween pour position + scale
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", $Bin.position, 0.2)
	tween.parallel().tween_property(card, "scale", Vector2(1.1,1.1), 0.2)

func compute_intention_ennemie(entity: Entity, sprite_intention) -> String:
	var random = randi_range(0, 99)
	if random < 25:
		sprite_intention.texture = load("res://slay_the_wc/Assets/Art/attack_icon.png")
		return entity.pattern[0].type
	elif random < 50:
		sprite_intention.texture = load("res://slay_the_wc/Assets/Art/shield_icon.png")
		return entity.pattern[1].type
	elif random < 75:
		sprite_intention.texture = load("res://slay_the_wc/Assets/Art/up-arrow_icon.png")
		return entity.pattern[2].type
	else:
		sprite_intention.texture = load("res://slay_the_wc/Assets/Art/down-arrow_icon.png")
		return entity.pattern[3].type

# Boutton fin de tour appuyé
func _on_button_pressed() -> void:
	player_turn = false
	
	#Ajout CKC - On doit vider la main
	for card in $PlayerHand.player_hand:
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
			$BattleField/Characters/Player/EnergyPlayer.text = "Energie : " + str(player.energy)
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
