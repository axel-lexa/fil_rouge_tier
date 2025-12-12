extends Node

# État global de l'application
# Gère l'écran de récompense de cartes globalement

var card_reward_screen: CardRewardScreen = null

func _ready():
	# Créer et ajouter l'écran de récompense à la scène racine
	var reward_screen_scene = preload("res://Scenes/Menus/CardRewardScreen.tscn")
	card_reward_screen = reward_screen_scene.instantiate()
	get_tree().root.add_child.call_deferred(card_reward_screen)
	card_reward_screen.z_index = 1000  # S'assurer qu'il est au-dessus de tout
	card_reward_screen.visible = false  # Masquer par défaut
