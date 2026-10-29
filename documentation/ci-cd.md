# Intégration continue

Le workflow `.github/workflows/ci.yml` s'exécute sur les push vers `main`, les pull requests, les lancements manuels et les
appels comme workflow réutilisable.

## Contrôles toujours exécutés

- formatage du dépôt ;
- lint, tests, couverture et build du frontend ;
- compilation, tests, Checkstyle et couverture du backend ;
- publication temporaire des rapports et artefacts nécessaires à l'analyse.

Ces contrôles ne nécessitent aucun secret externe.

## Sonar optionnel

L'analyse Sonar est désactivée par défaut afin qu'un dépôt créé depuis le template dispose immédiatement d'une CI
fonctionnelle.

Lorsqu'elle est désactivée, le job `Sonar` vérifie tout de même la présence des rapports produits par les builds, puis
ajoute un avertissement et un résumé indiquant que le Quality Gate n'a pas été exécuté.

Pour activer SonarQube Cloud :

1. Créer le projet dans SonarQube Cloud.
2. Désactiver l'analyse automatique du projet afin de ne pas analyser deux fois le même commit.
3. Dans les secrets GitHub Actions du dépôt, créer `SONAR_TOKEN`.
4. Dans les variables GitHub Actions, créer `SONAR_ORGANIZATION` avec la clé de l'organisation.
5. Créer `SONAR_PROJECT_KEY` avec la clé exacte du projet.
6. Créer `SONAR_CI_ENABLED` avec la valeur `true`.

Si `SONAR_CI_ENABLED` vaut `true` mais qu'une autre valeur manque, le workflow échoue explicitement. Une configuration
incomplète ne doit pas être présentée comme une analyse réussie.

Les secrets et variables GitHub ne sont pas copiés lorsqu'un nouveau dépôt est créé depuis un template. Cette configuration
doit donc être répétée pour chaque dépôt qui active Sonar.

## Contributions externes

Les pull requests provenant d'un fork et les exécutions Dependabot ne lancent pas Sonar, car elles ne doivent pas recevoir
le secret. Les builds et tests restent exécutés.

Le workflow n'utilise pas `pull_request_target`. Ne pas ajouter cet événement pour donner accès aux secrets à du code non
approuvé.

## Interprétation des résultats

Un build réussi ne prouve pas qu'un Quality Gate Sonar a été calculé. Vérifier séparément :

- les jobs de build et de tests ;
- l'étape d'analyse Sonar lorsqu'elle est activée ;
- le Quality Gate associé au commit ou à la pull request ;
- les contrôles réellement requis par les règles de fusion GitHub.
