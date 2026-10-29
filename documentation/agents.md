# Profils Codex et coordination

Le dépôt fournit quatre profils spécialisés réutilisables. Ils complètent les règles communes décrites dans [`AGENTS.md`](../AGENTS.md).

## Profils disponibles

| Profil         | Responsabilité principale                                                 |
| -------------- | ------------------------------------------------------------------------- |
| `architecture` | Frontières des contextes, dépendances, ports et décisions d'architecture  |
| `backend`      | Domaine Java, cas d'usage, API, persistance et migrations                 |
| `frontend`     | Parcours Angular, accessibilité, intégration des API et tests d'interface |
| `quality`      | Revue indépendante, tests, couverture, scans, dépendances et CI           |

Les profils sont définis dans `.codex/agents/`.

## Activation

Activer uniquement les profils utiles au travail demandé. Une tâche documentaire ou une petite correction ne nécessite pas automatiquement tous les profils.

Chaque profil doit commencer par lire `AGENTS.md`, les documents applicables et les fichiers concernés.

La présence d'un profil ne lui donne pas l'autorisation de modifier tout le dépôt. Son périmètre reste limité au lot explicitement confié.

## Coordination

Le coordinateur définit pour chaque lot :

- son objectif ;
- les fichiers ou composants concernés ;
- les critères de validation ;
- les dépendances avec les autres lots.

Éviter que plusieurs intervenants modifient simultanément le même fichier. Lorsqu'une modification traverse plusieurs couches, convenir d'abord des contrats et des responsabilités.

Les décisions d'architecture, l'ajout d'une dépendance, l'utilisation d'un service externe et la modification d'un seuil de qualité nécessitent une validation explicite.

## Restitution

Chaque profil restitue :

- les fichiers examinés ou modifiés ;
- les choix effectués ;
- les comportements ou contrats couverts ;
- les commandes exécutées et leurs résultats ;
- les vérifications non exécutées ;
- les limites et risques restants.

Une réussite doit être appuyée par des preuves vérifiables. Un outil configuré mais non exécuté ne constitue pas un contrôle réussi.
