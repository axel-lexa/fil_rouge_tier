extends Enemy
class_name techRex

var next_attack_index = 0

func _init():
	
	var attack1 = Enemy_attack.new()
	attack1.damage = 9
	attack1.name = "Chute"
	var attack2 = Enemy_attack.new()
	attack2.name = "Retry"
	attack2.atk_type = Enemy_attack.ATK_TYPE.DEBUFF
	attack2.useless_cards_to_add = 2
	attacks = [attack1, attack2]
	
	health = 40
	max_health = health
	name = "Techrex"
	image = load("res://slay_the_wc/Assets/Art/enemies/tech rex.png")
	
func compute_next_attack():
	next_atk = attacks[next_attack_index]
	if next_attack_index == 0 : 
		next_attack_index = 1 
	else:
		next_attack_index = 0
	update_intention_sprite(next_atk.atk_type)
