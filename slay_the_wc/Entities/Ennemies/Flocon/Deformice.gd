extends Enemy
class_name deformice

var attack_history: Array[String] = []

var compteur_morsure: int = 0
var compteur_concentration: int = 0

func _init():
	
	var attack1 = Enemy_attack.new()
	attack1.damage = 6
	attack1.name = "Morsure"
	var attack2 = Enemy_attack.new()
	attack2.strengh_buff = 3
	attack2.name = "Concentration"
	attack2.atk_type = Enemy_attack.ATK_TYPE.BUFF
	attacks = [attack1, attack2]
	health = 25
	max_health = health
	name = "Déformice"
	
	image = load("res://slay_the_wc/Assets/Art/enemies/Souris.webp")
	
func compute_next_attack():
	
	var random = randi_range(0, 99)
	if random <= 60:
		if compteur_morsure < 3:
			next_atk = attacks[0]
			compteur_morsure += 1
		else:
			next_atk = attacks[1]
			compteur_morsure = 0
	else:
		if compteur_concentration < 2:
			next_atk = attacks[1]
			compteur_concentration += 1
		else:
			next_atk = attacks[0]
			compteur_concentration = 0
	
	update_intention_sprite(next_atk.atk_type)
