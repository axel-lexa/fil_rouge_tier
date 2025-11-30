# Système de Récompense de Cartes

Ce document explique comment fonctionne le système de sélection de cartes en fin de partie.

## Vue d'ensemble

À la fin de chaque combat gagné, le joueur se voit proposer 3 cartes aléatoires parmi les cartes débloquées. Il doit en choisir une pour l'ajouter à son deck.

## Architecture

### Composants principaux

1. **CardRewardManager** (`Systems/CardSystem/CardRewardManager.gd`)
   - Gère la génération des récompenses de cartes
   - Sélectionne 3 cartes aléatoires selon les poids de rareté
   - Déclenche l'événement `card_reward_offered` quand un combat est gagné

2. **CardRewardScreen** (`Scenes/Menus/CardRewardScreen.gd`)
   - Interface utilisateur pour afficher les 3 cartes
   - Permet au joueur de sélectionner une carte
   - Émet l'événement `card_selected` quand une carte est choisie

3. **DeckManager** (`Systems/CardSystem/DeckManager.gd`)
   - Gère le deck du joueur
   - Ajoute automatiquement la carte sélectionnée au deck

4. **Events** (`_Autoloads/Events.gd`)
   - SignalBus central pour la communication entre systèmes
   - Événements clés :
     - `battle_won` : déclenché quand un combat est gagné
     - `card_reward_offered(cards)` : déclenché quand 3 cartes sont proposées
     - `card_selected(card_data)` : déclenché quand le joueur choisit une carte

## Flux d'exécution

1. **Fin de combat** : Le `TurnManager` émet `battle_won`
2. **Génération des récompenses** : `CardRewardManager` génère 3 cartes et émet `card_reward_offered`
3. **Affichage de l'écran** : `CardRewardScreen` affiche les 3 cartes
4. **Sélection** : Le joueur clique sur une carte
5. **Ajout au deck** : `DeckManager` ajoute la carte sélectionnée au deck

## Configuration

### CardRewardManager

Dans l'éditeur Godot, configurez le `CardRewardManager` (autoload) :

1. **all_cards** : Ajoutez toutes les cartes du jeu (fichiers `.tres` de type `CardData`)
2. **unlocked_cards** : Liste des cartes débloquées (par défaut, toutes les cartes)
3. **Probabilités de rareté** :
   - `common_weight` : 70 (70% de chance)
   - `uncommon_weight` : 25 (25% de chance)
   - `rare_weight` : 5 (5% de chance)

### Création de cartes

1. Créez des fichiers `.tres` dans `Cards/Data/`
2. Type de ressource : `CardData`
3. Remplissez les propriétés (voir `Cards/Data/ExampleCards.md`)

## Utilisation

### Déclencher manuellement (pour tester)

```gdscript
# Dans n'importe quel script
Events.battle_won.emit()
```

### Personnaliser l'écran de récompense

L'écran de récompense peut être personnalisé en modifiant :
- `Scenes/Menus/CardRewardScreen.gd` : Logique d'affichage
- `Scenes/Menus/CardRewardScreen.tscn` : Interface utilisateur

### Ajouter une scène de carte UI personnalisée

Dans `CardRewardScreen.gd`, assignez une scène à `card_ui_scene` :
```gdscript
card_ui_scene = preload("res://Cards/Scenes/CardTemplate.tscn")
```

La scène doit avoir une méthode `set_card_data(card_data: CardData)`.

## Exemple d'intégration

```gdscript
# Dans votre système de combat
func win_battle():
    Events.battle_won.emit()  # Déclenche automatiquement la récompense
```

## Personnalisation avancée

### Filtrer les cartes disponibles

Modifiez `CardRewardManager.generate_card_reward()` pour ajouter des filtres :
```gdscript
# Exemple : exclure certaines cartes
var filtered_cards = unlocked_cards.filter(func(card): 
    return card.card_type != "power"
)
```

### Changer le nombre de cartes proposées

Modifiez la boucle dans `generate_card_reward()` :
```gdscript
for i in range(5):  # Proposer 5 cartes au lieu de 3
```

### Ajouter des animations

Dans `CardRewardScreen.show_reward_screen()`, ajoutez des animations :
```gdscript
# Exemple avec Tween
var tween = create_tween()
tween.tween_property(self, "modulate:a", 1.0, 0.3)
```

