extends Control
@onready var continuer: AudioStreamPlayer = $VBoxContainer/continuer
@onready var hover: AudioStreamPlayer = $VBoxContainer/hover
@onready var booooo: AudioStreamPlayer = $VBoxContainer/booooo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	const lines: Array[String] = ["La foret d'Arpos est un lieu ou les animaux vivent en communauté et en harmonie avec la nature.",
	"Chaque année lors des premières neiges la forêt est insuflée d'un pouvoir magique et mystérieux. Les animaux se regroupent à cette période pour fabriquer de belles constructions à l'éfigie de l'hiver."]
	
	DialogManager.start_dialog(Vector2(0, 0), lines)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when user click on button "Continuer la partie"
func _on_continue_pressed() -> void:
	continuer.play()
	await get_tree().create_timer(1.2).timeout
	print("Continuer la partie")
	#get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Battle/Battle.tscn")
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Map/Map.tscn")
# Called when user click on button "Nouvelle partie"
func _on_new_game_pressed() -> void:
	continuer.play()
	await get_tree().create_timer(1.2).timeout
	print("Nouvelle partie")

# Called when user click on button "Paramètres"
func _on_options_pressed() -> void:
	print("Paramètres")

# Called when user click on button "Quitter la partie"
func _on_exit_game_pressed() -> void:
	get_tree().quit()

#Hover sur TOUS les boutons du menu
func _on_continue_mouse_entered() -> void:
	booooo.stop()
	hover.play()
	pass # Replace with function body.

func _on_new_game_mouse_entered() -> void:
	booooo.stop()
	hover.play()
	pass # Replace with function body.

func _on_options_mouse_entered() -> void:
	booooo.stop()
	hover.play()
	pass # Replace with function body.
	
func _on_exit_game_mouse_entered() -> void:
	booooo.play()
	pass # Replace with function body.
