extends Node2D

const CARD_SCENE_PATH = "res://slay_the_wc/Cards/Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2

var player_deck = [load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"), 
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"),
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"), 
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"),
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"),
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"), 
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"),
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"),
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"),
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"),
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"),
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"),
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"),
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"),
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres"), 
load("res://slay_the_wc/Cards/Data/Commun/Baston.tres")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = str(player_deck.size())

#Ajout CKC
func add_card(card:Card2):
	player_deck.append(card)
#Ajout CKC

func draw_card():
	# SI le joueur n'a plus de cartes dans son deck
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
		#Ajout CKC
		#Mettre la pile de défausse dans la pile de draw appelle shuffle_deck_from_bin
		shuffle_deck_from_bin()
		#Fin ajout CKC
	else :
		var card_draw = player_deck[0]
		player_deck.erase(card_draw)
		# On met a jour le libelle qui compte le nombre de cartes restantes du deck
		$RichTextLabel.text = str(player_deck.size())
		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		new_card.data = card_draw
		$"../PlayerHand".add_child(new_card)
		#new_card. = "Card"

		var hand = $"../PlayerHand"
		if hand.player_hand.size() < hand.MAX_HAND_SIZE:
			hand.add_card_to_hand(new_card, CARD_DRAW_SPEED)
		else:
			return
	

func set_deck_enabled(enabled: bool):
	$Area2D/CollisionShape2D.disabled = not enabled
	$Sprite2D.modulate = Color.WHITE if enabled else Color(0.6, 0.6, 0.6)
	$RichTextLabel.modulate = Color.WHITE if enabled else Color(0.6, 0.6, 0.6)	

#Ajout CKC
func shuffle_deck() -> void:
	player_deck.shuffle()
	
func shuffle_deck_from_bin():
	if player_deck.size() > 0:
		return
	for i in range(0, $"../Bin".player_bin.size()):
		self.add_card($"../Bin".player_bin[i])
	player_deck.shuffle()
		
#Fin ajout CKC
