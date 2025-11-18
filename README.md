Ce dépôt contient une architecture pensée pour un Rogue-like Deckbuilder (inspiré de Slay the Spire / Balatro).

Principes clefs :

- Séparer strictement la Donnée (Resources) de la Vue (Scenes/UI).
- Utiliser des Custom Resources (.tres) pour décrire les cartes, reliques et effets.
- Construire une Machine à États pour piloter le combat (TurnManager).

Structure de fichiers :

```
res://
├── _Autoloads/
│   ├── Events.gd           # SignalBus (découplage total)
│   ├── GameManager.gd      # État global de l'application
│   └── RunManager.gd       # Gère la run actuelle (PV, Deck actuel, Étage, Seed)
├── Assets/
│   ├── Art/                # Sprites des cartes, icônes, ennemis
│   └── DataTables/         # CSV ou JSON (import de données)
├── Cards/                  # Tout ce qui concerne les cartes
│   ├── Base/               # Scripts de base (CardUI.gd, CardData.gd)
│   ├── Data/               # Les RESSOURCES (.tres) : Strike.tres, Defend.tres...
│   ├── Scenes/             # La scène visuelle de la carte (CardTemplate.tscn)
│   └── Scripts/            # Logiques spécifiques (Targeting, Dragging)
├── Effects/                # Logique des effets (Command Pattern)
│   ├── DamageEffect.gd
│   ├── StatusEffect.gd
│   └── DrawCardEffect.gd
├── Enemies/
│   ├── Base/               # EnemyBase.tscn + EnemyAI.gd (Intentions)
│   └── Variations/         # Slime, Goblin, etc. (scènes héritées)
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

Les 3 piliers (rappel rapide)

- Cards/Data : les cartes sont des Resources (.tres) — pas des scènes. Un script `CardData` hérite de `Resource` et contient : id, name, mana_cost, description, target_type, effets (liste de resources Effect).
- Systems/BattleSystem : une machine à états pour piloter StartTurn -> PlayerTurn -> Resolution -> EnemyTurn -> EndTurn.
- Effects : petits modules réutilisables (DamageEffect, DrawEffect, ApplyStatus) assemblés dans les Resources de carte.

Feuille de route et découpage par étapes (avec tâches parallélisables)

Étape 1 — Conception & Prototype

- Objectif : valider la vision, créer assets minimaux et prototype jouable d'un tour.
- Sous-tâches (parallélisables) :
  - Designer : définir mécaniques principales (mana, coût, deck size, rares)
  - Dev A : écrire `CardData` Resource et loader simple (.tres)
  - Dev B : prototype TurnManager minimal (StartTurn/PlayerTurn/EnemyTurn)
  - Artist : fournir placeholders pour 6 cartes et 2 ennemis
  - QA / Playtest : sessions rapides pour vérifier la boucle de base

Étape 2 — Data & Effects

- Objectif : modèles de données robustes et effets modulaires.
- Sous-tâches (parallélisables) :
  - Dev A : implémenter `Effect` base class et `DamageEffect`, `DrawEffect`, `BlockEffect`
  - Dev B : créer exemples `.tres` pour 10 cartes basiques (Strike, Defend, etc.)
  - Scripter : définir format des fichiers DataTables si besoin (CSV/JSON import)
  - Artist : icônes pour cartes (placeholder → final)

Étape 3 — Card System (Deck/Hand/Draw/Discard)

- Objectif : comportements de deck reproductibles (shuffling, draw, reshuffle).
- Sous-tâches (parallélisables) :
  - Dev A : DeckManager (shuffle, draw N, reshuffle)
  - Dev B : HandManager + CardUI (drag/play/hover tooltip)
  - Dev C : DiscardPile, ExhaustPile
  - QA : tests unitaires pour shuffle/draw edge cases

Étape 4 — Battle System complet

- Objectif : état de combat complet, intentions ennemies et résolution d'effets.
- Sous-tâches (parallélisables) :
  - Dev A : TurnManager (états + transitions + coroutines/timers)
  - Dev B : EnemyManager + Intentions (AI simple, icônes d'intention)
  - Dev C : Effect resolution pipeline (ordre, timing, réactions)
  - Designer : créer 6 rencontres/combinaisons d'ennemis

Étape 5 — Scènes & UI

- Objectif : intégration des cartes dans l'UI, HUD, feedback visuel.
- Sous-tâches (parallélisables) :
  - Frontend : CardTemplate.tscn, animations d'usage, retour critique (hit numbers)
  - UX : tooltips, intentions au-dessus des ennemis, log de combat
  - Artist : finaliser visuels des cartes et icônes

Étape 6 — Map, Events, Relics

- Objectif : ajouter progression meta (carte, événements, reliques).
- Sous-tâches (parallélisables) :
  - Dev A : MapSystem (générateur simple de nœuds)
  - Dev B : Relic Resources + effets passifs
  - Narrative : écrire templates d'événements (choix, feu de camp)

Étape 7 — Tests, équilibrage, polish

- Objectif : corriger bugs, équilibrer cartes, ajouter SFX/particles.
- Sous-tâches :
  - QA : tests unitaires + scénarios automatisés (seed reproducibility)
  - Designer : équilibrage et métriques
  - Dev : perf optimisations, mem leaks

Checklist de livraison pour chaque étape

- Code : tests unitaires pour fonctions critiques (shuffle, draw, applyDamage)
- Data : exemples `.tres` et CSV import validation
- UX : interactions testées (drag/drop, play card)
- Perf : pas de GC spikes majeurs lors d'un tour
