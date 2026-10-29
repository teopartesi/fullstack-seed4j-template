# Frontend du template

Application Angular 22 standalone avec routage, SSR, hydratation, Tailwind CSS 4 et SCSS. Le frontend fournit uniquement
un socle technique et ne contient aucune fonctionnalité métier propre à une application particulière.

Les commandes se lancent depuis la racine du dépôt :

```bash
mise run frontend:ci
mise run frontend:run
mise run frontend:lint
mise run frontend:test
mise run frontend:build
mise run frontend:check
```

Le serveur de développement est disponible sur `http://localhost:4200`.

Après un build, lancer le bundle SSR avec :

```bash
mise exec -- npm run serve:ssr --prefix frontend
```

Le rapport LCOV est écrit sous `frontend/coverage/`. Le nom de son sous-répertoire suit le nom technique du workspace
Angular.
