structure de fichiers : 
```
res://
├── _Autoloads/
│   ├── Events.gd           # SignalBus (découplage total)
│   ├── GameManager.gd      # État global de l'application
│   └── RunManager.gd       # Gère la run actuelle (PV, Deck actuel, Étage, Seed)
├── Assets/
│   ├── Art/                # Sprites des cartes, icônes, ennemis
│   └── DataTables/         # CSV ou JSON (si vous importez des data d'Excel)
├── Cards/                  # Tout ce qui concerne les cartes
│   ├── Base/               # Scripts de base (CardUI.gd, CardData.gd)
│   ├── Data/               # Les RESSOURCES (.tres) : Strike, Defend, Fireball...
│   ├── Scenes/             # La scène visuelle de la carte (CardTemplate.tscn)
│   └── Scripts/            # Logiques spécifiques (Targeting, Dragging)
├── Effects/                # Logique des effets (Command Pattern)
│   ├── DamageEffect.gd
│   ├── StatusEffect.gd
│   └── DrawCardEffect.gd
├── Enemies/
│   ├── Base/               # EnemyBase.tscn + EnemyAI.gd (Intentions)
│   └── Variations/         # Slime, Goblin, FireDreams (Scènes héritées)
├── Relics/                 # Objets passifs (Artifacts)
│   ├── Data/               # Ressources des reliques
│   └── Icons/
├── Scenes/                 # Scènes principales
│   ├── Battle/             # La scène de combat
│   ├── Map/                # La carte de navigation (nœuds, chemins)
│   ├── Events/             # Scènes narratives (feux de camp, choix)
│   └── Menus/
├── Systems/                # Logique pure (Managers)
│   ├── BattleSystem/       # TurnManager, EnemyManager
│   ├── CardSystem/         # DeckManager, DiscardPile, HandManager
│   └── MapSystem/          # Génération procédurale de la map
└── UI/
    ├── Tooltips/           # Info-bulles au survol
    ├── Intentions/         # Icônes au-dessus des ennemis
    └── HUD/                # Mana, HP, Deck view
```
