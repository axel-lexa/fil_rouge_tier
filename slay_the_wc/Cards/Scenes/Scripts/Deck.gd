extends Node2D

func _ready() -> void:
	print(">>> Deck.gd _ready called")
	print(">>> Label found? ", $RichTextLabel)
	DeckManager.register_deck_label($RichTextLabel)

func set_deck_enabled(enabled: bool):
	$Area2D/CollisionShape2D.disabled = not enabled
	$Sprite2D.modulate = Color.WHITE if enabled else Color(0.6, 0.6, 0.6)
	$RichTextLabel.modulate = Color.WHITE if enabled else Color(0.6, 0.6, 0.6)
