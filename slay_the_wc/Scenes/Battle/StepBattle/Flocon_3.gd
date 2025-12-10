extends BattleDescription

func _ready():
	nom = "Flocon 3"
	entities = [choppyOrc.new(), greedyMimic.new(), oneTrickMage.new()]
	background = load("res://slay_the_wc/Assets/Art/background_forest_final.ogv")
