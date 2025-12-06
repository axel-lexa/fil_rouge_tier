extends Control

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_button_toggled(toggled_on: bool, index: int) -> void:
	if !toggled_on:
		return
	var btns: Array[Node] = $HBoxContainer/VFlowContainer.get_children().filter(func(child): return child is Button)
	for i in range(btns.size()):
		if i != index:
			(btns[i] as Button).button_pressed = false;

func _on_button_focus_entered(index: int) -> void:
	$HBoxContainer/TabContainer.current_tab = index
