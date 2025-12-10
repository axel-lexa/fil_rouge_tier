extends Resource
class_name CardData

enum TargetTypeEnum {
	NONE,
	ENEMY,
	SELF,
	ALL_ENEMIES,
	RANDOM,
}

enum RarityEnum {
	COMMON,
	UNCOMMON,
	RARE,
}

enum CardTypeEnum {
	ATTACK,
	SKILL,
	POWER
}

enum OwnerTeamEnum {
	COMMON,
	_12_PANDAS,
	BIBI,
	_5D6,
	CONFRERIE_BEURRE_SALE,
	AIXASPERANTS,
	PENTAMONSTRES,
	UWU
}

# Ressource de base pour décrire une carte
@export var id: String = ""
@export var card_name: String = ""
@export var mana_cost: int = 0
@export_multiline var description: String = ""
@export var target_type: TargetTypeEnum = TargetTypeEnum.NONE
@export var rarity: RarityEnum = RarityEnum.COMMON
@export var card_type: CardTypeEnum = CardTypeEnum.ATTACK
@export var icon: CompressedTexture2D = null
@export var background: CompressedTexture2D = null
@export var card_team_owner: OwnerTeamEnum = OwnerTeamEnum.COMMON
@export var exil: bool = false
@export var draftable: bool = true

# Liste des effets (sera remplie avec des resources Effect)
@export var effects: Array[Resource] = []

func _init():
	if id.is_empty():
		id = card_name.to_lower().replace(" ", "_")
