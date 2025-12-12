extends Control

var btns: Array[Node]
@onready var son_select_panda: AudioStreamPlayer = $VBoxContainer/HBoxContainer/VFlowContainer/SonSelectPanda
@onready var son_select_bernard: AudioStreamPlayer = $VBoxContainer/HBoxContainer/VFlowContainer/SonSelectBernard
@onready var son_select_loups: AudioStreamPlayer = $VBoxContainer/HBoxContainer/VFlowContainer/SonSelectLoups
@onready var son_select_poulpy: AudioStreamPlayer = $VBoxContainer/HBoxContainer/VFlowContainer/SonSelectPoulpy
@onready var son_select_grosse_mite: AudioStreamPlayer = $VBoxContainer/HBoxContainer/VFlowContainer/SonSelectGrosseMite
@onready var son_select_licorne: AudioStreamPlayer = $VBoxContainer/HBoxContainer/VFlowContainer/SonSelectLicorne
@onready var son_select_phoenix: AudioStreamPlayer = $VBoxContainer/HBoxContainer/VFlowContainer/SonSelectPhoenix

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
	DeckManager.shuffle_deck()
	DeckManager.unlockable_cards = mascotData.unlockable_cards
	DeckManager.mascotData = mascotData
	RunManager.current_team = mascotData.mascotte_name
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Map/Map.tscn")


func _on_button_return_pressed() -> void:
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Menus/Main_menu/Main_menu.tscn")

func _on_button_pressed() -> void:
	son_select_panda.play()

func _on_button_2_pressed() -> void:
	son_select_bernard.play()

func _on_button_3_pressed() -> void:
	son_select_loups.play()

func _on_button_4_pressed() -> void:
	son_select_poulpy.play()

func _on_button_5_pressed() -> void:
	son_select_grosse_mite.play()

func _on_button_6_pressed() -> void:
	son_select_licorne.play()

func _on_button_7_pressed() -> void:
	son_select_phoenix.play()
