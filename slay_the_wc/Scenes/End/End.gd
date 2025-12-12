extends Node2D

	
func _skip_video():
	# Stop the video player so audio/visuals cut immediately
	$VideoControl/VideoStreamPlayer.stop()
	 # Manually call the finish logic
	_on_video_stream_player_finished()

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://slay_the_wc/Scenes/Menus/DeckSelection/deck_selection.tscn")


func _on_skip_scene_pressed() -> void:
	_skip_video()
