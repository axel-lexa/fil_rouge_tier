extends Entity
class_name Enemy

var intention_sprite : Sprite2D
var id : int
var next_atk: Enemy_attack
@export var attacks: Array[Enemy_attack] = []


func perform_action(player: Entity):
	print("Enemy " + name + " playing attack " + next_atk.name)
	if next_atk.damage != 0:
		attack(player, next_atk.damage)
	if next_atk.strengh_buff != 0:
		add_strenght(next_atk.strengh_buff)

func compute_next_attack():
	next_atk = attacks.get(randi_range(0, attacks.size()-1))
	update_intention_sprite(next_atk.atk_type)
	
func set_intention_sprite(sprite: Sprite2D):
	intention_sprite = sprite

func update_intention_sprite(atk_type: Enemy_attack.ATK_TYPE):
	if intention_sprite != null:
		if atk_type == Enemy_attack.ATK_TYPE.ATK:
			intention_sprite.texture = load("res://slay_the_wc/Assets/Art/attack_icon.png")
		elif atk_type == Enemy_attack.ATK_TYPE.DEF:
			intention_sprite.texture = load("res://slay_the_wc/Assets/Art/shield_icon.png")
		elif atk_type == Enemy_attack.ATK_TYPE.BUFF:
			intention_sprite.texture = load("res://slay_the_wc/Assets/Art/up-arrow_icon.png")
		elif atk_type == Enemy_attack.ATK_TYPE.DEBUFF:
			intention_sprite.texture = load("res://slay_the_wc/Assets/Art/down-arrow_icon.png")

func attack(target: Entity, amount: int):
	amount = clamp(amount + (strenght - weakness_debuff), 0, 999999)
	target.apply_damage_and_check_lifestatus(amount)
