extends Control

var btns: Array[Node]

func _ready() -> void:
	# array of tab button
	btns = %HBoxContainer/VFlowContainer.get_children().filter(
		func(child): return child is Button
	)
	# set buttons texts to deck name
	for i in range(btns.size()):
		if %TabContainer.get_children().size() > i:
			btns[i].text = %TabContainer.get_children()[i].mascot.deck_name

func _process(_delta: float) -> void:
	pass

func _on_button_toggled(toggled_on: bool, index: int) -> void:
	if !toggled_on:
		%ButtonNext.disabled = true
		return
	for i in range(btns.size()):
		if i != index:
			(btns[i] as Button).button_pressed = false;
	%TabContainer.current_tab = index
	%ButtonNext.disabled = false


func _on_button_next_pressed() -> void:
	var mascotData: MascotData = %TabContainer.get_current_tab_control().mascot
	DeckManager.deck = mascotData.default_cards
	DeckManager.unlockable_cards = mascotData.unlockable_cards
	DeckManager.mascotData = mascotData
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Map/Map.tscn")


func _on_button_return_pressed() -> void:
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Menus/Main_menu/Main_menu.tscn")
