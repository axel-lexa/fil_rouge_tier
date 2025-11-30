extends Node
class_name TurnManager

# Machine à états pour piloter le combat
# États: StartTurn -> PlayerTurn -> Resolution -> EnemyTurn -> EndTurn

enum BattleState {
	START_TURN,
	PLAYER_TURN,
	RESOLUTION,
	ENEMY_TURN,
	END_TURN,
	BATTLE_WON,
	BATTLE_LOST
}

var current_state: BattleState = BattleState.START_TURN
var enemies_alive: Array = []  # Liste des ennemis en vie

func _ready():
	# S'abonner aux événements
	Events.battle_started.connect(_on_battle_started)
	
	# Initialiser l'état
	current_state = BattleState.START_TURN

func _on_battle_started():
	current_state = BattleState.START_TURN
	start_turn()

func start_turn():
	current_state = BattleState.START_TURN
	# Logique de début de tour (piocher des cartes, etc.)
	transition_to_player_turn()

func transition_to_player_turn():
	current_state = BattleState.PLAYER_TURN
	# Le joueur peut jouer des cartes

func end_player_turn():
	current_state = BattleState.RESOLUTION
	# Résoudre les effets
	transition_to_enemy_turn()

func transition_to_enemy_turn():
	current_state = BattleState.ENEMY_TURN
	# Les ennemis agissent
	check_battle_end()

func check_battle_end():
	# Vérifier si tous les ennemis sont morts
	if enemies_alive.is_empty():
		win_battle()
		return
	
	# Vérifier si le joueur est mort
	if RunManager.current_hp <= 0:
		lose_battle()
		return
	
	# Continuer le combat
	end_turn()

func end_turn():
	current_state = BattleState.END_TURN
	# Nettoyer les effets de fin de tour
	start_turn()

func win_battle():
	current_state = BattleState.BATTLE_WON
	Events.battle_won.emit()
	Events.battle_ended.emit(true)

func lose_battle():
	current_state = BattleState.BATTLE_LOST
	Events.battle_ended.emit(false)

# Fonction utilitaire pour tester (à appeler depuis l'extérieur)
func test_win_battle():
	win_battle()
