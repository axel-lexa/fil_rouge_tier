extends Node2D

func _ready():
	$PlayerHand.connect("hand_size_changed", _on_hand_size_changed)
	
func _on_hand_size_changed(size):
	if size >= $PlayerHand.MAX_HAND_SIZE:
		$Deck.set_deck_enabled(false)
	else:
		$Deck.set_deck_enabled(true)
