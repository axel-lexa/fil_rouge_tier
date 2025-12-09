extends Node2D

@onready var lancer_bataille: AudioStreamPlayer = $LancerBataille
@onready var retour_menu: AudioStreamPlayer = $retour_menu
@onready var marche_entre_batailles: AudioStreamPlayer = $marche_entre_batailles

const BATTLE_ORDER = [
	"flocon1",
	"flocon2",
	"flocon3",
	"flocon4",
	"flocon5",
	"boss1",
]

func _ready() -> void:
	update_battle_buttons()
	update_roads()
	
	
func get_next_battle() -> String:
	for key in BATTLE_ORDER:
		if PlayerMap.playerBattleDone[key] == false:
			return key
	return ""
	
func update_battle_buttons():
	var next_battle = get_next_battle()

	for battle in $Battles.get_children():
		battle.disabled = battle.name != next_battle

func update_roads():
	var state = PlayerMap.playerBattleDone
	var next_battle = get_next_battle()

	for road in $Roads.get_children():
		road.visible = false

	for i in range(BATTLE_ORDER.size() - 1):
		var current = BATTLE_ORDER[i]
		var next_id = BATTLE_ORDER[i + 1]
		var road_name = "%sTo%s" % [current, next_id]

		var road = $Roads.get_node_or_null(road_name)
		if road == null:
			print("Chemin introuvable :", road_name)
			continue

		if state[current] == true or next_id == next_battle:
			road.visible = true


func _on_battle_1_pressed() -> void:
	lancer_bataille.play()
	await get_tree().create_timer(0.2).timeout
	print("bataille 1")
	#var battle_desc = load("res://slay_the_wc/Scenes/Battle/StepBattle/Battle_1.tres")
	#GameState.current_battle_description = battle_desc
	#get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Battle/Battle.tscn")
	#pass # Replace with function body.


func _on_battle_2_pressed() -> void:
	print("bataille 2")


func _on_battle_3_pressed() -> void:
	print("bataille 3")


func _on_battle_4_pressed() -> void:
	print("bataille 4")


func _on_battle_5_pressed() -> void:
	print("bataille 5")


func _on_battle_final_pressed() -> void:
	print("bataille boss")


func _on_retour_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Menus/Main_menu/Main_menu.tscn")
	pass # Replace with function body.
