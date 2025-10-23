# Configuration des seuils d'étoiles

Ce document explique comment modifier les seuils d'étoiles pour chaque niveau du jeu Angry Dragon.

## Fichier de configuration

Le fichier `star_thresholds.json` à la racine du projet contient les seuils pour obtenir 2 ou 3 étoiles sur chaque niveau.

## Format du fichier

```json
{
  "levels": {
    "1": {
      "three_stars": 3,
      "two_stars": 5,
      "description": "Level 1 - Tutorial level"
    }
  }
}
```

### Explication des champs

- **`three_stars`** : Nombre maximum de tentatives pour obtenir 3 étoiles ⭐⭐⭐
- **`two_stars`** : Nombre maximum de tentatives pour obtenir 2 étoiles ⭐⭐☆
- **`description`** : Description optionnelle du niveau (ignorée par le jeu)

### Logique de calcul

- Si `tentatives <= three_stars` → 3 étoiles ⭐⭐⭐
- Si `tentatives <= two_stars` → 2 étoiles ⭐⭐☆
- Sinon → 1 étoile ⭐☆☆

## Comment modifier les seuils

### Méthode 1 : Éditer directement dans Godot

1. Dans Godot, ouvre le fichier `star_thresholds.json` dans l'éditeur de script
2. Modifie les valeurs `three_stars` et `two_stars`
3. Sauvegarde le fichier (Ctrl+S)
4. Redémarre le jeu pour que les changements prennent effet

### Méthode 2 : Éditer avec un éditeur de texte externe

1. Ouvre `star_thresholds.json` avec n'importe quel éditeur de texte (VS Code, Notepad++, etc.)
2. Modifie les valeurs
3. Sauvegarde
4. Redémarre le jeu dans Godot

## Exemples de configuration

### Niveau facile (beaucoup de tentatives autorisées)
```json
"1": {
  "three_stars": 10,
  "two_stars": 15,
  "description": "Niveau très facile"
}
```

### Niveau difficile (peu de tentatives autorisées)
```json
"5": {
  "three_stars": 3,
  "two_stars": 5,
  "description": "Niveau expert - très difficile"
}
```

## Ajouter de nouveaux niveaux

Pour ajouter les seuils d'un nouveau niveau (par exemple niveau 6) :

```json
"6": {
  "three_stars": 8,
  "two_stars": 13,
  "description": "Level 6 - New level"
}
```

## Fallback / Valeurs par défaut

Si le fichier `star_thresholds.json` est manquant ou corrompu, le jeu utilisera automatiquement les valeurs par défaut codées dans `Singletons/game_manager.gd` :

- Niveau 1: 3★ si ≤3 | 2★ si ≤5
- Niveau 2: 3★ si ≤4 | 2★ si ≤6
- Niveau 3: 3★ si ≤5 | 2★ si ≤8
- Niveau 4: 3★ si ≤6 | 2★ si ≤10
- Niveau 5: 3★ si ≤7 | 2★ si ≤12

## Vérification et débogage

Lors du démarrage du jeu, Godot affichera dans la console :
- ✅ `"Star thresholds loaded from config file: {1: [3, 5], 2: [4, 6], ...}"` si le chargement réussit
- ⚠️ `"Star thresholds config not found, using defaults"` si le fichier est manquant
- ⚠️ `"Failed to parse star thresholds JSON, using defaults"` si le JSON est invalide

Vérifie la fenêtre "Output" de Godot pour voir ces messages.

## Conseils de game design

Pour équilibrer ton jeu, voici quelques recommandations :

1. **Progression de difficulté** : Les niveaux plus avancés devraient avoir des seuils plus élevés
2. **Playtesting** : Joue tes niveaux plusieurs fois pour trouver un nombre "raisonnable" de tentatives
3. **Règle générale** :
   - 3 étoiles = performance excellente (top 10% des joueurs)
   - 2 étoiles = performance correcte (50% des joueurs)
   - 1 étoile = niveau complété (tous les joueurs)

## Fichiers concernés

Si tu veux modifier le système en profondeur :
- `star_thresholds.json` - Configuration des seuils
- `Singletons/game_manager.gd` - Chargement et logique des étoiles
- `Singletons/score_manager.gd` - Sauvegarde des étoiles obtenues
- `game_ui/game_ui.gd` - Affichage des étoiles à la fin du niveau
- `levelbutton/level_button.gd` - Affichage des étoiles sur les boutons de niveau
