# Exemples de cartes

Pour créer des cartes de données, créez des fichiers `.tres` dans ce dossier.

## Format d'une carte

Dans l'éditeur Godot :
1. Clic droit dans le dossier `Cards/Data`
2. Nouveau > Resource
3. Sélectionner `CardData` comme type
4. Remplir les propriétés :
   - `id`: identifiant unique (ex: "strike")
   - `card_name`: nom affiché (ex: "Frappe")
   - `mana_cost`: coût en mana (ex: 1)
   - `description`: description de la carte
   - `target_type`: type de cible ("none", "enemy", "self", "all_enemies")
   - `rarity`: rareté ("common", "uncommon", "rare")
   - `card_type`: type de carte ("attack", "skill", "power")

## Exemples de cartes à créer

### Carte commune - Frappe
- id: "strike"
- card_name: "Frappe"
- mana_cost: 1
- description: "Inflige 6 dégâts"
- target_type: "enemy"
- rarity: "common"
- card_type: "attack"

### Carte commune - Défense
- id: "defend"
- card_name: "Défense"
- mana_cost: 1
- description: "Gagne 5 de blocage"
- target_type: "self"
- rarity: "common"
- card_type: "skill"

### Carte peu commune - Coup puissant
- id: "heavy_strike"
- card_name: "Coup puissant"
- mana_cost: 2
- description: "Inflige 12 dégâts"
- target_type: "enemy"
- rarity: "uncommon"
- card_type: "attack"

### Carte rare - Tempête
- id: "storm"
- card_name: "Tempête"
- mana_cost: 3
- description: "Inflige 8 dégâts à tous les ennemis"
- target_type: "all_enemies"
- rarity: "rare"
- card_type: "attack"

