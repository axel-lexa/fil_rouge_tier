extends BattleDescription
class_name flocon3
func _init():
	nom = "Flocon 3"
	entities = [choppyOrc.new(), greedyMimic.new(), oneTrickMage.new()]
	background = load("res://slay_the_wc/Assets/Art/BackgroundBattle/Biome-plaine-animé.ogv")
