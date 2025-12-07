extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var json = JSON.new()
	var file = FileAccess.open("res://slay_the_wc/Assets/Dialog/intro.json", FileAccess.READ)
	var json_text = file.get_as_text()
	var error = json.parse(json_text)
	file.close()
	if error == OK:
		var data_received = json.data
		var dialogs: Array[String] = []
		for i in data_received["text"]:
			dialogs.append(i)
		DialogManager.start_dialog(Vector2(0, 750), dialogs)
	


func _on_skip_scene_pressed() -> void:
	DialogManager.skip_all_dialog()
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Map/Map.tscn")
