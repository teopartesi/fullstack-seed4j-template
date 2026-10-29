# Consignes des agents du template full-stack Seed4J

Communiquer en français, sauf demande contraire de l'utilisateur.

Avant toute modification, lire les instructions applicables, vérifier l'état Git et examiner le code concerné. Préserver les changements locaux existants et ne pas modifier un fichier sans comprendre son rôle.

Travailler dans le checkout courant du projet. Ne jamais utiliser un chemin absolu propre à une autre application. Ne pas créer de commit, pousser une branche, publier un dépôt ou modifier un service externe sans demande explicite.

## Références

- [Architecture du projet](documentation/architecture.md)
- [Variante hexagonale Seed4J](documentation/hexagonal-architecture.md)
- [Types de packages](documentation/package-types.md)
- [Assertions partagées](documentation/assertions.md)
- [Politique de tests et de qualité](documentation/testing-policy.md)

## Socle technique

Le dépôt fournit un socle full-stack exécutable comprenant un backend Java avec Spring Boot, un frontend Angular et les contrôles de qualité associés.

Avant d'utiliser une technologie ou un module, vérifier sa présence réelle dans les fichiers du projet. Ne pas supposer qu'une base de données, un fournisseur externe, une authentification ou un outil d'orchestration est déjà installé.

Conserver l'arborescence et les marqueurs Seed4J, sauf lorsqu'une tâche de maintenance du template demande explicitement leur adaptation.

## Architecture

Organiser les fonctionnalités par contexte métier avec les couches suivantes :

- `domain` : modèle, invariants et ports, sans dépendance à Spring, JPA, HTTP ou à un SDK externe ;
- `application` : orchestration des cas d'usage, transactions et autorisations ;
- `infrastructure/primary` : API, contrôleurs, DTO et adaptateurs entrants ;
- `infrastructure/secondary` : persistance, fournisseurs et adaptateurs sortants.

Utiliser `BusinessContext` pour identifier les contextes métier et `SharedKernel` uniquement pour les éléments réellement partagés.

Valider les entrées, les autorisations et la cohérence des données côté serveur. Ne jamais stocker de secret, jeton ou clé fournisseur dans le dépôt ou dans le frontend.

Le template ne doit contenir aucune règle métier appartenant à une application particulière.

## Travail et revue

Limiter chaque changement au périmètre demandé. Pour une modification importante, distinguer clairement :

- les fichiers modifiés ;
- les choix effectués ;
- les vérifications exécutées ;
- les vérifications non exécutées ;
- les limites ou risques restants.

Ne pas désactiver un test, un scan ou un contrôle de qualité pour obtenir un résultat vert. Distinguer un outil configuré, un contrôle exécuté et un contrôle effectivement réussi.

## Commandes du projet

Utiliser les versions et les tâches déclarées dans `mise.toml` :

```bash
mise run deps:install
mise run frontend:ci
mise run backend:test
mise run backend:verify
mise run frontend:check
mise run format:check
mise run check
```

Choisir les vérifications proportionnellement au changement :

- documentation : formatage, liens et cohérence des références ;
- backend : tests ciblés, puis vérification Maven ;
- frontend : lint, tests et build ;
- changement transversal : `mise run check`.

Ne jamais annoncer la réussite d'une commande qui n'a pas été exécutée jusqu'à son terme.
