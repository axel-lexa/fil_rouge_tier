class_name DeckTab extends ScrollContainer

@export var mascotte: CompressedTexture2D
@export var deck_name: String
@export var description: String
@export var mcards: MascotCards

var card_scene = preload("res://slay_the_wc/Cards/UICard/UICard.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if mascotte:
		$MarginContainer/VBoxContainer/MarginContainer/TextureRect.texture = mascotte
	if deck_name:
		$MarginContainer/VBoxContainer/MarginContainer5/Label.text = deck_name
	if description:
		$MarginContainer/VBoxContainer/MarginContainer4/Label2.text = description

	if mcards:
		for data in mcards.default_cards:
			var card_to_add = card_scene.instantiate()
			card_to_add.data = data
			$MarginContainer/VBoxContainer/FoldableContainer/HFlowContainer.add_child(card_to_add)
		for data in mcards.unlockable_cards:
			var card_to_add = card_scene.instantiate()
			card_to_add.data = data
			$MarginContainer/VBoxContainer/FoldableContainer2/HFlowContainer.add_child(card_to_add)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
