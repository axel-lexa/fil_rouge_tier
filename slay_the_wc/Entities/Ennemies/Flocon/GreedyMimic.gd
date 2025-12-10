extends Enemy
class_name greedyMimic

func _init():
	
	var attack1 = Enemy_attack.new()
	attack1.damage = 9
	attack1.name = "Boink"
	
	attacks = [attack1]
	health = 15
	name = "Greedy Mimic"
	image = load("res://slay_the_wc/Assets/Art/patate_ennemie.png")
	
func compute_next_attack():
	next_atk = attacks[0]
	update_intention_sprite(next_atk.atk_type)
