# This class is used to describe enemies attacks
# If you do not want to apply debuffs, deal damage, or whatever, simply keep 0 as a value for any unused parameter
extends Resource

class_name Enemy_attack

enum ATK_TYPE {ATK, DEF, BUFF, DEBUFF}

@export var name: String = "feur"
@export var atk_type: ATK_TYPE = ATK_TYPE.ATK
@export var damage: int = 0
@export var multi_hit_damages: Array[int] = [0]
@export var strengh_buff: int = 0
@export var weakness_debuff: int = 0
@export var useless_cards_to_add: int = 0
@export var burn: int = 0
@export var defense: int = 0
@export var vulnerability_debuff: int = 0
@export var cleanse_debuff: bool = false
