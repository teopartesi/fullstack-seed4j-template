# Full-stack Seed4J template

Socle réutilisable pour démarrer une application avec un backend Java/Spring Boot et un frontend Angular. Le dépôt fournit
une architecture hexagonale, les tests, le formatage et une intégration continue de base, sans fonctionnalité métier propre
à une application particulière.

## Composition

- backend Java 25 et Spring Boot sous `backend/` ;
- frontend Angular 22 standalone avec SSR et hydratation sous `frontend/` ;
- styles Tailwind CSS 4 et SCSS ;
- tests Java, tests Angular, JaCoCo et couverture LCOV ;
- Maven Wrapper, npm et versions d'outils pilotées par `mise` ;
- GitHub Actions et Dependabot.

Une base de données, une authentification ou une intégration externe ne doivent être considérées comme disponibles que
lorsque leurs modules et leurs configurations sont réellement présents.

## Prérequis

Installer [mise](https://mise.jdx.dev/), puis approuver et installer les versions déclarées dans `mise.toml` :

```bash
mise trust
mise install
```

Le Maven Wrapper est fourni : aucune installation globale de Maven n'est nécessaire.

## Créer un nouveau projet

Après activation du mode template sur GitHub, créer un dépôt indépendant puis exécuter l’initialiseur :

```bash
gh repo create teopartesi/musicquiz \
  --template teopartesi/fullstack-seed4j-template \
  --private \
  --clone

cd musicquiz
./scripts/init-project.sh musicquiz fr.teopartesi.musicquiz "Music Quiz" MusicQuiz
```

La procédure complète est décrite dans [Créer un projet depuis le template](documentation/getting-started.md).

## Installation

Depuis la racine du dépôt :

```bash
mise run deps:clean_install
mise run frontend:ci
```

## Vérifications

```bash
mise run backend:test
mise run backend:verify
mise run frontend:lint
mise run frontend:test
mise run frontend:build
mise run format:check
mise run check
```

`mise run check` regroupe le formatage, la vérification Maven et les contrôles du frontend.

## Démarrage local

Démarrer le backend avec le profil local :

```bash
mise run backend:run
```

Le serveur écoute par défaut sur `127.0.0.1:8080`. Vérifier sa santé avec :

```bash
curl -i http://localhost:8080/actuator/health
```

Dans un autre terminal, démarrer le frontend :

```bash
mise run frontend:run
```

Le serveur de développement Angular est disponible sur `http://localhost:4200`.

Pour construire et exécuter le bundle SSR :

```bash
mise run frontend:build
mise exec -- npm run serve:ssr --prefix frontend
```

Le serveur SSR utilise par défaut `http://localhost:4000`.

<!-- seed4j-needle-localEnvironment -->

<!-- seed4j-needle-startupCommand -->

## Documentation

- [Architecture du projet](documentation/architecture.md)
- [Variante hexagonale Seed4J](documentation/hexagonal-architecture.md)
- [Types de packages](documentation/package-types.md)
- [Assertions partagées](documentation/assertions.md)
- [Politique de tests et de qualité](documentation/testing-policy.md)
- [Intégration continue et Sonar optionnel](documentation/ci-cd.md)
- [Consignes communes des agents](AGENTS.md)
- [Créer un projet depuis le template](documentation/getting-started.md)
- [Maintenance du template](documentation/template-maintenance.md)
- [Profils Codex](documentation/agents.md)

<!-- seed4j-needle-documentation -->
