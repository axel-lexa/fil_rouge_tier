extends Node2D

var card_in_slot = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Slot4=", $Area2D.collision_mask)
