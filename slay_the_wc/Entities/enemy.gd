extends Entity
class_name Enemy

var intention : String = "ATK"


func perform_action(action_type: String):
	pass

func compute_intention() -> String:
	var random = randi_range(0, 99)
	if random < 25:
		intention = pattern[0].type
	elif random < 50:
		intention = pattern[1].type
	elif random < 75:
		intention = pattern[2].type
	else:
		intention = pattern[3].type
	return intention
	
