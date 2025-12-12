extends Enemy
class_name bruleSonge

var turn: int = 0
var current_index: int = 0
var index: Array[int]

func _init():
	var attack1 = Enemy_attack.new()
	attack1.name = "Attaque flamboyante"
	attack1.damage = 20
	
	var attack2 = Enemy_attack.new()
	attack2.name = "Attaque brûlante"
	attack2.damage = 6
	attack2.burn =+ 2
	
	var attack3 = Enemy_attack.new()
	attack3.name = "Tacle"
	attack3.damage = 10
	
	var attack4 = Enemy_attack.new()
	attack4.name = "Enflammer"
	attack4.atk_type = attack4.ATK_TYPE.BUFF
	attack4.defense += 12
	attack4.strengh_buff += 2 
	
	var attack5 = Enemy_attack.new()
	attack5.name = "Chaleur infernal"
	attack5.damage += 12
	attack5.strengh_buff += 3
	
	index = [1, 2, 1, 3, 2, 1, 4]
	
	attacks = [attack1, attack2, attack3, attack4, attack5]
	
	health = 250
	max_health = 250
	image = load("res://slay_the_wc/Assets/Art/enemies/fire-modified.png")
	name = "BruleSonge"

func compute_next_attack():
	if turn == 0:
		#next_atk = null
		#update_intention_sprite(next_atk.atk_type)
		#turn += 1
		#return
	#if turn == 1:
		next_atk = attacks[0]
		update_intention_sprite(next_atk.atk_type)
		turn += 1
		return
	if current_index >= index.size():
		current_index = 0
	next_atk = attacks[index[current_index]]
	current_index += 1
	update_intention_sprite(next_atk.atk_type)
	
		
	
	
