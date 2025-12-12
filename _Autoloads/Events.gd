extends Node

func debug_emit():
	print("card_reward_offered has", card_reward_offered.get_connections().size(), "connections")

# SignalBus pour découplage total entre systèmes
# Événements de combat
@warning_ignore_start("unused_signal")
signal battle_started
signal battle_ended(victory: bool)
signal battle_won

# Événements de cartes
signal card_selected(card_data: Resource)
signal card_reward_offered(cards: Array)

# Événements de deck
signal card_added_to_deck(card_data: Resource)
signal deck_updated

# Événements de partie
signal run_started
signal run_ended
signal floor_completed
