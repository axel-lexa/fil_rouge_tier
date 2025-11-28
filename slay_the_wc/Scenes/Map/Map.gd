extends Node2D

@onready var battle1 = $Battle1
@onready var battle2 = $Battle2
@onready var battle3 = $Battle3
@onready var battle4 = $Battle4
@onready var battle5 = $Battle5
@onready var line1To2 = $Line1To2
@onready var line2To3 = $Line2To3
@onready var line3To4 = $Line3To4
@onready var line4To5 = $Line4To5
@onready var battle_final = $BattleFinal
@onready var line5ToFinal = $Line5ToFinal

func _process(_delta: float) -> void:
	generate_line(battle1, battle2, line1To2)
	generate_line(battle2, battle3, line2To3)
	generate_line(battle3, battle4, line3To4)
	generate_line(battle4, battle5, line4To5)
	generate_line(battle5, battle_final, line5ToFinal)
	
func generate_line(b1, b2, l1To2):
	var p0 = get_center(b1)
	var p3 = get_center(b2)
	# Point de contrôle pour créer la courbe
	var mid = (p0 + p3) / 2
	var control_offset = Vector2(0, -150)  # vers le haut (change le sens en inversant)

	var c1 = mid + control_offset
	var c2 = mid + control_offset

	# Génération des points de la courbe
	var curve_points = []
	for t in range(21): # 0..20 -> 21 segments = courbe fluide
		var k = t / 20.0
		var point = cubic_bezier_point(p0, c1, c2, p3, k)
		curve_points.append(point)

	l1To2.points = curve_points
	
func cubic_bezier_point(p0, c1, c2, p3, t):
	return (
		p0 * pow(1 - t, 3)
		+ c1 * 3 * pow(1 - t, 2) * t
		+ c2 * 3 * (1 - t) * pow(t, 2)
		+ p3 * pow(t, 3)
	)

func get_center(node):
	return node.get_global_rect().get_center()


func _on_battle_1_pressed() -> void:
	var battle_desc = load("res://slay_the_wc/Scenes/Battle/StepBattle/Battle_1.tres")
	GameState.current_battle_description = battle_desc
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Battle/Battle.tscn")
	pass # Replace with function body.


func _on_battle_2_pressed() -> void:
	pass # Replace with function body.


func _on_battle_3_pressed() -> void:
	pass # Replace with function body.


func _on_battle_4_pressed() -> void:
	pass # Replace with function body.


func _on_battle_5_pressed() -> void:
	pass # Replace with function body.


func _on_battle_final_pressed() -> void:
	pass # Replace with function body.
