class_name DeckTab extends ScrollContainer

@export var mascotte: CompressedTexture2D
@export var description: String
@export var start_deck: Array[Card]
@export var card_list: Array[Card]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/MarginContainer/TextureRect.texture = mascotte
	$MarginContainer/VBoxContainer/MarginContainer4/Label2.text = description
	for card in start_deck:
		$MarginContainer/VBoxContainer/FoldableContainer/HFlowContainer.add_child(card)
	for card in card_list:
		$MarginContainer/VBoxContainer/FoldableContainer2/HFlowContainer.add_child(card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
