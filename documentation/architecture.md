# Architecture du projet

Le template fournit un monolithe modulaire composé d'un backend Spring Boot et d'un frontend Angular. Il conserve les
conventions hexagonales générées par Seed4J sans imposer de domaine métier particulier.

## Organisation générale

```text
backend/       Sources et tests Java
frontend/      Application Angular, SSR et tests
documentation/ Conventions techniques
.github/       Automatisation GitHub
.seed4j/       Historique et marqueurs Seed4J
```

Le projet Maven reste piloté depuis la racine. Le frontend possède son propre manifeste npm et son propre lockfile.

## Backend

La classe Spring Boot située à la racine du package Java porte le démarrage et la découverte des composants.

Chaque contexte métier est organisé avec les couches suivantes :

- `domain` : modèle, invariants et ports ;
- `application` : orchestration des cas d'usage, transactions et autorisations ;
- `infrastructure/primary` : API, contrôleurs, DTO et autres adaptateurs entrants ;
- `infrastructure/secondary` : persistance, clients externes et autres adaptateurs sortants.

Le domaine reste indépendant de Spring, JPA, HTTP et des SDK externes. Les adaptateurs dépendent du cœur et de ses ports,
jamais l'inverse.

Les packages racines des contextes sont marqués avec `@BusinessContext`. Les éléments réellement partagés utilisent
`@SharedKernel`. Ces annotations documentent les frontières ; des tests d'architecture peuvent compléter leur contrôle.

## Échanges entre contextes

Un contexte ne doit pas importer directement le modèle interne d'un autre contexte. Le contexte consommateur définit un
port minimal ; un adaptateur traduit ensuite ce contrat vers le contexte propriétaire.

Les échanges portent sur des identifiants stables et de petits contrats immuables. Le câblage technique compose les
implémentations sans introduire de dépendance entre les domaines.

## Frontend

Le frontend utilise des composants standalone, un routage explicite, le rendu serveur et l'hydratation côté navigateur.
Les composants d'interface ne constituent pas une frontière de sécurité : le backend valide toujours les entrées, les
droits et les invariants.

Les contrats d'API sont définis avec le backend avant leur intégration. Les états de chargement, d'erreur, d'absence de
données et d'indisponibilité font partie du comportement attendu de l'interface.

## Persistance et services externes

Le template ne suppose pas qu'un moteur de base de données, une authentification ou un fournisseur externe est installé.
Lorsqu'un module est ajouté, il reste derrière un port du cœur et sa configuration sensible provient de l'environnement.

Les migrations sont testées sur le moteur réellement ciblé. Les appels réseau réels ne font pas partie de la suite de
tests standard ; utiliser des réponses contrôlées pour les tests de contrat.

## Sécurité

- valider les entrées et les autorisations côté serveur ;
- ne jamais accepter un identifiant transmis par le navigateur comme preuve d'identité ;
- ne pas exposer de secret ou de jeton dans le frontend ;
- éviter de divulguer les messages internes et les traces dans les réponses HTTP ;
- conserver les dépendances entre couches orientées vers le domaine.

## Validation d'un changement

Une modification d'architecture décrit les frontières touchées, les contrats introduits et les conséquences sur les
transactions, les autorisations et la concurrence. Elle est accompagnée de tests adaptés ou d'une vérification manuelle
explicitement documentée lorsqu'aucun contrôle automatisé n'existe.
