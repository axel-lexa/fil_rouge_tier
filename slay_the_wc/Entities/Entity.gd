extends Resource
class_name Entity

@export var name: String
@export var health: int
@export var max_health: int
@export var defense: int
@export var strenght: int
@export var weakness_debuff: int
@export var fragility_debuff: int
@export var image: Texture2D

var components : Entity_components


func apply_damage_and_check_lifestatus(amount : int) -> bool:
	amount += fragility_debuff
	var dmg = amount - defense
	if dmg <= 0:
		defense -= amount
		return true
	defense = 0
	health = clamp(health-dmg, 0, max_health)
	update_ui()
	return health > 0

func heal(amount: int):
	health = clamp(health+amount, 0, max_health)
	update_health_ui()

func add_defense(amount: int):
	defense += amount
	update_defense_ui()

func multiply_defense(multiplier: int):
	defense *= multiplier
	update_defense_ui()

func update_ui():
	update_health_ui()
	update_defense_ui()

func update_health_ui():
	components.health_bar.value = health    
	components.health_label.text = str(health)+"/"+str(max_health)

func update_defense_ui():
	if defense <= 0:
		components.defense_icon.visible = false
		components.defense_label.visible = false
	else:
		components.defense_icon.visible = true
		components.defense_label.visible = true
		components.defense_label.text = str(defense)

func setup_ui():
	components.health_bar.max_value = max_health
	components.health_bar.value = health 
	components.name_label.text = name
	components.sprite.texture = image
	components.turn_ui_on()
	update_ui()

func add_strenght(amount: int):
	strenght += amount

func turn_ui_off():
	components.turn_ui_off()

func turn_ui_on():
	components.turn_ui_on()
