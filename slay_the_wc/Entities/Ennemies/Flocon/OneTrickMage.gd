extends Enemy
class_name oneTrickMage

var turn: int = 0

func _ready():
	
	var attack1 = Enemy_attack.new()
	attack1.damage = 25
	attack1.name = "Boule de feu"
	attacks = [attack1]
	health = 24
	name = "One Trick Mage"
	image = load("res://slay_the_wc/Assets/Art/patate_ennemie.png")
	
	
func compute_next_attack():
	
	if turn % 2 == 0:
		next_atk = attacks[0]
		update_intention_sprite(next_atk.atk_type)
	else:
		next_atk = null
