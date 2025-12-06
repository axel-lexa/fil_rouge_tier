extends Resource
class_name MascotData

@export var mascotte_img: CompressedTexture2D
@export var mascotte_name: String
@export var deck_name: String
@export_multiline var description: String
@export var default_cards :Array[CardData]
@export var unlockable_cards :Array[CardData]
