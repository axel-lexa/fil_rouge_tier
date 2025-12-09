extends Node

# Gère la run actuelle (PV, Deck actuel, Étage, Seed)

var current_hp: int = 100
var max_hp: int = 100
var current_floor: int = 1
var run_seed: int = 0

func _ready():
	# Initialiser la seed si nécessaire
	if run_seed == 0:
		run_seed = randi()
		seed(run_seed)

func start_new_run():
	current_hp = max_hp
	current_floor = 1
	run_seed = randi()
	seed(run_seed)
	Events.run_started.emit()

func end_run():
	Events.run_ended.emit()

func complete_floor():
	current_floor += 1
	Events.floor_completed.emit()
