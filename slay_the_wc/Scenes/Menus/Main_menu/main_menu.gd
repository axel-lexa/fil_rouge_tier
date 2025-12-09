extends Control
@onready var continuer: AudioStreamPlayer = $VBoxContainer/continuer
@onready var hover: AudioStreamPlayer = $VBoxContainer/hover
@onready var booooo: AudioStreamPlayer = $VBoxContainer/booooo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	hide_informations(false)
	
	#const lines: Array[String] = ["La foret d'Arpos est un lieu ou les animaux vivent en communauté et en harmonie avec la nature.",
	#"Chaque année lors des premières neiges la forêt est insuflée d'un pouvoir magique et mystérieux. Les animaux se regroupent à cette période pour fabriquer de belles constructions à l'éfigie de l'hiver."]
	
	#DialogManager.start_dialog(Vector2(0, 0), lines)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func hide_informations(boolean: bool):
	$VBoxContainer/Continue.visible = boolean
	$VBoxContainer/NewGame.visible = boolean
	$VBoxContainer/Options.visible = boolean
	$VBoxContainer/ExitGame.visible = boolean
	$TitleGame.visible = boolean
	$LogoWinterCup.visible = boolean
	$LogoWinterCup2.visible = boolean
	$Copyright.visible = boolean
	
	
	

func show_elements_progressively():
	
	# Liste des éléments du menu dans l'ordre d'apparition
	var elements = [
		$TitleGame,
		$LogoWinterCup,
		$LogoWinterCup2,
		$VBoxContainer/Continue,
		$VBoxContainer/NewGame,
		$VBoxContainer/Options,
		$VBoxContainer/ExitGame,
		$Copyright
	]
	
	for element in elements:
		element.visible = true
		
		# Optionnel : fade-in
		element.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(element, "modulate:a", 1.0, 0.4)
		
		# Attendre avant d'afficher le suivant
		await get_tree().create_timer(0.25).timeout
	
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
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Introduction/Introduction.tscn")

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


func _on_video_stream_player_finished() -> void:
	show_elements_progressively()
