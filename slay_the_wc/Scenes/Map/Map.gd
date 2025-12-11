extends Node2D

@onready var lancer_bataille: AudioStreamPlayer = $LancerBataille
@onready var retour_menu: AudioStreamPlayer = $retour_menu
@onready var marche_entre_batailles: AudioStreamPlayer = $marche_entre_batailles

func _ready() -> void:
	update_battle_buttons()
	update_roads()

	
func update_battle_buttons():
	var next_battle = "flocon"+str(RunManager.current_floor)
	print(next_battle)

	for battle in $Battles.get_children():
		battle.disabled = battle.name != next_battle

func update_roads():

	for road in $Roads.get_children():
		road.visible = false

	for i in range(0, RunManager.current_floor-1):
		var road_name = "flocon%sToflocon%s" % [i+1, i+2]

		var road = $Roads.get_node_or_null(road_name)
		if road == null:
			print("Chemin introuvable :", road_name)
			continue

		if i< RunManager.current_floor:
			road.visible = true


func _on_battle_1_pressed() -> void:
	lancer_bataille.play()
	await get_tree().create_timer(0.2).timeout
	print("bataille 1")
	var battle_desc = flocon1.new()
	GameState.current_battle_description = battle_desc
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Battle/Battle.tscn")
	#pass # Replace with function body.


func _on_battle_2_pressed() -> void:
	lancer_bataille.play()
	await get_tree().create_timer(0.2).timeout
	print("bataille 2")
	var battle_desc = flocon2.new()
	GameState.current_battle_description = battle_desc
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Battle/Battle.tscn")


func _on_battle_3_pressed() -> void:
	lancer_bataille.play()
	await get_tree().create_timer(0.2).timeout
	print("bataille 3")
	var battle_desc = flocon3.new()
	GameState.current_battle_description = battle_desc
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Battle/Battle.tscn")


func _on_battle_4_pressed() -> void:
	lancer_bataille.play()
	await get_tree().create_timer(0.2).timeout
	print("bataille 4")
	var battle_desc = flocon4.new()
	GameState.current_battle_description = battle_desc
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Battle/Battle.tscn")


func _on_battle_5_pressed() -> void:
	lancer_bataille.play()
	await get_tree().create_timer(0.2).timeout
	print("bataille 5")
	var battle_desc = flocon5.new()
	GameState.current_battle_description = battle_desc
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Battle/Battle.tscn")


func _on_battle_final_pressed() -> void:
	lancer_bataille.play()
	await get_tree().create_timer(0.2).timeout
	print("bataille Boss")
	var battle_desc = bossFlocon.new()
	GameState.current_battle_description = battle_desc
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Battle/Battle.tscn")


func _on_retour_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Menus/Main_menu/Main_menu.tscn")
	pass # Replace with function body.
