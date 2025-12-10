extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Retour.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_video_stream_player_finished() -> void:
	$Retour.visible = true


func _on_retour_pressed() -> void:
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Menus/Main_menu/Main_menu.tscn")

func _skip_video():
	# Stop the video player so audio/visuals cut immediately
	$VideoContainer/VideoStreamPlayer.stop()
	 # Manually call the finish logic
	_on_video_stream_player_finished()

func _on_skip_pressed() -> void:
	$VideoContainer/VideoStreamPlayer.stop()
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Menus/Main_menu/Main_menu.tscn")
