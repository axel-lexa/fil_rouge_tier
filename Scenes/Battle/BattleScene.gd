extends Node2D
class_name BattleScene

# Scène principale de combat
# Intègre le TurnManager

@onready var turn_manager: TurnManager = $TurnManager

func _ready():
	# Démarrer le combat
	Events.battle_started.emit()

# Fonction de test pour déclencher une victoire
func _input(event):
	if event.is_action_pressed("ui_accept"):  # Appuyer sur Entrée pour tester
		if turn_manager.current_state == TurnManager.BattleState.PLAYER_TURN:
			turn_manager.test_win_battle()

