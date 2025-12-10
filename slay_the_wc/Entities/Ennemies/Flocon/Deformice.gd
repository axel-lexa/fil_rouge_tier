extends Enemy
class_name deformice

var attack_history: Array[String] = []

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
	
	image = load("res://slay_the_wc/Assets/Art/patate_ennemie.png")
	
func compute_next_attack():
	var possible_attacks = []

	# 60% morsure
	if can_use_attack("Morsure"):
		possible_attacks.append({"name":"Morsure", "weight": 0.6})

	# 40% concentration
	if can_use_attack("Concentration"):
		possible_attacks.append({"name":"Concentration", "weight": 0.4})

	# Sécurité : si rien n’est possible (rare mais possible)
	if possible_attacks.is_empty():
		# Choisit la moins restrictive = Morsure
		next_atk = attacks[0]
		return

	# Tirage pondéré
	var rnd = randf()
	var cumulative = 0.0

	for atk in possible_attacks:
		cumulative += atk["weight"]
		if rnd <= cumulative:
			next_atk = attacks[1]
			break

	# Mise à jour de l’historique
	attack_history.append(next_atk.name)

	# Garde la taille raisonnable
	if attack_history.size() > 5:
		attack_history.pop_front()

	update_intention_sprite(next_atk.atk_type)

func can_use_attack(attack_name: String) -> bool:
	if attack_name == "Morsure":
		# On vérifie si les 2 derniers coups sont "Morsure"
		if attack_history.size() >= 2 and attack_history[-1] == "Morsure" and attack_history[-2] == "Morsure":
			return false

	if attack_name == "Concentration":
		# On vérifie si le dernier coup est "Concentration"
		if attack_history.size() >= 1 and attack_history[-1] == "Concentration":
			return false

	return true
