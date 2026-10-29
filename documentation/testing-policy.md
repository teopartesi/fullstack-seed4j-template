# Politique de tests et de qualité

La stratégie de test protège les comportements, les frontières d'architecture et les intégrations techniques sans dépendre
d'un domaine métier particulier.

## Principes

- tester les comportements observables plutôt que recopier l'implémentation ;
- ajouter un scénario de non-régression pour chaque correction de bug ;
- maîtriser l'horloge, les données, les graines aléatoires et la concurrence ;
- éviter les attentes arbitraires et les appels réseau réels dans la suite standard ;
- ne pas réduire un seuil, supprimer un test ou masquer un échec pour obtenir un résultat vert ;
- distinguer un outil configuré, un contrôle exécuté et un contrôle réussi.

## Commandes de référence

```bash
mise run backend:test
mise run backend:verify
mise run frontend:lint
mise run frontend:test
mise run frontend:build
mise run format:check
mise run check
```

Choisir les commandes proportionnellement au changement. Un changement transversal utilise `mise run check` avant
validation finale.

## Backend Java

Les tests unitaires se trouvent sous `backend/test/java`. Les tests d'intégration utilisent le suffixe `IT` et sont
exécutés par Maven Failsafe pendant `verify`.

Répartition recommandée :

| Couche               | Vérification principale                                                    |
| -------------------- | -------------------------------------------------------------------------- |
| Domaine              | Invariants, valeurs limites et erreurs, sans framework ni réseau           |
| Application          | Orchestration, autorisations, transactions et échecs des ports             |
| Adaptateurs entrants | Validation, statuts HTTP, sérialisation et absence de fuite d'informations |
| Adaptateurs sortants | Mappings, erreurs, concurrence et contrats avec les systèmes ciblés        |
| Architecture         | Sens des dépendances et respect des frontières de contextes                |

Les tests de persistance et de migrations utilisent le moteur réellement ciblé dans un environnement isolé. Une base
différente ne permet pas de conclure sur les contraintes ou la concurrence propres au moteur de production.

## Frontend Angular

Les tests vérifient les routes, les composants, les comportements et les états d'interface. Les parcours importants
couvrent également la navigation au clavier, les labels et les retours d'erreur pertinents.

Le lint, les tests et le build sont regroupés par `mise run frontend:check`. La couverture LCOV est produite sous le
répertoire `frontend/coverage/`.

Un pourcentage de couverture ne remplace pas les assertions de comportement, l'accessibilité ni les vérifications SSR.

## Couverture

Maven produit les rapports JaCoCo pendant `verify`. Les chemins et seuils configurés dans `pom.xml` constituent la source
exécutable de vérité.

Une source mesurable absente du rapport, un rapport manquant ou illisible et une suite interrompue constituent des erreurs,
jamais un succès ou un périmètre vide.

Toute exclusion de couverture est limitée au code réellement généré sans logique maintenue. Elle est précise, justifiée et
revue. Une règle métier, une autorisation ou une branche difficile à tester ne doit pas être exclue.

## Services externes

Les adaptateurs externes sont testés avec des réponses contrôlées couvrant succès, erreurs, pagination, données partielles
et changements de contrat pertinents. Aucun secret ni appel facturable n'est requis pour la suite standard.

Les validations distantes, comme un scan hébergé, sont distinguées des vérifications locales. Un statut ignoré, neutral ou
non calculé ne constitue pas une réussite.

## Intégration continue

La CI exécute au minimum le formatage, les tests, les builds et les contrôles de couverture configurés. Les analyses qui
nécessitent des secrets doivent rester sûres pour les contributions externes et signaler explicitement lorsqu'elles ne sont
pas exécutées.

Les contrôles de fusion réellement obligatoires sont vérifiés dans la configuration de la plateforme ; leur simple présence
dans un workflow ne prouve pas qu'ils bloquent une fusion.

## Preuves attendues

La restitution d'un changement précise :

- les commandes exécutées et leur résultat ;
- les tests ciblés ajoutés ou modifiés ;
- les rapports consultés ;
- les vérifications non exécutées et leur raison ;
- les risques restant à traiter.
