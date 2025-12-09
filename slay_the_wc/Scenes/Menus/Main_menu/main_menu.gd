extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Si une sauvegarde existe, charger automatiquement après un court délai
	# pour restaurer l'état du jeu
	if SaveManager.has_save_data:
		await get_tree().create_timer(0.1).timeout
		SaveManager.load_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when user click on button "Continuer la partie"
func _on_continue_pressed() -> void:
	print("Continuer la partie")
	if SaveManager.has_save_data:
		# Charger la sauvegarde (elle chargera automatiquement la bonne scène)
		SaveManager.load_game()
	else:
		# Pas de sauvegarde, aller à la map
		get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Map/Map.tscn")

# Called when user click on button "Nouvelle partie"
func _on_new_game_pressed() -> void:
	print("Nouvelle partie")
	# Supprimer la sauvegarde existante
	SaveManager.delete_save()
	# Réinitialiser RunManager
	RunManager.start_new_run()
	# Aller à la map
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Map/Map.tscn")

# Called when user click on button "Paramètres"
func _on_options_pressed() -> void:
	print("Paramètres")

# Called when user click on button "Quitter la partie"
func _on_exit_game_pressed() -> void:
	get_tree().quit()
