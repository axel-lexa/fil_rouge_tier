extends Resource
class_name CardData

# Ressource de base pour décrire une carte
@export var id: String = ""
@export var card_name: String = ""
@export var mana_cost: int = 0
@export var description: String = ""
@export var target_type: String = "none"  # "none", "enemy", "self", "all_enemies"
@export var rarity: String = "common"  # "common", "uncommon", "rare"
@export var card_type: String = "attack"  # "attack", "skill", "power"
@export var icon: Texture2D = null
@export var background: Texture2D = null

# Liste des effets (sera remplie avec des resources Effect)
@export var effects: Array[Resource] = []

func _init():
	if id.is_empty():
		id = card_name.to_lower().replace(" ", "_")
