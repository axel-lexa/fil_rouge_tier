extends Enemy
class_name techRex

func _ready():
	
	var attack1 = Enemy_attack.new()
	attack1.damage = 9
	attack1.name = "Chute"
	
func compute_next_attack():
	next_atk = attacks[0]
	update_intention_sprite(next_atk.atk_type)
