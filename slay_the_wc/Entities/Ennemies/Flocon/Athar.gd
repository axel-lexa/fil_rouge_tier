extends Enemy
class_name athar

func _init():
	
	var attack1 = Enemy_attack.new()
	attack1.damage = 6
	attack1.name = "Boink"
	var attack2 = Enemy_attack.new()
	attack2.strengh_buff = 3
	attack2.name = "Concentration"
	attack2.atk_type = Enemy_attack.ATK_TYPE.BUFF
	attacks = [attack1, attack2]
	health = 42
	max_health = health
	name = "Athar"
	image = load("res://slay_the_wc/Assets/Art/enemies/Athar.png")
	
func compute_next_attack():
	
	var random = randi_range(0, 99)
	if random < 25:
		next_atk = attacks[0]
	else:
		next_atk = attacks[1]
	
	update_intention_sprite(next_atk.atk_type)
