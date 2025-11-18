extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when user click on button "Continuer la partie"
func _on_continue_pressed() -> void:
	print("Continuer la partie")

# Called when user click on button "Nouvelle partie"
func _on_new_game_pressed() -> void:
	print("Nouvelle partie")

# Called when user click on button "Paramètres"
func _on_options_pressed() -> void:
	print("Paramètres")

# Called when user click on button "Quitter la partie"
func _on_exit_game_pressed() -> void:
	get_tree().quit()
